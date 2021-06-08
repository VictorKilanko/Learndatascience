clear

if c(username)=="USER"{
	global raw_dta "C:\Users\USER\Desktop\Stata Class\Raw data"
	global analytical_dta "C:\Users\USER\Desktop\Stata Class\Analytical data"
	global do_file "C:\Users\USER\Desktop\Stata Class\Do-file"
	global logs "C:\Users\USER\Desktop\Stata Class\Logs"
	global tables "C:\Users\USER\Desktop\Stata Class\Tables"
}


****************************************
*Project: Assignment 1- Importing and Cleaning Data
*Done by: Victor Kilanko
*****************************************

cd "${raw_dta}"
import delimited "TXDPS-2015-Traffic_Stops (1).csv", clear stringcols (_all) delimiter (",") varnames (1) rowrange (1:1000000)
save traffic_stops.dta, replace //I am saving my working data in a stata format for easy call-up later- "traffic_stops.dta"
set more off


*Starting my first log
cd "${raw_dta}"
	use "traffic_stops.dta" //using my saved data in raw data folder
	
cd "${logs}" //specifying to open log folder and save logs in there
	log using econ020321, replace
		gen obs_num = _n

*To split variables by "-" so as to remove unwanted dashes and last 4 zeroes in zip codes etc.
		local dash_vars "ha_a_zip_drvr ha_a_zip_jge"
			foreach var of local dash_vars{
			split `var', p("-")
		}
	
	
*I will drop the last 4 zeroes just saved in new variables and the old variables
	drop ha_a_zip_drvr2 ha_a_zip_jge2 ha_a_zip_drvr ha_a_zip_jge
	
*Change variable labels for more clarity. I decided to do this singly to keep clean format of labels(starting with caps)
	label var ha_a_address_drvr "Driver's address"
	label var ha_a_address_jge "Judge's address"
	label var ha_a_city_drvr "Driver's city"
	label var ha_a_city_jge "Judge's city"
	label var ha_a_state_drvr "Driver's state"
	label var ha_a_state_jge "Judge's state"
	label var ha_a_zip_drvr1 "Driver's zipcode"
	label var ha_a_zip_jge1 "Judge's zipcode"
	label var ha_accident "Any accident?"
	label var ha_alleged_speed "Speed when stopped"
	label var ha_arrest_date "Arrest date"
	label var ha_arrest_key "Arrest key"
	label var ha_comm_vehicle "Commercial vehicle"
	label var ha_construction_zone "Construction zone"
	label var ha_contrab_currency "Contraband currency"
	label var ha_contrab_drugs "Contraband drugs"
	label var ha_contrab_other "Other contrabands found"
	label var ha_contrab_weapon "Contraband weapons"
	label var ha_contraban "Contrabands found"
	label var ha_county "County"
	label var ha_court "Court"
	label var ha_d_court "Court date"
	label var ha_day_of_week "Day of week"
	label var ha_district "District"
	label var ha_gvwr "Gvwr"
	label var ha_height "Driver's height"
	label var ha_incidto_arrest "Incidence b4 arrest"
	label var ha_int1 "Prior international arrest"
	label var ha_interstate "Prior interstate arrest"
	label var ha_intrastate "Prior intrastate arrest"
	label var ha_judge_key "Judge's key"
	label var ha_latitude "Stop latitude"
	label var ha_longitude "Stop longitude"
	label var ha_milepost "Milepost"
	label var ha_month "Stop month"
	label var ha_n_first_drvr "Driver's firstname"
	label var ha_n_judge "Judge's name"
	label var ha_n_last_drvr "Driver's lastname"
	label var ha_n_middle_drvr "Driver's middlename"
	label var ha_n_trooper "Arresting officer's name"
	label var ha_officer_id "Officer's id"
	label var ha_oth_conditions "Other conditions?"
	label var ha_oth_loc "Other locations?"
	label var ha_owner_lessee "Owner's lessee"
	label var ha_p_hm_drvr "Driver's phone no"
	label var ha_p_judge "Judge's phone no"
	label var ha_p_wk_drvr "Drivers per week"
	label var ha_passengers "Any passengers?"
	label var ha_posted_speed "Posted speed"
	label var ha_precinct "Precinct"
	label var ha_qtr_day "Quarter day?"
	label var ha_race_sex "Driver's race and sex"
	label var ha_reason_cita "Citation given"
	label var ha_reason_warn "Warning given"
	label var ha_region "Region"
	label var ha_road_class "Road class"
	label var ha_road_loc "Road location"
	label var ha_route "Route"
	label var ha_search_concent "Consent to search"
	label var ha_search_p "Search picture"
	label var ha_searched "Was searched"
	label var ha_service "Service"
	label var ha_sgt_area "Sergeant area"
	label var ha_str1 "Sergeant's street"
	label var ha_ticket_number "Ticket no"
	label var ha_ticket_sta "Ticket status"
	label var ha_ticket_ty "Ticket type"
	label var ha_traff "Traffic"
	label var ha_upload_flag "Flag uploaded"
	label var ha_veh_col "Vehicle color"
	label var ha_veh_mak "Vehicle make"
	label var ha_veh_mod "Vehicle model"
	label var ha_veh_sear "Vehicle searched"
	label var ha_veh_y "Vehicle year"
	label var ha_vehicle_invent "Vehicle invent"
	label var ha_vehicle_type "Vehicle type"
	label var ha_weather "Weather"
	label var ha_workers_present "Workers present"
	label var ha_year "Stop year"
	label var obs_num "Observation number"
	
	
log close
cd "${analytical_dta}"
	save traffic_stops.dta, replace //specifying to save my updated data in my analytical folder
	
	
*******************************************************************************************************************************************************************	
	
*Next day, 02/04/21
	cd "${analytical_dta}"
		use "traffic_stops.dta" //using my saved data in analytical data folder
	
cd "${logs}" //specifying to open log folder and save my second log in there	
	log using econ020421, replace

*Next, I will be ordering the variables to allow easy flow of connections using local macro
	local orderrobot "ha_n_first_drvr ha_n_middle_drvr ha_n_last_drvr ha_a_address_drvr ha_a_city_drvr ha_a_state_drvr ha_a_zip_drvr ha_p_hm_drvr ha_n_judge ha_a_address_jge ha_a_city_jge ha_a_state_jge ha_a_zip_jge ha_p_judge ha_judge_key"
		order `orderrobot'

*Next, I will like to re-format my dates and time
	gen arrest_month=substr(ha_arrest_date,1,2)
	gen arrest_day=substr(ha_arrest_date,4,2)
	gen arrest_year=substr(ha_arrest_date,7,2)
	
	replace arrest_year="20"+arrest_year
	destring arrest_month arrest_day arrest_year, replace
	gen arrest_date=mdy(arrest_month,arrest_day,arrest_year)
	format arrest_date %td
	
	gen arrest_time=substr(ha_arrest_date,10,8)
	destring arrest_time, replace
	format arrest_time
	
*For the court date reformatting;
	gen court_month=substr(ha_d_court,1,2)
	gen court_day=substr(ha_d_court,4,2)
	gen court_year=substr(ha_d_court,7,2)
	
	replace court_year="20"+court_year
	destring court_month court_day court_year, replace
	gen court_date=mdy(court_month,court_day,court_year)
	format court_date %td
	
	gen court_time=substr(ha_d_court,10,8)
	destring court_time, replace
	format court_time
	
*I will be re-labelling the newly created variables
	label var arrest_month "Arrest Month"
	label var arrest_day "Arrest Day"
	label var arrest_year "Arrest Year"
	label var arrest_date "Arrest Date"
	label var arrest_time "Arrest Time"
	
	label var court_month "Court Month"
	label var court_day "Court Day"
	label var court_year "Court Year"
	label var court_date "Court Date"
	label var court_time "Court Time"
	
	
*I will be destringing some variables using macro
	
local destringrobot "ha_a_zip_drvr1 ha_p_hm_drvr ha_a_zip_jge1 ha_p_judge ha_alleged_speed ha_arrest_date ha_accident ha_comm_vehicle ha_construction_zone ha_contrab_currency ha_contrab_drugs ha_contrab_other ha_contrab_weapon ha_contraban ha_county ha_court ha_d_court ha_day_of_week ha_gvwr ha_height ha_incidto_arrest ha_int1 ha_interstate ha_intrastate ha_latitude ha_longitude ha_milepost ha_month ha_officer_id ha_passengers ha_posted_speed ha_precinct ha_qtr_day ha_reason_cita ha_reason_warn ha_region ha_road_class ha_route ha_search_concent ha_search_pc ha_searched ha_sgt_area ha_traffic ha_upload_flag ha_veh_search ha_veh_year ha_vehicle_invent ha_weather ha_workers_present ha_year"
		destring `destringrobot', replace force
	

log close 
	
	cd "${analytical_dta}"
		save traffic_stops.dta, replace //specifying to save my updated data in my analytical folder

*******************************************************************************************************************************************************************
	
*Next day, 02/05/21
	cd "${analytical_dta}"
		use "traffic_stops.dta" //using my saved data in analytical data folder
cd "${logs}" //specifying to open log folder and save my third log in there	
	log using econ020521, replace

	
*I will be creating a dummy variable for Texas in case I want to analyze drivers who live in Texas alone
	encode ha_a_state_drvr, generate(Driver_state)
		gen state_texas = Driver_state
		replace state_texas = 0 if state_texas != 9
		replace state_texas = 1 if state_texas == 9

	
*Next, I will create a cleaning program
	capture program drop clean
	program define clean
		capture missings dropvars,force
		capture rename *, lower
		foreach var of varlist *{
			capture replace `var'=upper(`var')
			capture replace `var'=trim(`var')
			capture replace `var'=strtrim(`var') 
			missings dropvars, force
		}
	end


