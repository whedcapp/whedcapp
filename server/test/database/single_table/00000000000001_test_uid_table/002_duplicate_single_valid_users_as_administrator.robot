*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
Suite Teardown    Disconnect From Database
Test Template     Create duplicate consistent UID should fail

*** Variables ***
${UID_NO1}     ${UID_AMOUNT1}
${UID_NO2}     ${UID_AMOUNT2}
${UID_NO3}     ${UID_AMOUNT3}
${UID_SPEC1}   'email@somewhere.org'
${UID_SPEC2}   'email@somewhere.org'
${UID_SPEC3}   '{a-zA-Z}{a-zA-Z0-9}*\@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*'

*** Keywords ***
Create duplicate consistent UID should fail
    [Arguments]           ${uid_no}    ${uid_spec}    ${is_superuser}    ${is_pdc}    ${is_adm}    ${is_qm}  
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},${uid_spec},${is_superuser},${is_pdc},${is_adm},${is_qm})    True
    Log Many    @{result}
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `uid_text` = ${uid_spec}    1    True
    ${result2} =     Run Keyword And Expect Error     EQUALS:IntegrityError: (1062, "Duplicate entry 'email@somewhere.org' for key 'uid.id_uid_idx'")
...                  Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},${uid_spec},${is_superuser},${is_pdc},${is_adm},${is_qm})    False






*** Test Cases ***                                      UID_NO        UID_SPEC        SUPERUSER    PDC      ADM      QM       
Attempt 01 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    False    False    
Attempt 02 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    False    True     
Attempt 03 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    True     False    
Attempt 04 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        False    True     True     
Attempt 05 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     False    False    
Attempt 06 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     False    True     
Attempt 07 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     True     False    
Attempt 08 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    False        True     True     True     
Attempt 09 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    False    False    
Attempt 10 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    False    True     
Attempt 11 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    True     False    
Attempt 12 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         False    True     True     
Attempt 13 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     False    False    
Attempt 14 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     False    True     
Attempt 15 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     True     False    
Attempt 16 to Create Duplicate Valid User               ${UID_NO1}    ${UID_SPEC1}    True         True     True     True     



