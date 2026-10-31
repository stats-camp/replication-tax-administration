********************************************************************************
* code: 01_build_data.do
* description: merges ISORA and GRD and collapses to country level (2018-2021)
********************************************************************************

cap log close
clear 
cls
set more off

* set folder paths (use forward-slash / for compatibility across devices)
global replication_package = "/Users/konstantinpoensgen/Library/CloudStorage/Dropbox/Research/work-with-anders/JEL_data-analysis/replication_package"
global data_raw = "$replication_package/data/raw"
global data_intermediate = "$replication_package/data/intermediate"
global data_final = "$replication_package/data/final"

* ============================================================================ *
* process UNU-WIDER/ICTD Government Revenue Dataset
* ============================================================================ *    
    
* import raw data
import delimited "$data_raw/UNUWIDERGRD_2023.csv", clear delim(",") varn(1)
    
* keep relevant variables and year range
keep iso year tax_inc_sc tax_ex_sc resourcetaxes
keep if inrange(year, 2018, 2021)    
rename iso iso_code
    
* collapse on country level
collapse (mean) tax_inc_sc tax_ex_sc resourcetaxes, by(iso_code)

* save processed data
save "$data_intermediate/df_grd.dta", replace

* ============================================================================ *
* process VDEM
* ============================================================================ *

* import a VDEM version with less variables (for computational reasons)
import delimited "$data_raw/VDEM_short.csv", clear delim(",") varn(1)

    * keep relevant year ranges
    keep if inrange(year, 2018, 2021)
    
    * rename variables
    rename country_text_id iso_code
    rename v2clrspct_osp vdem_rigorous_impartial
    rename v2stcritrecadm_osp vdem_meritocratic_recruitment
    rename v2x_jucon vdem_executive_judicial
    rename v2xlg_legcon vdem_executive_legislative
    
    * convert to numeric
    destring vdem_executive_legislative, replace ignore("NA")
    
* collapse to country-level
    
    * first collapse on country-year level
    collapse (mean) vdem_*, by(iso_code year)
    
    * now collapse on country level
    collapse (mean) vdem_*, by(iso_code)
    
* combine executive judicial and legislative
foreach var in vdem_executive_judicial vdem_executive_legislative {
    qui sum `var'
    gen `var'_z = (`var' - `r(mean)')/`r(sd)'
}
egen vdem_executive = rowmean(vdem_executive_judicial_z vdem_executive_legislative_z)

* save processed data
keep iso_code vdem_rigorous_impartial vdem_meritocratic_recruitment vdem_executive
save "$data_intermediate/df_vdem.dta", replace

* ============================================================================ *
* process GDP pc World Bank data
* ============================================================================ *

* import WB data on GDP per capita
import delimited "$data_raw/worldbank_NY.GDP.PCAP.KD_20240808.csv", clear delim(",") varn(1)
    
* compute country means
egen gdp_pc = rowmean(v63 v64 v65 v66)

* save processed data
keep iso_code gdp_pc
save "$data_intermediate/df_wb_gdp.dta", replace

* ============================================================================ *
* process ISORA
* ============================================================================ *

