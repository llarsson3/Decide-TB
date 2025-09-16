global DATA = "D:\Data\umoya\clinical data\stata"
cd "$DATA"


//get all registered pids
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "register.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=411        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

drop redcap_event_name redcap_repeat_instrument ///
redcap_repeat_instance  

//keep if record_id > "UM400"

save "register.dta" , replace

use "register.dta", clear

merge 1:1 record_id using "Master sheet_20230706_23Aug2022_PID List_mvn_an_mvn.dta", assert(master match) keep(master match) keepusing(UMCategory TBConfirmed TBTreatment Completed) generate(_tb_cat_mvn)

save "umoya_clinical.dta", replace

//form1 baseline
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form1_baseline.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=647        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"

do "UmoyaRestructure-Form1Baseline.do"
drop if umf01_ubl_visdate==.
gsort record_id -umf01_ubl_visdate
by record_id: gen n=_n
order n, after( record_id)
keep if n==1
drop n
drop redcap_event_name redcap_repeat_instrument ///
redcap_repeat_instance  

save "form1_baseline.dta" , replace

use "umoya_clinical.dta" 
merge 1:1 record_id using "form1_baseline.dta", assert(master match) keep(master match) generate(_bl)
save "umoya_clinical.dta", replace

//form2 week 2
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form2_week2.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=648        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"

do "UmoyaRestructure-Form2Week2.do"
drop if umf02_uw2_visdate==.
gsort record_id -umf02_uw2_visdate
by record_id: gen n=_n
order n, after( record_id)
keep if n==1
drop n  redcap_event_name redcap_repeat_instrument ///
redcap_repeat_instance  

save "form2_week2.dta" , replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form2_week2.dta", assert(master match) keep(master match) generate(_form2)
save "umoya_clinical.dta", replace

//form3 week 8
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form3_week8.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=649        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form3Week8.do"
drop if umf03_uw8_visdate==.
gsort record_id -umf03_uw8_visdate
by record_id: gen n = _n
order n, after( record_id)
//keep latest visit only
keep if n==1
drop n redcap_event_name redcap_repeat_instrument redcap_repeat_instance form_3_week_8_complete
save "form3_wk8.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form3_wk8.dta", assert(master match) keep(master match) generate(_form3)
save "umoya_clinical.dta", replace

//form 4 week 16
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form4_week6.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=473        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form4week16.do"
rename umf04_uw16_failurethrive_2 umf04_uw16_nightsweats
drop if umf04_uw16_visdate==.
gsort record_id -umf04_uw16_visdate
by record_id: gen n=_n
order n, after( record_id)
keep if n==1
drop n  redcap_event_name redcap_repeat_instrument ///
redcap_repeat_instance  

save "form4_week16.dta" , replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form4_week16.dta", assert(master match) keep(master match) generate(_form4)
save "umoya_clinical.dta", replace

//form 5 week 24
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form5_week24.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=484        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form5week24.do"
drop if umf05_uw24_visdate==.
gsort record_id -umf05_uw24_visdate
by record_id: gen n=_n
order n, after( record_id)
keep if n==1
drop n  redcap_event_name redcap_repeat_instrument ///
redcap_repeat_instance  
save "form5_week24.dta" , replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form5_week24.dta", assert(master match) keep(master match) generate(_form5)
save "umoya_clinical.dta", replace

//form 15 eos
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form15_eos.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=505        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form15endofstudyv21.do"
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance 
drop if umf15_ueos_visdate==.
gsort record_id - umf15_ueos_visdate
by record_id: gen n=_n
order n, after( record_id)
keep if n==1

gen study_outcome = "deceaed" if umf15_ueos_deceaseddateyn==1
order study_outcome, after(record_id)
gen outcome_date=umf15_ueos_deceaseddate if umf15_ueos_deceaseddateyn==1
order outcome_date, after( study_outcome)
format %td outcome_date
replace study_outcome="ltfu" if study_outcome=="" & umf15_ueos_datelastseenyn==1
replace outcome_date = umf15_ueos_datelastseen if outcome_date==. & umf15_ueos_datelastseenyn ==1
replace study_outcome="withdraw" if study_outcome=="" & umf15_ueos_withdrawaldyn==1
replace outcome_date = umf15_ueos_withdrawald if outcome_date==. & umf15_ueos_withdrawaldyn ==1

save "form15_endofstudy.dta", replace

//keep record_id umf15_ueos_visdate study_outcome outcome_date umf15_ueos_tbclass umf15_ueos_conver_stat umf15_ueos_confirmedtb___1 umf15_ueos_confirmedtb___2 umf15_ueos_confirmedtb___3
//save "$DATA/form15_endofstudy_min.dta", replace

use "umoya_clinical.dta"
merge 1:1 record_id using "form15_endofstudy.dta", assert(master match) keep(master match) generate(_eos)
order study_outcome outcome_date umf15_ueos_visdate, after(record_id)
save "umoya_clinical.dta", replace

//form 7 nurses
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form7_nurses.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=486        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form7nursecrfsamples.do"
drop if umf07_uf7_visdate==.
save "form7.dta", replace

//hiv
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance 
drop umf07_uf7_tbcat 
drop umf07_uf7_respsamplescollected umf07_uf7_samplesna umf07_uf7_samplesstudyteam umf07_uf7_samplesroutinecare ///
umf07_uf7_stamntsamples umf07_uf7_rcamntsamples umf07_uf7_gatika
drop umf07_uf7_npa umf07_uf7_othtestspec umf07_uf7_cd4vl umf07_uf7_biomarkser umf07_uf7_suvol umf07_uf7_pax ///
umf07_uf7_paxsufvol umf07_uf7_urine umf07_uf7_suvol2 umf07_uf7_stool umf07_uf7_stoolcases umf07_uf7_stoolcontrols ///
umf07_uf7_tst umf07_uf7_tstdate umf07_uf7_tstresult umf07_uf7_tstinduration umf07_uf7_igra umf07_ub7_bflyfl ///
umf07_ub7_saliva umf07_uf7_spiro umf07_uf7_tremoflo form_7_nurse_crf_samples_complet

gen hiv_order= umf07_uf7_resulthivtest 
replace hiv_order=-1 if umf07_uf7_resulthivtest==2
drop if umf07_uf7_resulthivtest==.
gsort record_id - hiv_order
by record_id: gen n=_n
keep if n==1
drop hiv_order n

save "form7_hiv.dta", replace

use "umoya_clinical.dta"
merge 1:1 record_id using "form7_hiv.dta", assert(master match) keep(master match) generate(_hiv)
save "umoya_clinical.dta", replace

//tst
use "form7.dta", clear

save "Form7_nurses_tst.dta", replace
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance umf07_uf7_visdate umf07_uf7_vistime umf07_uf7_tbcat umf07_uf7_respsamplescollected umf07_uf7_samplesna umf07_uf7_samplesstudyteam umf07_uf7_samplesroutinecare umf07_uf7_stamntsamples umf07_uf7_rcamntsamples umf07_uf7_gatika umf07_uf7_hivtest umf07_uf7_daterecenthivtest umf07_uf7_resulthivtest umf07_uf7_elisa_pcr umf07_uf7_npa umf07_uf7_othtestspec umf07_uf7_cd4vl umf07_uf7_biomarkser umf07_uf7_suvol umf07_uf7_pax umf07_uf7_paxsufvol umf07_uf7_urine umf07_uf7_suvol2 umf07_uf7_stool umf07_uf7_stoolcases umf07_uf7_stoolcontrols 
drop umf07_uf7_igra umf07_ub7_bflyfl umf07_ub7_saliva umf07_uf7_spiro umf07_uf7_tremoflo form_7_nurse_crf_samples_complet
//keep if umf07_uf7_tstresult==1
//gsort record_id  umf07_uf7_tstdate
//sort record_id
keep if inlist(umf07_uf7_tst , 0, 1)
gsort record_id -umf07_uf7_tst -umf07_uf7_tstresult umf07_uf7_tstdate
by record_id: gen n = _n
keep if n==1
drop n
//drop if record_id>"UM500"
save "Form7_nurses_tst.dta", replace

use "umoya_clinical.dta"
merge 1:1 record_id using "Form7_nurses_tst.dta", assert(master match) keep(master match) generate(_tst1)
save "umoya_clinical.dta", replace


use "form7.dta", clear

drop redcap_repeat_instrument redcap_repeat_instance 
drop umf07_uf7_vistime umf07_uf7_tbcat umf07_uf7_respsamplescollected umf07_uf7_samplesna umf07_uf7_samplesstudyteam umf07_uf7_samplesroutinecare umf07_uf7_stamntsamples umf07_uf7_rcamntsamples umf07_uf7_gatika umf07_uf7_hivtest umf07_uf7_daterecenthivtest umf07_uf7_resulthivtest umf07_uf7_elisa_pcr umf07_uf7_npa umf07_uf7_othtestspec umf07_uf7_cd4vl umf07_uf7_biomarkser umf07_uf7_suvol umf07_uf7_pax umf07_uf7_paxsufvol umf07_uf7_urine umf07_uf7_suvol2 umf07_uf7_stool umf07_uf7_stoolcases umf07_uf7_stoolcontrols 
drop umf07_uf7_igra umf07_ub7_bflyfl umf07_ub7_saliva umf07_uf7_spiro umf07_uf7_tremoflo form_7_nurse_crf_samples_complet

//keep if umf07_uf7_tst==1
//gen tst_order = umf07_uf7_tst
//replace tst_order = -1 if umf07_uf7_tst==94
gen event = "wk000" if redcap_event_name == "baseline_arm_1"
replace event = "wk999" if redcap_event_name == "unscheduled_1_arm_1" | redcap_event_name == "unscheduled_1_arm_2" | redcap_event_name == "unscheduled_1_arm_3" | ///
redcap_event_name == "unscheduled_2_arm_1" | redcap_event_name == "unscheduled_2_arm_2" | redcap_event_name == "unscheduled_2_arm_3" | ///
redcap_event_name == "unscheduled_3_arm_1" | redcap_event_name == "unscheduled_3_arm_2" | redcap_event_name == "unscheduled_3_arm_3" | ///
redcap_event_name == "unscheduled_4_arm_1" | redcap_event_name == "unscheduled_4_arm_2" | redcap_event_name == "unscheduled_4_arm_3" | ///
redcap_event_name == "unscheduled_5_arm_1" | redcap_event_name == "unscheduled_5_arm_2" | redcap_event_name == "unscheduled_5_arm_3" | ///
redcap_event_name == "unscheduled_6_arm_1" | redcap_event_name == "unscheduled_6_arm_2" | redcap_event_name == "unscheduled_6_arm_3" | ///
redcap_event_name == "unscheduled_7_arm_1" | redcap_event_name == "unscheduled_7_arm_2" | redcap_event_name == "unscheduled_7_arm_3"
replace event = "wk016" if redcap_event_name == "week_16_arm_1" | redcap_event_name == "week_16_arm_2" | redcap_event_name == "week_16_arm_3"
replace event = "wk024" if redcap_event_name == "week_24_arm_1" | redcap_event_name == "week_24_arm_2" | redcap_event_name == "week_24_arm_3"
replace event = "wk002" if redcap_event_name == "week_2_arm_1" | redcap_event_name == "week_2_arm_2"  | redcap_event_name == "week_2_arm_3" 
replace event = "wk052" if redcap_event_name == "week_52_arm_1" | redcap_event_name == "week_52_arm_2" | redcap_event_name == "week_52_arm_3"   
replace event = "wk008" if redcap_event_name == "week_8_arm_1" | redcap_event_name == "week_8_arm_2" | | redcap_event_name == "week_8_arm_3"
replace event = "wk104" if redcap_event_name == "week_104_arm_1" | redcap_event_name == "week_104_arm_2" | redcap_event_name == "week_104_arm_3"
replace event = "wk156" if redcap_event_name == "week_156_arm_1" | redcap_event_name == "week_156_arm_2" | redcap_event_name == "week_156_arm_3"
replace event = "wk208" if redcap_event_name == "week_208_arm_1" | redcap_event_name == "week_208_arm_2" | redcap_event_name == "week_208_arm_3"

order event, after(record_id)
drop redcap_event_name
rename umf07_uf7_visdate visdate
rename umf07_uf7_tst tst_done
rename umf07_uf7_tstdate tstdate
rename umf07_uf7_tstresult tstresult
rename umf07_uf7_tstinduration tstinduration

gsort record_id event -tstresult
by record_id event: gen n = _n
keep if n==1
drop n

reshape wide visdate tst_done tstdate tstresult tstinduration, i(record_id) j(event) string

save "form7_tst.dta", replace

use "umoya_clinical.dta"
merge 1:1 record_id using "form7_tst.dta", assert(master match) keep(master match) generate(_tst)
save "umoya_clinical.dta", replace

//form 11
version 14
set more off
clear 
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "form11.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=466        ///
	"https://data.dttc.sun.ac.za/redcap/api/"
	
