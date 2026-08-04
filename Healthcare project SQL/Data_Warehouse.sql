-- ================================================================
--  Healthcare Data Warehouse (Star Schema)
-- ================================================================
Use healthcare_project ;

-- ===========================================
-- Create Dimension Table : Patient
-- ===========================================
Create table dim_patient
(
   patient_key int auto_increment primary key,
   patient_id int,
   first_name varchar(50),
   last_name varchar(50),
   gender varchar(20),
   date_of_birth Date,
   contact_number varchar(50),
   address varchar (100),
   registration_date date,
   insurance_provider varchar(100),
   insurance_number varchar(50),
   email varchar(100)
);
insert into dim_patient
(
patient_id,
first_name,
last_name,
gender,
date_of_birth,
contact_number,
address,
registration_date,
insurance_provider,
insurance_number,
email
)
select 
patient_id,
first_name,
last_name,
gender,
date_of_birth,
contact_number,
address,
registration_date,
insurance_provider,
insurance_number,
email  from patients ;


-- ===========================================
-- Create Dimension Table : Doctor
-- ===========================================
create table dim_doctor
(
   doctor_key int auto_increment primary key ,
   doctor_id varchar(50),
   first_name varchar(50),
   last_name varchar(50),
   specialization varchar(50),
   years_experience int,
   hospital_branch varchar(50),
   phone_number int,
   email varchar(100)
);
insert into dim_doctor (
 doctor_id,
 first_name,
 last_name,
 specialization,
 years_experience,
 hospital_branch,
 phone_number,
 email )
select 
 doctor_id,
 first_name,
 last_name,
 specialization,
 years_experience,
 hospital_branch,
 phone_number,
 email from doctors;


-- ===========================================
-- Create Dimension Table : Treatment
-- ===========================================
create table dim_treatment
( 
  treatment_key int auto_increment primary key,
  treatment_id varchar(50),
  treatment_type varchar(50),
  description varchar(50)
);
insert into dim_treatment
( treatment_id,
  treatment_type,
  description)
  select treatment_id,
		 treatment_type,
         description from treatments;


-- ===========================================
-- Create Dimension Table : Date
-- ===========================================
create table dim_date 
(date_key int auto_increment primary key ,
 full_date date,
 day int,
 month int,
 month_name varchar(10),
 quarter int,
 year int ,
 weekday varchar(20) );

insert into dim_date (
   full_date,
   day ,
   month,
   month_name,
   quarter,
   year,
   weekday)
select distinct 
     appointment_date,
     day(appointment_date),
     month(appointment_date),
     monthname(appointment_date),
     concat('Q',quarter(appointment_date)),
     year(appointment_date),
     dayname(appointment_date) from appointments;
     
insert into dim_date (
   full_date,
   day ,
   month,
   month_name,
   quarter,
   year,
   weekday)
select distinct 
    bill_date,
    day(bill_date),
    month(bill_date),
    monthname(bill_date),
    concat('Q',quarter(bill_date)),
    year(bill_date),
    dayname(bill_date)
from billing
where bill_date not in (
      select full_date
      from dim_date );


-- ===========================================
-- Create Fact Table : Healthcare
-- ===========================================
create table fact_healthcare
(
fact_key int auto_increment primary key ,
appointment_id varchar(20),
bill_id varchar(20),
patient_key int,
doctor_key int,
treatment_key int,
date_key int,
appointment_status varchar(30),
payment_status varchar(30),
payment_method varchar(30),
appointment_time time,
reason_for_visit varchar(255),
treatment_cost decimal(10,2),
bill_amount decimal(10,2)
);

insert into fact_healthcare
(
   appointment_id,
   bill_id,
   patient_key,
   doctor_key,
   treatment_key,
   date_key,
   appointment_status,
   payment_status,
   payment_method,
   appointment_time,
   reason_for_visit,
   treatment_cost,
   bill_amount
)
select 
a.appointment_id,
b.bill_id,
dp.patient_key,
dd.doctor_key,
dt.treatment_key,
d.date_key,
a.status,
b.payment_status,
b.payment_method,
a.appointment_time,
a.reason_for_visit,
t.cost,
b.amount
    from appointments a
    join dim_patient dp
    on a.patient_id = dp.patient_id
    
    join dim_doctor dd
    on a.doctor_id = dd.doctor_id 
    
    left join treatments t
    on a.appointment_id = t.appointment_id
    
    left join dim_treatment dt
    on t.treatment_id = dt.treatment_id
    
    left join billing b 
    on t.treatment_id = b.treatment_id 
    
    left join dim_date d
    on a.appointment_date = d.full_date ;


select * from fact_healthcare;
select * from dim_date ;
select * from dim_treatment;
select * from dim_doctor;
select * from dim_patient;


SELECT treatment_key, COUNT(*)
FROM dim_treatment
GROUP BY treatment_key
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM dim_treatment;

SELECT COUNT(DISTINCT treatment_key)
FROM dim_treatment;









