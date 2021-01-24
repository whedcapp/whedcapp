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
%require "3.0.4"
%language "c++"
%skeleton "lalr1.cc"
%defines

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%locations

%define parse.trace
%define parse.error verbose

%code requires {
  #include <any>
  #include <iostream>
  #include <string>
  #include <vector>
  #include <memory>
  #include <typeinfo>
  #include <typeindex>
  #include "column.hh"
  #include "reference.hh"
  #include "table.hh"
  #include "tableSpecItem.hh"
  #include "type.hh"
  using namespace PartSqlCrudGen;
  typedef std::vector<std::string> StrVec;
  typedef std::shared_ptr<Columns> ShPtr2Columns;
  typedef std::shared_ptr<StrVec> ShPtr2StrVec;
  namespace PartSqlCrudGen {
    class Driver;
  }
  class ColAttrs {
  public:
    bool nullable = false;
    bool autoIncrementable = false;
    std::optional<std::any> defaultValue;
  ColAttrs(const ColAttrs& colAttrs): nullable(colAttrs.nullable), autoIncrementable(colAttrs.autoIncrementable) {}
  ColAttrs() {}
  };
}
%param { PartSqlCrudGen::Driver& drv }

%code {
  #include "driver.hh"
  #include "column.hh"
  #include "identity.hh"
  #include "reference.hh"
  #include "table.hh"
  #include "type.hh"
 }
%token ACTION
%token AFTER
%token AUTO_INCREMENT
%token AND
%token AS
%token BACK_QUOTE
%token BEFORE
%token WBEGIN
%token BOOLEAN
%token BY
%token CASE
%token CASCADE
%token CHECK
%token COMMA
%token COMMENT
%token CONSTRAINT
%token CREATE
%token CURRENT_TIMESTAMP
%token DATABASE
%token DATE
%token DATETIME
%token DD_DELIMITER
%token DECLARE
%token DEFAULT
%token DELETE
%token DELIMITER
%token DIVIDE_BY
%token DOUBLE
%token DROP
%token DO
%token EACH
%token ELSE
%token ELSEIF
%token END
%token ENGINE
%token EXISTS
%token FALSE
%token FOR
%token FOREIGN
%token FROM
%token FULL
%token GROUP
%token HAVING
%token <std::string> IDENTIFIER
%token IF
%token IS
%token IN
%token INDEX
%token INOUT
%token INSERT
%token INT
%token INTEGER
%token INTO
%token INNER
%token JOIN
%token KEY
%token LEAVE
%token LEFT_PAR
%token LOOP
%token MESSAGE_TEXT
%token MINUS
%token MYISAM
%token NO
%token NOT
%token NUL
%token <int> NUMBER
%token ON
%token OR
%token ORDER
%token OUT
%token OUTER
%token PERIOD
%token PLUS
%token PRIMARY
%token PROCEDURE
%token REFERENCES
%token REPEAT
%token RETURN
%token RIGHT_PAR
%token ROW
%token SQLSTATE
%token SELECT
%token SEMICOLON
%token SET
%token SIGNAL
%token <std::string> STRING
%token TABLE
%token TIMES
%token TIMESTAMP
%token THEN
%token TRIGGER
%token TRUE
%token UNIQUE
%token UNTIL
%token UPDATE
%token UPDATE_STATEMENT
%token USE
%token TRUNCATE
%token VALUES
%token VARCHAR
%token VIEW
%token VISIBLE
%token WHEN
%token WHERE
%token WHILE

%token LT
%token LE
%token EQ
%token NE
%token GE
%token GT

