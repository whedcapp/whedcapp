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
#ifndef OPTIONS_H
#define OPTIONS_H

#include <memory>
#include <unistd.h>
#include "configuration.hh"

namespace PartSqlCrudGen {
  class Options {
    const std::unique_ptr<IConfiguration> configuration;
  public:
    Options(): configuration(std::make_unique<Configuration>()) {}
    std::vector<std::string> vecOfCfgPath;
    std::vector<std::string> vecOfSrcPath;
    bool outputSql = false;
    bool outputDart = false;
    bool traceParsing = false;
    bool listTableMetaData = false;
    std::map<OutputLanguage::Type,std::string> outputFilePath;
    std::map<std::string,nlohmann::json> src2Cfg;
    int outputCodeTabWidth = 4;
    inline const IConfiguration& getConfiguration() const {
      return *configuration;
    }
    void parseArguments(int argc,char *argv[]);
    void readConfigurationFiles();
    
  };
}
#endif
