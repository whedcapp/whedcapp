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

#include "relationalOperator.hh"

namespace PartSqlCrudGen {
  std::map<OutputLanguage::Type,std::map<RelationalOperator::Type,std::string>> RelationalOperator::o2t2s{
    { OutputLanguage::Type::Sql,
        {
          {RelationalOperator::Type::nop, "NOP"}, {RelationalOperator::Type::eq, "="}, {RelationalOperator::Type::ne, "<>"}, {RelationalOperator::Type::lt, "<"}, {RelationalOperator::Type::le, "<="}, {RelationalOperator::Type::gt, ">"}, {RelationalOperator::Type::ge, ">="}
        }
    },
    { OutputLanguage::Type::Dart,
        { {RelationalOperator::Type::nop, "NOP"}, {RelationalOperator::Type::eq, "=="}, {RelationalOperator::Type::ne, "!="}, {RelationalOperator::Type::lt, "<"}, {RelationalOperator::Type::le, "<="}, {RelationalOperator::Type::gt, ">"}, {RelationalOperator::Type::ge, ">="}
        }
    }
  };
  std::map<OutputLanguage::Type,std::map<std::string,RelationalOperator::Type>> RelationalOperator::o2s2t{
    { OutputLanguage::Type::Sql,
        {
          {"NOP", RelationalOperator::Type::nop}, {"=", RelationalOperator::Type::eq}, {"<>", RelationalOperator::Type::ne}, {"<", RelationalOperator::Type::lt}, {"<=", RelationalOperator::Type::le}, {">", RelationalOperator::Type::gt}, {">=", RelationalOperator::Type::ge}
        }
    },
    { OutputLanguage::Type::Dart,
        {
          {"NOP", RelationalOperator::Type::nop}, {"==", RelationalOperator::Type::eq}, {"!=", RelationalOperator::Type::ne}, {"<", RelationalOperator::Type::lt}, {"<=", RelationalOperator::Type::le}, {">", RelationalOperator::Type::gt}, {">=", RelationalOperator::Type::ge}
        }
    }
  };
  
}
