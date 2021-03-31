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

  //  enum GenerateKind { onlyColumnParameters, columnParametersWithTypeInformation, columnParametersForUpdate, onlyPrimaryKey, columnParametersForSelect, onlyColumnParametersIncludingId};
  
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

    try {
      // get the context for the domain
      const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
      const auto& tc = ts.getTabCfgTemplate(op);
      const auto& tmplName = tc.getName();
      const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, accessType, tmplName);
      VecOfShPtr2Table& vecOfShPtr2Table = *shPtr2Driver->shPtr2VecOfShPtr2Table;

      /* Iterate over context parameters. TODO: Move to separate private method */
      bool notFirstContextParameter = false;
      for (const auto& par2ref: cp.getVecOfPar2Ref()) {
        if (notFirstContextParameter) {
          str << ", ";
        }
        str << par2ref.first << "_par" << " "; // the name of the parameter
        VecOfShPtr2Table::iterator votit = std::find_if(vecOfShPtr2Table.begin(),
                                                        vecOfShPtr2Table.end(),
                                                        [par2ref](ShPtr2Table shPtr2Table){ return shPtr2Table->getIdentity() == par2ref.second.getTableIdentity(); });
        if (votit == vecOfShPtr2Table.end()) {
          std::ostringstream msg;
          msg << "Table definition \"" << par2ref.second.getTableIdentity() << "\" is missing, either the context parameter reference is incorrect or the table definition is missing";
          throw std::logic_error(msg.str());
        }
        try {
          auto col = (*votit)->getShPtr2Columns()->getShPtr2Column(par2ref.second.getColumnIdentity());
          auto& type = col->getType();
          str << type;
        } catch (const std::out_of_range& oor) {
          std::ostringstream msg;
          msg << "No such column \"" << par2ref.second.getColumnIdentity() <<"\"";
          throw std::logic_error(msg.str());
        }
        
        notFirstContextParameter = true;
      }
      // If there are context parameters, then notFirstContextParameter is true and a comma should
      // be added prior to the rest of the parameters. Note, there must be other parameters.

      // get the parameters for the table and use them as parameters
      VecOfShPtr2Table::iterator votit = std::find_if(vecOfShPtr2Table.begin(),
                                                      vecOfShPtr2Table.end(),
                                                      [tableMetaData](ShPtr2Table shPtr2Table){ return shPtr2Table->getIdentity() == tableMetaData->getIdentity(); });
      if (votit == vecOfShPtr2Table.end()) {
        throw std::logic_error("There must be an table definition missing");
      }
      if (op != DatabaseOperation::Type::dbDelete && op != DatabaseOperation::Type::dbSelect) {
        std::cerr << "Start generating for " << tableMetaData->getIdentity() << std::endl;
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersWithTypeInformationInParameterList =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::columnParametersWithTypeInformationInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter
                                        );
        gclsColumnParametersWithTypeInformationInParameterList->generate();
        std::cerr << "End generating for " << tableMetaData->getIdentity() << std::endl;

      } else if (op == DatabaseOperation::Type::dbDelete) {
        std::unique_ptr<IGenerateColumnList> gclsOnlyPrimaryKeyInParameterList =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::onlyPrimaryKeyInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter
                                        );
        gclsOnlyPrimaryKeyInParameterList->generate();
      } else { // dbSelect
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersForSelectInParameterList =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::columnParametersForSelectInParameterList,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par",
                                        notFirstContextParameter
                                        );
        gclsColumnParametersForSelectInParameterList->generate();
        
      }
      str << ")"  << (op == DatabaseOperation::Type::dbInsert? " RETURNS INTEGER DETERMINISTIC MODIFIES SQL DATA ":"") << std::endl << "BEGIN" << std::endl;
    } catch (const std::out_of_range& oore) {
      std::ostringstream msg;
      msg << "Something missing in the configuration, candidates are: no table specification item for \""
          << tableMetaData->getIdentity().getSecondary() << "\", no table configuration template for \""
          << op << "\", not context parameter for \"SQL\" for \"" << accessType<< "\"" << std::endl;
      throw ConfigurationException(msg.str());
    }
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
    const auto& tc = ts.getTabCfgTemplate(op);
    const auto& tmplName = tc.getName();
    const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, at, tmplName);
    switch (op) {
    case DatabaseOperation::Type::dbInsert:
      {
        str << std::setw(options.outputCodeTabWidth) << " " << "INSERT INTO " << tableMetaData->getIdentity().getBackquoted() << " ( ";
        std::unique_ptr<IGenerateColumnList> gclsOnlyColumnParameters =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::onlyColumnParameters,
                                        str,
                                        tableMetaData,
                                        cp
                                        );
        gclsOnlyColumnParameters->generate();
        str << ")" << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "VALUES (";
        std::unique_ptr<IGenerateColumnList> gclsOnlyColumnParameters2 =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::onlyColumnParameters,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par"
                                        );
        gclsOnlyColumnParameters2->generate();
        str << ");";
      }
      break;
    case DatabaseOperation::Type::dbUpdate:
      {
        const auto& ts = options.getConfiguration().getTableSpec(tableMetaData->getIdentity().getSecondary());
        const auto& tc = ts.getTabCfgTemplate(op);
        const auto& tmplName = tc.getName();
        const auto& cp = options.getConfiguration().getContextParameter(OutputLanguage::Type::Sql, at, tmplName);
        str << std::setw(options.outputCodeTabWidth) << " " << "UPDATE " << tableMetaData->getIdentity().getBackquoted() << std::endl;
        str << std::setw(options.outputCodeTabWidth*2) << " " << "SET " << std::endl;
        str << std::setw(options.outputCodeTabWidth*3) << " ";
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersForUpdate =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::columnParametersForUpdate,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par"
                                        );
        gclsColumnParametersForUpdate->generate();
        
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
        str << std::setw(options.outputCodeTabWidth*2) << " " << "WHERE "; // << tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() << " = " <<  tableMetaData->getPrimaryKeyColumn()->getIdentity().getPrimary() << "_par;" << std::endl;
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersForDelete =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::columnParametersForDelete,
                                        str,
                                        tableMetaData,
                                        cp,
                                        "_par"
                                        );
        gclsColumnParametersForDelete->generate();
        str << ";" << std::endl;
      }
      break;
    case DatabaseOperation::Type::dbSelect:
      {
        str << std::setw(options.outputCodeTabWidth) << " "  << "SELECT ";
        //generateColumnList(str,tableMetaData->getShPtr2Columns(),GenerateKind::onlyColumnParametersIncludingId);
        std::unique_ptr<IGenerateColumnList> gclsColumnParametersIncludingIdForSelect =
          GenerateColumnListSql::create(
                                        IGenerateColumnList::GenerateKind::onlyColumnParametersIncludingIdForSelect,
                                        str,
                                        tableMetaData,
                                        cp
                                        );
        gclsColumnParametersIncludingIdForSelect->generate();
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
          str << std::setw(options.outputCodeTabWidth*5) << " " << "( " << c->getIdentity() << "_par is not null AND " << c->getIdentity() << "_par_cmp is not null";
          bool notFirst2 = false;
          for (const auto& ro: RelationalOperator::allRealOperatorType) {
            if (notFirst2) {
              str << " OR " << std::endl;
            } else {
              str << " AND " << std::endl;
            }
            str
              << std::setw(options.outputCodeTabWidth*6)
              << " "  << "( ";
            str
              << c->getIdentity()
              << "_par_cmp = \""
              << RelationalOperator::getStringFromType(OutputLanguage::Type::Sql,ro)
              << "\" AND "
              << c->getIdentity().getBackquoted()
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
    outputFile << "DELIMITER $$" << std::endl;
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
          outputFile << std::endl << "$$" << std::endl;
        }
      }
    }
    outputFile << "DELIMITER ;" << std::endl;


    outputFile.close();
  }

  const bool GenerateColumnListSql::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return true;
  }
  const bool GenerateColumnListSql::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }
  std::ostream& GenerateColumnListSql::generateColumn(const ShPtr2Column& shPtr2Column)  {
    getStr() << shPtr2Column->getIdentity().getBackquoted(getSuffix());
    return getStr();
  }

  std::unique_ptr<IGenerateColumnList> GenerateColumnListSql::create(IGenerateColumnList::GenerateKind generateKind,std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter, const std::string& suffix, bool notFirst ) {
    switch(generateKind) {
    case onlyColumnParameters:
      return std::make_unique<GclsOnlyColumnParameters>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case columnParametersWithTypeInformationInParameterList:
      return std::make_unique<GclsColumnParametersWithTypeInformationInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case columnParametersForUpdate:
      return std::make_unique<GclsColumnParametersForUpdate>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case onlyPrimaryKeyInParameterList:
      return std::make_unique<GclsOnlyPrimaryKeyInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case columnParametersForSelectInParameterList:
      return std::make_unique<GclsColumnParametersForSelectInParameterList>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case onlyColumnParametersIncludingIdForSelect:
      return std::make_unique<GclsColumnParametersIncludingIdForSelect>(str,shPtr2Table, optContextParameter, suffix,notFirst);
    case columnParametersForDelete:
      return std::make_unique<GclsColumnParametersForDelete>(str,shPtr2Table,optContextParameter,suffix,notFirst);
    default:
      return nullptr;
    }
  }

  const bool GclsOnlyColumnParameters::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return !shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  const bool GclsColumnParametersWithTypeInformationInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const  {
    std::cerr << shPtr2Column->getIdentity() << "=> pk = " << shPtr2Column->isPrimaryKey() << ", cp = " << isContextParameter(shPtr2Column) << std::endl;
    return !shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  std::ostream& GclsColumnParametersWithTypeInformationInParameterList::generateColumn(const ShPtr2Column& shPtr2Column)  {
    GclsOnlyColumnParameters::generateColumn(shPtr2Column);
    getStr() << " " << shPtr2Column->getType();
    return getStr();
  }

  // true if not primary key or not covered by a context parameter
  const bool GclsColumnParametersForUpdate::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {

    if (!getOptContextParameter().has_value()) {
      throw  std::logic_error("Context parameter is not set");
    }
    return !shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }
  // true if not primary key and coverered by a context parameter
  const bool  GclsColumnParametersForUpdate::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return !shPtr2Column->isPrimaryKey() && isContextParameter(shPtr2Column);
  }
  // set attribute = parameter
  std::ostream&  GclsColumnParametersForUpdate::generateColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << shPtr2Column->getIdentity().getBackquoted();
    getStr() << " = " << shPtr2Column->getIdentity().getBackquoted(getSuffix());
    return getStr();
  }
  // set attribute = context parameter (replacement of parameter)
  std::ostream&  GclsColumnParametersForUpdate::generateReplacementColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << shPtr2Column->getIdentity().getBackquoted();
    // if needed, this can be optimized away by passing the iterator
    // from a modified version of shouldReplacementAttributeBeListed
    // however, this performance increase is small, the advantage
    // is one place to modify the condition, but the cost is a less
    // understandable design
    const auto& vecOfPar2Ref = getOptContextParameter()->getVecOfPar2Ref();
    const auto& contextParInfoIt = std::find_if(vecOfPar2Ref.begin(),vecOfPar2Ref.end(),[this,shPtr2Column](const auto par2Ref) { return par2Ref.second.getColumnIdentity() == shPtr2Column->getIdentity() ; });
    Identity replacementId(contextParInfoIt->first);
    getStr() << " = " << replacementId.getBackquoted(getSuffix());
    return getStr();
      
  }

  const bool GclsOnlyPrimaryKeyInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }

  const bool GclsOnlyPrimaryKeyInParameterList::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }

  std::ostream& GclsOnlyPrimaryKeyInParameterList::generateColumn(const ShPtr2Column& shPtr2Column) {
    GclsOnlyColumnParameters::generateColumn(shPtr2Column);
    getStr() << " " << shPtr2Column->getType();
    return getStr();
  }
  
  const bool GclsColumnParametersForSelectInParameterList::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return !isContextParameter(shPtr2Column);
  }

  const bool GclsColumnParametersForSelectInParameterList::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }

  std::ostream& GclsColumnParametersForSelectInParameterList::generateColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << " " << shPtr2Column->getIdentity().getBackquoted(getSuffix()+"_cmp") << " VARCHAR(3), ";
    GclsOnlyColumnParameters::generateColumn(shPtr2Column);
    getStr() << " " << shPtr2Column->getType();
    return getStr();
  }
  
  const bool GclsColumnParametersIncludingIdForSelect::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return true;
  }
  const bool GclsColumnParametersIncludingIdForSelect::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return false;
  }

  // true if not primary key or not covered by a context parameter
  const bool GclsColumnParametersForDelete::shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const {

    if (!getOptContextParameter().has_value()) {
      throw  std::logic_error("Context parameter is not set");
    }
    return shPtr2Column->isPrimaryKey() && !isContextParameter(shPtr2Column);
  }
  // true if not primary key and coverered by a context parameter
  const bool  GclsColumnParametersForDelete::shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const {
    return shPtr2Column->isPrimaryKey() && isContextParameter(shPtr2Column);
  }
  // set attribute = parameter
  std::ostream&  GclsColumnParametersForDelete::generateColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << shPtr2Column->getIdentity().getBackquoted();
    getStr() << " = " << shPtr2Column->getIdentity().getBackquoted(getSuffix());
    return getStr();
  }
  // set attribute = context parameter (replacement of parameter)
  std::ostream&  GclsColumnParametersForDelete::generateReplacementColumn(const ShPtr2Column& shPtr2Column) {
    getStr() << shPtr2Column->getIdentity().getBackquoted();
    // if needed, this can be optimized away by passing the iterator
    // from a modified version of shouldReplacementAttributeBeListed
    // however, this performance increase is small, the advantage
    // is one place to modify the condition, but the cost is a less
    // understandable design
    const auto& vecOfPar2Ref = getOptContextParameter()->getVecOfPar2Ref();
    const auto& contextParInfoIt = std::find_if(vecOfPar2Ref.begin(),vecOfPar2Ref.end(),[this,shPtr2Column](const auto par2Ref) { return par2Ref.second.getColumnIdentity() == shPtr2Column->getIdentity() ; });
    Identity replacementId(contextParInfoIt->first);
    getStr() << " = " << replacementId.getBackquoted(getSuffix());
    return getStr();
      
  }
  
}
