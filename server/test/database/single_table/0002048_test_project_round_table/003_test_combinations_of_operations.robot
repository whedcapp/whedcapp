*** Settings ***
Documentation     This test suite tests creation of single valid projects as Whedcapp administrator
Library           DataDriver
...               file=${CURDIR}/003_test_combinations_of_operations.csv
...               reader_class=${CURDIR}/csv_reader_003_test_combinations_of_operations.py
...               encoding=utf-8
...               dialect=excel-tab
...               test_case_transformer_cls=TestCaseParTransformer
...               test_case_parameter_cls=TestCasePar
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Teardown     Tear Down Testcase
Test Template     Test Project Round Combination

*** Variables ***
${TIME}                2020-06-15
${YEAR}                2021
${BREAK_DATE_1}        14
${BREAK_DATE_2}        15
${ADAM_PROJECT_KEY}    'adam'
${BERTIL_PROJECT_KEY}  'bertil'
${PROJECT_START_DATE}  2021-04-15
${PROJECT_END_DATE}    2021-09-14

*** Test Cases ***
TC ${newProjectStartDateMonth} ${newProjectEndDateMonth} ${operation1} ${target1} ${operation2} ${target2} ${startDate1Month} ${endDate1Month} ${startDate2Month} ${endDate2Month} ${v1} ${violation_of_insert_bertil} ${violation_of_follow_up_on_insert_bertil} ${violation_of_project_operation1} ${violation_of_project_operation2} ${violation_of_project} ${violation}


*** Keywords ***
Test Project Round Combination
    [Arguments]    ${newProjectStartDateMonth}    ${newProjectEndDateMonth}    ${operation1}    ${target1}    ${operation2}    ${target2}    ${startDate1Month}    ${endDate1Month}    ${startDate2Month}    ${endDate2Month}    ${v1}    ${violation_of_insert_bertil}    ${violation_of_follow_up_on_insert_bertil}     ${violation_of_project_operation1}    ${violation_of_project_operation2}    ${violation_of_project}    ${violation}
    @{initIdProj}  Run Keyword
...                Initialize Test Case Tables
    @{orgProjRound}  Query  SELECT `id_proj_round` FROM `whedcapp`.`project_round` WHERE `proj_round_key` = ${ADAM_PROJECT_KEY}    True
    ${newProjectStartDate}  Catenate  SEPARATOR=-  ${YEAR}  ${newProjectStartDateMonth}  ${BREAK_DATE_2}
    ${newProjectEndDate}    Catenate  SEPARATOR=-  ${YEAR}  ${newProjectEndDateMonth}  ${BREAK_DATE_1}
    @{updateResult}  Execute SQL String  CALL `whedcapp`.`project_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${initIdProj[0][0]},'${newProjectStartDate}','${newProjectEndDate}',${ADAM_PROJECT_KEY},TRUE)    True
    ${operation1StartDate} =     Generate Date    ${operation1}    ${startDate1Month}    ${BREAK_DATE_2}
    ${operation1EndDate} =       Generate Date    ${operation1}    ${endDate1Month}      ${BREAK_DATE_1}
    ${operation2StartDate} =     Generate Date    ${operation2}    ${startDate2Month}    ${BREAK_DATE_2}
    ${operation2EndDate} =       Generate Date    ${operation2}    ${endDate2Month}      ${BREAK_DATE_1}
    @{correctResultOp1} =        Run Keyword Unless    ${violation_of_project_operation1} or ("${operation1}" == "insert" and "${target1}" == "bertil" and ${violation_of_insert_bertil})
...                              Perform Working Operation    ${initIdProj[0][0]}    ${operation1}    ${target1}    ${operation1StartDate}    ${operation1EndDate}
    Run Keyword If    (${violation_of_project_operation1} or ("${operation1}" == "insert" and "${target1}" == "bertil" and ${violation_of_insert_bertil}))
...                              Perform Project Violating Operation    ${initIdProj[0][0]}    ${operation1}    ${target1}    ${operation1StartDate}    ${operation1EndDate}
    @{correctResultOp2} =        Run Keyword If    not ${violation_of_project_operation2} and not ("${operation1}" == "insert" and "${target1}" == "bertil" and (((${violation_of_insert_bertil} or ${violation_of_project_operation1})and "${operation2}" == "update" and "${target2}" == "bertil") or ${violation_of_follow_up_on_insert_bertil} ))
...                              Perform Working Operation    ${initIdProj[0][0]}    ${operation2}    ${target2}    ${operation2StartDate}    ${operation2EndDate}
    Run Keyword If    (${violation_of_project_operation2} and not ("${operation1}" == "insert" and "${target1}" == "bertil" and (${violation_of_insert_bertil} or ${violation_of_follow_up_on_insert_bertil} or ${violation_of_project_operation1})))
...                              Perform Project Violating Operation    ${initIdProj[0][0]}    ${operation2}    ${target2}    ${operation2StartDate}    ${operation2EndDate}

Initialize Test Case Tables
    @{noOfIdProj}    Query    SELECT COUNT(`id_proj`) FROM `whedcapp`.`project`    True
    @{initIdProj}    Run Keyword If    ${noOfIdProj[0][0]} <= 0    Create List
    @{initIdProj}    Run Keyword If    ${noOfIdProj[0][0]} > 0
...                   Query    SELECT `id_proj` FROM `whedcapp`.`project`    True
    Run Keyword If    @{initIdProj} != []
...                   Delete All Projects    @{initIdProj}
    @{resultIdProj}       Query                 SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}','${PROJECT_START_DATE}','${PROJECT_END_DATE}',${ADAM_PROJECT_KEY},FALSE)    True
    Execute SQL String    CALL `whedcapp`.`project_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${resultIdProj[0][0]},'${PROJECT_START_DATE}','${PROJECT_END_DATE}',${ADAM_PROJECT_KEY},TRUE)    True
    Return From Keyword    @{resultIdProj}


