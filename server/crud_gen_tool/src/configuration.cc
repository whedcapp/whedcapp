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
#include <cassert>

#include <iostream>
#include <map>
#include <stdexcept>
#include <vector>
#include "configuration.hh"

namespace PartSqlCrudGen {

  ConfigurationException::ConfigurationException(const std::string& whatText) noexcept: whatText(whatText),std::exception() {}
  ConfigurationException::ConfigurationException(const ConfigurationException& e) noexcept: whatText(e.what()),std::exception(e) {}
  ConfigurationException::~ConfigurationException() {}

  const char* ConfigurationException::what() const noexcept {
    return whatText.c_str();
  }

  Access::Access(IConfiguration& iConfiguration,const std::vector<Access::Type>& vecOfType): ConfigurationItem(iConfiguration),rights(0) {
    for (auto& t: vecOfType) {
      rights.set(t);
    }
  }


  const std::map<Access::Type,std::string> Access::accessType2string = {
    std::make_pair(Access::Type::writeOther,"writeOther"),
    std::make_pair(Access::Type::writeSelf,"writeSelf"),
    std::make_pair(Access::Type::readOther,"readOther"),
    std::make_pair(Access::Type::readSelf,"readSelf")
  };
  const std::map<std::string,Access::Type> Access::string2AccessType = {
    std::make_pair("writeOther",Access::Type::writeOther),
    std::make_pair("writeSelf",Access::Type::writeSelf),
    std::make_pair("readOther",Access::Type::readOther),
    std::make_pair("readSelf",Access::Type::readSelf)
  };

  std::unique_ptr<std::vector<Access::Type>> Access::getRights() {
    std::unique_ptr<std::vector<Type>> tmp = std::make_unique<std::vector<Type>>();
    for (auto& p: accessType2string) {
      if (rights.test(p.first)) {
        tmp->push_back(p.first);
      }
    }
    return tmp;
  }

  const std::map<std::string,OutputLanguage::Type,CaselessLessThan> OutputLanguage::string2outputLanguageType = {
    std::make_pair("SQL",OutputLanguage::Type::Sql),
    std::make_pair("Dart",OutputLanguage::Type::Dart)
  };
  const  std::map<OutputLanguage::Type,std::string> OutputLanguage::outputLanguageType2string = {
    std::make_pair(OutputLanguage::Type::Sql,"SQL"),
    std::make_pair(OutputLanguage::Type::Dart,"Dart")
  };

  const  std::map<std::string,DatabaseOperation::Type,CaselessLessThan> DatabaseOperation::string2dbOpType = {
    std::make_pair("insert",DatabaseOperation::Type::dbInsert),
    std::make_pair("update",DatabaseOperation::Type::dbUpdate),
    std::make_pair("delete",DatabaseOperation::Type::dbDelete),
    std::make_pair("select",DatabaseOperation::Type::dbSelect)
  };
  const  std::map<DatabaseOperation::Type,std::string> DatabaseOperation::dbOpType2string = {
    std::make_pair(DatabaseOperation::Type::dbInsert,"insert"),
    std::make_pair(DatabaseOperation::Type::dbUpdate,"update"),
    std::make_pair(DatabaseOperation::Type::dbDelete,"delete"),
    std::make_pair(DatabaseOperation::Type::dbSelect,"select")
  };

  

  static bool checkSyntax(const std::string& str,const std::vector<std::regex>& vecOfRegex) {
    std::string::const_iterator cur = str.cbegin();
    std::smatch match;
    int i=0;
    for (auto& re:vecOfRegex) {
      if (!regex_search(cur,str.cend(),match,re)) {
        return false;
      }
      cur += match.length(0);
      ++i;
    }
    return true;
  }



