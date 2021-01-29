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
#include <cstdlib>
#include <iostream>
#include <fstream>

#include "options.hh"
#include "partialCrudGenConfig.h"

void PartSqlCrudGen::Options::parseArguments(int argc,char *argv[]) {
  int opt;
  while ((opt = getopt(argc,argv,"d:c:lp:s:tw:"))!=EOF) {
    switch(opt) {
    case 'c':
      vecOfCfgPath.push_back(optarg);
      break;
    case 's':
      outputSql = true;
      outputFilePath.insert(std::make_pair(OutputLanguage::Sql,optarg));
      break;
    case 'd':
      outputDart = true;
      outputFilePath.insert(std::make_pair(OutputLanguage::Dart,optarg));
      break;
    case 'l':
      listTableMetaData = true;
      break;
    case 'p':
      vecOfSrcPath.push_back(optarg);
      break;
    case 't':
      traceParsing = true;
      break;
    case 'w':
      outputCodeTabWidth = atoi(optarg);
      break;
    case '?':
      std::cerr << "This is version " << PartialCrudGen_VERSION_MAJOR << "." << PartialCrudGen_VERSION_MINOR << " of the partialCrudGen tool. Usage is \n\t-c <configuration file> -c <configuration file> ... \n\t-p <source file> -p <source file> ...\n\t-s <output file> output SQL stored procedures\n\t-d <output> ouput Dart gRPC server code\n\t-t trace parsing\n\t-l list found table data" << std::endl;
    default:
      std::cout << std::endl;
      abort();
    }
  }
}

void PartSqlCrudGen::Options::readConfigurationFiles()  {
  bool errorFlag = false;
  for (auto& p: vecOfCfgPath) {
    std::ifstream srcFile(p);
    nlohmann::json tmp;
    try {
      srcFile >> tmp;
      src2Cfg.insert(std::make_pair(p,tmp));
      const_cast<IConfiguration*>(&getConfiguration())->add(tmp);
    } catch (const nlohmann::json::parse_error& pe) {
      std::cerr << "Error while parsing \"" << p << "\"" << std::endl;
      std::cerr << pe.what() << " id = " << pe.id << " at position = " << pe.byte << std::endl;
    } catch (const std::exception& error) {
      std::cerr << "Error while parsing \"" << p << "\"" << std::endl;
      std::cerr << error.what() << std::endl;
      errorFlag = true;
    }
    srcFile.close();
  }
  if (errorFlag) {
    throw std::logic_error("Incorrect configuration files");
  }
}
