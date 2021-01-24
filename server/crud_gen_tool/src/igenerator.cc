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
#include "common.hh"
#include "igenerator.hh"
#include "generatorSql.hh"

std::unique_ptr<IGenerator> PartSqlCrudGen::IGenerator::create(const std::string& cfg) {
  std::string tmp = toupper(cfg);
  if (tmp == "SQL") {
    return std::make_unique<GeneratorSql>();
  }
  throw std::logic_error("Configuration string is not implemented yet");
}
