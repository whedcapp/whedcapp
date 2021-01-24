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
    along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
*/
#include <fstream>
#include <iomanip>
#include <regex>
#include <sstream>
#include <stdexcept>

#include "common.hh"
#include "generatorSql.hh"
#include "relationalOperator.hh"

static const std::regex errPattern("<ERR>");
static const std::regex operationPattern("<OPERATION>");
static const std::regex aTablePattern("<A_TABLE>");
static const std::regex domainPattern("<DOMAIN>");




std::string beautifyStoredProcedureCode(const std::string& tmpl,int indent) {
  std::string result{""};
  for (auto& c: tmpl) {
    if (c == '\n' || c == '\t') {
      for (int i = 0; i < indent; ++i) {
        result += " ";
      }
    }
    if (c != '\t' ) {
      result += c;
    } 
  }
  return result;
}

static std::string replace(const std::string& tmpl,const std::vector<std::pair<std::regex,std::string>>& tag2string) {
  std::string tmpTmpl(tmpl);
  for (auto& p: tag2string) {
    std::regex re(p.first);
    tmpTmpl = std::regex_replace(tmpTmpl,re,p.second);
  }
  return tmpTmpl;
}


  

namespace PartSqlCrudGen {

  static std::string accessType2Output(const Access::Type& accessType) {
    switch (accessType) {
    case Access::Type::writeSelf:
    case Access::Type::readSelf:
      return "own domain";
    default:
      return "others domain";
    }
  }

  enum GenerateKind { onlyColumnParameters, columnParametersWithTypeInformation, columnParametersForUpdate, onlyPrimaryKey, columnParametersForSelect, onlyColumnParametersIncludingId};
  static std::ostream& generateColumnList(std::ostream& str, const ShPtr2Columns& shPtr2Columns, GenerateKind generateKind,  const std::string& suffix = "") {
    if (generateKind == GenerateKind::columnParametersForUpdate && suffix != "") {
      throw std::logic_error("Suffix must not be set if update information is true");
    }
    bool notFirst = false;
    for (const auto& c: *shPtr2Columns) {
        if (notFirst) {
          str << ", ";
        }
        if ((!c->isPrimaryKey() && generateKind != GenerateKind::onlyPrimaryKey) ||
            (c->isPrimaryKey() && (generateKind == GenerateKind::onlyPrimaryKey || generateKind == GenerateKind::onlyColumnParametersIncludingId || generateKind == GenerateKind::columnParametersForSelect))) {
          if (generateKind == GenerateKind::columnParametersForSelect) {
            str << c->getIdentity().getBackquoted(suffix+"_cmp") << " VARCHAR(3), " << std::endl;
          }
          str << c->getIdentity().getBackquoted(suffix);
          notFirst = true;
          if (generateKind == GenerateKind::columnParametersWithTypeInformation ||
              generateKind == GenerateKind::columnParametersForSelect || 
              generateKind == GenerateKind::onlyPrimaryKey) {
            str << " " << c -> getType();
          } else if (generateKind == GenerateKind::columnParametersForUpdate) {
            str << " = " << c->getIdentity().getBackquoted("_par");
          }
          if (c->isPrimaryKey() && generateKind == GenerateKind::onlyPrimaryKey) {
            break;
          }
        } 
        
    }
    return str;
  }

  std::ostream& GeneratorSql::generateCreateProcedureOrFunction(std::ostream& str,
                                                                const Options& options,
                                                                const std::shared_ptr<Driver>& shPtr2Driver,
                                                                const ShPtr2Table& tableMetaData,
                                                                const DatabaseOperation::Type& op,
                                                                const Access::Type& accessType) const {
    std::ostringstream suffix;
    suffix << "_" << op << "_" << accessType;
    str
      << "CREATE " << (op != DatabaseOperation::Type::dbInsert? "PROCEDURE ": "FUNCTION ")
      << tableMetaData->getIdentity().getBackquoted(suffix.str())
      << "(";
    
    // get the context for the domain
    const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
    const auto& tc = ts.getTabCfgTemplate(op);
    const auto& tmplName = tc.getName();
    const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, accessType, tmplName);
    str << cp.getString();

