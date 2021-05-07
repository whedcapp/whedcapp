*** Settings ***
Documentation     This test suite tests creation of single invalid projects as other
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Setup        Run Keyword    Whedcapp Truncate Project
Test Template     Create single invalid project should fail

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
${PROJ_KEY5}    ''
${PROJ_KEY6}    'fredrik'
${OTHERADMIN}   'testadm@somewhere.org'

*** Keywords ***
Create single invalid project should fail
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidOtherAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${OTHERADMIN}    True
    ${result} =     Run Keyword And Expect Error     STARTS:InternalError:
...                 Query    SELECT `whedcapp`.`project_insert_writeOther`(${uidAdmin[0][0]},'${TIME}',${uidOtherAdmin[0][0]},'${start_date}','${end_date}',${proj_key},${proj_marked_for_deletion});    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project` WHERE `proj_key` = ${proj_key}                                            0    True

Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidOtherAdmin}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}',${OTHERADMIN},FALSE,FALSE,TRUE,FALSE)    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `id_uid` = ${uidOtherAdmin[0][0]} AND `uid_is_whedcapp_administrator`    1     True





*** Test Cases ***                              start_date             end_date               proj_key       proj_marked_for_deletion
Attempt 01 to Create One InValid Project        ${END_DATE1}         ${START_DATE1}           ${PROJ_KEY1}    False     
Attempt 02 to Create One InValid Project        ${END_DATE1}         ${START_DATE2}           ${PROJ_KEY2}    False     
Attempt 03 to Create One InValid Project        ${END_DATE2}         ${START_DATE1}           ${PROJ_KEY3}    False     
Attempt 04 to Create One InValid Project        ${END_DATE2}         ${START_DATE2}           ${PROJ_KEY4}    False     
Attempt 05 to Create One InValid Project        ${START_DATE2}       ${END_DATE2}             ${PROJ_KEY5}    False     
Attempt 06 to Create One InValid Project        ${START_DATE2}       ${END_DATE2}             ${PROJ_KEY6}    True     




