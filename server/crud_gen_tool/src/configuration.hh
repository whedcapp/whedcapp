/*
    This File Is Part Of Whedcapp - Well-Being Health Environment Data Collection App - to collect self-evaluated data for research purpose
    Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

    Whedcapp is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Whedcapp is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.
*/
#ifndef CONFIGURATION_HH
#define CONFIGURATION_HH

#include <bitset>
#include <iostream>
#include <map>
#include <memory>
#include <regex>
#include <set>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

#include "common.hh"
#include "reference.hh"
#include "json.hpp"

namespace PartSqlCrudGen {

  class IConfiguration;

  class ConfigurationException: public std::exception {
    std::string whatText;
  public:
    ConfigurationException(const std::string& whatText) noexcept;
    ConfigurationException(const ConfigurationException& e) noexcept;
    ~ConfigurationException();
    const char* what() const noexcept;
  };


  class ConfigurationItem {
    IConfiguration& iConfiguration;
  public:
    ConfigurationItem(IConfiguration& iConfiguration): iConfiguration(iConfiguration) {}
    IConfiguration& getIConfiguration() const {
      return iConfiguration;
    }
  };

  class Role: public ConfigurationItem {
    std::string name;
    int priority;
  public:
    Role(IConfiguration& iConfiguration,const std::string& name,int priority): ConfigurationItem(iConfiguration),name(name),priority(priority) {}
    inline const std::string& getName() const {
      return name;
    }
    inline int getPriority() const {
      return priority;
    }
  };

  inline bool operator<(const Role& rhs,const Role& lhs) {
    return (rhs.getPriority()<lhs.getPriority()|| (!(rhs.getPriority()>lhs.getPriority()) && rhs.getName()<lhs.getName()));
  }

  class Access: public ConfigurationItem {
  public:
    enum Type { writeOther=0x0,writeSelf=0x4,readOther=0x8,readSelf=0xc};
    static constexpr std::initializer_list<Type> allType = { writeOther,writeSelf,readOther,readSelf};
  private:
    static const std::map<Access::Type,std::string> accessType2string;
    static const std::map<std::string,Access::Type> string2AccessType;
    std::bitset<4> rights;
  public:
    Access(IConfiguration& iConfiguration): ConfigurationItem(iConfiguration),rights(0) {}
    Access(IConfiguration& iConfiguration,const Type type): ConfigurationItem(iConfiguration),rights(type) {}
    Access(IConfiguration& iConfiguration,const std::vector<Type>& vecOfType);
    Access(IConfiguration& iConfiguration,const Access& access): ConfigurationItem(iConfiguration),rights(access.rights) {}
    bool access(const Type type) {
      return rights.test(type);
    }
    std::unique_ptr<std::vector<Type>> getRights(); 
      
    static const Type getTypeFromString(const std::string& str)  {
      return string2AccessType.at(str);
    }
    static const std::string& getStringFromType(const Type& type) {
      return accessType2string.at(type);
    }
  };

  inline std::ostream& operator << (std::ostream& strm, const Access::Type& type) {
    const auto str = Access::getStringFromType(type);
    strm << str;
    return strm;
  }

  class OutputLanguage: public ConfigurationItem {
  public:
    enum Type { Sql, Dart, Proto };
    static constexpr std::initializer_list<Type> allType = { Sql, Dart, Proto};
  private:
    const static std::map<std::string,Type,CaselessLessThan> string2outputLanguageType;
    const static std::map<Type,std::string> outputLanguageType2string;
    Type type;
  public:
    OutputLanguage(IConfiguration& iConfiguration,Type type): ConfigurationItem(iConfiguration),type(type) {};
    OutputLanguage(IConfiguration& iConfiguration,const OutputLanguage& ol): ConfigurationItem(iConfiguration),type(ol.type) {};
    const static std::string& getStringFromType(Type type) {
      return outputLanguageType2string.at(type);
    }
    const static Type getTypeFromString(const std::string& str) {
      return string2outputLanguageType.at(str);
    }
    const Type& getType() {
      return type;
    }
  };
  inline std::ostream& operator << (std::ostream& strm, const OutputLanguage::Type& type) {
    const auto str = OutputLanguage::getStringFromType(type);
    strm << str;
    return strm;
  }

  class DatabaseOperation: public ConfigurationItem {
  public:
    enum Type { dbInsert=0x0, dbUpdate=0x1, dbDelete=0x2, dbSelect=0x3 };
    static constexpr std::initializer_list<Type> allType = { dbInsert,dbUpdate,dbDelete, dbSelect };
  private:
    Type type;
    const static std::map<std::string,Type,CaselessLessThan> string2dbOpType;
    const static std::map<Type,std::string> dbOpType2string;
  public:
    DatabaseOperation(IConfiguration& iConfiguration,const Type& type): ConfigurationItem(iConfiguration),type(type) {}
    const static std::string& getStringFromType(Type type) {
      return dbOpType2string.at(type);
    }
    inline const static Type getTypeFromString(const std::string& str)  {
      return string2dbOpType.at(str);
    }
    inline const Type& getType() const {
      return type;
    }
    inline static bool exists(const std::string& key)  {
      decltype(string2dbOpType)::const_iterator it = string2dbOpType.find(key);
      return  it != string2dbOpType.end();
    }
    static bool compatibleAccessType(DatabaseOperation::Type dt, Access::Type at) {
      return
        ((at == Access::Type::writeSelf || at == Access::Type::writeOther) && (dt == dbInsert || dt == dbUpdate || dt == dbDelete)) ||
        ((at == Access::Type::readSelf || at == Access::Type::readOther) &&
         (dt == dbSelect));
    }
  };