  CheckContext::CheckContext(IConfiguration& iConfiguration,const std::string& checkContext): ConfigurationItem(iConfiguration),checkContext(checkContext) {
    static std::vector<std::regex> vecOfRegex = {
      std::regex("^[[:space:]\n]*"), // prologue
      std::regex("^[iI][fF][[:space:]\n]+[nN][oO][tT][[:space:]\n]+"), // IF
      std::regex("^(`[[:alpha:]_][[:alnum:]_]*`|[[:alpha:]_][[:alnum:]_]*)[[:space:]\n]*"), /// ID
      std::regex("^(\\.[[:space:]\n]*(`[[:alpha:]_][[:alnum:]_]*`|[[:alpha:]_][[:alnum:]_]*)[[:space:]\n]*|[[:space:]\n]*)"), // ID part 2
      std::regex("\\([[:space:]\n]*([[:alpha:]_][[:alnum:]_]*|`[[:alpha:]_][[:alnum:]_]*`)[[:space:]\n]*(,[[:space:]\n]*([[:alpha:]_][[:alnum:]_]*|`[[:alpha:]_][[:alnum:]_]*`))*\\)[[:space:]\n]*"), // (arg)
      std::regex("^[tT][hH][eE][nN][[:space:]\n]+"), // THEN
      std::regex("^[sS][iI][gG][nN][aA][lL][[:space:]\n]+"), // SIGNAL
      std::regex("^[sS][qQ][lL][sS][tT][aA][tT][eE][[:space:]\n]+"), // SQLSTATE
      std::regex("^'4<ERR>'[[:space:]\n]+"), // '45<ERR>
      std::regex("^[sS][eE][tT][[:space:]\n]+"), // SET
      std::regex("^[mM][eE][sS][sS][aA][gG][eE]_[tT][eE][xX][tT][[:space:]\n]+"), // MESSAGE_TEXT
      std::regex("^=[[:space:]\n]+"), // =
      std::regex("^'.*'[[:space:]\n]*"), // '...'
      std::regex("^;[[:space:]\n]*"), // ";"
      std::regex("^[eE][nN][dD][[:space:]\n]+"), // END
      std::regex("^[iI][fF][[:space:]\n]*"), // IF
      std::regex("^;[[:space:]\n]*") // ";" 
                               
    };
    if (!checkSyntax(checkContext,vecOfRegex)) {
      throw std::logic_error("Syntax error in check context");
    } 
  }


  TabCfgTemplate::TabCfgTemplate(IConfiguration& iConfiguration,const std::string& name,const nlohmann::json& tabCfgTemplate): ConfigurationItem(iConfiguration), name(name), tabCfgTemplate(tabCfgTemplate) {
    for (auto& a: Access::allType) {
      if (tabCfgTemplate[Access::getStringFromType(a)] == nullptr) {
        throw std::logic_error("No actions specified for table configuration template");
      }
    }
    for (auto& a: Access::allType) {
      nlohmann::json tmp = tabCfgTemplate[Access::getStringFromType(a)];
      for (auto& r: tmp) {
        if (getIConfiguration().isRole(r)) {
          std::string tmp = "The role \""+std::string(r)+"\" does not exist";
          throw std::logic_error(tmp);
        }
      }
    }
    
    for (auto& a: Access::allType) {
      nlohmann::json tmp = tabCfgTemplate[Access::getStringFromType(a)];
      for (auto& a2r: tmp.items()) {
        r2a.insert(std::make_pair(a2r.value(),a));
      }
      
    }
  }

  TableSpec::TableSpec(IConfiguration& iConfiguration,const std::string& tableName,nlohmann::json jsonTableSpec): ConfigurationItem(iConfiguration), tableName(tableName) {
    for (auto& tmp: jsonTableSpec.items()) {
      if (!DatabaseOperation::exists(tmp.key()) && tmp.key() != "eidBase" && tmp.key() != "acronym" && tmp.key() != "hasKeyAttribute") {
        throw std::logic_error("The operation \""+tmp.key()+"\" is neither a database operation, found in \""+tableName+"\", nor an error identity base or an acronym");
      }
      if (DatabaseOperation::exists(tmp.key())) {
        nlohmann::json linkedTable = tmp.value()["link"];
        if (linkedTable == nullptr) {
          throw std::logic_error("No linked template, found in \""+tableName+"\"");
        }
        try {
          iConfiguration.getTabCfgTemplate(linkedTable.get<std::string>());
        } catch (std::out_of_range& oore) {
          throw std::logic_error("No such template: \""+linkedTable.get<std::string>()+"\"");
        }
      } else {
        if (tmp.key() == "eidBase") {
          eidBase = tmp.value().get<int>();
        } else if (tmp.key() == "acronym") {
          acronym = tmp.value().get<std::string>();
        } else {
          hasKeyAttr = tmp.value().get<bool>();
        }
      }
    }
    for (auto& tmp: jsonTableSpec.items()) {
      if (DatabaseOperation::exists(tmp.key())) {
        nlohmann::json linkedTable = tmp.value()["link"];
        op2tct.insert(std::make_pair(DatabaseOperation::getTypeFromString(tmp.key()),iConfiguration.getTabCfgTemplate(linkedTable)));
      }
    }
  
  }

