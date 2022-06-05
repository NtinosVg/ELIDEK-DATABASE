3.1 
SELECT * FROM Project WHERE admin_id = admin
SELECT * FROM Project WHERE duration = duration
SELECT * FROM Project WHERE project_start < date AND project_end > date
SELECT * FROM Project
SELECT * FROM Project WHERE duration =duration AND admin_id = admin
SELECT * FROM Project WHERE project_start < date AND project_end >date AND admin_id = admin
SELECT * FROM Project WHERE project_start < date AND project_end > date AND duration = duration

3.2
CREATE VIEW r_projects AS
    SELECT Researcher.researcher_name, 
    Researcher.researcher_lastname,
    Researcher.researcher_id,
    Works_in.project_title
FROM 
Researcher, Works_in 
WHERE Researcher.researcher_id = Works_in.researcher_id;

SELECT * FROM r_projects;

DROP VIEW r_projects;


CREATE VIEW overview_project AS 
    SELECT Project.project_title,
    Project.budget,
    Evaluation.evaluation_grade,
    Project.researcher_id
FROM Project, Evaluation
WHERE Project.evaluation_id=Evaluation.evaluation_id;

SELECT * FROM overview_project;

DROP VIEW overview_project;

3.3
SELECT * FROM Works_in WHERE Project_title IN (SELECT Project_title FROM Project WHERE (project_start < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) AND project_end > CURDATE() ) AND Project_title IN (SELECT project_title FROM Project_Field WHERE (field_name='Basic medicine')));

3.4

create view num_of_proj as
SELECT EXTRACT(YEAR from project.project_start) as years, organization.ID as org_ID,count(project.ID) as num_of_proj
FROM manages,organization,project
WHERE organization.ID = organization_ID AND project.ID = project_ID
GROUP BY years,org_ID;


SELECT org_ID,organization.org_name
FROM organization,(SELECT t1.org_ID, t1.num_of_proj
                    FROM num_of_proj as t1, num_of_proj as t2
                    WHERE (t1.org_ID = t2.org_ID AND t1.num_of_proj = t2.num_of_proj AND t1.years - t2.years = 1)) as newtable
WHERE (org_ID = organization.ID AND num_of_proj>=10);


3.5
CREATE VIEW Couples AS SELECT c.field_name AS Field1, a.field_name AS Field2 FROM Project_Field c, Project_Field a WHERE 
(a.field_name > c.field_name AND c.project_title IN (SELECT Project_title FROM Project) AND  a.project_title IN (SELECT Project_title FROM Project) AND a.project_title=c.project_title);

SELECT Field1, Field2, COUNT(*) AS occurences FROM Couples GROUP BY Field1, Field2 ORDER BY occurences DESC LIMIT 3;

DROP VIEW Couples;

3.6
CREATE VIEW current_workers AS SELECT researcher_id AS id FROM Works_in WHERE 
researcher_id IN (SELECT researcher_id FROM Works_in WHERE project_title IN (SELECT project_title FROM Project WHERE (project_start < CURDATE() AND project_end > CURDATE())));

CREATE VIEW current_researchers AS SELECT Researcher.researcher_name, Researcher.researcher_lastname, current_workers.id FROM Researcher INNER JOIN current_workers ON Researcher.researcher_id=current_workers.id;

SELECT *, COUNT(*) AS times_in_projects FROM current_researchers WHERE id IN (SELECT researcher_id FROM Researcher WHERE (TIMESTAMPDIFF(YEAR, researcher_birthdate,CURDATE()) < 40)) GROUP BY id ORDER BY times_in_projects DESC LIMIT 5;

DROP ViEW current_workers;
DROP VIEW current_researchers;

3.7
CREATE VIEW best_admin AS 
SELECT admins.name, admins.admin_id, project.org_name as private_company_name, project.budget as budget 
FROM Admins
INNER JOIN project ON admins.admin_id = project.admin_id
WHERE project.org_name IN (SELECT org_name FROM private_company) 
ORDER BY project.budget DESC;

SELECT admin_name, private_company_name, SUM(budget) as total_funds
FROM best_admin 
GROUP BY Admin_id LIMIT 5;

DROP VIEW best_admin;

3.8
create VIEW no_deliverables as (
select RESEARCHER_ID from works_in where project_title in 
(SELECT t1.project_title
FROM project t1
LEFT JOIN deliverables t2 ON t2.project_title = t1.project_title
WHERE t2.project_title IS NULL));

SELECT r.researcher_name, r.researcher_lastname, COUNT(w.researcher_id) as project_with_no_deliverables
FROM  researcher r
INNER JOIN no_deliverables w ON w.researcher_id = r.researcher_id
GROUP BY w.researcher_id
HAVING project_with_no_deliverables >= 5
ORDER BY project_with_no_deliverables DESC;