import delimited `outfile'

//keep if record_id > "UM400"
do "UmoyaRestructure-Form11tbresult.do"
drop if umf11_uf11_col_date==.
keep if inlist(umf11_uf11_spectypen, 1, 2, 3, 5, 6, 7, 13, 99)

//drop if redcap_event_name=="visit_unknown_rout_arm_1"
gen event = "wk000" if redcap_event_name == "baseline_arm_1"
replace event = "wk999" if redcap_event_name == "unscheduled_1_arm_1" | redcap_event_name == "unscheduled_1_arm_2" | redcap_event_name == "unscheduled_1_arm_3" | ///
redcap_event_name == "unscheduled_2_arm_1" | redcap_event_name == "unscheduled_2_arm_2" | redcap_event_name == "unscheduled_2_arm_3" | ///
redcap_event_name == "unscheduled_3_arm_1" | redcap_event_name == "unscheduled_3_arm_2" | redcap_event_name == "unscheduled_3_arm_3" | ///
redcap_event_name == "unscheduled_4_arm_1" | redcap_event_name == "unscheduled_4_arm_2" | redcap_event_name == "unscheduled_4_arm_3" | ///
redcap_event_name == "unscheduled_5_arm_1" | redcap_event_name == "unscheduled_5_arm_2" | redcap_event_name == "unscheduled_5_arm_3" | ///
redcap_event_name == "unscheduled_6_arm_1" | redcap_event_name == "unscheduled_6_arm_2" | redcap_event_name == "unscheduled_6_arm_3" | ///
redcap_event_name == "unscheduled_7_arm_1" | redcap_event_name == "unscheduled_7_arm_2" | redcap_event_name == "unscheduled_7_arm_3"
replace event = "wk016" if redcap_event_name == "week_16_arm_1" | redcap_event_name == "week_16_arm_2" | redcap_event_name == "week_16_arm_3"
replace event = "wk024" if redcap_event_name == "week_24_arm_1" | redcap_event_name == "week_24_arm_2" | redcap_event_name == "week_24_arm_3"
replace event = "wk002" if redcap_event_name == "week_2_arm_1" | redcap_event_name == "week_2_arm_2"  | redcap_event_name == "week_2_arm_3" 
replace event = "wk052" if redcap_event_name == "week_52_arm_1" | redcap_event_name == "week_52_arm_2" | redcap_event_name == "week_52_arm_3"   
replace event = "wk008" if redcap_event_name == "week_8_arm_1" | redcap_event_name == "week_8_arm_2" | | redcap_event_name == "week_8_arm_3"
replace event = "wk104" if redcap_event_name == "week_104_arm_1" | redcap_event_name == "week_104_arm_2" | redcap_event_name == "week_104_arm_3"
replace event = "wk156" if redcap_event_name == "week_156_arm_1" | redcap_event_name == "week_156_arm_2" | redcap_event_name == "week_156_arm_3"
replace event = "wk208" if redcap_event_name == "week_208_arm_1" | redcap_event_name == "week_208_arm_2" | redcap_event_name == "week_208_arm_3"
replace event = "unk" if redcap_event_name=="visit_unknown_rout_arm_1"

order event, after( redcap_event_name)

gen sampletype = "GAA" if umf11_uf11_spectypen==1
replace sampletype = "ESP" if umf11_uf11_spectypen==2
replace sampletype = "ISP" if umf11_uf11_spectypen==3
replace sampletype = "TBL" if umf11_uf11_spectypen==5
replace sampletype = "FNA" if umf11_uf11_spectypen==6
replace sampletype = "NPA" if umf11_uf11_spectypen==7
replace sampletype = "GATika" if umf11_uf11_spectypen==13
replace sampletype = "Other" if umf11_uf11_spectypen==99

save "form_11.dta", replace

use "form_11.dta", clear

//SMEAR
save "form_11_smear.dta", replace
drop redcap_event_name 
drop redcap_repeat_instrument redcap_repeat_instance umf11_u11_vst umf11_uf11_dob umf11_uf11_col_date umf11_uf11_col_time umf02_uf11_col_time umf11_uf11_col_volfl umf11_uf11_col_vol umf11_uf11_barcode_samplefl umf11_uf11_barcode_sample 
drop umf11_uf11_spectype umf11_uf11_recdate umf11_uf11_rectime umf11_uf11_barcode_episode 
drop umf11_uf11_res_xpert umf11_uf11_res_xpertmtb umf11_uf11_res_mgit umf11_uf11_res_mgit_mpt64 umf11_uf11_res_mgit_mtbdrplus umf11_uf11_res_mgit_oth_episode umf11_uf11_res_mgit_rif umf11_uf11_res_mgit_inh umf11_uf11_res_xpert_ultra umf11_uf11_res_xpert_sq umf11_uf11_res_cul_ttpd umf11_uf11_res_cul_ttph umf11_uf11_res_cul_zn umf11_uf11_res_cul_inh umf11_uf11_res_cul_hain umf11_uf11_res_cul_ntm umf11_uf11_res_cul_mtbdrsl umf11_uf11_res_cul_mtbdrsl_q umf11_uf11_res_cul_mtbdrsl_sli umf11_uf11_res_cul_cmo form_11_tb_result_complete

replace umf11_uf11_res_smear = -1 if umf11_uf11_res_smear==96 | umf11_uf11_res_smear==.
label define umf11_uf11_res_smear_ 0 "0 - Negative" 1 "1 - Scanty positive" 2 "2 - 1+ Smear positive" 3 "3 - 2+ Smear positive" 4 "4 - 3+ Smear positive" -1 "-1 - Not done", replace

rename umf11_uf11_res_smear res_smear
drop umf11_uf11_spectypen
gsort record_id event sampletype -res_smear
by record_id event sampletype: gen n = _n

keep if n==1
drop n

gsort record_id event sampletype -res_smear
save "form_11_smear_wide_event.dta", replace
reshape wide res_smear, i(record_id event) j(sampletype) string

gen smear_res = .
replace smear_res = res_smearESP if res_smearESP!=.
replace smear_res = res_smearGAA if (res_smearGAA >= smear_res | ///
smear_res==.) & res_smearGAA!=.
replace smear_res = res_smearISP if (res_smearISP >= smear_res | ///
smear_res==.) & res_smearISP!=. 
//replace smear_res = res_smearTBL if (res_smearTBL >= smear_res | smear_res==.) & res_smearTBL!=.
//replace smear_res = res_smearFNA if (res_smearFNA >= smear_res | smear_res==.) & res_smearFNA!=. //(res_smearNPA!=. & res_smearNPA>0) | 
//replace smear_res = res_smearGATika if (res_smearGATika >= smear_res | smear_res==.) & res_smearGATika!=. 
//replace smear_res = res_smearOther if (res_smearOther >= smear_res | smear_res==.) & res_smearOther!=.

replace smear_res = 0 if (smear_res==. & res_smearESP==0) | ///
(smear_res==. & res_smearGAA==0) | ///
(smear_res==. & res_smearISP==0)  ///
//(smear_res==. & res_smearTBL==0) | ///
//(smear_res==. & res_smearFNA==0) | ///(res_smearNPA!=. & res_smearNPA>0) | ///
//(smear_res==. & res_smearGATika==0) | (smear_res==. & res_smearOther==0)

label values smear_res umf11_uf11_res_smear_

gen smear_samplepos = "|ESP" if  (res_smearESP!=. & res_smearESP>0)
replace smear_samplepos = smear_samplepos + "|GAA" if  (res_smearGAA!=. & res_smearGAA>0)
replace smear_samplepos = smear_samplepos + "|ISP" if  (res_smearISP!=. & res_smearISP>0)
//replace smear_samplepos = smear_samplepos + "|TBL" if  (res_smearTBL!=. & res_smearTBL>0)
//replace smear_samplepos = smear_samplepos + "|FNA" if  (res_smearFNA!=. & res_smearFNA>0)
//replace smear_samplepos = smear_samplepos + "|NPA" if  (res_smearNPA!=. & res_smearNPA>0)
//replace smear_samplepos = smear_samplepos + "|GATika" if  (res_smearGATika!=. & res_smearGATika>0)
//replace smear_samplepos = smear_samplepos + "|Other" if  (res_smearOther!=. & res_smearOther>0)

//drop res_smearESP res_smearGAA res_smearISP 
//res_smearTBL res_smearFNA ///res_smearNPA 
//res_smearGATika res_smearOther
keep record_id event smear_res smear_samplepos
reshape wide smear_res smear_samplepos, i(record_id) j(event) string
save "form_11_smear_wide_fin.dta", replace

//CULTURE
use "form_11.dta", clear

drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance umf11_u11_vst umf11_uf11_dob umf11_uf11_col_date umf11_uf11_col_time umf02_uf11_col_time umf11_uf11_col_volfl umf11_uf11_col_vol umf11_uf11_barcode_samplefl umf11_uf11_barcode_sample 
drop umf11_uf11_spectype umf11_uf11_recdate umf11_uf11_rectime umf11_uf11_barcode_episode umf11_uf11_res_smear umf11_uf11_res_xpert umf11_uf11_res_xpertmtb 
drop umf11_uf11_res_mgit_mpt64  umf11_uf11_res_mgit_oth_episode umf11_uf11_res_xpert_ultra umf11_uf11_res_xpert_sq umf11_uf11_res_cul_ttpd umf11_uf11_res_cul_ttph umf11_uf11_res_cul_zn umf11_uf11_res_cul_inh umf11_uf11_res_cul_hain umf11_uf11_res_cul_ntm umf11_uf11_res_cul_mtbdrsl umf11_uf11_res_cul_mtbdrsl_q umf11_uf11_res_cul_mtbdrsl_sli umf11_uf11_res_cul_cmo form_11_tb_result_complete

//0, 0 - Negative for MTB complex | 
//1, 1 - Positive for MTB complex | 
//2, 2 - Positive for MTB complex and contaminated | 
//3, 3 - Positive for MTB complex and NTM | 
//4, 4 - Positive for NTM | 
//5, 5 - Culture contaminated. No further result to follow. | 
//96, 96 - Not done
//keep if inlist(umf11_uf11_res_mgit, 0, 1, 2, 3)
gen cul_order = 1 if umf11_uf11_res_mgit==1
replace cul_order = 2 if umf11_uf11_res_mgit==2
replace cul_order = 3 if umf11_uf11_res_mgit==3
replace cul_order = 4 if umf11_uf11_res_mgit==0
replace cul_order = 5 if umf11_uf11_res_mgit==4
replace cul_order = 6 if umf11_uf11_res_mgit==5
replace cul_order = 7 if umf11_uf11_res_mgit==96

order sampletype, after( umf11_uf11_spectypen)
gsort record_id event umf11_uf11_spectypen - cul_order
by record_id event umf11_uf11_spectypen: gen n = _n
keep if n==1
drop n cul_order
rename umf11_uf11_res_mgit res_mgit
rename umf11_uf11_res_mgit_mtbdrplus res_mgit_mtbdrplus
rename umf11_uf11_res_mgit_rif res_mgit_rif
rename umf11_uf11_res_mgit_inh res_mgit_inh
drop umf11_uf11_spectypen

save "form_11_culture.dta", replace

gsort record_id event sampletype -res_mgit
save "form_11_cul_wide_event.dta", replace
reshape wide res_mgit res_mgit_mtbdrplus res_mgit_rif res_mgit_inh, i(record_id event) j(sampletype) string

//0, 0 - Negative for MTB complex | 
//1, 1 - Positive for MTB complex | 
//2, 2 - Positive for MTB complex and contaminated | 
//3, 3 - Positive for MTB complex and NTM | 
//4, 4 - Positive for NTM | 
//5, 5 - Culture contaminated. No further result to follow. | 
//96, 96 - Not done

gen mgit_res = .
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==1
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==1
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==1
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==2
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==2
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==2
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==3
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==3
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==3
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==4
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==4
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==4
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==5
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==5
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==5
replace mgit_res = res_mgitESP if mgit_res==. & ///
res_mgitESP==96
replace mgit_res = res_mgitGAA if mgit_res==. & ///
res_mgitGAA==96
replace mgit_res = res_mgitISP if mgit_res==. & ///
res_mgitISP==96

replace mgit_res = 0 if mgit_res==. & res_mgitESP==0
replace mgit_res = 0 if mgit_res==. & res_mgitGAA==0
replace mgit_res = 0 if mgit_res==. & res_mgitISP==0
replace mgit_res = 0 if (res_mgitESP==0 | res_mgitGAA==0 | res_mgitISP==0) & ///
mgit_res>=5
//replace mgit_res = res_mgitTBL if res_mgitTBL < mgit_res & res_mgitTBL!=0 
//replace mgit_res = res_mgitFNA if res_mgitFNA < mgit_res & res_mgitFNA!=0  //(res_mgitNPA!=. & res_mgitNPA>0) 
//replace mgit_res = res_mgitGATika if res_mgitGATika < mgit_res & res_mgitGATika!=0
//replace mgit_res = res_mgitOther if res_mgitOther < mgit_res & res_mgitOther!=0

//replace mgit_res = 0 if mgit_res==. & res_mgitTBL==0 
//replace mgit_res = 0 if mgit_res==. & res_mgitFNA==0  //(res_mgitNPA!=. & res_mgitNPA>0) 
//replace mgit_res = 0 if mgit_res==. & res_mgitGATika==0
//replace mgit_res = 0 if mgit_res==. & res_mgitOther==0

label values mgit_res umf11_uf11_res_mgit_

gen mgit_samplepos = "|ESP" if  (res_mgitESP!=. & res_mgitESP>0 & res_mgitESP<5)
replace mgit_samplepos = mgit_samplepos + "|GAA" if  (res_mgitGAA!=. & res_mgitGAA>0 & res_mgitGAA<5)
replace mgit_samplepos = mgit_samplepos + "|ISP" if  (res_mgitISP!=. & res_mgitISP>0 & res_mgitISP<5)
//replace mgit_samplepos = mgit_samplepos + "|TBL" if  (res_mgitTBL!=. & res_mgitTBL>0)
//replace mgit_samplepos = mgit_samplepos + "|FNA" if  (res_mgitFNA!=. & res_mgitFNA>0)
//replace mgit_samplepos = mgit_samplepos + "|NPA" if  (res_mgitNPA!=. & res_mgitNPA>0)
//replace mgit_samplepos = mgit_samplepos + "|GATika" if  (res_mgitGATika!=. & res_mgitGATika>0)
//replace mgit_samplepos = mgit_samplepos + "|Other" if  (res_mgitOther!=. & res_mgitOther>0)

drop res_mgitESP res_mgitGAA res_mgitISP 
//res_mgitTBL res_mgitFNA ///res_mgitNPA 
//res_mgitGATika res_mgitOther

gen mgit_mtbdrplus_res = .
replace mgit_mtbdrplus_res = 1 if (res_mgit_mtbdrplusESP==1) ///
| (res_mgit_mtbdrplusGAA==1) | ///
(res_mgit_mtbdrplusISP==1) 
//| (res_mgit_mtbdrplusTBL==1) | ///
//(res_mgit_mtbdrplusFNA==1) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_mtbdrplusGATika==1) | (res_mgit_mtbdrplusOther==1)

replace mgit_mtbdrplus_res = 0 if ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusESP==0) | ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusGAA==0) | ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusISP==0) 
//| ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusTBL==0) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusFNA==0) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusGATika==0) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusOther==0)

replace mgit_mtbdrplus_res = 2 if ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusESP==2) | ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusGAA==2) | ///
(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusISP==2) 
//| ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusTBL==2) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusFNA==2) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusGATika==2) | ///
//(mgit_mtbdrplus_res==. & res_mgit_mtbdrplusOther==2)

label values mgit_mtbdrplus_res umf11_uf11_res_mgit_mtbdrplus_

drop res_mgit_mtbdrplusESP res_mgit_mtbdrplusGAA ///
res_mgit_mtbdrplusISP 
//res_mgit_mtbdrplusTBL res_mgit_mtbdrplusFNA ///res_mgitNPA 
//res_mgit_mtbdrplusGATika res_mgit_mtbdrplusOther

gen res_mgit_rif int = .
replace res_mgit_rif = 2 if (res_mgit_rifESP==2) | (res_mgit_rifGAA==2) | ///
(res_mgit_rifISP==2) 
//| (res_mgit_rifTBL==2) | ///
//(res_mgit_rifFNA==2) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_rifGATika==2) | (res_mgit_rifOther==2)

replace res_mgit_rif = 1 if (res_mgit_rif == . & res_mgit_rifESP==1) | /// 
(res_mgit_rif == . & res_mgit_rifGAA==1) | ///
(res_mgit_rif == . & res_mgit_rifISP==1) 
//| ///
//(res_mgit_rif == . & res_mgit_rifTBL==1) | ///
//(res_mgit_rif == . & res_mgit_rifFNA==1) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_rif == . & res_mgit_rifGATika==1) | (res_mgit_rif == . & res_mgit_rifOther==1)

replace res_mgit_rif = 3 if (res_mgit_rif == . & res_mgit_rifESP==3) | ///
(res_mgit_rif == . & res_mgit_rifGAA==3) | ///
(res_mgit_rif == . & res_mgit_rifISP==3) 
//| ///
//(res_mgit_rif == . & res_mgit_rifTBL==3) | ///
//(res_mgit_rif == . & res_mgit_rifFNA==3) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_rif == . & res_mgit_rifGATika==3) | (res_mgit_rif == . & res_mgit_rifOther==3)

drop res_mgit_rifESP res_mgit_rifGAA ///
res_mgit_rifISP 
//res_mgit_rifTBL ///
//res_mgit_rifFNA ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//res_mgit_rifGATika res_mgit_rifOther

label values res_mgit_rif umf11_uf11_res_mgit_rif_

gen res_mgit_inh int = .
replace res_mgit_inh = 2 if (res_mgit_inhESP==2) | ///
(res_mgit_inhGAA==2) | ///
(res_mgit_inhISP==2) 
//| ///
//(res_mgit_inhTBL==2) | ///
//(res_mgit_inhFNA==2) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_inhGATika==2) | (res_mgit_inhOther==2)

replace res_mgit_inh = 1 if (res_mgit_inh == . & res_mgit_inhESP==1) | ///
(res_mgit_inh == . & res_mgit_inhGAA==1) | ///
(res_mgit_inh == . & res_mgit_inhISP==1) 
//| ///
//(res_mgit_inh == . & res_mgit_inhTBL==1) | ///
//(res_mgit_inh == . & res_mgit_inhFNA==1) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_inh == . & res_mgit_inhGATika==1) | (res_mgit_inh == . & res_mgit_inhOther==1)

replace res_mgit_inh = 3 if (res_mgit_inh == . & res_mgit_inhESP==3) | ///
(res_mgit_inh == . & res_mgit_inhGAA==3) | ///
(res_mgit_inh == . & res_mgit_inhISP==3) 
//| (res_mgit_inh == . & res_mgit_inhTBL==3) | ///
//(res_mgit_inh == . & res_mgit_inhFNA==3) | ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//(res_mgit_inh == . & res_mgit_inhGATika==3) | (res_mgit_inh == . & res_mgit_inhOther==3)

//drop res_mgit_inhESP res_mgit_inhGAA ///
//res_mgit_inhISP 
//res_mgit_inhTBL ///
//res_mgit_inhFNA ///(res_mgitNPA!=. & res_mgitNPA>0) | ///
//res_mgit_inhGATika res_mgit_inhOther
keep record_id event mgit_res mgit_samplepos mgit_mtbdrplus_res	res_mgit_rif res_mgit_inh
label values res_mgit_inh umf11_uf11_res_mgit_inh_

reshape wide mgit_res mgit_samplepos mgit_mtbdrplus_res	res_mgit_rif res_mgit_inh, i(record_id) j(event) string
order mgit_resunk mgit_sampleposunk mgit_mtbdrplus_resunk res_mgit_rifunk res_mgit_inhunk, after( res_mgit_inhwk024)
save "form_11_culture_wide_fin.dta", replace

//Xpert
use "form_11.dta", clear

save "form_11_xpert.dta", replace
replace umf11_uf11_res_xpert_sq = . if umf11_uf11_res_xpert!=2 & umf11_uf11_res_xpert!=3

drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance umf11_u11_vst umf11_uf11_dob umf11_uf11_col_date umf11_uf11_col_time umf02_uf11_col_time umf11_uf11_col_volfl umf11_uf11_col_vol umf11_uf11_barcode_samplefl umf11_uf11_barcode_sample  umf11_uf11_spectype umf11_uf11_recdate umf11_uf11_rectime umf11_uf11_barcode_episode umf11_uf11_res_smear 
drop umf11_uf11_res_mgit umf11_uf11_res_mgit_mpt64 umf11_uf11_res_mgit_mtbdrplus umf11_uf11_res_mgit_oth_episode umf11_uf11_res_mgit_rif umf11_uf11_res_mgit_inh umf11_uf11_res_xpert_ultra umf11_uf11_res_xpert_sq umf11_uf11_res_cul_ttpd umf11_uf11_res_cul_ttph umf11_uf11_res_cul_zn umf11_uf11_res_cul_inh umf11_uf11_res_cul_hain umf11_uf11_res_cul_ntm umf11_uf11_res_cul_mtbdrsl umf11_uf11_res_cul_mtbdrsl_q umf11_uf11_res_cul_mtbdrsl_sli umf11_uf11_res_cul_cmo form_11_tb_result_complete

//1, 1 MTB complex NOT detected | 
//2, 2 MTB complex detected/trace | 
//3, 3 PCR result test unsuccessful | 
//4, 4 Indeterminate | 
//96, 96 Not done

gen xpert_order = 1 if umf11_uf11_res_xpert==2
replace xpert_order = 2 if umf11_uf11_res_xpert==1
replace xpert_order = 3 if umf11_uf11_res_xpert==3
replace xpert_order = 4 if umf11_uf11_res_xpert==4
replace xpert_order = 5 if umf11_uf11_res_xpert==96

gsort record_id event umf11_uf11_spectypen -xpert_order
by record_id event umf11_uf11_spectypen: gen n = _n
keep if n==1
drop n xpert_order

rename umf11_uf11_res_xpert res_xpert
rename umf11_uf11_res_xpertmtb res_xpertmtb

drop umf11_uf11_spectypen

gsort record_id event sampletype -res_xpert
save "form_11_xpert_wide_event.dta", replace
reshape wide res_xpert res_xpertmtb, i(record_id event) j(sampletype) string

gen xpert_res = 2 if (res_xpertESP==2) | (res_xpertGAA==2) | ///
(res_xpertISP==2) 
//| (res_xpertTBL==0) | ///
//(res_xpertFNA==0) | ///(res_xpertNPA!=. & res_xpertNPA>0) | ///
//(res_xpertGATika==0) | (res_xpertOther==0)
replace xpert_res = 1 if (xpert_res==. & res_xpertESP==1) | (xpert_res==. & res_xpertGAA==1) | ///
(xpert_res==. & res_xpertISP==1) 
//| (res_xpertTBL!=. & res_xpertTBL>0) | ///
//(res_xpertFNA!=. & res_xpertFNA>0) | ///(res_xpertNPA!=. & res_xpertNPA>0) | ///
//(res_xpertGATika!=. & res_xpertGATika>0) | (res_xpertOther!=. & res_xpertOther>0)
replace xpert_res = 3 if (xpert_res==. & res_xpertESP==3) | (xpert_res==. & res_xpertGAA==3) | ///
(xpert_res==. & res_xpertISP==3) 
replace xpert_res = 4 if (xpert_res==. & res_xpertESP==4) | (xpert_res==. & res_xpertGAA==4) | ///
(xpert_res==. & res_xpertISP==4) 

replace xpert_res = 96 if xpert_res==.
label values xpert_res umf11_uf11_res_xpert_

gen xpert_samplepos = "|ESP" if res_xpertESP==2
replace xpert_samplepos = xpert_samplepos + "|GAA" if res_xpertGAA==2
replace xpert_samplepos = xpert_samplepos + "|ISP" if res_xpertISP==2
//replace xpert_samplepos = xpert_samplepos + "|TBL" if  (res_xpertTBL!=. & res_xpertTBL>0)
//replace xpert_samplepos = xpert_samplepos + "|FNA" if  (res_xpertFNA!=. & res_xpertFNA>0)
//replace xpert_samplepos = xpert_samplepos + "|NPA" if  (res_xpertNPA!=. & res_xpertNPA>0)
//replace xpert_samplepos = xpert_samplepos + "|GATika" if  (res_xpertGATika!=. & res_xpertGATika>0)
//replace xpert_samplepos = xpert_samplepos + "|Other" if  (res_xpertOther!=. & res_xpertOther>0)

//1, 1 - Rifampicin: Sensitive | 
//2, 2 - Rifampicin: Resistant | 
//3, 3 - Rifampicin: Indeterminate | 
//4, 4 - Rifampicin: Unsuccessful | 
//96, 96 - Not Done

gen xpert_rif = 2 if xpert_res==2 & (res_xpertmtbESP==2 | res_xpertmtbGAA==2 | res_xpertmtbISP==2)
replace xpert_rif = 1 if xpert_res==2 & xpert_rif==. & (res_xpertmtbESP==1 | res_xpertmtbGAA==1 | res_xpertmtbISP==1)
replace xpert_rif = 3 if xpert_res==2 & xpert_rif==. & (res_xpertmtbESP==3 | res_xpertmtbGAA==3 | res_xpertmtbISP==3)
replace xpert_rif = 4 if xpert_res==2 & xpert_rif==. & (res_xpertmtbESP==4 | res_xpertmtbGAA==4 | res_xpertmtbISP==4)
replace xpert_rif = 96 if xpert_res==2 & xpert_rif==. & (res_xpertmtbESP==96 | res_xpertmtbGAA==96 | res_xpertmtbISP==96)
label values xpert_rif umf11_uf11_res_xpertmtb_

drop res_xpertESP res_xpertGAA res_xpertISP //res_xpertTBL res_xpertFNA ///res_xpertNPA 
//res_xpertGATika res_xpertOther

//drop res_xpertmtbESP res_xpertmtbGAA res_xpertmtbISP  
keep record_id event xpert_res xpert_samplepos xpert_rif
reshape wide xpert_res xpert_samplepos xpert_rif, i(record_id) j(event) string
save "form_11_xpert_wide_fin.dta", replace

use "form_11_smear_wide_fin.dta", clear
save "form_11_wide.dta", replace

merge 1:1 record_id using "form_11_xpert_wide_fin.dta", assert(master using match) keep(master using match) generate(_xpert)
merge 1:1 record_id using "form_11_culture_wide_fin.dta", assert(master using match) keep(master using match) generate(_cul)

order xpert_reswk000 xpert_sampleposwk000 xpert_rifwk000 mgit_reswk000 mgit_sampleposwk000 ///
mgit_mtbdrplus_reswk000	res_mgit_rifwk000	res_mgit_inhwk000 ///
, after( smear_sampleposwk000)
order xpert_reswk002 xpert_sampleposwk002 xpert_rifwk002 mgit_reswk002 mgit_sampleposwk002 ///
mgit_mtbdrplus_reswk002	res_mgit_rifwk002	res_mgit_inhwk002 ///
, after( smear_sampleposwk002)
//order xpert_reswk008 xpert_sampleposwk008 xpert_rifwk008 mgit_reswk008 mgit_sampleposwk008 ///
//mgit_mtbdrplus_reswk008	res_mgit_rifwk008	res_mgit_inhwk008 ///
//, after( smear_sampleposwk008)
//order xpert_reswk016 xpert_sampleposwk016 xpert_rifwk016 mgit_reswk016 mgit_sampleposwk016 ///
//mgit_mtbdrplus_reswk016	res_mgit_rifwk016	res_mgit_inhwk016 ///
//, after( smear_sampleposwk016)
//order xpert_reswk024 xpert_sampleposwk024 xpert_rifwk024 mgit_reswk024 mgit_sampleposwk024 ///
//mgit_mtbdrplus_reswk024	res_mgit_rifwk024	res_mgit_inhwk024 ///
//, after( smear_sampleposwk024)
drop _xpert _cul
save "form_11_wide.dta", replace

use "form_11.dta", clear

//xpert
drop redcap_repeat_instrument redcap_repeat_instance umf11_u11_vst umf11_uf11_dob 
drop umf11_uf11_recdate umf11_uf11_rectime umf11_uf11_barcode_episode umf11_uf11_res_smear 
drop umf11_uf11_res_mgit umf11_uf11_res_mgit_mpt64 umf11_uf11_res_mgit_mtbdrplus umf11_uf11_res_mgit_oth_episode umf11_uf11_res_mgit_rif umf11_uf11_res_mgit_inh 
drop umf11_uf11_res_cul_ttpd umf11_uf11_res_cul_ttph umf11_uf11_res_cul_zn umf11_uf11_res_cul_inh umf11_uf11_res_cul_hain umf11_uf11_res_cul_ntm umf11_uf11_res_cul_mtbdrsl umf11_uf11_res_cul_mtbdrsl_q umf11_uf11_res_cul_mtbdrsl_sli umf11_uf11_res_cul_cmo form_11_tb_result_complete
drop umf11_uf11_col_time umf02_uf11_col_time umf11_uf11_col_volfl umf11_uf11_col_vol umf11_uf11_barcode_samplefl umf11_uf11_barcode_sample 
drop umf11_uf11_spectype

gen xpert_order = 2 if umf11_uf11_res_xpert==1 //"1 MTB complex NOT detected"
replace xpert_order = 5 if umf11_uf11_res_xpert==96 | umf11_uf11_res_xpert==. //"96 Not done" 
replace xpert_order = 4 if umf11_uf11_res_xpert==3 //"3 PCR result test unsuccessful"
replace xpert_order = 3 if umf11_uf11_res_xpert==4 //"4 Indeterminate"
replace xpert_order = 1 if umf11_uf11_res_xpert==2 //"2 MTB complex detected/trace"
gsort record_id xpert_order -umf11_uf11_res_xpert_sq
by record_id: gen n = _n
keep if n==1
drop n xpert_order
rename redcap_event_name xpert_event
rename umf11_uf11_col_date xpert_col_date
rename umf11_uf11_spectypen xpert_spectypen
//drop if record_id>"UM500"
save "form_11_xpert.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form_11_xpert.dta", assert(master match) keep(master match) generate(_xpert)
save "umoya_clinical.dta", replace

//culture
use "form_11.dta", clear
drop redcap_repeat_instrument redcap_repeat_instance umf11_u11_vst umf11_uf11_dob 
drop umf11_uf11_col_time umf02_uf11_col_time umf11_uf11_col_volfl umf11_uf11_col_vol umf11_uf11_barcode_samplefl umf11_uf11_barcode_sample 
drop umf11_uf11_spectype umf11_uf11_recdate umf11_uf11_rectime umf11_uf11_barcode_episode umf11_uf11_res_smear umf11_uf11_res_xpert umf11_uf11_res_xpertmtb
drop umf11_uf11_res_xpert_ultra umf11_uf11_res_xpert_sq umf11_uf11_res_cul_ttpd umf11_uf11_res_cul_ttph umf11_uf11_res_cul_zn umf11_uf11_res_cul_inh umf11_uf11_res_cul_hain umf11_uf11_res_cul_ntm umf11_uf11_res_cul_mtbdrsl umf11_uf11_res_cul_mtbdrsl_q umf11_uf11_res_cul_mtbdrsl_sli umf11_uf11_res_cul_cmo form_11_tb_result_complete
keep if inlist(umf11_uf11_res_mgit, 0, 1, 2, 3)
gen cul_order = 1 if umf11_uf11_res_mgit==1
replace cul_order = 2 if umf11_uf11_res_mgit==2
replace cul_order = 3 if umf11_uf11_res_mgit==3
replace cul_order = 4 if umf11_uf11_res_mgit==0
sort record_id cul_order umf11_uf11_col_date
by record_id: gen n = _n
keep if n==1
drop cul_order n
rename redcap_event_name cul_event
rename umf11_uf11_col_date cul_col_date
rename umf11_uf11_spectypen cul_spectypen
//drop if record_id>"UM500"
save "form_11_culture.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "form_11_culture.dta", assert(master match) keep(master match) generate(_cul)
save "umoya_clinical.dta", replace

use "umoya_clinical.dta", clear

merge 1:1 record_id using "form_11_wide.dta", ///
assert(master match) keep(master match) generate(_form11)

save "umoya_clinical.dta", replace

//drop umf15_ueos_visdate 
//drop hiv_order n
		*Age in months
		
gen age_days = umf01_ubl_visdate - umf01_ubl_dob
label variable age_days "Age in days at enrloment"
order age_days, after( umf01_ubl_dob)
gen age_years = (umf01_ubl_visdate - umf01_ubl_dob) / 365.25
label variable age_years "Age in years at enrolment"
order age_years, after(age_days)
//format %9.2g age_years
gen age_months = (umf01_ubl_visdate - umf01_ubl_dob) / 30.4375
order age_months, after(age_years)
label variable age_months "Age in months at enrolment"
//format %9.2g age_months
gen age_cat = 1 if age_months >= 0 & age_months <= 12
replace age_cat = 2 if age_months > 12 & age_months <= 60
replace age_cat = 3 if age_months > 60 & age_months != .
label define _age_cat_mo 1 "0-12 months" 2 "13-60 months" 3 "older 60 months"
label values age_cat _age_cat_mo
order age_cat, after(age_months)
label variable age_cat "Age category in months"

gen hivexposure = umf01_ubl_hivexposure
order hivexposure, after(age_months)
gen bl_child_hiv = umf01_ubl_childhiv
order bl_child_hiv, after(hivexposure)
order umf07_uf7_hivtest umf07_uf7_daterecenthivtest umf07_uf7_resulthivtest, after(bl_child_hiv)
gen hiv_fin = 1 if bl_child_hiv==1 | umf07_uf7_resulthivtest==1
replace hiv_fin = 0 if hiv_fin==. & (bl_child_hiv==0 | umf07_uf7_resulthivtest==0)
order hiv_fin, before(hivexposure)
recast byte hiv_fin
label values hiv_fin umf07_uf7_resulthivtest_

gen hiv_exposure_fin = 1 if hiv_fin==1
replace hiv_exposure_fin = 2 if hiv_exposure_fin==. & hiv_fin==0 & hivexposure==1
replace hiv_exposure_fin = 3 if hiv_exposure_fin==. & hiv_fin==0 & hivexposure==0
replace hiv_exposure_fin = 4 if hiv_exposure_fin==. & hiv_fin==0 & (hivexposure==. | hivexposure==98)
label values hiv_fin umf07_uf7_resulthivtest_
label define hiv_exposure_fin_ 1 "HIV positive" 2 "HIV exposed - negative" 3 "HIV unexposed - negative" 4 "HIV exposed unk - negative"
label values hiv_exposure_fin hiv_exposure_fin_
order hiv_exposure_fin, after(hiv_fin)

order tst_donewk000 tstdatewk000 tstresultwk000 tstindurationwk000 visdatewk002 tst_donewk002 tstdatewk002 tstresultwk002 tstindurationwk002 ///
visdatewk008 tst_donewk008 tstdatewk008 tstresultwk008 tstindurationwk008, after( umf07_uf7_resulthivtest)

order smear_reswk000 smear_sampleposwk000 xpert_reswk000 xpert_sampleposwk000 xpert_rifwk000 mgit_reswk000 mgit_sampleposwk000 smear_reswk002 smear_sampleposwk002 xpert_reswk002 xpert_sampleposwk002 xpert_rifwk002 mgit_reswk002 mgit_sampleposwk002 ,after(tstindurationwk008)
gen bl_bact_conf=1 if mgit_reswk000==1 | xpert_reswk000==1
order bl_bact_conf, after( bl_child_hiv)

gen wk2_bact_conf = 1 if mgit_reswk002==1 | xpert_reswk002==1
order wk2_bact_conf, after( bl_bact_conf)

//merge 1:1 record_id using "tb_rx.dta", assert(master match) keep(master match) generate(_tbrx)
//order startedtbtreatment tbtreatstartdate , after(umf03_uw8_vs_tbclass)

save "umoya_clinical.dta", replace

//tb rx
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "Tbrxbltowk24.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=1315        ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'
do "UmoyaRestructure-Tbrxbltowk24.do"

keep if umf01_ubl_visdate!=. | umf02_uw2_visdate!=. | ///
umf03_uw8_visdate!=. | umf04_uw16_visdate!=. | umf05_uw24_visdate!=. | ///
umf06_uuns_visdate!=.
drop redcap_repeat_instrument redcap_repeat_instance
//bl
gen tb_visit_date = umf01_ubl_visdate if strpos(redcap_event_name, "baseline") > 0
order tb_visit_date, after( redcap_event_name)
format tb_visit_date %td
gen tb_treament = 0 if strpos(redcap_event_name, "baseline") > 0
order tb_treament, after(tb_visit_date)
replace tb_treament = 1 if umf01_ubl_startedtbtreatment == 1 & strpos(redcap_event_name, "baseline") > 0
gen startedtbtreatment = umf01_ubl_startedtbtreatment if strpos(redcap_event_name, "baseline") > 0
order startedtbtreatment, after( tb_treament)
label values tb_treament startedtbtreatment umf01_ubl_startedtbtreatment_
gen tbtreatstartdate = umf01_ubl_tbtreatstartdate if strpos(redcap_event_name, "baseline") > 0
order tbtreatstartdate, after( startedtbtreatment)
format tbtreatstartdate %td
//wk2
replace tb_visit_date = umf02_uw2_visdate if strpos(redcap_event_name, "week_2") > 0
replace tb_treament = 1 if umf02_uw2_ontbrxr == 1 & strpos(redcap_event_name, "week_2") > 0
replace tb_treament = 0 if tb_treament != 1 & umf02_uw2_ontbrxr == 0 & strpos(redcap_event_name, "week_2") > 0
replace tb_treament = 1 if umf02_uw2_startedtbtreatment == 1 & strpos(redcap_event_name, "week_2") > 0
replace tb_treament = 0 if tb_treament != 1 & umf02_uw2_startedtbtreatment == 0 & strpos(redcap_event_name, "week_2") > 0
replace startedtbtreatment = umf02_uw2_startedtbtreatment if startedtbtreatment != 1 & startedtbtreatment==. & strpos(redcap_event_name, "week_2") > 0
replace tbtreatstartdate = umf02_uw2_tbtreatstartdate if startedtbtreatment != 1 & umf02_uw2_startedtbtreatment==1 & strpos(redcap_event_name, "week_2") > 0
//wk 8
replace tb_visit_date = umf03_uw8_visdate if strpos(redcap_event_name, "week_8") > 0
replace tb_treament = 1 if umf03_uw8_tbrxr == 1 & strpos(redcap_event_name, "week_8") > 0
replace tb_treament = 0 if tb_treament != 1 & umf03_uw8_tbrxr == 0 & strpos(redcap_event_name, "week_8") > 0
replace tb_treament = 1 if umf03_uw8_startedtbtreatment == 1 & strpos(redcap_event_name, "week_8") > 0
replace tb_treament = 0 if tb_treament != 1 & umf03_uw8_startedtbtreatment == 0 & strpos(redcap_event_name, "week_8") > 0
replace startedtbtreatment = startedtbtreatment != 1 & umf03_uw8_startedtbtreatment if startedtbtreatment==. & strpos(redcap_event_name, "week_8") > 0
replace tbtreatstartdate = umf03_uw8_tbtreatstartdate if startedtbtreatment != 1 & startedtbtreatment==1 & strpos(redcap_event_name, "week_8") > 0
//wk 16
replace tb_visit_date = umf04_uw16_visdate if strpos(redcap_event_name, "week_16") > 0
replace tb_treament = 1 if umf04_uw16_participanttbtreat == 1 & strpos(redcap_event_name, "week_16") > 0
replace tb_treament = 0 if tb_treament != 1 & umf04_uw16_participanttbtreat == 0 & strpos(redcap_event_name, "week_16") > 0
replace tb_treament = 1 if umf04_uw16_startedtbtreatment == 1 & strpos(redcap_event_name, "week_16") > 0
replace tb_treament = 0 if tb_treament != 1 & umf04_uw16_startedtbtreatment == 0 & strpos(redcap_event_name, "week_16") > 0
replace startedtbtreatment = umf04_uw16_startedtbtreatment if startedtbtreatment != 1 & startedtbtreatment==. & strpos(redcap_event_name, "week_16") > 0
replace tbtreatstartdate = umf04_uw16_tbtreatstartdate if startedtbtreatment != 1 & umf04_uw16_startedtbtreatment == 1 & strpos(redcap_event_name, "week_16") > 0
//wk 24
replace tb_visit_date = umf05_uw24_visdate if strpos(redcap_event_name, "week_24") > 0
replace tb_treament = 1 if tb_treament != 1 & umf05_uw24_participanttbtreat == 1 & strpos(redcap_event_name, "week_24") > 0
replace tb_treament = 0 if tb_treament != 1 & umf05_uw24_participanttbtreat == 0 & strpos(redcap_event_name, "week_24") > 0

//uns
replace tb_visit_date = umf06_uuns_visdate if strpos(redcap_event_name, "unscheduled") > 0
replace tb_treament = 1 if umf06_uuns_participanttbtreat == 1 & strpos(redcap_event_name, "unscheduled") > 0
replace tb_treament = 0 if tb_treament != 1 & umf06_uuns_participanttbtreat == 0 & strpos(redcap_event_name, "unscheduled") > 0
replace tb_treament = 1 if umf06_uuns_startedtbtreatment == 1 & strpos(redcap_event_name, "unscheduled") > 0
replace tb_treament = 0 if tb_treament != 1 & umf06_uuns_startedtbtreatment == 0 & strpos(redcap_event_name, "unscheduled") > 0
replace startedtbtreatment = umf06_uuns_startedtbtreatment if startedtbtreatment != 1 & startedtbtreatment==. & strpos(redcap_event_name, "unscheduled") > 0
replace tbtreatstartdate = umf06_uuns_tbtreatstartdate if startedtbtreatment != 1 & umf06_uuns_startedtbtreatment == 1 & strpos(redcap_event_name, "unscheduled") > 0

replace tb_treament = -1 if tb_treament==. | tb_treament == 2
replace startedtbtreatment = -1 if startedtbtreatment==. | startedtbtreatment==94
//drop if record_id>"UM500"
save "tb_rx.dta", replace

use "tb_rx.dta", clear
save "tb_rx_1st.dta", replace
gsort record_id -tb_treament -startedtbtreatment -tbtreatstartdate
by record_id: gen n = _n
order n, after(tbtreatstartdate)
keep if n==1
drop n
//keep if startedtbtreatment == 1
drop redcap_event_name 
//redcap_repeat_instrument redcap_repeat_instance
drop umf04_uw16_participanttbtreat umf05_uw24_participanttbtreat umf05_uw24_tbtreatcomp umf05_uw24_reasontreatincomp umf01_ubl_visdate umf01_ubl_startedtbtreatment umf01_ubl_tbtreatstartdate umf02_uw2_visdate umf02_uw2_ontbrxr umf02_uw2_startedtbtreatment umf02_uw2_tbtreatstartdate umf03_uw8_visdate umf03_uw8_tbrxr umf03_uw8_tbclass umf03_uw8_startedtbtreatment umf03_uw8_tbtreatstartdate umf04_uw16_visdate umf04_uw16_startedtbtreatment umf04_uw16_tbtreatstartdate umf05_uw24_visdate umf06_uuns_visdate umf06_uuns_participanttbtreat umf06_uuns_startedtbtreatment umf06_uuns_tbtreatstartdate
save "tb_rx_1st.dta", replace

//tb rx from logs
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "for14_events.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=493        ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'
do "UmoyaRestructure-Form14events.do"

drop if umf14_reportingdt ==.
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance 
drop umf14_sitenumber umf14_reportedas___1 umf14_reportedas___2 
drop umf14_reportedas___4 umf14_events_deathdt umf14_deathcause umf14_deathplace 
keep if umf14_reportedas___3==1
drop umf14_hosp_admissiondt umf14_admissiondt_est umf14_hosp_dischargedt umf14_dischargedt_est umf14_admission_reason umf14_imaging umf14_samplesfortbtest 
drop umf14_sampling_event umf14_commentsyn umf14_comments form_14_events_complete 
drop umf14_drug_regimenyn umf14_drugregimen_wason umf14_drugregimen_changedto umf14_newtreatmentdt umf14_newtreatment_est umf14_reason_change umf14_reason_change_oth umf14_grade3_adv_event umf14_grade3_lab umf14_grade3_4_clinical umf14_iris_yn umf14_iris_treatchange umf14_iris_extension umf14_iris_prednisone umf14_iris_changesdt umf14_changesdt_est umf14_adherenceyn umf14_adherence_treatmentdt umf14_adherence_ext umf14_adherence_change umf14_adherence_actiondt umf14_adherence_actionest 
drop if umf14_tbstatus_change==.
gsort record_id -umf14_status_conversion
by record_id: gen n = _n
drop if n > 1

save "form14events_tb.dat", replace

use "tb_rx.dta", clear
save "tb_rx_wk16.dta", replace 
keep if redcap_event_name=="week_16_arm_1" | ///
redcap_event_name=="week_16_arm_2" | ///
redcap_event_name=="week_16_arm_3"
drop umf05_uw24_participanttbtreat umf05_uw24_tbtreatcomp umf05_uw24_reasontreatincomp umf01_ubl_visdate umf01_ubl_startedtbtreatment umf01_ubl_tbtreatstartdate umf02_uw2_visdate umf02_uw2_ontbrxr umf02_uw2_startedtbtreatment umf02_uw2_tbtreatstartdate umf03_uw8_visdate umf03_uw8_tbrxr umf03_uw8_tbclass umf03_uw8_startedtbtreatment umf03_uw8_tbtreatstartdate umf04_uw16_visdate umf04_uw16_startedtbtreatment umf04_uw16_tbtreatstartdate umf05_uw24_visdate
drop redcap_event_name 
//redcap_repeat_instrument redcap_repeat_instance
rename tb_visit_date visit_date_wk16
drop startedtbtreatment tbtreatstartdate
gsort record_id umf04_uw16_participanttbtreat -visit_date_wk16
by record_id: gen n = _n
keep if n == 1
drop n
rename umf04_uw16_participanttbtreat w16_participanttbtreat
save "tb_rx_wk16.dta", replace 

use "tb_rx_1st.dta", clear
merge 1:1 record_id using "tb_rx_wk16.dta", assert(master match) keep(master match) keepusing(visit_date_wk16 w16_participanttbtreat) generate(_wk16)
save "tb_rx_1st.dta", replace

use "tb_rx.dta", clear
save "tb_rx_wk24.dta", replace 
keep if redcap_event_name=="week_24_arm_1" | ///
redcap_event_name=="week_24_arm_2" | ///
redcap_event_name=="week_24_arm_3"
drop redcap_event_name 
//redcap_repeat_instrument redcap_repeat_instance
drop startedtbtreatment tbtreatstartdate umf04_uw16_participanttbtreat
drop umf01_ubl_visdate umf01_ubl_startedtbtreatment umf01_ubl_tbtreatstartdate umf02_uw2_visdate umf02_uw2_ontbrxr umf02_uw2_startedtbtreatment umf02_uw2_tbtreatstartdate umf03_uw8_visdate umf03_uw8_tbrxr umf03_uw8_tbclass umf03_uw8_startedtbtreatment umf03_uw8_tbtreatstartdate umf04_uw16_visdate umf04_uw16_startedtbtreatment umf04_uw16_tbtreatstartdate umf05_uw24_visdate
rename tb_visit_date visit_date_wk24
gsort record_id umf05_uw24_participanttbtreat -visit_date_wk24
by record_id: gen n = _n
keep if n == 1
drop n
rename umf05_uw24_participanttbtreat w24_participanttbtreat 
rename umf05_uw24_tbtreatcomp w24_tbtreatcomp 
rename umf05_uw24_reasontreatincomp w24_reasontreatincomp
save "tb_rx_wk24.dta", replace 

use "tb_rx_1st.dta", clear
merge 1:1 record_id using "tb_rx_wk24.dta", assert(master match) keep(master match) keepusing(visit_date_wk24 w24_participanttbtreat w24_tbtreatcomp w24_reasontreatincomp) generate(_wk24)
save "tb_rx_1st.dta", replace

use "tb_rx.dta", clear
save "tb_rx_uns.dta", replace 
keep if redcap_event_name=="unscheduled_1_arm_1" | ///
redcap_event_name=="unscheduled_1_arm_2" | ///
redcap_event_name=="unscheduled_1_arm_3"
drop redcap_event_name 
//redcap_repeat_instrument redcap_repeat_instance
drop umf04_uw16_participanttbtreat umf05_uw24_participanttbtreat umf05_uw24_tbtreatcomp umf05_uw24_reasontreatincomp umf01_ubl_visdate umf01_ubl_startedtbtreatment umf01_ubl_tbtreatstartdate umf02_uw2_visdate umf02_uw2_ontbrxr umf02_uw2_startedtbtreatment umf02_uw2_tbtreatstartdate umf03_uw8_visdate umf03_uw8_tbrxr umf03_uw8_tbclass umf03_uw8_startedtbtreatment umf03_uw8_tbtreatstartdate umf04_uw16_visdate umf04_uw16_startedtbtreatment umf04_uw16_tbtreatstartdate umf05_uw24_visdate umf06_uuns_visdate
rename tb_visit_date visit_date_uns
drop startedtbtreatment tbtreatstartdate
drop umf06_uuns_startedtbtreatment umf06_uuns_tbtreatstartdate
gsort record_id umf06_uuns_participanttbtreat -visit_date_uns
by record_id: gen n = _n
keep if n == 1
drop n
rename umf06_uuns_participanttbtreat uuns_participanttbtreat
save "tb_rx_uns.dta", replace 

use "tb_rx_1st.dta", clear
merge 1:1 record_id using "tb_rx_uns.dta", assert(master match) keep(master match) keepusing(visit_date_uns uuns_participanttbtreat) generate(_uns)
save "tb_rx_1st.dta", replace

//add tb log data
use "tb_rx_1st.dta", clear
merge 1:1 record_id using "form14events_tb.dat", assert(master match) keep(master match) generate(_tblog)
save "tb_rx_1st.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "tb_rx_1st.dta", assert(master match) keep(master match) generate(_tbrx_all)
/*change TB Rx from logs
C1 TB status change 1 - Ill control to TB case
2 - Tb case to Ill control
3 - Healthy control to TB case
*/
replace tbtreatstartdate = umf14_status_conversion if tb_treament==0 & inlist(umf14_tbstatus_change, 1, 3)
replace tb_treament=1 if tb_treament==0 & inlist(umf14_tbstatus_change, 1, 3)
replace startedtbtreatment=1 if startedtbtreatment==0 & inlist(umf14_tbstatus_change, 1, 3)
order tb_visit_date tb_treament, before(startedtbtreatment)
save "umoya_clinical.dta", replace

//tb preventative rx
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "Tbprevrxbltowk24.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=1331        ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'
do "UmoyaRestructure-Tbpreventrxbltowk24.do"

keep if umf01_ubl_visdate!=. | umf02_uw2_visdate!=. | ///
umf03_uw8_visdate!=. | umf04_uw16_visdate!=. | umf05_uw24_visdate!=. | ///
umf06_uuns_visdate!=.
gen visit_date = umf01_ubl_visdate
order visit_date, after( redcap_repeat_instance)
format visit_date %td
gen prev_tbtreatment = umf01_ubl_startedtbprev
order prev_tbtreatment, after( visit_date)
label values prev_tbtreatment umf01_ubl_startedtbprev_
gen prev_tbtreatstartdate = umf01_ubl_tbprevtreatdate
order prev_tbtreatstartdate, after( prev_tbtreatment)
format prev_tbtreatstartdate %td
replace visit_date = umf02_uw2_visdate if visit_date==.
replace prev_tbtreatment = umf02_uw2_startedtbprev ///
if prev_tbtreatment==.
replace prev_tbtreatstartdate = umf02_uw2_tbprevtreatdate ///
if prev_tbtreatstartdate==.
replace visit_date = umf03_uw8_visdate if visit_date==.
replace prev_tbtreatment = umf03_uw8_startedtbprev ///
if prev_tbtreatment==.
replace prev_tbtreatstartdate = umf03_uw8_tbprevtreatdate ///
if prev_tbtreatstartdate==.
replace visit_date = umf04_uw16_visdate if visit_date==.
replace prev_tbtreatment = umf04_uw16_startedtbprev ///
if prev_tbtreatment==.
replace prev_tbtreatstartdate = umf04_uw16_tbprevtreatdate ///
if prev_tbtreatstartdate ==.

replace visit_date = umf06_uuns_visdate if visit_date==.
replace prev_tbtreatment = umf06_uuns_startedtbprev ///
if prev_tbtreatment==.
replace prev_tbtreatstartdate = umf06_uuns_tbprevtreatdate if ///
prev_tbtreatstartdate ==.

replace visit_date = umf05_uw24_visdate if visit_date == .
replace prev_tbtreatment = -1 if prev_tbtreatment==94
//drop if record_id>"UM500"
save "prev_tb_rx.dta", replace

use "prev_tb_rx.dta", clear
save "prev_tb_rx_1st.dta", replace
gsort record_id -prev_tbtreatment prev_tbtreatstartdate visit_date
by record_id: gen n = _n
order n, after(prev_tbtreatstartdate)
keep if n==1
drop n
//keep if startedtbtreatment == 1
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance
drop umf01_ubl_visdate umf01_ubl_startedtbprev umf01_ubl_tbprevtreatdate umf01_ubl_est_2 umf02_uw2_visdate umf02_uw2_startedtbprev umf02_uw2_tbprevtreatdate umf02_uw2_estimate_3 umf03_uw8_visdate umf03_uw8_startedtbprev umf03_uw8_tbprevtreatdate umf03_uw8_est3 umf04_uw16_visdate umf04_uw16_startedtbprev umf04_uw16_tbprevtreatdate umf04_uw16_est3 umf05_uw24_visdate umf05_uw24_tbprevrxstop umf05_uw24_tbprevtreatdate umf05_uw24_est_3 umf06_uuns_visdate umf06_uuns_startedtbprev umf06_uuns_tbprevtreatdate umf06_uuns_est_3
save "prev_tb_rx_1st.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "prev_tb_rx_1st.dta", assert(master match) keep(master match) generate(_prevtbrx_all)
rename prev_tbtreatment preventative_tbtrx
rename prev_tbtreatstartdate preventative_tbtrx_date
order preventative_tbtrx ,after(tbtreatstartdate)
order preventative_tbtrx_date ,after(preventative_tbtrx)
drop if study_outcome=="" & visit_date==.
order startedtbtreatment tbtreatstartdate preventative_tbtrx preventative_tbtrx_date, after( registration_complete)
save "umoya_clinical.dta", replace

//XrayEnv form 17 bl
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "1C334B5FDC4D3349AB2B79C343EC51CC"
local outfile "XrayEnv_Form17_bl.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=533    ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'

do "XrayEnv-UmoyaXrayBaseline.do"
rename study_pid record_id
drop if umf17a_vsdtc==. & umf17a_ap_redtc==.

save "XrayEnv-Form17ChestXrayCxrEv_bl.dta", replace

//XrayEnv form 17 fu
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "1C334B5FDC4D3349AB2B79C343EC51CC"
local outfile "XrayEnv_Form17_fu.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=534    ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'

do "XrayEnv-UmoyaXrayfu.do"
rename study_pid record_id
drop if umf17b_vsdtc==. & umf17b_ap_redtc==.

save "XrayEnv-Form17ChestXrayCxrEv_fu.dta", replace


//XrayEnv form19 bl
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "1C334B5FDC4D3349AB2B79C343EC51CC"
local outfile "XrayEnv_Form19_bl.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=1341    ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'

do "XrayEnv-Form19ChestXrayCxrEv_bl.do"
rename study_pid record_id
keep if umf19_ai_ant_post_cxr!=.
keep if redcap_event_name=="baseline_arm_2"

save "XrayEnv-Form19ChestXrayCxrEv_bl.dta", replace

//use "umoya_nih_aim1.dta", clear
//merge 1:1 record_id using "XrayEnv-Form19ChestXrayCxrEv_bl.dta", assert(master match) keep(master match) generate(_bl_form19)
//save "umoya_nih_aim1.dta", replace

//XrayEnv form19 wk24
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "1C334B5FDC4D3349AB2B79C343EC51CC"
local outfile "XrayEnv_Form19_wk24.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=1417    ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'

do "XrayEnv-Form19ChestXrayCxrEv_wk24.do"
rename study_pid record_id
drop if umf19_date_ap_xray==.
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance
save "XrayEnv-Form19ChestXrayCxrEv_wk24.dta", replace

use "umoya_clinical.dta", clear

//merge 1:1 record_id using "D:\Data\umoya\nih clinical def\nih case definition SOP 20230404\umoya_nih_aim1.dta", assert(master match) keep(master match) keepusing(NIH_Category_aim1_nocxr NIH_Category_aim1_nocxr_rev NIH_aim1_nocxr_wk8_rev NIH_Category_aim1_cxr NIH_Category_aim1_cxr_rev NIH_aim1_cxr_wk8_rev NIH_Category_aim2a_cxr NIH_Category_aim2a_cxr_rev NIH_aim2a_cxr_wk8_rev NIH_Category_aim2b_cxr NIH_Category_aim2b_cxr_rev NIH_aim2b_cxr_wk8_rev) generate(_nih)

//order tb_visit_date tb_treament startedtbtreatment tbtreatstartdate preventative_tbtrx preventative_tbtrx_date NIH_Category_aim1_nocxr NIH_Category_aim1_nocxr_rev NIH_aim1_nocxr_wk8_rev NIH_Category_aim1_cxr NIH_Category_aim1_cxr_rev NIH_aim1_cxr_wk8_rev NIH_Category_aim2a_cxr NIH_Category_aim2a_cxr_rev NIH_aim2a_cxr_wk8_rev NIH_Category_aim2b_cxr NIH_Category_aim2b_cxr_rev NIH_aim2b_cxr_wk8_rev, after(Completed)
gen enrolment_date = umf01_ubl_visdate
order enrolment_date, after( record_id)
format enrolment_date %td
save "umoya_clinical.dta", replace

//combine cxr readers
use "XrayEnv-Form17ChestXrayCxrEv_bl.dta", clear


keep record_id umf17a_vsdtc umf17a_ap_redtc umf17a_l_redtc ///
umf17a_tqualap_reorres ///
umf17a_tquallat_reorres ///
umf17a_g1intp_reorres ///
umf17a_ops_parenchymayn ///
umf17a_ops_airspaced ///
umf17a_milltb_orres ///
umf17a_cvts_orres ///
umf17a_ops_lphndyn ///
umf17a_plrlffsn_orres ///
umf17a_g1intp_reorres_1 ///
umf17a_impression_typicaltb ///
umf17a_completedname umf17a_completeddt

gen quality_ap = umf17a_tqualap_reorres
gen quelity_lateral = umf17a_tquallat_reorres
tab umf17a_g1intp_reorres
gen cxr_normal = umf17a_g1intp_reorres
gen parenchymal_involvement = umf17a_ops_parenchymayn
gen airspace_opacity = umf17a_ops_airspaced
gen miliary = umf17a_milltb_orres
gen cavities = umf17a_cvts_orres
gen lymph_nodes = umf17a_ops_lphndyn
gen effusion = umf17a_plrlffsn_orres
gen interpretation = umf17a_g1intp_reorres_1
gen severity = umf17a_impression_typicaltb
gen reader_name = umf17a_completedname
gen read_date = umf17a_completeddt

drop umf17a_tqualap_reorres umf17a_tquallat_reorres umf17a_g1intp_reorres ///
umf17a_ops_parenchymayn umf17a_ops_airspaced umf17a_milltb_orres ///
umf17a_cvts_orres umf17a_ops_lphndyn umf17a_plrlffsn_orres ///
umf17a_g1intp_reorres_1 umf17a_impression_typicaltb umf17a_completedname ///
umf17a_completeddt

gen cavities_score = 5 if cavities==1
gen lymph_nodes_score = 17 if lymph_nodes==1
gen airspace_opacity_score = 5 if airspace_opacity==1
gen miliary_score = 15 if miliary==1
gen effusion_score = 8 if effusion==1

replace cavities_score = 0 if cavities_score==.
replace lymph_nodes_score = 0 if lymph_nodes_score==.
replace airspace_opacity_score = 0 if airspace_opacity_score==.
replace miliary_score = 0 if miliary_score==.
replace effusion_score = 0 if effusion_score==.

//label define umf17a_tqualap_reorres_ 1 "1 - Acceptable" 0 "0 - Not acceptable" 
//label define umf17a_tquallat_reorres_ 1 "1 - Acceptable" 0 "0 - Not acceptable" 94 "94 - Not applicable" 
//label define umf17a_g1intp_reorres_ 1 "1 - Chest X-ray Normal" 2 "2 - CXR not normal" 3 "3 - PH infiltrates only" 
//label define umf17a_ops_parenchymayn_ 1 "1 - Yes" 0 "0 - No" 
//label define umf17a_g1intp_reorres_1_ 1 "1 - Typical TB" 2 "2 - Abnormal, not typical of TB" 
//label define umf17a_impression_typicaltb_ 1 "1 - Non-severe" 2 "2 - Severe" 

label values quality_ap umf17a_tqualap_reorres_
label values quelity_lateral umf17a_tquallat_reorres_
label values cxr_normal umf17a_g1intp_reorres_
label values parenchymal_involvement umf17a_ops_parenchymayn_
label values interpretation umf17a_g1intp_reorres_1_
label values severity umf17a_impression_typicaltb_

gen cxr_score = cavities_score + lymph_nodes_score + airspace_opacity_score + miliary_score + effusion_score

//double check prof sch
keep if strpos( reader_name, "GOUS") > 0 | strpos( reader_name, "SCH") > 0
gen prof_sch = 1 if strpos( reader_name, "SCH")
replace prof_sch = 0 if strpos( reader_name, "GOUS")
gsort record_id -prof_sch
by record_id: gen reader_include = _n
order reader_include, after(record_id)
//bro record_id reader_include quality_ap quelity_lateral cxr_normal cavities_score lymph_nodes_score airspace_opacity_score miliary_score effusion_score cxr_score interpretation severity reader_name read_date

save "Umoya-Form17ChestXray_bl_who_score.dta", replace

keep if reader_include==1
save "Umoya-Form17ChestXray_bl_who_score_high_who_score_reader.dta", replace

use "umoya_clinical.dta", clear

merge 1:1 record_id using "Umoya-Form17ChestXray_bl_who_score_high_who_score_reader.dta", assert(master match) keep(master match) generate(_xray_who)

save "umoya_clinical.dta", replace

//form8 
version 14
set more off
clear 

*** cURL Settings (update to match your system and REDCap)
local curlpath "C:/Windows/System32/curl.exe" // Folder where cURL is installed (MacOS: "/usr/bin/curl")
local apiurl "https://data.dttc.sun.ac.za/redcap/api/" // Link to REDCap database
local token "B95D1C242852523C461DE44D04AE3713"
local outfile "UmoyaRestructure-Form8counsellorinfor.csv"

shell C:/Windows/System32/curl.exe		///
	--output `outfile' 		///
	--form token=`token'	///
	--form content=report 	///
	--form format=csv       ///
	--form report_id=459    ///
	"https://data.dttc.sun.ac.za/redcap/api/"

import delimited `outfile'

