
-- Forward Implementation Database Schema
-- MySQL
-- Team Cyan

DROP DATABASE IF EXISTS EdNET;
CREATE DATABASE EdNET; 
Use EdNET; 

-- ----------------
-- User Tables
-- ----------------
-- User
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  UserID int(11) NOT NULL AUTO_INCREMENT,
  FirstName varchar(45) DEFAULT NULL,
  LastName varchar(45) DEFAULT NULL,
  Email varchar(45) DEFAULT NULL,
  Password varchar(128) DEFAULT NULL,
  Type enum("Viewer","SuperViewer","Submitter","Editor","Admin","Disabled","Deleted","Pending") DEFAULT "Viewer",
  Grouptitle enum("None", "Temp", "Student", "Teacher", "Professor", "Principal", "Dean", "President", "Admin") NOT NULL DEFAULT "Temp",
  Locked enum("FALSE","TRUE") NOT NULL DEFAULT "FALSE",
  PRIMARY KEY (UserID)
) ENGINE=InnoDB;

-- Current Logins
DROP TABLE IF EXISTS currentlogins;
CREATE TABLE currentlogins (
  CurrentLoginID int(11) NOT NULL AUTO_INCREMENT,
  UserID int(11) DEFAULT NULL,
  AuthenticationToken bigint(20) NOT NULL,
  Expires datetime NOT NULL,
  PRIMARY KEY (CurrentLoginID),
  FOREIGN KEY (UserID) REFERENCES user (UserID)
) ENGINE=INNODB;

-- recovery
DROP TABLE IF EXISTS recovery ;
CREATE  TABLE IF NOT EXISTS recovery (
  ID INT AUTO_INCREMENT,
  UserID INT(11) NOT NULL,
  Token VARCHAR(64) NOT NULL,
  Expires DATETIME NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (UserID) REFERENCES user (UserID) ON DELETE CASCADE
) ENGINE = InnoDB;



-- ----------------
-- Module Tables
-- ----------------

-- modulebases
DROP TABLE IF EXISTS modulebases;
CREATE TABLE modulebases (
  BaseID int(10) NOT NULL AUTO_INCREMENT,
  Title varchar(300) NOT NULL,
  ModuleIdentifier varchar(35) DEFAULT NULL,
  PRIMARY KEY (BaseID)
) ENGINE=InnoDB;

-- Module
DROP TABLE IF EXISTS module;
CREATE TABLE module (
  ModuleID int(10) NOT NULL AUTO_INCREMENT,
  DateTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Description longtext NOT NULL,
  Language enum("chi", "eng", "fra", "ger", "hin", "ita", "jpn", "rus", "spa", "zxx") DEFAULT "eng",
  EducationLevel enum("Pre-Kindergarten", "Elementary School", "Middle School", "High School", "Higher Education", "Informal", "Vocational") DEFAULT "Higher Education",
  Minutes int(10) DEFAULT NULL,
  AuthorComments longtext,
  Status enum("InProgress","PendingModeration","Active","Locked") NOT NULL DEFAULT "InProgress",
  MinimumUserType enum("Unregistered","Viewer","SuperViewer","Submitter","Editor","Admin") NOT NULL DEFAULT "Viewer",
  InteractivityType enum("Active", "Expositive", "Mixed", "Undefined") DEFAULT "Undefined",
  Rights longtext DEFAULT NULL,
  BaseID int(10) NOT NULL,
  Version int(10) NOT NULL,
  SubmitterUserID int(11) DEFAULT NULL,
  CheckInComments longtext NOT NULL,
  Restrictions enum("None", "Temp", "Student", "Teacher", "Professor", "Principal", "Dean", "President", "Admin") NOT NULL DEFAULT "Temp",
  PRIMARY KEY (ModuleID),
  FOREIGN KEY (SubmitterUserID) REFERENCES user (UserID),
  FOREIGN KEY (BaseID) REFERENCES modulebases (BaseID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Categories
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  CategoryID int(11) NOT NULL AUTO_INCREMENT,
  Name varchar(45),
  Description varchar(150),
  PRIMARY KEY (CategoryID)
) ENGINE=INNODB;

-- modulecategories
DROP TABLE IF EXISTS modulecategories;
CREATE TABLE modulecategories (
  ModuleID int(10) NOT NULL,
  CategoryID int(10) NOT NULL,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE,
  FOREIGN KEY (CategoryID) REFERENCES categories (CategoryID)
) ENGINE=InnoDB;

-- ModuleAuthors
DROP TABLE IF EXISTS moduleauthors;
CREATE TABLE moduleauthors (
	  ModuleID int(11) NOT NULL,
	  AuthorName varchar(50) NOT NULL,
	  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID),
    OrderID INT
) ENGINE=INNODB;

