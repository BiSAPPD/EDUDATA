
WITH programs as (

select *
from dblink('dbname=academie user=readonly password=sdfm6234vsj', 
	'select spcr.status as status, spc.id as id, spc.name as name, spc.brand_id as brand_id, 
	(Case spc.brand_id
			When 1 then ''loreal'' 
			When 5 then ''matrix''
			When 6 then ''luxe''
			When 7 then ''redken''
			When 3 then ''essie''
		        End) as brand,
	spcr.salon_id as salon_id

	from special_program_club_records as spcr
	left join special_program_clubs as spc ON spcr.club_id = spc.id') AS spp (status  text, id integer, name_prog text, brand_id  integer, brand text, salon_id  integer )

where spp.brand_id = 

(Case current_database()
                When 'loreal' then 1
                When 'matrix' then 5
                When 'luxe' then 6
                When 'redken' then 7
                When 'essie' then 3
               End)


)

, club_py_clb as (
select *
from programs 
where name_prog like '%2016%' and 
	(Case when name_prog like '%Expert%' then 1 else
		(case when name_prog like '%МБК%' then 1  else
			(case when name_prog like '%Селективное Соглашение%' then 1 else 0 end ) end) end) = 1
)
, club_ty_clb as (
select * 
from programs 
where name_prog like '%2017%' and 
	(Case when name_prog like '%Expert%' then 1 else
		(case when name_prog like '%МБК%' then 1  else
			(case when name_prog like '%Селективное Соглашение%' then 1 else 0 end ) end) end) = 1
)

, club_py_emt as (
select *
from programs 
where name_prog like '%2016%' and name_prog like '%Emotion%'
)
, club_ty_emt as (
select *
from programs 
where name_prog like '%2017%' and name_prog like '%Emotion%'
)



select  
SLN.id as "ecad_salon_id",  
trim (concat(SLN.id, '-', sln.name, '. ', SLN.address, '. ', sln.city_name_geographic)) as "salon_name", 
(case when sln.is_closed = 't' then 0 else 1 end) as "isOpen",  
sln.client_type,

(CASE when clt.name_prog like '%Expert%' then clt.status else
   (CASE when clt.name_prog like '%МБК%' then clt.status Else 
	(CASE when clt.name_prog like '%Соглашение%' then clt.status End)End)End) as club_ty,
(CASE when clp.name_prog like '%Expert%' then clp.status else
   (CASE when clp.name_prog like '%МБК%' then clp.status Else 
	(CASE when clp.name_prog like '%Соглашение%' then clp.status End)End)End) as club_py,

(CASE when clt_em.name_prog like '%Emotion%' then clt_em.status End) as emotion_ty,
(CASE when clp_em.name_prog like '%Emotion%' then clp_em.status End) as emotion_py,



(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
where sln.id = usr.salon_id  or sln.salon_manager_id = usr.id  and smr.closed_at is not Null) as "unqUSR_ALLTIME",
 
(select Count( distinct usr.id ) from  seminars as smr
    left join seminar_users as smu on smu.seminar_id = smr.id 
    left join users as usr on smu.user_id  = usr.id 

where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id) and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null) as "unqUSR_PY",

(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id ) and extract(year from smr.started_at) = '2017' and smr.closed_at is not Null) as "unqUSR_TY",

(select Count(usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id
    left join seminars as smr on smu.seminar_id = smr.id
    where (sln.id = usr.salon_id  or sln.salon_manager_id = usr.id )and  smr.closed_at is not Null) as "CNT_ALLTIME",
 
(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id)  and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null) as "CNT_PY",

(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id)  and extract(year from smr.started_at) = '2017' and smr.closed_at is not Null) as "CNT_TY",

(select Count( distinct usr.id ) from  seminars as smr
    left join seminar_users as smu on smu.seminar_id = smr.id 
    left join users as usr on smu.user_id  = usr.id
    left join seminar_types as smt  ON smr.seminar_type_id = smt.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id) and smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "unqUSR_ALLTIME_exclCNSLT",

(select Count( distinct usr.id ) from  seminars as smr
    left join seminar_users as smu on smu.seminar_id = smr.id 
    left join users as usr on smu.user_id  = usr.id
    left join seminar_types as smt  ON smr.seminar_type_id = smt.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id) and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "unqUSR_PY_exclCNSLT",

(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id	
    left join seminar_types as smt ON smr.seminar_type_id = smt.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id ) and extract(year from smr.started_at) = '2017' and smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "unqUSR_TY_exclCNSLT",

(select Count(usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id
    left join seminars as smr on smu.seminar_id = smr.id
    left join seminar_types as smt ON  smr.seminar_type_id = smt.id
    where (sln.id = usr.salon_id  or sln.salon_manager_id = usr.id )and  smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "CNT_ALLTIME_exclCNSLT",
 
(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
    left join seminar_types as smt ON smr.seminar_type_id = smt.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id)  and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "CNT_PY_exclCNSLT",

(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id
    left join seminar_types as smt ON smr.seminar_type_id = smt.id
where (sln.id = usr.salon_id or sln.salon_manager_id = usr.id)  and extract(year from smr.started_at) = '2017' and smr.closed_at is not Null and smt.kpis_type in ('Seminars in Salon','Paid Seminars in Studio', 'Free Seminars in Studio')) as "CNT_TY_exclCNSLT",
	


(select Count( usr.id ) from users as usr
where sln.id = usr.salon_id ) as "Count_SLN_USRs",

(select Count( usr.id ) from users as usr
where sln.id = usr.salon_id and usr.last_request_at is not Null ) as "Count_actECAD_USRs",

(select Count(distinct usr.email ) from users as usr
where sln.id = usr.salon_id  ) as "Count_usr_email",

(select Count(distinct usr.mobile_number ) from users as usr
where sln.id = usr.salon_id  ) as "Count_usr_phone",

to_char(sln.created_at, 'DD.MM.YYYY')  as "add2ECAD",

(select usr.full_name from users as usr 
where sln.salon_manager_id = usr.id) as "Manager_SLN",

(select to_char(usr.last_request_at, 'DD.MM.YYYY')  from users as usr 
where sln.salon_manager_id = usr.id  and usr.last_request_at is not Null) as "Manager_SLN_last_accsess", 

(Select concat( smr.technolog_full_name, smr.partimer_full_name) from seminar_users as smu
    left join seminars as smr ON smr.id = smu.seminar_id
    Left join users as usr ON smu.user_id = usr.id
    left join salons as sln2 ON sln2.id = usr.salon_id
where sln.id = sln2.id
order by smr.started_at Desc
limit 1) as "last_educater_cont",


sln.city_name, 
sln.com_mreg as com_MREG,
sln.com_sect, 
sln.com_reg, 
sln.city_name_geographic



from salons as SLN
left join club_ty_clb  as clt ON 
	sln.id = clt.salon_id and clt.brand = current_database()  
left join club_py_clb  as clp ON 
	sln.id = clp.salon_id and clp.brand = current_database()

left join club_ty_emt  as clt_em ON 
	sln.id = clt_em.salon_id and clt_em.brand = current_database()
left join club_py_emt  as clp_em ON 
	sln.id = clp_em.salon_id and clp_em.brand = current_database()
