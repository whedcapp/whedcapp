"Interfaces for extensible type csv reader for robot framework data driver extension"

    # This File Is Part Of Whedcapp - Well-Being Health Environment Data Collection App - to collect self-evaluated data for research purpose
    # Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

    # Whedcapp is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # Whedcapp is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with Whedcapp.  If not, see <https://www.gnu.org/licenses/>.


import abc
import csv
import datetime
import distutils.util
import enum
import pdb
import sys
import time
import typing
from DataDriver.AbstractReaderClass import AbstractReaderClass  # inherit class from AbstractReaderClass
from DataDriver.ReaderConfig import TestCaseData, ReaderConfig  # return list of TestCaseData to DataDriver

AnyType = typing.TypeVar('T')
CT = typing.NewType('CT', typing.Union[str, int, float, bool, typing.Any])


def get_typed_value_of(value: typing.Any) -> CT:
    "Iterate over coercion functions and return a typed value according to priority order"
    value_classes = [(lambda val: int(val)), \
                     (lambda val: bool(distutils.util.strtobool(val))), \
                     (lambda val: float(val)), \
                     (lambda val: datetime.datetime.fromisoformat(val)), \
                     (lambda val: time.strptime(val, "%H:%M:%S")), \
                     (lambda val: str(val))]
    for val_cls in value_classes:
        try:
            return val_cls(value)
        except (ValueError, AttributeError, TypeError):
            pass

def get_type_of(value: typing.Any) -> AnyType:
    "returns the type of the value"
    return type(get_typed_value_of(value))

class TestCaseTransScope(enum.Enum):
    "Test case scope for transformation rules"
    PER_TEST_CASE = 1
    PER_TEST_SUITE = 2

def test_case_class(cls):
    "class decorator, used to set up cls_transform_columns in cls"
    cls.cls_transform_columns = {}
    cls.cls_derived_column_types = {}
    for meth_name in dir(cls):
        meth = getattr(cls, meth_name)
        if hasattr(meth, '_phase'):
            assert \
                len(meth._phase) == 3 and \
                isinstance(meth._phase[0], int) and \
                isinstance(meth._phase[1], type) and \
                isinstance(meth._phase[2], TestCaseTransScope)
            if not meth._phase[0] in  cls.cls_transform_columns:
                seq_of_meths = []
                cls.cls_transform_columns[meth._phase[0]] = seq_of_meths
            else:
                seq_of_meths = cls.cls_transform_columns[meth._phase[0]]
            seq_of_meths.append(meth_name)
            if meth._phase[2] == TestCaseTransScope.PER_TEST_CASE:
                cls.cls_derived_column_types[meth_name+"_"] = meth._phase[1]
    return cls

def test_case_transformer_in_phase(*args):
    "Test case transformation method decorator"
    def wrapper(func):
        func._phase = args
        return func
    return wrapper

