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
#ifndef COLUMN_HH
#define COLUMN_HH

#include <optional>
#include <set>
#include <stdexcept>
#include "identity.hh"
#include "reference.hh"
#include "type.hh"
namespace PartSqlCrudGen {
  class Column {
  private:
    class Cmp {
    public:
      bool operator() (ShPtr2Reference sp2r1, ShPtr2Reference sp2r2) {
        return (sp2r1->getTableIdentity()<sp2r2->getTableIdentity()) ||
          (sp2r1->getTableIdentity()==sp2r2->getTableIdentity() &&
           sp2r1->getColumnIdentity()<sp2r2->getColumnIdentity());
      }
    };
    Identity identity;
    Type type;
    bool primaryKey = false;
    bool nullable = true;
    bool foreignKey = false;
    bool autoIncrementable = false;
    static constexpr auto cmp = [](ShPtr2Reference sp2r1, ShPtr2Reference sp2r2) {
      return (sp2r1->getTableIdentity()<sp2r2->getTableIdentity()) ||
      (sp2r1->getTableIdentity()==sp2r2->getTableIdentity() &&
       sp2r1->getColumnIdentity()<sp2r2->getColumnIdentity());
    };
    std::set<ShPtr2Reference,Cmp> refSet;
  public:
    Column(const Identity& identity, const Type& type): identity(identity), type(type) {}
    inline const Identity& getIdentity() const {
      return identity;
    }
    inline const Type& getType() const {
      return type;
    }
    inline void setPrimaryKey(bool flag) {
      primaryKey = flag;
    }
    inline bool isPrimaryKey() {
      return primaryKey;
    }
    inline void setNullable(bool flag) {
      nullable = flag;
    }
    inline const bool isNullable() const {
      return nullable;
    }
    inline void setForeignKey(bool flag) {
      foreignKey = flag;
    }
    void addReference(ShPtr2Reference ref) {
      refSet.insert(ref);
    }
    const std::set<ShPtr2Reference,Cmp> & getRefSet() {
      return refSet;
    }
    inline void setAutoIncrementable(bool flag) {
      autoIncrementable = flag;
    }
    inline bool isAutoIncrementable() {
      return autoIncrementable;
    }
    
  };

  typedef std::shared_ptr<Column> ShPtr2Column;

  class Columns {
  private:
    std::vector<std::shared_ptr<Column>> vecOfShPtr2Column;
    std::map<Identity,ShPtr2Column> i2sp2c;
  public:
    inline void addColumn(const ShPtr2Column& shPtr2Column) {
      vecOfShPtr2Column.push_back(shPtr2Column);
      i2sp2c.insert(std::make_pair(shPtr2Column.get()->getIdentity(),shPtr2Column));
    }
    inline void prependColumn(const ShPtr2Column& shPtr2Column) {
      vecOfShPtr2Column.emplace(vecOfShPtr2Column.begin(),shPtr2Column);
      i2sp2c.insert(std::make_pair(shPtr2Column.get()->getIdentity(),shPtr2Column));
    }
    inline std::shared_ptr<Column> getShPtr2Column(int i) const {
      try {
        auto sp2c = vecOfShPtr2Column.at(i);
        return sp2c;
      } catch (std::out_of_range oore) {
        throw std::out_of_range("Column index is out of range");
      }
    }
    inline ShPtr2Column getShPtr2Column(const Identity& identity) const {
      try {
        auto sp2c = i2sp2c.at(identity);
        return sp2c;
      } catch (std::out_of_range oore) {
        throw std::out_of_range("Identity is unknown");
      }
    }
    std::vector<ShPtr2Column>::iterator begin() noexcept {
      return vecOfShPtr2Column.begin();
    }
    std::vector<ShPtr2Column>::const_iterator begin() const noexcept {
      return vecOfShPtr2Column.begin();
    }
    std::vector<ShPtr2Column>::iterator end() noexcept {
      return vecOfShPtr2Column.end();
    }
    std::vector<ShPtr2Column>::const_iterator end() const noexcept {
      return vecOfShPtr2Column.end();
    }
    std::vector<ShPtr2Column>::reverse_iterator rbegin() noexcept { 
      return vecOfShPtr2Column.rbegin();
    }
    std::vector<ShPtr2Column>::const_reverse_iterator rbegin() const noexcept {
      return vecOfShPtr2Column.rbegin();
    }
    std::vector<ShPtr2Column>::reverse_iterator rend() noexcept {
      return vecOfShPtr2Column.rend();
    }
    std::vector<ShPtr2Column>::const_reverse_iterator rend() const noexcept {
      return vecOfShPtr2Column.rend();
    }


  };

  typedef std::shared_ptr<Columns> ShPtr2Columns;

}
#endif