do "UmoyaRestructure-Form8counsellorinfor.do"
drop if umf08_uf8_visdate==.
//drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance
merge m:1 record_id using "umoya_clinical.dta", assert(master match) keep(master match) keepusing(umf01_ubl_dob umf01_ubl_gender) generate(_form8)
order umf01_ubl_dob umf01_ubl_gender, after(record_id)
save "UmoyaRestructure-Form8counsellorinfor.dta", replace

save "UmoyaRestructure-Form8counsellorinfor_zscore.dta", replace

gen week = 0 if strpos(redcap_event_name, "baseline") > 0
order week, after(record_id)
replace week = 999 if strpos(redcap_event_name, "unscheduled") > 0 
replace week = 16 if strpos(redcap_event_name, "week_16") > 0
replace week = 24 if strpos(redcap_event_name, "week_24_") > 0
replace week = 2 if strpos(redcap_event_name, "week_2_") > 0
replace week = 52 if strpos(redcap_event_name, "week_52") > 0
replace week = 8 if strpos(redcap_event_name, "week_8_") > 0
replace week = 104 if strpos(redcap_event_name, "week_104") > 0
replace week = 156 if strpos(redcap_event_name, "week_156") > 0
replace week = 208 if strpos(redcap_event_name, "week_208") > 0
replace week = 999 if strpos(redcap_event_name, "visit_unknown_rout") > 0