class TestCaseParIface(metaclass=abc.ABCMeta):
    "Test case parameters interface"
    cls_column_types = {}
    cls_column_to_order = {}
    cls_order_to_column = {}
    cls_derived_column_types = {}
    cls_transform_columns = {}
    @classmethod
    def __subclasshook__(cls, subclass: typing.Type[AnyType]):
        return (hasattr(subclass, '__init__') and
                callable(subclass.__init__) and
                hasattr(subclass, 'transform') and
                callable(subclass.transform) or
                NotImplemented)
    def __init__(self, row: typing.Mapping[str, CT]):
        for key, value in row.items():
            typed_value = get_typed_value_of(value)
            assert isinstance(typed_value, self.cls_column_types[key+"_"])
            setattr(self, key+"_", typed_value)

    def __str__(self):
        result = ""
        not_first = False
        for key in \
            list(self.__class__.cls_column_types.keys()) + \
            list(self.__class__.cls_derived_column_types.keys()):
            if not_first:
                result += ", "
            result += key + " = "
            try:
                result += str(getattr(self, key))
            except AttributeError:
                result += "\"N/A\""
            not_first = True
        return result

    def get_csv_header_string(self):
        "Returns string of CSV header with tab separators"
        result = ""
        not_first = False
        for index, col in self.__class__.cls_order_to_column.items():
            if not_first:
                result += "\t"
            result += col[0:len(col)-1] # everything but '_'
            not_first = True
        return result

    def get_csv_string(self):
        "Returns string of CSV with tab separators"
        result = ""
        not_first = False
        for index, col in self.__class__.cls_order_to_column.items():
            if not_first:
                result += "\t"
            result += str(getattr(self, col))
            not_first = True
        return result

    def get_csv_header_row(self):
        "Returns a list of strings representing the header"
        result = ['*** Test Cases ***']
        for index, col in self.__class__.cls_order_to_column.items():
            result.append('${'+col[0:len(col)-1]+'}')
        return result

    def get_csv_row(self, row_index: int):
        "Returns a list of string representing the row"
        result = []
        result.append('Test case {id}'.format(id = str(row_index)))
        for index, col in self.__class__.cls_order_to_column.items():
            result.append(str(getattr(self, col)))
        return result


    def transform(self, phase: int):
        "transforms a test case in phase"
        for meth_name in self.__class__.cls_transform_columns[phase]:
            meth = getattr(self, meth_name)
            result = meth()
            assert \
                (meth._phase[2] == TestCaseTransScope.PER_TEST_CASE and \
                 isinstance(result, self.__class__.cls_derived_column_types[meth_name+"_"]) \
                ) or \
                (meth._phase[2] == TestCaseTransScope.PER_TEST_SUITE and \
                 not isinstance(result, self.__class__.cls_derived_column_types[meth_name+"_"]) \
                )

            if meth._phase[2] == TestCaseTransScope.PER_TEST_CASE:
                setattr(self, meth_name+"_", meth())
                if not meth_name+"_" in self.__class__.cls_column_to_order:
                    idx = len(self.__class__.cls_column_to_order)
                    self.__class__.cls_column_to_order[meth_name+"_"] = idx
                    self.__class__.cls_order_to_column[idx] = meth_name+"_"
            elif meth._phase[2] == TestCaseTransScope.PER_TEST_SUITE:
                setattr(self.__class__, meth_name+"_", meth())
            else:
                raise AttributeError

class TestCaseParTransIface(metaclass=abc.ABCMeta):
    "Test case parameter transformer interface"
    @classmethod
    def __subclasshook__(cls, subclass):
        return (hasattr(subclass, 'test_case_transformer') and
                callable(subclass.test_case_transformer) or
                NotImplemented)

    def __init__(self, test_case_par_cls: typing.Type[TestCaseParIface]):
        self.test_case_par_cls = test_case_par_cls

    def test_case_transformer(self, list_of_test_cases: typing.List[TestCaseParIface]) \
        -> typing.List[TestCaseParIface]:
        "Transformix, ....."
        for phase in sorted(self.test_case_par_cls.cls_transform_columns.keys()):
            for test_case in list_of_test_cases:
                test_case.transform(phase)
        return list_of_test_cases