  inline std::ostream& operator << (std::ostream& strm, const DatabaseOperation::Type& type) {
    const auto str = DatabaseOperation::getStringFromType(type);
    strm << str;
    return strm;
  }

  
  class ContextParameter: public ConfigurationItem {
  public:
    class CtxtParSpec {
      Reference reference;
      bool accessControl;
      bool context;
    public:
      CtxtParSpec(const Reference& reference, bool accessControl, bool context): reference(reference), accessControl(accessControl), context(context) {}
      const Reference& getReference() const {
        return reference;
      }
      const bool getAccessControl() const {
        return accessControl;
      }
      const bool getContext() const {
        return context;
      }
    };
  private:
    std::vector<std::pair<std::string,CtxtParSpec>> vecOfPar2Ref;
    nlohmann::json contextParameter;
  public:
    ContextParameter(IConfiguration& iConfiguration,nlohmann::json& contextParameter);
    ContextParameter(IConfiguration& iConfiguration,const ContextParameter& contextParameter): ConfigurationItem(iConfiguration),contextParameter(contextParameter.contextParameter),vecOfPar2Ref(contextParameter.vecOfPar2Ref) {};
    ContextParameter(IConfiguration& iConfiguration,const ContextParameter&& contextParameter): ConfigurationItem(iConfiguration),contextParameter(std::move(contextParameter.contextParameter)),vecOfPar2Ref(std::move(contextParameter.vecOfPar2Ref)) {};

    const nlohmann::json& getContextParameterAsJson() const {
      return contextParameter;
    };
    const decltype(vecOfPar2Ref)& getVecOfPar2Ref() const {
      return  vecOfPar2Ref;
    }
    const decltype(vecOfPar2Ref)& getVecOfPar2CtxtSpec() const {
      return vecOfPar2Ref;
    }
  };


  
  



    
  class CheckContext: public ConfigurationItem {
    std::string checkContext;
  public:
    CheckContext(IConfiguration& iConfiguration,const std::string& checkContext);
    const std::string& getCheckContext() const {
      return checkContext;
    }
  };
    
    
  class TabCfgTemplate: public ConfigurationItem {
    std::string name;
    nlohmann::json tabCfgTemplate;
    std::multimap<std::string,Access::Type> r2a;
  public:
    TabCfgTemplate(IConfiguration& iConfiguration,const std::string& name,const nlohmann::json& tabCfgTemplate);
    const std::string& getName() const {
      return name;
    }
    const std::pair<decltype(r2a)::const_iterator,decltype(r2a)::const_iterator> getAcl(const std::string& key) const {
      return r2a.equal_range(key);
    }
  
  };

  class TableSpec: public ConfigurationItem {
    std::string tableName;
    std::map<DatabaseOperation::Type,TabCfgTemplate> op2tct;
    int eidBase;
    std::string acronym;
    bool hasKeyAttr = false;
  public:
    TableSpec(IConfiguration& iConfiguration, const std::string& tableName,nlohmann::json jsonTableSpec);
    const std::string& getTableName() const {
      return tableName;
    }
    TableSpec(IConfiguration& iConfiguration, const TableSpec&& tableSpec): ConfigurationItem(iConfiguration), tableName(std::move(tableSpec.tableName)),op2tct(std::move(tableSpec.op2tct)) {}
    const TabCfgTemplate& getTabCfgTemplate(const DatabaseOperation::Type& operation) const {
      return op2tct.at(operation);
    }
    inline int getEidBase() const {
      return eidBase;
    }
    inline const std::string& getAcronym() const {
      return acronym;
    }
    inline const bool hasKeyAttribute() const {
      return hasKeyAttr;
    }
  };

