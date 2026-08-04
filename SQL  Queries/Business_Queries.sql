-- ================================================================
-- SECTIION 1 : Database Setup
-- ================================================================
create database Healthcare_Project ;
use healthcare_project ;

-- ================================================================
-- SECTION 2 : Exploratory Data Analysis (EDA)
-- ================================================================

--  total number of registered patients
select count(*) as total_patients
from patients;

-- Total Number of Doctors Available
select count(*) from doctors;

--  Available Medical Specializations
select distinct specialization from doctors;

-- Available Medical Specializations
select distinct specialization from doctors;

-- ================================================================
-- SECTION 3: Patient Analysis
-- ================================================================

-- Recently Registered Patients (Last 30 Days)
select * from patients
where registration_date >= (select max(registration_date) - interval 30 day from patients)
order by registration_date desc;

-- Patient Distribution by Address
select address, count(*) as patient_count
from patients
group by address
order by patient_count desc;

-- Patient Age Distribution
select patient_id, first_name, gender,
TIMESTAMPDIFF(YEAR, date_of_birth, curdate()) as age
from patients;

-- Patient Segmentation by Age Group
select 
case
	when timestampdiff(YEAR, date_of_birth, CURDATE()) < 18 THEN 'UNDER 18'
    when timestampdiff(YEAR, date_of_birth, CURDATE()) BETWEEN 18 and 35 THEN 'Adults'
    when timestampdiff(YEAR, date_of_birth, CURDATE()) BETWEEN 36 and 55 THEN 'Matured'
    ELSE 'SENIORS'
end as age_group,
count(*) as patient_count
from patients
group by age_group
order by patient_count desc;

-- Most Common Email Domains
select substring_index(email, '@', -1) as email_domain,
count(*) as patient_count
from patients
group by email_domain;

-- Monthly Patient Registration Trend
select year(registration_date) as year,
month(registration_date) as month,
count(*) as patient_count
from patients
group by year, month;

-- ================================================================
-- SECTION 4: Doctor Analysis
-- ================================================================

-- Doctor Experience Ranking
select concat(first_name, ' ', last_name) as doctor_name,
specialization, years_experience
from doctors
order by years_experience desc;

-- Specialization Demand Based on Appointment Volume
select d.specialization,
count(a.appointment_id) as total_appointments
from appointments a
join doctors d
on a.doctor_id = d.doctor_id
group by d.specialization;

-- Senior vs Junior Doctors by Specialization
-- > 15 years--senior
select specialization,
count(*) as total_doctors,
SUM(CASE WHEN years_experience >= 15 THEN 1 ELSE 0 END) AS senior_doctors,
SUM(CASE WHEN years_experience < 15 THEN 1 ELSE 0 END) AS junior_doctors
from doctors
group by specialization;

-- Doctor Workload Analysis
SELECT
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
  d.specialization,
  COUNT(a.appointment_id) AS total_appointments
from doctors d
left join appointments a
on d.doctor_id = a.doctor_id
group by d.doctor_id, doctor_name, d.specialization
order by total_appointments;

-- doctor utilization rate 
select concat(d.first_name," ",d.last_name) as doctor_name ,
count(a.appointment_id) as Total_appoinment,
round((count(a.appointment_id) / 1000.0) *100,2) as utilization_percent
from doctors d 
join appointments a 
on d.doctor_id = a.doctor_id 
group by doctor_name
order by utilization_percent desc;

-- ================================================================
-- SECTION 5: Appointment Analysis
-- ================================================================
-- Appointment Status Distribution
select status, count(*) from appointments
group by status;

-- Appointment Statuses with More Than 50 Records
select status, count(*) from appointments
group by status
having count(*) > 50; 

-- Recent Appointments (Last 7 Days)
select * from appointments
where appointment_date >= (select max(appointment_date) - INTERVAL 7 day from appointments)
order by appointment_date desc;

-- Date-wise Appointment Status Trend
select appointment_date, status, count(*)
from appointments
group by appointment_date, status
order by appointment_date desc;

-- cancellation rate 
with cte_status_percent as (
   select status ,
    count(*)  as status_count
    from appointments
    group by status)
select status , 
status_count ,
round( (status_count /sum(status_count) over())*100 ) as percentage
from cte_status_percent
order by percentage desc ;

-- Monthly appointment trend
select 
year(appointment_date) as year,
month(appointment_date) as month,
count(*) as appointment_count
from appointments
group by year, month
order by year, month;

-- ================================================================
-- SECTION 6: Treatment Analysis
-- ================================================================
-- Most common treatment_type
select treatment_type, count(*) as treatment_count
from treatments
group by treatment_type
order by treatment_count desc;

-- Treatment Cost Analysis (Min, Max & Average)
select min(cost) as min_cost, max(cost) as max_cost, round(avg(cost), 1) as avg_cost
from treatments;

-- Revenue Contribution by Treatment Type
with cte_treatment_revenue as (
   select treatment_type , sum(amount) as total_revenue
   from billing b
   join treatments t 
   on b.treatment_id = t.treatment_id 
   group by treatment_type )
