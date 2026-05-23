--Dipinsa Marasini
-- University Enrollment Database
-- Oracle SQL | Database Management Systems | UT Arlington

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE GRADES';
  EXECUTE IMMEDIATE 'DROP TABLE ENROLLMENTS';
  EXECUTE IMMEDIATE 'DROP TABLE COURSES';
  EXECUTE IMMEDIATE 'DROP TABLE INSTRUCTORS';
  EXECUTE IMMEDIATE 'DROP TABLE STUDENTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

--------------------------------------------------
-- Part A: Table Creation
--------------------------------------------------

CREATE TABLE STUDENTS(
  studentId NUMBER(5) PRIMARY KEY,
  firstName VARCHAR2(40),
  lastName VARCHAR2(40),
  dateOfBirth DATE,
  address VARCHAR2(120)
);

CREATE TABLE INSTRUCTORS(
  instructorId NUMBER(5) PRIMARY KEY,
  instructorName VARCHAR2(60),
  specialization VARCHAR2(60)
);

CREATE TABLE COURSES(
  courseId NUMBER(5) PRIMARY KEY,
  courseName VARCHAR2(80),
  instructorId NUMBER(5),
  credits NUMBER(2),
  FOREIGN KEY (instructorId) REFERENCES INSTRUCTORS(instructorId)
);

CREATE TABLE ENROLLMENTS(
  enrollmentId NUMBER(6) PRIMARY KEY,
  studentId NUMBER(5),
  courseId NUMBER(5),
  enrollmentDate DATE,
  FOREIGN KEY (studentId) REFERENCES STUDENTS(studentId),
  FOREIGN KEY (courseId) REFERENCES COURSES(courseId)
);

CREATE TABLE GRADES(
  gradeId NUMBER(6) PRIMARY KEY,
  enrollmentId NUMBER(6),
  grade VARCHAR2(2),
  FOREIGN KEY (enrollmentId) REFERENCES ENROLLMENTS(enrollmentId)
);

--------------------------------------------------
-- Part A: Record Insertion
--------------------------------------------------

INSERT INTO STUDENTS VALUES (10,'Elena','Santos',TO_DATE('2001-02-14','YYYY-MM-DD'),'Haltom City, TX');
INSERT INTO STUDENTS VALUES (11,'Marcus','Reed',TO_DATE('2000-11-28','YYYY-MM-DD'),'Euless, TX');
INSERT INTO STUDENTS VALUES (12,'Priya','Kapoor',TO_DATE('2003-05-03','YYYY-MM-DD'),'Arlington, TX');
INSERT INTO STUDENTS VALUES (13,'Jaden','Brooks',TO_DATE('2002-10-19','YYYY-MM-DD'),'Grand Prairie, TX');

INSERT INTO INSTRUCTORS VALUES (500,'Dr. Simmons','Cybersecurity');
INSERT INTO INSTRUCTORS VALUES (501,'Professor Lane','Software Engineering');
INSERT INTO INSTRUCTORS VALUES (502,'Dr. Nguyen','Data Management');

INSERT INTO COURSES VALUES (900,'Network Security Fundamentals',500,3);
INSERT INTO COURSES VALUES (901,'Object-Oriented Programming',501,4);
INSERT INTO COURSES VALUES (902,'Database Concepts',502,3);
INSERT INTO COURSES VALUES (903,'Systems Analysis',501,3);
INSERT INTO COURSES VALUES (904,'Data Visualization',502,4);

INSERT INTO ENROLLMENTS VALUES (2001,10,900,TO_DATE('2025-01-08','YYYY-MM-DD'));
INSERT INTO ENROLLMENTS VALUES (2002,11,901,TO_DATE('2025-01-10','YYYY-MM-DD'));
INSERT INTO ENROLLMENTS VALUES (2003,12,902,TO_DATE('2025-01-11','YYYY-MM-DD'));
INSERT INTO ENROLLMENTS VALUES (2004,13,904,TO_DATE('2025-01-13','YYYY-MM-DD'));
INSERT INTO ENROLLMENTS VALUES (2005,10,903,TO_DATE('2025-01-14','YYYY-MM-DD'));

