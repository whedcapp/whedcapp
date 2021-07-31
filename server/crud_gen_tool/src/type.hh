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
#ifndef TYPE_HH
#define TYPE_HH
#include <algorithm>
#include <iostream>
#include <map>
#include <stdexcept>
#include "common.hh"

namespace PartSqlCrudGen {
  class Type {
  private:
    bool array;
    int size;
  public:
    enum Cat {
      unknown_sql,int_sql, tiny_int_sql, small_int_sql,
      medium_int_sql, big_int_sql,
      float_sql, double_sql, decimal_sql,
      bit_sql,
      date_sql, time_sql, datetime_sql, timestamp_sql, year_sql,
      char_sql, varchar_sql,
      binary_sql, varbinary_sql,
      tinyblob_sql, blob_sql, mediumblob_sql, longblob_sql,
      tinytext_sql, text_sql, mediumtext_sql, longtext_sql,
      boolean_sql };
  private:
    Cat cat;
    static std::map<Cat,std::string> e2s;
    static std::map<std::string,Cat> s2e;
    void initCat(const std::string& typeName) {
      std::string t = toupper(typeName);
      try {
        cat = s2e.at(t);
      } catch (std::out_of_range oore) {
        throw std::domain_error("The type \""+typeName+"\" does not exist");
      }
    }
  public:
    Type(): array(false), size(0), cat(unknown_sql)  {}
    Type(const std::string& typeName): array(false), size(0), cat(s2e.at(toupper(typeName)))  {
      initCat(typeName);
    }
    Type(const std::string& typeName, int size): array(true), size(size), cat(s2e.at(toupper(typeName)))  {
      initCat(typeName);
    }
    Type(const Type& type): array(type.array), size(type.size), cat(type.cat) {}
    Type(const Cat cat): array(false), size(0), cat(cat) {}

    const std::string& getTypeName() const;
    inline bool isArray() const {
      return array;
    }
    inline int getSize() const {
      return size;
    }

    // These should no be necessary:
    friend bool operator==(const Type& lhs, const Type& rhs);
    friend bool operator<(const Type& lhs, const Type& rhs);
    friend bool operator>(const Type& lhs, const Type& rhs);
  };

  inline std::ostream& operator << (std::ostream& strm, const PartSqlCrudGen::Type& tp) {
    
    strm << tp.getTypeName();
    if (tp.isArray()) {
      strm << "(" << tp.getSize() << ")";
    }
    return strm;
  }


  inline bool operator==(const Type& lhs, const Type& rhs) {
    return lhs.cat == rhs.cat;
  }
  inline bool operator!=(const Type& lhs, const Type& rhs) {
    return !(lhs == rhs);
  }
  inline bool operator<(const Type& lhs, const Type& rhs) {
    return lhs.cat<rhs.cat;
  }
  inline bool operator>(const Type& lhs, const Type& rhs) {
    return lhs.cat>rhs.cat;
  }
  inline bool operator<=(const Type& lhs, const Type& rhs) {
    return !(lhs>rhs);
  }
  inline bool operator>=(const Type& lhs, const Type& rhs) {
    return !(lhs<rhs);
  }
}

#endif