-- Hierarchymodule
DROP TABLE IF EXISTS hierarchymodule;
CREATE TABLE hierarchymodule (
  ModuleID int(10) NOT NULL,
  OrderID INT,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID)
) ENGINE=INNODB;

-- modulelog
DROP TABLE IF EXISTS modulelog;
CREATE TABLE modulelog (
  ModuleID int(10) NOT NULL,
  Message longtext NOT NULL,
  UserID int(11) NOT NULL,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- moduleratings
DROP TABLE IF EXISTS moduleratings;
CREATE TABLE moduleratings (
  ModuleID int(10),
  Rating double NOT NULL DEFAULT "0",
  NumRatings int(10) NOT NULL DEFAULT "0",
  PRIMARY KEY (ModuleID),
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- type
DROP TABLE IF EXISTS type;
CREATE TABLE type (
  TypeID INT NOT NULL AUTO_INCREMENT ,
  Name VARCHAR(45) NOT NULL ,
  PRIMARY KEY (TypeID)
) ENGINE=InnoDB;

-- moduletype
DROP TABLE IF EXISTS moduletype;
CREATE TABLE moduletype (
  ModuleID int(10) NOT NULL,
  TypeID int(10) NOT NULL,
  PRIMARY KEY (ModuleID, TypeID) ,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID),
  FOREIGN KEY (TypeID) REFERENCES type (TypeID)
) ENGINE=InnoDB;

-- objectives
DROP TABLE IF EXISTS objectives;
CREATE TABLE objectives (
  ModuleID int(10) NOT NULL,
  ObjectiveText varchar(300) NOT NULL,
  OrderID int(10) NOT NULL,
  PRIMARY KEY (ModuleID, ObjectiveText, OrderID),
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- otherresources
DROP TABLE IF EXISTS otherresources;
CREATE TABLE otherresources (
  ModuleID int(10) NOT NULL,
  Description varchar(400) NOT NULL,
  ResourceLink varchar(200) DEFAULT NULL,
  OrderID int(10) NOT NULL,
  PRIMARY KEY (ModuleID, OrderID),
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- prereqs
DROP TABLE IF EXISTS prereqs;
CREATE TABLE prereqs (
  ModuleID int(10) NOT NULL,
  PrerequisiteText varchar(200) NOT NULL,
  OrderID int(10) NOT NULL,
  PRIMARY KEY (ModuleID, OrderID),
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Seealso
DROP TABLE IF EXISTS seealso;
CREATE TABLE seealso (
  ModuleID int(10) DEFAULT NULL,
  Description varchar(200) DEFAULT NULL,
  ReferencedModuleID int(11) DEFAULT NULL,
  OrderID int(10) DEFAULT NULL,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- topics
DROP TABLE IF EXISTS topics;
CREATE TABLE topics (
  ModuleID int(10) NOT NULL,
  TopicText varchar(200) NOT NULL,
  OrderID int(10) NOT NULL,
  PRIMARY KEY (ModuleID, OrderID),
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- ----------------
-- Material Tables
-- ----------------

-- Materials
DROP TABLE IF EXISTS materials;
CREATE TABLE materials (
  MaterialID int(10) NOT NULL AUTO_INCREMENT,
  Name varchar(45) DEFAULT NULL,
  Type enum("LocalFile","ExternalURL") NOT NULL,
  Content varchar(200) NOT NULL,
  ReadableFileName varchar(50) NOT NULL,
  DateTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Format varchar(50),
  Rating double NOT NULL DEFAULT "0",
  NumberOfRatings int(10) unsigned zerofill NOT NULL,
  AccessFlag int(10) NOT NULL DEFAULT "-1",
  PRIMARY KEY (MaterialID)
) ENGINE=InnoDB;

-- Materialcomments
DROP TABLE IF EXISTS materialcomments;
CREATE TABLE materialcomments (
  MaterialID int(10) NOT NULL,
  Comments varchar(1000) NOT NULL,
  Subject varchar(250) NOT NULL,
  Date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  Rating double NOT NULL,
  Author varchar(50) NOT NULL,
  NumberOfRatings int(11),
  FOREIGN KEY (MaterialID) REFERENCES materials (MaterialID)
) ENGINE=InnoDB;

-- modulematerialslink
DROP TABLE IF EXISTS modulematerialslink;
CREATE TABLE modulematerialslink (
  ModuleID int(10) NOT NULL,
  MaterialID int(10) NOT NULL,
  OrderID int(10) NOT NULL,
  MaterialLink varchar(200) NOT NULL,
  PRIMARY KEY (ModuleID,MaterialID),
  FOREIGN KEY (MaterialID) REFERENCES materials (MaterialID) ON DELETE CASCADE,
  FOREIGN KEY (ModuleID) REFERENCES module (ModuleID) ON DELETE CASCADE
) ENGINE=InnoDB;



-- ----------------
-- Other Tables
-- ----------------

-- Emails
DROP TABLE IF EXISTS emails;
CREATE TABLE emails (
  EmailID int(10) NOT NULL AUTO_INCREMENT,
  Subject varchar(100) NOT NULL,
  Message longtext NOT NULL,
  PRIMARY KEY (EmailID)
) ENGINE=INNODB;



-- TODO: Do we need parentchild or composition ????

-- parentchild
DROP TABLE IF EXISTS parentchild;
CREATE TABLE parentchild (
  PairingID int(10) NOT NULL AUTO_INCREMENT,
  ParentID int(10) NOT NULL,
  ChildID int(10) NOT NULL,
  Leaf bit NOT NULL, 
  PRIMARY KEY (PairingID)
) ENGINE=InnoDB;

-- Composition
DROP TABLE IF EXISTS composition;
CREATE TABLE composition (
  CompositionID int(10) NOT NULL AUTO_INCREMENT,
  Name varchar(300) NOT NULL, 
  PRIMARY KEY (CompositionID)
) ENGINE=INNODB;



-- ----------------
-- Add Default Values
-- ----------------
INSERT INTO type (Name) VALUES ('Assessment Material'),('Answer Key'),('Portfolio'),('Rubric'),('Test'),('Dataset'),('Event'),('Instructional Material'),('Activity'),('Annotation'),('Case Study'),('Course'),('Curriculum'),('Demonstration'),('Experiment/Lab Activity'),('Field Trip'),('Game'),('Instructional Strategy'),('Instructor Guide/Manual'),('Interactive Simulation'),('Lecture/Presentation'),('Lesson/Lesson Plan'),('Model'),('Problem Set'),('Project'),('Simulation'),('Student Guide'),('Syllabus'),('Textbook'),('Tutorial'),('Unit of Instruction'),('Reference Material'),('Community'),('Tool'),('Audio/Visual');



-- ----------------
-- Add Sample Data
-- ----------------

INSERT INTO user VALUES (1,"Admin","User","admin@admin.com","password","Admin","Admin", "FALSE");

-- TODO: Add more sample data

