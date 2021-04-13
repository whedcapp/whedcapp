*** Settings ***
Documentation     This test suite tests correct variants of updating of uid
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Delete other uid as administrator should succeed

*** Variables ***
${UID_SPEC3}   'testuser@somwhere.org'
${TIME}        '2021-01-01 01:01:01'

*** Keywords ***
Delete other uid as administrator should succeed
    [Arguments]             ${tc}
    ${uid_admin}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}               Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uid_admin[0][0]},${TIME},${UID_SPEC3},FALSE,FALSE,FALSE,FALSE)    True
    ${uid_user}             Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${UID_SPEC3}    True
    Execute SQL String      CALL `whedcapp`.`uid_delete_writeOther`(${uid_admin[0][0]},${TIME},${uid_user[0][0]})    False


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uid_admin}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True







*** Test Cases ***                           
Attempt 01 to Delete Other Uid    tc               




