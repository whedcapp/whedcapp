{
    "roles": {
        "whedcapp_administrator": 0,
        "project_owner": 1,
        "questionnaire_maintainter": 1,
        "supporter": 2,
        "participant": 3,
        "researcher": 4
    },
    "contextParameters": {
        "SQL": {
            "writeSelf": {
                "$ADMIN$": "calling_uid_key_par VARCHAR(64),",
                "$PROJECT$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32),",
                "$ANSWER$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), proj_round_key_par VARCHAR(32),",
                "$QUESTIONNAIRE$": "calling_uid_key_par VARCHAR(64), questionnaire_key_par VARCHAR(32),"
            },
            "writeOther": {
                "$ADMIN$": "calling_uid_key_par VARCHAR(64), other_uid_key_par VARCHAR(64),",
                "$PROJECT$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), other_uid_key_par VARCHAR(64),",
                "$ANSWER$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), proj_round_key_par VARCHAR(32), other_uid_key_par VARCHAR(64),",
                "$QUESTIONNAIRE$": "calling_uid_key_par VARCHAR(64), questionnaire_key_par VARCHAR(32),uid_respondee_key_par VARCHAR(64),"
            },
            "readSelf": {
                "$ADMIN$": "calling_uid_key_par VARCHAR(64),",
                "$PROJECT$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32),",
                "$ANSWER$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), proj_round_key_par VARCHAR(32),",
                "$QUESTIONNAIRE$": "calling_uid_key_par VARCHAR(64), questionnaire_key_par VARCHAR(32),"
            },
            "readOther": {
                "$ADMIN$": "calling_uid_key_par VARCHAR(64), other_uid_key_par VARCHAR(64),",
                "$PROJECT$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), other_uid_key_par VARCHAR(64),",
                "$ANSWER$": "calling_uid_key_par VARCHAR(64), proj_key_par VARCHAR(32), proj_round_key_par VARCHAR(32), other_uid_key_par VARCHAR(64),",
                "$QUESTIONNAIRE$": "calling_uid_key_par VARCHAR(64), questionnaire_key_par VARCHAR(32),uid_respondee_key_par VARCHAR(64),"
            }
            
        }
    },
    "checkContext":
    {
        
        "$ADMIN$":
        "\tIF NOT `whedcapp`.`check_top_administrator_rights`(calling_uid_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",
        
        "$PROJECT$":
        "\tIF NOT `whedcapp`.`check_project_owner_rights`(calling_uid_key_par,proj_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator or a project owner.';\n\tEND IF;\n",
        
        "$ANSWER$":
        "\tIF NOT `whedcapp`.`check_participant_rights`(calling_uid_key_par,proj_key_par,proj_round_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must either be a supporter or a participant.';\n\tEND IF;\n",
        
        "$QUESTIONNAIRE$":
        "\tIF NOT `whedcapp`.`check_questionnaire_maintainer_rights`(calling_uid_key_par,questionnaire_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must  be a questionnaire maintainer.';\n\tEND IF;\n"
    }
    ,
    "declaration":
    [
        {
            "step": 0,
            "tablePattern": ".*",
            "domainPattern": "write.*",
            "operationPattern": "(insert)",
            "instruction":
            "\tDECLARE result_id_var INTEGER;\n"
        },
        {
            "step": 0,
            "tablePattern": "^PROJECT$",
            "domainPattern": "write.*",
            "operationPattern": "(insert)",
            "instruction":
            "\tDECLARE id_proj_round_var INTEGER;\n"
        }

        
    ],
    "preProcessing":
    [
    ],
    "postProcessing":
    [
        {
            "step": 0,
            "tablePattern": ".*",
            "domainPattern": "write.*",
            "operationPattern": "(insert)",
            "instruction":
            "\tSET result_id_var := last_insert_id();\n"
        },
        {
            "step": 1,
            "tablePattern": ".*",
            "domainPattern": "write.*",
            "operationPattern": "(insert|update|delete)",
            "instruction":
            "\tIF ROW_COUNT() < 1 THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are allowed to <OPERATION> <A_TABLE> for <DOMAIN>, but something went wrong';\n\tEND IF;\n"
        },
        {
            "step": 3,
            "tablePattern": "^PROJECT$",
            "domainPattern": "write.*",
            "operationPattern": "insert",
            "instruction": "\tSET id_proj_round_var = `whedcapp`.`project_round_insert_<DOMAIN>`(calling_uid_key_par,start_date_par,end_date_par,proj_key_par);\n"
        },
        {
            "step": 100,
            "tablePattern": ".*",
            "domainPattern": "write.*",
            "operationPattern": "(insert)",
            "instruction":
            "\tRETURN result_id_var;\n"
        }
        
    ],
    "tableConfiguration":
    {
        
        "aclTemplate":{
            "$ADMIN$":
            {
                "writeSelf": [
                    "whedcapp_administrator"
                ]
                ,
                "writeOther": [
                    "whedcapp_administrator"
                ],
                "readSelf": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher",
                    "questionnaire_maintainer",
                    "supporter",
                    "participant"
                ],
                "readOther": [
                    "whedcapp_administrator"
                ]
            }
            
            ,
            "$ADMIN_LIMITED_SELECT$":
            {
                "writeSelf": [
                    "whedcapp_administrator"
                ]
                ,
                "writeOther": [
                    "whedcapp_administrator"
                ],
                "readSelf": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher"
                ],
                "readOther": [
                    "whedcapp_administrator"
                ]
            }
            
            ,
            "$PROJECT$":
            {
                "writeSelf": [
                    "whedcapp_administrator",
                    "project_owner"
                ]
                ,
                "writeOther": [
                    "whedcapp_administrator"
                ],
                "readSelf": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher",
                    "questionnaire_maintainer",
                    "supporter",
                    "participant"
                ],
                "readOther": [
                    "whedcapp_administrator"
                ]
                
            },
            "$QUESTIONNAIRE$":
            {
                "writeSelf": [
                    "whedcapp_administrator",
                    "questionnaire_maintainer"
                ]
                ,
                "writeOther": [
                    "whedcapp_administrator"
                ],
                "readSelf": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher",
                    "questionnaire_maintainer",
                    "supporter",
                    "participant"
                ],
                "readOther": [
                    "whedcapp_administrator"
                ]
                
            },
            "$ANSWER$":
            {
                "writeSelf": [
                    "participant"
                ]
                ,
                "writeOther": [
                    "whedcapp_administrator",
                    "project_owner",
                    "supporter"
                ],
                "readSelf": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher",
                    "questionnaire_maintainer",
                    "supporter",
                    "participant"
                ],
                "readOther": [
                    "whedcapp_administrator",
                    "project_owner",
                    "researcher",
                    "supporter"
                ]
            }
        },
        "tableSpec": {
            "ACL":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link":"$ADMIN$"},
                "eidBase": 5000,
                "hasKeyAttribute": false
            },
            "AIM_OR_RESEARCH_QUESTION":
            {
                "insert":
                {"link":"$PROJECT$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 5100,
                "acronym": "res_que",
                "hasKeyAttribute": true
            },
            "AIM_OR_RESEARCH_QUESTION_LOCALE":
            {
                 "insert":
                {"link":"$PROJECT$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 5200,
                "hasKeyAttribute": false
            },
            "ALTERNATIVE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 5300,
                "acronym":"alt",
                "hasKeyAttribute":  true
            },
            "ALTERNATIVE_LOCALE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 5400,
                "hasKeyAttribute": false
            },
            "ANSWER":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 5500,
                "acronym":"ans",
                "hasKeyAttribute": false
            },
            "ANSWER_CONTENT":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 5600,
                "hasKeyAttribute": false
            },
            "ETHICAL_APPROVAL":
            {
                "insert":
                {"link": "$PROJECT$"},
                "update":
                {"link": "$PROJECT$"},
                "delete":
                {"link": "$PROJECT$"},
                "select":
                {"link": "$ADMIN_LIMITED_SELECT$"},
                "eidBase": 5700,
                "hasKeyAttribute": false
            },
            "PARTICIPANT":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link": "$ADMIN$"},
                "eidBase": 5800,
                "hasKeyAttribute": false

            },
            "PARTICIPANT_GDPR_STATUS_LOG":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link": "$ADMIN$"},
                "eidBase": 5900,
                "hasKeyAttribute": false
            },
            "PPSA_RQQ_A_REL":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 6000,
                "hasKeyAttribute": false
            },
            "PP_REL":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link": "$ADMIN$"},
                "eidBase": 6100,
                "hasKeyAttribute": false
                
            },
            "PP_REL_S_REL":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 6200,
                "hasKeyAttribute": false
            },
            "PROJECT":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 6300,
                "acronym":"proj",
                "hasKeyAttribute":true
            },
            "PROJECT_LOCALE":
            {
                "insert":
                {"link":"$PROJECT$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 6400,
                "hasKeyAttribute": false
            },
            "PROJECT_ROUND":
            {
                "insert":
                {"link":"$PROJECT$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 6500,
                "acronym": "proj_round",
                "hasKeyAttribute":true
            },
            "QQ_REL":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 6600,
                "hasKeyAttribute": false
            },
            "QUESTION":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 6700,
                "acronym":"quest",
                "hasKeyAttribute": true
            },
            "QUESTIONNAIRE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 6800,
                "acronym": "questionnaire",
                "hasKeyAttribute": true
            },
            "QUESTIONNAIRE_LOCALE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 6900,
                "hasKeyAttribute": false
            },
            "QUESTIONNAIRE_SHARE_TYPE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 7000,
                "hasKeyAttribute": false
            },
            "QUESTION_ANSWER_INTEGER_RANGE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 7100,
                "hasKeyAttribute": false
            },
            "QUESTION_ANSWER_SCALAR_RANGE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 7200,
                "hasKeyAttribute": false
            },
            "QUESTION_LOCALE":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 7300,
                "hasKeyAttribute": false
            },
            "QUESTION_TYPE_SPECIFICATION":
            {
                "insert":
                {"link": "$QUESTIONNAIRE$"},
                "update":
                {"link": "$QUESTIONNAIRE$"},
                "delete":
                {"link": "$QUESTIONNAIRE$"},
                "select":
                {"link":"$QUESTIONNAIRE$"},
                "eidBase": 7400,
                "hasKeyAttribute": false
            },
            "RQQ_REL":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 7500,
                "hasKeyAttribute": false
            },
            "SAMPLING_SESSION":
            {
                "insert":
                {"link": "$ANSWER$"},
                "update":
                {"link": "$ANSWER$"},
                "delete":
                {"link": "$ANSWER$"},
                "select":
                {"link": "$ANSWER$"},
                "eidBase": 7600,
                "hasKeyAttribute": false
            },
            "SPP_REL":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link":"$ADMIN$"},
                "eidBase": 7700,
                "hasKeyAttribute":false
                
            },
            "UID":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link":"$ADMIN$"},
                "eidBase": 7800,
                "hasKeyAttribute":false
                
            }
        }

    }
}









