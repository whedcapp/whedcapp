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
  along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.
*/
#ifndef TABLE_HH
#define TABLE_HH

#include "column.hh"
#include "tableSpecItem.hh"

namespace PartSqlCrudGen {
  class Table {
  private:
    Identity identity;
    ShPtr2Columns shPtr2Columns;
    ShPtr2VecOfShPtr2TableSpecItem shPtr2VecOfShPtr2TableSpecItem;
  public:
    Table(const Identity& identity): identity(identity) {}
    const Identity& getIdentity() const {
      return identity;
    }
    void addShPtr2VecOfShPtr2TableSpecItem(const ShPtr2VecOfShPtr2TableSpecItem& shPtr2VecOfShPtr2TableSpecItem);
    inline ShPtr2Columns getShPtr2Columns() const {
      return shPtr2Columns;
    }

    ShPtr2Column getPrimaryKeyColumn() const;
  
  };

  typedef std::shared_ptr<Table> ShPtr2Table;
  typedef std::vector<ShPtr2Table> VecOfShPtr2Table;
  typedef std::shared_ptr<VecOfShPtr2Table> ShPtr2VecOfShPtr2Table;

  inline std::ostream& operator << (std::ostream& strm, const Table& table) {
    strm << table.getIdentity() << std::endl;
    for (auto& col: *(table.getShPtr2Columns())) {
      strm << "\t" << col->getIdentity() << " " << col->getType().getTypeName() << " Array? = " << col->getType().isArray()  << " PK = " << col->isPrimaryKey() << " NULLABLE = " << col->isNullable() << " AUTO = " << col->isAutoIncrementable() << std::endl;
    }
    return strm;
  }
  
}
#endif
