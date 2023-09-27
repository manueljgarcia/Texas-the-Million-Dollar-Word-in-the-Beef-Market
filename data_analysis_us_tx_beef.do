********************************************************************************
* Author: Manuel Garcia                                                        *                                     *                                               
* Date: September 2023                                                         *
********************************************************************************

//STEP 1: Import the raw data from Qualtrics (.xlsx; .csv; .tsv), merge it, apply quality assurance, and save it (*.dta).

*The first part of data wrangling was carried out using Python "data"
**clear
**import excel "C:\Users\gar14685\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset.xlsx", sheet("Sheet1) firstrow

clear
import excel "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset.xlsx", sheet("Sheet1") firstrow

drop if (Progress != 100 | Finished == "False") //we don't need partial responses//

// Drop CE missing answers
drop if (CE1 == "" | CE2 == "" | CE3 == "" | CE4 == "" | CE5 == "" | CE6 == "" | CE7 == "" | CE8 == "" | CE9 == "" | CE10 == "" | CE11 == "" | CE12 == "")

describe 

****************************************************************************************************************************************************************************

//STEP 2: Data wrangling -Estimating summary statistics

destring year_born, replace force
gen age = (2021 - year_born) //Years old in 2021

gen urban = 1 //Dummy variable (1=urban, 0=rural)
replace urban = 0 if location == "Rural" 

gen male = 1 //Dummy variable (1=male, 0=female)
replace male = 0 if gender == "Femenino"

gen household_size = household_size_underage + household_size_adults //Household size

summarize age urban male household_size

gen Block = .
replace Block = 1 if block == "b1"
replace Block = 2 if block == "b2"

drop block



tab edu
gen education = edu
replace education = "Middle School or below" if edu == "Primaria"
replace education = "High school" if (edu == "Secundaria" | edu == "Preparatoria o bachillerato")
replace education = "Professional (Technicians, BS, Graduate Degree)" if (edu == "Carrera técnica o comercial" | edu == "Universitario (Licenciatura, Ingeniería o posgrado)")
tab education 
drop edu

//Household monthly income
replace monthly_income = "Under 3,000 Pesos" if monthly_income == "Menos de 3,000 pesos"
replace monthly_income = "More than 30,000 Pesos" if monthly_income == "Más de 30,000 Pesos"
tab monthly_income

gen share_incomefood = budgetshare_food  //Household income spent on food --We will use the average for those surveys in which we asked for ranges--
replace share_incomefood = "5" if budgetshare_food == "Menos del 10%"
replace share_incomefood = "15" if budgetshare_food == "Entre el 10-19%"
replace share_incomefood = "25" if budgetshare_food == "Entre el 20-29%"
replace share_incomefood = "35" if budgetshare_food == "Entre el 30-39%"
replace share_incomefood = "45" if budgetshare_food == "Entre el 40-49%"
replace share_incomefood = "55" if budgetshare_food == "Entre el 50-60%"
replace share_incomefood = "60" if budgetshare_food == "Más del 60%"
destring share_incomefood, replace force


gen freq_beefpurchase = meat_purchase_freq //Frequency of beef purchase
replace freq_beefpurchase = "Daily" if meat_purchase_freq == "Diario"
replace freq_beefpurchase = "Weekly" if meat_purchase_freq == "Semanal"
replace freq_beefpurchase = "Biweekly" if meat_purchase_freq == "Quincenal"
replace freq_beefpurchase = "Monthly" if meat_purchase_freq == "Mensual"
replace freq_beefpurchase = "Less than once a month" if meat_purchase_freq == "Menos de una vez al mes"
replace freq_beefpurchase = "Never" if meat_purchase_freq == "Nunca"
tab freq_beefpurchase


gen freq_beefconsumption = meat_consumption_freq //Frequency of beef consumption
replace freq_beefconsumption = "4 or more times a week" if meat_consumption_freq == "4 o más por semana"
replace freq_beefconsumption = "2 - 3 times a week" if meat_consumption_freq == "2-3 veces por semana"
replace freq_beefconsumption = "Once a week" if meat_consumption_freq == "Una vez por semana"
replace freq_beefconsumption = "2 - 3 times a month" if meat_consumption_freq == "2-3 veces al mes"
replace freq_beefconsumption = "Once a month" if meat_consumption_freq == "1 vez al mes"
replace freq_beefconsumption = "Never" if meat_consumption_freq == "Nunca"
tab freq_beefconsumption


//Overall opinions about foreign places (US, Texas, Canada, and Nicaragua)
gen US_opinion =country_perception_us
replace US_opinion = "Somewhat or very unfavorable" if (country_perception_us == "1. (Muy desfavorable)" | country_perception_us == "2. (Algo desfavorable)")
replace US_opinion = "Neutral" if country_perception_us == "3. (Neutral)"
replace US_opinion = "Somewhat or very favorable" if (country_perception_us == "4. (Algo favorable)" | country_perception_us =="5. (Muy favorable)")
tab US_opinion if US_opinion != "Ninguna"

gen TX_opinion =country_perception_us_tx
replace TX_opinion = "Somewhat or very unfavorable" if (country_perception_us_tx == "1. (Muy desfavorable)" | country_perception_us_tx == "2. (Algo desfavorable)")
replace TX_opinion = "Neutral" if country_perception_us_tx == "3. (Neutral)"
replace TX_opinion = "Somewhat or very favorable" if (country_perception_us_tx == "4. (Algo favorable)" | country_perception_us_tx =="5. (Muy favorable)")
tab TX_opinion if TX_opinion != "Ninguna"

gen Can_opinion =country_perception_can
replace Can_opinion = "Somewhat or very unfavorable" if (country_perception_can == "1. (Muy desfavorable)" | country_perception_can == "2. (Algo desfavorable)")
replace Can_opinion = "Neutral" if country_perception_can == "3. (Neutral)"
replace Can_opinion = "Somewhat or very favorable" if (country_perception_can == "4. (Algo favorable)" | country_perception_can =="5. (Muy favorable)")
tab Can_opinion if Can_opinion != "Ninguna"

gen Nic_opinion =country_perception_nic
replace Nic_opinion = "Somewhat or very unfavorable" if (country_perception_nic == "1. (Muy desfavorable)" | country_perception_nic == "2. (Algo desfavorable)")
replace Nic_opinion = "Neutral" if country_perception_nic == "3. (Neutral)"
replace Nic_opinion = "Somewhat or very favorable" if (country_perception_nic == "4. (Algo favorable)" | country_perception_nic =="5. (Muy favorable)")
tab Nic_opinion if Nic_opinion != "Ninguna"



//Consumers' opinions of characteristics of products labeled with Geographic Indication (GI)
gen GI_Highquality = coo_percep_higherquality
replace GI_Highquality = "Disagree or totally disagree" if (coo_percep_higherquality == "1. (Totalmente en desacuerdo)" | coo_percep_higherquality == "2.")
replace GI_Highquality = "Neutral" if coo_percep_higherquality == "3. (Neutral)"
replace GI_Highquality = "Agree or totally agree" if (coo_percep_higherquality == "4." | coo_percep_higherquality =="5. (Totalmente de acuerdo)")
tab GI_Highquality if GI_Highquality != "Ninguna"

gen GI_Constantquality = coo_percep_constantquality
replace GI_Constantquality = "Disagree or totally disagree" if (coo_percep_constantquality == "1. (Totalmente en desacuerdo)" | coo_percep_constantquality == "2.")
replace GI_Constantquality = "Neutral" if coo_percep_constantquality == "3. (Neutral)"
replace  GI_Constantquality = "Agree or totally agree" if (coo_percep_constantquality == "4." | coo_percep_constantquality =="5. (Totalmente de acuerdo)")
tab GI_Constantquality if  GI_Constantquality != "Ninguna"

gen GI_Authenticity = coo_percep_original
replace GI_Authenticity = "Disagree or totally disagree" if (coo_percep_original == "1. (Totalmente en desacuerdo)" | coo_percep_original== "2.")
replace GI_Authenticity = "Neutral" if coo_percep_original == "3. (Neutral)"
replace GI_Authenticity = "Agree or totally agree" if (coo_percep_original == "4." | coo_percep_original =="5. (Totalmente de acuerdo)")
tab GI_Authenticity if GI_Authenticity != "Ninguna"

gen GI_Exclusivity = coo_percep_exclusivity
replace GI_Exclusivity = "Disagree or totally disagree" if (coo_percep_exclusivity == "1. (Totalmente en desacuerdo)" | coo_percep_exclusivity == "2.")
replace GI_Exclusivity = "Neutral" if coo_percep_exclusivity == "3. (Neutral)"
replace GI_Exclusivity = "Agree or totally agree" if (coo_percep_exclusivity == "4." | coo_percep_exclusivity =="5. (Totalmente de acuerdo)")
tab GI_Exclusivity if GI_Exclusivity != "Ninguna"



//Consumers' perceptions of beef quality by country of origin
gen COOL_USqual = coo_beefquality_percep_us
replace COOL_USqual = "Poor or very poor" if (coo_beefquality_percep_us == "1. (Pobre calidad)" | coo_beefquality_percep_us == "2.")
replace COOL_USqual = "Fair" if coo_beefquality_percep_us == "3. (Buena calidad)"
replace COOL_USqual = "Good or very good" if (coo_beefquality_percep_us == "4." | coo_beefquality_percep_us =="5. (Excelente calidad)")
tab COOL_USqual if COOL_USqual != "Ninguna"

gen COOL_Mexicoqual = coo_beefquality_percep_mx
replace COOL_Mexicoqual = "Poor or very poor" if (coo_beefquality_percep_mx == "1. (Pobre calidad)" | coo_beefquality_percep_mx == "2.")
replace COOL_Mexicoqual = "Fair" if coo_beefquality_percep_mx == "3. (Buena calidad)"
replace COOL_Mexicoqual = "Good or very good" if (coo_beefquality_percep_mx == "4." | coo_beefquality_percep_mx =="5. (Excelente calidad)")
tab COOL_Mexicoqual if COOL_Mexicoqual != "Ninguna"

gen COOL_Canadaqual = coo_beefquality_percep_can
replace COOL_Canadaqual = "Poor or very poor" if (coo_beefquality_percep_can == "1. (Pobre calidad)" | coo_beefquality_percep_can == "2.")
replace COOL_Canadaqual = "Fair" if coo_beefquality_percep_can == "3. (Buena calidad)"
replace COOL_Canadaqual = "Good or very good" if (coo_beefquality_percep_can == "4." | coo_beefquality_percep_can =="5. (Excelente calidad)")
tab COOL_Canadaqual if COOL_Canadaqual != "Ninguna"

gen COOL_Nicaraguaqual = coo_beefquality_percep_nic
replace COOL_Nicaraguaqual = "Poor or very poor" if (coo_beefquality_percep_nic == "1. (Pobre calidad)" | coo_beefquality_percep_nic == "2.")
replace COOL_Nicaraguaqual = "Fair" if coo_beefquality_percep_nic == "3. (Buena calidad)"
replace COOL_Nicaraguaqual = "Good or very good" if (coo_beefquality_percep_nic == "4." | coo_beefquality_percep_nic =="5. (Excelente calidad)")
tab COOL_Nicaraguaqual if COOL_Nicaraguaqual != "Ninguna"



//Consumers' perceptions of beef quality by US State of origin
gen Texas_beefqual = state_beefquality_percep_tx
replace Texas_beefqual = "Poor or very poor" if (state_beefquality_percep_tx == "1. (Pobre calidad)" | state_beefquality_percep_tx == "2.")
replace Texas_beefqual = "Fair" if state_beefquality_percep_tx == "3. (Buena calidad)"
replace Texas_beefqual = "Good or very good" if (state_beefquality_percep_tx == "4." | state_beefquality_percep_tx =="5. (Excelente calidad)")
tab Texas_beefqual if Texas_beefqual != "Ninguna"

gen Nebraska_beefqual = state_beefquality_percep_nebrask
replace Nebraska_beefqual = "Poor or very poor" if (state_beefquality_percep_nebrask== "1. (Pobre calidad)" | state_beefquality_percep_nebrask == "2.")
replace Nebraska_beefqual = "Fair" if state_beefquality_percep_nebrask == "3. (Buena calidad)"
replace Nebraska_beefqual = "Good or very good" if (state_beefquality_percep_nebrask == "4." | state_beefquality_percep_nebrask=="5. (Excelente calidad)")
tab Nebraska_beefqual if Nebraska_beefqual != "Ninguna"

gen Kansas_beefqual = state_beefquality_percep_ks
replace Kansas_beefqual = "Poor or very poor" if (state_beefquality_percep_ks == "1. (Pobre calidad)" | state_beefquality_percep_ks == "2.")
replace Kansas_beefqual = "Fair" if state_beefquality_percep_ks == "3. (Buena calidad)"
replace Kansas_beefqual = "Good or very good" if (state_beefquality_percep_ks == "4." | state_beefquality_percep_ks =="5. (Excelente calidad)")
tab Kansas_beefqual if Kansas_beefqual != "Ninguna"

gen California_beefqual = state_beefquality_percep_ca
replace California_beefqual = "Poor or very poor" if (state_beefquality_percep_ca == "1. (Pobre calidad)" | state_beefquality_percep_ca == "2.")
replace California_beefqual = "Fair" if state_beefquality_percep_ca == "3. (Buena calidad)"
replace California_beefqual = "Good or very good" if (state_beefquality_percep_ca == "4." | state_beefquality_percep_ca =="5. (Excelente calidad)")
tab California_beefqual if California_beefqual != "Ninguna"

gen Oklahoma_beefqual = state_beefquality_percep_ok
replace Oklahoma_beefqual = "Poor or very poor" if (state_beefquality_percep_ok == "1. (Pobre calidad)" | state_beefquality_percep_ok == "2.")
replace Oklahoma_beefqual = "Fair" if state_beefquality_percep_ok == "3. (Buena calidad)"
replace Oklahoma_beefqual = "Good or very good" if (state_beefquality_percep_ok == "4." | state_beefquality_percep_ok =="5. (Excelente calidad)")
tab Oklahoma_beefqual if Oklahoma_beefqual != "Ninguna"

// Number of observations
gen obs = .
forvalues i = 1/`=_N' {
    replace obs = `i' if _n == `i'
    replace obs = obs[_n-1]+1 if _n > `i'
}

****************************************************************************************************************************************************************************

//STEP 3: -cont. Data wrangling-Frame design

// Generate 12 choice sets with 3 alternatives each
foreach i in Alta Altb Altc Altd Alte Altf Altg Alth Alti Altj Altk Altl {
    gen `i'1 = 1
    gen `i'2 = 2
    gen `i'3 = 3
	gen `i'4 = 4
	gen `i'5 = 5
	gen `i'6 = 6
}


// transpose the matrix of alternatives
reshape long Alt, i(obs) j(Q) string


// Generate sets=12
gen Set = 12
local letters = "abcdefghijkl"

forval i = 1/12 {
    local l = substr("`letters'", `i', 1)
    replace Set = `i' if Q == "`l'1" | Q == "`l'2" | Q == "`l'3"| Q == "`l'4" | Q == "`l'5" | Q == "`l'6" 
}

// Generate Choice
gen Choice = 0
forvalues i = 1/6 {
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a1") & (CE1=="Opción 1")
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a2") & (CE1=="Opción 2") 
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a3") & (CE1=="Opción 3")
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a4") & (CE1=="Opción 4")
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a5") & (CE1=="Opción 5")
	replace Choice=1 if (Set==1) & (Block==`i') & (Q=="a6")& (CE1=="Ninguno") 
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b1") & (CE2=="Opción 1")
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b2") & (CE2=="Opción 2")
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b3") & (CE2=="Opción 3")
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b4") & (CE2=="Opción 4")
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b5") & (CE2=="Opción 5")
	replace Choice=1 if (Set==2) & (Block==`i') & (Q=="b6")& (CE2=="Ninguno") 
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c1") & (CE3=="Opción 1")
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c2") & (CE3=="Opción 2")
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c3") & (CE3=="Opción 3")
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c4") & (CE3=="Opción 4")
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c5") & (CE3=="Opción 5")
	replace Choice=1 if (Set==3) & (Block==`i') & (Q=="c6") & (CE3=="Ninguno") 
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d1") & (CE4=="Opción 1")
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d2") & (CE4=="Opción 2")
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d3") & (CE4=="Opción 3")
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d4") & (CE4=="Opción 4")
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d5") & (CE4=="Opción 5")
	replace Choice=1 if (Set==4) & (Block==`i') & (Q=="d6") & (CE4=="Ninguno") 
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e1") & (CE5=="Opción 1")
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e2") & (CE5=="Opción 2")
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e3") & (CE5=="Opción 3")
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e4") & (CE5=="Opción 4")
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e5") & (CE5=="Opción 5")
	replace Choice=1 if (Set==5) & (Block==`i') & (Q=="e6") & (CE5=="Ninguno") 
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f1") & (CE6=="Opción 1")
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f2") & (CE6=="Opción 2")
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f3") & (CE6=="Opción 3")
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f4") & (CE6=="Opción 4")
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f5") & (CE6=="Opción 5")
	replace Choice=1 if (Set==6) & (Block==`i') & (Q=="f6") & (CE6=="Ninguno") 
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g1") & (CE7=="Opción 1")
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g2") & (CE7=="Opción 2")
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g3") & (CE7=="Opción 3")
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g4") & (CE7=="Opción 4")
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g5") & (CE7=="Opción 5")
	replace Choice=1 if (Set==7) & (Block==`i') & (Q=="g6") & (CE7=="Ninguno") 
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h1") & (CE8=="Opción 1")
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h2") & (CE8=="Opción 2")
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h3") & (CE8=="Opción 3")
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h4") & (CE8=="Opción 4")
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h5") & (CE8=="Opción 5")
	replace Choice=1 if (Set==8) & (Block==`i') & (Q=="h6") & (CE8=="Ninguno")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i1") & (CE9=="Opción 1")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i2") & (CE9=="Opción 2")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i3") & (CE9=="Opción 3")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i4") & (CE9=="Opción 4")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i5") & (CE9=="Opción 5")
	replace Choice=1 if (Set==9) & (Block==`i') & (Q=="i6") & (CE9=="Ninguno") 
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j1") & (CE10=="Opción 1")
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j2") & (CE10=="Opción 2")
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j3") & (CE10=="Opción 3")
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j4") & (CE10=="Opción 4")
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j5") & (CE10=="Opción 5")
	replace Choice=1 if (Set==10) & (Block==`i') & (Q=="j6") & (CE10=="Ninguno") 
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k1") & (CE11=="Opción 1")
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k2") & (CE11=="Opción 2")
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k3") & (CE11=="Opción 3")
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k4") & (CE11=="Opción 4")
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k5") & (CE11=="Opción 5")
	replace Choice=1 if (Set==11) & (Block==`i') & (Q=="k6") & (CE11=="Ninguno") 
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l1") & (CE12=="Opción 1")
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l2") & (CE12=="Opción 2")
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l3") & (CE12=="Opción 3")
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l4") & (CE12=="Opción 4")
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l5") & (CE12=="Opción 5")
	replace Choice=1 if (Set==12) & (Block==`i') & (Q=="l6") & (CE12=="Ninguno") 
}

* Save it
save "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\panel_data.dta", replace



****************************************************************************************************************************************************************************

//STEP 4: Merge the Dataset with the experimental design and save it (*.dta)

// Import the first Excel file and save it as a temporary Stata dataset
import excel "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data\Block1.xlsx", sheet("B1") firstrow clear
tempfile block1
save `block1', replace

// Import the second Excel file and save it as a temporary Stata dataset
import excel "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data\Block2.xlsx", sheet("B2") firstrow clear
tempfile block2
save `block2', replace

// Use the first Stata dataset and append the second one to it
use `block1', clear
append using `block2'


sort Block Set Alt


order Block Set Alt ASC Mexico US Texas Canada Nicaragua Price Fsafety Prod

* 4.7 Save the experimental_design
save "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\experimental_design.dta", replace

* 4.8 Merge the dataset with the experimental design
use "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\panel_data.dta", clear
merge m:1 Block Set Alt using "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\experimental_design.dta"

sort  obs Block Set Alt
drop if Block == . // 0 obervation deleted

gen CHOICESITUATION = int((_n-1)/6) +1

order CHOICESITUATION obs Block Set Alt Choice ASC Mexico US Texas Canada Nicaragua Price Fsafety Prod

* 4.9 Save it
save "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset_processed.dta", replace

export excel using "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset_processed.xlsx",  firstrow(variables) replace


****************************************************************************************************************************************************************************

//STEP 5: Estimate the results

use "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset_processed.dta", clear

// Installing the mixlogitwtp package
ssc install mixlogitwtp

gen PRICEATRIB= (-Price/18.9)/2.2 //USD/Lb. Exchange rate = $18.90:1USD

//Merging the US and Texas
*gen us_d = 1 if US == 1 | Texas ==1
*replace us_d = 0 if us_d == .


/* WTP BETAS: BASELINE MEXICAN BEEF */
mixlogitwtp Choice,  price(PRICEATRIB)  rand(ASC US Texas Canada Nicaragua Fsafety Prod) group(CHOICESITUATION)  id(obs) nrep(1000) 
mixlbeta  US Texas Canada Nicaragua Fsafety Prod, nrep(1000) saving(WTP_BETAS_TX_MX1000) replace

export excel using "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\wtp_values1000.xlsx", firstrow(variables) replace

import excel "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\dataset_processed.xlsx", sheet("Sheet1") firstrow clear
drop if (Choice == 0 | Choice == .)
drop CHOICESITUATION Block Set Alt ASC Mexico US Texas Canada Nicaragua Price Fsafety Prod Q 
duplicates drop obs, force

merge 1:1 obs using "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\scripts\WTP_BETAS_TX_MX1000.dta", keep(match master) nogen

save "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\data_viz1000.dta", replace

export excel using "D:\OneDrive - Texas Tech University\PUBLICATIONS\Published\Mexican_consumers_perceptions_and_preferences_for_US_and_Texas_beef\Texas beef in Mexico\Texas-Mexico Beef Project\data_output\data_viz1000.xlsx", firstrow(variables) replace

