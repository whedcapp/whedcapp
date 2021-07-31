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
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <map>
#include <regex>
#include <sstream>
#include <stdexcept>

#include "common.hh"
#include "generatorProto.hh"
#include "relationalOperator.hh"

namespace PartSqlCrudGen {
  std::map<Type,std::string>
  GeneratorProto::type2protoType = {
                                    std::make_pair(Type(Type::Cat::int_sql),"int32")
                                    ,std::make_pair(Type(Type::Cat::tiny_int_sql),"int32")
                                    ,std::make_pair(Type(Type::Cat::small_int_sql),"int32")
                                    ,std::make_pair(Type(Type::Cat::medium_int_sql),"int32")
                                    ,std::make_pair(Type(Type::Cat::big_int_sql),"int64")
                                    ,std::make_pair(Type(Type::Cat::decimal_sql),"double")
                                    ,std::make_pair(Type(Type::Cat::float_sql),"double")
                                    ,std::make_pair(Type(Type::Cat::double_sql),"double")
                                    ,std::make_pair(Type(Type::Cat::bit_sql),"int64")
                                    ,std::make_pair(Type(Type::Cat::date_sql),"GTimestamp")
                                    ,std::make_pair(Type(Type::Cat::time_sql),"GTimestamp")
                                    ,std::make_pair(Type(Type::Cat::datetime_sql),"GTimestamp")
                                    ,std::make_pair(Type(Type::Cat::timestamp_sql),"GTimestamp")
                                    ,std::make_pair(Type(Type::Cat::char_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::varchar_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::binary_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::varbinary_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::tinyblob_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::blob_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::mediumblob_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::longblob_sql),"bytes")
                                    ,std::make_pair(Type(Type::Cat::tinytext_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::text_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::mediumtext_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::longtext_sql),"string")
                                    ,std::make_pair(Type(Type::Cat::boolean_sql),"bool")
  };
  std::ostream& GeneratorProto::generateRpcIngress(std::ostream& str,
                                                  const Options& options,
                                                  const std::shared_ptr<Driver>& shPtr2Driver) const {
    str 
      << "syntax = 'proto3';" << std::endl
      << "option java_multiple_files = true;" << std::endl
      << "option java_package = \"se.his.ihl.shc.whedcapp\";" << std::endl
      << "option java_outer_classname = \"Whedcapp\";" << std::endl
      << "option objc_class_prefix = \"WHEDCAPP\";" << std::endl
      << "package whedcapp;" << std::endl;
    return str;
  }
  std::ostream& GeneratorProto::generateRpcStdMsg(std::ostream& str,
                                                 const Options& options,
                                                 const std::shared_ptr<Driver>& shPtr2Driver) const {
    // RecordIdentityResult, to handle insert result
    str
      << "message RecordIdentityResult {" << std::endl
      << "  int32 recordIdentity = 1;" << std::endl
      << "}" << std::endl;

    // Dummy
    str
      << "message Dummy {" << std::endl
      << "  bool success = 1;" << std::endl
      << "}" << std::endl;

    // GTimestamp
    str
      << "message GTimestamp {" << std::endl
      << "  int64 seconds = 1;" << std::endl
      << "  int32 nanos = 2;" << std::endl
      << "}" << std::endl;

    return str;
  }