INSERT INTO GRADES VALUES (3001,2001,'B');
INSERT INTO GRADES VALUES (3002,2002,'A');
INSERT INTO GRADES VALUES (3003,2003,'B');
INSERT INTO GRADES VALUES (3004,2004,'A');
INSERT INTO GRADES VALUES (3005,2005,'C');

COMMIT;


--------------------------------------------------
-- Part B
--------------------------------------------------

-- 1
SELECT * FROM STUDENTS;

SELECT firstName,lastName,dateOfBirth
FROM STUDENTS
WHERE dateOfBirth > TO_DATE('2002-01-01','YYYY-MM-DD');

SELECT * FROM COURSES WHERE credits > 3;

-- 2
SELECT firstName || ' ' || lastName AS StudentName
FROM STUDENTS;

SELECT c.courseName || ' - ' || i.instructorName
FROM COURSES c, INSTRUCTORS i
WHERE c.instructorId = i.instructorId;

-- 3
SELECT DISTINCT specialization FROM INSTRUCTORS;

SELECT * FROM STUDENTS ORDER BY lastName;

-- 4
SELECT courseId, COUNT(*)
FROM ENROLLMENTS
GROUP BY courseId;

SELECT AVG(credits) FROM COURSES;

SELECT MAX(credits), MIN(credits) FROM COURSES;

-- 5
SELECT instructorId, COUNT(*)
FROM COURSES
GROUP BY instructorId
HAVING COUNT(*) > 1;

SELECT courseId, COUNT(*)
FROM ENROLLMENTS
GROUP BY courseId
HAVING COUNT(*) > 2;

-- 6
SELECT s.firstName, s.lastName, c.courseName
FROM STUDENTS s
JOIN ENROLLMENTS e ON s.studentId=e.studentId
JOIN COURSES c ON e.courseId=c.courseId;

SELECT i.instructorName, c.courseName
FROM INSTRUCTORS i
LEFT JOIN COURSES c ON i.instructorId=c.instructorId;

SELECT s.firstName, s.lastName, c.courseName, i.instructorName, g.grade
FROM GRADES g
JOIN ENROLLMENTS e ON g.enrollmentId=e.enrollmentId
JOIN STUDENTS s ON e.studentId=s.studentId
JOIN COURSES c ON e.courseId=c.courseId
JOIN INSTRUCTORS i ON c.instructorId=i.instructorId;

-- 7
SELECT studentId
FROM ENROLLMENTS
GROUP BY studentId
HAVING COUNT(*) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM ENROLLMENTS GROUP BY studentId));

SELECT * 
FROM COURSES
WHERE credits > (SELECT AVG(credits) FROM COURSES);

-- 8
SELECT * FROM COURSES WHERE courseName LIKE 'D%';

SELECT *
FROM STUDENTS
WHERE dateOfBirth BETWEEN TO_DATE('2000-01-01','YYYY-MM-DD')
AND TO_DATE('2003-12-31','YYYY-MM-DD');

SELECT *
FROM INSTRUCTORS
WHERE specialization IN ('Cybersecurity','AI','Networking');

-- 9
INSERT INTO INSTRUCTORS VALUES (503,'Mr. Allen','Information Systems');

UPDATE COURSES
SET credits = 5
WHERE instructorId = 503;

-- 10
SELECT i.instructorName,
       COUNT(DISTINCT e.studentId),
       COUNT(DISTINCT c.courseId)
FROM INSTRUCTORS i
LEFT JOIN COURSES c ON i.instructorId=c.instructorId
LEFT JOIN ENROLLMENTS e ON c.courseId=e.courseId
GROUP BY i.instructorName;

SELECT s.firstName, s.lastName,
       AVG(CASE grade WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2 WHEN 'D' THEN 1 ELSE 0 END)
FROM STUDENTS s
JOIN ENROLLMENTS e ON s.studentId=e.studentId
JOIN GRADES g ON e.enrollmentId=g.enrollmentId
GROUP BY s.firstName,s.lastName;
