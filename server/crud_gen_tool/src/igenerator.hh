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
#ifndef IGENERATOR_HH
#define IGENERATOR_HH

#include <memory>

#include "driver.hh"
#include "options.hh"

namespace PartSqlCrudGen {
  class IGenerator {
  public:
    virtual void generate(const Options& options, const std::shared_ptr<Driver>& shPtr2Driver) const = 0;
    static std::unique_ptr<IGenerator> create(const std::string& cfg);
  };
  class IGenerateColumnList {
  public:
    IGenerateColumnList();
    enum GenerateKind { onlyColumnParameters,
                        columnParametersWithTypeInformation,
                        columnParametersForUpdate,
                        onlyPrimaryKey,
                        columnParametersForSelect,
                        onlyColumnParametersIncludingId};
    virtual std::ostream& generatePrefix() = 0;
    virtual const bool shouldAttributeBeListed(const ShPtr2Column& shPtr2Column) const = 0;
    virtual const bool shouldReplacementAttributeBeListed(const ShPtr2Column& shPtr2Column) const = 0;
    virtual std::ostream& generateColumn(const ShPtr2Column& shPtr2Column) = 0;
    virtual std::ostream& generateReplacementColumn(const ShPtr2Column& shPtr2Column) = 0;
    virtual std::ostream& generateColumnList() = 0;
    virtual std::ostream& generateSuffix() = 0;
    virtual std::ostream& generate() = 0;
  };

  class GenerateColumnList: public IGenerateColumnList {
    bool notFirst;
    bool lastConsideredAttributeListed;
    std::ostream& str;
    ShPtr2Table shPtr2Table;
    ShPtr2Columns shPtr2Columns;
    std::optional<ContextParameter> optContextParameter;
    std::string suffix;    
  protected:
    GenerateColumnList(std::ostream& str,const ShPtr2Table& shPtr2Table,const std::optional<ContextParameter>& optContextParameter = std::nullopt, const std::string& suffix = "",bool notFirst = false): IGenerateColumnList(),notFirst(notFirst),lastConsideredAttributeListed(false),str(str),shPtr2Table(shPtr2Table),optContextParameter(optContextParameter),suffix(suffix) {}
  public:
    inline bool getNotFirst() const {
      return this->notFirst;
    }
    inline void setNotFirst() {
      this->notFirst = true;
    }
    inline bool getLastConsideredAttributeListed() {
      return lastConsideredAttributeListed;
    }
    inline void setLastConsideredAttributeListed() {
      this->lastConsideredAttributeListed = true;
    }
    inline void unsetLastConsideredAttributeListed() {
      this->lastConsideredAttributeListed = false;
    }
    inline std::ostream& getStr() {
      return str;
    }
    inline const ShPtr2Table& getShPtr2Table() const {
      return shPtr2Table;
    }
    inline const ShPtr2Columns getShPtr2Columns() const {
      return shPtr2Table->getShPtr2Columns();
    }
    inline const std::optional<ContextParameter>& getOptContextParameter() const {
      return optContextParameter;
    }
    inline const std::string& getSuffix() const {
      return suffix;
    }
    const bool isContextParameter(const ShPtr2Column& shPtr2Column) const;
    std::ostream& generatePrefix() override;
    std::ostream& generateColumn(const ShPtr2Column& shPtr2Column)  override;
    std::ostream& generateReplacementColumn(const ShPtr2Column& shPtr2Column) override;
    std::ostream& generateColumnList() override;
    std::ostream& generateSuffix() override;
    std::ostream& generate() override;
  };
}

#endif
