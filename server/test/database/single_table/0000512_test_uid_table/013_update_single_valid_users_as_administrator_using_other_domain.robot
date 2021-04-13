*** Settings ***
Documentation     This test suite tests correct variants of updating of uid
Resource          ../../../Resources/Lib/GlobalLibrary.txt
Suite Setup       Initialize Test Suite
Suite Teardown    Disconnect From Database
Test Template     Update other uid as administrator should succeed

*** Variables ***
${UID_SPEC2}   'testadm@somewhere.org'
${UID_SPEC3}   'testuser@somwhere.org'
${TIME}        '2021-01-01 01:01:01'

*** Keywords ***
Update other uid as administrator should succeed
    [Arguments]             ${uid_spec}    ${is_superuser}    ${is_pdc}    ${is_adm}    ${is_qm}  
    ${uid_admin}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    ${uid_user}             Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${UID_SPEC3}    True
    Execute SQL String      CALL `whedcapp`.`uid_update_writeOther`(${uid_admin[0][0]},${TIME},${uid_user[0][0]},${UID_SPEC3},${is_superuser},${is_pdc},${is_adm},${is_qm})    True
    ${uid_admin1}            Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    Execute SQL String      CALL `whedcapp`.`uid_update_writeOther`(${uid_admin1[0][0]},${TIME},${uid_user[0][0]},${UID_SPEC3},${is_superuser},${is_pdc},${is_adm},${is_qm})    True


Initialize Test Suite
    Connect To Database Using Custom Params  pymysql    database=${dbName},user=${dbUserName},password=${dbPassword},host=${dbHost},port=${dbPort}
    ${uid_admin}    Query    SELECT `id_uid` FROM `whedcapp`.`uid` WHERE `uid_text` = ${ADMIN}    True
    @{result}       Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uid_admin[0][0]},${TIME},${UID_SPEC2},FALSE,FALSE,TRUE,FALSE)    True
    @{result}       Query    SELECT `whedcapp`.`uid_insert_writeSelf`(${uid_admin[0][0]},${TIME},${UID_SPEC3},FALSE,FALSE,FALSE,FALSE)    True







*** Test Cases ***                           UID_SPEC        SUPERUSER    PDC      ADM      QM       
Attempt 01 to Update Other Uid               ${UID_SPEC2}    True         False    False    False    
Attempt 02 to Update Other Uid               ${UID_SPEC2}    True         False    False    True     
Attempt 03 to Update Other Uid               ${UID_SPEC2}    True         False    True     False    
Attempt 04 to Update Other Uid               ${UID_SPEC2}    True         False    True     True     
Attempt 05 to Update Other Uid               ${UID_SPEC2}    True         True     False    False    
Attempt 06 to Update Other Uid               ${UID_SPEC2}    True         True     False    True     
Attempt 07 to Update Other Uid               ${UID_SPEC2}    True         True     True     False    
Attempt 08 to Update Other Uid               ${UID_SPEC2}    True         True     True     True     
Attempt 09 to Update Other Uid               ${UID_SPEC2}    False        False    False    False    
Attempt 10 to Update Other Uid               ${UID_SPEC2}    False        False    False    True     
Attempt 11 to Update Other Uid               ${UID_SPEC2}    False        False    True     False    
Attempt 12 to Update Other Uid               ${UID_SPEC2}    False        False    True     True     
Attempt 13 to Update Other Uid               ${UID_SPEC2}    False        True     False    False    
Attempt 14 to Update Other Uid               ${UID_SPEC2}    False        True     False    True     
Attempt 15 to Update Other Uid               ${UID_SPEC2}    False        True     True     False    
Attempt 16 to Update Other Uid               ${UID_SPEC2}    False        True     True     True     