  void Processing::addProcessingStep(const ProcessingStep processingStep) {
    decltype(phase2Step2SetOfPPS)::iterator p2s2soppsit = phase2Step2SetOfPPS.find(processingStep.getPhase());
    if (p2s2soppsit == phase2Step2SetOfPPS.end()) {
      decltype(phase2Step2SetOfPPS)::mapped_type  s2setOfPPS;
      const auto& result = phase2Step2SetOfPPS.insert(std::make_pair(processingStep.getPhase(),s2setOfPPS));
      p2s2soppsit = result.first;
    }
    decltype(phase2Step2SetOfPPS)::mapped_type::iterator s2soppsit = p2s2soppsit->second.find(processingStep.getStep());
    if (s2soppsit == p2s2soppsit->second.end()) {
      decltype(p2s2soppsit->second)::mapped_type s2setOfPPS;
      const auto& result = p2s2soppsit->second.insert(std::make_pair(processingStep.getStep(),s2setOfPPS));
      s2soppsit = result.first;
    }
    decltype(s2soppsit->second)::iterator soppsit = s2soppsit->second.find(processingStep);
    if (soppsit != s2soppsit->second.end()) {
      throw std::logic_error("Duplicate steps addressing exactly the same thing in post processing specification");
    }
    s2soppsit->second.insert(processingStep);
  }

  void Configuration::addRoleSet(const nlohmann::json& jsonCfg) {
    nlohmann::json rs = jsonCfg["roles"];
    if ( rs == nullptr ) {
      throw std::logic_error("No roles specified");
    }
    for (auto& r: rs.items()) {
      Role role(*static_cast<IConfiguration*>(this),r.key(),std::stoi(r.value().get<std::string>()));
      addRole(std::move(role));
    }
  }

  void Configuration::addRole(const Role& role) {
    roleSet.insert(role);
  }
  
  const std::set<Role>& Configuration::getRoleSet() const {
    return roleSet;
  }


  bool Configuration::isRole(const std::string& roleDesc) const {
    return std::any_of(roleSet.begin(),roleSet.end(),[roleDesc](const Role& role){return role.getName() == roleDesc; });
  }
  

