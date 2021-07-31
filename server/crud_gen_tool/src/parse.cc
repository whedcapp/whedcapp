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
  along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.
*/
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <unistd.h>

#include "configuration.hh"
#include "driver.hh"
#include "igenerator.hh"
#include "options.hh"
#include "table.hh"
#include "json.hpp"

static PartSqlCrudGen::Options options;

static void listTableMetaData(const std::shared_ptr<PartSqlCrudGen::Driver>& shPtr2Driver) {
  std::cout << "List of identifiers: " << std::endl;
  for (auto s : *shPtr2Driver->shPtr2VecOfShPtr2Table) {
    std::cout << *s << "\n";
  }
  std::cout << "List of identifiers: end " << std::endl;
  
}

int main(int argc, char *argv[]) {
  options.parseArguments(argc,argv);
  options.readConfigurationFiles();

    
  auto drv = std::make_shared<PartSqlCrudGen::Driver>();
  drv->trace_parsing = options.traceParsing;
  for (auto& p:options.vecOfSrcPath) {
    drv->parse(p);
  }
  if (options.listTableMetaData) {
    listTableMetaData(drv);
  }
  if (options.outputSql && !options.outputFilePath.empty()) {
    std::unique_ptr<IGenerator> generator = IGenerator::create("SQL");
    
    generator->generate(options,drv);
  }
  if (options.outputProto && !options.outputFilePath.empty()) {
    std::unique_ptr<IGenerator> generator = IGenerator::create("Proto");
    
    generator->generate(options,drv);
  }
 
}
