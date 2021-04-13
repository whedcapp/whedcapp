*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
Suite Teardown    Disconnect From Database
Test Template     Create single consistent UID should succeed

*** Variables ***
${TIME}        '2021-01-01 01:01:01'

*** Keywords ***
Create single consistent UID should succeed
    [Arguments]           ${start_date}  ${end_date}  ${proj_key}  ${proj_marked_for_deletion}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}    Query    SELECT `whedcapp`.`project_insert_writeSelf`(${uidAdmin[0][0]},${TIME},${start_date},${end_date},${proj_key},${proj_marked_for_deletion});
    Log Many    @{result}
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `proj_key` = ${proj_key}    1    False





*** Test Cases ***                            start_date             end_date               proj_key  proj_marked_for_deletion
Attempt 01 to Create One Valid Project        '2021-01-01 01:01:01'  '2021-10-01 00:00:00'  'adam'    False     