/*******************************************************************************
Do-file created by Eline Wijstma on 16/10/2023
In this do-file, I create anthopometry Z scores for UMOYA participants:
	
	> Weight-for-age Z for children under 5 (zscore06 package, WHO 2006)
	> Weight-for-age Z for children 5-10 (zanthro package, WHO 2007)
	> Weight-for-height Z for children under 5 (zscore06 package, WHO 2006)
	> Weight-for-height Z for children 5-10 (zanthro package, WHO 2007)
	> BMI Z (all children aged 10 years or older)

I start with the long-format raw antrhopometry dataset (easier than wode format).
I later merge this to the clinical datasets.
*******************************************************************************/

** define globals

** TO DO:
** WHZ/WAZ NAAR BMI FOR HEIGHT SCORE VOOR KINDEREN BOVEN 10
** HEIGHT FOR AGE SCORE BEREKENEN VOOR ALLE GROEPEN -> DESCRIPTIVE
	
	rename umf01_ubl_dob dob
	rename umf01_ubl_gender gender
	rename umf08_uf8_* *
	
** Z scores are age-standardised. 

** PREPARATION 

	* Step 1: check dob and visit variables: impossible visits before birth?
	list record_id dob visdate if dob>visdate | dob==.
//	replace visdate=mdy(08,17,2021) if record_id=="UM380" & visdate==mdy(08,17,2020)
//	replace dob=mdy(12,16,2007) if record_id=="UM004"
	drop if dob==.
	list record_id dob visdate if dob>visdate | dob==. //ok, no more impossible visits
	list record_id dob visdate in 1/10 //ok, dob across all recrods
	

	* Step 2: make a variable with age per visit

		*Age in months
		gen agemo=(visdate-dob)/30.4375
		label variable agemo "Age in months at visit"
		
		*Age in years
		gen agey=(visdate-dob)/365.25
		label variable agey "Age in years at visit"

	* Step 3: destring weight variables
	
	des weight length muac // string variable
	tab weight //one child: weight is 9:01 -> cannot be destringed
	//destring weight, generate(weight2) force
	destring muac, generate(muac2) force
	drop muac
    rename muac2 muac
	//bro if weight2==.
	//replace weight="9.01" if weight=="9:01" 
	
	//destring weight, replace
	//sum weight, d
	//count if weight==.
	
		
** Z SCORE CALCULATION

