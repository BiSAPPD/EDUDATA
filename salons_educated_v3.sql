---internal выводит структуру регионов сотурудников обучения сom и edu 
with 
internal as (
select 
	rgn.id as region_id, rgn.name as region_name, rgn.brand_id, rgn.region_level, rgn.structure_type, rgn.is_blocked, rgn.code as region_code, rgn.status as region_status, rgn.education_region_id,
	usr.id as user_id, usr.last_name || ' ' || usr.first_name as full_name,  usr.email, usr.mobile_number, usr.city
from regions as rgn
	left join user_post_brands as upb on rgn.id = upb.region_id
	left join user_posts as usp on usp.id = upb.user_post_id
	left join users as usr on usp.user_id = usr.id),
---internal_hrr выводит структру с вышестоящими регионами на три уровня выше
internal_hrr as (
select 
	distinct inte.brand_id, inte.region_level, inte.structure_type, 
	inte.user_id, inte.full_name,  inte.email, inte.mobile_number, inte.city, 
	l5.user_id as "n1_user_id", l5.full_name as "n1_full_name", 
	l4.user_id as "n2_user_id", l4.full_name as "n2_full_name", 
	l3.full_name as "n3_full_name"
from internal as inte
	left join region_hierarchies as rgh5 on rgh5.descendant_id = inte.region_id and rgh5.generations = 1
	left join internal as l5 on  rgh5.ancestor_id = l5.region_id
	left join region_hierarchies as rgh4 on rgh4.descendant_id = inte.region_id and rgh4.generations = 2
	left join internal as l4 on  rgh4.ancestor_id = l4.region_id
	left join region_hierarchies as rgh3 on rgh3.descendant_id = inte.region_id and rgh3.generations = 3
	left join internal as l3 on  rgh3.ancestor_id = l3.region_id),
---выводит регионы для связки салона и коммерции на уровне представителя. 
region_srep as (
select 
	brd."name" as brand, 
	rgn.id as com_ter_id, rgn.name as com_ter_name, rgn.code as com_ter_code, rgn.status as ter_status, 
	rgn1.id as com_reg_id, rgn1.name as com_reg_name, rgn1.code as com_reg_code, rgn1.status as reg_status, 
	rgn2.id as com_mreg_id, rgn2.name as com_mreg_name, rgn2.code as com_mreg_code, rgn2.status as mreg_status, 
	rgn1.education_region_id as edu_reg_id, rgn1_edu."name" as edu_reg_name,
	rgn2_edu.id as edu_mreg_id, rgn2_edu."name" as edu_mreg_name
from regions as rgn
	left join regions as rgn1 on rgn.parent_id = rgn1.id
	left join regions as rgn2 on rgn1.parent_id = rgn2.id
	left join regions as rgn1_edu on rgn1.education_region_id = rgn1_edu.id
	left join regions as rgn2_edu on rgn1_edu.parent_id = rgn2_edu.id
	left join brands as brd on rgn.brand_id = brd.id
where rgn.region_level = 6 and rgn.structure_type = 1),
---salon_regions - связка салона с регионом коммерции и обучения
salons_rgn as (
select 
	sln.id, rgu.brand, sln."name" ||'. '|| sln.address || '. ' || sln.city as salon_name,   sln.city,  slt."name" as salon_type, 
	rgu.com_ter_id as com_ter_id, rgu.com_ter_name as com_ter_name, 
	rgu.com_reg_id as com_reg_id, rgu.com_reg_name as com_reg_name, 
	rgu.com_mreg_id as com_mreg_id, rgu.com_mreg_name as com_mreg_name, 
	rgu.edu_reg_id as edu_reg_id, rgu.edu_reg_name as edu_reg_name,
	rgu.edu_mreg_id as edu_mreg_id, rgu.edu_mreg_name as edu_mreg_name
from  salons as sln 
	left join salon_types as slt on sln.salon_type_id = slt.id
	left join regions_salons as rgs on sln.id = rgs.salon_id
	left join region_srep as rgu on rgs.region_id = rgu.com_ter_id
order by sln.id),
--- подсчет участников семинара
participations_count as(
select 
	prt.seminar_event_id, count(distinct prt.user_id) as user_count
from participations as prt
group by prt.seminar_event_id),
---салоны участников
participations_nobrand_salons as (
	select distinct  usr_sln.salon_id,  sln_user.com_mreg_name 
	from participations as prt
		left join seminar_events as sme on sme.id = prt.seminar_event_id
		left join seminars as smr on sme.seminar_id = smr.id
		left join users_salons as usr_sln on prt.user_id = usr_sln.user_id
		left join brands as brn on smr.brand_id = brn.id
		left join salons_rgn as sln_user on usr_sln.salon_id = sln_user.id and brn."name" <> sln_user.brand
	where sln_user.com_mreg_name is not null and sln_user.com_mreg_name not like 'МегаТест'),