  std::ostream& GeneratorProto::generateRpc(std::ostream& str,
                                           const Options& options,
                                           const std::shared_ptr<Driver>& shPtr2Driver,
                                           const ShPtr2Table& tableMetaData,
                                           const DatabaseOperation::Type& op,
                                           const Access::Type& accessType) const {
    std::ostringstream suffix;
    suffix << "_" << op << "_" << accessType;
    const Identity& id = tableMetaData->getIdentity();
    str
      << "  rpc "
      << id.getUnquoted(suffix.str())
      << "("
      << id.getUnquoted(suffix.str()+"_input")
      << ")"
      << " returns "
      << "(";

    if (op == DatabaseOperation::Type::dbInsert) {
      str << "RecordIdentityResult";
    } else if (op == DatabaseOperation::Type::dbSelect) {
      str << "stream "
          << id.getUnquoted(suffix.str()+"_response");
    } else {
      str << "Dummy";
    }
    str <<  ");" << std::endl;
    return str;
  }
  std::ostream& GeneratorProto::generateRpcApi(std::ostream& str,
                                              const Options& options,
                                              const std::shared_ptr<Driver>& shPtr2Driver) const {
    // RPC specification 
    str
      << "service Whedcapp {" << std::endl;
    for (auto tableMetaData : *shPtr2Driver->shPtr2VecOfShPtr2Table) {
      std::cerr << "Generating for \"" << *tableMetaData << "\"" <<std::endl;
      for (auto op: DatabaseOperation::allType) {
        for (auto at: Access::allType) {
          if (DatabaseOperation::compatibleAccessType(op,at)) {
            generateRpc(str,options,shPtr2Driver,tableMetaData,op,at);
          }
        }
      }
    }

    str
      << "}";
    return str;
  }
  std::ostream& GeneratorProto::generateInpMsgCtxtPar(std::ostream& str,
                                      const Options& options,
                                      const std::shared_ptr<Driver>& shPtr2Driver,
                                      const ShPtr2Table& tableMetaData,
                                      const DatabaseOperation::Type& op,
                                      const Access::Type& accessType,
                                      bool selectMsg,
                                      bool& notFirstContextParameter,
                                      int& grpcParPos) const
  {
    notFirstContextParameter = false;
    grpcParPos = 1; // gRPC parameters start at position 1
    try {
      // get the context for the domain
      const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
      const auto& tc = ts.getTabCfgTemplate(op);
      const auto& tmplName = tc.getName();
      const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Proto, accessType, tmplName);
      VecOfShPtr2Table& vecOfShPtr2Table = *shPtr2Driver->shPtr2VecOfShPtr2Table;
  
      for (const auto& par2ref: cp.getVecOfPar2Ref()) {
        if (notFirstContextParameter) {
          str << "; " << std::endl;
        }
        const std::string colNameBase = par2ref.first ; // the name of the parameter
        VecOfShPtr2Table::iterator votit = std::find_if(vecOfShPtr2Table.begin(),
                                                        vecOfShPtr2Table.end(),
                                                        [par2ref](ShPtr2Table shPtr2Table){ return shPtr2Table->getIdentity() == par2ref.second.getReference().getTableIdentity(); });
        if (votit == vecOfShPtr2Table.end()) {
          std::ostringstream msg;
          msg << "Table definition \"" << par2ref.second.getReference().getTableIdentity() << "\" is missing, either the context parameter reference is incorrect or the table definition is missing";
          throw std::logic_error(msg.str());
        }
        try {
          auto col = (*votit)->getShPtr2Columns()->getShPtr2Column(par2ref.second.getReference().getColumnIdentity());
          auto& type = col->getType();
          str
            << "  "
            << type2protoType.at(type)
            << " "
            << colNameBase << "_par"
            << " = "
            << grpcParPos;
          ++grpcParPos;
        } catch (const std::out_of_range& oor) {
          std::ostringstream msg;
          msg << "No such column \"" << par2ref.second.getReference().getColumnIdentity() <<"\"";
          throw std::logic_error(msg.str());
        }
        
        notFirstContextParameter = true;
      }
    } catch (const std::out_of_range& oor) {
    }
    return str;
  }
  std::ostream& GeneratorProto::generateInpMsgNotCtxtPar(std::ostream& str,
                                                         const Options& options,
                                                         const std::shared_ptr<Driver>& shPtr2Driver,
                                                         const ShPtr2Table& tableMetaData,
                                                         const DatabaseOperation::Type& op,
                                                         const Access::Type& accessType,
                                                         bool selectMsg,
                                                         bool& notFirstContextParameter,
                                                         int& grpcPosPar) const {
    try {
      // If there are context parameters, then notFirstContextParameter is true and a comma should
      // be added prior to the rest of the parameters. Note, there must be other parameters.

      // get the parameters for the table and use them as parameters
      const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
      const auto& tc = ts.getTabCfgTemplate(op);
      const auto& tmplName = tc.getName();
      
      const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, accessType, tmplName);
      VecOfShPtr2Table& vecOfShPtr2Table = *shPtr2Driver->shPtr2VecOfShPtr2Table;
      VecOfShPtr2Table::iterator votit = std::find_if(vecOfShPtr2Table.begin(),
                                                      vecOfShPtr2Table.end(),
                                                      [tableMetaData](ShPtr2Table shPtr2Table){ return shPtr2Table->getIdentity() == tableMetaData->getIdentity(); });
      if (votit == vecOfShPtr2Table.end()) {
        throw std::logic_error("There must be an table definition missing");
      }
      if (op == DatabaseOperation::Type::dbInsert) {
        std::cerr << "Start generating for " << tableMetaData->getIdentity() << std::endl;
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersWithTypeInformationInParameterList =
          GenerateColumnListProto::create(
                                          IGenerateColumnList::GenerateKind::columnParametersWithTypeInformationInParameterList,
                                          str,
                                          tableMetaData,
                                          cp,
                                          "_par",
                                          notFirstContextParameter,
                                          grpcPosPar
                                          );
        gclsColumnParametersWithTypeInformationInParameterList->generate();
        std::cerr << "End generating for " << tableMetaData->getIdentity() << std::endl;
      } else if (op == DatabaseOperation::Type::dbUpdate) {
        std::cerr << "Start generating for " << tableMetaData->getIdentity() << std::endl;
        std::unique_ptr<IGenerateColumnList> gclpColumnParametersForUpdateInParameterList =
          GenerateColumnListProto::create(
                                        IGenerateColumnList::GenerateKind::columnParametersForUpdateInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter,
                                        grpcPosPar
                                        );
        gclpColumnParametersForUpdateInParameterList->generate();
        std::cerr << "End generating for " << tableMetaData->getIdentity() << std::endl;        

      } else if (op == DatabaseOperation::Type::dbDelete) {
        std::unique_ptr<IGenerateColumnList> gclpOnlyPrimaryKeyInParameterList =
          GenerateColumnListProto::create(
                                        IGenerateColumnList::GenerateKind::onlyPrimaryKeyInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter,
                                        grpcPosPar
                                        );
        gclpOnlyPrimaryKeyInParameterList->generate();
      } else { // dbSelect
        std::unique_ptr<IGenerateColumnList> gclpColumnParametersForSelectInParameterList =
          GenerateColumnListProto::create(
                                        IGenerateColumnList::GenerateKind::columnParametersForSelectInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter,
                                        grpcPosPar
                                        );
        gclpColumnParametersForSelectInParameterList->generate();
        
      }
    } catch (const std::out_of_range& oore) {
      std::ostringstream msg;
      msg << "Something missing in the configuration, candidates are: no table specification item for \""
          << tableMetaData->getIdentity().getSecondary() << "\", no table configuration template for \""
          << op << "\", not context parameter for \"SQL\" for \"" << accessType<< "\"" << std::endl;
      throw ConfigurationException(msg.str());
    }
    return str;
  }


  /* Generates input message parameter specification for gRPC */
  std::ostream& GeneratorProto::generateInpMsgPar(std::ostream& str,
                                                 const Options& options,
                                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                                 const ShPtr2Table& tableMetaData,
                                                 const DatabaseOperation::Type& op,
                                                 const Access::Type& accessType,
                                                 bool& notFirstParameter,
                                                 int& grpcPosPar) const {
    notFirstParameter = false;
    grpcPosPar = 1;
    bool selectMsg = op == DatabaseOperation::Type::dbSelect;
    generateInpMsgCtxtPar(str,options,shPtr2Driver,tableMetaData,op,accessType,selectMsg,notFirstParameter,grpcPosPar);
    generateInpMsgNotCtxtPar(str,options,shPtr2Driver,tableMetaData,op,accessType,selectMsg,notFirstParameter,grpcPosPar);
      
    return str;
  }

  /* Generates an input message specification for gRPC */
  std::ostream& GeneratorProto::generateInpMsg(std::ostream& str,
                                               const Options& options,
                                               const std::shared_ptr<Driver>& shPtr2Driver,
                                               const ShPtr2Table& tableMetaData,
                                               const DatabaseOperation::Type& op,
                                               const Access::Type& accessType) const {
    std::ostringstream suffix;
    suffix << "_" << op << "_" << accessType;
    str
      << "message " 
      << tableMetaData->getIdentity().getUnquoted(suffix.str()+"_input")
      << " {";

    bool notFirstParameter = false;
    int grpcPosPar = 1;
    generateInpMsgPar(str,options,shPtr2Driver,tableMetaData,op,accessType,notFirstParameter,grpcPosPar);
    str << "}" << std::endl;

      
    return str;
  }

  /* Generates result message parameter specification for gRPC */
  std::ostream& GeneratorProto::generateResMsgPar(std::ostream& str,
                                                 const Options& options,
                                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                                 const ShPtr2Table& tableMetaData,
                                                 const DatabaseOperation::Type& op,
                                                 const Access::Type& accessType,
                                                 bool& notFirstParameter,
                                                 int& grpcPosPar) const {
    notFirstParameter = false;
    grpcPosPar = 1;
    if (op == DatabaseOperation::Type::dbSelect) {
      const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
      const auto& tc = ts.getTabCfgTemplate(op);
      const auto& tmplName = tc.getName();
      
      const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, accessType, tmplName);
      str
        << "message X {" << std::endl;
      for (auto tableMetaData : *shPtr2Driver->shPtr2VecOfShPtr2Table) {
        std::cerr << "Generating for \"" << *tableMetaData << "\"" <<std::endl;
        for (auto op: DatabaseOperation::allType) {
          for (auto at: Access::allType) {
            if (DatabaseOperation::compatibleAccessType(op,at)) {
              std::unique_ptr<IGenerateColumnList> gclpColumnParametersIncludingIdForSelect =
                GenerateColumnListProto::create(
                                                IGenerateColumnList::GenerateKind::onlyPrimaryKeyInParameterList,
                                                str,
                                                tableMetaData,
                                                cp,
                                                "_par",
                                                notFirstParameter,
                                                grpcPosPar
                                                );
              gclpColumnParametersIncludingIdForSelect->generate();
            }
          }
        }
      }
      str << "}" << std::endl;
    }
      
    return str;
  }

  /* Generates an result message specification for gRPC */
  std::ostream& GeneratorProto::generateResMsg(std::ostream& str,
                                               const Options& options,
                                               const std::shared_ptr<Driver>& shPtr2Driver,
                                               const ShPtr2Table& tableMetaData,
                                               const DatabaseOperation::Type& op,
                                               const Access::Type& accessType) const {
    std::ostringstream suffix;
    suffix << "_" << op << "_" << accessType;
    str
      << "message " 
      << tableMetaData->getIdentity().getUnquoted(suffix.str()+"_record")
      << " {";

    bool notFirstParameter = false;
    int grpcPosPar = 1;
    generateResMsgPar(str,options,shPtr2Driver,tableMetaData,op,accessType,notFirstParameter,grpcPosPar);
    str << "}" << std::endl;

      
    return str;
  }

  std::ostream& GeneratorProto::generateInpMsgs(std::ostream& str,
                                                const Options& options,
                                                const std::shared_ptr<Driver>& shPtr2Driver) const {
    for (auto tableMetaData : *shPtr2Driver->shPtr2VecOfShPtr2Table) {
      std::cerr << "Generating for \"" << *tableMetaData << "\"" <<std::endl;
      for (auto op: DatabaseOperation::allType) {
        for (auto at: Access::allType) {
          if (DatabaseOperation::compatibleAccessType(op,at)) {
            std::cerr << "Database operation " << op << std::endl;
            std::cerr << "Access type " << at << std::endl;
            generateInpMsg(str,options,shPtr2Driver,tableMetaData,op,at);
            generateResMsg(str,options,shPtr2Driver,tableMetaData,op,at);
          }
        }
      }
    }

    return str;
  }

  
  void GeneratorProto::generate(const PartSqlCrudGen::Options& options, const std::shared_ptr<PartSqlCrudGen::Driver>& shPtr2Driver) const {
    if (options.outputFilePath.empty()) {
      throw std::logic_error("Output file path cannot be empty");
    }
    std::ofstream outputFile;
    outputFile.open(options.outputFilePath.at(OutputLanguage::Type::Proto),std::ofstream::out);
    if (!outputFile.is_open()) {
      throw std::logic_error("Output file is not opened");
    }

    generateRpcIngress(outputFile,options,shPtr2Driver);
    generateRpcApi(outputFile,options,shPtr2Driver);
    generateRpcStdMsg(outputFile,options,shPtr2Driver);
    generateInpMsgs(outputFile,options,shPtr2Driver);

      
  }
    


  const bool GenerateColumnListProto::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return true;
  }
  const bool GenerateColumnListProto::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }
  std::ostream& GenerateColumnListProto::generateColumn(const ShPtr2Column& shPtr2Column)  {
    getStr() << shPtr2Column->getIdentity().getUnquoted(getSuffix());
    return getStr();
  }

  std::unique_ptr<IGenerateColumnList> GenerateColumnListProto::create(IGenerateColumnList::GenerateKind generateKind,std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter, const std::string& suffix, bool notFirst, int& grpcParPos ) {
    switch(generateKind) {
    case onlyColumnParameters:
      return std::make_unique<GclpOnlyColumnParameters>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case columnParametersForInsertInValues:
      throw std::logic_error("columnParametersForInsertInValues not used in gRPC prototype specification generation");;
    case columnParametersForInsertInFieldList:
      throw std::logic_error("columnParametersForInsertInFieldList not used in gRPC prototype specification generation");;
    case columnParametersWithTypeInformationInParameterList:
      return std::make_unique<GclpColumnParametersWithTypeInformationInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case columnParametersForUpdateInParameterList:
      return std::make_unique<GclpColumnParametersForUpdateInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case columnParametersForUpdate:
      throw std::logic_error("columnParametersForUpdate not used in gRPC prototype specification generation");;
    case onlyPrimaryKeyInParameterList:
      return std::make_unique<GclpOnlyPrimaryKeyInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case columnParametersForSelectInParameterList:
      return std::make_unique<GclpColumnParametersForSelectInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case onlyColumnParametersIncludingIdForSelect:
      return std::make_unique<GclpColumnParametersIncludingIdForSelect>(str,shPtr2Table, optContextParameter, suffix,notFirst,grpcParPos);
    case columnParametersForDelete:
      throw std::logic_error("columnParametersForDelete not used in gRPC prototype specification generation");
    default:
      return nullptr;
    }
  }

  std::ostream& GenerateColumnListProto::generateColumnList() {
    for (const auto& col: *(getShPtr2Columns())) {
      if (shouldAttributeBeListed(col)) {
        if (getNotFirst()) {
          getStr() << " = " << grpcParPos << " ; " << std::endl << "  ";
          ++grpcParPos;
        }
        generateColumn(col);
        setNotFirst();
      } else if (shouldReplacementAttributeBeListed(col)) {
        if (getNotFirst()) {
          getStr() << " = " << grpcParPos << " ; " << std::endl << "  ";
          ++grpcParPos;
        }
        generateReplacementColumn(col);
        setNotFirst();
      }
      
    }
    return getStr();
  }

  const bool GclpOnlyColumnParameters::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return !shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  const bool GclpColumnParametersWithTypeInformationInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const  {
    std::cerr << shPtr2Column->getIdentity() << "=> pk = " << shPtr2Column->isPrimaryKey() << ", cp = " << isContextParameter(shPtr2Column) << std::endl;
    return !shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  std::ostream& GclpColumnParametersWithTypeInformationInParameterList::generateColumn(const ShPtr2Column& shPtr2Column)  {
    getStr() << GeneratorProto::type2protoType.at(shPtr2Column->getType());
    GclpOnlyColumnParameters::generateColumn(shPtr2Column);
    return getStr();
  }

  const bool GclpColumnParametersForUpdateInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const  {
    std::cerr << shPtr2Column->getIdentity() << "=> pk = " << shPtr2Column->isPrimaryKey() << ", cp = " << isContextParameter(shPtr2Column) << std::endl;
    return !isContextParameter(shPtr2Column);
  }

  

  const bool GclpOnlyPrimaryKeyInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  const bool GclpOnlyPrimaryKeyInParameterList::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }

  const bool GclpColumnParametersForSelectInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return !isContextParameter(shPtr2Column);
  }

  const bool GclpColumnParametersForSelectInParameterList::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }

  std::ostream& GclpColumnParametersForSelectInParameterList::generateColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << "string" << " " << shPtr2Column->getIdentity().getUnquoted(getSuffix()+"_cmp") << " = " << grpcParPos;
    ++grpcParPos;
    getStr() << "  " << GeneratorProto::type2protoType.at(shPtr2Column->getType());
    GclpOnlyColumnParameters::generateColumn(shPtr2Column);
    return getStr();
  }

  const bool GclpColumnParametersIncludingIdForSelect::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return true;
  }
  const bool GclpColumnParametersIncludingIdForSelect::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }
  std::ostream& GclpColumnParametersIncludingIdForSelect::generateColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << "  " << GeneratorProto::type2protoType.at(shPtr2Column->getType()) << " ";
    GclpOnlyColumnParameters::generateColumn(shPtr2Column);
    return getStr();
  }


}
