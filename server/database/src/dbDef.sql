/*
    Whedcapp - Well-being HEalth Environment Data Collection App - to collect self-evaluated data for research purposes
    Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    */

DROP DATABASE IF EXISTS `whedcapp`;
CREATE DATABASE `whedcapp`;
USE `whedcapp`;



/* Create table locale that contains implemented ICU locale codes of the form cc_LL, where 'cc' stands for
   country and 'll' stands for locale. See https://www.localeplanet.com/icu/ for more information */

CREATE TABLE `whedcapp`.`locale` (
    `id_loc` INTEGER NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id_loc`),
    `icu_code` VARCHAR(45) NOT NULL,
    UNIQUE INDEX `locale_idx_unique` (`icu_code`) VISIBLE,
    CONSTRAINT `locale_icu_code_is_not_empty` CHECK (`icu_code` <> "" AND CHAR_LENGTH(`icu_code`) = 5)
);

/* Insert supported locales */

INSERT INTO  `whedcapp`.`locale` (`icu_code`)
VALUES ('sv_SE');
INSERT INTO  `whedcapp`.`locale` (`icu_code`)
VALUES ('en_US');
INSERT INTO  `whedcapp`.`locale` (`icu_code`)
VALUES ('en_GB');

/* ACL_LEVEL
    #     #####  #               #       ####### #     # ####### #       
   # #   #     # #               #       #       #     # #       #       
  #   #  #       #               #       #       #     # #       #       
 #     # #       #               #       #####   #     # #####   #       
 ####### #       #               #       #        #   #  #       #       
 #     # #     # #               #       #         # #   #       #       
 #     #  #####  #######         ####### #######    #    ####### ####### 
                         #######                                         
*/

CREATE TABLE `whedcapp`.`acl_level` (
  `id_acl_level`INTEGER NOT NULL AUTO_INCREMENT,
  `acl_level_key` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id_acl_level`),
  UNIQUE INDEX `acl_level_idx` (`acl_level_key`),
  CONSTRAINT `acl_level_key_is_not_empty` CHECK (`acl_level_key` <> "")
  );

INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("superuser");
INSERT INTO `whedcapp`.`acl_level` (`acl_level_key`)
VALUES("personal_data_controller");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("whedcapp_administrator");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("project_owner");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("researcher");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("questionnaire_maintainer");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("supporter");
INSERT INTO `whedcapp`.`acl_level` (`acl_Level_key`)
VALUES ("participant");

  
CREATE TABLE `whedcapp`.`acl_level_locale` (
  `id_acl_level_loc` INTEGER NOT NULL AUTO_INCREMENT,
  `id_acl_level` INTEGER NOT NULL,
  `acl_level_text` VARCHAR(32),
  `id_loc` INTEGER NOT NULL,
  PRIMARY KEY(`id_acl_level_loc`),
  INDEX `id_acl_level_constraint_idx` (`id_acl_level`),
  CONSTRAINT `id_acl_level_constraint`
    FOREIGN KEY (`id_acl_level`)
    REFERENCES `whedcapp`.`acl_level`(`id_acl_level`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_acl_level_loc_constraint_idx`(`id_loc`),
  CONSTRAINT `id_acl_level_loc_constraint`
    FOREIGN KEY (`id_loc`)
    REFERENCES `whedcapp`.`locale`(`id_loc`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `acl_level_locale_acl_level_text_is_not_empty` CHECK (`acl_level_text` <> "")
);

/* Dataskyddsombud alternativt personuppgiftsansvarig */
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcapp", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "superuser" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Personuppgiftsansvarig", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "personal_data_controller" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcappadministratör", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "whedcapp_administrator" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Projektägare", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "project_owner" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Forskare", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "researcher" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Enkätansvarig", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "questionnaire_maintainer" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Stödperson", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "supporter" AND `locale`.`icu_code` = "sv_SE";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Deltagare", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "participant" AND `locale`.`icu_code` = "sv_SE";

INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcapp", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "superuser" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Personal data controller", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "personal_data_controller" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcapp administrator", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "whedcapp_administrator" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Project owner", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "project_owner" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Researcher", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "researcher" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Questionnaire maintainer", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "questionnaire_maintainer" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Supporter", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "supporter" AND `locale`.`icu_code` = "en_GB";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Participant", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "participant" AND `locale`.`icu_code` = "en_GB";

INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcapp", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "superuser" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Personal data controller", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "personal_data_controller" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "whedcapp administrator", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "whedcapp_administrator" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Project owner", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "project_owner" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Researcher", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "researcher" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Questionnaire maintainer", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "questionnaire_maintainer" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Supporter", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "supporter" AND `locale`.`icu_code` = "en_US";
INSERT INTO `whedcapp`.`acl_level_locale` (`acl_level_text`,`id_acl_level`,`id_loc`)
SELECT "Participant", `id_acl_level`, `id_loc` FROM `whedcapp`.`acl_level`, `whedcapp`.`locale` WHERE `acl_level`.`acl_level_key` = "participant" AND `locale`.`icu_code` = "en_US";
/* UID
 #     # ### ######  
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
  #####  ### ######  
                     
*/

CREATE TABLE `whedcapp`.`uid` (
  `id_uid` INTEGER NOT NULL AUTO_INCREMENT,
  `uid_text` VARCHAR(64) NOT NULL,
  `uid_id_superuser` BOOLEAN DEFAULT FALSE,
  `uid_is_personal_data_controller` BOOLEAN DEFAULT FALSE,
  `uid_is_whedcapp_administrator` BOOLEAN DEFAULT FALSE,
  `uid_is_quesionnaire_maintainer` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY(`id_uid`),
  UNIQUE INDEX `id_uid_idx`(`uid_text`),
  CONSTRAINT `uid_text_is_not_empty` CHECK (`uid_text` <> "")
  );
  
/* PROJECT
 ######  ######  #######       # #######  #####  ####### 
 #     # #     # #     #       # #       #     #    #    
 #     # #     # #     #       # #       #          #    
 ######  ######  #     #       # #####   #          #    
 #       #   #   #     # #     # #       #          #    
 #       #    #  #     # #     # #       #     #    #    
 #       #     # #######  #####  #######  #####     #    
                                                         
*/
        

/* Project */
CREATE TABLE `whedcapp`.`project` (
    `id_proj` INTEGER NOT NULL AUTO_INCREMENT,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `proj_key`VARCHAR(32) NOT NULL,
    `proj_marked_for_deletion` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id_proj`),
    UNIQUE INDEX `proj_key_idx` (`proj_key`),
    CONSTRAINT `project_start_date_end_date_constraint` CHECK (`start_date` < `end_date`)
);    

      

/* Actual project data per supported locale */