--
payments_usr as (
select 
	ord.item_id, ord.base_cost, ord.cost, pmt.amount
from orders as ord
left join payments as pmt on ord.id = pmt.order_id
where ord.item_type = 'Participation'),
---salons_educated
salons_educated as(
	select
		sme.started_at::timestamp at time zone 'UTC' as started_ar,
		brn.code as brand_code,
		prt.user_id,
	    usr_sln.salon_id,
	    smr_kpi."name",
	    smr."name"
	from participations as prt
		left join seminar_events as sme on sme.id = prt.seminar_event_id
		left join seminars as smr on sme.seminar_id = smr.id
		left join brands as brn on smr.brand_id = brn.id
		left join users_salons as usr_sln on prt.user_id = usr_sln.user_id
		left join seminar_kpis_types as smr_kpi on smr.seminar_kpis_type_id = smr_kpi.id
	where usr_sln.salon_id is not null and brn.code is not null 
	group by sme.started_at::timestamp at time zone 'UTC', brn.code, prt.user_id, usr_sln.salon_id, smr_kpi."name", smr."name")
---
---
select 
	 usr_sln.salon_id,
	 sln_edu.brand_code,
	 (select count(sln1.user_id) from salons_educated as sln1 where sln1.salon_id = sln.id and sln1.brand_code = sln_edu.brand_code)
	--(case when brn.code is not null then brn.code else smrkt."name" end) as brand
	--sme.started_at::timestamp at time zone 'UTC') as Day, 
from salons as sln
	left join users_salons as usr_sln on sln.id = usr_sln.salon_id
	left join (select distinct salon_id, brand_code from salons_educated where brand_code is not null) as sln_edu on sln.id = sln_edu.salon_id
	left join salons_educated as sln_edu_all_time on sln.id = sln_edu_all_time.salon_id and 
	

	
where
	usr_sln.salon_id is not Null
	--to_char(sme.started_at::timestamp at time zone 'UTC','YYYY') in ('2017', '2016') and  
	--to_char(sme.started_at::timestamp at time zone 'UTC','MM') in ('07') and 
	--and brn."name" is not null and 
	--and brn.code = 'LP' 
  	--inte.n1_full_name is not null and
	--inte.n3_full_name is not null and 
	-- sme.studio_id is null
	--and sln_user.com_mreg_name is null 
	--and usr_sln.salon_id in (3023)
--order by sme.started_at, sme.id, prt.id



select 
	usr_sln.salon_id, 
	brn.code, 
		(select Count(prt.user_id) from users_salons as usr_sln1  )  as "usr_alltime"
from participations as prt
	left join seminar_events as sme on sme.id = prt.seminar_event_id
	left join seminars as smr on sme.seminar_id = smr.id
	left join brands as brn on smr.brand_id = brn.id
	left join users_salons as usr_sln on prt.user_id = usr_sln.user_id
where usr_sln.salon_id is not null and brn.code is not null
group by usr_sln.salon_id, brn.code, sme.started_at::timestamp at time zone 'UTC'






select distinct
	sme.started_at::timestamp at time zone 'UTC' as started_ar,
	brn.code,
	prt.user_id,
    usr_sln.salon_id,
    smr_kpi."name",
    smr."name"
from participations as prt
	left join seminar_events as sme on sme.id = prt.seminar_event_id
	left join seminars as smr on sme.seminar_id = smr.id
	left join brands as brn on smr.brand_id = brn.id
	left join users_salons as usr_sln on prt.user_id = usr_sln.user_id
	left join seminar_kpis_types as smr_kpi on smr.seminar_kpis_type_id = smr_kpi.id
where usr_sln.salon_id is not null and brn.code is not null 
group by sme.started_at::timestamp at time zone 'UTC', brn.code, prt.user_id, usr_sln.salon_id, smr_kpi."name", smr."name"



