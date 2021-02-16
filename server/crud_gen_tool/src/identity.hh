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
    along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.
*/
#ifndef IDENTITY_HH
#define IDENTITY_HH

#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

namespace PartSqlCrudGen {
  class Identity {
  private:
    std::vector<std::string> identity;
    void checkIdentity() {
      if (getLength()>2) {
        std::ostringstream msg;
        msg << "Identity cannot be more than two levels, \"";
        bool notFirst = false;
        for (const auto& str: identity) {
          if (notFirst) {
            msg << ".";
          }
          msg << str;
        }
        msg << "\" has " << getLength() << " levels.";
        throw std::logic_error(msg.str());
      }
      for (const auto& str: identity) {
        if (str.find('.') != std::string::npos) {
          std::ostringstream msg;
          msg << "Identity (part) \"" << str << "\" contains a period.";
          throw std::logic_error(msg.str());
        }
      }
    }
     
  public:
    Identity() {}
    Identity(const std::string &id) {
      identity.push_back(id);
      checkIdentity();
    }
    Identity(const std::string &primId, const std::string &secId) {
      identity.push_back(primId);
      identity.push_back(secId);
      checkIdentity();
    }
    Identity(const Identity& primId, const Identity& secId);
    Identity(const Identity& id): identity(id.identity) {}
    Identity(const std::vector<std::string>& idVec): identity(idVec) {
      checkIdentity();
    }
    //Identity(const Identity&& id): identity(id.identity) {}
    inline const int getLength() const {
      return identity.size();
    }
    inline const bool isSplitIdentifier() const {
      return getLength() > 1;
    }
    inline const std::string& get(int i) const {
      return identity.at(i);
    }
    inline std::string& getPrimary() const {
      return const_cast<std::vector<std::string>&>(identity).at(0);
    }
    inline std::string& getSecondary() const {
      return const_cast<std::vector<std::string>&>(identity).at(1);
    }
    inline std::string getBackquoted(const std::string& suffix = "") const {
      std::ostringstream result;
      result << "`" << getPrimary() << (isSplitIdentifier()?"":suffix)<< "`";
      if (isSplitIdentifier()) {
        result << "." << "`" << getSecondary() << suffix << "`";
      }
      return result.str();
    }
  };

  inline std::ostream& operator << (std::ostream& strm, const Identity& identity) {
    strm << const_cast<Identity&>(identity).getPrimary();
    if (identity.isSplitIdentifier()) {
      strm << "." << const_cast<Identity&>(identity).getSecondary();
    }
    return strm;
  }

  bool operator==(const Identity& lhs, const Identity& rhs);
  inline bool operator!=(const Identity& lhs, const Identity& rhs) {
    return !(lhs == rhs);
  }
  bool operator<(const Identity& lhs, const Identity& rhs);
  bool operator>(const Identity& lhs, const Identity& rhs);
  inline bool operator<=(const Identity& lhs, const Identity& rhs) {
    return !(lhs>rhs);
  }
  inline bool operator>=(const Identity& lhs, const Identity& rhs) {
    return !(lhs<rhs);
  }

  class IdentityList {
  private:
    std::vector<Identity> identityList;
  public:
    void add(const Identity &id) {
      identityList.push_back(id);
    }
    std::vector<Identity>::iterator begin() noexcept {
      return identityList.begin();
    }
    std::vector<Identity>::const_iterator begin() const noexcept {
      return identityList.begin();
    }
    std::vector<Identity>::iterator end() noexcept {
      return identityList.end();
    }
    std::vector<Identity>::const_iterator end() const noexcept {
      return identityList.end();
    }
    std::vector<Identity>::reverse_iterator rbegin() noexcept {
      return identityList.rbegin();
    }
    std::vector<Identity>::const_reverse_iterator rbegin() const noexcept {
      return identityList.rbegin();
    }
    std::vector<Identity>::reverse_iterator rend() noexcept {
      return identityList.rend();
    }
    std::vector<Identity>::const_reverse_iterator rend() const noexcept {
      return identityList.rend();
    }
  };

}
#endif