CREATE TABLE `whedcapp`.`project_locale` (
    `id_proj_loc` INTEGER NOT NULL AUTO_INCREMENT,
    `id_loc` INTEGER NOT NULL,
    `proj_title` VARCHAR(256) NOT NULL,
    `proj_desc` VARCHAR(2048),
    `id_proj` INTEGER NOT NULL,
    PRIMARY KEY (`id_proj_loc`),
    UNIQUE INDEX `project_locale_proj_title_idx_unique`(`id_loc`,`proj_title`),
    INDEX `id_proj_loc_constraint_idx` (`id_loc`),
    CONSTRAINT `id_proj_loc_constraint`
        FOREIGN KEY (`id_loc`)
        REFERENCES `whedcapp`.`locale`(`id_loc`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `id_proj_constraint_idx` (`id_proj`),
    CONSTRAINT `id_proj_constraint`
        FOREIGN KEY (`id_proj`)
        REFERENCES `whedcapp`.`project` (`id_proj`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `project_locale_title_is_not_empty` CHECK (`proj_title` <> "")
);

/* PROJECT_ROUND
 ######  ######  #######       # #######  #####  #######         ######  ####### #     # #     # ######  
 #     # #     # #     #       # #       #     #    #            #     # #     # #     # ##    # #     # 
 #     # #     # #     #       # #       #          #            #     # #     # #     # # #   # #     # 
 ######  ######  #     #       # #####   #          #            ######  #     # #     # #  #  # #     # 
 #       #   #   #     # #     # #       #          #            #   #   #     # #     # #   # # #     # 
 #       #    #  #     # #     # #       #     #    #            #    #  #     # #     # #    ## #     # 
 #       #     # #######  #####  #######  #####     #            #     # #######  #####  #     # ######  
                                                         #######                                         
*/

CREATE TABLE `whedcapp`.`project_round` (
    `id_proj_round` INTEGER NOT NULL AUTO_INCREMENT,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `proj_round_key` VARCHAR(32) NOT NULL,
    `id_proj` INTEGER NOT NULL,
    `proj_round_ccpa_b` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_c` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_f` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_g` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_h` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_j` BOOLEAN DEFAULT FALSE,
    `proj_round_ccpa_k` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY(`id_proj_round`),
    UNIQUE INDEX `proj_round_key_idx` (`proj_round_key`),
    UNIQUE INDEX `proj_round_date_idx`(`id_proj`,`start_date`,`end_date`),
    CONSTRAINT `proj_round_start_date_end_date_constraint` CHECK (`start_date`<`end_date`),
    INDEX `proj_round_id_proj_constraint_idx`(`id_proj`),
    CONSTRAINT `proj_round_id_proj_constraint`
      FOREIGN KEY (`id_proj`)
      REFERENCES `whedcapp`.`project`(`id_proj`)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
);


CREATE TABLE `whedcapp`.`project_round_locale` (
    `id_proj_round_loc` INTEGER NOT NULL AUTO_INCREMENT,
    `id_loc` INTEGER NOT NULL,
    `title` VARCHAR(256) NOT NULL,
    `desc` VARCHAR(2048),
    `id_proj_round` INTEGER NOT NULL,
    PRIMARY KEY (`id_proj_round_loc`),
    UNIQUE INDEX `proj_round_idx_unique` (`id_proj_round`, `id_loc`, `title`) VISIBLE,
    UNIQUE INDEX `proj_round_title_idx_unique`(`title`),
    INDEX `proj_round_id_loc_constraint_idx` (`id_loc`),
    CONSTRAINT `proj_round_id_loc_constraint`
        FOREIGN KEY (`id_loc`)
        REFERENCES `whedcapp`.`locale`(`id_loc`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `proj_round_loc_id_proj_round_constraint_idx` (`id_proj_round`),
    CONSTRAINT `proj_round_loc_id_proj_round_constraint`
        FOREIGN KEY (`id_proj_round`)
        REFERENCES `whedcapp`.`project_round` (`id_proj_round`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `proj_round_loc_title_is_not_empty` CHECK (`title` <> "")
);

/* ETHICAL_APPROVAL
 ####### ####### #     # ###  #####     #    #                  #    ######  ######  ######  ####### #     #    #    #       
 #          #    #     #  #  #     #   # #   #                 # #   #     # #     # #     # #     # #     #   # #   #       
 #          #    #     #  #  #        #   #  #                #   #  #     # #     # #     # #     # #     #  #   #  #       
 #####      #    #######  #  #       #     # #               #     # ######  ######  ######  #     # #     # #     # #       
 #          #    #     #  #  #       ####### #               ####### #       #       #   #   #     #  #   #  ####### #       
 #          #    #     #  #  #     # #     # #               #     # #       #       #    #  #     #   # #   #     # #       
 #######    #    #     # ###  #####  #     # #######         #     # #       #       #     # #######    #    #     # ####### 
                                                     #######                                                                 
*/

CREATE TABLE `whedcapp`.`ethical_approval`(
    `id_eth_apr` INTEGER NOT NULL AUTO_INCREMENT,
    `id_proj` INTEGER NOT NULL,
    `eth_apr_text_path` VARCHAR(256),
    PRIMARY KEY(`id_eth_apr`),
    INDEX `ethical_approval_id_proj_constraint_idx`(`id_proj`),
    CONSTRAINT `ethical_approval_id_proj_constraint`
        FOREIGN KEY (`id_proj`)
        REFERENCES `whedcapp`.`project`(`id_proj`)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

/* ACL
    #     #####  #       
   # #   #     # #       
  #   #  #       #       
 #     # #       #       
 ####### #       #       
 #     # #     # #       
 #     #  #####  ####### 
                         
*/
CREATE TABLE `whedcapp`.`acl` (
  `id_acl` INTEGER NOT NULL auto_increment,
  `id_uid` INTEGER NOT NULL,
  `id_acl_level` INTEGER NOT NULL,
  `id_proj`INTEGER NOT NULL,
  PRIMARY KEY (`id_acl`),
  UNIQUE INDEX `id_acl_idx`(`id_proj`,`id_uid`),
  INDEX `id_acl_proj_constraint_idx`(`id_proj`),
  CONSTRAINT `id_acl_proj_constraint`
    FOREIGN KEY (`id_proj`)
    REFERENCES `whedcapp`.`project`(`id_proj`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_acl_acl_level_constraint_idx`(`id_acl_level`),
  CONSTRAINT `id_acl_acl_level_constraint`
    FOREIGN KEY (`id_acl_level`)
    REFERENCES `whedcapp`.`acl_level`(`id_acl_level`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_acl_uid_constraint_idx`(`id_uid`),
  CONSTRAINT `id_acl_uid_constraint`
    FOREIGN KEY (`id_uid`)
    REFERENCES `whedcapp`.`uid`(`id_uid`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
/* UID_PROJECT_ACL_CHANGE_LOG
 #     # ### ######          ######  ######  #######       # #######  #####  #######            #     #####  #               
 #     #  #  #     #         #     # #     # #     #       # #       #     #    #              # #   #     # #               
 #     #  #  #     #         #     # #     # #     #       # #       #          #             #   #  #       #               
 #     #  #  #     #         ######  ######  #     #       # #####   #          #            #     # #       #               
 #     #  #  #     #         #       #   #   #     # #     # #       #          #            ####### #       #               
 #     #  #  #     #         #       #    #  #     # #     # #       #     #    #            #     # #     # #               
  #####  ### ######          #       #     # #######  #####  #######  #####     #            #     #  #####  #######         
                     #######                                                         #######                         ####### 
  #####  #     #    #    #     #  #####  #######         #       #######  #####                                              
 #     # #     #   # #   ##    # #     # #               #       #     # #     #                                             
 #       #     #  #   #  # #   # #       #               #       #     # #                                                   
 #       ####### #     # #  #  # #  #### #####           #       #     # #  ####                                             
 #       #     # ####### #   # # #     # #               #       #     # #     #                                             
 #     # #     # #     # #    ## #     # #               #       #     # #     #                                             
  #####  #     # #     # #     #  #####  #######         ####### #######  #####                                              
                                                 #######                                                                     
*/
CREATE TABLE `whedcapp`.`uid_project_acl_change_log` (
    `id_uid_proj_acl_chg_log`  INTEGER NOT NULL AUTO_INCREMENT,
    `uid_proj_log_date` DATETIME,
    `id_uid` INTEGER NOT NULL,
    `id_acl_level` INTEGER NOT NULL,
    `id_proj` INTEGER NOT NULL,
    PRIMARY KEY(`id_uid_proj_acl_chg_log`),
    INDEX `uid_project_acl_change_log_id_uid_constraint_idx`(`id_uid`),
    CONSTRAINT `uid_project_acl_change_log_id_uid_constraint`
        FOREIGN KEY (`id_uid`)
        REFERENCES `whedcapp`.`uid`(`id_uid`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `uid_project_acl_change_log_id_acl_level_constraint_idx`(`id_acl_level`),
    CONSTRAINT `uid_project_acl_change_log_id_acl_level_constraint`
        FOREIGN KEY (`id_acl_level`)
        REFERENCES `whedcapp`.`acl_level`(`id_acl_level`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `uid_project_acl_change_log_id_proj_constraint_idx`(`id_proj`),
    CONSTRAINT `uid_project_acl_change_log_id_proj_constraint`
        FOREIGN KEY (`id_proj`)
        REFERENCES `whedcapp`.`project`(`id_proj`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);
/* QUESTION_TYPE
  #####  #     # #######  #####  ####### ### ####### #     #         ####### #     # ######  ####### 
 #     # #     # #       #     #    #     #  #     # ##    #            #     #   #  #     # #       
 #     # #     # #       #          #     #  #     # # #   #            #      # #   #     # #       
 #     # #     # #####    #####     #     #  #     # #  #  #            #       #    ######  #####   
 #   # # #     # #             #    #     #  #     # #   # #            #       #    #       #       
 #    #  #     # #       #     #    #     #  #     # #    ##            #       #    #       #       
  #### #  #####  #######  #####     #    ### ####### #     #            #       #    #       ####### 
                                                             #######                                 
*/

CREATE TABLE `whedcapp`.`question_type` (
  `id_quest_type` INTEGER NOT NULL AUTO_INCREMENT,
  `quest_type` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id_quest_type`),
  CONSTRAINT `question_type_type_is_not_empty` CHECK (`quest_type` <> "")
);

INSERT INTO `whedcapp`.`question_type` (`quest_type`)
VALUES("text");
INSERT INTO `whedcapp`.`question_type` (`quest_type`)
VALUES("alternative");
INSERT INTO `whedcapp`.`question_type` (`quest_type`)
VALUES("scalar");
INSERT INTO `whedcapp`.`question_type` (`quest_type`)
VALUES("integer");
INSERT INTO `whedcapp`.`question_type` (`quest_type`)
VALUES("noanswer");

/* QUESTION_TYPE_SPECIFICAION
  #####  #     # #######  #####  ####### ### ####### #     #         ####### #     # ######  #######         
 #     # #     # #       #     #    #     #  #     # ##    #            #     #   #  #     # #               
 #     # #     # #       #          #     #  #     # # #   #            #      # #   #     # #               
 #     # #     # #####    #####     #     #  #     # #  #  #            #       #    ######  #####           
 #   # # #     # #             #    #     #  #     # #   # #            #       #    #       #               
 #    #  #     # #       #     #    #     #  #     # #    ##            #       #    #       #               
  #### #  #####  #######  #####     #    ### ####### #     #            #       #    #       #######         
                                                             #######                                 ####### 
  #####  ######  #######  #####  ### ####### ###  #####     #    ####### ### ####### #     #                 
 #     # #     # #       #     #  #  #        #  #     #   # #      #     #  #     # ##    #                 
 #       #     # #       #        #  #        #  #        #   #     #     #  #     # # #   #                 
  #####  ######  #####   #        #  #####    #  #       #     #    #     #  #     # #  #  #                 
       # #       #       #        #  #        #  #       #######    #     #  #     # #   # #                 
 #     # #       #       #     #  #  #        #  #     # #     #    #     #  #     # #    ##                 
  #####  #       #######  #####  ### #       ###  #####  #     #    #    ### ####### #     #                 
                                                                                                             
*/

CREATE TABLE `whedcapp`.`question_type_specification` (
    `id_quest_type_spec` INTEGER NOT NULL AUTO_INCREMENT,
    `id_quest_type` INTEGER NOT NULL,
    `quest_type_spec_text` VARCHAR(32) NOT NULL,
    PRIMARY KEY(`id_quest_type_spec`),
    UNIQUE INDEX `quest_type_spec_idx`(`id_quest_type`,`quest_type_spec_text`),
    INDEX `quest_type_spec_id_quest_type_constraint_idx`(`id_quest_type`),
    CONSTRAINT `quest_type_spec_id_quest_type_constraint`
        FOREIGN KEY (`id_quest_type`)
        REFERENCES `whedcapp`.`question_type`(`id_quest_type`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

/* QUESTION
  #####  #     # #######  #####  ####### ### ####### #     # 
 #     # #     # #       #     #    #     #  #     # ##    # 
 #     # #     # #       #          #     #  #     # # #   # 
 #     # #     # #####    #####     #     #  #     # #  #  # 
 #   # # #     # #             #    #     #  #     # #   # # 
 #    #  #     # #       #     #    #     #  #     # #    ## 
  #### #  #####  #######  #####     #    ### ####### #     # 
                                                             
*/

CREATE TABLE `whedcapp`.`question` (
  `id_quest`INTEGER NOT NULL AUTO_INCREMENT,
  `id_quest_type_spec`INTEGER NOT NULL,
  `quest_key` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id_quest`),
  UNIQUE INDEX `quest_key_idx` (`quest_key`),
  INDEX `id_question_type_spec_constraint_idx` (`id_quest_type_spec`),
  CONSTRAINT `id_question_type_spec_constraint`
    FOREIGN KEY (`id_quest_type_spec`)
    REFERENCES `whedcapp`.`question_type_specification`(`id_quest_type_spec`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `question_key_not_empty` CHECK (`quest_key` <> "")
  
);
  
        

CREATE TABLE `whedcapp`.`question_locale`(
  `id_quest_loc` INTEGER NOT NULL AUTO_INCREMENT,
  `id_loc`INTEGER NOT NULL,
  `quest_text` VARCHAR(45) NOT NULL,
  `id_quest` INTEGER NOT NULL,
  PRIMARY KEY (`id_quest_loc`),
  UNIQUE INDEX `question_locale_idx_unique`(`id_quest`, `id_loc`,`quest_text`),
  INDEX `id_quest_loc_constraint_idx`(`id_loc`),
  CONSTRAINT `id_quest_loc_constraint`
    FOREIGN KEY (`id_loc`)
    REFERENCES `whedcapp`.`locale` (`id_loc`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_quest_constraint_idx`(`id_quest`),
  CONSTRAINT `id_quest_constraint`
    FOREIGN KEY (`id_quest`)
    REFERENCES `whedcapp`.`question` (`id_quest`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* ALTERNATIVE
    #    #       ####### ####### ######  #     #    #    ####### ### #     # ####### 
   # #   #          #    #       #     # ##    #   # #      #     #  #     # #       
  #   #  #          #    #       #     # # #   #  #   #     #     #  #     # #       
 #     # #          #    #####   ######  #  #  # #     #    #     #  #     # #####   
 ####### #          #    #       #   #   #   # # #######    #     #   #   #  #       
 #     # #          #    #       #    #  #    ## #     #    #     #    # #   #       
 #     # #######    #    ####### #     # #     # #     #    #    ###    #    ####### 
                                                                                     
*/
   
CREATE TABLE `whedcapp`.`alternative` (
  `id_alt` INTEGER NOT NULL AUTO_INCREMENT,
  `alt_key` VARCHAR(32) NOT NULL,
  `id_quest_type_spec` INTEGER NOT NULL,
  PRIMARY KEY (`id_alt`),
  UNIQUE INDEX `alt_key_idx` (`id_quest_type_spec`, `alt_key`),
  INDEX `id_quest_type_spec_constraint_idx`(`id_quest_type_spec`),
  CONSTRAINT `id_quest_type_spec_constraint`
    FOREIGN KEY (`id_quest_type_spec`)
    REFERENCES `whedcapp`.`question_type_specification` (`id_quest_type_spec`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE `whedcapp`.`alternative_locale` (
  `id_alt_loc` INTEGER NOT NULL AUTO_INCREMENT,
  `id_loc`INTEGER NOT NULL,
  `id_alt` INTEGER NOT NULL,
  `alt_text` VARCHAR(45),
  PRIMARY KEY (`id_alt_loc`),
  UNIQUE INDEX `id_alt_loc_constaint_idx` (`id_loc`,`id_alt`),
  INDEX `id_alt_loc_constraint_idx`(`id_loc`),
  CONSTRAINT `id_alt_loc_constraint`
    FOREIGN KEY (`id_loc`)
    REFERENCES `whedcapp`.`locale`(`id_loc`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_alt_constraint_idx`(`id_alt`),
  CONSTRAINT `id_alt_constraint`
    FOREIGN KEY (`id_alt`)
    REFERENCES `whedcapp`.`alternative` (`id_alt`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    );
/* QUESTION_ANSWER_INTEGER_RANGE
  #####  #     # #######  #####  ####### ### ####### #     #            #    #     #  #####  #     # ####### ######          
 #     # #     # #       #     #    #     #  #     # ##    #           # #   ##    # #     # #  #  # #       #     #         
 #     # #     # #       #          #     #  #     # # #   #          #   #  # #   # #       #  #  # #       #     #         
 #     # #     # #####    #####     #     #  #     # #  #  #         #     # #  #  #  #####  #  #  # #####   ######          
 #   # # #     # #             #    #     #  #     # #   # #         ####### #   # #       # #  #  # #       #   #           
 #    #  #     # #       #     #    #     #  #     # #    ##         #     # #    ## #     # #  #  # #       #    #          
  #### #  #####  #######  #####     #    ### ####### #     #         #     # #     #  #####   ## ##  ####### #     #         
                                                             #######                                                 ####### 
 ### #     # ####### #######  #####  ####### ######          ######     #    #     #  #####  #######                         
  #  ##    #    #    #       #     # #       #     #         #     #   # #   ##    # #     # #                               
  #  # #   #    #    #       #       #       #     #         #     #  #   #  # #   # #       #                               
  #  #  #  #    #    #####   #  #### #####   ######          ######  #     # #  #  # #  #### #####                           
  #  #   # #    #    #       #     # #       #   #           #   #   ####### #   # # #     # #                               
  #  #    ##    #    #       #     # #       #    #          #    #  #     # #    ## #     # #                               
 ### #     #    #    #######  #####  ####### #     #         #     # #     # #     #  #####  #######                         
                                                     #######                                                                 
*/    
CREATE TABLE `whedcapp`.`question_answer_integer_range` (
  `id_quest_ans_rng` INTEGER NOT NULL AUTO_INCREMENT,
  `id_quest_type_spec` INTEGER NOT NULL,
  `quest_ans_rng_min`INTEGER NOT NULL,
  `quest_ans_rng_max` INTEGER NOT NULL,
  `quest_ans_rng_min_closed` BOOLEAN NOT NULL DEFAULT TRUE,
  `quest_ans_rng_max_closed` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id_quest_ans_rng`),
  INDEX `id_quest_type_spec_quest_ans_rng_constraint_idx`(`id_quest_type_spec`),
  CONSTRAINT `id_quest_type_spec_quest_ans_rng_constraint`
    FOREIGN KEY (`id_quest_type_spec`)
    REFERENCES `whedcapp`.`question_type_specification`(`id_quest_type_spec`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
  );
/* QUESTION_ANSWER_SCALAR_RANGE
  #####  #     # #######  #####  ####### ### ####### #     #            #    #     #  #####  #     # ####### ######          
 #     # #     # #       #     #    #     #  #     # ##    #           # #   ##    # #     # #  #  # #       #     #         
 #     # #     # #       #          #     #  #     # # #   #          #   #  # #   # #       #  #  # #       #     #         
 #     # #     # #####    #####     #     #  #     # #  #  #         #     # #  #  #  #####  #  #  # #####   ######          
 #   # # #     # #             #    #     #  #     # #   # #         ####### #   # #       # #  #  # #       #   #           
 #    #  #     # #       #     #    #     #  #     # #    ##         #     # #    ## #     # #  #  # #       #    #          
  #### #  #####  #######  #####     #    ### ####### #     #         #     # #     #  #####   ## ##  ####### #     #         
                                                             #######                                                 ####### 
  #####   #####     #    #          #    ######          ######     #    #     #  #####  #######                             
 #     # #     #   # #   #         # #   #     #         #     #   # #   ##    # #     # #                                   
 #       #        #   #  #        #   #  #     #         #     #  #   #  # #   # #       #                                   
  #####  #       #     # #       #     # ######          ######  #     # #  #  # #  #### #####                               
       # #       ####### #       ####### #   #           #   #   ####### #   # # #     # #                                   
 #     # #     # #     # #       #     # #    #          #    #  #     # #    ## #     # #                                   
  #####   #####  #     # ####### #     # #     #         #     # #     # #     #  #####  #######                             
                                                 #######                                                                     
*/  
  CREATE TABLE `whedcapp`.`question_answer_scalar_range` (
  `id_quest_ans_scl_rng` INTEGER NOT NULL AUTO_INCREMENT,
  `id_quest_type_spec` INTEGER NOT NULL,
  `quest_ans_rng_scl_min` DOUBLE NOT NULL,
  `quest_ans_rng_scl_max` DOUBLE NOT NULL,
  `quest_ans_rng_scl_min_closed` BOOLEAN NOT NULL DEFAULT TRUE,
  `quest_ans_rng_scl_max_closed` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id_quest_ans_scl_rng`),
  INDEX `id_quest_type_spec_quest_ans_scl_rng_constraint_idx`(`id_quest_type_spec`),
  CONSTRAINT `id_quest_type_spec_quest_ans_scl_rng_constraint`
    FOREIGN KEY (`id_quest_type_spec`)
    REFERENCES `whedcapp`.`question`(`id_quest_type_spec`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
  );
  
/* QUESTIONNAIRE_SHARE_TYPE
   #####  #     # #######  #####  ####### ### ####### #     # #     #    #    ### ######  #######         
 #     # #     # #       #     #    #     #  #     # ##    # ##    #   # #    #  #     # #               
 #     # #     # #       #          #     #  #     # # #   # # #   #  #   #   #  #     # #               
 #     # #     # #####    #####     #     #  #     # #  #  # #  #  # #     #  #  ######  #####           
 #   # # #     # #             #    #     #  #     # #   # # #   # # #######  #  #   #   #               
 #    #  #     # #       #     #    #     #  #     # #    ## #    ## #     #  #  #    #  #               
  #### #  #####  #######  #####     #    ### ####### #     # #     # #     # ### #     # #######         
                                                                                                 ####### 
  #####  #     #    #    ######  #######         ####### #     # ######  #######                         
 #     # #     #   # #   #     # #                  #     #   #  #     # #                               
 #       #     #  #   #  #     # #                  #      # #   #     # #                               
  #####  ####### #     # ######  #####              #       #    ######  #####                           
       # #     # ####### #   #   #                  #       #    #       #                               
 #     # #     # #     # #    #  #                  #       #    #       #                               
  #####  #     # #     # #     # #######            #       #    #       #######                         
                                         #######                                                          
*/
  
  CREATE TABLE `whedcapp`.`questionnaire_share_type` (
    `id_questionnaire_sha_tp` INTEGER NOT NULL AUTO_INCREMENT,
    `questionnaire_sha_tp_text` VARCHAR(32),
    PRIMARY KEY(`id_questionnaire_sha_tp`), 
    UNIQUE INDEX `questionnaire_share_type_unq_idx`(`questionnaire_sha_tp_text`)
);

INSERT INTO `whedcapp`.`questionnaire_share_type` (`questionnaire_sha_tp_text`)
    VALUES ("public"), ("site"), ("private");

/* QUESTIONNAIRE
  #####  #     # #######  #####  ####### ### ####### #     # #     #    #    ### ######  ####### 
 #     # #     # #       #     #    #     #  #     # ##    # ##    #   # #    #  #     # #       
 #     # #     # #       #          #     #  #     # # #   # # #   #  #   #   #  #     # #       
 #     # #     # #####    #####     #     #  #     # #  #  # #  #  # #     #  #  ######  #####   
 #   # # #     # #             #    #     #  #     # #   # # #   # # #######  #  #   #   #       
 #    #  #     # #       #     #    #     #  #     # #    ## #    ## #     #  #  #    #  #       
  #### #  #####  #######  #####     #    ### ####### #     # #     # #     # ### #     # ####### 
                                                                                                 
*/
CREATE TABLE `whedcapp`.`questionnaire` (
  `id_questionnaire` INTEGER NOT NULL AUTO_INCREMENT,
  `id_questionnaire_sha_tp` INTEGER NOT NULL,
  `questionnaire_key` VARCHAR(32) NOT NULL,
  `questionnaire_is_longitudinal` BOOLEAN DEFAULT FALSE,
  `questionnaire_allow_comments` BOOLEAN DEFAULT FALSE,
  `questionnaire_locked` BOOLEAN DEFAULT FALSE,
  `questionnaire_graphable` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`id_questionnaire`),
  UNIQUE INDEX `questionnaire_idx`(`questionnaire_key`),
  CONSTRAINT `questionnaire_key_not_empty` CHECK (`questionnaire_key` <> ""),
  INDEX `questionnaire_id_questionnaire_sha_tp_constraint_idx`(`id_questionnaire_sha_tp`),
  CONSTRAINT `questionnaire_id_questionnaire_sha_tp_constraint`
    FOREIGN KEY (`id_questionnaire_sha_tp`)
    REFERENCES `whedcapp`.`questionnaire_share_type`(`id_questionnaire_sha_tp`)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
  );
  
  CREATE TABLE `whedcapp`.`questionnaire_locale` (
    `id_questionnaire_loc`  INTEGER NOT NULL AUTO_INCREMENT,
    `id_questionnaire` INTEGER NOT NULL,
    `questionnaire_text` VARCHAR(45),
    `id_loc` INTEGER NOT NULL,
    PRIMARY KEY (`id_questionnaire_loc`),
    UNIQUE INDEX `questionnaire_loc_idx` (`id_questionnaire`,`id_loc`),
    INDEX `id_questionnaire_loc_constraint_idx` (`id_loc`),
    CONSTRAINT `id_questionnaire_loc_constraint`
      FOREIGN KEY (`id_loc`)
      REFERENCES `whedcapp`.`locale`(`id_loc`)
      ON DELETE CASCADE
      ON UPDATE NO ACTION,
    INDEX `id_questionnaire_constraint_idx` (`id_questionnaire`),
    CONSTRAINT `id_questionnaire`
      FOREIGN KEY (`id_questionnaire`)
      REFERENCES `whedcapp`.`questionnaire`(`id_questionnaire`)
      ON DELETE CASCADE
      ON UPDATE NO ACTION
      );
/* UQ_REL
 #     #  #####          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 #     # #     #         ######  #####   #       
 #     # #   # #         #   #   #       #       
 #     # #    #          #    #  #       #       
  #####   #### #         #     # ####### ####### 
                 #######                         
*/      
CREATE TABLE `whedcapp`.`uq_rel` (
    `id_uq_rel` INTEGER NOT NULL AUTO_INCREMENT,
    `id_uid` INTEGER NOT NULL,
    `id_questionnaire` INTEGER NOT NULL,
    PRIMARY KEY(`id_uq_rel`),
    UNIQUE INDEX `uq_rel_uniq_idx`(`id_uid`,`id_questionnaire`),
    INDEX `uq_rel_id_uid_constraint_idx`(`id_uid`),
    CONSTRAINT `uq_rel_id_uid_constraint`
        FOREIGN KEY (`id_uid`)
        REFERENCES `whedcapp`.`uid`(`id_uid`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `uq_rel_id_questionnaire_constraint_idx`(`id_questionnaire`),
    CONSTRAINT `uq_rel_id_questionnaire_constraint`
        FOREIGN KEY (`id_questionnaire`)
        REFERENCES `whedcapp`.`questionnaire`(`id_questionnaire`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

/* AIM_OR_RESEARCH_QUESTION
    #    ### #     #         ####### ######                                                                                          
   # #    #  ##   ##         #     # #     #                                                                                         
  #   #   #  # # # #         #     # #     #                                                                                         
 #     #  #  #  #  #         #     # ######                                                                                          
 #######  #  #     #         #     # #   #                                                                                           
 #     #  #  #     #         #     # #    #                                                                                          
 #     # ### #     #         ####### #     #                                                                                         
                     #######                 #######                                                                                 
 ######  #######  #####  #######    #    ######   #####  #     #          #####  #     # #######  #####  ####### ### ####### #     # 
 #     # #       #     # #         # #   #     # #     # #     #         #     # #     # #       #     #    #     #  #     # ##    # 
 #     # #       #       #        #   #  #     # #       #     #         #     # #     # #       #          #     #  #     # # #   # 
 ######  #####    #####  #####   #     # ######  #       #######         #     # #     # #####    #####     #     #  #     # #  #  # 
 #   #   #             # #       ####### #   #   #       #     #         #   # # #     # #             #    #     #  #     # #   # # 
 #    #  #       #     # #       #     # #    #  #     # #     #         #    #  #     # #       #     #    #     #  #     # #    ## 
 #     # #######  #####  ####### #     # #     #  #####  #     #          #### #  #####  #######  #####     #    ### ####### #     # 
                                                                 #######                                                             
*/        
    
CREATE TABLE `whedcapp`.`aim_or_research_question` (
  `id_res_que` INTEGER NOT NULL AUTO_INCREMENT,
  `id_proj` INTEGER NOT NULL,
  `res_que_key`VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id_res_que`),
  UNIQUE INDEX `id_res_que`(`id_proj`,`res_que_key`),
  INDEX `id_res_que_proj_constraint_idx`(`id_proj`),
  CONSTRAINT `id_res_que_proj_constraint`
    FOREIGN KEY (`id_proj`)
    REFERENCES `whedcapp`.`project`(`id_proj`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `research_question_res_que_key_not_empty` CHECK (`res_que_key` <> "")
);

CREATE TABLE `whedcapp`.`aim_or_research_question_locale` (
  `id_res_que_loc` INTEGER NOT NULL AUTO_INCREMENT,
  `id_res_que` INTEGER NOT NULL,
  `id_loc` INTEGER NOT NULL,
  `res_que_text` VARCHAR(45) NOT NULL,
  PRIMARY KEY(`id_res_que_loc`),
  UNIQUE INDEX `id_res_que_loc_idx`(`id_res_que`,`id_loc`),
  INDEX `id_res_que_constraint_idx`(`id_res_que`),
  CONSTRAINT `id_res_que_constraint`
    FOREIGN KEY (`id_res_que`)
    REFERENCES `whedcapp`.`aim_or_research_question`(`id_res_que`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_res_que_loc_constraint_idx`(`id_loc`),
  CONSTRAINT `id_res_que_loc_constraint`
    FOREIGN KEY (`id_loc`)
    REFERENCES `whedcapp`.`locale`(`id_loc`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* QQ_REL
  #####   #####          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 #     # #     #         ######  #####   #       
 #   # # #   # #         #   #   #       #       
 #    #  #    #          #    #  #       #       
  #### #  #### #         #     # ####### ####### 
                 #######                         
*/
CREATE TABLE `whedcapp`.`qq_rel` (
    `id_qq_rel` INTEGER NOT NULL AUTO_INCREMENT,
    `id_questionnaire` INTEGER NOT NULL,
    `id_quest` INTEGER NOT NULL,
    `qq_rel_order` INTEGER NOT NULL,
    PRIMARY KEY(`id_qq_rel`),
    UNIQUE INDEX `qq_rel_unique_idx`(`id_quest`,`id_questionnaire`),
    UNIQUE INDEX `qq_rel_unique_order_idx`(`id_quest`,`id_questionnaire`,`qq_rel_order`),
    CONSTRAINT `qq_rel_order_above_zero` CHECK (`qq_rel_order`>-1),
    INDEX `qq_rel_id_questionnaire_constraint_idx`(`id_questionnaire`),
    CONSTRAINT `qq_rel_id_questionnaire_constraint`
        FOREIGN KEY (`id_questionnaire`)
        REFERENCES `whedcapp`.`questionnaire`(`id_questionnaire`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `qq_rel_id_quest_constraint_idx`(`id_quest`),
    CONSTRAINT `qq_rel_id_quest_constraint`
        FOREIGN KEY (`id_quest`)
        REFERENCES `whedcapp`.`question`(`id_quest`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);
/* RQ_REL
 ######   #####          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 ######  #     #         ######  #####   #       
 #   #   #   # #         #   #   #       #       
 #    #  #    #          #    #  #       #       
 #     #  #### #         #     # ####### ####### 
                 #######                         
*/
CREATE TABLE `whedcapp`.`rq_rel` (
  `id_rq_rel` INTEGER NOT NULL AUTO_INCREMENT,
  `id_questionnaire` INTEGER NOT NULL,
  `id_res_que` INTEGER NOT NULL,
  PRIMARY KEY(`id_rq_rel`),
  UNIQUE INDEX `rq_rel_unique_idx`(`id_res_que`,`id_questionnaire`),
  INDEX `rq_rel_id_questionnaire_constraint_idx`(`id_questionnaire`),
  CONSTRAINT `rq_rel_id_questionnaire_constraint`
    FOREIGN KEY (`id_questionnaire`)
    REFERENCES `whedcapp`.`questionnaire`(`id_questionnaire`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `rq_rel_id_res_que_constraint_idx`(`id_res_que`),
  CONSTRAINT `rq_rel_id_res_que_constraint`
    FOREIGN KEY (`id_res_que`)
    REFERENCES `whedcapp`.`aim_or_research_question`(`id_res_que`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
/* RQQ_REL
 ######   #####   #####          ######  ####### #       
 #     # #     # #     #         #     # #       #       
 #     # #     # #     #         #     # #       #       
 ######  #     # #     #         ######  #####   #       
 #   #   #   # # #   # #         #   #   #       #       
 #    #  #    #  #    #          #    #  #       #       
 #     #  #### #  #### #         #     # ####### ####### 
                         #######                         
*/

CREATE TABLE `whedcapp`.`rqq_rel` (
  `id_rqq_rel` INTEGER NOT NULL AUTO_INCREMENT,
  `id_qq_rel` INTEGER NOT NULL,
  `id_rq_rel` INTEGER NOT NULL,
  PRIMARY KEY(`id_rqq_rel`),
  UNIQUE INDEX `id_rqq_rel_idx`(`id_qq_rel`,`id_rq_rel`),
  INDEX `id_rqq_qq_rel_constraint_idx`(`id_qq_rel`),
  CONSTRAINT `id_rqq_qq_rel_constraint`
    FOREIGN KEY (`id_qq_rel`)
    REFERENCES `whedcapp`.`qq_rel`(`id_qq_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_rqq_rq_rel_constraint_idx`(`id_rq_rel`),
  CONSTRAINT `id_rqq_rq_rel_constraint`
    FOREIGN KEY (`id_rq_rel`)
    REFERENCES `whedcapp`.`rq_rel`(`id_rq_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* PARTICIPANT
 ######     #    ######  ####### ###  #####  ### ######     #    #     # ####### 
 #     #   # #   #     #    #     #  #     #  #  #     #   # #   ##    #    #    
 #     #  #   #  #     #    #     #  #        #  #     #  #   #  # #   #    #    
 ######  #     # ######     #     #  #        #  ######  #     # #  #  #    #    
 #       ####### #   #      #     #  #        #  #       ####### #   # #    #    
 #       #     # #    #     #     #  #     #  #  #       #     # #    ##    #    
 #       #     # #     #    #    ###  #####  ### #       #     # #     #    #    
                                                                                 
*/
    
CREATE TABLE `whedcapp`.`participant` (
  `id_part`INTEGER NOT NULL AUTO_INCREMENT,
  `id_uid` INTEGER NOT NULL,
  PRIMARY KEY (`id_part`),
  UNIQUE INDEX `part_id_uid_constraint_idx`(`id_uid`),
  CONSTRAINT `part_id_uid_constraint`
    FOREIGN KEY (`id_uid`)
    REFERENCES `whedcapp`.`uid`(`id_uid`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* GDPR_STATUS
  #####  ######  ######  ######           #####  #######    #    ####### #     #  #####  
 #     # #     # #     # #     #         #     #    #      # #      #    #     # #     # 
 #       #     # #     # #     #         #          #     #   #     #    #     # #       
 #  #### #     # ######  ######           #####     #    #     #    #    #     #  #####  
 #     # #     # #       #   #                 #    #    #######    #    #     #       # 
 #     # #     # #       #    #          #     #    #    #     #    #    #     # #     # 
  #####  ######  #       #     #          #####     #    #     #    #     #####   #####  
                                 #######                                                 
*/
CREATE TABLE `whedcapp`.`gdpr_status` (
  `id_gdpr_stat` INTEGER NOT NULL AUTO_INCREMENT,
  `gdpr_stat_txt` VARCHAR(32),
  PRIMARY KEY (`id_gdpr_stat`),
  UNIQUE INDEX `gdpr_status_idx` (`gdpr_stat_txt`),
  CONSTRAINT `gdpr_status_gdpr_stat_txt_check` CHECK (`gdpr_stat_txt` <> "")
);



INSERT INTO `whedcapp`.`gdpr_status`(`gdpr_stat_txt`) 
    VALUES ("participation_request"),("removal_request"), ("printout_request"), ("data_dump_request");
    
CREATE TABLE `whedcapp`.`gdpr_status_locale` (
    `id_gdpr_stat_loc` INTEGER NOT NULL AUTO_INCREMENT,
    `id_gdpr_stat`INTEGER NOT NULL,
    `id_loc` INTEGER NOT NULL,
    `gdpr_stat_loc_txt` VARCHAR(64),
    PRIMARY KEY(`id_gdpr_stat_loc`),
    INDEX `gdpr_status_locale_id_gdpr_stat_constraint_idx`(`id_gdpr_stat`),
    CONSTRAINT `gdpr_status_locale_id_gdpr_stat_constraint`
        FOREIGN KEY (`id_gdpr_stat`)
        REFERENCES `whedcapp`.`gdpr_status`(`id_gdpr_stat`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `gdpr_status_locale_id_loc_constraint_idx`(`id_loc`),
    CONSTRAINT `gdpr_status_locale_id_loc_constraint`
        FOREIGN KEY (`id_loc`)
        REFERENCES `whedcapp`.`locale`(`id_loc`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION
);

INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Deltagandeförfrågan(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                `icu_code` = "sv_SE"
            AND
                `gdpr_stat_txt` = "participation_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Bortagningsförfrågan(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                `icu_code` = "sv_SE"
            AND
                `gdpr_stat_txt` = "removal_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Utskriftsförfrågan(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                `icu_code` = "sv_SE"
            AND
                `gdpr_stat_txt` = "printout_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Datanedladdningsförfrågan(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                `icu_code` = "sv_SE"
            AND
                `gdpr_stat_txt` = "data_dump_request";

INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Participation request(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                (`icu_code` = "en_GB" OR `icu_code` = "en_US")
            AND
                `gdpr_stat_txt` = "participation_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Removal request(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                (`icu_code` = "en_GB" OR `icu_code` = "en_US")
            AND
                `gdpr_stat_txt` = "removal_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Printout request(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                (`icu_code` = "en_GB" OR `icu_code` = "en_US")
            AND
                `gdpr_stat_txt` = "printout_request";
INSERT INTO `whedcapp`.`gdpr_status_locale`(`id_loc`,`id_gdpr_stat`,`gdpr_stat_loc_txt`)
    SELECT `id_loc`,`id_gdpr_stat`,"Data dump request(GDPR)"
        FROM `whedcapp`.`locale`, `whedcapp`.`gdpr_status`
        WHERE 
                (`icu_code` = "en_GB" OR `icu_code` = "en_US")
            AND
                `gdpr_stat_txt` = "data_dump_request";
/* PARTICIPANT_GDPR_STATUS_LOG
 ######     #    ######  ####### ###  #####  ### ######     #    #     # #######          #####  ######  ######  ######          
 #     #   # #   #     #    #     #  #     #  #  #     #   # #   ##    #    #            #     # #     # #     # #     #         
 #     #  #   #  #     #    #     #  #        #  #     #  #   #  # #   #    #            #       #     # #     # #     #         
 ######  #     # ######     #     #  #        #  ######  #     # #  #  #    #            #  #### #     # ######  ######          
 #       ####### #   #      #     #  #        #  #       ####### #   # #    #            #     # #     # #       #   #           
 #       #     # #    #     #     #  #     #  #  #       #     # #    ##    #            #     # #     # #       #    #          
 #       #     # #     #    #    ###  #####  ### #       #     # #     #    #             #####  ######  #       #     #         
                                                                                 #######                                 ####### 
  #####  #######    #    ####### #     #  #####          #       #######  #####                                                  
 #     #    #      # #      #    #     # #     #         #       #     # #     #                                                 
 #          #     #   #     #    #     # #               #       #     # #                                                       
  #####     #    #     #    #    #     #  #####          #       #     # #  ####                                                 
       #    #    #######    #    #     #       #         #       #     # #     #                                                 
 #     #    #    #     #    #    #     # #     #         #       #     # #     #                                                 
  #####     #    #     #    #     #####   #####          ####### #######  #####                                                  
                                                 #######                                                                         
*/

CREATE TABLE `whedcapp`.`participant_gdpr_status_log` (
  `id_part_gdpr_stat` INTEGER NOT NULL AUTO_INCREMENT,
  `id_gdpr_stat` INTEGER NOT NULL,
  `id_part` INTEGER NOT NULL,
  `part_gdpr_stat_log_request_date` DATE NOT NULL,
  `part_gdpr_stat_log_completion_date` DATE,
  PRIMARY KEY (`id_part_gdpr_stat`),
  INDEX `id_gdpr_status_log_gdpr_stat_constraint_idx`(`id_gdpr_stat`),
  CONSTRAINT `id_gdpr_status_log_gdpr_stat_constraint`
    FOREIGN KEY (`id_gdpr_stat`)
    REFERENCES `whedcapp`.`gdpr_status` (`id_gdpr_stat`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_gdpr_status_log_part_constraint_idx`(`id_part`),
  CONSTRAINT `id_gdpr_status_log_part_constraint`
    FOREIGN KEY (`id_part`)
    REFERENCES `whedcapp`.`participant`(`id_part`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `participant_gdpr_status_log` CHECK ((`part_gdpr_stat_log_completion_date` IS NULL) OR ((`part_gdpr_stat_log_completion_date` IS NOT NULL) AND `part_gdpr_stat_log_request_date`<`part_gdpr_stat_log_completion_date`))
);
  
/* SAMPLING_SESSION
  #####     #    #     # ######  #       ### #     #  #####           #####  #######  #####   #####  ### ####### #     # 
 #     #   # #   ##   ## #     # #        #  ##    # #     #         #     # #       #     # #     #  #  #     # ##    # 
 #        #   #  # # # # #     # #        #  # #   # #               #       #       #       #        #  #     # # #   # 
  #####  #     # #  #  # ######  #        #  #  #  # #  ####          #####  #####    #####   #####   #  #     # #  #  # 
       # ####### #     # #       #        #  #   # # #     #               # #             #       #  #  #     # #   # # 
 #     # #     # #     # #       #        #  #    ## #     #         #     # #       #     # #     #  #  #     # #    ## 
  #####  #     # #     # #       ####### ### #     #  #####           #####  #######  #####   #####  ### ####### #     # 
                                                             #######                                                     
*/
CREATE TABLE `whedcapp`.`sampling_session` (
  `id_samp_sess` INTEGER NOT NULL AUTO_INCREMENT,
  `sess_start_time` DATETIME NOT NULL,
  `sess_end_time` DATETIME,
  PRIMARY KEY (`id_samp_sess`),
  CONSTRAINT `sampling_session_timestamp_check` CHECK ((`sess_end_time` IS NULL) OR ((`sess_end_time` IS NOT NULL ) AND `sess_end_time`>`sess_start_time`))
);

/* Split from pps_rel -> pp_rel and pp_rel_s_rel */
/* PP_REL
 ######  ######          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 ######  ######          ######  #####   #       
 #       #               #   #   #       #       
 #       #               #    #  #       #       
 #       #               #     # ####### ####### 
                 #######                         
*/

CREATE TABLE `whedcapp`.`pp_rel` (
  `id_pp_rel`  INTEGER NOT NULL AUTO_INCREMENT,
  `id_proj_round` INTEGER NOT NULL,
  `id_part` INTEGER NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`id_pp_rel`),
  UNIQUE INDEX `pp_rel_unique2_idx`(`id_part`,`id_proj_round`),
  INDEX `pp_rel_id_part_constraint_idx` (`id_part`),
  CONSTRAINT `pp_rel_id_part_constraint`
    FOREIGN KEY (`id_part`)
    REFERENCES `whedcapp`.`participant`(`id_part`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `pp_rel_proj_round_constraint_idx` (`id_proj_round`),
  CONSTRAINT `pp_rel_proj_round_constraint`
    FOREIGN KEY (`id_proj_round`)
    REFERENCES `whedcapp`.`project_round`(`id_proj_round`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `pp_rel_date_check` CHECK (`start_date` < `end_date`)
  
);

/* PP_REL_S_REL
 ######  ######          ######  ####### #                #####          ######  ####### #       
 #     # #     #         #     # #       #               #     #         #     # #       #       
 #     # #     #         #     # #       #               #               #     # #       #       
 ######  ######          ######  #####   #                #####          ######  #####   #       
 #       #               #   #   #       #                     #         #   #   #       #       
 #       #               #    #  #       #               #     #         #    #  #       #       
 #       #               #     # ####### #######          #####          #     # ####### ####### 
                 #######                         #######         #######                         

*/

CREATE TABLE `whedcapp`.`pp_rel_s_rel` (
  `id_pp_rel_s_rel`  INTEGER NOT NULL AUTO_INCREMENT,
  `id_samp_sess` INTEGER NOT NULL,
  `id_pp_rel` INTEGER NOT NULL,
  PRIMARY KEY (`id_pp_rel_s_rel`),
  UNIQUE INDEX `pps_rel_idx`(`id_pp_rel`,`id_samp_sess`), /* At most one record for each sampling session beloing to a participant in a project */
  INDEX `id_pp_rel_s_rel_pp_rel_constraint_idx` (`id_pp_rel`),
  CONSTRAINT `id_pp_rel_s_rel_pp_rel_constraint`
    FOREIGN KEY (`id_pp_rel`)
    REFERENCES `whedcapp`.`pp_rel`(`id_pp_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_pps_rel_samp_sess_constraint_idx` (`id_samp_sess`),
  CONSTRAINT `id_pps_rel_samp_sess_constraint`
    FOREIGN KEY (`id_samp_sess`)
    REFERENCES `whedcapp`.`sampling_session`(`id_samp_sess`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);
/* PPSA_RQQ_A_REL
 ######  ######   #####     #            ######   #####   #####             #            ######  ####### #       
 #     # #     # #     #   # #           #     # #     # #     #           # #           #     # #       #       
 #     # #     # #        #   #          #     # #     # #     #          #   #          #     # #       #       
 ######  ######   #####  #     #         ######  #     # #     #         #     #         ######  #####   #       
 #       #             # #######         #   #   #   # # #   # #         #######         #   #   #       #       
 #       #       #     # #     #         #    #  #    #  #    #          #     #         #    #  #       #       
 #       #        #####  #     #         #     #  #### #  #### #         #     #         #     # ####### ####### 
                                 #######                         #######         #######                         
*/
CREATE TABLE `whedcapp`.`ppsa_rqq_a_rel` (
  `id_ppsa_rqq_a_rel` INTEGER NOT NULL AUTO_INCREMENT,
  `id_pp_rel_s_rel` INTEGER NOT NULL,
  `id_rqq_rel` INTEGER NOT NULL,
  `ppsa_rqq_a_rel_completed` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id_ppsa_rqq_a_rel`),
  INDEX `id_ppsa_rqq_a_rel_pps_rel_constraint_idx` (`id_pp_rel_s_rel`),
  CONSTRAINT `id_ppsa_rqq_a_rel_pps_rel_constraint`
    FOREIGN KEY (`id_pp_rel_s_rel`)
    REFERENCES `whedcapp`.`pp_rel_s_rel`(`id_pp_rel_s_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_ppsa_rqq_a_rel_rqq_rel_constraint_idx` (`id_rqq_rel`),
  CONSTRAINT `id_ppsa_rqq_a_rel_rqq_rel_constraint`
    FOREIGN KEY (`id_rqq_rel`)
    REFERENCES `whedcapp`.`rqq_rel`(`id_rqq_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* ANSWER
    #    #     #  #####  #     # ####### ######  
   # #   ##    # #     # #  #  # #       #     # 
  #   #  # #   # #       #  #  # #       #     # 
 #     # #  #  #  #####  #  #  # #####   ######  
 ####### #   # #       # #  #  # #       #   #   
 #     # #    ## #     # #  #  # #       #    #  
 #     # #     #  #####   ## ##  ####### #     # 
                                                 
*/
    
CREATE TABLE `whedcapp`.`answer` (
  `id_ans` INTEGER NOT NULL AUTO_INCREMENT,
  `ans_rev` INTEGER NOT NULL,
  `ans_ts` DATETIME NOT NULL,
  `id_ppsa_rqq_a_rel` INTEGER NOT NULL,
  PRIMARY KEY (`id_ans`),
  UNIQUE INDEX `answer_id_ppsa_rqq_a_rel_ans_rev_idx`(`id_ppsa_rqq_a_rel`,`ans_rev`),
  INDEX `answer_id_ppsa_rqq_a_rel_constraint_idx`(`id_ppsa_rqq_a_rel`),
  CONSTRAINT `answer_id_ppsa_rqq_a_rel_constraint`
    FOREIGN KEY (`id_ppsa_rqq_a_rel`)
    REFERENCES `whedcapp`.`ppsa_rqq_a_rel`(`id_ppsa_rqq_a_rel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

/* ANSWER_CONTENT
    #    #     #  #####  #     # ####### ######           #####  ####### #     # ####### ####### #     # ####### 
   # #   ##    # #     # #  #  # #       #     #         #     # #     # ##    #    #    #       ##    #    #    
  #   #  # #   # #       #  #  # #       #     #         #       #     # # #   #    #    #       # #   #    #    
 #     # #  #  #  #####  #  #  # #####   ######          #       #     # #  #  #    #    #####   #  #  #    #    
 ####### #   # #       # #  #  # #       #   #           #       #     # #   # #    #    #       #   # #    #    
 #     # #    ## #     # #  #  # #       #    #          #     # #     # #    ##    #    #       #    ##    #    
 #     # #     #  #####   ## ##  ####### #     #          #####  ####### #     #    #    ####### #     #    #    
                                                 #######                                                         
*/

CREATE TABLE `whedcapp`.`answer_content` (
  `id_ans_cont` INTEGER NOT NULL AUTO_INCREMENT,
  `ans_text` VARCHAR(1024),
  `ans_integer` INTEGER,
  `ans_scalar` DOUBLE,
  `id_alt` INTEGER,
  `id_loc` INTEGER NOT NULL,
  `id_ans` INTEGER NOT NULL,
  `ans_committed` BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (`id_ans_cont`),
  INDEX `id_ans_text_ans_constraint_idx` (`id_ans`),
  CONSTRAINT `id_ans_text_ans_constraint`
    FOREIGN KEY (`id_ans`)
    REFERENCES `whedcapp`.`answer`(`id_ans`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  INDEX `id_ans_text_loc_constraint_idx`(`id_loc`),
  CONSTRAINT `id_ans_text_loc_constraint`
    FOREIGN KEY (`id_loc`)
    REFERENCES `whedcapp`.`locale`(`id_loc`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE VIEW `whedcapp`.`answer_text` 
AS
    SELECT `id_ans_cont`, `ans_text`, `id_loc`, `id_ans`, `ans_committed`
    FROM `whedcapp`.`answer_content`
    WHERE `ans_text` IS NOT NULL;
    
CREATE VIEW `whedcapp`.`answer_integer`
AS
    SELECT `id_ans_cont`, `ans_integer`, `id_loc`, `id_ans` , `ans_committed`
    FROM `whedcapp`.`answer_content`
    WHERE `ans_integer` IS NOT NULL;

CREATE VIEW `whedcapp`.`answer_scalar`
AS
    SELECT `id_ans_cont`, `ans_scalar`, `id_loc`, `id_ans`, `ans_committed`
    FROM `whedcapp`.`answer_content`
    WHERE `ans_scalar` IS NOT NULL;

CREATE VIEW `whedcapp`.`answer_alternative`
AS
    SELECT `id_ans_cont`, `id_alt`, `id_loc`, `id_ans`
    FROM `whedcapp`.`answer_content`
    WHERE `id_alt` IS NOT NULL;
    
/* SPP_REL
  #####  ######  ######          ######  ####### #       
 #     # #     # #     #         #     # #       #       
 #       #     # #     #         #     # #       #       
  #####  ######  ######          ######  #####   #       
       # #       #               #   #   #       #       
 #     # #       #               #    #  #       #       
  #####  #       #               #     # ####### ####### 
                         #######                         
*/

CREATE TABLE `whedcapp`.`spp_rel` (
    `id_spp` INTEGER NOT NULL AUTO_INCREMENT,
    `id_uid` INTEGER NOT NULL,
    `id_part` INTEGER NOT NULL,
    `id_proj_round` INTEGER NOT NULL,
    `spp_rel_start_date` DATETIME NOT NULL,
    `spp_rel_end_date` DATETIME,
    PRIMARY KEY(`id_spp`),
    UNIQUE INDEX `spp_rel_uniq_idx`(`id_uid`,`id_part`,`id_proj_round`),
    INDEX `spp_rel_id_uid_constraint_idx`(`id_uid`),
    CONSTRAINT `spell_rel_id_uid_constraint`
        FOREIGN KEY(`id_uid`)
        REFERENCES `whedcapp`.`uid`(`id_uid`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `spp_rel_id_part_constraint_idx`(`id_part`),
    CONSTRAINT `spell_rel_id_part_constraint`
        FOREIGN KEY(`id_part`)
        REFERENCES `whedcapp`.`participant`(`id_part`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    INDEX `spp_rel_id_proj_round_constraint_idx`(`id_proj_round`),
    CONSTRAINT `spell_rel_id_proj_round_constraint`
        FOREIGN KEY(`id_proj_round`)
        REFERENCES `whedcapp`.`project_round`(`id_proj_round`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `spp_rel_check_date` CHECK ((`spp_rel_end_date` IS NULL) OR (`spp_rel_end_date` IS NOT NULL AND `spp_rel_end_date`>`spp_rel_start_date`))
);


DELIMITER $$
DROP PROCEDURE IF EXISTS resetLog;$$
DROP PROCEDURE IF EXISTS doLog;$$
DROP PROCEDURE IF EXISTS `whedcapp`.`check_project_round`;$$
DROP TRIGGER IF EXISTS `whedcapp`.`check_project_round_trigger`;$$
DROP TRIGGER IF EXISTS `whedcapp`.`pp_rel_check_acl`;$$
DROP TRIGGER IF EXISTS `whedcapp`.`pp_rel_check_acl_update`;$$

Create Procedure resetLog() 
BEGIN   
    create table if not exists log (ts timestamp default current_timestamp, msg varchar(2048)) engine = myisam; 
    truncate table log;
END; 
$$

Create Procedure doLog(in logMsg varchar(2048))
BEGIN  
  insert into log (msg) values(logMsg);
END;
$$
/* PROJECT
 ######  ######  #######       # #######  #####  ####### 
 #     # #     # #     #       # #       #     #    #    
 #     # #     # #     #       # #       #          #    
 ######  ######  #     #       # #####   #          #    
 #       #   #   #     # #     # #       #          #    
 #       #    #  #     # #     # #       #     #    #    
 #       #     # #######  #####  #######  #####     #  
 */
CREATE PROCEDURE `whedcapp`.`project_insert_or_update_check`(
    in id_proj_par INTEGER,
    in start_date_par DATE,
    in end_date_par DATE
    )
BEGIN
    DECLARE no_of_mismatching_project_rounds_var INTEGER;
    DECLARE no_of_mismatching_uid_proj_acl_chg_log_var INTEGER;

    /* Check project rounds, if any */
    SELECT COUNT(`id_proj_round`) INTO no_of_mismatching_project_rounds_var
        FROM `whedcapp`.`project_round`
        WHERE
                `id_proj` = id_proj_par
            AND
                (`start_date` < start_date_par OR `start_date` > end_date_par OR `end_date` < start_date_par OR `end_date` > end_date_paer);
    IF no_of_mismatching_project_rounds_var THEN
        SIGNAL SQLSTATE '45030'
            SET MESSAGE_TEXT = 'Project must encompass project rounds';
    END IF;
    
    /* Check uid_project_acl_change_log, if any entreis */
    SELECT COUNT(`id_uid_proj_acl_chg_log`) INTO no_of_mismatching_uid_proj_acl_chg_log_var
        FROM `whedcapp`.`uid_project_acl_change_log` 
        WHERE
                `id_proj` = id_proj_par
            AND
                (`uid_proj_log_date` < start_date_par OR `uid_proj_log_date` > end_date_par);
    IF no_of_mismatching_uid_proj_acl_chg_log_var THEN
        SIGNAL SQLSTATE '45032' 
            SET MESSAGE_TEXT = 'Project must encompass uid project acl log dates';
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`project_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`project` FOR EACH ROW
BEGIN
   CALL `whedcapp`.`project_insert_or_update_check`(NEW.id_proj,NEW.start_date,NEW.end_date);
END;
$$
CREATE TRIGGER `whedcapp`.`project_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`project` FOR EACH ROW
BEGIN
   CALL `whedcapp`.`project_insert_or_update_check`(NEW.id_proj,NEW.start_date,NEW.end_date);
END;
$$
CREATE TRIGGER `whedcapp`.`project_delete_check`
    BEFORE DELETE
    ON `whedcapp`.`project` FOR EACH ROW
BEGIN
    IF NOT OLD.proj_marked_for_deletion THEN
        SIGNAL SQLSTATE '45031'
            SET MESSAGE_TEXT = 'Cannot delete a project that is not marked for deletion';
    END IF;
END;
$$
/* PROJECT_ROUND
 ######  ######  #######       # #######  #####  #######    ######  ####### #     # #     # ######  
 #     # #     # #     #       # #       #     #    #       #     # #     # #     # ##    # #     # 
 #     # #     # #     #       # #       #          #       #     # #     # #     # # #   # #     # 
 ######  ######  #     #       # #####   #          #       ######  #     # #     # #  #  # #     # 
 #       #   #   #     # #     # #       #          #       #   #   #     # #     # #   # # #     # 
 #       #    #  #     # #     # #       #     #    #       #    #  #     # #     # #    ## #     # 
 #       #     # #######  #####  #######  #####     #       #     # #######  #####  #     # ###### 
*/
CREATE PROCEDURE `whedcapp`.`project_round_insert_or_update_check`(
    in `start_date_par` DATE,
    in `end_date_par`DATE,
    in `id_proj_par` INTEGER,
    in `id_proj_round_par`INTEGER
    )
BEGIN
    DECLARE `violating_start_date_count` INTEGER;
    DECLARE `violating_end_date_count` INTEGER;
    DECLARE `violating_project_dates_count` INTEGER;
    DECLARE no_of_violating_pp_rel_records INTEGER;
  
    /* Check if insert or update overlaps with some other project round in the same project*/
    SELECT COUNT(*) INTO  `violating_start_date_count`
        FROM `whedcapp`.`project_round`
        WHERE ( (`start_date` <= `start_date_par` AND `end_date` > `start_date_par` )
                OR
                (`start_date_par` < `start_date` AND `start_date` <`end_date_par`)) AND `id_proj` = `id_proj_par`;
    /* Check if insert or update overlaps with some other project round in the same project*/
    SELECT COUNT(*) INTO `violating_end_date_count`
        FROM `whedcapp`.`project_round`
        WHERE ( (`start_date` < `end_date_par` AND `end_date` >= `end_date_par`)
                OR
                (`start_date_par` < `end_date` AND `end_date` <`end_date_par`)) AND `id_proj` = `id_proj_par`;
    IF (`violating_start_date_count` > 0 OR `violating_end_date_count` > 0) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Overlapping project rounds is disallowed';
    END IF;
    /* Check project round dates vis a vi project dates */
    SELECT COUNT(*) INTO `violating_project_dates_count`
        FROM `whedcapp`.`project` 
        WHERE `id_proj` = `id_proj_par` AND (`start_date` > `start_date_par` OR `end_date` < `end_date_par`);
    IF `violating_project_dates_count` > 0 THEN
        SIGNAL SQLSTATE '45001'
            SET MESSAGE_TEXT = 'Violation of project dates';
    END IF;
    /* Check project round dates vis a vi participant participation */
    SELECT COUNT(`id_pp_rel`) INTO no_of_violating_pp_rel_records
        FROM `whedcapp`.`pp_rel`
        WHERE 
                `id_proj_round` = id_proj_round_par
            AND
                (start_date_par>`start_date` OR end_date_par < `end_date`);
    IF no_of_violating_pp_rel_records > 0 THEN
        SIGNAL SQLSTATE '45029'
            SET MESSAGE_TEXT = 'Project round date interval must encompass project round participation intervals.';
    END IF;
END;
$$



CREATE TRIGGER `whedcapp`.`project_round_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`project_round` FOR EACH ROW
BEGIN
   CALL `whedcapp`.`project_round_insert_or_update_check`(NEW.start_date,NEW.end_date,NEW.id_proj,NEW.id_proj_round);
END;
$$
CREATE TRIGGER `whedcapp`.`project_round_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`project_round` FOR EACH ROW
BEGIN
    IF NEW.id_proj <> OLD.id_proj THEN
        SIGNAL SQLSTATE '45018' 
        SET MESSAGE_TEXT = 'Cannot move a project round from one project to another';
    END IF;
   CALL `whedcapp`.`check_project_round`(NEW.start_date,NEW.end_date,NEW.id_proj,NEW.id_proj_round);
END;
$$
/* RQ_REL
 ######   #####     ######  ####### #       
 #     # #     #    #     # #       #       
 #     # #     #    #     # #       #       
 ######  #     #    ######  #####   #       
 #   #   #   # #    #   #   #       #       
 #    #  #    #     #    #  #       #       
 #     #  #### #    #     # ####### ####### 
                                            
*/
CREATE PROCEDURE `whedcapp`.`rq_rel_insert_or_update_check`(id_questionnaire_par INT, id_res_que_par INT)
BEGIN
    DECLARE no_of_arq_var INTEGER;
    DECLARE no_of_associable_questionnaires INTEGER;
    /* A questionnaire is only connected once to a project via one aim or research question */
    SELECT COUNT(DISTINCT `id_res_que`) INTO no_of_arq_var
        FROM `whedcapp`.`aim_or_research_question`
        JOIN `whedcapp`.`rq_rel` ON `rq_rel`.`id_res_que` = `aim_or_research_question`.`id_res_que`
        JOIN `whedcapp`.`questionnaire` ON `questionnaire`.`id_questionnaire` = `rq_rel`.`id_questionnaire`
        WHERE `id_res_que` <> id_res_que_par AND `id_questionnaire` = id_questionnaire_par; 
    IF no_of_arq_var > 1 THEN
        SIGNAL SQLSTATE '45017'
            SET MESSAGE_TEXT = 'An questionnaire can only belong to a project via one aim or research question';
    END IF;
    /* Check if questionnaire can be used in project. If and only if questionnaire manager is the project owner or
       share type is not private */
    SELECT COUNT(`id_questionnaire`) INTO no_of_associable_questionnaires
        FROM `whedcapp`.`questionnaire`
        WHERE 
                `id_questionnaire_sha_tp` IN     (SELECT `id_questionnaire_sha_tp`
                                                    FROM `wheedcap`.`questionnaire_share_type`
                                                    WHERE `questionnaire_sha_tp_text` IN ("public","site")
                                                )
            OR
                (
                    `id_questionnaire_sha_tp` IN     (SELECT `id_questionnaire_sha_tp`
                                                        FROM `whedcapp`.`questionnaire_share_type`
                                                        WHERE `questionnaire_sha_tp_text` = "private"
                                                    )
                AND
                    id_res_que_par IN     (SELECT `id_res_que`
                                            FROM `whedcapp`.`aim_or_research_question`
                                            WHERE `id_proj` IN     (SELECT `id_proj`
                                                                    FROM `whedcapp`.`acl` 
                                                                    WHERE `id_uid` IN     (SELECT `id_uid`
                                                                                            FROM `whedcapp`.`uq_rel`
                                                                                            WHERE `id_questionnaire` = id_questionnaire_par
                                                                                        )
                                                                )
                                        )
                );
        IF no_of_associable_questionnaires < 1 THEN
            SIGNAL SQLSTATE '45043'
                SET MESSAGE_TEXT = 'Questionnaire cannot be associated with project, since it is neither public nor owned by the project owner';
        END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`check_rq_rel_insert`
    BEFORE INSERT
    ON `whedcapp`.`rq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`rq_rel_insert_or_update_check`(NEW.id_questionnaire,NEW.id_res_que);
END;
$$
CREATE TRIGGER `whedcapp`.`rq_rel_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`rq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`rq_rel_insert_or_update_check`(NEW.id_questionnaire,NEW.id_res_que);
END;
$$
/* ALTERNATIVE
    #    #       ####### ####### ######  #     #    #    ####### ### #     # ####### 
   # #   #          #    #       #     # ##    #   # #      #     #  #     # #       
  #   #  #          #    #       #     # # #   #  #   #     #     #  #     # #       
 #     # #          #    #####   ######  #  #  # #     #    #     #  #     # #####   
 ####### #          #    #       #   #   #   # # #######    #     #   #   #  #       
 #     # #          #    #       #    #  #    ## #     #    #     #    # #   #       
 #     # #######    #    ####### #     # #     # #     #    #    ###    #    ####### 
                                                                                     
*/
CREATE PROCEDURE `whedcapp`.`alternative_insert_or_update_check`(id_quest_type_spec_par INTEGER)
BEGIN
    DECLARE no_of_correct_question_types_var INT;
    SELECT COUNT(*) INTO no_of_correct_question_types_var
        FROM `whedcapp`.`question_type` 
        WHERE 
                `id_quest_type` IN     (SELECT `id_quest_type` 
                                        FROM `whedcapp`.`question_type_specification` 
                                        WHERE `id_quest_type_spec` = id_quest_type_spec_par
                                    ) 
            AND 
                `quest_type` = "alternative";
    IF no_of_correct_question_types_var < 1 THEN
        SIGNAL SQLSTATE '45002'
            SET MESSAGE_TEXT = 'An alternative must belong to a question of type "alternative"';
    END IF;
    
END;
$$
CREATE FUNCTION `whedcapp`.`questionnaire_any_associated_questionnaire_is_locked`(id_quest_type_spec_par INTEGER) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_locked_associated_questionnaires INTEGER;
    SELECT COUNT(`id_questionnaire`) INTO no_of_locked_associated_questionnaires
        FROM `whedcapp`.`questionnaire`
        WHERE 
                `id_questionnaire` IN     (SELECT `id_questionnaire` 
                                            FROM `whedcapp`.`qq_rel`
                                            WHERE `id_quest` IN     (SELECT `id_quest`
                                                                        FROM `whedcapp`.`question`
                                                                        WHERE `id_quest_type_spec` = id_quest_type_spec_par
                                                                    )
                                        )
            AND
                `questionnaire_locked` = TRUE;
    RETURN no_of_locked_associated_questionnaire > 0;
END;
$$
CREATE TRIGGER `whedcapp`.`alternative_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`alternative` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`alternative_insert_or_update_check`(NEW.id_quest_type_spec);
END;
$$
CREATE TRIGGER `whedcapp`.`alternative_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`alternative` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`alternative_insert_or_update_check`(NEW.id_quest_type_spec);
END;
$$
/* ANSWER_SCALAR_RANGE
    #    #     #  #####  #     # ####### ######      #####   #####     #    #       ####### 
   # #   ##    # #     # #  #  # #       #     #    #     # #     #   # #   #       #       
  #   #  # #   # #       #  #  # #       #     #    #       #        #   #  #       #       
 #     # #  #  #  #####  #  #  # #####   ######      #####  #       #     # #       #####   
 ####### #   # #       # #  #  # #       #   #            # #       ####### #       #       
 #     # #    ## #     # #  #  # #       #    #     #     # #     # #     # #       #       
 #     # #     #  #####   ## ##  ####### #     #     #####   #####  #     # ####### ####### 
                                                                                            
 ######     #    #     #  #####  #######                                                    
 #     #   # #   ##    # #     # #                                                          
 #     #  #   #  # #   # #       #                                                          
 ######  #     # #  #  # #  #### #####                                                      
 #   #   ####### #   # # #     # #                                                          
 #    #  #     # #    ## #     # #                                                          
 #     # #     # #     #  #####  #######                                                    
                                                                                                                                                                                      
*/
CREATE PROCEDURE `whedcapp`.`question_answer_scalar_range_insert_or_update_check`(id_quest_type_spec_par INTEGER,quest_ans_rng_scl_min_par DOUBLE, quest_ans_rng_scl_max_par DOUBLE)
BEGIN
    DECLARE no_of_correct_question_types_var INT;
    SELECT COUNT(*) INTO no_of_correct_question_types_var
        FROM `whedcapp`.`question_type` 
        WHERE `id_quest_type` IN (SELECT `id_quest_type` FROM `whedcapp`.`question_type_specification` WHERE `id_quest_type_spec` = id_quest_type_spec_par) AND `quest_type` = "scalar";    
    IF no_of_correct_question_types_var < 1 THEN
        SIGNAL SQLSTATE '45004'
            SET MESSAGE_TEXT = 'An scalar range must belong to a question of type "scalar"';
    END IF;
    IF quest_ans_rng_scl_min_par>quest_ans_rng_scl_max_par THEN
        SIGNAL SQLSTATE '45003' 
            SET MESSAGE_TEXT=  'Violation, min value is larger than or equal max';
    END IF;
    IF `whedcapp`.`any_associated_questionnaire_is_locked`(id_quest_type_spec_par) THEN
        SIGNAL SQLSTATE '45025' 
            SET MESSAGE_TEXT = "Cannot insert, update or delete question, a questionnaire is locked for editing";
    END IF;
END;
$$

CREATE TRIGGER  `whedcapp`.`question_answer_scalar_range_insert_check`
    BEFORE INSERT    
    ON  `whedcapp`.`question_answer_scalar_range` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_answer_scalar_range_insert_or_update_check`(NEW.id_quest_type_spec, NEW.quest_ans_rng_scl_min, NEW.quest_ans_rng_scl_max);
END;
$$
CREATE TRIGGER  `whedcapp`.`question_answer_scalar_range_update_check`
    BEFORE UPDATE    
    ON  `whedcapp`.`question_answer_scalar_range` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_answer_scalar_range_insert_or_update_check`(NEW.id_quest_type_spec, NEW.quest_ans_rng_scl_min, NEW.quest_ans_rng_scl_max);
    IF NEW.id_quest_type_spec <> OLD.id_quest_type_spec THEN
        SIGNAL SQLSTATE '45041'
            SET MESSAGE_TEXT = 'Cannot change type specification identity of question answer scalar range';
    END IF;
END;
$$
CREATE TRIGGER  `whedcapp`.`question_answer_scalar_range_delete_check`
    BEFORE DELETE    
    ON  `whedcapp`.`question_answer_scalar_range` FOR EACH ROW
BEGIN
    IF `whedcapp`.`any_associated_questionnaire_is_locked`(OLD.id_quest_type_spec) THEN
        SIGNAL SQLSTATE '45025' 
            SET MESSAGE_TEXT = "Cannot insert, update or delete question, a questionnaire is locked for editing";
    END IF;
END;
$$
/* ANSWER_INTEGER_RANGE
    #    #     #  #####  #     # ####### ######     ### #     # ####### #######  #####  ####### ######  
   # #   ##    # #     # #  #  # #       #     #     #  ##    #    #    #       #     # #       #     # 
  #   #  # #   # #       #  #  # #       #     #     #  # #   #    #    #       #       #       #     # 
 #     # #  #  #  #####  #  #  # #####   ######      #  #  #  #    #    #####   #  #### #####   ######  
 ####### #   # #       # #  #  # #       #   #       #  #   # #    #    #       #     # #       #   #   
 #     # #    ## #     # #  #  # #       #    #      #  #    ##    #    #       #     # #       #    #  
 #     # #     #  #####   ## ##  ####### #     #    ### #     #    #    #######  #####  ####### #     # 
                                                                                                        
 ######     #    #     #  #####  #######                                                                
 #     #   # #   ##    # #     # #                                                                      
 #     #  #   #  # #   # #       #                                                                      
 ######  #     # #  #  # #  #### #####                                                                  
 #   #   ####### #   # # #     # #                                                                      
 #    #  #     # #    ## #     # #                                                                      
 #     # #     # #     #  #####  #######                                                                
                                                                                                        
*/
CREATE PROCEDURE `whedcapp`.`question_answer_integer_range_insert_or_update_check`(id_quest_type_spec_par INTEGER, quest_ans_rng_min_par INTEGER, quest_ans_rng_max_par INTEGER)
BEGIN
    DECLARE no_of_correct_question_types_var INT;
    SELECT COUNT(*) INTO no_of_correct_question_types_var
        FROM `whedcapp`.`question_type` 
        WHERE `id_quest_type` IN (SELECT `id_quest_type` FROM `whedcapp`.`question_type_specification` WHERE `id_quest_type_spec` = id_quest_type_spec_par) AND `quest_type` = "integer";    
    IF no_of_correct_question_types_var < 1 THEN
        SIGNAL SQLSTATE '45005'
            SET MESSAGE_TEXT = 'An integer range must belong to a question of type "integer"';
    END IF;
    IF quest_ans_rng_min_par>=NEW.quest_ans_rng_max_par THEN
        SIGNAL SQLSTATE '45006' 
            SET MESSAGE_TEXT=  'Violation, min value is larger than or equal max';
    END IF;
    IF `whedcapp`.`any_associated_questionnaire_is_locked`(id_quest_type_spec_par) THEN
        SIGNAL SQLSTATE '45025' 
            SET MESSAGE_TEXT = "Cannot insert, update or delete question, a questionnaire is locked for editing";
    END IF;
END;
$$
CREATE TRIGGER  `whedcapp`.`question_check_integer_range_insert_check`
    BEFORE INSERT    
    ON  `whedcapp`.`question_answer_integer_range` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_answer_integer_range_insert_or_update_check`(NEW.id_quest_type_spec, NEW.quest_ans_rng_min, NEW.quest_ans_rng_max);
END;
$$
CREATE TRIGGER  `whedcapp`.`question_answer_integer_range_update_check`
    BEFORE UPDATE
    ON  `whedcapp`.`question_answer_integer_range` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_answer_integer_range_insert_or_update_check`(NEW.id_quest_type_spec, NEW.quest_ans_rng_min, NEW.quest_ans_rng_max);
    IF NEW.id_quest_type_spec <> OLD.id_quest_type_spec THEN
        SIGNAL SQLSTATE '45042'
            SET MESSAGE_TEXT = 'Cannot change type specification identity of question answer integer range';
    END IF;
END;
$$
CREATE TRIGGER  `whedcapp`.`question_answer_integer_range_delete_check`
    BEFORE DELETE
    ON  `whedcapp`.`question_answer_integer_range` FOR EACH ROW
BEGIN
    IF `whedcapp`.`any_associated_questionnaire_is_locked`(OLD.id_quest_type_spec) THEN
        SIGNAL SQLSTATE '45025' 
            SET MESSAGE_TEXT = "Cannot insert, update or delete question, a questionnaire is locked for editing";
    END IF;
END;
$$
/* QUESTION_TYPE
  #####  #     # #######  #####  ####### ### ####### #     #         ####### #     # ######  ####### 
 #     # #     # #       #     #    #     #  #     # ##    #            #     #   #  #     # #       
 #     # #     # #       #          #     #  #     # # #   #            #      # #   #     # #       
 #     # #     # #####    #####     #     #  #     # #  #  #            #       #    ######  #####   
 #   # # #     # #             #    #     #  #     # #   # #            #       #    #       #       
 #    #  #     # #       #     #    #     #  #     # #    ##            #       #    #       #       
  #### #  #####  #######  #####     #    ### ####### #     #            #       #    #       ####### 
                                                             #######                                 
*/
CREATE TRIGGER `whedcapp`.`question_type_insert_check`
  BEFORE INSERT
  ON `whedcapp`.`question_type` FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45034'
    SET MESSAGE_TEXT='Question type cannot be changed';
END;                                                                
$$
CREATE TRIGGER `whedcapp`.`question_type_update_check`
  BEFORE UPDATE
  ON `whedcapp`.`question_type` FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45034'
    SET MESSAGE_TEXT='Question type cannot be changed';
END;                                                                
$$
CREATE TRIGGER `whedcapp`.`question_type_delete_check`
  BEFORE DELETE
  ON `whedcapp`.`question_type` FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45034'
    SET MESSAGE_TEXT='Question type cannot be changed';
END;                                                                
$$
/* QUESTION_TYPE_SPECIFICATION
  #####  #     # #######  #####  ####### ### ####### #     #         ####### #     # ######  #######         
 #     # #     # #       #     #    #     #  #     # ##    #            #     #   #  #     # #               
 #     # #     # #       #          #     #  #     # # #   #            #      # #   #     # #               
 #     # #     # #####    #####     #     #  #     # #  #  #            #       #    ######  #####           
 #   # # #     # #             #    #     #  #     # #   # #            #       #    #       #               
 #    #  #     # #       #     #    #     #  #     # #    ##            #       #    #       #               
  #### #  #####  #######  #####     #    ### ####### #     #            #       #    #       #######         
                                                             #######                                 ####### 
  #####  ######  #######  #####  ### ####### ###  #####     #    ####### ### ####### #     #                 
 #     # #     # #       #     #  #  #        #  #     #   # #      #     #  #     # ##    #                 
 #       #     # #       #        #  #        #  #        #   #     #     #  #     # # #   #                 
  #####  ######  #####   #        #  #####    #  #       #     #    #     #  #     # #  #  #                 
       # #       #       #        #  #        #  #       #######    #     #  #     # #   # #                 
 #     # #       #       #     #  #  #        #  #     # #     #    #     #  #     # #    ##                 
  #####  #       #######  #####  ### #       ###  #####  #     #    #    ### ####### #     #                 
                                                                                                             
*/
CREATE TRIGGER `whedcapp`.`question_type_specification_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`question_type_specification` FOR EACH ROW
BEGIN
    DECLARE no_of_questions_associated_with_question_type_spec INTEGER;
    IF OLD.quest_type <> NEW.quest_type THEN
        SELECT COUNT(DISTINCT `id_quest`) INTO no_of_questions_associated_with_question_type_spec
            FROM `whedcapp`.`question`
            WHERE `id_quest_type_spec` = NEW.id_quest_type_spec;
        IF no_of_questions_associated_with_question_type_spec > 0 THEN
            SIGNAL SQLSTATE '45039'
                SET MESSAGE_TEXT = 'Cannot update or delete question type of the question type specification since there are questions associated with the question type specification';
        END IF;
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`question_type_specification_delete_check`
    BEFORE DELETE
    ON `whedcapp`.`question_type_specification` FOR EACH ROW
BEGIN
    DECLARE no_of_questions_associated_with_question_type_spec INTEGER;
    SELECT COUNT(DISTINCT `id_quest`) INTO no_of_questions_associated_with_question_type_spec
        FROM `whedcapp`.`question`
        WHERE `id_quest_type_spec` = NEW.id_quest_type_spec;
    IF no_of_questions_associated_with_question_type_spec > 0 THEN
        SIGNAL SQLSTATE '45039'
            SET MESSAGE_TEXT = 'Cannot update or delete question type of the question type specification since there are questions associated with the question type specification';
    END IF;
END;
$$
/* QUESTION_ANSWER_INTEGER_RANGE
*/
$$
/* QUESTION_ANSWER_SCALAR_RANGE
*/
$$
/* QUESTION
  #####  #     # #######  #####  ####### ### ####### #     # 
 #     # #     # #       #     #    #     #  #     # ##    # 
 #     # #     # #       #          #     #  #     # # #   # 
 #     # #     # #####    #####     #     #  #     # #  #  # 
 #   # # #     # #             #    #     #  #     # #   # # 
 #    #  #     # #       #     #    #     #  #     # #    ## 
  #### #  #####  #######  #####     #    ### ####### #     # 
                                                             
*/
CREATE PROCEDURE `whedcapp`.`question_insert_or_update_check`    (    
                                                                in id_quest_par INTEGER, 
                                                                in id_quest_type_spec_par INTEGER,
                                                                in quest_key VARCHAR(32)
                                                                )
BEGIN
    DECLARE no_of_locked_questionnaires_var INTEGER;
    /* Check if questionnaire is not locked */
    SELECT COUNT(`id_questionnaire`) INTO no_of_locked_questionnaires_var
        FROM `whedcapp`.`questionnaire`
        WHERE `id_questionnaire` IN     (SELECT `id_questionnaire`
                                        FROM `whedcapp`.`qq_rel`
                                        WHERE `id_quest` = id_quest_par);
    IF no_of_locked_questionnaires_var > 0 THEN
        SIGNAL SQLSTATE '45033' 
            SET MESSAGE_TEXT = "Questionnaire is locked, question cannot be modified";
    END IF;
    
END;
$$
CREATE TRIGGER `whedcapp`.`question_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`question` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_insert_or_update_check`(NEW.id_quest, NEW.id_quest_type_spec, NEW.quest_key);
END;
$$
CREATE TRIGGER `whedcapp`.`question_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`question` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_insert_or_update_check`(NEW.id_quest, NEW.id_quest_type_spec, NEW.quest_key);
END;
$$
CREATE TRIGGER `whedcapp`.`question_delete_check`
    BEFORE DELETE
    ON `whedcapp`.`question` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_insert_or_update_check`(OLD.id_quest, OLD.id_quest_type_spec, OLD.quest_key);
END;
$$
/* QQ_REL
  #####   #####          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 #     # #     #         ######  #####   #       
 #   # # #   # #         #   #   #       #       
 #    #  #    #          #    #  #       #       
  #### #  #### #         #     # ####### ####### 
                 #######                         
*/
CREATE FUNCTION `whedcapp`.`qq_rel_count_no_of_questions_of_type`( quest_tp_par VARCHAR(32)) RETURNS INTEGER DETERMINISTIC
BEGIN
    DECLARE no_of_questions_of_type INTEGER;
    SELECT COUNT(`id_question`) INTO no_of_questions_of_type
        FROM `whedcapp`.`qq_rel`
        WHERE 
                `id_questionnaire` = id_questionnaire_par
            AND
                `id_quest` IN     (SELECT `id_quest`
                                    FROM `whedcapp`.`question`
                                    WHERE `id_quest_type_spec` IN    (SELECT `id_quest_type_spec`
                                                                        FROM `whedcapp`.`question_type_specification`
                                                                        WHERE `id_quest_type` IN     (SELECT `id_quest_type`
                                                                                                        FROM `whedcapp`.`question_type`
                                                                                                        WHERE `quest_type` = quest_tp_par
                                                                                                    )
                                                                    )
                                );
    RETURN no_of_questions_of_type;
END;
$$
CREATE PROCEDURE `whedcapp`.`qq_rel_insert_or_update_check`     (
                                                                IN id_qq_rel_par INTEGER,
                                                                IN id_questionnaire_par INTEGER,
                                                                IN id_quest_par INTEGER,
                                                                IN qq_rel_order_par INTEGER
                                                                )
BEGIN
    DECLARE no_of_locked_questionnaires_var INTEGER;
    DECLARE is_graphable_var BOOLEAN;
    DECLARE no_of_questions_that_are_of_wrong_type_var INTEGER;
    DECLARE question_is_of_non_graphable_type BOOLEAN;
    DECLARE no_of_alternative_questions_not_zero_var BOOLEAN;
    DECLARE no_of_scalar_questions_not_zero_var BOOLEAN;
    DECLARE no_of_integer_questions_not_zero_var BOOLEAN;
    DECLARE no_of_alternative_of_new_var INTEGER;
    DECLARE no_of_alternative_of_existing_var INTEGER;
    DECLARE no_of_questions INTEGER;
    DECLARE no_of_questions_of_type_spec INTEGER;
    SELECT COUNT(`id_questionnaire`) INTO no_of_locked_questionnaires_var
        FROM `whedcapp`.`questionnaire`
        WHERE 
                `id_questionnaire` = id_questionnaire_par
            AND
                `questionnaire_locked` = TRUE;
    IF no_of_locked_questionnaire_var > 0 THEN
        SIGNAL SQLSTATE '45035' 
            SET MESSAGE_TEXT = "Questionnaire is locked, question/questionnaire coupling cannot be inserted, updated or deleted";
    END IF;
    SELECT `questionnaire_graphable` INTO is_graphable_var
        FROM `whedcapp`.`questionnaire`
        WHERE `id_questionnaire` = id_questionnaire_par;
    IF is_graphable_var THEN
        /* Check if same type, same range */
        /* Check if there are any text-based questions in the questionnaire */
        SET no_of_questions_that_are_of_wrong_type_var = `whedcapp`.`qq_rel_count_no_of_questions_of_type`("text");
        IF no_of_questions_that_are_of_wrong_type_var > 0 THEN
            SIGNAL SQLSTATE '45036'
                SET MESSAGE_TEXT = 'Graphable questionnaire cannot contain text questions.';
        END IF;
        /* Check new question, if must be graphable */
        SELECT COUNT(`id_quest_type`) > 0 INTO question_is_of_non_graphable_type
            FROM `whedcapp`.`question_type`
            WHERE 
                    `id_quest_type` IN     (SELECT `id_quest_type`
                                            FROM `whedcapp`.`question_type_spec`
                                            WHERE `id_quest_type_spec` IN    (SELECT `id_quest_type_spec`
                                                                                FROM `whedcapp`.`question`
                                                                                WHERE `id_quest` = id_quest_par
                                                                            )
                                        )
                AND
                    `quest_type` = "text"; /* Extend here with more non-graphable types */
        IF question_is_of_non_graphable_type_var THEN
            SIGNAL SQLSTATE '45036'
                SET MESSAGE_TEXT = 'Graphable questionnaire cannot contain text questions.';
        END IF;
        SET no_of_alternative_questions_not_zero_var = `whedcapp`.`qq_rel_count_no_of_questions_of_type`("alternative")>0;
        SET no_of_scalar_questions_not_zero_var = `whedcapp`.`qq_rel_count_no_of_questions_of_type`("scalar")>0;
        SET no_of_integer_questions_not_zero_var = `whedcapp`.`qq_rel_count_no_of_questions_of_type`("integer")>0;
        IF NOT (no_of_alternative_questions_not_zero_var XOR no_of_alternative_questions_not_zero_var XOR no_of_integer_questions_not_zero_var) OR (no_of_alternative_questions_not_zero_var AND no_of_alternative_questions_not_zero_var AND no_of_integer_questions_not_zero_var) THEN
            SIGNAL SQLSTATE '45037'
                SET MESSAGE_TEXT = 'All questions in a graphable questionnaire must be of the same type.';
        END IF;
        SELECT COUNT(`id_qq_rel`) INTO no_of_questions
            FROM `whedcapp`.`qq_rel`
            WHERE `id_questionnaire` = id_questionnaire_par;
        SELECT COUNT(`id_qq_rel`) INTO no_of_questions_of_type_spec
            FROM `whedcapp`.`qq_rel`
            WHERE 
                    `id_questionnaire` = id_questionnaire_par
                AND
                    `id_quest` IN     (SELECT `id_quest`
                                        FROM `whedcapp`.`question`
                                        WHERE `id_quest_type_spec` IN     (SELECT `id_quest_type_spec`
                                                                            FROM `whedcapp`.`question`
                                                                            WHERE `id_quest` = id_quest_par
                                                                        )
                                    );
        IF no_of_questions <> no_of_questions_of_type_spec THEN
            SIGNAL SQLSTATE '45040'
                SET MESSAGE_TEXT = 'All questions of a graphable questionnaire must be of the same question type specification';
        END IF;
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`qq_rel_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`qq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`qq_rel_insert_or_update_check`(NEW.id_qq_rel, NEW.id_questionnaire, NEW.id_quest,NEW.qq_rel_order);
END;
$$
CREATE TRIGGER `whedcapp`.`qq_rel_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`qq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_insert_or_update_check`(NEW.id_qq_rel, NEW.id_questionnaire, NEW.id_quest,NEW.qq_rel_order);
END;
$$
CREATE TRIGGER `whedcapp`.`qq_rel_delete_check`
    BEFORE DELETE
    ON `whedcapp`.`qq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`question_insert_or_update_check`(OLD.id_qq_rel, OLD.id_questionnaire, OLD.id_quest,OLD.qq_rel_order);
END;

$$
/* PP_REL
 ######  ######     ######  ####### #       
 #     # #     #    #     # #       #       
 #     # #     #    #     # #       #       
 ######  ######     ######  #####   #       
 #       #          #   #   #       #       
 #       #          #    #  #       #       
 #       #          #     # ####### ####### 
                                            
*/

CREATE TRIGGER `whedcapp`.`pp_rel_check_acl`
    BEFORE INSERT 
    ON `whedcapp`.`pp_rel` FOR EACH ROW
BEGIN
    DECLARE no_of_acl_records_var INT;
    DECLARE no_of_incorrect_date_var INT;
    /* check if access to project is participant, if not disallow insertion */
    SELECT COUNT(*) INTO no_of_acl_records_var
        FROM `whedcapp`.`acl`
        WHERE `acl`.`id_proj` IN 
                (SELECT `id_proj`
                    FROM `whedcapp`.`project_round` 
                    WHERE `id_proj_round` = NEW.`id_proj_round`)
            AND `acl`.`id_uid` IN 
                (SELECT `id_uid`
                    FROM `whedcapp`.`participant`
                    WHERE `id_part` = NEW.`id_part`)
            AND `acl`.`id_acl_level` IN 
                (SELECT `id_acl_level` 
                    FROM `whedcapp`.`acl_level` 
                    WHERE `acl_level_key` = "participant");
    IF no_of_acl_records_var < 1 THEN
        SIGNAL SQLSTATE '45007'
            SET MESSAGE_TEXT = 'The given uid does not have the right to be a participant of this project';
    END IF;
    IF no_of_acl_records_var > 1 THEN
        SIGNAL SQLSTATE '45008'
            SET MESSAGE_TEXT = 'Cosmic storm approaching, several records in the acl';
    END IF;
    /* check that the dates of participant is within the dates of the project round */
    SELECT COUNT(*) INTO no_of_incorrect_date_var
        FROM `whedcapp`.`project_round`
        WHERE `id_proj_round` = NEW.`id_proj_round` AND (`project_round`.`start_date` > NEW.`start_date` OR `project_round`.`end_date` < NEW.`end_date`);
    IF no_of_incorrect_date_var > 0 THEN
        SIGNAL SQLSTATE '45009'
            SET MESSAGE_TEXT = 'Incorrect date interval of participation in project round';
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`pp_rel_check_acl_update`
    BEFORE UPDATE
    ON `whedcapp`.`pp_rel` FOR EACH ROW
BEGIN
    DECLARE no_of_acl_records_var INT;
    DECLARE no_of_correct_date_var INT;
    /* check if access to project is participant, if not disallow insertion */
    IF OLD.`id_proj_round` <> NEW.`id_proj_round` OR OLD.`id_part` <> NEW.`id_part` THEN
        SIGNAL SQLSTATE '45010'
            SET MESSAGE_TEXT = 'You cannot update participant or project round in an existing pp_rel';
    END IF;
    /* check that the dates of participant is within the dates of the project round */
    SELECT COUNT(*) INTO no_of_correct_date_var
        FROM `whedcapp`.`project_round`
        WHERE `id_proj_round` = NEW.`id_proj_round` AND `project_round`.`start_date` <= NEW.`start_date` AND `project_round`.`end_date` >= NEW.`end_date`;
    IF no_of_correct_date_var < 1 THEN
        SIGNAL SQLSTATE '45009'
            SET MESSAGE_TEXT = 'Incorrect date interval of participation in project round';
    END IF;
END;
$$
/* ANSWER
    #    #     #  #####  #     # ####### ######  
   # #   ##    # #     # #  #  # #       #     # 
  #   #  # #   # #       #  #  # #       #     # 
 #     # #  #  #  #####  #  #  # #####   ######  
 ####### #   # #       # #  #  # #       #   #   
 #     # #    ## #     # #  #  # #       #    #  
 #     # #     #  #####   ## ##  ####### #     # 
                                                 
*/
CREATE PROCEDURE `whedcapp`.`answer_insert_or_update_check`(ans_ts_par DATETIME, id_ppsa_rqq_a_rel_par INT) 
BEGIN
    DECLARE start_date_var,end_date_var DATETIME;
    
    /* Get the end date from the project round */
    SELECT `end_date` INTO end_date_var
        FROM `whedcapp`.`project_round`
        WHERE `id_proj_round` IN (SELECT `id_proj_round`
                                    FROM `whedcapp`.`pp_rel`
                                    WHERE `id_pp_rel` IN (SELECT `id_pp_rel`
                                                            FROM `whedcapp`.`pp_rel_s_rel`
                                                            WHERE `id_pp_rel_s_rel` IN (SELECT `id_pp_rel_s_rel`
                                                                                            FROM `whedcapp`.`ppsa_rqq_a_rel`
                                                                                            WHERE `id_ppsa_rqq_a_rel` = id_ppsa_rqq_a_rel_par
                                                                                        )
                                                        )
                                );
                        
    SELECT `sess_start_time` INTO start_date_var
        FROM `whedcapp`.`sampling_session`
        WHERE `id_samp_sess` IN (SELECT `id_samp_sess`
                                    FROM `whedcapp`.`pp_rel_s_rel`
                                    WHERE `id_pp_rel_s_rel` IN (SELECT `id_pp_rel_s_rel`
                                                                    FROM `whedcapp`.`ppsa_rqq_a_rel`
                                                                    WHERE `id_ppsa_rqq_a_rel` = id_ppsa_rqq_a_rel_par
                                                                )
                                                        
                                );
    IF ans_ts_par < start_date_var OR ans_ts_par > end_date_var THEN
        SIGNAL SQLSTATE '45014'
            SET MESSAGE_TEXT = "Answer outside sampling session start and project round end boundaries";
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`answer_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`answer` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`answer_insert_or_update_check`(NEW.ans_ts,NEW.id_ppsa_rqq_a_rel);
END;
$$
CREATE TRIGGER `whedcapp`.`answer_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`answer` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`answer_insert_or_update_check`(NEW.ans_ts,NEW.id_ppsa_rqq_a_rel);
END;
$$
/* ANSWER_CONTENT
    #    #     #  #####  #     # ####### ######           #####  ####### #     # ####### ####### #     # ####### 
   # #   ##    # #     # #  #  # #       #     #         #     # #     # ##    #    #    #       ##    #    #    
  #   #  # #   # #       #  #  # #       #     #         #       #     # # #   #    #    #       # #   #    #    
 #     # #  #  #  #####  #  #  # #####   ######          #       #     # #  #  #    #    #####   #  #  #    #    
 ####### #   # #       # #  #  # #       #   #           #       #     # #   # #    #    #       #   # #    #    
 #     # #    ## #     # #  #  # #       #    #          #     # #     # #    ##    #    #       #    ##    #    
 #     # #     #  #####   ## ##  ####### #     #          #####  ####### #     #    #    ####### #     #    #    
                                                 #######                                                         
*/
CREATE PROCEDURE `whedcapp`.`answer_content_insert_or_update_check`(ans_text_part VARCHAR(2048), ans_integer_par INTEGER, ans_scalar_par DOUBLE, id_alt_par INTEGER, id_loc_par INTEGER)
BEGIN
    DECLARE no_of_set_parts_var INT;
    DECLARE quest_type_var VARCHAR(16);
    DECLARE id_quest_var INT;
    DECLARE id_rqq_rel_var INT;
    DECLARE no_of_correct_alternatives_var INT;
    DECLARE no_of_answer_content_not_in_the_same_loc_var INT;
    
    /* Check number of parts of answer content that has been inserted in the same row, it should be 1 and 1 only */
    DROP TEMPORARY TABLE IF EXISTS c;
    CREATE TEMPORARY TABLE c(
        id_c INTEGER NOT NULL AUTO_INCREMENT,
        cond BOOLEAN NOT NULL);
    INSERT INTO c(cond)
        SELECT ans_text_par IS NULL;
    INSERT INTO c(cond)
        SELECT ans_integer_par IS NULL;
    INSERT INTO c(cond)
        SELECT ans_scalar_par IS NULL;
    INSERT INTO c(cond)
        SELECT id_alt_par IS NULL;
    SELECT COUNT(*) INTO no_of_set_parts_var FROM c WHERE cond = TRUE;
    IF no_of_set_parts > 1 THEN
        DROP TEMPORARY TABLE c;
        SIGNAL SQLSTATE '45011'
            SET MESSAGE_TEXT = "Cannot set more than one part at a time of answer_context";
    END IF;
    IF no_of_set_parts < 1 THEN
        DROP TEMPORARY TABLE c;
        SIGNAL SQLSTATE '45015'
            SET MESSAGE_TEXT = "One part in answer_context must be set";
    END IF;
    DROP TEMPORARY TABLE c;
    
    /* Check that the answer follows the type of the question */
    SELECT DISTINCT `id_rqq_rel` INTO id_rqq_rel_var
        FROM `whedcapp`.`ppsa_rqq_a_rel`
        WHERE `id_ppsa_rqq_a_rel` IN (SELECT DISTINCT `id_ppsa_rqq_a_rel` 
                                        FROM `whedcapp`.`answer`
                                        WHERE `id_ans` = id_ans_par
                                    );
    SELECT DISTINCT id_quest INTO id_quest_var
        FROM qq_rel
        WHERE id_qq_rel IN (SELECT DISTINCT id_qq_rel
                                FROM rqq_rel
                                WHERE id_rqq_rel = id_rqq_rel_var
                            );
    SELECT `quest_type` INTO quest_type_var
        FROM `whedcapp`.`question_type`
        WHERE `id_quest_type` IN (SELECT DISTINCT `id_quest_type` 
                                    FROM `whedcapp`.`question_type_specification`
                                    WHERE `id_quest_type_spec` IN     (SELECT `id_quest_type_spec`
                                                                        FROM `whedcapp`.`question`
                                                                        WHERE `id_quest` = id_quest_var
                                                                )
                                );
    IF         (quest_type = "scalar" AND ans_scalar_par IS NULL) 
        OR 
            (quest_type = "integer" AND ans_integer_par IS NULL)
        OR
            (quest_type = "text" AND ans_text_par IS NULL)
        OR
            (quest_type = "alternative" AND id_alt_par IS NULL)
                                                                    THEN
        SIGNAL SQLSTATE '45012'
            SET MESSAGE_TEXT = "Proper part of answer_content is not set";
    END IF;
    /* Check alternative */
    IF quest_type = "alternative" THEN
        SELECT COUNT(*) INTO no_of_correct_alternatives_var FROM alternative WHERE id_alt = id_alt_par AND id_quest = id_quest_var;
        IF no_of_correct_alternative_var < 1 THEN
            SIGNAL SQLSTATE '45013'
                SET MESSAGE_TEXT = "Incorrect alternative for answer";
        END IF;
    END IF;
    /* Check that one and only one language has been used to respond to the question */
    SELECT COUNT(*) INTO no_of_answer_content_not_in_the_same_loc_var
        FROM `whedcapp`.`answer_content`
        WHERE `id_ans` = id_ans_par AND `id_loc` <> id_loc_par;
    IF no_of_answer_content_not_in_the_same_loc_var > 0 THEN
            SIGNAL SQLSTATE '45016'
                SET MESSAGE_TEXT = "Answers can only be given in one language only";
    END IF;
END;
$$
CREATE TRIGGER `whedcapp`.`answer_content_insert_check`
    BEFORE INSERT 
    ON `whedcapp`.`answer_content` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`answer_content_insert_or_update_check`(NEW.ans_text, NEW.ans_integer, NEW.ans_scalar, NEW.id_alt, NEW.id_loc);
END;
$$
CREATE TRIGGER `whedcapp`.`answer_content_update_check`
    BEFORE UPDATE 
    ON `whedcapp`.`answer_content` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`answer_content_insert_or_update_check`(NEW.ans_text, NEW.ans_integer, NEW.ans_scalar, NEW.id_alt, NEW.id_loc);
END;
$$
/* QUESTIONNAIRE
  #####  #     # #######  #####  ####### ### ####### #     # #     #    #    ### ######  ####### 
 #     # #     # #       #     #    #     #  #     # ##    # ##    #   # #    #  #     # #       
 #     # #     # #       #          #     #  #     # # #   # # #   #  #   #   #  #     # #       
 #     # #     # #####    #####     #     #  #     # #  #  # #  #  # #     #  #  ######  #####   
 #   # # #     # #             #    #     #  #     # #   # # #   # # #######  #  #   #   #       
 #    #  #     # #       #     #    #     #  #     # #    ## #    ## #     #  #  #    #  #       
  #### #  #####  #######  #####     #    ### ####### #     # #     # #     # ### #     # ####### 
                                                                                                 
*/
CREATE PROCEDURE `whedcapp`.`questionnaire_lock_check`(
                                                        id_questionnaire_par INTEGER, 
                                                        id_questionnaire_sha_tp_par INTEGER,
                                                        questionnaire_locked_par BOOLEAN
                                                        )
BEGIN
    DECLARE no_of_answers_associated_with_questionnaire INTEGER;
    IF questionnaire_locked_par THEN
        SELECT COUNT(`id_ans`) INTO no_of_answers_associated_with_questionnaire
            FROM `whedcapp`.`answer`
            WHERE `id_ppsa_rqq_a_rel` IN     (SELECT `id_ppsa_rqq_a_rel`
                                            FROM `whedcapp`.`ppsa_rqq_a_rel`
                                            WHERE `id_rqq_rel` IN     (SELECT `id_rqq_rel`
                                                                    FROM `whedcapp`.`rqq_rel`
                                                                    WHERE `id_qq_rel` IN     (SELECT `id_qq_rel`
                                                                                            FROM `whedcapp`.`qq_rel`
                                                                                            WHERE `id_questionnaire` = id_questionnaire_par
                                                                                            )
                                                                    )
                                            );
        IF no_of_answers_associated_with_questionnaire > 0 THEN
            SIGNAL SQLSTATE '45026'
                SET MESSAGE_TEXT = 'Cannot unlock a questionnaire with answers. ';
        END IF;
    END IF;

                                    
END;
$$
CREATE TRIGGER `whedcapp`.`questionnaire_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`questionnaire` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`questionnaire_lock_check`(NEW.id_questionnaire,NEW.questionnaire_locked);
END;
$$
CREATE TRIGGER `whedcapp`.`questionnaire_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`questionnaire` FOR EACH ROW
BEGIN
    
    CALL `whedcapp`.`questionnaire_lock_check`(NEW.id_questionnaire,NEW.questionnaire_locked);
    IF OLD.questionnaire_locked THEN
        IF NEW.questionnaire_is_longitudinal <> OLD.questionnaire_is_longitudinal THEN
            SIGNAL SQLSTATE '45027'
                SET MESSAGE_TEXT = 'Cannot change longitudinal when questionnaire is locked.';
        END IF;
        IF NEW.questionnaire_allow_comments <> OLD.questionnaire_allow_comments THEN
            SIGNAL SQLSTATE '45028'
                SET MESSAGE_TEXT = 'Cannot change "allow_comments" when questionnaire is locked.';
        END IF;
    END IF;
END;
$$
/* UQ_REL
 #     #  #####          ######  ####### #       
 #     # #     #         #     # #       #       
 #     # #     #         #     # #       #       
 #     # #     #         ######  #####   #       
 #     # #   # #         #   #   #       #       
 #     # #    #          #    #  #       #       
  #####   #### #         #     # ####### ####### 
                 #######                         
*/
CREATE PROCEDURE `whedcapp`.`uq_rel_insert_or_update_check`(id_uid_par INTEGER,id_questionnaire_par INTEGER)
BEGIN
    DECLARE no_of_correct_acl INTEGER;
    /* add checks */
    SELECT COUNT(DISTINCT `id_uid`) INTO no_of_correct_acl
        FROM `whedcapp`.`uid`
        WHERE 
                `id_uid` = id_uid_par
            AND
                `uid_questionnaire_maintainer`;
    IF no_of_correct_acl < 1 THEN
        SIGNAL SQLSTATE '45018' 
            SET MESSAGE_TEXT = 'User is not a questionnaire maintainer';
    END IF;
        
END;
$$
CREATE TRIGGER `whedcapp`.`uq_rel_update_check`
    BEFORE UPDATE 
    ON `whedcapp`.`uq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`uq_rel_insert_or_update_check`(NEW.id_uid, NEW.id_questionnaire);
END;
$$
CREATE TRIGGER `whedcapp`.`uq_rel_insert_check`
    BEFORE INSERT 
    ON `whedcapp`.`uq_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`uq_rel_insert_or_update_check`(NEW.id_uid, NEW.id_questionnaire);
END;
$$
/* SPP_REL
  #####  ######  ######          ######  ####### #       
 #     # #     # #     #         #     # #       #       
 #       #     # #     #         #     # #       #       
  #####  ######  ######          ######  #####   #       
       # #       #               #   #   #       #       
 #     # #       #               #    #  #       #       
  #####  #       #               #     # ####### ####### 
                         #######                         
*/
CREATE PROCEDURE `whedcapp`.`spp_rel_insert_or_update_check`(id_uid_par INTEGER, id_part_par INTEGER, id_proj_round_par INTEGER, start_date_par DATETIME, end_date_par DATETIME) 
BEGIN
    DECLARE no_of_correct_acl_var INTEGER;
    DECLARE no_of_correct_part_in_proj_round_var INTEGER;
    DECLARE no_of_correct_proj_round_var INTEGER;
    
    IF start_date_par IS NULL THEN
        SIGNAL SQLSTATE '45024' 
            SET MESSAGE_TEXT = 'Incorrect supporting interval, start is not set';
    END IF;
    IF end_date_par IS NOT NULL AND start_date_par >= end_date_par THEN
        SIGNAL SQLSTATE '45023' 
            SET MESSAGE_TEXT = 'Incorrect supporting interval, start is later than end';
    END IF;
    
    /* Check that uid is a supporter in the project round */
    SELECT COUNT(DISTINCT `id_acl`) INTO no_of_correct_acl_var
        FROM `whedcapp`.`acl`
        JOIN `whedcapp`.`project` ON `project`.`id_proj` = `acl`.`id_proj`
        JOIN `whedcapp`.`project_round` ON `project_round`.`id_proj` = `project`.`id_proj`
        WHERE
                `id_proj_round` = id_proj_round_par
            AND
                `id_uid` = id_uid_par
            AND 
                `id_acl_level` IN     (SELECT `id_acl_level`
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` = "supporter");
    IF no_of_correct_acl_var < 1 THEN
        SIGNAL SQLSTATE '45019' 
            SET MESSAGE_TEXT = 'User is not a supporter in the project round';
    END IF;
    
    /* Check that participant is in project round */
    SELECT COUNT(DISTINCT `id_pp_rel`) INTO no_of_correct_part_in_proj_round_var
        FROM `whedcapp`.`pp_rel`
        WHERE
                `id_part` = id_part_par
            AND
                `id_proj_round` = id_proj_round_par
            AND
                now() > `start_date`
            AND
                (`end_date` IS NULL OR (`end_date` IS NOT NULL AND now() < `end_date`));
    IF no_of_correct_part_in_proj_round_var < 1 THEN
        SIGNAL SQLSTATE '45020'
            SET MESSAGE_TEXT = 'Participant is not part of the project round or the participant has dropped out';
    END IF;
    IF end_date_par IS NOT NULL and now() > end_date_par THEN
        SIGNAL SQLSTATE '45021'
            SET MESSAGE_TEXT = 'Supporting interval expired';
    END IF;
    /* Check supporter interval vis a vi project round, supporter interval must overlap the start and cannot overlap the end */
    SELECT COUNT(DISTINCT `id_proj_round`) INTO no_of_correct_proj_round_var
        FROM `whedcapp`.`proj_round`
        WHERE 
                `id_proj_round` = id_proj_round_par
            AND
                (`end_date` IS NULL OR (`end_date` IS NOT NULL AND `end_date` >= end_date_par));
    IF no_of_correct_proj_round_var < 1 THEN
        SIGNAL SQLSTATE '45022'
            SET MESSAGE_TEXT = 'Supporting interval does not match project round interval';
    END IF;

END;
$$
CREATE TRIGGER `whedcapp`.`spp_rel_insert_check`
    BEFORE INSERT
    ON `whedcapp`.`spp_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`spp_rel_insert_or_update_check`(NEW.id_uid, NEW.id_part, NEW.id_proj_round, NEW.spp_rel_start_date, NEW.spp_rel_end_date);
END;
$$
CREATE TRIGGER `whedcapp`.`spp_rel_update_check`
    BEFORE UPDATE
    ON `whedcapp`.`spp_rel` FOR EACH ROW
BEGIN
    CALL `whedcapp`.`spp_rel_insert_or_update_check`(NEW.id_uid, NEW.id_part, NEW.id_proj_round, NEW.spp_rel_start_date, NEW.spp_rel_end_date);
END;
$$
/* UID
 #     # ### ######  
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
 #     #  #  #     # 
  #####  ### ######  
*/
$$

DELIMITER ;


