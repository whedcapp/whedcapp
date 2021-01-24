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
#include "identity.hh"


namespace PartSqlCrudGen {
  Identity::Identity(const Identity& primId, const Identity& secId) {
    if (primId.isSplitIdentifier() || secId.isSplitIdentifier()) {
      throw std::logic_error("Cannot build a new split identifier on split identifiers");
    }
    identity.push_back(const_cast<Identity&>(primId).getPrimary());
    identity.push_back(const_cast<Identity&>(secId).getPrimary());
  }

  bool operator==(const Identity& lhs, const Identity& rhs) {
    if (lhs.getLength() != rhs.getLength()) {
      return false;
    }
    for (int i = 0; i < std::max(lhs.getLength(),rhs.getLength()); ++i) {
      if (lhs.get(i) != rhs.get(i)) {
        return false;
      }
    }
    return true;
  }

  bool operator<(const Identity& lhs, const Identity& rhs) {
    // sort identifiers with no scope first or last
    if (lhs.getLength() < rhs.getLength()) {
      return true;
    }
    for (int i = 0; i < lhs.getLength(); ++i) {
      if (lhs.get(i)>rhs.get(i)) {
        return false;
      }
      if (lhs.get(i)<rhs.get(i)) {
        return true;
      }
    
    }
    return false;
  }

  bool operator>(const Identity& lhs, const Identity& rhs) {
    // sort identifiers with no scope first or last
    if (lhs.getLength() > rhs.getLength()) {
      return true;
    }
    for (int i = 0; i < lhs.getLength(); ++i) {
      if (lhs.get(i)<rhs.get(i)) {
        return false;
      }
      if (lhs.get(i)>rhs.get(i)) {
        return true;
      }
    
    }
    return false;
  }
}
