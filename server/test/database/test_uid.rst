*** Settings ***
Suite Setup    Run Keywords
...            Login to Database AND
...            Create Test User AND
...            Switch to Test User AND
...            Drop Database AND
...            Upload Database Scheme

*** Variables ***
${UID_NO1}       1
${UID_NO2}      10
${UID_NO3}     100
${UID_SPEC1}   email@somewhere.org
${UID_SPEC2}   email@somewhere.org
${UID_SPEC3}   {a-zA-Z}{a-zA-Z0-9}*@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*

*** Test Cases ***                                UID_NO        UID_SPEC        SUPERUSER    PDC      ADM      QM       Seed
Attempt 01 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        false    false    false    0
Attempt 02 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        false    false    true     0
Attempt 03 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        false    true     false    0
Attempt 04 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        false    true     true     0
Attempt 05 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        true     false    false    0
Attempt 06 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        true     false    true     0
Attempt 07 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        true     true     false    0
Attempt 08 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    false        true     true     true     0
Attempt 09 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         false    false    false    0
Attempt 10 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         false    false    true     0
Attempt 11 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         false    true     false    0
Attempt 12 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         false    true     true     0
Attempt 13 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         true     false    false    0
Attempt 14 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         true     false    true     0
Attempt 15 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         true     true     false    0
Attempt 16 to Create One Valid User               ${UID_NO1}    ${UID_SPEC1}    true         true     true     true     0
Attempt 17 to Create Multiple Invalid Users       ${UID_NO2}    ${UID_SPEC2}    false        false    false    false    0
Attempt 18 to Create Multiple Valid Users         ${UID_NO2}    ${UID_SPEC3}    false        false    false    false    1
Attempt 19 to Create Multiple Valid Users         ${UID_NO3}    ${UID_SPEC3}    false        false    false    false    2


*** Keywords ***
Attempt X to Create One Valid User
    [Arguments] ${uid_no} ${uid_spec} ${is_superuser} ${is_pdc} ${is_adm} ${is_qm}
    Use No of   ${uid_no}
    Use Spec    ${uid_spec}
    Use SU      ${is_superuser}
    Use PDC     ${is_pdc}
    Use ADM     ${is_adm}
    Use QM      ${is_qm}
    Call uid_insert_writeSelf
    Exceptions should have been signalled

Creation of Valid User Specifications Should Succeed
    [Arguments] ${uid_no} ${uid_spec} ${is_superuser} ${is_pdc} ${is_adm} ${is_qm}
    Use No of   ${uid_no}
    Use Spec    ${uid_spec}
    Use SU      ${is_superuser}
    Use PDC     ${is_pdc}
    Use ADM     ${is_adm}
    Use QM      ${is_qm}
    Call uid_insert_writeSelf
    No exceptions should be signalled