** Part 1: Z scores for children up to 5 years

	**findit zscore06
	**ssc install zscore06
	**This package is based on the WHO Z scores
	**Height should be in centimeters, weight in kilograms, age in months -> ok.
		
	zscore06, a(agemo) h(length) w(weight) s(gender) female(1) male(0)
	
	** Check: which variables are made?
	des, f
	drop haz06 bmiz06
	rename waz06 waz 
	rename whz06 whz
	
	label variable waz "Weight for age Z score (based on 2006/2007 WHO standards)"
	label variable whz "Weight for height Z score (based on 2006/2007 WHO standards)"
	
	
		** Check: z scores not calculated // implausible? 
		count if waz==99 
		count if whz==99 
		
		count if waz==99 & agemo<61 //ok, all among kids older than 5
		count if whz==99 & agemo<61 //4 kids 
		list whz record_id visdate  gender weight length agemo if whz==99 & agemo<61
		** length is smaller than is allowed for the calculator (min 45 cm)
		
		replace waz=. if waz==99
		replace whz=. if whz==99
			
		** Check any biologically implausible scores? no
		count if waz < -6 | (waz > 6 & waz!=.) //ok
		count if whz < -6 | (whz > 6 & whz!=.) //ok	
		
** Part 2: Z scores for children 5-10 years	
		
	*findit zanthro
	*help zanthro
	*age can be in days, months, years -> just specify the ageunit
	*height in cm, weight in kilograms
	*This package aalows various Z score calculations, I specify: WHO
	
	** weight for age (wa)
	egen waz_older=zanthro(weight,wa,WHO) if agemo>=61 & agemo<120, ///
	xvar(agemo) gender(gender) gencode(male=0, female=1) ///
	ageunit(month) nocutoff
	
	** weight for height (wh)
	egen whz_older=zanthro(weight,wh,WHO) if agemo>=61 & agemo<120, ///
	xvar(length) gender(gender) gencode(male=0, female=1) nocutoff
	
	
	** Check any biologically implausible scores? Yes -> change to missing
	
	count if waz_older < -6 | (waz_older > 6 & waz_older!=.) // 1 child
	list record_id gender agey weight waz_older if waz_older < -6 | (waz_older > 6 & waz_older!=.)
	replace waz_older=. if waz_older < -6 | (waz_older > 6 & waz_older!=.)
	
	count if whz_older < -6 | (whz_older > 6 & whz_older!=.) // 1 child	
	list record_id gender length weight whz_older if whz_older < -6 | (whz_older > 6 & whz_older!=.)
	replace whz_older=. if whz_older < -6 | (whz_older > 6 & whz_older!=.)

	
** Part 3: combine waz/whz for older and younger children

	replace waz=waz_older if waz==.
	replace whz=whz_older if whz==.
	drop waz_older whz_older
	
** Part 4: Children from 10 onwards -> BMI Z score 
	
	gen lengthm=length/100
	gen bmi=weight/(lengthm^2)
	label variable bmi "BMI (i.e., weight in kg / (height in meters, squared))"
	
	egen bmiz=zanthro(bmi,ba,WHO) if agemo>=120 & agemo!=., ///
	xvar(agemo) gender(gender) gencode(male=0, female=1) ///
	ageunit(month) nocutoff
	
	label variable bmiz "BMI Z score, calculated for children 10 years or older"
	
	sum bmiz, d
	count if bmiz<-2 //8 times
	count if bmiz==. & agemo>120 & agemo!=. //only one missing bmi
	
	*no implausible bmi z scores:
	list record_id agey weight lengthm bmi bmiz if (bmiz<-6 | bmiz>6) & bmiz!=.
	
	*checked som z scores manually (ok)
	list record_id gender agey bmi bmiz if agemo>120 & agemo!=. in 800/900
	
	
** Part 5: binary: is it -2 or less or not?

	foreach var in waz whz bmiz {
	
	gen `var'bin=.
	replace `var'bin =1 if `var'<=-2
	replace `var'bin=0 if `var'>-2 & `var'!=.
	
	label define `var'lbl 0 "Z greater than -2" 1 "Z of -2 or less", modify
	label var `var'bin `var'lbl
	}
	
	label variable wazbin "Weight for age Z score, binary"
	label variable whzbin "Weight for height Z score, binary"
	label variable bmizbin "BMI for age Z score, binary"
	
	tab wazbin, m
	tab whzbin, m
	tab bmizbin, m
	
save "Form8CounsellorInformation_ANTHROPOMETRY_and_dob_andZscores.dta", replace

//drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance visitweek 
//drop temp oxygen heartrate resprate newtbcontact numoftbcont tbcontactstatus suspectbasedon othspec daterstposres unknown___98 ontreatment rxstartdate rxstartdateunkn___98 est adherent retreatment tbcontprimcarer tbcontmom tbcontsamehh more1tbcont tbconseechild tbcontsameroom tbconsamebed tbconcoughing tbcontactptb tbconsmearpos tbrxipt whogivesrx___1 whogivesrx___2 whogivesrx___3 whogivesrx___4 whogivesrx___5 whogivesrx___99 spec1 childtakingtbrx counselling counselling_ra carermedknowtb tbrxcard tbcardseen misseddoses numofmisseddosesrxcard kidvomitedmeds numofvomiteddoses kidrefusedmeds numofrefuseddoses dosesforgotten numofmisseddoses clinicadherissue nummisseddosespec participantonart childarvs counselling_1 counselling_ra_1 defaultedhiv carerhivmedknowadm carerknowwhichtabs___1 carerknowwhichtabs___2 carerknowwhichtabs___3 carerknowwhichtabs___4 carerknowwhichtabs___5 carerknowwhichtabs___6 othspec2 carerreminder___1 carerreminder___2 carerreminder___3 carerreminder___99 othspec3 foodworry frequency bedhungry frequency_1 eatfruit eatmeat eat_redmeat eat_vegetables form_8_counsellor_information_co carerknowwhichtabs___9 _form8

save "Form8CounsellorInformation_ANTHROPOMETRY_and_dob_andZscores_wide.dta", replace

//use "umoya_clinical.dta", clear

//save "umoya_who_sympt_score.dta", replace

/* Do file created by Eline Wijstma on 26-10-2023
** This do file is a shortened version of the do-file entitled 03_UMOYA_dm_GBTMTDA.do
** It is focused on making the WHO TDA variables.
 
In this do file, I start of with the full UMOYA clinical dataset for the first
400 children, and create WHO symptom variables for those symptoms described in 
the WHO treatment Decision Algorithm B */


/* TDA symptom definitions have been sent by Marieke van der Zalm om 10/10/2023, and 
are the following:

Cough: 		persistent, unremitting cough for 2 weeks or more. 

Fever: 		persistent fever for 2 weeks or more 
			(the score in the algorithm is based on the duration of fever as per 
			the history rather than the actual temperature on examination).
		
Lethargy: 	persistent unexplained lethargy or decreased playfulness or activity 
			reported by the parent or caregiver. 
Weightloss: more than 5% reduction in weight compared with the highest weight 
			recorded in the past 3 months, or failure to thrive 
			(clear deviation from previous growth trajectory, 
			or documented crossing of percentile lines in the preceding 3 months, 
			or weight-for-age Z-score of ‚ -2 or less, 
			or weight-for-height Z-score of -2 
			or less in the absence of information on previous or recent growth trajectory).
			
			
Haemoptysis: 	expectoration of blood or blood-tinged sputum. 
				This is a very rare symptom in children aged under 10 years 
				and should be distinguished carefully from blood brought up 
				by a child following a nosebleed. 
				
Night sweats: 	excessive night-time sweating that soaks the bed or clothes.
 
Swollen lymph nodes: non-painful, enlarged cervical, submandibular, or axillary lymph nodes. 

Tachycardia: cardiosys cardioabspec
			o children aged under 2 months: heart rate over 160 beats/minute. 
			o children aged 2-12 months: heart rate over 150 beats/minute.
			o children 12 months to 5 years: heart rate over 140 beats/minute. 
			o children aged over 5 years: heart rate over 120 beats/minute.
			
Tachypnoea: 
			o children aged under 2 months: respiratory rate over 60/minute. 
			o children aged 2-12 months: respiratory rate over 50/minute.
			o children aged 12 months to 5 years: respiratory rate over 40/minute.
			o children aged over 5 years: respiratory rate over 30/minute.

*/


********************************************************************************
************* Chapter 1: drop controls, view date variables ********************
********************************************************************************

//count //400; wide dataset
//des, full

//rename record_id id

** Drop healthy controls (no symptoms) and children without diagnosis
//drop if umf01_ubl_status==2 | umf01_ubl_status==.

** Date variables

	** Drop duplicate visit date variables
//	des *visdate* , full
//	drop visdate*
sort record_id week -visdate
by record_id week: gen n = _n
drop if n > 1
drop n

drop form_8_counsellor_information_co othspec2
	
reshape wide dob gender redcap_event_name redcap_repeat_instrument redcap_repeat_instance visitweek visdate vistime weight muac length temp oxygen heartrate resprate newtbcontact numoftbcont tbcontactstatus suspectbasedon othspec daterstposres unknown___98 ontreatment rxstartdate rxstartdateunkn___98 est adherent retreatment tbcontprimcarer tbcontmom tbcontsamehh more1tbcont tbconseechild tbcontsameroom tbconsamebed tbconcoughing tbcontactptb tbconsmearpos tbrxipt whogivesrx___1 whogivesrx___2 whogivesrx___3 whogivesrx___4 whogivesrx___5 whogivesrx___99 spec1 childtakingtbrx counselling counselling_ra carermedknowtb tbrxcard tbcardseen misseddoses numofmisseddosesrxcard kidvomitedmeds numofvomiteddoses kidrefusedmeds numofrefuseddoses dosesforgotten numofmisseddoses clinicadherissue nummisseddosespec participantonart childarvs counselling_1 counselling_ra_1 defaultedhiv carerhivmedknowadm carerknowwhichtabs___1 carerknowwhichtabs___2 carerknowwhichtabs___3 carerknowwhichtabs___4 carerknowwhichtabs___5 carerknowwhichtabs___6 carerreminder___1 carerreminder___2 carerreminder___3 carerreminder___99 othspec3 foodworry frequency bedhungry frequency_1 eatfruit eatmeat eat_redmeat eat_vegetables carerknowwhichtabs___9 _form8 agemo agey waz whz lengthm bmi bmiz wazbin whzbin bmizbin, i(record_id) j(week)

save "Form8CounsellorInformation_ANTHROPOMETRY_and_dob_andZscores_wide.dta", replace

use "umoya_clinical.dta", clear

merge 1:1 record_id using "Form8CounsellorInformation_ANTHROPOMETRY_and_dob_andZscores_wide.dta", assert(master match) keep(master match) generate(_anthro)
save "umoya_clinical_zscore.dta", replace

********************************************************************************
********** Chapter 2: Rename variables (shorten week index) ********************
********************************************************************************


** Give baseline a shorter name (i.e., remove umf01_ubl_ at start; replace with _week at end)

	*rename variables that start with number after the umf01_ubl_ prefix
	rename umf01_ubl_0to5mon umf01_ubl_hh0to5mon
	rename umf01_ubl_6to60mon umf01_ubl_hh6to60mon

	foreach var of varlist umf01_ubl_* {
		local newname = substr("`var'", 11, .)
		rename `var' `newname'_w0
	}
	
	* Form 2, week 2 (remove 11 characters at start)
	foreach var of varlist umf02* {
	local newname = substr("`var'", 11, .)
	rename `var' `newname'_w2
	}
	
	* Form 3, week 8 (remove 11 characters at start)
	foreach var of varlist umf03* {
	local newname = substr("`var'", 11, .)
	rename `var' `newname'_w8
	}
	
	*  Form 4, week 16 (remove 12 characters at start)
	foreach var of varlist umf04* {
	local newname = substr("`var'", 12, .) 
	rename `var' `newname'_w16
	}	

	*  Form 5, week 24 (remove 12 characters at start)
	foreach var of varlist umf05* {
	local newname = substr("`var'", 12, .) 
	rename `var' `newname'_w24
	}

	* End of study form
	foreach var of varlist umf15* {
	local newname = substr("`var'", 12, .)
	rename `var' `newname'_eos
	}
	
	
	** Rename height/weight variables to have this same variable name structure
	foreach name in weight length muac heartrate waz wazbin whz whzbin agemo agey {
		foreach w in 0 2 8 16 24 {
		rename `name'`w' `name'_w`w'
	}
	}
	
	describe, full



	
********************************************************************************
**** Chapter 2: Select variables and rough data management *********************
********************************************************************************

	
	** NOTE: on week 16 and week 24, the symptom variables have a different name
	** change this to be consistent with the week 2 and week 8 variable
	des *symptoms* 
	rename symptoms_y_n_w16 symptoms_w16
	rename symptoms_y_n_w24 symptoms_w24
	
	des physexamnorm*, f //week 8, 16, 24 -> if normal (1), lymphadenopathy not asked
	des physical_exam_w0, f //week 0 -> if normal (1), lymphadenopathy not asked
	des physexam_w2, f //week 2 -> if normal (1), lymphadenotpathy not asked
	
	rename physexam_w2 physical_exam_w2
	rename physexamnorm_w8 physical_exam_w8
	rename physexamnorm_w16 physical_exam_w16
	rename physexamnorm_w24 physical_exam_w24
	
	des respsys* 
	tab respsys_w0 //1 is normal
	
******* ROUGH VARIABLE SELECTION
	
	keeporder record_id gender* dob* visdate* ///
	cxrabnormal* symptoms* *cough* wheeze* fever* nightsweats* hemoptysis* ///
	weight_w* waz* length_w* whz* muac_w* ///
	lackappetite* activity* failurethrive* ///
	physical_exam* lymphadenopathy* ///
	heartrate* *cardio* *physxm_other*  ///
	respsys* resprate* *diagnosis* *diagcode* *other_specify* *otherdiag* *signsoth_spec* 
	

******* ROUGH DATA MANAGEMENT: no specific symptoms if no general abnormality


** if symptoms==0, then value 0 for all specific symptoms in section B
** Note: 'symptoms' is not asked at baseline.

gen hemoptysis_w8 = .
gen hemoptysis_w16 = .
gen hemoptysis_w24 = .
order hemoptysis_w8 hemoptysis_w16 hemoptysis_w24, after(hemoptysis_w2)

	foreach week in w2 w8 w16 w24 {
		
		foreach var in cough wheeze fever nightsweats hemoptysis ///
		lackappetite activitylevel failurethrive {
		
		replace `var'_`week'=0 if symptoms_`week'==0 & `var'_`week'==.	
		}
	
		replace activitylevel_`week'=1 if activitylevel_`week'==0 // 1 is 'normal'
	}
	
	
	
** If physical exam is normal (i.e., 1), then..
** -> no lymphadenopathy and respiratory rate and heartrate not taken; 

	foreach week in 0 2 8 16 24 {
	
	*heartrate NA
	replace heartrate_w`week'="9999" if physical_exam_w`week'==1 & heartrate_w`week'==""	
	
	*respiratory rate NA (note: only if also not available in the c8f variable)
	replace resprate_w`week'=9999 if physical_exam_w`week'==1 & resprate_w`week'==. //& ///
	//resprate_c8f`week'==""
	
	*lymphadenopathy
	replace lymphadenopathy_w`week'=0 if physical_exam_w`week'==1 & lymphadenopathy_w`week'==.
	
	}
	
	
** If cardiac system is normal (i.e., 1), then heartrate not applicable

	foreach week in w0 w2 w8 w16 w24 {
	replace heartrate_`week'="9999" if cardiosys_`week'==1 & heartrate_`week'==""  	
	}
	
	
** If respiratory system is normal (i.e., 1), then resprate not applicable

	foreach week in 0 2 8 16 24 {
	replace resprate_w`week'=9999 if respsys_w`week'==1 & resprate_w`week'==. //& ///
	//resprate_c8f`week'==""	
	}	
	
	
	
********************************************************************************
***** Chapter 3.1: COUGH *******************************************************
********************************************************************************
* WHO score definition is: persistent, unremitting cough for 2 weeks or more. 
	
	edit  record_id cough_w24 coughtype_w24 coughduration_w24 drycoughnight_w24 if cough_w24==1
	replace coughduration_w24 = "5" in 351
	replace coughduration_w24 = "3" in 353
	replace coughduration_w24 = "1" in 369
	replace coughduration_w24 = "1" in 390
	replace coughduration_w24 = "7" in 391
	replace coughduration_w24 = "5" in 393
	replace coughduration_w24 = "2" in 394
	replace coughduration_w24 = "7" in 398
	replace coughduration_w24 = "1" in 400
	replace coughduration_w24 = "7" in 401
	replace coughduration_w24 = "2" in 427
	replace coughduration_w24 = "4" in 436
	replace coughduration_w24 = "3" in 438
	replace coughduration_w24 = "6" in 458
	replace coughduration_w24 = "1" in 463
	replace coughduration_w24 = "7" in 464
	replace coughduration_w24 = "4" in 488
	replace coughduration_w24 = "4" in 496
	replace coughduration_w24 = "4" in 497
	replace coughduration_w24 = "2" in 506
	replace coughduration_w24 = "7" in 511
	replace coughduration_w24 = "3" in 525
	replace coughduration_w24 = "2" in 531
	replace coughduration_w24 = "2" in 542
	replace coughduration_w24 = "7" in 544
	replace coughduration_w24 = "7" in 545
	replace coughduration_w24 = "37" in 555
	destring coughduration_w24, generate(coughduration_w24_2) force
	drop coughduration_w24 
	rename coughduration_w24_2 coughduration_w24
	
	rename acutecoughdays_w0 coughduration_w0 

	des *cough*, f 
	//rename umf01_uw2_coughtype coughtype_w2 //concistency in variable names!

	** Inspect cough variables
	foreach week in w0 w2 w8 w16 w24 {
	des cough*_`week' // not the same variables each week!
	tab cough_`week' if visdate_`week'!=., m 
	}
	
	** Change cough to missing if impossible value (i.e., -1)
	foreach week in w0 w2 w8 w16 w24 {
	replace cough_`week'=. if cough_`week'==-1
	}
	
	** LIST MISSINGS (removed from this condensed script)
	** Fill in missings if possible based on paper medical files.
	replace cough_w0=1 if record_id=="UM075"
	replace coughpattern_w0=2 if record_id=="UM075"
	
	
** week 0: available variables are cough and coughpattern
** WHO TDA description met if cough==YES & coughpattern==CHRONIC
** WHO TDA description not met if cough==NO, or (cough==YES & coughpattern!=CHRONIC)
	
	des cough*_w0
	tab coughpattern_w0 cough_w0, m 

	gen WHOcough_w0=.
	label variable WHOcough_w0 "WHO cough requirement met? (persistent, unremmitting cough, >=2 wk)"

	replace WHOcough_w0=1 if coughpattern_w0==2
	replace WHOcough_w0=1 if coughpattern_w0==1 & coughduration_w0>14 & coughduration_w0!=.
	replace WHOcough_w0=0 if cough_w0==0 | coughpattern_w0==1 | coughpattern_w0==3
		
	tab WHOcough_w0, m

** Week 2, 8, 16, 24: available variables are cough, coughtype and coughduration
** WHO TDA description met if cough is persistent or improved or (new & lasting >=14 days)
		
		des cough*_w2
		des cough*_w8
		des cough*_w16
		des cough*_w24
	
	    //destring coughduration_w24, generate(coughduration_w24_2) force
		//drop coughduration_w24 
        //rename coughduration_w24_2 coughduration_w24
		
		foreach week in w2 w8 w16 w24 {
	
		gen WHOcough_`week'=.
		label variable WHOcough_`week' "WHO cough (definition: persistent, unremmitting cough, >=2 wk)"
		label val WHOcough_`week' ynlbl
		
		*WHO criterion met if.....
		replace WHOcough_`week'=1 if cough_`week'==1 & coughduration_`week'>=14 //new cough >14d
		replace WHOcough_`week'=1 if cough_`week'==1 & coughtype_`week'==2 //persistent cough
		replace WHOcough_`week'=1 if cough_`week'==1 & coughtype_`week'==3 //improved cough
		
		*WHO criterion not met if...
		replace WHOcough_`week'=0 if cough_`week'==0 
		replace WHOcough_`week'=0 if cough_`week'==1 & coughduration_`week'<14
		replace WHOcough_`week'=0 if cough_`week'==1 & (coughtype_`week'==3 | coughtype_`week'==4)

		} 
		

	** Check: 
	
		foreach week in w2 w8 w16 w24 {
		tab cough_`week' if visdate_`week'!=., m
		} //only one missing at BL
		
		
		
