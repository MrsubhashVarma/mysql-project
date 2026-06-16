CREATE DATABASE placement_management_system;

USE placement_management_system;

CREATE TABLE departments(
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO departments VALUES
(101,'CSE'),
(102,'ECE'),
(103,'EEE'),
(104,'Mechanical'),
(105,'Civil');

CREATE TABLE students(
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone BIGINT,
    cgpa DECIMAL(3,1),
    dept_id INT,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

INSERT INTO students(student_id,student_name,email,phone,cgpa,dept_id) VALUES
(1,'Saran','saran@gmail.com',9876543210,8.5,101),
(2,'Priya','priya@gmail.com',9876543211,9.0,102),
(3,'Rahul','rahul@gmail.com',9876543212,7.8,101),
(4,'Deepa','deepa@gmail.com',9876543213,8.9,103),
(5,'Anjali','anjali@gmail.com',9876543214,8.2,102),
(6,'Kumar','kumar@gmail.com',9876543215,7.5,104),
(7,'Sneha','sneha@gmail.com',9876543216,9.1,101),
(8,'Varun','varun@gmail.com',9876543217,8.0,105),
(9,'Charan','charan@gmail.com',9876543218,7.2,104),
(10,'Harsha','harsha@gmail.com',9876543219,8.7,101);

CREATE TABLE companies(
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100) UNIQUE,
    location VARCHAR(100),
    package_lpa DECIMAL(4,1)
);

INSERT INTO companies VALUES
(1,'TCS','Hyderabad',4.5),
(2,'Infosys','Bangalore',5.2),
(3,'Accenture','Chennai',6.0),
(4,'Wipro','Pune',4.2),
(5,'Cognizant','Hyderabad',5.8);

CREATE TABLE jobs(
    job_id INT PRIMARY KEY,
    company_id INT,
    role_name VARCHAR(100),
    min_cgpa DECIMAL(3,1),
    FOREIGN KEY(company_id) REFERENCES companies(company_id)
);

INSERT INTO jobs VALUES
(1,1,'Java Developer',7.5),
(2,2,'Python Developer',8.0),
(3,3,'Full Stack Developer',8.2),
(4,4,'Data Analyst',7.0),
(5,5,'Software Engineer',7.8);

CREATE TABLE applications(
    application_id INT PRIMARY KEY,
    student_id INT,
    job_id INT,
    status VARCHAR(20),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(job_id) REFERENCES jobs(job_id)
);

INSERT INTO applications VALUES
(1,1,1,'Applied'),
(2,1,5,'Applied'),
(3,2,3,'Applied'),
(4,3,1,'Applied'),
(5,4,2,'Applied'),
(6,5,3,'Applied'),
(7,6,4,'Applied'),
(8,7,5,'Applied'),
(9,8,2,'Applied'),
(10,10,3,'Applied');

CREATE TABLE aptitude_tests(
    test_id INT PRIMARY KEY,
    student_id INT,
    marks INT,
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);

INSERT INTO aptitude_tests VALUES
(1,1,85),
(2,2,92),
(3,3,70),
(4,4,95),
(5,5,80),
(6,6,65),
(7,7,98),
(8,8,75),
(9,9,68),
(10,10,88);

CREATE TABLE interviews(
    interview_id INT PRIMARY KEY,
    student_id INT,
    company_id INT,
    round_name VARCHAR(50),
    result VARCHAR(20),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(company_id) REFERENCES companies(company_id)
);

INSERT INTO interviews VALUES
(1,1,1,'Technical','Pass'),
(2,2,3,'Technical','Pass'),
(3,3,1,'Technical','Fail'),
(4,4,2,'Technical','Pass'),
(5,5,5,'Technical','Pass'),
(6,6,4,'Technical','Fail'),
(7,7,5,'Technical','Pass'),
(8,8,2,'Technical','Pass'),
(9,10,3,'Technical','Pass');

CREATE TABLE placements(
    placement_id INT PRIMARY KEY,
    student_id INT,
    company_id INT,
    package_lpa DECIMAL(4,1),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(company_id) REFERENCES companies(company_id)
);

INSERT INTO placements VALUES
(1,1,1,4.5),
(2,2,3,6.0),
(3,4,2,5.2),
(4,5,5,5.8),
(5,7,5,5.8),
(6,8,2,5.2),
(7,10,3,6.0);

CREATE TABLE skills(
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(50)
);

INSERT INTO skills VALUES
(1,'Java'),
(2,'Python'),
(3,'SQL'),
(4,'React'),
(5,'Spring Boot');

CREATE TABLE student_skills(
    student_id INT,
    skill_id INT,
    PRIMARY KEY(student_id,skill_id),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(skill_id) REFERENCES skills(skill_id)
);

INSERT INTO student_skills VALUES
(1,1),
(1,3),
(2,2),
(2,4),
(3,1),
(4,2),
(5,5),
(7,1),
(7,5),
(10,3);

SELECT s.student_name, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

SELECT s.student_name, c.company_name
FROM students s
INNER JOIN applications a ON s.student_id = a.student_id
INNER JOIN jobs j ON a.job_id = j.job_id
INNER JOIN companies c ON j.company_id = c.company_id;

SELECT * FROM students
WHERE cgpa > 8;

SELECT * FROM companies
WHERE package_lpa > 5;

SELECT DISTINCT s.student_name
FROM students s
INNER JOIN interviews i ON s.student_id = i.student_id;

SELECT s.student_name, c.company_name, p.package_lpa
FROM placements p
INNER JOIN students s ON p.student_id = s.student_id
INNER JOIN companies c ON p.company_id = c.company_id;

SELECT s.student_name
FROM students s
LEFT JOIN placements p ON s.student_id = p.student_id
WHERE p.placement_id IS NULL;

SELECT COUNT(*) AS total_students
FROM students;

SELECT AVG(cgpa) AS average_cgpa
FROM students;

SELECT MAX(cgpa) AS highest_cgpa
FROM students;

SELECT MIN(cgpa) AS lowest_cgpa
FROM students;

SELECT d.dept_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

SELECT c.company_name, COUNT(p.student_id) AS placed_student_count
FROM companies c
LEFT JOIN placements p ON c.company_id = p.company_id
GROUP BY c.company_name;

SELECT d.dept_name, COUNT(s.student_id) AS student_count
FROM departments d
INNER JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING COUNT(s.student_id) > 2;

SELECT c.company_name, COUNT(p.student_id) AS selected_count
FROM companies c
INNER JOIN placements p ON c.company_id = p.company_id
GROUP BY c.company_name
HAVING COUNT(p.student_id) > 1;

SELECT d.dept_name, AVG(s.cgpa) AS average_cgpa
FROM departments d
INNER JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name
HAVING AVG(s.cgpa) > 8;

SELECT s.student_name, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

SELECT s.student_name, c.company_name
FROM students s
INNER JOIN applications a ON s.student_id = a.student_id
INNER JOIN jobs j ON a.job_id = j.job_id
INNER JOIN companies c ON j.company_id = c.company_id;

SELECT c.company_name, j.role_name
FROM companies c
LEFT JOIN jobs j ON c.company_id = j.company_id;

SELECT s.student_name, a.application_id, a.status
FROM students s
LEFT JOIN applications a ON s.student_id = a.student_id;

SELECT s.student_name
FROM students s
LEFT JOIN applications a ON s.student_id = a.student_id
WHERE a.application_id IS NULL;

SELECT *
FROM students
WHERE cgpa = (SELECT MAX(cgpa) FROM students);

SELECT *
FROM students
WHERE cgpa > (SELECT AVG(cgpa) FROM students);

SELECT *
FROM companies
WHERE package_lpa = (SELECT MAX(package_lpa) FROM companies);

SELECT s.student_name, c.company_name
FROM placements p
INNER JOIN students s ON p.student_id = s.student_id
INNER JOIN companies c ON p.company_id = c.company_id
WHERE c.company_name = 'TCS';

SELECT DISTINCT s.student_name
FROM students s
INNER JOIN applications a ON s.student_id = a.student_id
LEFT JOIN placements p ON s.student_id = p.student_id
WHERE p.placement_id IS NULL;

CREATE VIEW selected_students AS
SELECT s.student_name, c.company_name, p.package_lpa
FROM placements p
INNER JOIN students s ON p.student_id = s.student_id
INNER JOIN companies c ON p.company_id = c.company_id;

SELECT * FROM selected_students;

CREATE VIEW cgpa_above_8_students AS
SELECT *
FROM students
WHERE cgpa > 8;

DELIMITER //

CREATE PROCEDURE display_all_students()
BEGIN
    SELECT * FROM students;
END //

CREATE PROCEDURE display_students_by_department(IN deptNo INT)
BEGIN
    SELECT *
    FROM students
    WHERE dept_id = deptNo;
END //

CREATE PROCEDURE display_placed_students()
BEGIN
    SELECT s.student_name, c.company_name, p.package_lpa
    FROM placements p
    INNER JOIN students s ON p.student_id = s.student_id
    INNER JOIN companies c ON p.company_id = c.company_id;
END //

CREATE PROCEDURE insert_new_student(
    IN s_name VARCHAR(50),
    IN s_email VARCHAR(100),
    IN s_phone BIGINT,
    IN s_cgpa DECIMAL(3,1),
    IN s_dept_id INT
)
BEGIN
    INSERT INTO students(student_name,email,phone,cgpa,dept_id)
    VALUES(s_name,s_email,s_phone,s_cgpa,s_dept_id);
END //

CREATE PROCEDURE update_student_cgpa(
    IN s_id INT,
    IN new_cgpa DECIMAL(3,1)
)
BEGIN
    UPDATE students
    SET cgpa = new_cgpa
    WHERE student_id = s_id;
END //

CREATE TRIGGER set_application_status
BEFORE INSERT ON applications
FOR EACH ROW
BEGIN
    SET NEW.status = 'Applied';
END //

CREATE TRIGGER prevent_low_cgpa_students
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.cgpa < 6 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CGPA below 6 is not allowed';
    END IF;
END //

CREATE TABLE deleted_students_backup(
    student_id INT,
    student_name VARCHAR(50),
    email VARCHAR(100),
    phone BIGINT,
    cgpa DECIMAL(3,1),
    dept_id INT,
    deleted_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) //

CREATE TRIGGER backup_deleted_students
BEFORE DELETE ON students
FOR EACH ROW
BEGIN
    INSERT INTO deleted_students_backup
    (student_id, student_name, email, phone, cgpa, dept_id)
    VALUES
    (OLD.student_id, OLD.student_name, OLD.email, OLD.phone, OLD.cgpa, OLD.dept_id);
END //

DELIMITER ;

CALL display_all_students();
CALL display_students_by_department(101);
CALL display_placed_students();
CALL insert_new_student('Ravi','ravi@gmail.com',9876543220,8.4,101);
CALL update_student_cgpa(3,8.1);