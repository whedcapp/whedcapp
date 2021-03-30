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
#include "common.hh"
#include "igenerator.hh"
#include "generatorSql.hh"

namespace PartSqlCrudGen {

  std::unique_ptr<IGenerator> IGenerator::create(const std::string& cfg) {
    std::string tmp = toupper(cfg);
    if (tmp == "SQL") {
      return std::make_unique<GeneratorSql>();
    }
    throw std::logic_error("Configuration string \""+cfg+"\" is not implemented yet");
  }

  IGenerateColumnList::IGenerateColumnList() {}

  const bool GenerateColumnList::isContextParameter(const ShPtr2Column& shPtr2Column) const {
    const auto& vecOfPar2Ref = getOptContextParameter()->getVecOfPar2Ref();
    const bool isContextParameter =
      std::any_of(
                  vecOfPar2Ref.begin(),
                  vecOfPar2Ref.end(),
                  [this,shPtr2Column](const auto par2Ref) {
                    return
                      par2Ref.second.getColumnIdentity() == shPtr2Column->getIdentity()
                      && par2Ref.second.getTableIdentity() == this->getShPtr2Table()->getIdentity();
                  }
                  );
    return isContextParameter;
  }

  std::ostream& GenerateColumnList::generatePrefix() {
    return getStr();
  }

  std::ostream& GenerateColumnList::generateSuffix() {
    return getStr();
  }

  std::ostream& GenerateColumnList::generateColumn(const ShPtr2Column& shPtr2Column)  {
    getStr() << shPtr2Column->getIdentity();
    return getStr();
  }

  std::ostream& GenerateColumnList::generateReplacementColumn(const ShPtr2Column& shPtr2Column) {
    return getStr();
  }

  std::ostream& GenerateColumnList::generateColumnList() {
    for (const auto& col: *(getShPtr2Columns())) {
      if (shouldAttributeBeListed(col)) {
        if (getNotFirst()) {
          std::cerr << getShPtr2Table()->getIdentity() << "." << col->getIdentity() << " has a comma " << std::endl;
          getStr() << ", ";
        }
        generateColumn(col);
        setNotFirst();
      } else if (shouldReplacementAttributeBeListed(col)) {
        if (getNotFirst()) {
          getStr() << ", ";
        }
        generateReplacementColumn(col);
        setNotFirst();
      }
      
    }
    return getStr();
  }

  std::ostream& GenerateColumnList::generate() {
    generatePrefix();
    generateColumnList();
    generateSuffix();
    return getStr();
  }
}
