WITH Courses AS(
    SELECT E.user_id
    , E.name
    , E.status
    , CONVERT(DATE, E.enroll_date_of_enrollment, 23) AS enroll_date_of_enrollment
    , CONVERT(DATE, E.course_complete_date, 23) AS course_complete_date
    , E.total_time
    , X.title AS Certification
    , 'Course' AS 'Type'
    , X.duration
    , X.duration_unit
    , C.credits
    FROM docebo.enrollment AS E
    LEFT JOIN docebo.courses AS C
    ON E.uidCourse=C.uidCourse
    LEFT JOIN docebo.certifications AS X
    ON C.code = X.code AND C.code != ''


),

ExternalTraining AS(
    SELECT X.user_id
    , X.course_name
    , 'completed' AS status
    , CONVERT(DATE, X.from_date,23) AS enrollment_date
    , CONVERT(DATE, X.to_date, 23) AS completed_date
    , NULL AS total_time
    , C.title AS Certification
    , 'External Training' AS 'Type'
    , C.duration
    , C.duration_unit
    , X.CEUs
    FROM docebo.external_training AS X
    LEFT JOIN docebo.certifications AS C 
    ON X.certification = C.id_cert
    UNION ALL
     SELECT R.user_id
    , R.name
    , R.status
    , R.enroll_date_of_enrollment 
    , R.course_complete_date
    , R.total_time
    , R.Certification
    , R.Type
    , R.duration
    , R.duration_unit
    , R.credits
    FROM Courses AS R
)
--Should only include users whose status=1 Probably.
   
SELECT U.fullname
, U.is_manager
, U.[manager_names.1.manager_name] AS Manager
, X.course_name
, X.status 
, X.enrollment_date
, X.completed_date 
,  X.total_time
, X.Certification
, X.Type 
, X.duration 
, X.duration_unit
, CASE 
    WHEN X.duration_unit='year' AND Certification IS NOT NULL AND X.duration != 0 AND X.duration IS NOT NULL AND X.completed_date IS NOT NULL  THEN DATEADD(year, CAST(X.duration AS int), CAST(X.completed_date  AS DATE ))
    WHEN X.duration_unit='day' AND Certification IS NOT NULL AND X.duration != 0 AND X.duration IS NOT NULL AND X.completed_date IS NOT NULL  THEN DATEADD(day, CAST(X.duration AS int),  CAST(X.completed_date AS DATE))
    WHEN X.duration=0 AND Certification IS NOT NULL THEN '0001-01-01'
    ELSE NULL END AS Expiration_Date
, X.CEUs
FROM ExternalTraining AS X
LEFT JOIN docebo.users AS U 
ON X.user_id=U.user_Id





-- select completed_date
-- FROM ExternalTraining
-- WHERE completed_date is NOT NULL AND TRY_CONVERT(date, [completed_date], 23) is null


