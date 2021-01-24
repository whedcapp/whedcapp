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
    along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
*/


#include "genConfig.hh"

namespace PartSqlCrudGen {

  std::string JsonPath::rootString = "/";
  JsonPath JsonPath::rootJsonPath = JsonPath(JsonPath::rootString);

  const JsonPath& JsonPath::getRootJsonPath() {
    return rootJsonPath;
  }
  const JsonPath JsonPath::constructJsonPath(const std::string& pathString) {
    return JsonPath(pathString);
  }


  const std::multimap<JsonPath ,std::string> GenConfig::validCfgKeywords = {
    {JsonPath::getRootJsonPath(),"contextParameters"},
    {JsonPath::getRootJsonPath(),"checkContext"},
    {JsonPath::getRootJsonPath(),"preprocessing"},
    {JsonPath::getRootJsonPath(),"postprocessing"},
    {JsonPath::getRootJsonPath(),"aclCheck"},
    {JsonPath::constructJsonPath("/checkContext"),"wheedcapp_administrator"},
    {JsonPath::constructJsonPath("/checkContext"),"project_owner"},
    {JsonPath::constructJsonPath("/checkContext"),"researcher"},
    {JsonPath::constructJsonPath("/checkContext"),"questionnaire_maintainer"},
    {JsonPath::constructJsonPath("/checkContext"),"supporter"},
    {JsonPath::constructJsonPath("/checkContext"),"participant"},
    {JsonPath::constructJsonPath("/preprocessing"),"step"},
    {JsonPath::constructJsonPath("/postprocessing"),"step"}
    
    
  };


  std::vector<std::string> JsonPath::findTokens(const std::string& str, const std::string& pattern) {
    std::vector<std::string> tokens;
    std::regex re(pattern);
    std::regex_iterator<std::string::iterator> rend;
    std::regex_iterator<std::string::iterator> rit(const_cast<std::string&>(str).begin(),const_cast<std::string&>(str).end(),re);
    for(;rit!=rend; ++rit) {
      tokens.push_back(rit->str());
    }
    if ((tokens.empty() && str.length()<1) || (!tokens.empty() &&str.substr(0,tokens[0].length()) == tokens[0])) {
      throw std::logic_error("JsonPath must start with a delimiter");
    }
    if (!tokens.empty()) {
      std::string& tmpString = tokens[tokens.size()-1];
      std::size_t sz = tmpString.length();
      if (str.substr(str.length()-sz,sz) != tmpString) {
        throw std::logic_error("JsonPath cannot end with a delimiter");
      }
    }
    return tokens;
  }


  bool operator==(const JsonPath& lhs, const JsonPath& rhs) {
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

  bool operator<(const JsonPath& lhs, const JsonPath& rhs) {
    // sort identifiers with no scope first or last
    if (lhs.getLength() < rhs.getLength()) {
      return true;
    }
    for (int i = 0; i < lhs.getLength() && i < rhs.getLength(); ++i) {
      if (lhs.get(i)>rhs.get(i)) {
        return false;
      }
      if (lhs.get(i)<rhs.get(i)) {
        return true;
      }
    
    }
    return false;
  }

  bool operator>(const JsonPath& lhs, const JsonPath& rhs) {
    // sort identifiers with no scope first or last
    if (lhs.getLength() > rhs.getLength()) {
      return true;
    }
    for (int i = 0; i < lhs.getLength() && i < rhs.getLength(); ++i) {
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
