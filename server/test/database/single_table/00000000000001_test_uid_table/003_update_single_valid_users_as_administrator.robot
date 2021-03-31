*** Settings ***
Documentation     This test suite tests correct variants of updating of uid
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Update self uid should succeed

*** Variables ***
${UID_NO1}     ${UID_AMOUNT1}
${UID_NO2}     ${UID_AMOUNT2}
${UID_NO3}     ${UID_AMOUNT3}
${UID_SPEC1}   ${ADMIN}
${UID_SPEC2}   'email@somewhere.org'
${UID_SPEC3}   '{a-zA-Z}{a-zA-Z0-9}*\@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*'

*** Keywords ***
Update self uid should succeed
    [Arguments]                ${uid_no}    ${uid_spec}    ${is_superuser}    ${is_pdc}    ${is_adm}    ${is_qm}  
    ${uidAdmin}                Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    Execute SQL String         CALL `whedcapp`.`uid_update_writeSelf`(${uidAdmin[0][0]},${uid_spec},${is_superuser},${is_pdc},${is_adm},${is_qm})    True
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    1    True

Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    @{result}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True







*** Test Cases ***                          UID_NO        UID_SPEC        SUPERUSER    PDC      ADM      QM       
Attempt 01 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         False    False    False    
Attempt 02 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         False    False    True     
Attempt 03 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         False    True     False    
Attempt 04 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         False    True     True     
Attempt 05 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         True     False    False    
Attempt 06 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         True     False    True     
Attempt 07 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         True     True     False    
Attempt 08 to Update Self Uid               ${UID_NO1}    ${UID_SPEC1}    True         True     True     True     



