*** Settings ***
Documentation     This test suite tests correct variants of updating of uid
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Delete other uid as non administrator should fail

*** Variables ***
${UID_SPEC2}   'testuser1@somwhere.org'
${UID_SPEC3}   'testuser2@somwhere.org'
${TIME}        '2021-01-01 01:01:01'

*** Keywords ***
Delete other uid as non administrator should fail
    [Arguments]             ${tc}
    ${uid_admin}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}               Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uid_admin[0][0]},${TIME},${UID_SPEC3},FALSE,FALSE,FALSE,FALSE)    True
    @{result}               Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uid_admin[0][0]},${TIME},${UID_SPEC2},FALSE,FALSE,FALSE,FALSE)    True
    ${uid_user2}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${UID_SPEC2}    True
    ${uid_user3}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${UID_SPEC3}    True
    ${result2}              Run Keyword And Expect Error    EQUALS:InternalError: (1644, 'You are not allowed to delete a/an UID for others domain. You must be either a superuser or a whedcapp administrator.')
...                         Execute SQL String      CALL `whedcapp`.`uid_delete_writeOther`(${uid_user2[0][0]},${TIME},${uid_user3[0][0]})    False


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uid_admin}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True







*** Test Cases ***                           
Attempt 01 to Delete Other Uid    1               