%token YYEOF 0
%type <Type>                COL_TYPE_SPEC
%type <ShPtr2Table>         CREATE_TABLE_STATEMENT
%type <ShPtr2TableSpecItem> ALT_SPEC
%type <ShPtr2TableSpecItem> PRIMARY_KEY_SPEC
%type <ShPtr2TableSpecItem> COL_SPEC
%type <ShPtr2TableSpecItem> INDEX_SPEC
%type <ShPtr2TableSpecItem> CONSTRAINT_SPEC
%type <ShPtr2TableSpecItem> CONSTRAINT_ALT
%type <ShPtr2VecOfShPtr2TableSpecItem> TABLE_SPEC
%type <ShPtr2VecOfShPtr2Table> CMDS
%type <ShPtr2VecOfShPtr2Table> IF_STATEMENT
%type <ShPtr2VecOfShPtr2Table> ELSE_PART
%type <ShPtr2VecOfShPtr2Table> CASE_STATEMENT
%type <ShPtr2VecOfShPtr2Table> WHEN_ELSE_PART
%type <ShPtr2VecOfShPtr2Table> WHEN_ELSE_PART_END
%type <ShPtr2VecOfShPtr2Table> WHEN_ELSE_PART2
%type <ShPtr2VecOfShPtr2Table> WHEN_ELSE_PART2_END
%type <ShPtr2VecOfShPtr2Table> LOOP_STATEMENT
%type <ShPtr2VecOfShPtr2Table> WHILE_STATEMENT
%type <ShPtr2VecOfShPtr2Table> REPEAT_STATEMENT
%type <ShPtr2VecOfShPtr2Table> LEAVE_STATEMENT
%type <ShPtr2VecOfShPtr2Table> SET_STATEMENT
%type <ShPtr2VecOfShPtr2Table> RETURN_STATEMENT
%type <ShPtr2VecOfShPtr2Table> LABEL
%type <ShPtr2VecOfShPtr2Table> TRUNCATE_TABLE_STATEMENT
%type <ShPtr2VecOfShPtr2Table> DECLARATION_OR_OPERATION_STATEMENTS
%type <ShPtr2VecOfShPtr2Table> DECLARATION_STATEMENT
%type <ShPtr2VecOfShPtr2Table> OPERATION_STATEMENT
%type <ShPtr2VecOfShPtr2Table> DECLARATION_STATEMENTS
%type <ShPtr2VecOfShPtr2Table> OPERATION_STATEMENTS
%type <ShPtr2VecOfShPtr2Table> CREATE_PROCEDURE_STATEMENT
%type <ShPtr2VecOfShPtr2Table> CREATE_TRIGGER_STATEMENT
%type <ShPtr2VecOfShPtr2Table> STATEMENT_SECTIONS
%type <Identity> QID
%type <Identity> ID
%type <ColAttrs> COL_ATTRS
%type <std::any> VALUE
%type <std::any> SYSTEM_VARIABLE


%%
%start TOP;

TOP: CMDS YYEOF { std::cout << "Hello\n"; drv.shPtr2VecOfShPtr2Table = $1; }

CMDS: DECLARATION_OR_OPERATION_STATEMENTS { $$ = $1; }

// On top level, we can mix declaration and operational statements
DECLARATION_OR_OPERATION_STATEMENTS: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();} | DECLARATION_STATEMENT DD_DELIMITER_OR_SEMICOLON DECLARATION_OR_OPERATION_STATEMENTS { $$ = $1;  $$->insert($$->end(),$1->begin(),$1->end()); }| OPERATION_STATEMENT DD_DELIMITER_OR_SEMICOLON DECLARATION_OR_OPERATION_STATEMENTS { $$ = $1;  $$->insert($$->end(),$1->begin(),$1->end()); } | DELIMITER_STATEMENT DECLARATION_OR_OPERATION_STATEMENTS { $$ = $2; }


// Handling changing delimiters

DD_DELIMITER_OR_SEMICOLON: SEMICOLON DD_DELIMITER { if((!drv.atTopLevel && drv.inDifferentDelimiter)) { yy::parser::error(drv.location,"Cannot be a ';' and '$$' ending a statement, must be only a ';' "); } } | SEMICOLON { if((drv.atTopLevel && drv.inDifferentDelimiter)) { yy::parser::error(drv.location,"Cannot only be a ';' ending a statement, must be both a ';' and '$$'"); } }

DATABASE_OR_PROCEDURE_OR_TRIGGER: DATABASE | PROCEDURE | TRIGGER

CREATE_TABLE_STATEMENT:   CREATE TABLE IF_NOT_EXISTS ID LEFT_PAR TABLE_SPEC RIGHT_PAR OPT_ENGINE_SPEC
{

  Identity id;
  if (drv.optSelectedDatabase.has_value() && !$4.isSplitIdentifier()) {
    id = Identity(drv.optSelectedDatabase.value(),$4);
  } else {
    id = $4;
  }
  auto tmp = std::make_shared<Table>(id);
  tmp->addShPtr2VecOfShPtr2TableSpecItem($6);
  $$ = tmp;
}

OPT_ENGINE_SPEC: /* empty */ | ENGINE EQ ENGINE_SPEC_ALT

ENGINE_SPEC_ALT: MYISAM

TRUNCATE_TABLE_STATEMENT: TRUNCATE TABLE ID { $$ = std::make_shared<VecOfShPtr2Table>(); }

INSERT_STATEMENT: INSERT INTO ID LEFT_PAR ID_LIST RIGHT_PAR VALUES_OR_SELECT

