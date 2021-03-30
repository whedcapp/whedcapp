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
                "$ADMIN$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$SELECT_ONLY$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$PROJECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "proj_round_key": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round"
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "questionnaire_key": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire"
                        }
                    }
                ]
            },
            "writeOther": {
                "$ADMIN$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$SELECT_ONLY$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$PROJECT$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "proj_round_key": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                    
                        "questionnaire_key": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire"
                        }
                    },
                    {
                        "uid_respondee_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ] 
            },
            "readSelf": {
                "$ADMIN$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$SELECT_ONLY$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ],
                "$PROJECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "proj_round_key": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round"
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "questionnaire_key": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire"
                        }
                    }
                ]
            },
            "readOther": {
                "$ADMIN$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$SELECT_ONLY$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$PROJECT$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj"
                        }
                    },
                    {
                        "proj_round_key": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round"
                        }
                    },
                    {
                        "other_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_uid_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                    },
                    {
                        "questionnaire_key": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire"
                        }
                    },
                    {
                        "uid_respondee_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid"
                        }
                        
                    }
                ] 
            }
            
        }
    },
    "checkContext":
    {
        
        "$ADMIN$":
        "\tIF NOT `whedcapp`.`check_top_administrator_rights`(calling_uid_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",

        "$ADMIN_LIMITED_SELECT$":
        "\tIF NOT `whedcapp`.`check_top_administrator_limited_select_rights`(calling_uid_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner or a researcher.';\n\tEND IF;\n",

        "$PROJECT$":
        "\tIF NOT `whedcapp`.`check_project_owner_rights`(calling_uid_key_par,proj_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator or a project owner.';\n\tEND IF;\n",

        "$SELECT_ONLY$":
        "\tIF NOT `whedcapp`.`check_select_only_rights`(calling_uid_key_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. ';\n\tEND IF;\n",

        
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
                
            }
            ,
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
                
            }
            ,
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
            ,
            "$SELECT_ONLY$":
            {
                "writeSelf": [
                ]
                ,
                "writeOther": [
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
                    "questionnaire_maintainer",
                    "supporter",
                    "participant"
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
            }
            ,
            "ACL_LEVEL":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8000,
                "hasKeyAttribute": false
            }
            ,
            "ACL_LEVEL_LOCALE":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8000,
                "hasKeyAttribute": false
            }
            ,
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
            "GDPR_STATUS":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8300,
                "acronym":"gdpr_stat",
                "hasKeyAttribute": false
            },
            "GDPR_STATUS_LOCALE":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8400,
                "acronym":"gdpr_stat_loc",
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
            }
            ,
            "LOCALE": 
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 7900,
                "acronym":"loc",
                "hasKeyAttribute": false
            }
            ,
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
            "PROJECT_ROUND_LOCALE":
            {
                "insert":
                {"link":"$PROJECT$"},
                "update":
                {"link":"$PROJECT$"},
                "delete":
                {"link":"$PROJECT$"},
                "select":
                {"link":"$PROJECT$"},
                "eidBase": 8100,
                "acronym": "proj_round_loc",
                "hasKeyAttribute":false
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
            }
            ,
            "QUESTION_TYPE":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8300,
                "acronym":"quest_type",
                "hasKeyAttribute": false
            }
            ,
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
            "RQ_REL":
            {
                "insert":
                {"link":"$ANSWER$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link":"$ADMIN$"},
                "eidBase": 8400,
                "hasKeyAttribute":false
                
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
            ,
            "UID_PROJECT_ACL_CHANGE_LOG":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8200,
                "acronym":"uid_proj_acl_chg_log",
                "hasKeyAttribute": false
            },
            "UQ_REL":
            {
                "insert":
                {"link":"$ADMIN$"},
                "update":
                {"link":"$ADMIN$"},
                "delete":
                {"link":"$ADMIN$"},
                "select":
                {"link":"$ADMIN$"},
                "eidBase": 8300,
                "hasKeyAttribute":false
                
            }
        }

    }
}









