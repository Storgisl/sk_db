WITH RECURSIVE SubTree AS (
    SELECT EmployeeID, ManagerID
    FROM Employees
    WHERE RoleID = 1
    
    UNION ALL
    
    SELECT e.EmployeeID, e.ManagerID
    FROM Employees e
    JOIN SubTree st ON e.ManagerID = st.EmployeeID
),
ManagerSubCount AS (
    SELECT ManagerID AS EmployeeID, COUNT(*) AS total_subordinates
    FROM SubTree
    WHERE ManagerID IS NOT NULL
    GROUP BY ManagerID
)
SELECT DISTINCT e.EmployeeID, e.Name AS EmployeeName, e.ManagerID,
       d.DepartmentName, r.RoleName,
       (SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p WHERE p.DepartmentID = e.DepartmentID) AS ProjectNames,
       (SELECT GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t WHERE t.AssignedTo = e.EmployeeID) AS TaskNames,
       COALESCE(msc.total_subordinates, 0) AS TotalSubordinates
FROM Employees e
JOIN ManagerSubCount msc ON e.EmployeeID = msc.EmployeeID
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON e.RoleID = r.RoleID
WHERE e.RoleID = 1
ORDER BY e.Name;