Delete All Projects
    [Arguments]    @{initIdProj}
    FOR    ${id_proj}    IN    @{initIdProj}
        Execute SQL String    CALL `whedcapp`.`project_delete_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj[0]})    True
    END

    

Generate Date
    [Arguments]       ${operation}    ${month}    ${date}
    Run Keyword And Return If    "${operation}" != "delete"
...                              Catenate   SEPARATOR=-    ${YEAR}    ${month}    ${date}
    Return From Keyword    '-1'

Perform Project Violating Operation
    [Arguments]    ${id_proj}   ${operation}    ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "insert"
...      Perform Project Violating Insert Operation    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "update"
...      Perform Project Violating Update Operation    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "delete"    Fail

Perform Project Violating Insert Operation
    [Arguments]    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    Run Keyword And Expect Error    REGEXP:^.*Error:.*\\(.*1644,.*$
...           Query    SELECT `whedcapp`.`project_round_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj},'${startDate}','${endDate}','${target}',FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)    True

Perform Project Violating Update Operation
    [Arguments]    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    ${idProjRound} =    Query   SELECT `id_proj_round` FROM `whedcapp`.`project_round` WHERE `id_proj` = ${id_proj} and `proj_round_key` = "${target}"    True
    Run Keyword And Expect Error    REGEXP:^.*Error:.*\\(.*1644,.*$
...           Execute SQL String    CALL `whedcapp`.`project_round_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj},${idProjRound[0][0]},'${startDate}','${endDate}','${target}',FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)    True

Perform Working Operation
    [Arguments]    ${id_proj}   ${operation}    ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "insert"
...                   Perform Working Insert Operation    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "update"
...                   Perform Working Update Operation    ${id_proj}   ${target}    ${startDate}    ${endDate}    
    Run Keyword If    "${operation}" == "delete"
...                   Perform Working Delete Operation    ${id_proj}   ${target}


Perform Working Insert Operation
    [Arguments]    ${id_proj}    ${target}    ${startDate}    ${endDate}    
    @{correctResult} =     Query    SELECT `whedcapp`.`project_round_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj},'${startDate}','${endDate}','${target}',FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `proj_round_key` = '${target}'   1    True

Perform Working Update Operation
    [Arguments]    ${id_proj}    ${target}    ${startDate}    ${endDate}    
    ${idProjRound} =    Query   SELECT `id_proj_round` FROM `whedcapp`.`project_round` WHERE `id_proj` = ${id_proj} and `proj_round_key` = "${target}"    True
    Execute SQL String    CALL `whedcapp`.`project_round_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj},${idProjRound[0][0]},'${startDate}','${endDate}','${target}',FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `proj_round_key` = '${target}'   1    True

Perform Working Delete Operation
    [Arguments]    ${id_proj}    ${target} 
    @{idProjRound} =    Query    SELECT `id_proj_round` FROM `whedcapp`.`project_round` WHERE `id_proj` = ${id_proj} and `proj_round_key` = '${target}'    True
    Run Keyword If    @{idProjRound} != []
...                   Execute SQL String    CALL `whedcapp`.`project_round_delete_writeSelf`(${uidAdmin[0][0]},'${TIME}',${id_proj},${idProjRound[0][0]})
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `proj_round_key` = '${target}'   0    True


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uidAdmin}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    Set Suite Variable    ${uidAdmin}
    
Tear Down Testcase
    @{all11}        Query                      SELECT * FROM `whedcapp`.`project_round`    True
    @{all12}        Query                      SELECT * FROM `whedcapp`.`project`    True
    Run Keyword If Test Failed
...               Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `uid_text`= ""   0    False
    @{all21}        Query                      SELECT * FROM `whedcapp`.`project_round`    True
    @{all22}        Query                      SELECT * FROM `whedcapp`.`project`    False
    @{all31}        Query                      SELECT * FROM `whedcapp`.`project_round`    False
    @{all32}        Query                      SELECT * FROM `whedcapp`.`project`    False
