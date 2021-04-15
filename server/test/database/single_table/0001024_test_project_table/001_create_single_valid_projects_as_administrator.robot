*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
Suite Teardown    Disconnect From Database
Test Template     Create single consistent UID should succeed

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
Create single consistent UID should succeed
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}    Query    SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},'${TIME}','${start_date}','${end_date}',${proj_key},${proj_marked_for_deletion});    True
    Log Many    @{result}
    @{result2}   Query    SELECT `proj_round_key`,`start_date`,time(`start_date`),`end_date`,time(`end_date`),`id_proj` FROM `whedcapp`.`project_round`    True
    Log Many    @{result2}
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project` WHERE `proj_key` = ${proj_key}                                            1    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `id_proj` = ${result[0][0]}                                   1    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `id_proj` = ${result[0][0]} AND `start_date` = '${start_date}'                                   1    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`project_round` WHERE `id_proj` = ${result[0][0]} AND `end_date` = '${end_date}'                                   1    True






*** Test Cases ***                            start_date             end_date               proj_key       proj_marked_for_deletion
Attempt 01 to Create One Valid Project        ${START_DATE1}         ${END_DATE1}           ${PROJ_KEY1}    False     
Attempt 02 to Create One Valid Project        ${START_DATE1}         ${END_DATE2}           ${PROJ_KEY2}    False     
Attempt 03 to Create One Valid Project        ${START_DATE2}         ${END_DATE1}           ${PROJ_KEY3}    False     
Attempt 04 to Create One Valid Project        ${START_DATE2}         ${END_DATE2}           ${PROJ_KEY4}    False     




