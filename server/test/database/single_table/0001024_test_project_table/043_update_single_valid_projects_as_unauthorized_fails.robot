*** Settings ***
Documentation     This test suite tests updating of single valid projects in valid and invalid ways as project owner. The test case data has been generated by pict using triplet-coverage.
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
${USER}        'testuser@somewhere.org'

*** Keywords ***
Update Some Combination
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}  ${nstart_date}  ${nend_date}  ${nproj_key}  ${nproj_marked_for_deletion}    ${success}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidUser}   Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${USER}    True
    @{result1}   Query    SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}','${start_date}','${end_date}',${proj_key},${proj_marked_for_deletion});    True
    Log Many    @{result1}
    Run Keyword And Expect Error    EQUALS:InternalError: (1644, 'You are not allowed to update a/an PROJECT for own domain. You must be either an administrator or a project owner.')
...                   Execute SQL String    CALL `whedcapp`.`project_update_writeSelf`(${uidUser[0][0]},'${TIME}',${result1[0][0]},'${nstart_date}','${nend_date}',${nproj_key},${nproj_marked_for_deletion})    True
    @{result2}    Query    SELECT * FROM `whedcapp`.`project`    True
    Log Many    @{result2}


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidUser}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}',${USER},FALSE,FALSE,FALSE,FALSE)    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `id_uid` = ${uidUser[0][0]} AND NOT `uid_is_whedcapp_administrator`    1     True




*** Test Cases ***   start_date    end_date    proj_key      proj_marked_for_deletion    nstart_date    nend_date    nproj_key    nproj_marked_for_deletion    success
Case 01              2020-02-01    2020-07-08  'adam01'      False                       2020-08-08     2020-03-01   'adam01'     True                         False
Case 02              2020-02-01    2020-07-08  'adam02'      False                       2020-01-01     2020-03-01   'adam02'     False                        False
Case 03              2020-02-01    2020-07-08  'adam03'      False                       2020-01-01     2020-07-08   'adam03'     True                         True
Case 04              2020-02-01    2020-07-08  'adam04'      False                       2020-03-01     2020-07-08   'adam04'     True                         False
Case 05              2020-02-01    2020-07-08  'adam05'      False                       2020-03-01     2020-03-01   'adam05'     True                         False
Case 06              2020-02-01    2020-07-08  'adam06'      False                       2020-03-01     2020-07-08   'adam06'     False                        False
Case 07              2020-02-01    2020-07-08  'adam07'      False                       2020-08-08     2020-01-01   'adam07'     True                         False
Case 08              2020-02-01    2020-07-08  'adam08'      False                       2020-08-08     2020-03-01   'adam08'     False                        False
Case 09              2020-02-01    2020-07-08  'adam09'      False                       2020-01-01     2020-07-08   'adam09'     False                        True
Case 10              2020-02-01    2020-07-08  'adam10'      False                       2020-08-08     2020-07-08   'adam10'     True                         False
Case 11              2020-02-01    2020-07-08  'adam11'      False                       2020-01-01     2020-01-01   'adam11'     False                        False
Case 12              2020-02-01    2020-07-08  'adam12'      False                       2020-02-01     2020-03-01   'adam12'     True                         False
Case 13              2020-02-01    2020-07-08  'adam13'      False                       2020-02-01     2020-08-08   'adam13'     True                         True
Case 14              2020-02-01    2020-07-08  'adam14'      False                       2020-03-01     2020-03-01   'adam14'     False                        False
Case 15              2020-02-01    2020-07-08  'adam15'      False                       2020-02-01     2020-07-08   'adam15'     False                        True
Case 16              2020-02-01    2020-07-08  'adam16'      False                       2020-03-01     2020-08-08   'adam16'     True                         False
Case 17              2020-02-01    2020-07-08  'adam17'      False                       2020-08-08     2020-07-08   'adam17'     False                        False
Case 18              2020-02-01    2020-07-08  'adam18'      False                       2020-03-01     2020-08-08   'adam18'     False                        False
Case 19              2020-02-01    2020-07-08  'adam19'      False                       2020-08-08     2020-08-08   'adam19'     False                        False
Case 20              2020-02-01    2020-07-08  'adam20'      False                       2020-02-01     2020-01-01   'adam20'     False                        False
Case 21              2020-02-01    2020-07-08  'adam21'      False                       2020-08-08     2020-01-01   'adam21'     False                        False
Case 22              2020-02-01    2020-07-08  'adam22'      False                       2020-02-01     2020-03-01   'adam22'     False                        False
Case 23              2020-02-01    2020-07-08  'adam23'      False                       2020-02-01     2020-07-08   'adam23'     True                         True
Case 24              2020-02-01    2020-07-08  'adam24'      False                       2020-02-01     2020-01-01   'adam24'     True                         False
Case 25              2020-02-01    2020-07-08  'adam25'      False                       2020-08-08     2020-08-08   'adam25'     True                         False
Case 26              2020-02-01    2020-07-08  'adam26'      False                       2020-01-01     2020-03-01   'adam26'     True                         False
Case 27              2020-02-01    2020-07-08  'adam27'      False                       2020-02-01     2020-08-08   'adam27'     False                        True
Case 28              2020-02-01    2020-07-08  'adam28'      False                       2020-03-01     2020-01-01   'adam28'     True                         False
Case 29              2020-02-01    2020-07-08  'adam29'      False                       2020-01-01     2020-08-08   'adam29'     True                         True
Case 30              2020-02-01    2020-07-08  'adam30'      False                       2020-01-01     2020-08-08   'adam30'     False                        True
Case 31              2020-02-01    2020-07-08  'adam31'      False                       2020-01-01     2020-01-01   'adam31'     True                         False
Case 32              2020-02-01    2020-07-08  'adam32'      False                       2020-03-01     2020-01-01   'adam32'     False                        False






