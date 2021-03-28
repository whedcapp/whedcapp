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
#ifndef GENERATOR_SQL_HH
#define GENERATOR_SQL_HH
#include <memory>
#include "driver.hh"
#include "igenerator.hh"
#include "options.hh"

namespace PartSqlCrudGen {

  class GeneratorSql: public IGenerator {
  private:
    std::ostream& generateCreateProcedureOrFunction(std::ostream& str,
                                                    const Options& options,
                                                    const std::shared_ptr<Driver>& shPtr2Driver,
                                                    const ShPtr2Table& tableMetaData,
                                                    const DatabaseOperation::Type& op,
                                                    const Access::Type& accessType) const;
    std::ostream& generateContextCheckParameters(std::ostream& str,
                                                 const Options& options,
                                                 const std::shared_ptr<Driver>& shPtr2Driver,
                                                 const ShPtr2Table& tableMetaData,
                                                 const DatabaseOperation::Type& op,
                                                 const Access::Type& at) const;
    std::ostream& generateOperation(std::ostream& str,
                                    const Options& options,
                                    const std::shared_ptr<Driver>& shPtr2Driver,
                                    const ShPtr2Table& tableMetaData,
                                    const DatabaseOperation::Type& op,
                                    const Access::Type& at) const;
    std::ostream& generateProcessing(std::ostream& str,
                                     const Options& options,
                                     const std::shared_ptr<Driver>& shPtr2Driver,
                                     const ShPtr2Table& tableMetaData,
                                     const DatabaseOperation::Type& op,
                                     const Access::Type& at,
                                     const ProcessingStep::Phase& phase) const;
  public:
    void generate(const PartSqlCrudGen::Options& options, const std::shared_ptr<PartSqlCrudGen::Driver>& shPtr2Driver) const override;
  };


  class GclsOnlyColumnParameters;
  class GenerateColumnListSql: public GenerateColumnList {
    friend GclsOnlyColumnParameters;
  public:
    GenerateColumnListSql(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GenerateColumnList(str, shPtr2Table,optContextParameter,suffix) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column)  override;
    static std::unique_ptr<IGenerateColumnList> create(IGenerateColumnList::GenerateKind generateKind,std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "");
    
  };
  // Only column parameters without primary key for, for example
  // INSERT INTO column specification.
  class GclsOnlyColumnParameters: public GenerateColumnListSql {
  public:
    GclsOnlyColumnParameters(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GenerateColumnListSql(str,shPtr2Table, optContextParameter, suffix) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    
  };

  class GclsColumnParametersWithTypeInformation: public GclsOnlyColumnParameters {
  public:
    GclsColumnParametersWithTypeInformation(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GclsOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix) {}
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column)  override;
  };

  class GclsColumnParametersForUpdate: public GclsOnlyColumnParameters {
  public:
    GclsColumnParametersForUpdate(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GclsOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column) override;
    std::ostream& generateReplacementColumn(const ShPtr2Column& shPtr2Column) override;
    
  };

  class GclsOnlyPrimaryKey: public GclsOnlyColumnParameters {
  public:
    GclsOnlyPrimaryKey(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GclsOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    
  };

  class GclsColumnParametersForSelect: public GclsOnlyColumnParameters {
  public:
    GclsColumnParametersForSelect(std::ostream& str, const ShPtr2Table& shPtr2Table, const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = ""): GclsOnlyColumnParameters(str,shPtr2Table, optContextParameter, suffix) {}
    const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column) override;
    
  };

}
#endif
