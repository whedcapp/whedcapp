/*
    This file is part of Whedcapp - Well-being Health Environment Data Collection App - to collect self-evaluated data for research purpose
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
#include "type.hh"

using namespace PartSqlCrudGen;

std::map<Type::Cat,std::string> Type::e2s = {
  {Type::unknown_sql,"UNKNOWN"},
  {Type::int_sql,"INT"},
  {Type::int_sql,"INTEGER"},
  {Type::tiny_int_sql,"TINYINT"},
  {Type::small_int_sql,"SMALLINT"},
  {Type::medium_int_sql,"MEDIUMINT"},
  {Type::big_int_sql,"BIGINT"},
  {Type::decimal_sql,"DECIMAL"},
  {Type::decimal_sql,"NUMERIC"},
  {Type::float_sql,"FLOAT"},
  {Type::double_sql,"DOUBLE"},
  {Type::bit_sql,"BIT"},
  {Type::date_sql,"DATE"},
  {Type::time_sql,"TIME"},
  {Type::datetime_sql,"DATETIME"},
  {Type::timestamp_sql,"TIMESTAMP"},
  {Type::char_sql,"CHAR"},
  {Type::varchar_sql,"VARCHAR"},
  {Type::binary_sql,"BINARY"},
  {Type::varbinary_sql,"VARBINARY"},
  {Type::blob_sql,"TINYBLOB"},
  {Type::blob_sql,"BLOB"},
  {Type::mediumblob_sql,"MEDIUMBLOB"},
  {Type::longblob_sql,"LONGBLOB"},
  {Type::tinytext_sql,"TINYTEXT"},
  {Type::text_sql,"TEXT"},
  {Type::mediumtext_sql,"MEDIUMTEXT"},
  {Type::longtext_sql,"LONGTEXT"},
  {Type::boolean_sql,"BOOLEAN"}
};
std::map<std::string,Type::Cat> Type::s2e = {
  {"UNKNOWN",Type::unknown_sql},
  {"INT",Type::int_sql},
  {"INTEGER",Type::int_sql},
  {"TINYINT",Type::tiny_int_sql},
  {"SMALLINT",Type::small_int_sql},
  {"MEDIUMINT",Type::medium_int_sql},
  {"BIGINT",Type::big_int_sql},
  {"DECIMAL",Type::decimal_sql},
  {"NUMERIC",Type::decimal_sql},
  {"FLOAT",Type::float_sql},
  {"DOUBLE",Type::double_sql},
  {"BIT",Type::bit_sql},
  {"DATE",Type::date_sql},
  {"TIME",Type::time_sql},
  {"DATETIME",Type::datetime_sql},
  {"TIMESTAMP",Type::timestamp_sql},
  {"CHAR",Type::char_sql},
  {"VARCHAR",Type::varchar_sql},
  {"BINARY",Type::binary_sql},
  {"VARBINARY",Type::varbinary_sql},
  {"TINYBLOB",Type::blob_sql},
  {"BLOB",Type::blob_sql},
  {"MEDIUMBLOB",Type::mediumblob_sql},
  {"LONGBLOB",Type::longblob_sql},
  {"TINYTEXT",Type::tinytext_sql},
  {"TEXT",Type::text_sql},
  {"MEDIUMTEXT",Type::mediumtext_sql},
  {"LONGTEXT",Type::longtext_sql},
  {"BOOLEAN",Type::boolean_sql}
};

const std::string& Type::getTypeName() const {
  try {
    std::string& typeName = e2s.at(cat);
    return typeName;
  } catch (std::out_of_range oore) {
    auto pos = std::find_if(s2e.begin(),
                            s2e.end(),
                            [this](const auto& mo){return mo.second == cat; }
                            );
    if (pos == s2e.end()) {
      throw std::logic_error("Development error: this should not happen, cannot find type category");
    }
    e2s.insert(std::make_pair(pos->second,pos->first));
    return pos->first;
  }
}



  




