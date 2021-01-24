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

#ifndef GEN_CONFIG_HH
#define GEN_CONFIG_HH

#include <iostream>
#include <fstream>
#include <map>
#include <optional>
#include <regex>
#include <string>

#include "json.hpp"

namespace PartSqlCrudGen {

  class GenConfig;

  class JsonPath {
    friend class GenConfig;
  private:
    static std::string rootString ;
    static JsonPath rootJsonPath;
  public:
    static const JsonPath& getRootJsonPath();
    static const JsonPath constructJsonPath(const std::string& pathString);
  private:
    std::vector<std::string> tokens;
    std::string pattern = "[^\\/]+";
    std::vector<std::string> findTokens(const std::string& str, const std::string& pattern);
  public:
    JsonPath() {}
    JsonPath(const std::string& str) {
      tokens = findTokens(str,pattern);
    }
    JsonPath(const std::string& str,const std::string& pattern): pattern(pattern) {
      tokens = findTokens(str,pattern);
    }
    const std::vector<std::string>& getTokens() const {
      return tokens;
    }
    const int getLength() const {
      return tokens.size();
    }
    const std::string& get(const int index) const {
      return tokens.at(index);
    }
  };

  bool operator==(const JsonPath& lhs, const JsonPath& rhs);
  inline bool operator!=(const JsonPath& lhs, const JsonPath& rhs) {
    return !(lhs == rhs);
  }
  bool operator<(const JsonPath& lhs, const JsonPath& rhs);
  bool operator>(const JsonPath& lhs, const JsonPath& rhs);
  inline bool operator<=(const JsonPath& lhs, const JsonPath& rhs) {
    return !(lhs>rhs);
  }
  inline bool operator>=(const JsonPath& lhs, const JsonPath& rhs) {
    return !(lhs<rhs);
  }


  class GenConfig {
  public:
  private:
    std::string pathToCfg;
    nlohmann::json cfg;
    static const std::multimap<JsonPath,std::string> validCfgKeywords;
  public:
    GenConfig(const std::string& pathToCfg): pathToCfg(pathToCfg) {
    }
    GenConfig(const GenConfig& genConfig): pathToCfg(genConfig.pathToCfg), cfg(genConfig.cfg) {}
    
  };  
}

#endif
