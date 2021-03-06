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
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    }
                    
                ],
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ],
                "$SELECT_ONLY$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    }
                ],
                "$PROJECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "context_id_proj_round": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_questionnaire": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ]
            },
            "writeOther": {
                "$ADMIN$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$SELECT_ONLY$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$PROJECT$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    }, 
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "context_id_proj_round": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                    
                        "context_id_questionnaire": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "uid_respondee_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ] 
            },
            "readSelf": {
                "$ADMIN$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    }
                ],
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ],
                "$SELECT_ONLY$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    }
                ],
                "$PROJECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "context_id_proj_round": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": true
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_questionnaire": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ]
            },
            "readOther": {
                "$ADMIN$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$ADMIN_LIMITED_SELECT$": [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$SELECT_ONLY$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$PROJECT$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ], 
                "$ANSWER$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_proj": {
                            "table": "whedcapp.project",
                            "column": "id_proj",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "context_id_proj_round": {
                            "table": "whedcapp.project_round",
                            "column": "id_proj_round",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "other_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                    }
                ], 
                "$QUESTIONNAIRE$":  [
                    {
                        "calling_id_uid": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": true,
                            "context": false
                        }
                    },
                    {   
                        "context_time": {
                            "table": "whedcapp.datatype_spec",
                            "column": "datetime_",
                            "accessControl": false,
                            "context": false
                        }   
                    },
                    {
                        "context_id_questionnaire": {
                            "table": "whedcapp.questionnaire",
                            "column": "id_questionnaire",
                            "accessControl": false,
                            "context": true
                        }
                    },
                    {
                        "uid_respondee_key": {
                            "table": "whedcapp.uid",
                            "column": "id_uid",
                            "accessControl": false,
                            "context": true
                        }
                        
                    }
                ] 
            }
            
        }
    },
    "checkContext":
    {
        "readSelf": {
            
            "$ADMIN$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",

            "$ADMIN_LIMITED_SELECT$":
            "\tIF NOT `whedcapp`.`check_limited_select_rights`(calling_id_uid_par,context_id_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner or a researcher.';\n\tEND IF;\n",

            "$PROJECT$":
            "\tIF NOT `whedcapp`.`check_project_read_access_rights_self`(calling_id_uid_par,context_id_proj_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner, a participant or a supporter.';\n\tEND IF;\n",

            "$SELECT_ONLY$":
            "\t\/* No context check is required *\/\n",


            "$ANSWER$":
            "\tIF NOT `whedcapp`.`check_answer_write_access_rights_self`(calling_id_uid_par,context_id_proj_par,context_id_proj_round_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must either be a supporter or a participant.';\n\tEND IF;\n",

            "$QUESTIONNAIRE$":
            "\tIF NOT `whedcapp`.`check_questionnaire_read_access_rights_self`(calling_id_uid_par,context_id_questionnaire,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must  be a questionnaire maintainer.';\n\tEND IF;\n"
        },
        "readOther": {
            
            "$ADMIN$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",

            "$ADMIN_LIMITED_SELECT$":
            "\tIF NOT `whedcapp`.`check_limited_select_rights`(calling_id_uid_par,context_id_proj_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner or a researcher.';\n\tEND IF;\n",

            "$PROJECT$":
            "\tIF NOT `whedcapp`.`check_project_read_access_rights_other`(calling_id_uid_par,context_id_proj_par,other_uid_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator or a project owner.';\n\tEND IF;\n",

            "$SELECT_ONLY$":
            "\t\/* No context check is required *\/\n",


            "$ANSWER$":
            "\tIF NOT `whedcapp`.`check_answer_read_access_rights_other`(calling_id_uid_par,context_id_proj_par,context_id_proj_round_par,other_uid_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must either be a supporter or a participant.';\n\tEND IF;\n",

            "$QUESTIONNAIRE$":
            "\tIF NOT `whedcapp`.`check_questionnaire_read_access_rights_other`(calling_id_uid_par,context_id_questionnaire,other_uid_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must  be a questionnaire maintainer.';\n\tEND IF;\n"
        },
        "writeSelf": {
            
            "$ADMIN$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",

            "$ADMIN_LIMITED_SELECT$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner or a researcher.';\n\tEND IF;\n",

            "$PROJECT$":
            "\tIF NOT `whedcapp`.`check_project_write_access_rights_self`(calling_id_uid_par,context_id_proj_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either an administrator or a project owner.';\n\tEND IF;\n",

            "$SELECT_ONLY$":
            "\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. ';\n\n",


            "$ANSWER$":
            "\tIF NOT `whedcapp`.`check_answer_write_access_rights_self`(calling_id_uid_par,context_id_proj_par,context_id_proj_round_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must either be a supporter or a participant.';\n\tEND IF;\n",

            "$QUESTIONNAIRE$":
            "\tIF NOT `whedcapp`.`check_questionnaire_write_access_rights_self`(calling_id_uid_par,context_id_questionnaire,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must  be a questionnaire maintainer.';\n\tEND IF;\n"
        },
        "writeOther": {
            
            "$ADMIN$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser or a whedcapp administrator.';\n\tEND IF;\n",

            "$ADMIN_LIMITED_SELECT$":
            "\tIF NOT `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either a superuser, a whedcapp administrator, a project owner or a researcher.';\n\tEND IF;\n",

            "$PROJECT$":
            "\tIF NOT `whedcapp`.`check_project_write_access_rights_other`(calling_id_uid_par,context_id_proj_par,other_uid_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must be either an administrator or a project owner.';\n\tEND IF;\n",

            "$SELECT_ONLY$":
            "\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. ';\n\n",


            "$ANSWER$":
            "\tIF NOT `whedcapp`.`check_answer_write_access_rights_other`(calling_id_uid_par,context_id_proj_par,context_id_proj_round,other_uid_par,context_time_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must either be a supporter or a participant.';\n\tEND IF;\n",

            "$QUESTIONNAIRE$":
            "\tIF NOT `whedcapp`.`check_questionnaire_write_access_rights_other`(calling_id_uid_par,context_id_questionnaire,other_uid_par) THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are not allowed to <OPERATION> <A_TABLE> for <DOMAIN>. You must  be a questionnaire maintainer.';\n\tEND IF;\n"
        }     

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
            "operationPattern": "(insert|delete)",
            "instruction":
            "\tIF ROW_COUNT() < 1 THEN\n\t\tSIGNAL SQLSTATE '4<ERR>'\n\t\t\tSET MESSAGE_TEXT = 'You are allowed to <OPERATION> <A_TABLE> for <DOMAIN>, but something went wrong';\n\tEND IF;\n"
        },
        {
            "step": 3,
            "tablePattern": "^PROJECT$",
            "domainPattern": "writeSelf",
            "operationPattern": "insert",
            "instruction": "\tSET id_proj_round_var = `whedcapp`.`project_round_insert_<REAL_DOMAIN>`(calling_id_uid_par,context_time_par,result_id_var,start_date_par,end_date_par,proj_key_par,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);\n"
        },
        {
            "step": 3,
            "tablePattern": "^PROJECT$",
            "domainPattern": "writeOther",
            "operationPattern": "insert",
            "instruction": "\tSET id_proj_round_var = `whedcapp`.`project_round_insert_<REAL_DOMAIN>`(calling_id_uid_par,context_time_par,result_id_var,other_uid_par,start_date_par,end_date_par,proj_key_par,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);\n"
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
                {"link": "$QUESTIONNAIRE$"},
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
                {"link": "$QUESTIONNAIRE$"},
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
            "DATATYPE_SPEC":
            {
                "insert":
                {"link": "$SELECT_ONLY$"},
                "update":
                {"link": "$SELECT_ONLY$"},
                "delete":
                {"link": "$SELECT_ONLY$"},
                "select":
                {"link": "$SELECT_ONLY$"},
                "eidBase": 8500,
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
                {"link":"$SELECT_ONLY$"},
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
                {"link":"$SELECT_ONLY$"},
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









