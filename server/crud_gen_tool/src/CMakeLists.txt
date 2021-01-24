# 
#     This File Is Part Of Whedcapp - Well-Being Health Environment Data Collection App - to collect self-evaluated data for research purpose
#     Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

#     Whedcapp is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     Whedcapp is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
# 
cmake_minimum_required(VERSION 3.10)
project(PartialCrudGen VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(BISON)
find_package(FLEX)



BISON_TARGET(Parser partialSql.y ${CMAKE_CURRENT_BINARY_DIR}/partialSql.tab.cc
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/partialSql.tab.hh)
FLEX_TARGET(Scanner partialSql.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc)
ADD_FLEX_BISON_DEPENDENCY(Scanner Parser)


add_executable(parser  configuration.cc  common.cc  driver.cc  generatorSql.cc  genConfig.cc  identity.cc  igenerator.cc  lex.yy.cc  options.cc  parse.cc   relationalOperator.cc  table.cc  tableSpecItem.cc  type.cc ${BISON_Parser_OUTPUTS} ${FLEX_Scanner_OUTPUTS})

configure_file(partialCrudGenConfig.h.in partialCrudGenConfig.h)

target_include_directories(parser PUBLIC "${PROJECT_BINARY_DIR}" ${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/../thirdparty)



  
