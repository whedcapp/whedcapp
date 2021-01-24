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
#ifndef IGENERATOR_HH
#define IGENERATOR_HH

#include <memory>

#include "driver.hh"
#include "options.hh"

namespace PartSqlCrudGen {
  class IGenerator {
  public:
    virtual void generate(const Options& options, const std::shared_ptr<Driver>& shPtr2Driver) const = 0;
    static std::unique_ptr<IGenerator> create(const std::string& cfg);
  };
}

#endif