select
   treatment_type,
   total_revenue,
   round(total_revenue*100.0/
   sum(total_revenue) over(),2
   ) as revenue_contribution_percentage
from cte_treatment_revenue
order by revenue_contribution_percentage desc 
;

-- Treatment Cost Outlier Detection
select treatment_id,
treatment_type,
cost
from treatments
where cost > (select avg(cost) + 2 *stddev(cost) from treatments);

-- ================================================================
-- SECTION 7: Billing & Revenue Analysis
-- ================================================================
-- PAYMENT STATUS DISTRIBUTION
SELECT payment_status, COUNT(*) AS bill_count
FROM billing
GROUP BY payment_status;

-- Total Revenue Generated
select sum(amount) as total_revenue
from billing
where payment_status = 'Paid';

-- Top Revenue Contributing Patients
SELECT
p.patient_id,
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
SUM(b.amount) AS total_spent
from patients p
join billing b
on p.patient_id = b.patient_id
where b.payment_status = 'Paid'
GROUP BY p.patient_id, patient_name
ORDER BY total_spent DESC;

-- Top 10% high Spending Pateints
with cte_total_rev_pat as (
     select p.patient_id ,
     concat(p.first_name,"  ",p.last_name) as patient_name,
     sum(b.amount)as total_amount
from patients p
join billing b
on p.patient_id = b.patient_id 
where b.payment_status = 'Paid'
group by p.patient_id , patient_name
),
cte_rank as (
   select * ,
         Ntile(10) over(order by total_amount desc ) as patient_bucket
         from cte_total_rev_pat
)
select 
   patient_id ,
   patient_name,
   total_amount
from cte_rank 
where patient_bucket = 1
order by total_amount desc;

-- Monthly revenue trend
select 
year(bill_date) as year,
month(bill_date) as month,
sum(amount) as total_revenue
from billing
where payment_status = 'Paid'
group by year, month
order by year, month;

-- Running Revenue Analysis
with monthly_revenue as (
    select
	YEAR(bill_date) AS year,
	MONTH(bill_date) AS month,
	SUM(amount) AS monthly_revenue
    FROM billing
    WHERE payment_status = 'Paid'
    GROUP BY YEAR(bill_date), MONTH(bill_date)
)
SELECT
    year,
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY year, month
    ) AS running_revenue
FROM monthly_revenue;

-- ================================================================
-- SECTION 8: Customer Segmentation
-- ================================================================
-- RFM Segmentation 
-- Recency, Frequency and Monetary
-- Create RFM metrcis per patient using: last_visit, total_visit, paid_spend
-- label "champions", "Loyal high value", "risk"
WITH rfm AS (
  SELECT
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    MAX(a.appointment_date) AS last_visit,
    COUNT(DISTINCT a.appointment_id) AS frequency,
    COALESCE(SUM(CASE WHEN b.payment_status='Paid' THEN b.amount END),0) AS monetary
  FROM patients p
  LEFT JOIN appointments a ON a.patient_id = p.patient_id
  LEFT JOIN billing b ON b.patient_id = p.patient_id
  GROUP BY p.patient_id, patient_name
),
scored AS (
  SELECT
    *,
    DATEDIFF(CURDATE(), last_visit) AS recency_days,
    NTILE(4) OVER (ORDER BY DATEDIFF(CURDATE(), last_visit) ASC) AS r_score, -- lower recency better
    NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
  FROM rfm
)
SELECT
  patient_id, patient_name,
  recency_days, frequency, monetary,
  r_score, f_score, m_score,
  CONCAT(r_score,f_score,m_score) AS rfm_code,
  CASE
    WHEN r_score >=3 AND f_score >=3 AND m_score >=3 THEN 'Champions'
    WHEN f_score >=3 AND m_score >=3 THEN 'Loyal High Value'
    WHEN r_score <=2 AND f_score <=2 THEN 'At Risk / Inactive'
    WHEN f_score >=3 THEN 'Frequent Visitors'
    WHEN m_score >=3 THEN 'High Spenders'
    ELSE 'Regular'
  END AS segment
FROM scored
ORDER BY monetary DESC, frequency DESC;

-- ================================================================
-- SECTION 9: Business Intelligence Views
-- ================================================================
-- Patient Journey Master Table
-- (Appointment → Treatment → Billing)
SELECT
  p.patient_id,
  CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  a.appointment_id,
  a.appointment_date,
  a.status AS appointment_status,
  t.treatment_id,
  t.treatment_type,
  t.cost AS treatment_cost,
  b.bill_id,
  b.amount AS billed_amount,
  b.payment_status
FROM patients p
JOIN appointments a
  ON p.patient_id = a.patient_id
LEFT JOIN treatments t
  ON a.appointment_id = t.appointment_id
LEFT JOIN billing b
  ON t.treatment_id = b.treatment_id
ORDER BY p.patient_id, a.appointment_date;




-------------------------------------------------------------------
select * from patients ;
select * from doctors ;
select * from treatments ;
select * from appointments;
select * from billing ;

