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
#include "common.hh"


namespace PartSqlCrudGen {
  std::string toupper(const std::string& value) {
    std::string tmp;
    for (auto c:value) {
      tmp.push_back(std::toupper(c));
    }
    return tmp;
  }
  const std::vector<std::string> tokenize(const std::string& value, char delimiter) {
    std::istringstream iss(value);
    std::vector<std::string> result;
    std::string token;
    while (std::getline(iss,token,delimiter)) {
      result.push_back(token);
    }
    return result;
  }
}
