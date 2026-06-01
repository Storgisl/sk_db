WITH RECURSIVE OrgTree AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN OrgTree ot ON e.ManagerID = ot.EmployeeID
),
SubordinateCount AS (
    SELECT ManagerID, COUNT(*) AS total_sub
    FROM Employees
    WHERE ManagerID IN (SELECT EmployeeID FROM OrgTree)
    GROUP BY ManagerID
),
TaskCount AS (
    SELECT AssignedTo, COUNT(*) AS total_tasks
    FROM Tasks
    WHERE AssignedTo IN (SELECT EmployeeID FROM OrgTree)
    GROUP BY AssignedTo
)
SELECT ot.EmployeeID, ot.Name AS EmployeeName, ot.ManagerID,
       d.DepartmentName, r.RoleName,
       (SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p WHERE p.DepartmentID = ot.DepartmentID) AS ProjectNames,
       (SELECT GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t WHERE t.AssignedTo = ot.EmployeeID) AS TaskNames,
       COALESCE(tc.total_tasks, 0) AS TotalTasks,
       COALESCE(sc.total_sub, 0) AS TotalSubordinates
FROM OrgTree ot
LEFT JOIN Departments d ON ot.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON ot.RoleID = r.RoleID
LEFT JOIN SubordinateCount sc ON ot.EmployeeID = sc.ManagerID
LEFT JOIN TaskCount tc ON ot.EmployeeID = tc.AssignedTo
ORDER BY ot.Name;
