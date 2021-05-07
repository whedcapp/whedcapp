*** Settings ***
Documentation     This test suite tests deletion of projects as administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Setup        Run Keyword    Whedcapp Truncate Project
Test Template     Delete project not marked for deletion as other administrator should fail

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
${OTHERADMIN}   'testadm@somewhere.org'

*** Keywords ***
Delete project not marked for deletion as other administrator should fail
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}
    ${uidAdmin}       Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidOtherAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${OTHERADMIN}    True
    ${result1} =      Query    SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}','${start_date}','${end_date}',${proj_key},${proj_marked_for_deletion});    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project` WHERE `proj_key` = ${proj_key}                                            1    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `id_proj` IN (SELECT `id_proj` FROM `whedcapp`.`project` WHERE `proj_key` = ${proj_key})                                            1    True
    Execute SQL String    CALL `whedcapp`.`project_update_writeSelf`(${uidAdmin[0][0]},'${TIME}',${result1[0][0]},'${start_date}','${end_date}',${proj_key},FALSE);    True
    Run Keyword And Expect Error    STARTS:InternalError:
...                            Execute SQL String    CALL `whedcapp`.`project_delete_writeOther`(${uidAdmin[0][0]},'${TIME}',${result1[0][0]},${uidOtherAdmin[0][0]});    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project` WHERE `proj_key` = ${proj_key}                                            1    True

Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidOtherAdmin}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}',${OTHERADMIN},FALSE,FALSE,TRUE,FALSE)    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `id_uid` = ${uidOtherAdmin[0][0]} AND `uid_is_whedcapp_administrator`    1     True




*** Test Cases ***                  start_date             end_date               proj_key       proj_marked_for_deletion
Attempt 01 to Delete Project        ${START_DATE1}         ${END_DATE1}           ${PROJ_KEY1}   False     
Attempt 02 to Delete Project        ${START_DATE1}         ${END_DATE2}           ${PROJ_KEY2}   False     
Attempt 03 to Delete Project        ${START_DATE2}         ${END_DATE1}           ${PROJ_KEY3}   False     
Attempt 04 to Delete Project        ${START_DATE2}         ${END_DATE2}           ${PROJ_KEY4}   False     




