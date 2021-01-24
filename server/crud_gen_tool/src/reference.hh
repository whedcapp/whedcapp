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
#ifndef REFERENCE_HH
#define REFERENCE_HH
#include <memory>
namespace PartSqlCrudGen {
  class Reference {
  private:
    Identity tableIdentity;
    Identity columnIdentity;
  public:
    Reference(const Identity& tableIdentity,const Identity& columnIdentity): tableIdentity(tableIdentity), columnIdentity(columnIdentity) {}
    inline const Identity& getTableIdentity() const {
      return tableIdentity;
    }
    inline const Identity& getColumnIdentity() const {
      return columnIdentity;
    }
  
    // These should no be necessary:
    friend bool operator==(const Reference& lhs, const Reference& rhs);
    friend bool operator<(const Reference& lhs, const Reference& rhs);
    friend bool operator>(const Reference& lhs, const Reference& rhs);
  };

  inline bool operator==(const Reference& lhs, const Reference& rhs) {
    return lhs.tableIdentity == rhs.tableIdentity && lhs.columnIdentity == rhs.columnIdentity;
  }
  inline bool operator!=(const Reference& lhs, const Reference& rhs) {
    return !(lhs == rhs);
  }
  inline bool operator<(const Reference& lhs, const Reference& rhs) {
    return lhs.tableIdentity<rhs.tableIdentity ||
                             (lhs.tableIdentity == rhs.tableIdentity && lhs.columnIdentity<rhs.columnIdentity);
  }
  inline bool operator>(const Reference& lhs, const Reference& rhs) {
    return lhs.tableIdentity>rhs.tableIdentity ||
      (lhs.tableIdentity == rhs.tableIdentity && lhs.columnIdentity>rhs.columnIdentity);
  }
  inline bool operator<=(const Reference& lhs, const Reference& rhs) {
    return !(lhs>rhs);
  }
  inline bool operator>=(const Reference& lhs, const Reference& rhs) {
    return !(lhs<rhs);
  }

  typedef std::shared_ptr<Reference> ShPtr2Reference;
}
#endif
