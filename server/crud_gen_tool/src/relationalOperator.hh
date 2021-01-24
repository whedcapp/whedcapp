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

#include <map>

#include "configuration.hh"



#ifndef RELATION_OPERATOR_HH
#define RELATION_OPERATOR_HH
namespace PartSqlCrudGen {
  class RelationalOperator {
  public:
    enum Type { nop,eq,ne,lt,le,gt,ge };
    static constexpr std::initializer_list<Type> allType { nop, eq, ne, lt, le, gt, ge };
    static constexpr std::initializer_list<Type> allRealOperatorType { eq, ne, lt, le, gt, ge };
  private:
    Type type;
    static std::map<OutputLanguage::Type,std::map<Type,std::string>> o2t2s;
    static std::map<OutputLanguage::Type,std::map<std::string,Type>> o2s2t;
  public:
    RelationalOperator(const Type& type): type(type) {}
    RelationalOperator(const RelationalOperator& relationalOperator): type(relationalOperator.type) {}
    const Type getType() const {
      return type;
    }
    static const std::string& getStringFromType(const OutputLanguage::Type& outputLanguage, const Type& type) {
      return o2t2s.at(outputLanguage).at(type);
    }
    static const Type& getTypeFromString(const OutputLanguage::Type& outputLanguage, const std::string& str) {
      return o2s2t.at(outputLanguage).at(str);
    }

  };
  inline bool operator<(const RelationalOperator& lhs, const RelationalOperator& rhs) {
    return lhs.getType()<rhs.getType();
  }
}
  
#endif
