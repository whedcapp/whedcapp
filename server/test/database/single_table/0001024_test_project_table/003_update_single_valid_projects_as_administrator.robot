*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Update Some Combination

*** Variables ***
${TIME} =       2021-01-01
${START_DATE1}  2021-01-01
${END_DATE1}    2021-10-01
${START_DATE2}  2021-02-01
${END_DATE2}    2021-11-01
${PROJ_KEY1}    'adam'
${PROJ_KEY2}    'bertil'
${PROJ_KEY3}    'cesar'
${PROJ_KEY4}    'david'

*** Keywords ***
Update Some Combination
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}  ${nstart_date}  ${nend_date}  ${nproj_key}  ${nproj_marked_for_deletion}    ${success}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result1}   Query    SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}','${start_date}','${end_date}',${proj_key},${proj_marked_for_deletion});    True
    Log Many    @{result1}
    Run Keyword If    ${success}  
...                   Execute SQL String    CALL `whedcapp`.`project_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${result1[0][0]},'${nstart_date}','${nend_date}',${nproj_key},${nproj_marked_for_deletion})    True
    Run Keyword Unless    ${success}
...                   Run Keyword And Expect Error    STARTS:OperationalError:
...                   Execute SQL String    CALL `whedcapp`.`project_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${result1[0][0]},'${nstart_date}','${nend_date}',${nproj_key},${nproj_marked_for_deletion})    True
    @{result2}    Query    SELECT * FROM `whedcapp`.`project`    False
    Log Many    @{result2}


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}




*** Test Cases ***   start_date    end_date    proj_key    proj_marked_for_deletion    nstart_date    nend_date    nproj_key    nproj_marked_for_deletion    success
Case 01              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-03-01   'adam'       True                         False
Case 02              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-03-01   'adam'       False                        False
Case 03              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-07-08   'adam'       True                         True
Case 04              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-07-08   'adam'       True                         False
Case 05              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-03-01   'adam'       True                         False
Case 06              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-07-08   'adam'       False                        False
Case 07              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-01-01   'adam'       True                         False
Case 08              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-03-01   'adam'       False                        False
Case 09              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-07-08   'adam'       False                        True
Case 10              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-07-08   'adam'       True                         False
Case 11              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-01-01   'adam'       False                        False
Case 12              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-03-01   'adam'       True                         False
Case 13              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-08-08   'adam'       True                         True
Case 14              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-03-01   'adam'       False                        False
Case 15              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-07-08   'adam'       False                        True
Case 16              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-08-08   'adam'       True                         False
Case 17              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-07-08   'adam'       False                        False
Case 18              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-08-08   'adam'       False                        False
Case 19              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-08-08   'adam'       False                        False
Case 20              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-01-01   'adam'       False                        False
Case 21              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-01-01   'adam'       False                        False
Case 22              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-03-01   'adam'       False                        False
Case 23              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-07-08   'adam'       True                         True
Case 24              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-01-01   'adam'       True                         False
Case 25              2020-02-01    2020-07-08  'adam'      False                       2020-08-08     2020-08-08   'adam'       True                         False
Case 26              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-03-01   'adam'       True                         False
Case 27              2020-02-01    2020-07-08  'adam'      False                       2020-02-01     2020-08-08   'adam'       False                        True
Case 28              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-01-01   'adam'       True                         False
Case 29              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-08-08   'adam'       True                         True
Case 30              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-08-08   'adam'       False                        True
Case 31              2020-02-01    2020-07-08  'adam'      False                       2020-01-01     2020-01-01   'adam'       True                         False
Case 32              2020-02-01    2020-07-08  'adam'      False                       2020-03-01     2020-01-01   'adam'       False                        False






