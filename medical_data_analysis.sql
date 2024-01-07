Task 1: Average Hospital Charges Analysis
SELECT Avg(charges)
FROM   hospitalization_details;

Task 2: High Charges Analysis
SELECT customer_id,
       year,
       charges
FROM   hospitalization_details
WHERE  charges > 700; 

Task 3: High BMI Patients Analysis
SELECT names.NAME,
       hospitalization_details.year,
       hospitalization_details.charges
FROM   names
       INNER JOIN hospitalization_details
               ON names.customer_id = hospitalization_details.customer_id
       INNER JOIN medical_examinations
               ON medical_examinations.customer_id = names.customer_id
WHERE  medical_examinations.bmi > 35

Task 4: Customers with Major Surgeries
SELECT names.customer_id,
       names.NAME
FROM   names
       INNER JOIN medical_examinations
               ON names.customer_id = medical_examinations.customer_id
WHERE  medical_examinations.numberofmajorsurgeries >= 1 

Task 5: Average Charges by Hospital Tier in 2000
SELECT hospital_tier,
       Avg(charges)
FROM   hospitalization_details
WHERE  year = 2000
GROUP  BY hospital_tier 

Task 6: Smoking Patients with Transplants Analysis
SELECT hospitalization_details.customer_id,
       medical_examinations.bmi,
       hospitalization_details.charges
FROM   hospitalization_details
       INNER JOIN medical_examinations
               ON hospitalization_details.customer_id =
                  medical_examinations.customer_id
WHERE  smoker = 'yes'
       AND any_transplant = 'yes' 

Task 7: Patients with Major Surgeries or Cancer History
SELECT names.NAME
FROM   names
       INNER JOIN medical_examinations
               ON names.customer_id = medical_examinations.customer_id
WHERE  numberofmajorsurgeries >= 2
        OR cancer_history = 'yes' 

Task 8: Customer with Most Major Surgeries¶
SELECT names.customer_id,
       names.name
FROM   names
       INNER JOIN medical_examinations
               ON names.customer_id = medical_examinations.customer_id
ORDER  BY numberofmajorsurgeries DESC
LIMIT  1 

Task 9: Customers with Major Surgeries and City Tiers
SELECT names.customer_id,
       names.NAME,
       hospitalization_details.city_tier
FROM   names
       INNER JOIN hospitalization_details
               ON names.customer_id = hospitalization_details.customer_id
       INNER JOIN medical_examinations
               ON names.customer_id = medical_examinations.customer_id
WHERE  numberofmajorsurgeries > 0 

Task 10: Average BMI by City Tier in 1995
SELECT hospitalization_details.city_tier,
       Avg(medical_examinations.bmi) AS avg_bmi
FROM   hospitalization_details
       INNER JOIN medical_examinations
               ON hospitalization_details.customer_id =
                  medical_examinations.customer_id
WHERE  year = 1995
GROUP  BY hospitalization_details.city_tier 

Task 11: High BMI Customers with Health Issues
SELECT names.customer_id,
       names.NAME,
       hospitalization_details.charges
FROM   names
       INNER JOIN hospitalization_details
               ON names.customer_id = hospitalization_details.customer_id
       INNER JOIN medical_examinations
               ON names.customer_id = medical_examinations.customer_id
WHERE  health_issues = 'yes'
       AND bmi > 30

Task 12: Customers with Highest Charges and City Tier by Year
SELECT hd.year,
       n.NAME,
       hd.city_tier,
       Max(hd.charges) AS max_charges
FROM   hospitalization_details hd
       INNER JOIN names n
               ON hd.customer_id = n.customer_id
WHERE  ( hd.year, hd.charges ) IN (SELECT year,
                                          Max(charges) AS max_charges
                                   FROM   hospitalization_details
                                   GROUP  BY year)
GROUP  BY hd.year,
          n.NAME,
          hd.city_tier 

Task 13: Top 3 Customers with Highest Average Yearly Charges
WITH yearlycharges AS
(
         SELECT   customer_id,
                  Avg(charges) AS avg_yearly_charges
         FROM     hospitalization_details
         GROUP BY customer_id,
                  year )
SELECT     n.NAME,
           Max(avg_yearly_charges) AS highest_avg_yearly_charges
FROM       names n
INNER JOIN yearlycharges yc
ON         n.customer_id = yc.customer_id
GROUP BY   n.NAME
ORDER BY   highest_avg_yearly_charges DESC limit 3;

Task 14: Ranking Customers by Total Charges
SELECT names.NAME,
       Sum(hospitalization_details.charges)                    AS total_charges,
       Rank()
         OVER (
           ORDER BY Sum(hospitalization_details.charges) DESC) AS charges_rank
FROM   hospitalization_details
       INNER JOIN names
               ON hospitalization_details.customer_id = names.customer_id
GROUP  BY names.NAME
ORDER  BY charges_rank DESC

Task 15: Identifying Peak Year for Hospitalizations
WITH yearlyhospitalizations
     AS (SELECT year,
                Count(*) AS hospitalization_count
         FROM   hospitalization_details
         GROUP  BY year)
SELECT year,
       hospitalization_count
FROM   yearlyhospitalizations
WHERE  hospitalization_count = (SELECT Max(hospitalization_count)
                                FROM   yearlyhospitalizations)
