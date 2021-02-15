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
#ifndef DRIVER_HH
#define DRIVER_HH
#include <string>
#include <map>
#include "identity.hh"
#include "partialSql.tab.hh"
#include "table.hh"
// Give Flex the prototype of yylex we want ...
# define YY_DECL \
  yy::parser::symbol_type yylex (Driver&drv)
// ... and declare it for the parser's sake.
YY_DECL;

//#define yyterminate return yy::parser::make_YYEOF(drv.location)
#define yyterminate return yy::parser::make_YYEOF(yy::location())

namespace PartSqlCrudGen {
  // Conducting the whole scanning and parsing of Calc++.
  class Driver
  {
  public:
    Driver ();
    Driver(const Driver&);

    ShPtr2StrVec tableNameVector;
    ShPtr2VecOfShPtr2Table shPtr2VecOfShPtr2Table;
    std::optional<Identity> optSelectedDatabase;
  
    // Run the parser on file F.  Return 0 on success.
    int parse (const std::string& f);
    // The name of the file being parsed.
    std::string file;
    // Whether to generate parser debug traces.
    bool trace_parsing;
    // Whether to generate scanner debug traces.
    bool trace_scanning;
    // The token's location used by the scanner.
    yy::location location;
    bool inDifferentDelimiter = false;
    bool atTopLevel = true;

    // Handling the scanner.
    void scan_begin ();
    void scan_end ();
  };
}
#endif