VALUES_OR_SELECT: VALUES LEFT_PAR NON_EMPTY_ID_OR_VALUE_LIST RIGHT_PAR VALUES_OR_SELECT_LIST | SELECT_STATEMENT

VALUES_OR_SELECT_LIST: /* empty */ | COMMA LEFT_PAR NON_EMPTY_ID_OR_VALUE_LIST RIGHT_PAR VALUES_OR_SELECT_LIST

CREATE_VIEW_STATEMENT: CREATE VIEW ID AS SELECT_STATEMENT

SELECT_STATEMENT: SELECT NON_EMPTY_ID_OR_VALUE_LIST FROM ID_LIST JOIN_PART WHERE CONDITION

JOIN_PART: INNER_OUTER_FULL_STANDARD_JOIN ID ON ID EQ ID | /* empty */

INNER_OUTER_FULL_STANDARD_JOIN: INNER | OUTER | FULL | /* empty */

QID: IDENTIFIER {  $$ = Identity($1); }| BACK_QUOTE IDENTIFIER BACK_QUOTE { $$ = Identity($2); }

IF_EXISTS: /* !exists */| IF EXISTS

IF_NOT_EXISTS: /* empty: do not care */ | IF NOT EXISTS


ID: QID {  $$ = Identity($1);  }| QID PERIOD QID {$$ = Identity($1,$3); }

ID_LIST: ID COMMA ID_LIST | ID

NON_EMPTY_ID_OR_VALUE_LIST: FUNCTION_ID_OR_VALUE OPT_INTO_SPEC COMMA NON_EMPTY_ID_OR_VALUE_LIST | FUNCTION_ID_OR_VALUE OPT_INTO_SPEC

OPT_INTO_SPEC: /* empty */ | INTO ID

TABLE_SPEC:
  ALT_SPEC COMMA TABLE_SPEC { $$ = $3; $$.get()->prependTableSpecItem($1); }| ALT_SPEC { $$ = std::make_shared<VecOfShPtr2TableSpecItem>(); $$.get()->addTableSpecItem($1); }

ALT_SPEC:
  COL_SPEC  { $$ = $1; } |
  INDEX_SPEC  { $$ = $1; } |
  PRIMARY_KEY_SPEC { $$ = $1; } |
  CONSTRAINT_SPEC { $$ = $1; }  

COL_SPEC:
  ID COL_TYPE_SPEC COL_ATTRS {
    $$ = std::make_shared<ColumnTableSpecItem>($1,std::make_shared<Column>($1,$2));
    static_cast<ColumnTableSpecItem*>($$.get())->getShPtr2Column()->setNullable($3.nullable);
    static_cast<ColumnTableSpecItem*>($$.get())->getShPtr2Column()->setAutoIncrementable($3.autoIncrementable);
  }

COL_TYPE_SPEC:
  VARCHAR LEFT_PAR NUMBER RIGHT_PAR { $$ = Type("VARCHAR",$3);}|
  INT { $$ = Type("INT"); }|
  INTEGER { $$ = Type("INTEGER");} |
  DOUBLE { $$ = Type("DOUBLE"); } |
  DATE { $$ = Type("DATE"); } |
  DATETIME { $$ = Type("DATETIME"); } |
  BOOLEAN { $$ = Type("BOOLEAN"); } |
  TIMESTAMP { $$ = Type("TIMESTAMP"); } 

COL_ATTRS:
  NUL COL_ATTRS { $$ = $2; $$.nullable = true; } |
  NOT NUL COL_ATTRS { $$ = $3; $$.nullable = false; } |
  AUTO_INCREMENT COL_ATTRS { $$ = $2; $$.autoIncrementable = true; } | { $$ = ColAttrs(); } |
  DEFAULT VALUE COL_ATTRS { $$ = $3; $$.defaultValue = $2; }

VALUE:
  STRING { $$ = $1; }|
  NUMBER { $$ = $1; }|
  TRUE { $$ = true;} |
  FALSE { $$ = false;} |
  SYSTEM_VARIABLE { $$ = $1; }

SYSTEM_VARIABLE: CURRENT_TIMESTAMP { $$ = "current_timestamp"; }

CONDITION:
  LEFT_PAR CONDITION RIGHT_PAR |
  NOT CONDITION |
  CONJUNCTION | DISJUNCTION | FUNCTION_ID_OR_VALUE RELOP FUNCTION_ID_OR_VALUE | FUNCTION_ID_OR_VALUE | FUNCTION_ID_OR_VALUE IS NUL | FUNCTION_ID_OR_VALUE IS NOT NUL

CONJUNCTION:
  CONDITION AND CONDITION

