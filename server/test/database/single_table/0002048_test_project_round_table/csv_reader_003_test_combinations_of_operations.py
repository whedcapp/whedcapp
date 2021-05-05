from augmentable_csv_reader import *
@test_case_class
class TestCasePar(TestCaseParIface):
    "Actual test case implementation"

    @staticmethod
    def _violation_of_original_adam(start_month: int, end_month: int) -> bool:
        "check if months violates period of original adam [4-9]"
        def check_start_month_in_adam_interval():
            return 4 < start_month <= 9
        def check_end_month_in_adam_interval():
            return 4 <= end_month < 9
        def check_start_month_and_end_month_overlaps_adam():
            return \
                start_month != -1 and \
                end_month != -1 and \
                start_month <= 4 and \
                end_month >= 9
        return \
            check_start_month_in_adam_interval() or \
            check_end_month_in_adam_interval() or \
            check_start_month_and_end_month_overlaps_adam()

    @test_case_transformer_in_phase(1, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation_of_insert_bertil(self):
        "check if test case violates condition by insert bertil"
        if self.operation1_ == "insert" and \
           self.target1_ == "bertil" and \
           self._violation_of_original_adam(self.startDate1Month_, self.endDate1Month_):
            return True
        return False

    @test_case_transformer_in_phase(2, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation_of_follow_up_on_insert_bertil(self):
        "check if test case violates condition in operation2"
        def check_update_adam_preceedes_bertil():
            return \
                self.startDate2Month_ < self.startDate1Month_ and \
                self.endDate2Month_ <= self.startDate1Month_
        def check_update_adam_succeeds_bertil():
            return \
                self.startDate2Month_ >= self.endDate1Month_ and \
                self.endDate2Month_ > self.endDate1Month_
        def check_update_adam():
            return \
                self.operation2_ == "update" and \
                self.target2_ == "adam" and \
                not ( \
                      check_update_adam_preceedes_bertil() or \
                      check_update_adam_succeeds_bertil() \
                )
        def check_update_bertil():
            return \
                self.operation2_ == "update" and \
                self.target2_ == "bertil" and \
                self._violation_of_original_adam(self.startDate2Month_, self.endDate2Month_)


        if self.operation1_ == "insert" and self.target1_ == "bertil" and \
           (check_update_adam() or check_update_bertil()):
            return True
        return False

    @test_case_transformer_in_phase(3, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation_of_project_operation1(self):
        return \
            (self.startDate1Month_ != -1 and \
             self.newProjectStartDateMonth_ > self.startDate1Month_) or \
            (self.endDate1Month_ != -1 and \
             self.newProjectEndDateMonth_ < self.endDate1Month_)
        

    @test_case_transformer_in_phase(3, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation_of_project_operation2(self):
        return \
            (self.startDate2Month_ != -1 and \
             self.newProjectStartDateMonth_ > self.startDate2Month_) or \
            (self.endDate2Month_ != -1 and \
             self.newProjectEndDateMonth_ < self.endDate2Month_)
    
    @test_case_transformer_in_phase(4, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation_of_project(self):
        return \
            self.violation_of_project_operation1_ or\
            self.violation_of_project_operation2_


    @test_case_transformer_in_phase(5, bool, TestCaseTransScope.PER_TEST_CASE)
    def violation(self):
        "Summary view of violations"
        return \
            self.violation_of_project_ or \
            self.violation_of_insert_bertil_ or \
            self.violation_of_follow_up_on_insert_bertil_




class TestCaseParTransformer(TestCaseParTransIface):
    "Test case transformer using default transformation algorithm"

class csv_reader_003_test_combinations_of_operations(augmentable_csv_reader):
    "Actual CSV reader"
