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


#include "driver.hh"
#include "partialSql.tab.hh"

extern void yyset_debug(int debug_flag);

using namespace PartSqlCrudGen;

Driver::Driver ()
  : file(""),trace_parsing (false), trace_scanning (false)
{
}

Driver::Driver(const Driver&driver) : file(driver.file), trace_parsing(driver.trace_parsing), trace_scanning(driver.trace_scanning) {
}


int
Driver::parse (const std::string &f)
{
  file = f;
  location.initialize (&file);
  scan_begin ();
  yy::parser parse (*this);
  parse.set_debug_level (trace_parsing);
  //yyset_debug(1);
  int res = parse.parse ();
  scan_end ();
  return res;
}


