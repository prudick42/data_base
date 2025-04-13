--Найти всех клиентов женского пола, родившихся после 1990 года.
SELECT * FROM Clients 
WHERE gender = 'Женский' AND birthdate > '1990-01-01';

--Вывести тренеров, у которых количество проведенных тренировок превышает 3, с указанием их специализации.
SELECT T.full_name, T.specialization, COUNT(TS.session_id) AS total_sessions 
FROM Trainers T 
LEFT JOIN TrainingSessions TS ON T.trainer_id = TS.trainer_id 
GROUP BY T.trainer_id, T.full_name, T.specialization 
HAVING COUNT(TS.session_id) > 3 
ORDER BY total_sessions DESC;

--Вывести специализации тренеров, где средний стаж превышает 5 лет.
SELECT specialization, AVG(experience_years) AS avg_experience 
FROM Trainers 
GROUP BY specialization 
HAVING AVG(experience_years) > 5;

--Вывести самые дорогие типы абонементов
SELECT * FROM Memberships 
ORDER BY price DESC 
LIMIT 5;

--Получить список активных абонементов клиентов с их ФИО.
SELECT C.full_name, M.name AS membership_name 
FROM ClientMemberships CM 
INNER JOIN Clients C ON CM.client_id = C.client_id 
INNER JOIN Memberships M ON CM.subscription_id = M.subscription_id 
WHERE CM.status = 'Активен';

--Найти клиентов, которые оплатили абонементы дороже 7000 рублей.
SELECT * FROM Clients 
WHERE client_id IN (
    SELECT client_id FROM Payments 
    WHERE amount > 7000
);

--Ранжировать тренеров по стажу в рамках их специализации.
SELECT full_name, specialization, experience_years,
       RANK() OVER (PARTITION BY specialization ORDER BY experience_years DESC) AS rank 
FROM Trainers;

--Найти клиентов, у которых есть хотя бы одна тренировка по боксу.
SELECT * FROM Clients C 
WHERE EXISTS (
    SELECT 1 FROM TrainingSessions TS 
    WHERE TS.client_id = C.client_id AND TS.type = 'Бокс'
);

--Для каждого клиента вывести дату следующей тренировки на основе его расписания.
SELECT full_name, current_session_date, next_session_date 
FROM (
    SELECT 
        C.full_name, 
        TS.date AS current_session_date, 
        LEAD(TS.date) OVER (
            PARTITION BY TS.client_id 
            ORDER BY TS.date
        ) AS next_session_date 
    FROM TrainingSessions TS 
    INNER JOIN Clients C ON TS.client_id = C.client_id 
) AS subquery 
WHERE next_session_date IS NOT NULL 
ORDER BY full_name, current_session_date;

-- Для каждого клиента вывести общую сумму его платежей
SELECT 
    C.client_id,
    C.full_name,
    (SELECT SUM(amount) 
     FROM Payments P 
     WHERE P.client_id = C.client_id) AS total_paid
FROM Clients C;