class augmentable_csv_reader(AbstractReaderClass):
    "Generate expected output library"
    _test_case_transformer_cls_attr_name = 'test_case_transformer_cls'
    _test_case_parameter_cls_attr_name = 'test_case_parameter_cls'

    def __init__(self, reader_config: ReaderConfig):
        super().__init__(reader_config)
        if not augmentable_csv_reader._test_case_transformer_cls_attr_name in self.kwargs:
            raise AttributeError
        if not augmentable_csv_reader._test_case_parameter_cls_attr_name in self.kwargs:
            raise AttributeError
        test_case_transformer_cls_name = self.kwargs[augmentable_csv_reader._test_case_transformer_cls_attr_name]
        test_case_parameter_cls_name = self.kwargs[augmentable_csv_reader._test_case_parameter_cls_attr_name]
        self.test_case_parameter_cls = getattr(sys.modules[self.__class__.__module__],test_case_parameter_cls_name)
        if not isinstance(self.test_case_parameter_cls,type):
            raise AttributeError
        self.test_case_transformer = getattr(sys.modules[self.__class__.__module__],test_case_transformer_cls_name)(self.test_case_parameter_cls)
        


    def _load_test_case_parameters(self, path: str) \
        -> typing.List[TestCaseParIface]:
        "read csv and convert to test cases"
        assert isinstance(path, str)
        with open(path, "r", encoding=self.csv_encoding) as csvfile:
            reader0 = csv.reader(csvfile, dialect=self.csv_dialect)
            for row in reader0:
                index = 0
                for col in row:
                    self.test_case_parameter_cls.cls_column_to_order[col+"_"] = index
                    self.test_case_parameter_cls.cls_order_to_column[index] = col+"_"
                    index = index + 1
                break


            csvfile.seek(0)
            reader = csv.DictReader(csvfile, dialect=self.csv_dialect)
            test_cases = []
            candidate_column_types = {}
            for row in reader:
                for key, value in row.items():
                    if not key+"_" in candidate_column_types:
                        tmp_s = set()
                        tmp_s.add(get_type_of(value))
                        candidate_column_types[key+"_"] = tmp_s
                    else:
                        tmp_s = candidate_column_types[key+"_"]
                        tmp_s.add(get_type_of(value))
            actual_column_types = {}
            for (key, set_of_types) in candidate_column_types.items():
                if len(set_of_types) > 1:
                    actual_column_types[key] = str
                else:
                    for types in set_of_types:
                        actual_column_types[key] = types
            print(actual_column_types)
            self.test_case_parameter_cls.cls_column_types = actual_column_types
            csvfile.seek(0)
            first = True
            for row in reader:
                if first:
                    first = False
                    continue
                test_case = self.test_case_parameter_cls(row)
                test_cases.append(test_case)
        return test_cases

    def _augment_test_case_parameters(self, \
                                      test_cases: typing.List[TestCaseParIface]) \
        -> typing.List[TestCaseParIface]:
        "augment test case parameters by, for example, adding expected output columns"
        assert isinstance(test_cases, list)
        #check that all test cases are of proper types
        for test_case in test_cases:
            assert all(map((lambda ct: isinstance(getattr(test_case, ct[0]), ct[1])), \
                           test_case.cls_column_types.items()))
        return self.test_case_transformer.test_case_transformer(test_cases)



    def _register_dialects(self):
        if self.csv_dialect.lower() == "userdefined":
            csv.register_dialect(
                self.csv_dialect,
                delimiter=self.delimiter,
                quotechar=self.quotechar,
                escapechar=self.escapechar,
                doublequote=self.doublequote,
                skipinitialspace=self.skipinitialspace,
                lineterminator=self.lineterminator,
                quoting=csv.QUOTE_ALL,
            )
        elif self.csv_dialect == "Excel-EU":
            csv.register_dialect(
                self.csv_dialect,
                delimiter=";",
                quotechar='"',
                escapechar="\\",
                doublequote=True,
                skipinitialspace=False,
                lineterminator="\r\n",
                quoting=csv.QUOTE_ALL,
            )
            
    def get_data_from_source(self):
        self._register_dialects()

        # get the test case parameters from the CSV file in a typed way
        test_cases = self._load_test_case_parameters(self.file)

        # augment with, for example, expected output per test case or per test suite
        # according to TestCaseTransIface and TestCaseParIface
        augmented_test_cases = self._augment_test_case_parameters(test_cases)
        
        # send headers to abstract reader in Robotframework-Datadriver
        self._analyse_header(test_cases[0].get_csv_header_row())

        # register the row to the abstract reader to obtain
        # proper format for Robotframework-Datadriver
        for index, test_case in enumerate(test_cases):
            self._read_data_from_table(test_case.get_csv_row(index))
        
        # return rows in expected format for Robotframework-Datadriver
        return self.data_table
