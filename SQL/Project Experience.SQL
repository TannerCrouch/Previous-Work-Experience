WITH Personnel
AS (
	SELECT H.HUB_PERSONNEL_HASHKEY
		, S.FirstName
		, S.LastName
		, S.FormalName
		, Z.StaffRoleName AS Title
		, S.OfficeEmail
		, P.HUB_OFFICE_HashKey
		, O.OfficeName AS EmployeeOffice
		, LP.HUB_PROJECT_HashKey
		, H.PersonnelId
		, S.Status
		, S.dvEndDateTime
	FROM dbo.HUB_PERSONNEL AS H
	LEFT JOIN dbo.HSAT_PERSONNEL AS S
		ON H.HUB_PERSONNEL_HASHKEY = S.HUB_PERSONNEL_HashKey
	LEFT JOIN dbo.LINK_PERSONNEL_OFFICE AS P
		ON H.HUB_PERSONNEL_HASHKEY = P.HUB_PERSONNEL_HashKey
	INNER JOIN dbo.LSAT_PERSONNEL_OFFICE AS LSAT
		ON P.LINK_PERSONNEL_OFFICE_HASHKEY=LSAT.LINK_PERSONNEL_OFFICE_HASHKEY 
		AND LSAT.dvEndDateTime IS NULL
	LEFT JOIN dbo.HUB_OFFICE AS O
		ON P.HUB_OFFICE_HashKey = O.HUB_OFFICE_HashKey
	LEFT JOIN dbo.LINK_PROJECT_PERSONNEL AS LP
		ON H.HUB_PERSONNEL_HASHKEY = LP.HUB_PERSONNEL_HashKey
    LEFT JOIN dbo.LSAT_PROJECT_PERSONNEL AS Z
        ON LP.LINK_PROJECT_PERSONNEL_HashKey=Z.LINK_PROJECT_PERSONNEL_HashKey
	WHERE S.dvEndDateTime IS NULL
	)
	, Project
AS (
	SELECT HP.HUB_PROJECT_HashKey
		, HP.ProjectNumber
		, SP.[Description]
		, LM.HUB_MARKETSECTORS_HashKey
		, LS.HUB_SUBMARKETSECTORS_HashKey
		, CS.FincontPc
		, SM.CategoryName
		, SS.SecondaryCategoryName
		, SCHED.ActualSubstantialCompletionDate AS CompletionDate
	FROM dbo.HUB_PROJECT AS HP
	LEFT JOIN dbo.HSAT_PROJECT AS SP
		ON HP.HUB_PROJECT_HashKey = SP.HUB_PROJECT_HashKey
	LEFT JOIN dbo.LINK_PROJECT_MARKETSECTORS AS LM
		ON HP.HUB_PROJECT_HashKey = LM.HUB_PROJECT_HashKey
	LEFT JOIN dbo.HUB_MARKETSECTORS AS HM
		ON LM.HUB_MARKETSECTORS_HashKey=HM.HUB_MARKETSECTORS_HashKey
	LEFT JOIN dbo.HSAT_MARKETSECTORS AS SM
		ON HM.HUB_MARKETSECTORS_HashKey = SM.HUB_MARKETSECTORS_HashKey
	LEFT JOIN dbo.LINK_PROJECT_SUBMARKETSECTORS AS LS
		ON HP.HUB_PROJECT_Hashkey = LS.HUB_PROJECT_HashKey
	LEFT JOIN dbo.HUB_SUBMARKETSECTORS AS X
		ON LS.HUB_SUBMARKETSECTORS_HashKey=X.HUB_SUBMARKETSECTORS_HashKey
	LEFT JOIN dbo.HSAT_SUBMARKETSECTORS AS SS
		ON X.HUB_SUBMARKETSECTORS_HashKey = SS.HUB_SUBMARKETSECTORS_HashKey
	LEFT JOIN dbo.HSAT_PROJECT_COST AS CS
		ON HP.HUB_PROJECT_HashKey = CS.HUB_PROJECT_HashKey
	LEFT JOIN dbo.HSAT_PROJECT_SCHEDULE AS SCHED 
		ON HP.HUB_PROJECT_Hashkey= SCHED.HUB_PROJECT_HashKey
	WHERE SP.dvEndDateTime IS NULL
		AND SP.Description IS NOT NULL

	)
	, PersonnelProject
