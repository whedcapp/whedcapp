/*-
    This file is part of Whedcapp - Well-being Health Environment Data Collection App - to collect self-evaluated data for research purpose
    Copyright (C) 2020-2021  Jonas Mellin, Catharina Gillsjö

    Whedcapp is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Whedcapp is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    */


DELIMITER $$
CREATE FUNCTION `whedcapp`.`check_acl`(
                                        id_uid_par INT, 
				        id_proj_par INT,
					is_superuser_par BOOLEAN, 
					is_personal_data_controller_par BOOLEAN,
                                        is_whedcapp_administrator_par BOOLEAN,
                                        is_project_owner_par BOOLEAN,
                                        is_researcher_par BOOLEAN,
                                        is_supporter_par BOOLEAN,
                                        is_participant_par BOOLEAN,
                                        is_questionnaire_manager_par BOOLEAN) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE acl_check_var INT;
    IF is_superuser_par OR is_personal_data_controller_par OR is_whedcapp_administrator_par THEN
		SELECT COUNT(`id_uid`) INTO acl_check_var
			FROM `whedcapp`.`uid` 
                             WHERE `id_uid` = `id_uid_par` 
				AND (
						(`uid_is_superuser` AND is_superuser_par)
					OR 
						(`uid_is_whedcapp_administrator` AND is_whedcapp_administrator_par) 
					OR 
						(`uid_is_personal_data_controller` AND is_personal_data_controller_par)
					);
		IF acl_check_var > 0 THEN
			RETURN TRUE;
		END IF;
    END IF;
    SELECT COUNT(DISTINCT `id_acl`) INTO acl_check_var
		FROM `whedcapp`.`acl`
                     WHERE 
				`id_proj`= id_proj_par AND `id_uid` = id_uid_par 
			AND (
					(is_superuser_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "superuser"))
				OR
					(is_personal_data_controller_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "personal_data_controller"))
				OR
					(is_whedcapp_administrator_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "whedcapp_administrator"))
				OR
					(is_project_owner_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "project_owneer"))
				OR
					(is_researcher_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "researcher"))
				OR
					(is_supporter_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "supporter"))
				OR
					(is_participant_par AND `id_acl_level` IN (SELECT `id_acl_level` FROM `whedcapp`.`acl_level` WHERE `acl_level_key` = "participant"))
        );
	RETURN acl_check_var>0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_administrator_rights`(id_uid_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_admin_rights INT;
    SELECT COUNT(`id_uid`) INTO no_of_admin_rights
        FROM `whedcapp`.`uid`
        WHERE ( `uid_is_superuser` OR `uid_is_whedcapp_administrator`) AND `id_uid` = id_uid_par;
    RETURN no_of_admin_rights>0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_write_access_rights_self`(calling_id_uid_par INT, context_id_proj_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_project_owner INT;
    SELECT COUNT(`id_uid`) INTO no_of_project_owner
        FROM `whedcapp`.`acl`
        WHERE
                `id_uid` = calling_id_uid_par
            AND
                `id_acl_level` IN   (SELECT `id_acl_level`
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` = "project_owner"
                                    )
            AND
                `id_proj` = context_id_proj_par;
    RETURN no_of_project_owner > 0;
               
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_write_access_rights_other`(calling_id_uid_par INT, context_id_proj_par INT,other_uid_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    IF NOT `whedcapp`.`check_project_write_access_rights_self`(other_uid_par,context_id_proj_par) THEN
        RETURN FALSE;
    END IF;
    IF `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_read_access_rights_self`(calling_id_uid_par INT, context_id_proj_par INT,time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_uid INT;
    IF `whedcapp`.`check_project_write_access_rights_self`(calling_id_uid_par,context_id_proj_par,time_par) THEN
        RETURN TRUE;
    END IF;
    SELECT COUNT(`id_uid`) INTO no_of_uid
        FROM `whedcapp`.`acl`
        WHERE
                `id_uid` = calling_id_uid_par
            AND
                `id_acl_level` IN   (SELECT `id_acl_level`
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` IN ("participant","researcher")
                                    )
            AND
                `id_proj` = context_id_proj_par;
    RETURN no_of_uid > 0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_read_access_rights_other`(calling_id_uid_par INT, context_id_proj_par INT,other_uid_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    IF NOT `whedcapp`.`check_project_read_access_rights_self(other_uid_par,context_id_proj_par,time_par) THEN
        RETURN FALSE;
    END IF;
    IF `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN
        RETURN TRUE;
    END IF;
    IF `whedcapp`.`check_project_write_access_rights_self(calling_id_uid_par,context_id_proj_par) THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_answer_write_access_rights_self`(id_uid_par INT, id_proj_par INT, id_proj_round_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_participant INT;
    SELECT COUNT(`id_uid`) INTO no_of_participant
        FROM `whedcapp`.`acl`
        WHERE
                `id_uid` = id_uid_par
            AND
                `id_acl_level` IN   (SELECT `id_acl_level`
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` = "participant"
                                    )
            AND
                `id_proj` = id_proj_par
            AND
                `id_proj` IN    (SELECT `id_proj`
                                    FROM `whedcapp`.`project_round`
                                    WHERE
                                            `id_proj_round` = id_proj_round_par
                                        AND
                                            `id_proj_round` IN  (SELECT `id_proj_round`
                                                                    FROM `whedcapp`.`pp_rel`
                                                                    WHERE
                                                                            `id_part` IN    (SELECT `id_part`
                                                                                                FROM `whedcapp`.`participant`
                                                                                                WHERE `id_uid` = id_uid_par
                                                                                            )
                                                                        AND
                                                                            `start_date` <= time_par
                                                                        AND
                                                                            `end_date` >= time_par
                                                                )
                                );
    RETURN no_of_participant > 0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_answer_write_access_rights_other`(id_uid_par INT, id_proj_par INT,id_proj_round_par INT, other_uid_par INT,time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_supporters INT;
    /* Check if other is not a participant */
    IF NOT `whedcapp`.`check_answer_write_access_rights_self`(other_uid_par,id_proj_par,id_proj_round_par) THEN
        RETURN FALSE;
    END IF;
    IF `whedcapp`.`check_administrator_rights`(id_uid_par) THEN
        RETURN TRUE;
    END IF;
    /* Check if calling uid is supporter */
    SELECT COUNT(`id_spp`) INTO no_of_supporters
        FROM `whedcapp`.`spp_rel`
        WHERE
                `id_uid` = id_uid_par
            AND
                `id_proj_round` = id_proj_round_par
            AND
                `spp_rel_start_date` <= time_par
            AND
                (( `spp_rel_end_date` IS NOT NULL AND `spp_rel_end_date` >= time_par) OR `spp_rel_end_date` IS NULL)
            AND
                `id_part` IN    (SELECT `id_part`
                                    FROM `whedcapp`.`participant`
                                    WHERE `id_uid` = other_uid_par
                                );
    IF no_of_supporters>0 THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_answer_read_access_rights_self`(id_uid_par INT, context_id_proj_par INT, context_id_proj_round_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN `whedcapp`.`check_answer_write_access_rights_self`(id_uid_par,context_id_proj_par, context_id_proj_round_par,time_par);
END;
$$
CREATE FUNCTION `whedcapp`.`check_answer_read_access_rights_other`(id_uid_par INT, context_id_proj_par INT, context_id_proj_round_par INT,other_uid_par INT,  time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_researcher INT;
    IF `whedcapp`.`check_answer_write_access_rights_other`(id_uid_par,context_id_proj_par, context_id_proj_round_par,other_uid_par,time_par) THEN
        RETURN TRUE;
    END IF;
    /* Check if uid is a researcher associated with the project */
    SELECT COUNT(`id_uid`) INTO no_of_researcher
        FROM `whedcapp`.`acl`
        WHERE
                `id_uid` = calling_uid_par
            AND
                `id_proj` = context_id_proj_par
            AND
                `id_acl_level` IN   (SELECT `id_acl_level
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` = "researcher"
                                    );
    RETURN no_of_researcher>0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_questionnaire_write_acccess_rights_self`(id_uid_par INT, id_questionnaire_par INT,time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_qm INT;
    SELECT COUNT(`id_uid`) INTO no_of_qm
        FROM `whedcapp`.`uq_rel`
        WHERE
                `id_questionnaire` = id_questionnaire_par
            AND
                `id_uid` IN     (SELECT `id_uid`
                                    FROM `whedcapp`.`uid`
                                    WHERE
                                            `id_uid` = id_uid_par
                                        AND
                                            `is_questionnaire_maintainer`
                                );
    RETURN no_of_qm > 0;
END;
$$
CREATE FUNCTION `whedcapp`.`check_questionnaire_write_access_rights_other`(calling_id_uid_par INT, context_id_questionnaire_par INT,other_uid_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    IF NOT `whedcapp`.`check_questionnaire_write_access_rights_self`(other_uid_par,context_id_questionnaire_par,time_par) THEN
        RETURN FALSE;
    END IF;
    IF `whedcapp`.`check_administrator_rights`(calling_id_uid_par) THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_questionnaire_read_access_rights_self`(calling_id_uid_par INT,context_id_questionnaire_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_questionnaires INT;
    IF `whedcapp`.`check_questionnaire_write_access_rights_self`(calling_id_uid_par,context_id_questionnaire_par,time_par) THEN
        RETURN TRUE;
    END IF;
    /* Check if researcher or participant associated with project using the questionnaire */
    SELECT COUNT(`id_questionnaire`) INTO no_of_questionnaires
        FROM `whedcapp`.`rq_rel`
        WHERE
                `id_questionnaire` = context_id_questionnaire
            AND
                `id_res_que` IN (SELECT `id_res_que`
                                    FROM `whedcapp`.`aim_or_research_question`
                                    WHERE
                                            `id_proj` IN    (SELECT `id_proj`
                                                                FROM `whedcapp`.`project_round`
                                                                JOIN `whedcapp`.`pp_rel` ON `project_round`.`id_proj_round` = `pp_rel`.`id_proj_round`
                                                                JOIN `whedcapp`.`participant` ON `pp_rel`.`id_part` = `participant`.`id_part`
                                                                JOIN `whedcapp`.`acl` ON `participant`.`id_uid` = `acl`.`id_uid`
                                                                WHERE
                                                                        `acl`.`id_uid` = calling_id_uid
                                                                    AND
                                                                        `pp_rel`.`start_date` <= time_par
                                                                    AND
                                                                        `pp_rel`.`end_date` >= time_par
                                                                    AND
                                                                        `acl`.`id_acl_level` IN (SELECT `id_acl_level`
                                                                                                    FROM `whedcapp`.`acl_level`
                                                                                                    WHERE `acl_level_key` = "participant"
                                                                                                )
                                                            )
                                       OR
                                           `id_proj` IN     (SELECT `id_proj`
                                                                FROM `whedcapp`.`acl`
                                                                WHERE
                                                                        `id_uid` = calling_id_uid
                                                                    AND
                                                                        `id_acl_level` IN   (SELECT `id_acl_level`
                                                                                                FROM `whedcapp`.`acl_level`
                                                                                                WHERE
                                                                                                        `acl_level_key` = "researcher"
                                                                                                    OR
                                                                                                        `acl_level_key` = "project_owner"
                                                                                            )
                                                            )
                                );
    IF no_of_questionnaires>0 THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_questionnaire_read_access_rights_other`(calling_id_uid INT, context_id_questionnaire INT, other_uid_par INT, time_par DATETIME) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE no_of_project_owners INT;
    IF NOT `whedcapp`.`check_questionnaire_read_access_rights_self`(other_uid_par,context_id_questionnaire,time_par) THEN
        RETURN FALSE;
    END IF;
    IF `whedcapp`.`check_administrator_rights`(calling_id_uid) THEN
        RETURN TRUE;
    END IF;
    SELECT COUNT(`id_uid`) INTO no_of_project_owners
        FROM `whedcapp`.`acl`
        WHERE
                `id_uid` = calling_uid_par
            AND
                `id_proj` IN    (SELECT `id_proj`
                                    FROM `whedcapp`.`aim_or_research_question`
                                    WHERE
                                            `id_res_que` IN (SELECT `id_res_que`
                                                                FROM `whedcapp`.`rq_rel`
                                                                WHERE `id_questionnaire` = context_id_questionnaie
                                                            )
                                )
            AND
                `id_acl_level` IN   (SELECT `id_acl_level`
                                        FROM `whedcapp`.`acl_level`
                                        WHERE `acl_level_key` = "project_owner"
                                    );
    IF no_of_project_owners > 0 THEN
        RETURN TRUE;
    END IF;
        
                                            `
    RETURN FALSE;
END;
$$
CREATE FUNCTION `whedcapp`.`check_top_administrator_rights`(id_uid_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN `whedcapp`.`check_administrator_rights`(id_uid_par);
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_owner_rights`(id_uid_par INT,id_proj_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN `whedcapp`.`check_acl`(id_uid_par,id_proj_par,TRUE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE);
END;
$$
CREATE FUNCTION `whedcapp`.`check_project_supporter_rights`(id_uid_par INT,id_proj_par INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
	RETURN `whedcapp`.`check_acl`(id_uid_par,id_proj_par,TRUE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE,FALSE);
END;
$$