  void Configuration::addContextParameters(const nlohmann::json& jsonCfg) {
    // check for context parameters
    nlohmann::json cp = jsonCfg["contextParameters"];
    if ( cp ==  nullptr) {
      throw std::logic_error("No context parameters in configuration");
    }
    int noOfOutputLanguageCfg = 0;
    for (auto& t: OutputLanguage::allType) {
      const std::string& olkey = OutputLanguage::getStringFromType(t);
      nlohmann::json cpl = cp[olkey];
      if (cpl != nullptr) {
        ++noOfOutputLanguageCfg;
        for (auto& at: Access::allType) {
          const std::string& atkey = Access::getStringFromType(at);
          nlohmann::json cpla = cpl[atkey];
          if (cpla != nullptr) {
            for (auto& el: cpla.items()) {
              auto cpo = ContextParameter(*this,el.value());

              // create t entry
              decltype(ol2at2te2cp)::iterator itol = ol2at2te2cp.find(t);
              if (itol == ol2at2te2cp.end()) {
                decltype(itol->second) tmp;
                auto result = ol2at2te2cp.insert(std::make_pair(t,tmp));
                assert(result.second);
                itol = result.first;
              }

              // create at entry in t entry
              decltype(itol->second)::iterator itat = itol->second.find(at);
              if (itat == itol->second.end()) {
                decltype(itat->second) tmp2;
                auto result2 = itol->second.insert(std::make_pair(at,std::move(tmp2)));
                assert(result2.second);
                itat = result2.first;
              }

              // create te entry in at entry in t entry
              decltype(itat->second)::iterator itte = itat -> second.find(el.key());
              if (itte == itat->second.end()) {
                auto result3 = itat->second.insert(std::make_pair(el.key(),std::move(cpo)));
                assert(result3.second);
                itte = result3.first;
              } else {
                throw std::logic_error("The same key twice, impossible!");
              }

            }
          }
        }
      }
    }
    if (noOfOutputLanguageCfg < 1) {
      throw std::logic_error("No configuration of output languages");
    }
  }
  void Configuration::addCheckContext(const nlohmann::json& jsonCfg) {
    // look for checkContext statements
    nlohmann::json cc = jsonCfg["checkContext"];
    if ( cc ==  nullptr) {
      throw std::logic_error("No check context statements in configuration");
    }
    for (auto& el: cc.items()) {
      auto cco = CheckContext(*this,el.value());
      key2cc.insert(std::make_pair(el.key(),cco));
    }
    
  }
  void Configuration::addTabCfgTemplate(const nlohmann::json& jsonCfg) {
    // look for table configuration, templates
    nlohmann::json tc = jsonCfg["tableConfiguration"]["aclTemplate"];
    if (tc == nullptr) {
      throw std::logic_error("No table template configuration");
    }
    for (auto& tableCfg: tc.items()) {
      TabCfgTemplate tct(*this,tableCfg.key(),tableCfg.value());
      key2tct.insert(std::make_pair(tableCfg.key(),tct));
    }
  }
  void Configuration::addTableSpec(const nlohmann::json& jsonCfg) {
    // look for table specifications
    nlohmann::json tss = jsonCfg["tableConfiguration"]["tableSpec"];
    if (tss == nullptr) {
      throw std::logic_error("Not table specification configuration");
    }
    for (auto& tableSpec: tss.items()) {
      TableSpec ts(*this,tableSpec.key(),tableSpec.value());
      key2ts.insert(std::make_pair(tableSpec.key(),std::move(ts)));
    }
  }
  void Configuration::addProcessing(const nlohmann::json& jsonCfg) {
    std::map<ProcessingStep::Phase,std::string> p2s{
      { ProcessingStep::Phase::declaration,"declaration"},
      { ProcessingStep::Phase::preProcessing,"preProcessing"},
      { ProcessingStep::Phase::postProcessing,"postProcessing"}
    };
    for (auto& p2spair: p2s) {
      // look for table specifications
      nlohmann::json pp = jsonCfg[p2spair.second];
      if (pp == nullptr) {
        throw std::logic_error("No declaration/pre/post processing configuration");
      }
      for (auto& pps: pp) {
        ProcessingStep processingStep(*this,p2spair.first,pps["step"].get<int>(),pps["tablePattern"].get<std::string>(),pps["operationPattern"].get<std::string>(),pps["domainPattern"].get<std::string>(),pps["instruction"].get<std::string>());
        processing.addProcessingStep(processingStep);
      }
    }
  }

  void Configuration::add(const nlohmann::json& jsonCfg) {
    addContextParameters(jsonCfg);
    addCheckContext(jsonCfg);
    addTabCfgTemplate(jsonCfg);
    addTableSpec(jsonCfg);
    addProcessing(jsonCfg);

  }

  const ContextParameter& Configuration::getContextParameter(const OutputLanguage::Type& oltp, const Access::Type& attp, const std::string& templ) const {
    return ol2at2te2cp.at(oltp).at(attp).at(templ);
  }
  const  CheckContext& Configuration::getCheckContext(const std::string& key) const {
    return key2cc.at(key);
  }
  const  TabCfgTemplate& Configuration::getTabCfgTemplate(const std::string& key) const {
    return key2tct.at(key);
  }
  const  TableSpec& Configuration::getTableSpec(const std::string& key) const {
    return key2ts.at(key);
  }
  const Processing& Configuration::getProcessing() const {
    return processing;
  }
  Configuration::Configuration(nlohmann::json jsonCfg): processing(*this) {
    add(jsonCfg);
  }

}
