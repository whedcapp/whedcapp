*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
Suite Teardown    Disconnect From Database
Test Template     Create single consistent UID should succeed

*** Variables ***
${UID_NO1}     ${UID_AMOUNT1}
${UID_NO2}     ${UID_AMOUNT2}
${UID_NO3}     ${UID_AMOUNT3}
${UID_SPEC1}   'email@somewhere.org'
${UID_SPEC2}   'email@somewhere.org'
${UID_SPEC3}   '{a-zA-Z}{a-zA-Z0-9}*\@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*'

*** Keywords ***
Create single consistent UID should succeed
    [Arguments]           ${uid_no}    ${uid_spec}    ${is_superuser}    ${is_pdc}    ${is_adm}    ${is_qm}    ${seed}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}
    @{result}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin},${uid_spec},${is_superuser},${is_pdc},${is_adm},${is_qm})
    Log Many    @{result}


*** Test Cases ***                                UID_NO        UID_SPEC        SUPERUSER    PDC      ADM      QM       SEED
Attempt 01 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    False    False    0
Attempt 02 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    False    True     0
Attempt 03 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    True     False    0
Attempt 04 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    True     True     0
Attempt 05 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     False    False    0
Attempt 06 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     False    True     0
Attempt 07 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     True     False    0
Attempt 08 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     True     True     0
Attempt 09 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    False    False    0
Attempt 10 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    False    True     0
Attempt 11 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    True     False    0
Attempt 12 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    True     True     0
Attempt 13 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     False    False    0
Attempt 14 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     False    True     0
Attempt 15 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     True     False    0
Attempt 16 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     True     True     0



