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
%{
# include <cerrno>
# include <climits>
# include <cstdlib>
# include <cstring> // strerror
# include <string>
# include "driver.hh"
# include "partialSql.tab.hh"
# include "location.hh"
%}
%option noyywrap nounput noinput batch debug

%{
  // Code run each time a pattern is matched.
  # define YY_USER_ACTION  loc.columns (yyleng);
%}
id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t\r]
citation \"

%s comment inDoubleQuoteString inSingleQuoteString

%%

%{
  // A handy shortcut to the location held by the driver.
  yy::location& loc = drv.location;
  // Code run each time yylex is called.
  loc.step ();
%}

<INITIAL>{blank}+              loc.step ();
<INITIAL>\n+                   loc.lines (yyleng); loc.step ();
<INITIAL>"/*"                  BEGIN(comment);
<comment>[^*\n]       loc.step ();
<comment>"*"+[^*/\n]* loc.step ();
<comment>\n           { loc.lines (yyleng); loc.step (); }
<comment>"*"+"/"      loc.step (); BEGIN (INITIAL);


%{
  // A number symbol corresponding to the value in S.
  yy::parser::symbol_type
    make_NUMBER (const std::string &s, const yy::parser::location_type& loc);
  yy::parser::symbol_type
    make_STRING (const std::string &s, const yy::parser::location_type& loc);
  yy::parser::symbol_type
    make_IDENTIFIER (const std::string &s, const yy::parser::location_type& loc);

  

%}
<INITIAL>(?i:after)             return yy::parser::make_AFTER(loc); 
<INITIAL>(?i:action)            return yy::parser::make_ACTION(loc); 
<INITIAL>(?i:auto_increment)    return yy::parser::make_AUTO_INCREMENT(loc);
<INITIAL>(?i:and)               return yy::parser::make_AND(loc); 
<INITIAL>(?i:as)                return yy::parser::make_AS(loc); 
<INITIAL>"\`"                   return yy::parser::make_BACK_QUOTE(loc); 
<INITIAL>(?i:before)            return yy::parser::make_BEFORE(loc); 
<INITIAL>(?i:begin)             return yy::parser::make_WBEGIN(loc); 
<INITIAL>(?i:boolean)           return yy::parser::make_BOOLEAN(loc); 
<INITIAL>(?i:by)                return yy::parser::make_BY(loc); 
<INITIAL>(?i:call)              return yy::parser::make_CALL(loc); 
<INITIAL>(?i:case)              return yy::parser::make_CASE(loc); 
<INITIAL>(?i:cascade)           return yy::parser::make_CASCADE(loc); 
<INITIAL>(?i:check)             return yy::parser::make_CHECK(loc); 
<INITIAL>","                    return yy::parser::make_COMMA(loc); 
<INITIAL>(?i:constraint)        return yy::parser::make_CONSTRAINT(loc); 
<INITIAL>(?i:create)            return yy::parser::make_CREATE(loc); 
<INITIAL>(?i:current_timestamp) return yy::parser::make_CURRENT_TIMESTAMP(loc); 
<INITIAL>(?i:database)          return yy::parser::make_DATABASE(loc); 
<INITIAL>(?i:date)              return yy::parser::make_DATE(loc); 
<INITIAL>(?i:datetime)          return yy::parser::make_DATETIME(loc); 
<INITIAL>(?i:$$)                return yy::parser::make_DD_DELIMITER(loc); 
<INITIAL>(?i:declare)           return yy::parser::make_DECLARE(loc); 
<INITIAL>(?i:default)           return yy::parser::make_DEFAULT(loc); 
<INITIAL>(?i:delete)            return yy::parser::make_DELETE(loc); 
<INITIAL>(?i:delimiter)         return yy::parser::make_DELIMITER(loc); 
<INITIAL>(?i:deterministic)     return yy::parser::make_DETERMINISTIC(loc); 
<INITIAL>(?i:distinct)          return yy::parser::make_DISTINCT(loc); 
<INITIAL>(?i:double)            return yy::parser::make_DOUBLE(loc); 
<INITIAL>(?i:drop)              return yy::parser::make_DROP(loc); 
<INITIAL>(?i:do)                return yy::parser::make_DO(loc); 
<INITIAL>(?i:each)              return yy::parser::make_EACH(loc); 
<INITIAL>(?i:else)              return yy::parser::make_ELSE(loc); 
<INITIAL>(?i:elseif)            return yy::parser::make_ELSEIF(loc); 
<INITIAL>(?i:end)               return yy::parser::make_END(loc); 
<INITIAL>(?i:engine)            return yy::parser::make_ENGINE(loc); 
<INITIAL>(?i:exists)            return yy::parser::make_EXISTS(loc); 
<INITIAL>(?i:false)             return yy::parser::make_FALSE(loc); 
<INITIAL>(?i:for)               return yy::parser::make_FOR(loc); 
<INITIAL>(?i:foreign)           return yy::parser::make_FOREIGN(loc); 
<INITIAL>(?i:from)              return yy::parser::make_FROM(loc); 
<INITIAL>(?i:full)              return yy::parser::make_FULL(loc); 
<INITIAL>(?i:function)          return yy::parser::make_FUNCTION(loc); 
<INITIAL>(?i:group)             return yy::parser::make_GROUP(loc); 
<INITIAL>(?i:having)            return yy::parser::make_HAVING(loc); 
<INITIAL>(?i:if)                return yy::parser::make_IF(loc); 
<INITIAL>(?i:is)                return yy::parser::make_IS(loc); 
<INITIAL>(?i:in)                return yy::parser::make_IN(loc); 
<INITIAL>(?i:index)             return yy::parser::make_INDEX(loc); 
<INITIAL>(?i:inner)             return yy::parser::make_INNER(loc); 
<INITIAL>(?i:inout)             return yy::parser::make_INOUT(loc); 
<INITIAL>(?i:insert)            return yy::parser::make_INSERT(loc); 
<INITIAL>(?i:int)               return yy::parser::make_INT(loc); 
<INITIAL>(?i:integer)           return yy::parser::make_INTEGER(loc); 
<INITIAL>(?i:into)              return yy::parser::make_INTO(loc); 
<INITIAL>(?i:join)              return yy::parser::make_JOIN(loc); 
<INITIAL>(?i:key)               return yy::parser::make_KEY(loc); 
<INITIAL>(?i:leave)             return yy::parser::make_LEAVE(loc); 
<INITIAL>"("                    return yy::parser::make_LEFT_PAR(loc); 
<INITIAL>(?i:loop)              return yy::parser::make_LOOP(loc); 
<INITIAL>(?i:message_text)      return yy::parser::make_MESSAGE_TEXT(loc); 
<INITIAL>(?i:myisam)            return yy::parser::make_MYISAM(loc); 
<INITIAL>(?i:no)                return yy::parser::make_NO(loc); 
<INITIAL>(?i:not)               return yy::parser::make_NOT(loc); 
<INITIAL>(?i:null)              return yy::parser::make_NUL(loc); 
<INITIAL>(?i:on)                return yy::parser::make_ON(loc); 
<INITIAL>(?i:or)                return yy::parser::make_OR(loc);
<INITIAL>(?i:order)             return yy::parser::make_ORDER(loc); 
<INITIAL>(?i:out)               return yy::parser::make_OUT(loc); 
<INITIAL>(?i:outer)             return yy::parser::make_OUTER(loc); 
<INITIAL>(?i:procedure)         return yy::parser::make_PROCEDURE(loc); 
<INITIAL>"."                    return yy::parser::make_PERIOD(loc); 
<INITIAL>(?i:primary)           return yy::parser::make_PRIMARY(loc); 
<INITIAL>(?i:references)        return yy::parser::make_REFERENCES(loc);
<INITIAL>(?i:repeat)            return yy::parser::make_REPEAT(loc);
<INITIAL>(?i:return)            return yy::parser::make_RETURN(loc);
<INITIAL>(?i:returns)           return yy::parser::make_RETURNS(loc);
<INITIAL>")"                    return yy::parser::make_RIGHT_PAR(loc); 
<INITIAL>(?i:row)               return yy::parser::make_ROW(loc);
<INITIAL>(?i:select)            return yy::parser::make_SELECT(loc);
<INITIAL>";"                    return yy::parser::make_SEMICOLON(loc);
<INITIAL>(?i:set)               return yy::parser::make_SET(loc); 
<INITIAL>(?i:signal)            return yy::parser::make_SIGNAL(loc); 
<INITIAL>(?i:sqlstate)          return yy::parser::make_SQLSTATE(loc); 
<INITIAL>(?i:table)             return yy::parser::make_TABLE(loc); 
<INITIAL>(?i:then)              return yy::parser::make_THEN(loc); 
<INITIAL>(?i:timestamp)         return yy::parser::make_TIMESTAMP(loc); 
<INITIAL>(?i:trigger)           return yy::parser::make_TRIGGER(loc); 
<INITIAL>(?i:true)              return yy::parser::make_TRUE(loc); 
<INITIAL>(?i:truncate)          return yy::parser::make_TRUNCATE(loc); 
<INITIAL>(?i:unique)            return yy::parser::make_UNIQUE(loc); 
<INITIAL>(?i:until)             return yy::parser::make_UNTIL(loc); 
<INITIAL>(?i:update)            return yy::parser::make_UPDATE(loc); 
<INITIAL>(?i:use)               return yy::parser::make_USE(loc); 
<INITIAL>(?i:values)            return yy::parser::make_VALUES(loc); 
<INITIAL>(?i:varchar)           return yy::parser::make_VARCHAR(loc); 
<INITIAL>(?i:view)              return yy::parser::make_VIEW(loc); 
<INITIAL>(?i:visible)           return yy::parser::make_VISIBLE(loc);
<INITIAL>(?i:where)             return yy::parser::make_WHERE(loc);
<INITIAL>(?i:when)              return yy::parser::make_WHEN(loc);
<INITIAL>(?i:while)             return yy::parser::make_WHILE(loc);
<INITIAL>"<"                    return yy::parser::make_LT(loc);
<INITIAL>"<="                   return yy::parser::make_LE(loc);
<INITIAL>"="                    return yy::parser::make_EQ(loc);
<INITIAL>"<>"                   return yy::parser::make_NE(loc);
<INITIAL>">"                    return yy::parser::make_GT(loc);
<INITIAL>">="                   return yy::parser::make_GE(loc);
<INITIAL>"*"                    return yy::parser::make_TIMES(loc);
<INITIAL>"/"                    return yy::parser::make_DIVIDE_BY(loc);
<INITIAL>"+"                    return yy::parser::make_PLUS(loc);
<INITIAL>"-"                    return yy::parser::make_MINUS(loc);

<INITIAL>[a-zA-Z][a-zA-Z0-9_]*  return yy::parser::make_IDENTIFIER(yytext,loc);
<INITIAL>"-"?[0-9]+             { int i=atoi(yytext); return yy::parser::make_NUMBER(i,loc); }
<INITIAL>{citation}([^\"]|\\{citation})*{citation}        { std::string tmp(yytext); return yy::parser::make_STRING(tmp.substr(1,tmp.length()-2),loc); }
<INITIAL>\'([^\']|\\')*\'       { std::string tmp(yytext); return yy::parser::make_STRING(tmp.substr(1,tmp.length()-2),loc); }

.          {
             throw yy::parser::syntax_error
               (loc, "invalid character: " + std::string(yytext));
}
<<EOF>>                  return yy::parser::make_YYEOF(loc);

%%

  void
    Driver::scan_begin ()
  {
    yy_flex_debug = trace_scanning;
    if (file.empty () || file == "-")
      yyin = stdin;
    else if (!(yyin = fopen (file.c_str (), "r")))
      {
        std::cerr << "cannot open " << file << ": " << strerror (errno) << '\n';
        exit (EXIT_FAILURE);
      }
  }


  void
    Driver::scan_end ()
  {
    fclose (yyin);
  }

  