    // get the parameters for the table and use them as parameters
    VecOfShPtr2Table& vecOfShPtr2Table = *shPtr2Driver->shPtr2VecOfShPtr2Table;
    VecOfShPtr2Table::iterator votit = std::find_if(vecOfShPtr2Table.begin(),
                                                    vecOfShPtr2Table.end(),
                                                    [tableMetaData](ShPtr2Table shPtr2Table){ return shPtr2Table->getIdentity() == tableMetaData->getIdentity(); });
    if (votit == vecOfShPtr2Table.end()) {
      throw std::logic_error("There must be an table definition missing");
    }
    if (op != DatabaseOperation::Type::dbDelete && op != DatabaseOperation::Type::dbSelect) {
      generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::columnParametersWithTypeInformation,"_par");
    } else if (op == DatabaseOperation::Type::dbDelete) {
      generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::onlyPrimaryKey,"_par");
    } else { // dbSelect
      generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::columnParametersForSelect,"_par");
    }
    str << ")"  << (op == DatabaseOperation::Type::dbInsert? " RETURNS INTEGER DETERMINISTIC":"") << std::endl << "BEGIN" << std::endl;
    return str;
  
  }

  std::ostream& GeneratorSql::generateContextCheckParameters(std::ostream& str,
                                                             const Options& options,
                                                             const std::shared_ptr<Driver>& shPtr2Driver,
                                                             const ShPtr2Table& tableMetaData,
                                                             const DatabaseOperation::Type& op,
                                                             const Access::Type& at) const {


    // get template name
    const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
    const auto& tc = ts.getTabCfgTemplate(op);
    const auto& tmplName = tc.getName();

    // get check context code
    const auto& cc = options.getConfiguration().getCheckContext(tmplName);

    // replace tags
    const auto& ccs = beautifyStoredProcedureCode(cc.getCheckContext(),options.outputCodeTabWidth);
    const auto& ccsr = replace(ccs,{
                                     {errPattern,std::to_string(ts.getEidBase()+op+at)},
                                     {operationPattern,DatabaseOperation::getStringFromType(op)},
                                     {aTablePattern,"a/an "+toupper(tableMetaData->getIdentity().getSecondary())},
                                     {domainPattern,accessType2Output(at)}
      });
    str << ccsr << std::endl;
    return str;
  
  }



  std::ostream& GeneratorSql::generateOperation(std::ostream& str,
                                                const Options& options,
                                                const std::shared_ptr<Driver>& shPtr2Driver,
                                                const ShPtr2Table& tableMetaData,
                                                const DatabaseOperation::Type& op,
                                                const Access::Type& at) const {
    const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
    switch (op) {
    case DatabaseOperation::Type::dbInsert:
      {
        str << std::setw(options.outputCodeTabWidth) << " " << "INSERT INTO " << tableMetaData->getIdentity().getBackquoted() << " ( ";
        generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::onlyColumnParameters);
        str << ")" << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "VALUES (";
        generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::onlyColumnParameters,"_par");
        str << ");";
      }
      break;
    case DatabaseOperation::Type::dbUpdate:
      {
        str << std::setw(options.outputCodeTabWidth) << " " << "UPDATE " << tableMetaData->getIdentity().getBackquoted() << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "SET " << std::endl;
        str << std::setw(options.outputCodeTabWidth*3) << " ";
        generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::columnParametersForUpdate);
        str << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "WHERE ";
        const std::string& acronym = ts.getAcronym();
      
        std::string colNamePrefix;
        if (acronym!="") {
          colNamePrefix = acronym;
        } else {
          colNamePrefix = tableMetaData->getIdentity().getSecondary();
        }
        if (ts.hasKeyAttribute()) {
          str << colNamePrefix << "_key";
          str << " = " << colNamePrefix << "_key_par;";
        } else {
          // get primary key
          str << tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() 
              << " = " << tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() << "_par;"; 
        }
      }
      break;
    case DatabaseOperation::Type::dbDelete:
      {
        str << std::setw(options.outputCodeTabWidth) << " "  << "DELETE FROM " << tableMetaData->getIdentity().getBackquoted() << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "WHERE " << tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() << " = " <<  tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() << "_par;" << std::endl;
      }
      break;
    case DatabaseOperation::Type::dbSelect:
      {
        str << std::setw(options.outputCodeTabWidth) << " "  << "SELECT ";
        generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::onlyColumnParametersIncludingId);
        str << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " "  << "FROM " << tableMetaData->getIdentity().getBackquoted() << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " "  << "WHERE "  << std::endl;
        str << std::setw(options.outputCodeTabWidth*3) << " "  << "( "  << std::endl;

        // iterate over columns and generate a subclause that if the parameter "x_par" and relational operator
        // "x_par_cmp" is not null, then check what relational operator it is and perform the comparison,
        // this is realized as a sequence of conjunctions of subclauses with conditional disjunctions
        bool notFirst = false;
        for (const auto& c: *tableMetaData->getShPtr2Columns()) {
          if (notFirst) {
            str << " AND " << std::endl;
          }
          str << std::setw(options.outputCodeTabWidth*4) << " "  << "( " << std::endl;
          str << std::setw(options.outputCodeTabWidth*5) << " " << "( " << c->getIdentity() << "_par is not null AND " << c->getIdentity() << "_par_cmp is not null" << std::endl;
          bool notFirst2 = false;
          for (const auto& ro: RelationalOperator::allRealOperatorType) {
            if (notFirst2) {
              str << " OR " << std::endl;
            }
            str
              << std::setw(options.outputCodeTabWidth*6)
              << " "  << "( ";
            str
              << c->getIdentity()
              << "_par_cmp = \""
              << RelationalOperator::getStringFromType(OutputLanguage::Type::Sql,ro)
              << "\" AND "
              << c->getIdentity()
              << RelationalOperator::getStringFromType(OutputLanguage::Type::Sql,ro)
              << c->getIdentity() << "_par)";
            notFirst2 = true;
          }
              
          str << std::endl;
          str << std::setw(options.outputCodeTabWidth*5) << " " << ") OR " << std::endl;
          str << std::setw(options.outputCodeTabWidth*5) << " " << "(";
          str  << c->getIdentity() << "_par is null OR " << c->getIdentity() << "_par_cmp is null)"<<std::endl;
          str << std::setw(options.outputCodeTabWidth*4) << " " << ")";
          notFirst = true;
        }
          str << std::endl << std::setw(options.outputCodeTabWidth*3) << " "  << ");"  << std::endl;
      }
      break;
    }
    str << std::endl;
    return str;
  }
  
  std::ostream& GeneratorSql::generateProcessing(std::ostream& str,
                                                 const Options& options,
                                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                                 const ShPtr2Table& tableMetaData,
                                                 const DatabaseOperation::Type& op,
                                                 const Access::Type& at,
                                                 const ProcessingStep::Phase& phase) const {
    try {
      auto& processing = options.getConfiguration().getProcessing();
      auto& step2SetOfPostProcessingStep = processing.getPhase2Step2SetOfProcessingStep().at(phase);
      for (auto& step2PpsSet: step2SetOfPostProcessingStep) {
        for (auto& pps: step2PpsSet.second) {
          std::smatch tsm;
          const std::string tableName(toupper(tableMetaData->getIdentity().getSecondary()));
          if (std::regex_match(tableName,tsm,pps.getTableRegex() )) {
            std::smatch dsm;
            if (std::regex_match(Access::getStringFromType(at),dsm,pps.getDomainRegex())) {
              std::smatch osm;
              if (std::regex_match(DatabaseOperation::getStringFromType(op),osm,pps.getOperationRegex())) {
                const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
                const auto ppi = beautifyStoredProcedureCode(pps.getInstruction(),options.outputCodeTabWidth);
                const auto ppir = replace(ppi,{
                    {errPattern,std::to_string(ts.getEidBase()+op+at+16)},
                      {operationPattern,DatabaseOperation::getStringFromType(op)},
                        {aTablePattern,"a/an "+tableName},
                          {domainPattern,accessType2Output(at)}
                  });
                //              str << "BANZAI: \"" << pps.getTablePattern() << "\", \"" << at << "\", \"" << op << std::endl;
                str << ppir << std::endl;
              }
            }
          }
        }
      }

    } catch (const std::out_of_range& oore) {
    }
    return str;
  }

  void GeneratorSql::generate(const PartSqlCrudGen::Options& options,
                              const std::shared_ptr<PartSqlCrudGen::Driver>& shPtr2Driver) const {
    if (options.outputFilePath.empty()) {
      throw std::logic_error("Output file path cannot be empty");
    }
    std::ofstream outputFile;
    outputFile.open(options.outputFilePath.at(OutputLanguage::Type::Sql),std::ofstream::out);
    if (!outputFile.is_open()) {
      throw std::logic_error("Output file is not opened");
    }
    for (auto tableMetaData : *shPtr2Driver->shPtr2VecOfShPtr2Table) {
      for (auto op: DatabaseOperation::allType) {
        for (auto at: Access::allType) {
          if (DatabaseOperation::compatibleAccessType(op,at)) {
            generateCreateProcedureOrFunction(outputFile,options,shPtr2Driver,tableMetaData,op,at);
            generateProcessing(outputFile,options,shPtr2Driver,tableMetaData,op,at,ProcessingStep::Phase::declaration);
            generateContextCheckParameters(outputFile,options,shPtr2Driver,tableMetaData,op,at);
            generateProcessing(outputFile,options,shPtr2Driver,tableMetaData,op,at,ProcessingStep::Phase::preProcessing);
            generateOperation(outputFile,options,shPtr2Driver,tableMetaData,op,at);
            generateProcessing(outputFile,options,shPtr2Driver,tableMetaData,op,at,ProcessingStep::Phase::postProcessing);
            outputFile << "END;" << std::endl;
            // check context parameters
          }
          outputFile << std::endl;
        }
      }
    }

    outputFile.close();
  }
}
