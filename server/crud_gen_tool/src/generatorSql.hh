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
}

#endif