DISJUNCTION:
  CONDITION OR CONDITION

RELOP:
  LT | LE | EQ | NE | GE | GT

FUNCTION_ID_OR_VALUE:
  ID LEFT_PAR ID_OR_VALUE_LIST RIGHT_PAR | ID_OR_VALUE

ID_OR_VALUE_LIST: /* empty */ | FUNCTION_ID_OR_VALUE ID_OR_VALUE_LIST_TAIL 

ID_OR_VALUE_LIST_TAIL: /* empty */ | COMMA ID_OR_VALUE_LIST 

ID_OR_VALUE:
  ID | NUMBER | STRING

INDEX_SPEC:
  INDEX ID LEFT_PAR ID_LIST RIGHT_PAR VISIBLE_OR_NOT { $$ = std::make_shared<IndexTableSpecItem>($2); } |
  UNIQUE INDEX ID LEFT_PAR ID_LIST RIGHT_PAR VISIBLE_OR_NOT { $$ = std::make_shared<IndexTableSpecItem>($3); }

VISIBLE_OR_NOT: /* !exists */ | VISIBLE

PRIMARY_KEY_SPEC:
PRIMARY KEY LEFT_PAR ID RIGHT_PAR { auto tmp = std::make_shared<PrimaryKeyTableSpecItem>($4); $$ = tmp;  }

CONSTRAINT_SPEC:
  CONSTRAINT CONSTRAINT_ALT { $$ = $2; }

CONSTRAINT_ALT:
  ID CHECK CONDITION  { $$ = std::make_shared<CheckConstraintTableSpecItem>($1); } |
  ID FOREIGN KEY LEFT_PAR ID RIGHT_PAR REFERENCES ID LEFT_PAR ID RIGHT_PAR FOREIGN_KEY_ACTION FOREIGN_KEY_ACTION  { $$ = std::make_shared<ForeignKeyConstraintTableSpecItem>($1,$5,std::make_shared<Reference>(Identity($8.getPrimary()),Identity($8.getSecondary()))); }

FOREIGN_KEY_ACTION:
  ON DELETE CASCADE_OR_NO_ACTION  |
  ON UPDATE CASCADE_OR_NO_ACTION  

CASCADE_OR_NO_ACTION: CASCADE | NO ACTION

CREATE_PROCEDURE_STATEMENT: CREATE PROCEDURE {drv.atTopLevel = false; } ID LEFT_PAR PAR_LIST RIGHT_PAR WBEGIN STATEMENT_SECTIONS END {drv.atTopLevel = true; $$ = $STATEMENT_SECTIONS; }

CREATE_TRIGGER_STATEMENT: CREATE TRIGGER {drv.atTopLevel = false; } ID BEFORE_OR_AFTER INSERT_UPDATE_DELETE ON ID FOR EACH ROW  WBEGIN STATEMENT_SECTIONS END {drv.atTopLevel = true; $$ = $STATEMENT_SECTIONS; }

BEFORE_OR_AFTER: BEFORE | AFTER

INSERT_UPDATE_DELETE: INSERT | UPDATE | DELETE

PAR_LIST: /* empty */ | PAR_LIST_ELEMENT | PAR_LIST_ELEMENT COMMA PAR_LIST

PAR_LIST_ELEMENT: IN_OR_OUT ID COL_TYPE_SPEC

IN_OR_OUT: /* empty */ | IN | OUT | INOUT

STATEMENT_SECTIONS: DECLARATION_STATEMENTS  OPERATION_STATEMENTS { $$ = $1; $$ -> insert($$->begin(),$2->begin(),$2->end()); }

DECLARATION_STATEMENTS: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();} | DECLARATION_STATEMENT DD_DELIMITER_OR_SEMICOLON DECLARATION_STATEMENTS { $$ = $1; $$->insert($$->end(),$3->begin(),$3->end()); }

DECLARATION_DEFAULT_SPEC: /* empty */  | DEFAULT VALUE

DECLARATION_STATEMENT: DECLARE ID COL_TYPE_SPEC DECLARATION_DEFAULT_SPEC { $$ = std::make_shared<VecOfShPtr2Table>(); }

OPERATION_STATEMENTS: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();} | OPERATION_STATEMENT DD_DELIMITER_OR_SEMICOLON OPERATION_STATEMENTS { $$ = $1; $$->insert($$->end(),$3->begin(),$3->end()); }