********************************************************************************
***** Chapter 3.2: FEVER *******************************************************
********************************************************************************
** persistent fever for 2 weeks or more (the score in the algorithm is based on 
** duration of fever (i.e., history) rather than temperature on examination).		

** Inspect fever variables. 

	des fever* //type, days, duration, responding
	drop fevernotresponding*
	
	** In week 0, duration variable called 'feverdays' not 'feverduration' 
	** -> change for consistency 
	rename feverdays_w0 feverduration_w0

	** note: fevertype has different categories at week 0 than at follow-up
	** baselien: 1 intermittent; 2 continuous; FU: 1 new; 2: peristent; 3: recurrent.
	foreach week in w0 w2 w8 w16 w24 {
	tab fevertype_`week'
	} 
	
	
*** List missings (removed from this condensed script)
*** Insert missing values if they can be retrieved from paper files
	replace fevertype_w0=1 if record_id=="UM210"	


** Make WHO TDA fever variable	
** WHO TDA criterion met if persistent fever lasting > 14 days.

** At baseline, we know the duration of all fevers. We say that the WHO TDA criterion is met
** for continuous fevers > 14 days

** At follow-up, we only know the NEW fevers. We say that the WHO TDA criterion is met
** for 'continous fever > 14days', or persistent fevers if a feevr was already present
** at the previous visit. We recognise that we miss some persistent fevers that last
** more than 2 weeks, but less than the duration between study visits. 


** WHO fever week 0
	
	gen WHOfever_w0=.
	label variable WHOfever_w0 "w0 WHO fever requirement met? (persistent, >=2 wk)"
	
	*WHO TDA fever criterion met
	replace WHOfever_w0=1 if fever_w0==1 & fevertype_w0==1 & feverduration_w0>=14 & feverduration_w0!=.
	replace WHOfever_w0=1 if fever_w0==1 & fevertype_w0==2 	
	
	*WHO TDA fever criterion NOT met
	replace WHOfever_w0=0 if fever_w0==0
	replace WHOfever_w0=0 if fever_w0==1 & fevertype_w0==1
	replace WHOfever_w0=0 if fever_w0==1 & fevertype_w0==2 & feverduration_w0<14
	
	tab WHOfever_w0, m

		
** WHO fever week 2, 8, 16, 24
	
	foreach week in w2 w8 w16 w24 {
		
		gen WHOfever_`week'=.
		label variable WHOfever_`week' "`week' WHO fever requirement met? (persistent, >=2 wk)"

		*new fever lasting >14 days -> YES
		replace WHOfever_`week'=1 if fever_`week'==1 & fevertype_`week'==1 & ///
		feverduration_`week'>=14 & feverduration_`week'!=.
		
		*no fever -> NO
		replace WHOfever_`week'=0 if fever_`week'==0
		
		*intermittent fever -> NO
		replace WHOfever_`week'=0 if fever_`week'==1 & fevertype_`week'==3
		
		*any fever lasting <14 days -> NO
		replace WHOfever_`week'=0 if fever_`week'==1 & feverduration_`week'<14
		
	} 

		*persistent fever that was already present at last UMOYA visit
		replace WHOfever_w2=1 if fever_w2==1 & fevertype_w2==2 & fever_w0==1
		replace WHOfever_w8=1 if fever_w8==1 & fevertype_w8==2 & fever_w2==1
		replace WHOfever_w16=1 if fever_w16==1 & fevertype_w16==2 & fever_w8==1
		replace WHOfever_w24=1 if fever_w24==1 & fevertype_w24==2 & fever_w16==1
	
	** Check:
	foreach week in w0 w2 w8 w16 w24 {
	tab WHOfever_`week' if visdate_`week'!=., m
	} // four missing in total. Rare symtom, especially at follow-up.
	
	
	
********************************************************************************
***** Chapter 3.3: LETHARGY ****************************************************
********************************************************************************
** persistent unexplained lethargy or decreased playfulness or activity 
** reported by the parent or caregiver. Since we have not data on the duration
** of lethargy, I just use the activitylevel variable
	

		des activity*
		tab activitylevel_w0 //ordinal variable. 1=normal; 2 reduced; 3 lethargic 
		
		** If value is -1: not possible -> change to missing
		foreach var of varlist activity* {
		replace `var'=. if `var'!=1 & `var'!=2 & `var'!=3
		}
		

*** List missings (removed from this condensed script)	
*** I checked paper medical files (26 October 2023. All missing in paper file too)

*** Make WHO lethargy variable (i.e., binary)
		
		foreach week in w0 w2 w8 w16 w24 {
		
		gen WHOactivity_`week'=.
		label variable WHOactivity_`week' "WHO activity req met? (lethargy or reduced activity)"
		label val WHOactivity_`week' ynlbl
		
		* Lethargy or reduced playfulness -> YES
		replace WHOactivity_`week'=1 if activitylevel_`week'==2 | activitylevel_`week'==3
		
		* Normal activity level
		replace WHOactivity_`week'=0 if activitylevel_`week'==1
		tab WHOactivity_`week', m
		}
	
*** Check:

		foreach week in w0 w2 w8 w16 w24 {
		tab WHOactivity_`week' if visdate_`week'!=., m
		} // in total, 5 remaining missings

	
********************************************************************************
***** Chapter 3.4: WEIGHTLOSS  *************************************************
********************************************************************************
/*> more than 5% reduction in weight compared with the highest weight recorded in 
	the past 3 months, or....
> 	failure to thrive (clear deviation from previous growth trajectory, or...
> 	weight-for-AGE Z-score of -2 or less, or...
> 	weight-for-HEIGHT Z-score of -2 or lesstrajectory).*/
	
	
**** List missings (removed from this concise script
**** Fill in missings

	*UM380
	replace weight_w0=3.6 if record_id=="UM380" 
	replace length_w0=49 if record_id=="UM380" 
	replace heartrate_w0="164" if record_id=="UM380" & heartrate_w0==""
	replace resprate_w0=94 if record_id=="UM380" & resprate_w0==.

	*UM092
	replace weight_w2=15.2 if record_id=="UM092" 
	replace length_w2=87.5 if record_id=="UM092" 

	*UM337
	replace weight_w2=3.6 if record_id=="UM337" 
	replace length_w2=54.5 if record_id=="UM337" 
	replace heartrate_w2="121" if record_id=="UM337" & heartrate_w2==""
	replace resprate_w2=28 if record_id=="UM337" & resprate_w2==.
	
	*UM397
	replace weight_w2=10.3 if record_id=="UM397" 
	replace length_w2=107.8 if record_id=="UM397" 
	replace heartrate_w2="78" if record_id=="UM397" & heartrate_w2==""
	replace resprate_w2=20 if record_id=="UM397" & resprate_w2==.	
	
	*UM214
	replace weight_w16=13.6 if record_id=="UM214" 
	replace length_w16=88.0 if record_id=="UM214" 

	*UM374
	replace visdate_w24=mdy(01,12,2022) if record_id=="UM374"
	replace weight_w24=7.3 if record_id=="UM374" 
	replace length_w24=71.2 if record_id=="UM374" 
	replace heartrate_w24="82" if record_id=="UM374" & heartrate_w24==""
	replace resprate_w24=23 if record_id=="UM374" & resprate_w24==.	
	
	** Correct implausible and wrongly noted length
	replace length_w8=103.2 if record_id=="UM371"
	replace length_w0=73.4 if record_id=="UM393" 
	replace length_w0=87.9 if record_id=="UM398"
	
	
*** Create empty WHO weight variables

	foreach week in w0 w2 w8 w16 w24 {
	gen WHOweight_`week'=.
	label variable WHOweight_`week' "Weightloss according to 4-fold WHO definition"
	}
	
	
*** DEFINITION 1: >5% REDUCTION COMPARED TO HIGHEST WEIGHT PAST 3 MO

	* Week 0: we have no data on weight before w0
	
	* Week 2: changes since w0? note: w0 and w2 must not be missing (4 children)
	
		replace WHOweight_w2=1 if weight_w0!=. & weight_w2!=. & ///
		((weight_w0-weight_w2)/weight_w0)*100>5  
		
		list record_id weight_w0 weight_w2 if WHOweight_w2==1
	
	* Week 8: changes since w0 or w2? 
	
		*Changes since w0? (1 child)
		replace WHOweight_w8=1 if weight_w0!=. & weight_w8!=. & ///
		((weight_w0-weight_w8)/weight_w0)*100>5 	
		
		*Changes since w2? (5 children)
		replace WHOweight_w8=1 if weight_w2!=. & weight_w8!=. & ///
		((weight_w2-weight_w8)/weight_w2)*100>5 

	* Week 16: changes since w8? (6 children)

		replace WHOweight_w16=1 if weight_w8!=. & weight_w16!=. & ///
		((weight_w8-weight_w16)/weight_w8)*100>5 		

	* Week 24: changes since week 16? (4 children)

		replace WHOweight_w24=1 if weight_w16!=. & weight_w24!=. & ///
		((weight_w16-weight_w24)/weight_w16)*100>5 

		
*** Definition 2: Failure to thrive

	des failurethrive*, f //not asked at w2
	tab failurethrive_w0, m //1 is yes
	
	foreach week in w0 w8 w16 w24 {
	replace WHOweight_`week'=1 if failurethrive_`week'==1
	} //162, 12, 9 and 7 children, respectively


*** Definition 3: dZ scores for waz or whz below -2

	foreach week in w0 w2 w8 w16 w24 {
	
	tab wazbin_`week', m
	replace WHOweight_`week'=1 if wazbin_`week'==1
	
	tab whzbin_`week', m
	replace WHOweight_`week'=1 if whzbin_`week'==1
	} 	

	
	
*** Fill in the zero's if weight is not missing en check distribution

	foreach week in w0 w2 w8 w16 w24 {
	replace WHOweight_`week'=0 if WHOweight_`week'!=1 & weight_`week'!=.
	tab WHOweight_`week' if visdate_`week' !=., m
	} // very few missings

	

	
********************************************************************************
***** Chapter 3.5: HAEMOPTYSIS  ************************************************
********************************************************************************
		
/*Haemoptysis =expectoration of blood or blood-tinged sputum. 

This is a very rare symptom in children aged under 10 years and should be 
distinguished carefully from blood brought up by a child following a nosebleed. 
				
This is not registered in a separate variable, but will be noted inclprimary/secondary/tertiary diagnosis variables, or open field for other symptoms.

@ Rory, this bit of script is mainly an exploration of these variables, to see if and 
where I can find haemoptysis diagnoses. 
*/

	** Primary, secondary and tertiary diagnosis are available
	des *diagnosis*, full //available each week
	
		*Drop the yes/no variables and tb diagnosis
		drop tbdatediagnosis_w0 secondaydiagnosisyn* tertiarydiagnosisyn*
		
		*Make lower case; see what diagnosis code for haemoptysis is.
		*Take into account wrong spelling
		foreach var of varlist *diagnosis* {
		replace `var'=lower(`var')
		list record_id `var' if strpos(`var', "haemoptysis") | strpos(`var', "hemoptysis") | ///
		strpos(`var', "haem") | strpos(`var', "hemo")
		} //according to this code, no one with haemoptysis as diag 1, 2, 3.
		
	** Other diagnoses	
	des *otherdiag* *other_specify*, full //some string, some byte
	
	
		*check out strings
		des *otherdiag* *other_specify*, full
		
		foreach var of varlist ///
		otherdiag1_w0 otherdiag2_w0 umf01_other_specify_sec1 other_specify_sec3 {
		list record_id `var' if `var'!=""
		}
		
			** Lists do not include haemoptosis as symptom -> drop vars
			drop otherdiag1_w0 otherdiag2_w0 umf01_other_specify_sec1 other_specify_sec3
			
		*check out bytes
		foreach var of varlist otherdiagcode1_w0 otherdiagcode2_w0 ///
		umf01_other_specify* {
		tab `var', m
		} 
		
			** tab shows: last 4 vars are empty; other 2 variables no signs of Haemoptysis
			** -> drop these variables
			drop otherdiagcode1_w0 otherdiagcode2_w0 umf01_other_specify*

	** Other signs or abnormalities
	des *signsoth_spec* *physxm_other* , full
	
	tab signsoth_spec_w0
	list record_id if strpos(signsoth_spec_w0, "HEMOPTYSIS") | strpos(signsoth_spec_w0, "HAEMOPTYSIS")
	list record_id signsoth_spec_w0 *diagnosis* if strpos(signsoth_spec_w0, "HEMOPTYSIS") | ///
	strpos(signsoth_spec_w0, "HAEMOPTYSIS"), ab(30)
	
	** TWO KIDS WITH HAEMOPTYSIS AT BASELINE; VARIABLE NOT AVAILABLE AT LATER POINTS
	tab physxm_other_s_w0 // no haemoptysis

	
** Make WHO variables

	gen WHOhaem_w0=0

	label variable WHOhaem_w0 "WHO activity req met? (Haemoptysis)"
	label val WHOhaem_w0 ynlbl
	*WHO TDA HAEMOPTYSIS criterion met
	/*Haemoptysis: expectoration of blood or blood-tinged sputum. This is a very rare
      symptom in children aged under 10 years and should be distinguished carefully from
	  blood brought up by a child following a nosebleed.
	*/

	replace WHOhaem_w0=1 if  hemoptysis_w0==1
	
	tab WHOhaem_w0, m
	
	foreach week in w2 w8 w16 w24 {
	
	gen WHOhaem_`week'=0
	label variable WHOhaem_`week' "WHO activity req met? (Haemoptysis)"
	label val WHOhaem_`week' ynlbl

	}	
	
	
********************************************************************************
***** Chapter 3.6: NIGHTSWEATS  ************************************************
********************************************************************************
		
*** Nighsweats: excessive nightsweats that soak the bed
*** This variable has only been collected for 150 children -> we will exclude it from analysis

	des nightsweats*
	
	gen WHOsweat_w0 = 0
	replace WHOsweat_w0=1 if  nightsweats_w0==1
	
	label variable WHOsweat_w0 "WHO nightsweats"
	label val WHOsweat_w0 ynlbl
	
	foreach week in w2 w8 w16 w24 {
	tab nightsweats_`week' if visdate_`week'!=., m
	rename nightsweats_`week' WHOsweat_`week'
	} // I excluded this due to missings.
	
	drop nightsweats_w0
	order WHOsweat_w0, before(WHOsweat_w2)

	
********************************************************************************
***** Chapter 3.7: LYMPHADENOPATHY  ********************************************
********************************************************************************
*Lymphadenopathy may not be registered if physical exam is normal. I imputed 
*lymphadenopathy==0 in these cases in chapter 3.0.
	
	des lymphadenopathy*
		
*** Inspect missings
	
	foreach week in w0 w2 w8 w16 w24 {
	tab lymphadenopathy_`week' if visdate_`week'!=., m
	list record_id visdate_`week' lymphadenopathy_w0 if lymphadenopathy_`week'==. & visdate_`week'!=.	
	} // limited number of missings
	
	
*** Rename to WHO variable
	foreach week in w0 w2 w8 w16 w24 {
	rename lymphadenopathy_`week' WHOlymph_`week'
	}
	
*** Check

	foreach week in w0 w2 w8 w16 w24 {
	tab WHOlymph_`week' if visdate_`week'!=., m
	}
		
	

********************************************************************************
***** Chapter 3.8: TACHYCARDIA  ************************************************
********************************************************************************
		
/*Tachycardia: diagnosis based on age+heartrate; and diagnosis code
		o children aged under 2 months: heart rate over 160 beats/minute. 
		o children aged 2-12 months: heart rate over 150 beats/minute.
		o children 12 months to 5 years: heart rate over 140 beats/minute. 
		o children aged over 5 years: heart rate over 120 beats/minute.
*/


*** Step 0: Fill in missings based on manual check of paper participant records 
*** (26 October 2023, EWijstma and MvNiekerk)

	replace heartrate_w2="" if heartrate_w2=="NA"
    replace heartrate_w8="" if heartrate_w8=="NA"
    replace heartrate_w16="" if heartrate_w16=="NA"
    replace heartrate_w24="" if heartrate_w24=="N/A"

	foreach var of varlist heartrate* {
	destring `var', replace
	count if `var'<1 //ok
	count if `var'==9999
	} 
	
	replace heartrate_w24=83 if record_id=="UM293"	
	replace heartrate_w24=94 if record_id=="UM302"
	replace heartrate_w0=111 if record_id=="UM311"
	replace heartrate_w24=98 if record_id=="UM311"
	replace heartrate_w0=80 if record_id=="UM312"
	replace heartrate_w2=89 if record_id=="UM312"
	replace heartrate_w0=144 if record_id=="UM316"
	replace heartrate_w0=118 if record_id=="UM319"
	replace heartrate_w0=127 if record_id=="UM321"
	replace heartrate_w2=121 if record_id=="UM321"
	replace heartrate_w2=121 if record_id=="UM337" 

** Step 1 : Age at visit

	rename dob_w0 dob
	//drop dob0 dob2 dob8 dob16 dob24 dob52 dob104 dob156 dob208 dob999

	foreach week in w0 w2 w8 w16 w24 {
	gen agemo_`week'=(visdate_`week'-dob)/30.4375
	label variable agemo_`week' "Age in months at `week'"
	gen agecat_`week'=.
	replace agecat_`week'=1 if agemo_`week'>0 & agemo_`week'<2 //under 2 mo
	replace agecat_`week'=2 if agemo_`week'>=2 & agemo_`week'<12 //2-12 mo
	replace agecat_`week'=3 if agemo_`week'>=12 & agemo_`week'<60
	replace agecat_`week'=4 if agemo_`week'>=60 & agemo_`week'!=.
	
	label define respagecat 1 "<2 mo" 2 "2-12 mo" 3 "12 mo-5y" 4 "5 or older", modify
	label val agecat_`week' respagecat
	}
	
	
** Step 2: Inspect Heart abnormality variables

	des *heart* *cardiosys* *cardioabspec* 

	foreach var of varlist *cardiosys* {
	tab `var', m //ATTENTION: 1 IS NORMAL, 2 IS ABNORMAL
	}
	
	
	foreach var of varlist *cardioabspec* {
	replace `var'=lower(`var') 		//lower case
	list record_id `var' if `var'!="" 		//look at different spelling in order not to miss out
	}

	gen cardioabspec_w16="" //generate cardioabspec for w16 and w24 to allow looping
	gen cardioabspec_w24=""
	


** Make WHO TDA tachycardia variable

	foreach week in w0 w2 w8 w16 w24 {
	
	gen WHOheart_`week'=.
	label variable WHOheart_`week' "WHO activity req met? (Tachycardia)"
	label val WHOheart_`week' ynlbl

* No tachycardia if cardiovascular system is normal//normal

	replace WHOheart_`week'=0 if cardiosys_`week'==1

* Tachycardia based on age and heartrate
* NOTE: heartrate of 9999 means it is missing, but cardiac system or physical exam
* was normal, meaning that tachycardia is excluded as possible diagnosis (see Ch3).
	
	*under 2 mo, rate over 160 bpm
	replace WHOheart_`week'=1 if agecat_`week'==1 & heartrate_`week'>160 & ///
	heartrate_`week'!=. & heartrate_`week'!=9999
	
	*2-12 mo, rate over 150 bpm
	replace WHOheart_`week'=1 if agecat_`week'==2 & heartrate_`week'>150 & ///
	heartrate_`week'!=. & heartrate_`week'!=9999
	
	*12 mo to 5 y, rate over 140bpm
	replace WHOheart_`week'=1 if agecat_`week'==3 &  heartrate_`week'>140 & ///
	heartrate_`week'!=. & heartrate_`week'!=9999
	
	*5 years or older, rate over 120 bpm
	replace WHOheart_`week'=1 if agecat_`week'==4 & heartrate_`week'>120 & ///
	heartrate_`week'!=. & heartrate_`week'!=9999
	
* Tachycardia based on written diagnosis: 
	replace WHOheart_`week'=1 if strpos(cardioabspec_`week', "tachycardia")
	
* No tachycardia if heartrate is not missing and tachycardia==no	
	
	replace WHOheart_`week'=0 if heartrate_`week'!=. & WHOheart_`week' !=1

	}

