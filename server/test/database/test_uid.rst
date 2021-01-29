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
${UID_SPEC2}   {a-zA-Z}{a-zA-Z0-9}*@{a-zA-Z}{a-zA-Z0-9}*.{a-zA-Z}{a-zA-Z0-9}*

*** Test Cases ***              UID_NO        UID_SPEC     SUPERUSER  PDC   ADM   QM
Valid One User  1               ${UID_NO1}    ${UID_SPEC1} false      false false false
Valid One User  2               ${UID_NO1}    ${UID_SPEC1} false      false false true
Valid One User  3               ${UID_NO1}    ${UID_SPEC1} false      false true  false
Valid One User  4               ${UID_NO1}    ${UID_SPEC1} false      false true  true
Valid One User  5               ${UID_NO1}    ${UID_SPEC1} false      true  false false
Valid One User  6               ${UID_NO1}    ${UID_SPEC1} false      true  false true
Valid One User  7               ${UID_NO1}    ${UID_SPEC1} false      true  true  false
Valid One User  8               ${UID_NO1}    ${UID_SPEC1} false      true  true  true
Valid One User  9               ${UID_NO1}    ${UID_SPEC1} true       false false false
Valid One User 10               ${UID_NO1}    ${UID_SPEC1} true       false false true
Valid One User 11               ${UID_NO1}    ${UID_SPEC1} true       false true  false
Valid One User 12               ${UID_NO1}    ${UID_SPEC1} true       false true  true
Valid One User 13               ${UID_NO1}    ${UID_SPEC1} true       true  false false
Valid One User 14               ${UID_NO1}    ${UID_SPEC1} true       true  false true
Valid One User 15               ${UID_NO1}    ${UID_SPEC1} true       true  true  false
Valid One User 16               ${UID_NO1}    ${UID_SPEC1} true       true  true  true
Invalid Multiple Users 10       ${UID_NO2}    ${UID_SPEC1} false      false false false
Valid Multiple Users 10         ${UID_NO2}    ${UID_SPEC2} false      false false false
Valid Multiple Users 100        ${UID_NO3}    ${UID_SPEC2} false      false false false


*** Keywords ***
Creation of Invalid User Specifications Should Fail
    [Arguments] ${uid_no} ${uid_spec} ${is_superuser} ${is_pdc} ${is_adm} ${is_qm}
    Use No of   ${uid_no}
    Use Spec    ${uid_spec}
    Use SU      ${is_superuser}
    Use PDC     ${is_pdc}
    Use ADM     ${is_adm}
    Use QM      ${is_qm}
    Call uid_insert_writeSelf
    Exceptions should be signalled

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
