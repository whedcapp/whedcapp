*** Settings ***
Documentation     This test suite tests removal of the whedcapp administrator (superuser) and it should fail
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Update self uid should fail

*** Variables ***
${UID_NO1}     ${UID_AMOUNT1}
${UID_NO2}     ${UID_AMOUNT2}
${UID_NO3}     ${UID_AMOUNT3}
${UID_SPEC1}   'email@somewhere.org'
${UID_SPEC2}   ${ADMIN}
${UID_SPEC3}   '{a-zA-Z}{a-zA-Z0-9}*\@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*'

*** Keywords ***
Update self uid should fail
    [Arguments]                ${uid_no}    ${uid_spec}    
    ${uidAdmin}                Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${result2} =     Run Keyword And Expect Error     EQUALS:OperationalError: (1644, 'Cannot delete whedcapp administrator')
...                  Execute SQL String    CALL `whedcapp`.`uid_delete_writeSelf`(${uidAdmin[0][0]})    False


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    @{result}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True







*** Test Cases ***                          UID_NO        UID_SPEC    
Attempt 01 to Delete Self Uid Fails         ${UID_NO1}    ${UID_SPEC1}