*I will be splitting the gender/race variable

	gen drvr_race_white=inlist(ha_race_sex,"WF","WM")
	gen drvr_race_black=inlist(ha_race_sex,"BF","BM")
	gen drvr_race_asian=inlist(ha_race_sex,"AF","AM")
	gen drvr_race_hispanic=inlist(ha_race_sex,"HF","HM")
	gen drvr_sex_female=inlist(ha_race_sex,"WF","BF","AF","HF")
	gen drvr_sex_male=inlist(ha_race_sex,"WM","BM","AM","HM")
	
*Label new variables

	label var drvr_race_white "White Driver"
	label var drvr_race_black "Black Driver"
	label var drvr_race_asian "Asian Driver"
	label var drvr_race_hispanic "Hispanic Driver"
	label var drvr_sex_female "Female Driver" 
	label var drvr_sex_male "Male Driver" 

	
	
*I will be storing some strings as numbers to reduce storage space
	encode ha_district, gen(district)
	encode ha_service, gen(service)
	encode ha_str1, gen(sergeants_street)
	encode ha_ticket_type, gen(ticket_type)
	encode ha_veh_color, gen(veh_color)
	encode ha_veh_make, gen(veh_make)
	
*I am interested in the vehicles the drivers drove. This is a data I will like to look into further- do drivers who drive certain vehicle get stopped more?
*For now, it is saved in a tempfile
	preserve
	egen veh_group = group(veh_make)
	gen one = 1
	bysort veh_make: egen veh_group_count = count(one)
	tempfile veh_make_tab
	save `veh_make_tab', replace
	restore
	

*I will now merge this data with another data (the HR data)
cd "${analytical_dta}"
	use "traffic_stops.dta", clear
	merge m:1 ha_officer_id using "officers_list.dta"

log close

cd "${analytical_dta}"
	save traffic_stops.dta, replace //specifying to save my updated data in my analytical folder
	