*** Check:

	foreach week in w0 w2 w8 w16 w24 {
	tab WHOheart_`week' if visdate_`week'!=., m
	list physical_exam_`week' cardiosys_`week' heartrate_`week' if ///
	WHOheart_`week'==. & visdate_`week'!=.
	} //some unresolved missings
	
********************************************************************************
***** Chapter 3.9: TACHYPNOEA  ************************************************
********************************************************************************
			
/*Tachypnoea: based on respiratory rate + age, and diagnosis codes
		o children aged under 2 months: respiratory rate over 60/minute. 
		o children aged 2-12 months: respiratory rate over 50/minute.
		o children aged 12 months to 5 years: respiratory rate over 40/minute.
		o children aged over 5 years: respiratory rate over 30/minute.
*/
	
** Step 1: age at visit (category variable already made)	
** Step 2: look at respiratory rate

	des *resp*
	des *resprate*, full
	
	** Fix mistakes in variables
	
		* Non-numeric value
		//replace resprate_w0="28" if resprate_w0=="28 wars"
	
		* Negative value
		foreach week in w0 w2 w8 w16 w24 {
		list record_id visdate_`week' if resprate_`week'<1 //Note: has no other resp rate value
		replace resprate_`week'=. if resprate_`week'<1
		}
	
	** Impute resprate as measured by doctors with resprate as measured by counsellors
	** (only if resprate as measured by doctors is missing)
	
	//replace resprate2 = "9999" in 461
    //replace resprate24 = "9999" in 349
	
	foreach week in w0 w2 w8 w16 w24  {
	destring resprate_`week', replace
	replace resprate_`week'=resprate_`week' if resprate_`week'==.
	}
	
	

** Make WHO TDA tachypnoea variable, based on age category and respiratory rate, 
** And on the respiratory system (normal/abormal) variable

** Note: resprate 9999 occurs when resprate is missing, but respiratory system
** or physical exam was normal (meaning that tachypnoe is excluded as possible diagnosis)

	foreach week in 0 2 8 16 24 {
	
	gen WHOtachypnoe_w`week'=. 
	label variable WHOtachypnoe_w`week' "Tachypnoe present at week `week'? yes/no"
	
	*No tachypnoe if resp system is normal or physical exam is normal
	replace WHOtachypnoe_w`week'=0 if respsys_w`week'==1 | physical_exam_w`week'==1
	
	*Start with no tachypnoe if resprate is not missing (this will be corrected if tachypnoe is present)
	replace WHOtachypnoe_w`week'=0 if resprate_w`week'!=. 
	
	
	*Under 2 mo: >60 per minute
	replace WHOtachypnoe_w`week'=1 if agecat_w`week'==1 & ///
	((resprate_w`week'>60 & resprate_w`week'!=.) | (resprate_w`week'>60 & resprate_w`week'!=.)) ///
	& resprate_w`week'!=9999
	
	*2-12 mo: >50 per minute
	replace WHOtachypnoe_w`week'=1 if agecat_w`week'==2 & ///
	((resprate_w`week'>50 & resprate_w`week'!=.) | (resprate_w`week'>50 & resprate_w`week'!=.)) ///
	& resprate_w`week'!=9999
	
	*12 mo to 5 years: >40 per minute
	replace WHOtachypnoe_w`week'=1 if agecat_w`week'==3 & ///
	((resprate_w`week'>40 & resprate_w`week'!=.) | (resprate_w`week'>40 & resprate_w`week'!=.)) ///
	& resprate_w`week'!=9999
	
	*older than 5 years: >30 per minute
	replace WHOtachypnoe_w`week'=1 if agecat_w`week'==4 & ///
	((resprate_w`week'>30 & resprate_w`week'!=.) | (resprate_w`week'>30 & resprate_w`week'!=.)) ///
	& resprate_w`week'!=9999
				
	}
	
	
	foreach week in w0 w2 w8 w16 w24 {
	tab WHOtachypnoe_`week' if visdate_`week'!=., m
	list physical_exam_`week' respsys_`week' resprate_`week' if ///
	WHOtachypnoe_`week'==. & visdate_`week'!=.
	} //some unresolved missings

********************************************************************************
********** CHAPTER 4: SUMMARIZING WHO VARS, CREATE AGGREGATE VAR ***************
********************************************************************************

****** Assign points to each symptom and week

des WHO*, full	
	
	** cough: 5 points
	foreach var of varlist WHOcough* {
	gen points`var'=5 if `var'==1
	}
	
	** fever: 10 points
	foreach var of varlist WHOfever* {
	gen points`var'=10 if `var'==1
	}	
	
	** lethargy: 4 points
	foreach var of varlist WHOactivity* {
	gen points`var'=4 if `var'==1
	}
	
	** weightloss: 5 points
	foreach var of varlist WHOweight* {
	gen points`var'=5 if `var'==1
	}		
	
	** haemoptysis: 9 points
	foreach var of varlist WHOhaem* {
	gen points`var'=9 if `var'==1
	}		
	
	** nightsweats: 6 points
	foreach var of varlist WHOsweat* {
	gen points`var'=6 if `var'==1
	}		
	
	** lymphadenopathy: 7 points
	foreach var of varlist WHOlymph* {
	gen points`var'=7 if `var'==1
	}	
	
	** tachycardia: 4 points
	foreach var of varlist WHOheart* {
	gen points`var'=4 if `var'==1
	}		

	** tachypnoe: 2 points
	foreach var of varlist WHOtachypnoe* {
	gen points`var'=2 if `var'==1
	}	
	
//	drop WHOheart_ pointsWHOheart_
	
** Calculate total WHO score (i.e., rowtotal)
** NOTE FOR RORY: I excluded nightsweats here!

	foreach week in w0 w2 w8 w16 w24 {
	egen symptomscore_`week'=rowtotal(	pointsWHOcough_`week'			///
										pointsWHOfever_`week' 		///
										pointsWHOactivity_`week' 		///
										pointsWHOweight_`week'		///
										pointsWHOhaem_`week' 			///
										pointsWHOsweat_`week'			///
										pointsWHOlymph_`week'			///
										pointsWHOheart_`week'			///
										pointsWHOtachypnoe_`week' )	
	}

	
	
** Make variable indicating: incomplete data, if WHO value is missing on one
** of symptoms:

	foreach week in w0 w2 w8 w16 w24 {
	gen incomplete_`week'=1 if WHOcough_`week' ==. | WHOfever_`week' ==. | ///
	WHOactivity_`week'==. | WHOweight_`week'==. | WHOhaem_`week'==. | ///
	WHOlymph_`week'==. | WHOheart_`week'==. | 	WHOtachypnoe_`week'==.	
										
	count if incomplete_`week'==1 & visdate_`week'!=.								
	} 
	
	//foreach week in w0 w2 w8 w16 w24 {
	//tab symptomscore_`week' if incomplete_`week'!=1, m
	//}

	//drop gender0 gender2 gender8 gender16 gender24 gender52 gender104 gender156 gender208 gender999
	
	********************************************************************************
******** Chapter 4 - WAZ and WHZ ***********************************************
********************************************************************************

** Age  
// foreach week in w0 w2 w8 w16 w24 {
//                  
//                   gen agemo_`week'=(visdate_`week'-dob)/30.4375
//                   label variable agemo_`week' "Age in months at week `week'"
//                  
//                   gen agecat_`week'=.
//                   label variable agecat_`week' "Age category at week `week'"
//                   replace agecat_`week'=1 if agemo_`week'>0 & agemo_`week'<2 //under 2 mo
//                   replace agecat_`week'=2 if agemo_`week'>=2 & agemo_`week'<12 //2-12 mo
//                   replace agecat_`week'=3 if agemo_`week'>=12 & agemo_`week'<60
//                   replace agecat_`week'=4 if agemo_`week'>=60 & agemo_`week'!=.
//                  
//                   label define agecatlabel1 1 "<2 mo" 2 "2-12 mo" 3 "12 mo-5y" 4 "5 or older", modify
//                   label val agecat_`week' agecatlabel1
//                   }
                  
                  
** Step 1: destring weight and length variables if needed
** @WARNING: check if there are any other non-numerical signs in these variables, 
** If the output of this command is a warning saying it can't replace (not: warning is in black)

                  foreach week in w0 w2 w8 w16 w24 {
                  destring weight_`week', replace
                  destring length_`week', replace
                  }
                  

*************************
** Children up to 5 years
*************************

* If you have not yet installed these packages, install once by removing the * and running:
* ssc install zscore06
* findit zanthro //now click on install

// foreach week in w0 w2 w8 w16 w24 {
//                                   
//                   zscore06, a(agemo_`week') h(length_`week') w(weight_`week') s(gender_w0) female(1) male(0)
//                  
//                   drop haz06 bmiz06
//                   rename waz06 waz_`week' 
//                   rename whz06 whz_`week'
//                  
//                   label variable waz_`week' "WAZ `week', children under 10 (based on 2006/07 WHO standards)"
//                   label variable whz_`week' "WHZ `week', children under 10 (based on 2006/07 WHO standards)"
//                  
//                   replace waz_`week'=. if waz_`week'==99
//                   replace whz_`week'=. if whz_`week'==99
//                                                     
//                   ** Check any biologically implausible scores? 
//                   * @WARNING: check if any lists are made; if so, check whether these values are correct!
//                   list record_id agemo_`week' weight_`week' if waz_`week' < -6 | (waz_`week' > 6 & waz_`week'!=.) 
//                   list record_id weight_`week' length_`week' if whz_`week' < -6 | (whz_`week' > 6 & whz_`week'!=.)                   
//
// } 

***********************
** Children 5-10 years     
**********************


*In the zanthro package age can be in days, months, years; just specify the ageunit
* We have height in cm, weight in kilograms (check for yourself!)
* This package aalows various Z score calculations, I specify I want the WHO method
                  
//                   foreach week in w0 w2 w8 w16 w24 {
//                                   
//                   ** weight for age (wa)
//                  
//                   egen waz_older_`week'=zanthro(weight_`week',wa,WHO) ///
//                   if agemo_`week'>=61 & agemo_`week'<120, ///
//                   xvar(agemo_`week') ageunit(month) ///
//                   gender(gender_w0) gencode(male=0, female=1) ///
//                   nocutoff
//                  
//                   ** weight_`week' for height (wh)
//                  
//                   egen whz_older_`week'=zanthro(weight_`week',wh,WHO) ///
//                   if agemo_`week'>=61 & agemo_`week'<120, ///
//                   xvar(length_`week') gender(gender_w0) gencode(male=0, female=1) ///
//                   nocutoff
//                  
//                  
//                   ** Check any biologically implausible scores? Yes -> change to missing
//                   ** @WARNING: check if you get implausible values 
//                  
//                   list record_id gender_w0 agemo_`week' weight_`week' waz_older_`week' ///
//                   if waz_older_`week' < -6 | (waz_older_`week' > 6 & waz_older_`week'!=.)
//                  
//                   list record_id gender_w0 length_`week' weight_`week' whz_older_`week' ///
//                   if whz_older_`week' < -6 | (whz_older_`week' > 6 & whz_older_`week'!=.)
//                                   
//                   replace waz_older_`week'=. if waz_older_`week' < -6 | (waz_older_`week' > 6 & waz_older_`week'!=.)
//                   replace whz_older_`week'=. if whz_older_`week' < -6 | (whz_older_`week' > 6 & whz_older_`week'!=.)
//                  
//                   }
                  
                  
******************************
** combine waz/whz for children under and over 5
******************************

//                   foreach week in w0 w2 w8 w16 w24 {
//                  
//                   replace waz_`week'=waz_older_`week' if waz_`week'==.
//                   replace whz_`week'=whz_older_`week' if whz_`week'==.
//                   drop waz_older_`week' whz_older_`week'
//                  
//                   }
                  

***********************************
**  Children from 10 onwards -> BMI Z score 
***********************************

                  foreach week in w0 w2 w8 w16 w24 {
                                   
                  gen lengthm_`week'=length_`week'/100
                  gen bmi_`week'=weight_`week'/(lengthm_`week'^2)
                  label variable bmi_`week' "BMI week `week' (i.e., weight in kg / (height in meters, squared))"
                  
                  egen bmiz_`week'=zanthro(bmi_`week',ba,WHO) if agemo_`week'>=120 & agemo_`week'!=., ///
                  xvar(agemo_`week') gender(gender_w0) gencode(male=0, female=1) ///
                  ageunit(month) nocutoff                 
                                   
                  label variable bmiz_`week' "BMI Z score week `week', calculated for children 10 years or older"
                  drop lengthm_`week'
                  
                  }
                                   
                                   
** @WARNING: CHECK IMPLAUSIBLE Z SCORES FOR YOURSELF

                  foreach week in w0 w2 w8 w16 w24 {
                  list record_id agemo_`week' weight_`week' length_`week' bmi_`week' bmiz_`week' ///
                  if (bmiz_`week'<-6 | bmiz_`week'>6) & bmiz_`week'!=.
                  }
                  

*******************************
**** Make into binary variables, cutoff -2
*******************************

//                   foreach week in w0 w2 w8 w16 w24 {
//                   foreach var in waz whz bmiz {
//                  
//                   gen `var'bin_`week'=.
//                   replace `var'bin_`week'=1 if `var'_`week'<=-2
//                   replace `var'bin_`week'=0 if `var'_`week'>-2 & `var'_`week'!=.
//
//                   label define zbinlbl 0 "Z greater than -2" 1 "Z of -2 or less", modify
//                   label var `var'bin_`week' zbinlbl
//                   }
//                   }
//                  
//                   foreach week in w0 w2 w8 w16 w24 {
//                   label variable wazbin_`week' "week `week' Weight for age Z score, binary"
//                   label variable whzbin_`week' "week `week'Weight for height Z score, binary"
//                   label variable bmizbin_`week' "week `week' BMI for age Z score, binary"
//                   }

                  foreach week in w0 w2 w8 w16 w24 {
                  foreach var in bmiz {
                  
                  gen `var'bin_`week'=.
                  replace `var'bin_`week'=1 if `var'_`week'<=-2
                  replace `var'bin_`week'=0 if `var'_`week'>-2 & `var'_`week'!=.

                  label define zbinlbl 0 "Z greater than -2" 1 "Z of -2 or less", modify
                  label var `var'bin_`week' zbinlbl
                  }
                  }
                  
                  foreach week in w0 w2 w8 w16 w24 {
                  //label variable wazbin_`week' "week `week' Weight for age Z score, binary"
                  //label variable whzbin_`week' "week `week'Weight for height Z score, binary"
                  label variable bmizbin_`week' "week `week' BMI for age Z score, binary"
                  }
	
	drop gender0 gender2 gender8 gender16 gender24 gender52 gender104 gender156 gender208 gender999 
	rename gender_w0 gender
	drop dob0 dob2 dob8 dob16 dob24 dob52 dob104 dob156 dob208 dob999 
	drop visdatewk002 visdatewk008 
	drop visdatewk000 visdatewk016 visdatewk024 visdatewk052 visdatewk104 visdatewk156 visdatewk208 visdatewk999 
	drop visdate_w0 visdate_w2 visdate_w8 visdate_w16 visdate_w24 
	drop visdate_eos
	save "umoya_clinical_zscore.dta", replace
	
	use "umoya_clinical.dta", clear
	
	merge 1:1 record_id using "umoya_clinical_zscore.dta", assert(master match) keep(master match) generate(_symp_who)
	
	save "umoya_clinical.dta", replace
	
//NIH case deff
	
gen bl_cough_n=1 if umf01_ubl_cough==1 & umf01_ubl_coughpattern==2
//gen bl_wheeze_n=1 if umf01_ubl_wheeze==1
gen bl_weight_n = 1 if umf01_ubl_failurethrive==1 | ///
inlist(umf01_ubl_growthpatternrthc, 1, 2, 3, 4)
gen bl_fever_n = 1 if (umf01_ubl_fever==1 & umf01_ubl_feverdays>=7 & umf01_ubl_feverdays!=.) | umf01_ubl_fevernotresponding==1
gen bl_lethargy_n=1 if inlist(umf01_ubl_activitylevel, 2, 3)
gen bl_symptoms = 1 if bl_cough_n==1 | bl_weight_n==1 | bl_fever_n==1 | bl_lethargy_n==1
replace bl_symptoms=0 if bl_symptoms==.

save "umoya_clinical.dta", replace

use "UmoyaRestructure-Form8_counsellor.dta", clear

save "UmoyaRestructure-Form8_counsellor_tbcontact.dta", replace
drop redcap_event_name redcap_repeat_instrument redcap_repeat_instance umf08_uf8_visitweek 
drop umf08_uf8_vistime umf08_uf8_weight umf08_uf8_muac umf08_uf8_length umf08_uf8_temp umf08_uf8_oxygen umf08_uf8_heartrate umf08_uf8_resprate 
drop umf08_uf8_daterstposres umf08_uf8_unknown___98 umf08_uf8_ontreatment umf08_uf8_rxstartdate umf08_uf8_rxstartdateunkn___98 umf08_uf8_est umf08_uf8_adherent umf08_uf8_retreatment umf08_uf8_tbcontprimcarer umf08_uf8_tbcontmom umf08_uf8_tbcontsamehh umf08_uf8_more1tbcont umf08_uf8_tbconseechild umf08_uf8_tbcontsameroom umf08_uf8_tbconsamebed umf08_uf8_tbconcoughing umf08_uf8_tbcontactptb umf08_uf8_tbrxipt umf08_uf8_whogivesrx___1 umf08_uf8_whogivesrx___2 umf08_uf8_whogivesrx___3 umf08_uf8_whogivesrx___4 umf08_uf8_whogivesrx___5 umf08_uf8_whogivesrx___99 umf08_uf8_spec1 umf08_uf8_childtakingtbrx umf08_uf8_counselling umf08_uf8_counselling_ra umf08_uf8_carermedknowtb umf08_uf8_tbrxcard umf08_uf8_tbcardseen umf08_uf8_misseddoses umf08_uf8_numofmisseddosesrxcard umf08_uf8_kidvomitedmeds umf08_uf8_numofvomiteddoses umf08_uf8_kidrefusedmeds umf08_uf8_numofrefuseddoses umf08_uf8_dosesforgotten umf08_uf8_numofmisseddoses umf08_uf8_clinicadherissue umf08_uf8_nummisseddosespec umf08_uf8_participantonart umf08_uf8_childarvs umf08_uf8_counselling_1 umf08_uf8_counselling_ra_1 umf08_uf8_defaultedhiv umf08_uf8_carerhivmedknowadm umf08_uf8_carerknowwhichtabs___1 umf08_uf8_carerknowwhichtabs___2 umf08_uf8_carerknowwhichtabs___3 umf08_uf8_carerknowwhichtabs___4 umf08_uf8_carerknowwhichtabs___5 umf08_uf8_carerknowwhichtabs___6 umf08_uf8_carerknowwhichtabs___9 umf08_uf8_othspec2 umf08_uf8_carerreminder___1 umf08_uf8_carerreminder___2 umf08_uf8_carerreminder___3 umf08_uf8_carerreminder___99 umf08_uf8_othspec3 umf08_uf8_foodworry umf08_uf8_frequency umf08_uf8_bedhungry umf08_uf8_frequency_1 umf08_uf8_eatfruit umf08_uf8_eatmeat umf08_uf8_eat_redmeat umf08_uf8_eat_vegetables form_8_counsellor_information_co

gsort record_id -umf08_uf8_newtbcontact -umf08_uf8_tbconsmearpos
by record_id: gen n = _n
keep if n==1
save "UmoyaRestructure-Form8_counsellor_tbcontact.dta", replace

use "umoya_clinical.dta", clear
merge 1:1 record_id using "UmoyaRestructure-Form8_counsellor_tbcontact.dta", assert(master match) keep(master match) generate(_f8_tbcon)
save "umoya_clinical.dta", replace

gen tb_exposure = 1 if umf01_ubl_tbcontact==1 | umf07_uf7_tstresult==1 | umf08_uf8_newtbcontact==1
replace tb_exposure = 0 if tb_exposure==.
gen unconf_tb_n = bl_symptoms + tb_exposure

gen unconf_tb_cxr_n = unconf_tb_n
order unconf_tb_cxr_n, after(unconf_tb_n)
gen cxr_n=1 if interpretation==1 
//umf19_aii_cxr_review==1 | umf19_aii_cxr_review==3 //CXR Typical of TB
order cxr_n, after(unconf_tb_cxr_n)
replace unconf_tb_cxr_n = unconf_tb_cxr_n + cxr_n if cxr_n!=.

//wk2
gen resp_rx_cough_wk2 = 1 if (umf02_uw2_cough==1 & umf01_uw2_coughtype==3) | ///
(umf02_uw2_cough==0 & umf01_ubl_cough==1)
gen resp_rx_wheeze_wk2 = 1 if (umf02_uw2_wheeze==1 & umf02_uw2_wheezetype==3) | ///
(umf02_uw2_wheeze==0 & umf01_ubl_wheeze==1)
gen resp_rx_fever_wk2 = 1 if (umf02_uw2_fever==0 & umf01_ubl_fever==1)
gen resp_rx_appetite_wk2 = 1 if (umf02_uw2_lackappetite==0 & umf01_ubl_lackappetite==1)
gen resp_rx_lethargy_wk2 = 1 if umf02_uw2_activitylevel==1 & inlist(umf01_ubl_activitylevel, 2, 3)

gen resp_rx_wk2 = 0
replace resp_rx_wk2 = -1 if umf02_uw2_visdate==.
replace resp_rx_wk2=1 if resp_rx_cough_wk2==1 | ///
resp_rx_wheeze_wk2==1 | resp_rx_fever_wk2==1 | ///
resp_rx_appetite_wk2==1 | resp_rx_lethargy_wk2==1
//bro record_id umf02_uw2_cough umf01_uw2_coughtype umf02_uw2_wheeze umf02_uw2_wheezetype umf02_uw2_fever umf01_ubl_fever umf02_uw2_lackappetite umf01_ubl_lackappetite umf02_uw2_activitylevel umf01_ubl_activitylevel response_rx_wk2

//wk8
gen resp_rx_cough_wk8 = 1 if (umf03_uw8_cough==1 & umf03_uw8_coughtype==3) | ///
(umf03_uw8_cough==0 & umf01_ubl_cough==1)
gen resp_rx_wheeze_wk8 = 1 if (umf03_uw8_wheeze==1 & umf03_uw8_wheezetype==3) | ///
(umf03_uw8_wheeze==0 & umf01_ubl_wheeze==1)
gen resp_rx_fever_wk8 = 1 if (umf03_uw8_fever==0 & umf01_ubl_fever==1)
gen resp_rx_appetite_wk8 = 1 if (umf03_uw8_lackappetite==0 & umf01_ubl_lackappetite==1)
gen resp_rx_lethargy_wk8 = 1 if umf03_uw8_activitylevel==1 & inlist(umf01_ubl_activitylevel, 2, 3)

gen resp_rx_goodrespsetbrx_wk8 = 1 if umf03_uw8_goodrespsetbrx==1
gen resp_rx_weightgain_wk8 = 1 if umf03_uw8_weightgain==1
gen resp_rx_resolution_wk8 = 1 if umf03_uw8_resolution==1
gen resp_rx_clinician_wk8 = 1 if resp_rx_goodrespsetbrx_wk8==1 | ///
resp_rx_weightgain_wk8==1 | resp_rx_resolution_wk8==1

gen resp_rx_wk8 = 0
replace resp_rx_wk8 = -1 if umf03_uw8_visdate==.
replace resp_rx_wk8 = 1 if resp_rx_cough_wk8==1 | ///
resp_rx_wheeze_wk8==1 | resp_rx_fever_wk8==1 | ///
resp_rx_appetite_wk8==1 | resp_rx_lethargy_wk8==1 | ///
resp_rx_clinician_wk8==1
//bro record_id umf03_uw8_cough umf03_uw8_coughtype umf03_uw8_wheeze umf03_uw8_wheezetype umf03_uw8_fever umf01_ubl_fever umf03_uw8_lackappetite umf01_ubl_lackappetite umf03_uw8_activitylevel umf01_ubl_activitylevel response_rx_wk8 umf03_uw8_goodrespsetbrx umf03_uw8_weightgain umf03_uw8_resolution response_clinician_rx_wk8 response_rx_wk8_fin

//wk24
gen resp_rx_cough_wk24 = 1 if (umf05_uw24_cough==1 & umf05_uw24_coughtype==3) | ///
(umf05_uw24_cough==0 & umf01_ubl_cough==1)
gen resp_rx_wheeze_wk24 = 1 if (umf05_uw24_wheeze==1 & umf05_uw24_wheezetype==3) | ///
(umf05_uw24_wheeze==0 & umf01_ubl_wheeze==1)
gen resp_rx_fever_wk24 = 1 if (umf05_uw24_fever==0 & umf01_ubl_fever==1)
gen resp_rx_appetite_wk24 = 1 if (umf05_uw24_lackappetite==0 & umf01_ubl_lackappetite==1)
gen resp_rx_lethargy_wk24 = 1 if umf05_uw24_activitylevel==1 & inlist(umf01_ubl_activitylevel, 2, 3)

gen resp_rx_wk24 = 0
replace resp_rx_wk24 = -1 if umf05_uw24_visdate==.
replace resp_rx_wk24 = 1 if resp_rx_cough_wk24==1 | ///
resp_rx_wheeze_wk24==1 | resp_rx_fever_wk24==1 | ///
resp_rx_appetite_wk24==1 | resp_rx_lethargy_wk24==1 

//eos
//confirmed tb
gen resp_rx_goodtbrx_conftb_eos = 1 if umf15_ueos_goodrespns==1 & ///
umf15_ueos_tbclass==1
gen resp_rx_weightgain_conftb_eos = 1 if umf15_ueos_weightgain==1 & ///
umf15_ueos_tbclass==1
gen resp_rx_resolution_conftb_eos = 1 if umf15_ueos_resolution==1 & ///
umf15_ueos_tbclass==1
gen resp_rx_clinician_conftb_eos = 1 if (resp_rx_goodtbrx_conftb_eos==1 | ///
resp_rx_weightgain_conftb_eos==1 | resp_rx_resolution_conftb_eos==1) & ///
umf15_ueos_tbclass==1

//unconfirmed tb
gen resp_rx_goodtbrx_unconftb_eos = 1 if umf15_ueos_goodrespns2==1 & ///
umf15_ueos_tbclass==2
gen resp_rx_weightgain_unconftb_eos = 1 if umf15_ueos_weightgain2==1 & ///
umf15_ueos_tbclass==2
gen resp_rx_resolution_unconftb_eos = 1 if umf15_ueos_resolution2==1 & ///
umf15_ueos_tbclass==2
gen resp_rx_clinician_unconftb_eos = 1 if (resp_rx_goodtbrx_unconftb_eos==1 | ///
resp_rx_weightgain_unconftb_eos==1 | resp_rx_resolution_unconftb_eos==1) & ///
umf15_ueos_tbclass==2

//ill control
gen resp_rx_goodtbrx_illcont_eos = 1 if umf15_ueos_respnsrx==1 & ///
umf15_ueos_tbclass==3
gen resp_rx_weightgain_illcont_eos = 1 if umf15_ueos_weightgain3==1 & ///
umf15_ueos_tbclass==3
gen resp_rx_resolution_illcont_eos = 1 if umf15_eos_resolution3==1 & ///
umf15_ueos_tbclass==3
gen resp_rx_clinician_illcont_eos = 1 if (resp_rx_goodtbrx_illcont_eos==1 | ///
resp_rx_weightgain_illcont_eos==1 | resp_rx_resolution_illcont_eos==1) & ///
umf15_ueos_tbclass==3

gen resp_rx_eos = 0
replace resp_rx_eos = -1 if umf15_ueos_visdate==.
replace resp_rx_eos = 1 if resp_rx_clinician_conftb_eos==1 | ///
resp_rx_clinician_unconftb_eos==1 | ///
resp_rx_clinician_illcont_eos==1

gen ind_response_rx = 1 if resp_rx_wk2==1 | resp_rx_wk8==1 | ///
resp_rx_wk24==1
//gen overall_response_rx = 
order umf15_ueos_tbclass, after(TBTreatment)

//With response to Rx at wk8
gen unconf_tb_aim2a_cxr_n = unconf_tb_cxr_n
replace unconf_tb_aim2a_cxr_n = unconf_tb_aim2a_cxr_n + 1 ///
if umf03_uw8_tbrxr==1 & umf03_uw8_goodrespsetbrx==1
order unconf_tb_aim2a_cxr_n, after(unconf_tb_cxr_n)

//With response to Rx at wk24
gen good_response_TBRx = 0
replace good_response_TBRx = 1 if (umf15_ueos_tbclass==1 & umf15_ueos_goodrespns==1) | ///
(umf15_ueos_tbclass==2 & umf15_ueos_goodrespns2==1)
gen good_response_OtherRx = 0
replace good_response_OtherRx = 1 if (umf15_ueos_tbclass==3 & umf15_ueos_respnsrx==1)
gen unconf_tb_aim2b_cxr_n = unconf_tb_cxr_n
replace unconf_tb_aim2b_cxr_n = unconf_tb_aim2b_cxr_n + 1 ///
if (umf15_ueos_tbclass==1 & umf15_ueos_goodrespns==1) | ///
(umf15_ueos_tbclass==2 & umf15_ueos_goodrespns2==1) //| ///
//(umf15_ueos_tbclass==3 & umf15_ueos_respnsrx==1)
order unconf_tb_aim2b_cxr_n, after(unconf_tb_aim2a_cxr_n)

//AIM1 Without CXR
/*
Kids confirmed (trace) but never started on TB treatment. 
I wonder if we can recode them ignoring the TB micro results? 
And also keep one as confirmed as they are basically confirmed we just don’t believe they have TB. 
Maybe make “NIH_all_revised_confirmed_untreated”
*/

/*
I would like to make children that did not receive TB treatment but were classified as 
unconfirmed TB and did well without receiving TB treatment should become unlikely TB. Maybe we 
can make that another variable too “NIH_week8_revised_untreated”.
*/
/*
If Unlikely but treated for TB and good response to TB treatment to call them unconfirmed TB
*/

gen NIH_Category_aim1_nocxr = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim1_nocxr, after(umf15_ueos_tbclass)
replace NIH_Category_aim1_nocxr = "Unconfirmed TB" if NIH_Category_aim1_nocxr!="Confirmed TB" & unconf_tb_n>=2 & unconf_tb_n!=.
replace NIH_Category_aim1_nocxr="Unlikely TB" if NIH_Category_aim1_nocxr=="" & UMCategory!="healthy control"
replace NIH_Category_aim1_nocxr="Healthy Control" if NIH_Category_aim1_nocxr==""

gen NIH_Category_aim1_nocxr_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim1_nocxr_rev, after(NIH_Category_aim1_nocxr)
replace NIH_Category_aim1_nocxr_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_Category_aim1_nocxr_rev = "Unconfirmed TB" if NIH_Category_aim1_nocxr_rev!="Confirmed TB" & unconf_tb_n>=2 & unconf_tb_n!=.
replace NIH_Category_aim1_nocxr_rev="Unlikely TB" if NIH_Category_aim1_nocxr_rev=="" & UMCategory!="healthy control"
replace NIH_Category_aim1_nocxr_rev="Healthy Control" if NIH_Category_aim1_nocxr_rev==""

gen NIH_aim1_nocxr_wk8_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_aim1_nocxr_wk8_rev, after(NIH_Category_aim1_nocxr_rev)
replace NIH_aim1_nocxr_wk8_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_aim1_nocxr_wk8_rev = "Unconfirmed TB" if NIH_aim1_nocxr_wk8_rev!="Confirmed TB" & unconf_tb_n>=2 & unconf_tb_n!=.
replace NIH_aim1_nocxr_wk8_rev = "Unlikely TB" if NIH_aim1_nocxr_wk8_rev == "Unconfirmed TB" & tb_treament == 0 & resp_rx_wk8 == 1
replace NIH_aim1_nocxr_wk8_rev="Unlikely TB" if NIH_aim1_nocxr_wk8_rev=="" & UMCategory!="healthy control"
replace NIH_aim1_nocxr_wk8_rev = "Unconfirmed TB" if NIH_aim1_nocxr_wk8_rev == "Unlikely TB" & tb_treament == 1 & resp_rx_wk8 == 1
replace NIH_aim1_nocxr_wk8_rev="Healthy Control" if NIH_aim1_nocxr_wk8_rev==""
 
//AIM1 With CXR
gen NIH_Category_aim1_cxr = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim1_cxr, after(NIH_Category_aim1_nocxr_rev)
replace NIH_Category_aim1_cxr = "Unconfirmed TB" if NIH_Category_aim1_cxr!="Confirmed TB" & unconf_tb_cxr_n>=2 & unconf_tb_cxr_n!=.
replace NIH_Category_aim1_cxr="Unlikely TB" if NIH_Category_aim1_cxr=="" & UMCategory!="healthy control"
replace NIH_Category_aim1_cxr="Healthy Control" if NIH_Category_aim1_cxr==""

gen NIH_Category_aim1_cxr_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim1_cxr_rev, after(NIH_Category_aim1_cxr)
replace NIH_Category_aim1_cxr_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_Category_aim1_cxr_rev = "Unconfirmed TB" if NIH_Category_aim1_cxr_rev!="Confirmed TB" & unconf_tb_cxr_n>=2 & unconf_tb_cxr_n!=.
replace NIH_Category_aim1_cxr_rev="Unlikely TB" if NIH_Category_aim1_cxr_rev=="" & UMCategory!="healthy control"
replace NIH_Category_aim1_cxr_rev="Healthy Control" if NIH_Category_aim1_cxr_rev==""

gen NIH_aim1_cxr_wk8_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_aim1_cxr_wk8_rev, after(NIH_Category_aim1_cxr_rev)
replace NIH_aim1_cxr_wk8_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_aim1_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim1_cxr_wk8_rev!="Confirmed TB" & unconf_tb_cxr_n>=2 & unconf_tb_cxr_n!=.
replace NIH_aim1_cxr_wk8_rev = "Unlikely TB" if NIH_aim1_cxr_wk8_rev == "Unconfirmed TB" & tb_treament == 0 & resp_rx_wk8 == 1
replace NIH_aim1_cxr_wk8_rev="Unlikely TB" if NIH_aim1_cxr_wk8_rev=="" & UMCategory!="healthy control"
replace NIH_aim1_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim1_cxr_wk8_rev == "Unlikely TB" & tb_treament == 1 & resp_rx_wk8 == 1
replace NIH_aim1_cxr_wk8_rev="Healthy Control" if NIH_aim1_cxr_wk8_rev==""

//AIM2 With CXR
//Response to Rx wk8
gen NIH_Category_aim2a_cxr = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim2a_cxr, after(NIH_Category_aim1_cxr_rev)
replace NIH_Category_aim2a_cxr = "Unconfirmed TB" if NIH_Category_aim2a_cxr!="Confirmed TB" & unconf_tb_aim2a_cxr_n>=2 & unconf_tb_aim2a_cxr_n!=.
replace NIH_Category_aim2a_cxr="Unlikely TB" if NIH_Category_aim2a_cxr=="" & UMCategory!="healthy control"
replace NIH_Category_aim2a_cxr="Healthy Control" if NIH_Category_aim2a_cxr==""

gen NIH_Category_aim2a_cxr_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim2a_cxr_rev, after(NIH_Category_aim2a_cxr)
replace NIH_Category_aim2a_cxr_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_Category_aim2a_cxr_rev = "Unconfirmed TB" if NIH_Category_aim2a_cxr_rev!="Confirmed TB" & unconf_tb_aim2a_cxr_n>=2 & unconf_tb_aim2a_cxr_n!=.
replace NIH_Category_aim2a_cxr_rev="Unlikely TB" if NIH_Category_aim2a_cxr_rev=="" & UMCategory!="healthy control"
replace NIH_Category_aim2a_cxr_rev="Healthy Control" if NIH_Category_aim2a_cxr_rev==""

gen NIH_aim2a_cxr_wk8_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_aim2a_cxr_wk8_rev, after(NIH_Category_aim2a_cxr_rev)
replace NIH_aim2a_cxr_wk8_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_aim2a_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim2a_cxr_wk8_rev!="Confirmed TB" & unconf_tb_aim2a_cxr_n>=2 & unconf_tb_aim2a_cxr_n!=.
replace NIH_aim2a_cxr_wk8_rev = "Unlikely TB" if NIH_aim2a_cxr_wk8_rev == "Unconfirmed TB" & tb_treament == 0 & resp_rx_wk8 == 1
replace NIH_aim2a_cxr_wk8_rev="Unlikely TB" if NIH_aim2a_cxr_wk8_rev=="" & UMCategory!="healthy control"
replace NIH_aim2a_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim2a_cxr_wk8_rev == "Unlikely TB" & tb_treament == 1 & resp_rx_wk8 == 1
replace NIH_aim2a_cxr_wk8_rev="Healthy Control" if NIH_aim2a_cxr_wk8_rev==""

//AIM2 With CXR
//Response to Rx wk24
gen NIH_Category_aim2b_cxr = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim2b_cxr, after(NIH_Category_aim2a_cxr_rev)
replace NIH_Category_aim2b_cxr = "Unconfirmed TB" if NIH_Category_aim2b_cxr!="Confirmed TB" & unconf_tb_aim2b_cxr_n>=2 & unconf_tb_aim2b_cxr_n!=.
replace NIH_Category_aim2b_cxr="Unlikely TB" if NIH_Category_aim2b_cxr=="" & UMCategory!="healthy control"
replace NIH_Category_aim2b_cxr="Healthy Control" if NIH_Category_aim2b_cxr==""

gen NIH_Category_aim2b_cxr_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_Category_aim2b_cxr_rev, after(NIH_Category_aim2b_cxr)
replace NIH_Category_aim2b_cxr_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_Category_aim2b_cxr_rev = "Unconfirmed TB" if NIH_Category_aim2b_cxr_rev!="Confirmed TB" & unconf_tb_aim2b_cxr_n>=2 & unconf_tb_aim2b_cxr_n!=.
replace NIH_Category_aim2b_cxr_rev="Unlikely TB" if NIH_Category_aim2b_cxr_rev=="" & UMCategory!="healthy control"
replace NIH_Category_aim2b_cxr_rev="Healthy Control" if NIH_Category_aim2b_cxr_rev==""

gen NIH_aim2b_cxr_wk8_rev = "Confirmed TB" if umf11_uf11_res_xpert==2 | inlist(umf11_uf11_res_mgit, 1, 2, 3)
order NIH_aim2b_cxr_wk8_rev, after(NIH_Category_aim2b_cxr_rev)
replace NIH_aim2b_cxr_wk8_rev = "Confirmed TB Untreated" if tb_treament==0 & umf11_uf11_res_xpert==2
replace NIH_aim2b_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim2b_cxr_wk8_rev!="Confirmed TB" & unconf_tb_aim2b_cxr_n>=2 & unconf_tb_aim2b_cxr_n!=.
replace NIH_aim2b_cxr_wk8_rev = "Unlikely TB" if NIH_aim2b_cxr_wk8_rev == "Unconfirmed TB" & tb_treament == 0 & resp_rx_wk8 == 1
replace NIH_aim2b_cxr_wk8_rev="Unlikely TB" if NIH_aim2b_cxr_wk8_rev=="" & UMCategory!="healthy control"
replace NIH_aim2b_cxr_wk8_rev = "Unconfirmed TB" if NIH_aim2b_cxr_wk8_rev == "Unlikely TB" & tb_treament == 1 & resp_rx_wk8 == 1
replace NIH_aim2b_cxr_wk8_rev="Healthy Control" if NIH_aim2b_cxr_wk8_rev==""

save "umoya_clinical.dta", replace


	

