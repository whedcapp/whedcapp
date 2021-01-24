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
#include <typeinfo>
#include "table.hh"

namespace PartSqlCrudGen {

  void Table::addShPtr2VecOfShPtr2TableSpecItem(const ShPtr2VecOfShPtr2TableSpecItem& shPtr2VecOfShPtr2TableSpecItem) {
    this->shPtr2VecOfShPtr2TableSpecItem = shPtr2VecOfShPtr2TableSpecItem;
    // find the columns
    shPtr2Columns = std::make_shared<Columns>();
    for (auto sp2tsi: *shPtr2VecOfShPtr2TableSpecItem) {
      if (typeid(*sp2tsi) == typeid(ColumnTableSpecItem)) {
        ColumnTableSpecItem & ctsi = *static_cast<ColumnTableSpecItem*>(sp2tsi.get());
        shPtr2Columns->addColumn(ctsi.getShPtr2Column());
      }
    }
    // find primary key and foreign keys
    for (auto sp2tsi: *shPtr2VecOfShPtr2TableSpecItem) {
      if (sp2tsi->isAdaptor()) {
        auto shPtr2Column = shPtr2Columns->getShPtr2Column(sp2tsi->getColumnIdentity());
        sp2tsi->adaptColumn(*shPtr2Column);
        shPtr2Columns->getShPtr2Column(sp2tsi->getColumnIdentity())->setPrimaryKey(true);
      } 
    }
  }

  ShPtr2Column Table::getPrimaryKeyColumn() const {
    for (auto& c: *shPtr2Columns) {
      if (c->isPrimaryKey()) {
        return c;
      }
    }
    throw std::logic_error("Table must have a primary key");
      
  }
}

