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
#ifndef TABLESPECITEM_HH
#define TABLESPECITEM_HH

#include <algorithm>
#include <map>
#include <memory>
#include <optional>

#include "column.hh"
#include "identity.hh"
#include "reference.hh"

namespace PartSqlCrudGen {
  class TableSpecItem {
  private:
    Identity identity;
  public:
    TableSpecItem(const Identity& identity): identity(identity) {}
    inline const Identity & getIdentity() const {
      return identity;
    }
    virtual void writeStream(std::ostream& os) {
      os << getIdentity();
    }
    virtual void adaptColumn(Column& column) {
    }
    virtual const Identity& getColumnIdentity() {
      throw std::logic_error("TableSpecItem is a base class");
    }
    virtual const bool isColumnTableSpecItem() {
      return false;
    }
    virtual const bool isAdaptor() {
      return false;
    }
  
  };

  class ColumnTableSpecItem: public TableSpecItem {
  private:
    ShPtr2Column shPtr2Column;
  public:
    ColumnTableSpecItem(const Identity identity, const ShPtr2Column& shPtr2Column): TableSpecItem(identity),shPtr2Column(shPtr2Column) {}
    inline const Column& getColumn() const {
      return *shPtr2Column.get();
    }
    inline ShPtr2Column getShPtr2Column() const {
      return shPtr2Column;
    }
    void writeStream(std::ostream& os) {
      os << getIdentity() << "(" << shPtr2Column->getIdentity();
    }
    const Identity& getColumnIdentity() {
      throw std::logic_error("TableSpecItem has no column identity");
    }
    const bool isColumnTableSpecItem() {
      return true;
    }
  };

  class IndexTableSpecItem: public TableSpecItem {
  public:
    IndexTableSpecItem(const Identity identity): TableSpecItem(identity) {}
  };

  class ForeignKeyConstraintTableSpecItem: public TableSpecItem {
  private:
    ShPtr2Reference shPtr2Reference;
    std::optional<Identity> columnIdentity;
  public:
    ForeignKeyConstraintTableSpecItem(const Identity&& identity): TableSpecItem(identity) {}
    ForeignKeyConstraintTableSpecItem(const Identity& identity, const Identity& columnIdentity, const ShPtr2Reference& shPtr2Reference): TableSpecItem(identity), shPtr2Reference(shPtr2Reference),   columnIdentity(columnIdentity)  {}
    ~ForeignKeyConstraintTableSpecItem() {
      shPtr2Reference.reset();
    }
    inline ShPtr2Reference getShPtr2Reference() {
      return shPtr2Reference;
    }
    void adaptColumn(Column& column) {
      column.setForeignKey(true);
      column.addReference(shPtr2Reference);
    }
    const Identity& getColumnIdentity() {
      return columnIdentity.value();
    }
    const bool isAdaptor() {
      return true;
    }
  
  };

  class CheckConstraintTableSpecItem: public TableSpecItem {
  public:
    CheckConstraintTableSpecItem(const Identity& identity): TableSpecItem(identity) {}
    CheckConstraintTableSpecItem(const Identity&& identity): TableSpecItem(identity) {}

  
  };

  class PrimaryKeyTableSpecItem: public TableSpecItem {
  public:
    PrimaryKeyTableSpecItem(const Identity& identity): TableSpecItem(identity) {}
    const Identity & getPrimaryKeyColumnIdentity() const {
      return getIdentity();
    }
    void adaptColumn(Column& column) {
      column.setPrimaryKey(true);
    }
    const Identity& getColumnIdentity() {
      return getIdentity();
    }
    const bool isAdaptor() {
      return true;
    }
  };

  typedef std::shared_ptr<TableSpecItem> ShPtr2TableSpecItem;

  class VecOfShPtr2TableSpecItem;

  typedef std::shared_ptr<VecOfShPtr2TableSpecItem> ShPtr2VecOfShPtr2TableSpecItem;

  class VecOfShPtr2TableSpecItem {
  private:
    std::vector<ShPtr2TableSpecItem> vecOfShPtr2TableSpecItem;
    std::multimap<Identity,ShPtr2TableSpecItem> i2ShPtr2TableSpecItem;;
  public:
    inline void addTableSpecItem(const ShPtr2TableSpecItem& shPtr2TableSpecItem) {
      vecOfShPtr2TableSpecItem.push_back(shPtr2TableSpecItem);
      i2ShPtr2TableSpecItem.insert(std::make_pair(shPtr2TableSpecItem.get()->getIdentity(),shPtr2TableSpecItem));
    }
    inline void prependTableSpecItem(const ShPtr2TableSpecItem& shPtr2TableSpecItem) {
      vecOfShPtr2TableSpecItem.emplace(vecOfShPtr2TableSpecItem.begin(),shPtr2TableSpecItem);
      i2ShPtr2TableSpecItem.insert(std::make_pair(shPtr2TableSpecItem.get()->getIdentity(),shPtr2TableSpecItem));
    }
    const std::vector<ShPtr2TableSpecItem> & getVecOfShPtr2TableSpecItem() {
      return vecOfShPtr2TableSpecItem;
    }
    const std::multimap<Identity,ShPtr2TableSpecItem>& getIdentity2ShPtr2TableSpecItem() {
      return i2ShPtr2TableSpecItem;
    }
    const ShPtr2TableSpecItem operator[](int index) {
      return vecOfShPtr2TableSpecItem[index];
    }
    const ShPtr2TableSpecItem operator[](const Identity& identity) {
      return i2ShPtr2TableSpecItem.find(identity)->second;
    }
    std::vector<ShPtr2TableSpecItem>::iterator begin() noexcept {
      return vecOfShPtr2TableSpecItem.begin();
    }
    std::vector<ShPtr2TableSpecItem>::const_iterator begin() const noexcept {
      return vecOfShPtr2TableSpecItem.begin();
    }
    std::vector<ShPtr2TableSpecItem>::iterator end() noexcept {
      return vecOfShPtr2TableSpecItem.end();
    }
    std::vector<ShPtr2TableSpecItem>::const_iterator end() const noexcept {
      return vecOfShPtr2TableSpecItem.end();
    }
    std::vector<ShPtr2TableSpecItem>::reverse_iterator rbegin() noexcept { 
      return vecOfShPtr2TableSpecItem.rbegin();
    }
    std::vector<ShPtr2TableSpecItem>::const_reverse_iterator rbegin() const noexcept {
      return vecOfShPtr2TableSpecItem.rbegin();
    }
    std::vector<ShPtr2TableSpecItem>::reverse_iterator rend() noexcept {
      return vecOfShPtr2TableSpecItem.rend();
    }
    std::vector<ShPtr2TableSpecItem>::const_reverse_iterator rend() const noexcept {
      return vecOfShPtr2TableSpecItem.rend();
    }

  };

}

#endif
