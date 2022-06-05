SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS ELIDEK;
CREATE SCHEMA ELIDEK;
USE ELIDEK;

CREATE TABLE Program (
    program_name VARCHAR(50) NOT NULL,
    program_address VARCHAR(50) NOT NULL,
    PRIMARY KEY (program_name)
);

CREATE TABLE Research_Field (
    field_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(field_name)
);

CREATE TABLE Admins (
    admin_id INT UNSIGNED NOT NULL,
    admin_name VARCHAR(50),
    PRIMARY KEY (admin_id)
);

CREATE TABLE Organization (
    ID INT NOT NULL,
    org_name VARCHAR(50) NOT NULL,
    post_code VARCHAR(50) NOT NULL,
    org_address VARCHAR(50) NOT NULL,
    org_city VARCHAR(50) NOT NULL,
    org_abbr VARCHAR(50) NOT NULL,
    PRIMARY KEY (org_name)
);

CREATE TABLE Evaluation (
    evaluation_id INT UNSIGNED NOT NULL,
    evaluation_grade INT UNSIGNED NOT NULL,
    evaluation_date  DATE NOT NULL,
    PRIMARY KEY (evaluation_id)
);

CREATE TABLE Researcher (
    researcher_id VARCHAR(50) NOT NULL,
    researcher_name VARCHAR(50) NOT NULL,
    researcher_lastname VARCHAR(50) NOT NULL,
    researcher_birthdate  DATE NOT NULL,
    researcher_gender VARCHAR(50) NOT NULL,
    org_name VARCHAR(50) NOT NULL,
    hire  DATE NOT NULL,
    PRIMARY KEY (researcher_id, org_name),
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
);

    CREATE INDEX org_name_idx ON Researcher(org_name);
    CREATE INDEX researcher_id_idx ON Researcher(researcher_id);

CREATE TABLE Project (
    ID INT NOT NULL,
    project_title VARCHAR(50) NOT NULL,
    project_start  DATE NOT NULL,
    project_end  DATE NOT NULL,
    budget INT UNSIGNED NOT NULL,
    admin_id INT UNSIGNED NOT NULL,
    program_name VARCHAR(50) NOT NULL,
    evaluation_id INT UNSIGNED NOT NULL,
    researcher_id VARCHAR(50) NOT NULL,
    org_name VARCHAR(50) NOT NULL,
    chief_researcher VARCHAR(50) NOT NULL,
    project_brief VARCHAR(500) NOT NULL,
    duration SMALLINT AS (TIMESTAMPDIFF(YEAR, project_start, project_end)),
    PRIMARY KEY (project_title),
    FOREIGN KEY (admin_id) REFERENCES Admins(admin_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (program_name) REFERENCES Program(program_name) ON DELETE RESTRICT ON UPDATE CASCADE, 
    FOREIGN KEY (evaluation_id) REFERENCES Evaluation(evaluation_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
    FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (chief_researcher) REFERENCES Researcher(researcher_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
    CREATE INDEX admin_id_idx ON Project(admin_id);
    CREATE INDEX program_name_idx ON Project(program_name);
    CREATE INDEX evaluation_id_idx ON Project(evaluation_id);
    CREATE INDEX researcher_id_idx ON Project(researcher_id);
    CREATE INDEX org_name_idx ON Project(org_name);
    CREATE INDEX chief_researcher_idx ON Project(chief_researcher);

CREATE TABLE manages (
    organization_ID INT NOT NULL,
    project_ID INT NOT NULL,
    PRIMARY KEY (organization_ID, project_ID)
);

CREATE TABLE Project_Field (
    field_name VARCHAR(50) NOT NULL,
    project_title VARCHAR(50) NOT NULL,
    PRIMARY KEY (field_name, project_title),
    FOREIGN KEY (field_name) REFERENCES Research_Field(field_name) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (project_title) REFERENCES Project(project_title) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX field_name_idx ON Project_Field(field_name);
    CREATE INDEX project_title_idx ON Project_Field(project_title);


CREATE TABLE Deliverables (
    project_title VARCHAR(50) NOT NULL,
    deliverable_title VARCHAR(50) NOT NULL,
    brief VARCHAR(500) NOT NULL,
    delivery_date  DATE NOT NULL,
    PRIMARY KEY (deliverable_title, project_title),
    FOREIGN KEY (project_title) REFERENCES Project(project_title) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX project_title_idx ON Deliverables(project_title);



CREATE TABLE Evaluate (
    evaluation_id INT UNSIGNED NOT NULL,
    researcher_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (evaluation_id, researcher_id),
    FOREIGN KEY (evaluation_id) REFERENCES Evaluation(evaluation_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

    CREATE INDEX evaluation_id_idx ON Evaluate(evaluation_id);
    CREATE INDEX researcher_id_idx ON Evaluate(researcher_id);

CREATE TABLE Works_in (
    project_title VARCHAR(50) NOT NULL,
    researcher_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (project_title, researcher_id),
    FOREIGN KEY (project_title) REFERENCES Project(project_title) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX project_title_idx ON Works_in (project_title);
    CREATE INDEX researcher_id_idx ON Works_in (researcher_id);


CREATE TABLE Phone_Numbers (
    org_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    PRIMARY KEY (org_name, phone_number),
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX org_name_idx ON Phone_Numbers(org_name);


CREATE TABLE Private_Company (
    company_funds INT UNSIGNED NOT NULL,
    org_name VARCHAR(50),
    PRIMARY KEY (org_name),
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
);

    CREATE INDEX org_name_idx ON Private_Company(org_name);


CREATE TABLE University (
    university_funds INT UNSIGNED NOT NULL,
    org_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (org_name),
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX org_name_idx ON University(org_name);


CREATE TABLE Research_Center (
    publicfunds INT UNSIGNED NOT NULL,
    privatefunds INT UNSIGNED NOT NULL,
    org_name VARCHAR(50),
    PRIMARY KEY (org_name),
    FOREIGN KEY (org_name) REFERENCES Organization(org_name) ON DELETE RESTRICT ON UPDATE CASCADE
);


    CREATE INDEX org_name_idx ON Research_Center(org_name);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;