  class ProcessingStep: public ConfigurationItem {
  public:
    enum Phase {declaration,preProcessing,postProcessing};
  private:
    Phase phase;
    int step;
    std::string tablePattern;
    std::string operationPattern;
    std::string domainPattern;
    std::string instruction;
    std::map<std::string,std::regex> s2r;
  public:
    ProcessingStep(IConfiguration& iConfiguration,
                   const Phase& phase,
                   const int& step,
                   const std::string& tablePattern,
                   const std::string& operationPattern,
                   const std::string& domainPattern,
                   const std::string& instruction):
      ConfigurationItem(iConfiguration),
      phase(phase),
      step(step),
      tablePattern(tablePattern),
      operationPattern(operationPattern),
      domainPattern(domainPattern),
      instruction(instruction),
      s2r {
        {tablePattern,std::regex(tablePattern)},
        {operationPattern,std::regex(operationPattern)},
        {domainPattern,std::regex(domainPattern)}
      } {}
    ProcessingStep(const ProcessingStep& processingStep):
      ConfigurationItem(processingStep.getIConfiguration()),
      phase(processingStep.phase),
      step(processingStep.step),
      tablePattern(processingStep.tablePattern),
      operationPattern(processingStep.operationPattern),
      domainPattern(processingStep.domainPattern),
      instruction(processingStep.instruction),
      s2r {
        {tablePattern,std::regex(tablePattern)},
        {operationPattern,std::regex(operationPattern)},
        {domainPattern,std::regex(domainPattern)}
      } {}
    inline const Phase getPhase() const {
      return phase;
    }
    inline const int getStep() const {
      return step;
    }
    inline const std::string& getTablePattern() const {
      return tablePattern;
    }
    inline const std::string& getOperationPattern() const {
      return operationPattern;
    }
    inline const std::string& getDomainPattern() const {
      return domainPattern;
    }
    
    inline const std::string& getInstruction() const {
      return instruction;
    }
    inline const std::regex& getTableRegex() const {
      return s2r.at(tablePattern);
    }
    inline const std::regex& getDomainRegex() const {
      return s2r.at(domainPattern);
    }
    inline const std::regex& getOperationRegex() const {
      return s2r.at(operationPattern);
    }

  };

  inline bool operator<(const ProcessingStep& lhs, const ProcessingStep& rhs) {
    return (lhs.getTablePattern()<rhs.getTablePattern()) ||
                                 ((!(lhs.getTablePattern()>rhs.getTablePattern()) && lhs.getDomainPattern() < rhs.getDomainPattern()) ||
                                  (!(lhs.getDomainPattern()>rhs.getDomainPattern()) && lhs.getOperationPattern()<rhs.getOperationPattern()));
  }

  class Processing: public ConfigurationItem {
  private:
    std::map<ProcessingStep::Phase,std::map<int,std::set<ProcessingStep>>> phase2Step2SetOfPPS;
  public:
    Processing(IConfiguration& iConfiguration): ConfigurationItem(iConfiguration) {}
    Processing(const Processing& processing): ConfigurationItem(processing.getIConfiguration()) {}
    void addProcessingStep(const ProcessingStep processingStep);
    inline const auto& getPhase2Step2SetOfProcessingStep() const {
      return phase2Step2SetOfPPS;
    }
  };


  class IConfiguration {
  public:
    virtual void add(const nlohmann::json& jsonCfg)=0;
    virtual void addRole(const Role& role)=0;
    virtual const std::set<Role>& getRoleSet() const = 0;
    virtual bool isRole(const std::string& roleDesc) const = 0;
    virtual const ContextParameter& getContextParameter(const OutputLanguage::Type& oltp, const Access::Type& attp, const std::string& templ) const = 0;
    virtual const CheckContext& getCheckContext(const Access::Type& atp,const std::string& key) const = 0;
    virtual const TabCfgTemplate& getTabCfgTemplate(const std::string& key) const = 0;
    virtual const TableSpec& getTableSpec(const std::string& key) const = 0;
    virtual const Processing& getProcessing() const = 0;

  };

  class Configuration: public IConfiguration {
    std::set<Role> roleSet;
    std::map<OutputLanguage::Type,std::map<Access::Type,std::map<std::string,ContextParameter>>> ol2at2te2cp;
    std::map<std::string,ContextParameter> key2cp;
    //std::map<std::string,CheckContext> key2cc;
    std::map<Access::Type,std::map<std::string,CheckContext>> at2key2cc;
    std::map<std::string,TabCfgTemplate> key2tct;
    std::map<std::string,TableSpec,CaselessLessThan> key2ts;
    Processing processing;
    void addRoleSet(const nlohmann::json& jsonCfg);
    void addContextParameters(const nlohmann::json& jsonCfg);
    void addCheckContext(const nlohmann::json& jsonCfg);
    void addTabCfgTemplate(const nlohmann::json& jsonCfg);
    void addTableSpec(const nlohmann::json& jsonCfg);
    void addProcessing(const nlohmann::json& jsonCfg);
  public:
    Configuration(): processing(*this) {}
    Configuration(nlohmann::json jsonCfg);
    void add(const nlohmann::json& jsonCfg);
    void addRole(const Role& role);
    const std::set<Role>& getRoleSet() const;
    bool isRole(const std::string& roleDesc) const;
    const ContextParameter& getContextParameter(const OutputLanguage::Type& oltp, const Access::Type& attp, const std::string& templ) const;
    const CheckContext& getCheckContext(const Access::Type& atp,const std::string& key) const;
    const TabCfgTemplate& getTabCfgTemplate(const std::string& key) const;
    const TableSpec& getTableSpec(const std::string& key) const;
    const Processing& getProcessing() const;
  };

}  

#endif
