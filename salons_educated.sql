
select  
SLN.id as "ecad_salon_id",  
trim (concat(SLN.id, '-', sln.name, '. ', SLN.address, '. ', sln.city_name_geographic)) as "salon_name", 
sln.city_name, 
sln.com_mreg as com_MREG,

(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id and smr.closed_at is not Null
where sln.id = usr.salon_id  or sln.salon_manager_id = usr.id) as "U_ALLTIME",

 
(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id and extract(year from smr.started_at) = '2015' and smr.closed_at is not Null
where sln.id = usr.salon_id or sln.salon_manager_id = usr.id) as "U_2015",

(select Count( distinct usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null
where sln.id = usr.salon_id or sln.salon_manager_id = usr.id ) as "U_2016",

(select Count(usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id
    left join seminars as smr on smu.seminar_id = smr.id and  smr.closed_at is not Null
where sln.id = usr.salon_id  or sln.salon_manager_id = usr.id ) as "C_ALLTIME",

 
(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id and extract(year from smr.started_at) = '2015' and smr.closed_at is not Null
where sln.id = usr.salon_id or sln.salon_manager_id = usr.id ) as "C_2015",

(select Count( usr.id ) from  seminar_users as smu
    left join users as usr on usr.id = smu.user_id 
    left join seminars as smr on smu.seminar_id = smr.id and extract(year from smr.started_at) = '2016' and smr.closed_at is not Null
where sln.id = usr.salon_id or sln.salon_manager_id = usr.id ) as "C_2016",

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

sln.show_on_locator, 
sln.com_sect, 
sln.com_reg, 
sln.city_name_geographic, 
(case when sln.is_closed = 't' then 0 else 1 end),  
sln.client_type,
spp.status as ClubStatus,
spse.status as EmotionStatus

from salons as SLN

left join 
	dblink('dbname=academie', 
	'select spcr.status as status, spc.id as id, spc.name as name, spc.brand_id as brand_id, spcr.salon_id as salon_id

	from special_program_club_records as spcr
	left join special_program_clubs as spc ON spcr.club_id = spc.id') AS spp (status  text, id integer, name text, brand_id  integer, salon_id  integer )
	ON
	sln.id = spp.salon_id and spp.brand_id =  

(Case current_database()
                When 'loreal' then 1
                When 'matrix' then 5
                When 'luxe' then 6
                When 'redken' then 7
                When 'essie' then 3
                End)
	and 
		(case  when spp.name like '%Expert%' then spp.status
			    when spp.name like '%МБК%' then   spp.status
				end)  in ('accepted', 'invited' )

left join 
	dblink('dbname=academie', 
	'select spcr.status as status, spc.id as id, spc.name as name, spc.brand_id as brand_id, spcr.salon_id as salon_id

	from special_program_club_records as spcr
	left join special_program_clubs as spc ON spcr.club_id = spc.id') AS spse (status  text, id integer, name text, brand_id  integer, salon_id  integer )
	ON
	sln.id = spse.salon_id and spse.brand_id =  

(Case current_database()
                When 'loreal' then 1
                When 'matrix' then 5
                When 'luxe' then 6
                When 'redken' then 7
                When 'essie' then 3
                End)
	and 
		(case  when spse.name like '%Emotion%' then spse.status
				end)  in ('accepted', 'invited' )