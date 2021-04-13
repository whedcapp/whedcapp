*** Settings ***
Documentation     This test suite tests creation of single valid users as Whedcapp administrator
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Create single consistent UID should succeed using other domain

*** Variables ***
${UID_SPEC1}   'email1@somewhere.org'
${UID_SPEC3}   @somewhere.org
${TIME}        '2021-01-01 01:01:01'

*** Keywords ***
Create single consistent UID should succeed using other domain
    [Arguments]           ${uid_spec}    ${is_superuser}    ${is_pdc}    ${is_adm}    ${is_qm}   
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uidAdmin1}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${UID_SPEC1}    True
    ${emailBase} =   Generate Random String  8  [LOWER]
    ${id}    Format String    '{}{}'    ${emailBase}    ${uid_spec}
    @{result}    Query    SELECT `whedcapp`.`uid_insert_writeOther`(${uidAdmin[0][0]},${TIME},${uidAdmin1[0][0]},${id},${is_superuser},${is_pdc},${is_adm},${is_qm})    True
    Log Many    @{result}
    Row Count Is Equal To X    SELECT * FROM `whedcapp`.`uid` WHERE `uid_text` = ${id}    1    True

Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uidAdmin}  Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}    Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uidAdmin[0][0]},${TIME},${UID_SPEC1},FALSE,FALSE,TRUE,FALSE)    True





*** Test Cases ***                                UID_SPEC        SUPERUSER    PDC      ADM      QM       
Attempt 01 to Create One Valid User               ${UID_SPEC3}    False        False    False    False    
Attempt 02 to Create One Valid User               ${UID_SPEC3}    False        False    False    True     
Attempt 03 to Create One Valid User               ${UID_SPEC3}    False        False    True     False    
Attempt 04 to Create One Valid User               ${UID_SPEC3}    False        False    True     True     
Attempt 05 to Create One Valid User               ${UID_SPEC3}    False        True     False    False    
Attempt 06 to Create One Valid User               ${UID_SPEC3}    False        True     False    True     
Attempt 07 to Create One Valid User               ${UID_SPEC3}    False        True     True     False    
Attempt 08 to Create One Valid User               ${UID_SPEC3}    False        True     True     True     
Attempt 09 to Create One Valid User               ${UID_SPEC3}    True         False    False    False    
Attempt 10 to Create One Valid User               ${UID_SPEC3}    True         False    False    True     
Attempt 11 to Create One Valid User               ${UID_SPEC3}    True         False    True     False    
Attempt 12 to Create One Valid User               ${UID_SPEC3}    True         False    True     True     
Attempt 13 to Create One Valid User               ${UID_SPEC3}    True         True     False    False    
Attempt 14 to Create One Valid User               ${UID_SPEC3}    True         True     False    True     
Attempt 15 to Create One Valid User               ${UID_SPEC3}    True         True     True     False    
Attempt 16 to Create One Valid User               ${UID_SPEC3}    True         True     True     True     