OPERATION_STATEMENT:
    IF_STATEMENT { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CASE_STATEMENT { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | LOOP_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | WHILE_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | REPEAT_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | LEAVE_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | SET_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | RETURN_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | LABEL  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CREATE_TABLE_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); $$->push_back($1); }
  | SELECT_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | INSERT_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CREATE_VIEW_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CREATE_PROCEDURE_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CREATE_TRIGGER_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | DROP DATABASE_OR_PROCEDURE_OR_TRIGGER IF_EXISTS ID  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | CREATE DATABASE QID  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | USE  QID  { drv.optSelectedDatabase = $2; $$ = std::make_shared<VecOfShPtr2Table>();}
  | TRUNCATE_TABLE_STATEMENT  { $$ = std::make_shared<VecOfShPtr2Table>(); }
  | SIGNAL_STATEMENT { $$ = std::make_shared<VecOfShPtr2Table>(); }




LABEL: ID { $$ = std::make_shared<VecOfShPtr2Table>(); }

// If statement

IF_STATEMENT: IF CONDITION THEN OPERATION_STATEMENTS ELSE_PART END IF {$$ = $4; $$->insert($$->end(),$5->begin(),$5->end()); }

ELSE_PART: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();} | ELSE OPERATION_STATEMENTS  {$$ = $2;}| ELSEIF CONDITION THEN OPERATION_STATEMENTS ELSE_PART { $$ = $4; $$ -> insert($$->end(),$5->begin(),$5->end()); }

// Case statement:

CASE_STATEMENT: CASE ID WHEN_ELSE_PART END CASE {$$ = $3; } | CASE WHEN_ELSE_PART2 END CASE {$$ = $2;}

WHEN_ELSE_PART: WHEN VALUE THEN OPERATION_STATEMENTS WHEN_ELSE_PART_END { $$ = $4; $$ -> insert($$->end(),$5->begin(),$5->end()); }

WHEN_ELSE_PART_END: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();} | WHEN VALUE THEN OPERATION_STATEMENTS WHEN_ELSE_PART_END { $$ = $4; $$ -> insert($$->end(),$5->begin(),$5->end());} | ELSE OPERATION_STATEMENTS { $$ = $2; }

WHEN_ELSE_PART2: WHEN CONDITION THEN OPERATION_STATEMENTS WHEN_ELSE_PART2_END { $$ = $4; $$ -> insert($$->end(),$5->begin(),$5->end()); }

WHEN_ELSE_PART2_END: /* empty */ { $$ = std::make_shared<VecOfShPtr2Table>();}| WHEN CONDITION THEN OPERATION_STATEMENTS WHEN_ELSE_PART2_END { $$ = $4; $$ -> insert($$->end(),$4->begin(),$4->end());} | ELSE OPERATION_STATEMENTS { $$ = $2; }

// Loop statement

LOOP_STATEMENT: LOOP OPERATION_STATEMENTS END LOOP {$$ = $2;}

// While statement

WHILE_STATEMENT: WHILE CONDITION DO OPERATION_STATEMENTS END WHILE {$$ = $4;}

// Repeat statement

REPEAT_STATEMENT: REPEAT OPERATION_STATEMENTS UNTIL CONDITION END REPEAT {$$ = $2;}

// Leave

LEAVE_STATEMENT: LEAVE ID { $$ = std::make_shared<VecOfShPtr2Table>(); }| LEAVE { $$ = std::make_shared<VecOfShPtr2Table>(); }

// Set

SET_STATEMENT: SET ID EQ EXPRESSION { $$ = std::make_shared<VecOfShPtr2Table>(); }

EXPRESSION: FUNCTION_ID_OR_VALUE | LEFT_PAR EXPRESSION RIGHT_PAR | FEXPRESSION PLUS FEXPRESSION | FEXPRESSION MINUS FEXPRESSION | BEXPRESSION OR BEXPRESSION

FEXPRESSION: EXPRESSION TIMES EXPRESSION | EXPRESSION DIVIDE_BY EXPRESSION

RETURN_STATEMENT: RETURN EXPRESSION { $$ = std::make_shared<VecOfShPtr2Table>(); }

BEXPRESSION: AEXPRESSION | AEXPRESSION AND AEXPRESSION

AEXPRESSION: EXPRESSION | EXPRESSION RELOP EXPRESSION

// Signal
SIGNAL_STATEMENT: SIGNAL SQLSTATE STRING SET MESSAGE_TEXT EQ STRING

DELIMITER_STATEMENT:
  DELIMITER DD_DELIMITER  { drv.inDifferentDelimiter = true;  }
  | DELIMITER SEMICOLON  { drv.inDifferentDelimiter = false;  }


%%

void yy::parser::error(const location_type& l, const std::string&m) {
  std::cerr << l << ": " << m << std::endl;
}