AS (
	SELECT P.PersonnelId
		, P.FirstName
		, P.LastName
		, P.OfficeEmail
		, P.EmployeeOffice
		, P.Title
		, M.[Description]
		, M.CategoryName
		, M.ProjectNumber
		, M.SecondaryCategoryName
		, STR(M.FincontPc) AS 'JobCost'
		, M.CompletionDate
		,P.Status
		,P.dvEndDateTime
	FROM Personnel AS P
	INNER JOIN Project AS M
		ON P.HUB_PROJECT_HashKey = M.HUB_PROJECT_HashKey

	)
	, PersonnelOffice
AS (
	SELECT DISTINCT PersonnelId
		, EmployeeOffice
	FROM Personnel
	)
	, UnionTable
AS (
	SELECT P.PersonnelID
		, P.LastName
		, P.FirstName
		, P.Title
		, P.OfficeEmail
		, P.EmployeeOffice
		, P.Description
		, P.CategoryName 
		, P.SecondaryCategoryName 
		, 'MGC' AS 'Company'
		, P.JobCost
		, P.ProjectNumber
		, P.CompletionDate
		, P.Status
	FROM PersonnelProject AS P
	
	UNION ALL
	
	SELECT T.PersonnelIDBackend
		, CASE 
			WHEN CHARINDEX('  ', PersonnelName) > 0
				THEN SUBSTRING(T.PersonnelName, 1, CHARINDEX('  ', PersonnelName) - 1)
			ELSE T.PersonnelName
			END LastName
		, CASE 
			WHEN CHARINDEX('  ', T.PersonnelName) > 0
				THEN TRIM(SUBSTRING(T.PersonnelName, CHARINDEX('  ', T.PersonnelName) + 1, len(T.PersonnelName)))
			ELSE NULL
			END AS FirstName
		, NULL
		, T.OfficeEmail
		, X.EmployeeOffice
		, T.ProjectsPreviousProjectName
		, T.ProjectsPreviousPrimaryCategory
		, T.ProjectsPreviousSecondaryCategory
		, 'Other'
		, T.ProjectsPreviousTotalAmount
		, CONCAT(T.ProjectsPreviousProjectName, 'Other', T.ProjectsPreviousTotalAmount)
		, T.ProjectsPreviousCompletionDate
		, SAT.Status
	FROM compass.previous_project_experience AS T
	LEFT JOIN PersonnelOffice AS X
		ON T.PersonnelIDBackend = X.PersonnelId
	LEFT JOIN dbo.HUB_PERSONNEL AS PE
		ON T.PersonnelIDBackend=PE.PersonnelId
	LEFT JOIN dbo.HSAT_PERSONNEL AS SAT
		ON PE.HUB_PERSONNEL_Hashkey=SAT.HUB_PERSONNEL_Hashkey
	WHERE T.ProjectsPreviousProjectName IS NOT NULL  
	AND SAT.dvEndDateTime IS NULL
	),


SubMarketsConcat AS(
   SELECT innerQuery.ProjectNumber, STRING_AGG(innerQuery.SecondaryCategoryName, ', ') AS Concatenated_SubMarkets
   FROM
   		(
   			SELECT	UnionTable.SecondaryCategoryName
   				,UnionTable.ProjectNumber
   			FROM	UnionTable
   			GROUP BY UnionTable.SecondaryCategoryName
   				,UnionTable.ProjectNumber
   		) AS innerQuery
   GROUP BY	innerQuery.ProjectNumber
),

AllConcat AS(
   SELECT innerQuery1.ProjectNumber, STRING_AGG(innerQuery1.CategoryName, ', ') AS Concatenated_Markets, MAX(S.Concatenated_SubMarkets) AS Concatenated_SubMarkets
   FROM
   		(
   			SELECT	UnionTable.CategoryName
   				,UnionTable.ProjectNumber
   			FROM	UnionTable
   			GROUP BY UnionTable.CategoryName
   				,UnionTable.ProjectNumber
   		) AS innerQuery1
    LEFT JOIN SubMarketsConcat AS S
    ON innerQuery1.ProjectNumber=S.ProjectNumber
   GROUP BY	innerQuery1.ProjectNumber)

   SELECT U.PersonnelID
		, U.LastName
		, U.FirstName
		, U.Title
		, U.OfficeEmail
		, U.EmployeeOffice
		, U.Description
		, U.CategoryName 
		, U.SecondaryCategoryName 
		, U.Company
		, U.JobCost
		, U.ProjectNumber
		, U.CompletionDate
		, U.Status
		, A.Concatenated_Markets
		, A.Concatenated_SubMarkets
   FROM UnionTable AS U
   LEFT JOIN AllConcat AS A
   ON U.ProjectNumber=A.ProjectNumber
   WHERE U.Description <> '' 