* country roster
import excel "$data_raw/countrycodes.xlsx", clear firstrow 
keep country_isora iso_code income_group_wb
    
    * expand to one row for each year (2018-2021)
    expand 4
    bysort iso_code: gen year = 2017 + _n
    assert inlist(year, 2018, 2019, 2020, 2021)
    
    tempfile df_isora
    save `df_isora'

* process individual tables from ISORA
foreach var in laborforce_per_FTE population staff_pct_master ///
    staff_pct_20_more e_payments_pct_number e_payments_pct_value {
    
    * ISORA excel sheet    
    if "`var'"=="laborforce_per_FTE" {
        local excel_file = "ISORA_14_Derived_indicators_Revenue_and_r"
        local excel_sheet = "D5_resource ratios_FTE"
    }
    else if "`var'"=="population" {
        local excel_file = "ISORA_14_Derived_indicators_Revenue_and_r"
        local excel_sheet = "population_laborforce"
    }
    else if "`var'"=="staff_pct_master" {
        local excel_file = "ISORA_15_Derived_indicators_Staff"
        local excel_sheet = "D10_academic_qualifications"
    }
    else if "`var'"=="staff_pct_20_more" {
        local excel_file = "ISORA_15_Derived_indicators_Staff"
        local excel_sheet = "D14_length_more_10"
    }
    else if "`var'"=="e_payments_pct_number" {
        local excel_file = "ISORA_12_Stakeholder_interactions_Return_"
        local excel_sheet = "A88_electronic_payments"
    }
    else if "`var'"=="e_payments_pct_value" {
        local excel_file = "ISORA_12_Stakeholder_interactions_Return_"
        local excel_sheet = "A88_electronic_payments"
    }
    
    * load raw data from ISORA
    import excel "$data_raw/`excel_file'.xlsx", clear firstrow sheet("`excel_sheet'")
    
    * keep relevant variables and entries
    keep country_isora `var'* 
    keep if !inlist(country_isora, "", "Formula") 
    keep if !(strpos(country_isora, "Please see the tables referred") > 0)
    
    * reshape to long and destring
    reshape long `var'_, i(country_isora) j(year)
    rename `var'_ `var'
    destring `var', ignore("D") replace
        
    * merge onto main data
    merge 1:1 country_isora year using `df_isora', assert(3) nogen
    
    if "`var'"=="e_payments_pct_number" rename e_payments_pct_number electronic_payments_pct_number
    if "`var'"=="e_payments_pct_value" rename e_payments_pct_value electronic_payments_pct_value
    
    tempfile df_isora
    save `df_isora', replace
}

* collapse to country level
collapse (mean) staff* labor* population* electronic*, by(country_isora iso_code income_group_wb)

* label variables
label var laborforce_per_FTE "Labor force per FTE staff (Table D5)"
label var population "Population"
label var staff_pct_master "Education level of staff (Table D10)"
label var staff_pct_20_more "Length of contract - percent 20 years or more (Tables D13-14)"
label var electronic_payments_pct_number "Number of electronic payments (Table A88)"
label var electronic_payments_pct_value "Share of electronic payments (Table A88)"

* compute additional variables
   
    * calculate Z-scores
    foreach var in electronic_payments_pct_number staff_pct_20_more staff_pct_master {
        qui sum `var'
        gen `var'_z = (`var' - `r(mean)')/`r(sd)'
    }
       
    egen z_score = rowmean(electronic_payments_pct_number_z staff_pct_20_more_z staff_pct_master_z)
    egen staff_index = rowmean(staff_pct_20_more_z staff_pct_master_z)
    
    * FTE per laborforce
    gen fte_per_laborforce=1/laborforce_per_FTE

* save processed ISORA data
save "$data_intermediate/df_isora.dta", replace  
    
* ============================================================================ *
* merge datasets
* ============================================================================ *      
    
* left-join of {ISORA, GRD}
merge 1:1 iso_code using "$data_intermediate/df_grd.dta"

    * look into countries in ISORA but not in GRD
    list country_isora iso_code population if _merge==1    
    drop if _merge!=3
    drop _merge
    
* filter to relevant countries
gen resource_share = resourcetaxes/tax_ex_sc
keep if (population > 10^6 & population!=.) & (resource_share  <= 1/3 | resource_share==.) & !missing(tax_ex_sc)   
drop resource_share
    
* left-join {DF, VDEM}
merge 1:1 iso_code using "$data_intermediate/df_vdem.dta", assert(2 3) keep(3) nogen

* left-join {DF, GDP per capita}
merge 1:1 iso_code using "$data_intermediate/df_wb_gdp.dta", assert(2 3) keep(3) nogen
  
* save dataset
save "$data_final/df_ISORA_GRD_VDEM_WB.dta", replace  
    
