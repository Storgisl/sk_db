WITH RECURSIVE OrgTree AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN OrgTree ot ON e.ManagerID = ot.EmployeeID
)
SELECT ot.EmployeeID, ot.Name AS EmployeeName, ot.ManagerID,
       d.DepartmentName, r.RoleName,
       (SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = ot.DepartmentID) AS ProjectNames,
       (SELECT GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = ot.EmployeeID) AS TaskNames
FROM OrgTree ot
LEFT JOIN Departments d ON ot.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON ot.RoleID = r.RoleID
ORDER BY ot.Name;
