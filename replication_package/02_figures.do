********************************************************************************
* code: 02_figures.do
* description: creates figures for Jensen and Weigel (2025, JEL)
********************************************************************************

cap log close
clear
clear matrix
cls
set more off

* set path to replication package (use forward-slash / for compatibility across devices)
global replication_package = ""
global data_final = "$replication_package/data/final"
global figures = "$replication_package/figures"

* ============================================================================ *
* data
* ============================================================================ *

use "$data_final/df_ISORA_GRD_VDEM_WB.dta", clear
* Sample restriction: 1 million in population and non-resource intense; already incorporated in imported dataset

* ============================================================================ *
* Figure 1
* ============================================================================ *

* Figure 1A
twoway (lfitci tax_ex_sc fte_per_laborforce, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc fte_per_laborforce, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc fte_per_laborforce, ///
        mcolor(gray*1.25)), legend(off) xtitle("Tax administration staff per labor force") ytitle("Tax revenue excl. soc sec (% of GDP)") graphregion(color(white)) ylabel(0(10)40)	
graph save "$figures/Figure1A.gph", replace
graph export "$figures/Figure1A.pdf", replace
		
* Figure 1B
twoway (lfitci tax_ex_sc vdem_meritocratic_recruitment, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc vdem_meritocratic_recruitment, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc vdem_meritocratic_recruitment, ///
        mcolor(gray*1.25)), legend(off) xtitle("Meritocratic recruitment score") ytitle("Tax revenue excl. soc sec (% of GDP)") xlabel(1(1)3) ylabel(0(10)40) graphregion(color(white))
graph save "$figures/Figure1B.gph", replace
graph export "$figures/Figure1B.pdf", replace		

* Figure 1C
twoway (lfitci tax_ex_sc staff_index if staff_index<=2, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc staff_index if staff_index<=2, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc staff_index if staff_index<=2, ///
        mcolor(gray*1.25)), legend(off) xtitle("Index of qualifications and tenure of staff") ytitle("Tax revenue excl. soc sec (% of GDP)") xlabel(-1(0.5)1.5) ylabel(0(10)40) graphregion(color(white))
graph save "$figures/Fig1C.gph", replace
graph export "$figures/Fig1C.pdf", replace
		
* Figure 1D 
twoway (lfitci tax_ex_sc electronic_payments_pct_number, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc electronic_payments_pct_number, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc electronic_payments_pct_number, ///
        mcolor(gray*1.25)), legend(off) xtitle("Share of payments received electronically") ytitle("Tax revenue excl. soc sec (% of GDP)") xlabel(0(20)100) ylabel(0(10)40) graphregion(color(white))
graph save "$figures/Fig1D.gph", replace
graph export "$figures/Fig1D.pdf", replace

* Figure 1E
twoway (lfitci tax_ex_sc vdem_executive, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc vdem_executive, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc vdem_executive, ///
        mcolor(gray*1.25)), legend(off) xtitle("Constraints on the executive") ytitle("Tax revenue excl. soc sec (% of GDP)") xlabel(-2(1)1) ylabel(0(10)40) graphregion(color(white))
graph save "$figures/Fig1E.gph", replace
graph export "$figures/Fig1E.pdf", replace

		
* Figure 1F
twoway (lfitci tax_ex_sc vdem_rigorous_impartial, ///
        lcolor(ltblue%0) fcolor(ltblue)) ///
       (lfit tax_ex_sc vdem_rigorous_impartial, ///
        lcolor(dknavy*1.25)) ///
       (scatter tax_ex_sc vdem_rigorous_impartial, ///
        mcolor(gray*1.25)), legend(off) xtitle("Impartial and rigorous public administration score") ytitle("Tax revenue excl. soc sec (% of GDP)") xlabel(0(1)4) ylabel(0(10)40) graphregion(color(white))
graph save "$figures/Fig1F.gph", replace
graph export "$figures/Fig1F.pdf", replace


* ============================================================================ *
* Figure 2
* ============================================================================ *

xtile exec_median=vdem_executive, nq(2)
xtile impartial=vdem_rigorous_impartial, nq(2)

egen mean_exec=mean(vdem_executive)
egen sd_exex=sd(vdem_executive)
gen z_exec=(vdem_executive-mean_exec)/sd_exex

egen mean_impartial=mean(vdem_rigorous_impartial)
egen sd_impartial=sd(vdem_rigorous_impartial)
gen z_impartial=(vdem_rigorous_impartial-mean_impartial)/sd_impartial

egen index_legitimate=rowmean(z_exec z_impartial)

egen mean_fte=mean(fte_per_laborforce)
egen sd_fte=sd(fte_per_laborforce)
gen z_fte=(fte_per_laborforce-mean_fte)/sd_fte

egen mean_merito=mean(vdem_meritocratic_recruitment)
egen sd_merito=sd(vdem_meritocratic_recruitment)
gen z_merito=(vdem_meritocratic_recruitment-mean_merito)/sd_merito

* winsorize z_staff at 99th percentile
egen mean_staff=mean(staff_index) if staff_index<=2
egen sd_staff=sd(staff_index) if staff_index<=2
gen z_staff=(staff_index-mean_staff)/sd_staff if staff_index<=2

egen mean_electroninc=mean(electronic_payments_pct_number)
egen sd_electronic=sd(electronic_payments_pct_number)
gen z_electronic=(electronic_payments_pct_number-mean_electroninc)/sd_electronic

egen index_admin=rowmean(z_electronic z_staff z_merito z_fte) if staff_index<=2

xtile indexlegit_median=index_legitimate, nq(2)
replace indexlegit_median=indexlegit_median-1

*** By admin component
reg tax_ex_sc c.z_fte##c.index_legitimate
predict y_fte, xb
twoway (lfitci y_fte z_fte if indexlegit_median==0, ///
        lcolor(ltblue*1.25) fcolor(ltblue)) ///
       (lfitci y_fte z_fte if indexlegit_median==1, ///
        lcolor(gray*1.25) fcolor(gray*1)), ///
       legend(order(1 "Low legitimacy" 3 "High legitimacy")) xtitle("admin index") graphregion(color(white)) ytitle("Tax revenue excl. soc sec (% of GDP)") xtitle("Tax staff per labor force (index)") xlabel(-2(1)3)
graph save "$figures/Fig2A.gph", replace
graph export "$figures/Fig2A.pdf", replace

reg tax_ex_sc c.z_merito##c.index_legitimate
predict y_merito, xb
twoway (lfitci y_merito z_merito if indexlegit_median==0, ///
        lcolor(ltblue*1.25) fcolor(ltblue)) ///
       (lfitci y_merito z_merito if indexlegit_median==1, ///
        lcolor(gray*1.25) fcolor(gray*1)), ///
       legend(order(1 "Low legitimacy" 3 "High legitimacy")) xtitle("admin index") graphregion(color(white)) ytitle("Tax revenue excl. soc sec (% of GDP)") xtitle("Meritocratic recruitment (index)") xlabel(-2(1)3)
graph save "$figures/Fig2B.gph", replace
graph export "$figures/Fig2B.pdf", replace

reg tax_ex_sc c.z_staff##c.index_legitimate if staff_index<=2
predict y_staff, xb
twoway (lfitci y_staff z_staff if indexlegit_median==0, ///
        lcolor(ltblue*1.25) fcolor(ltblue)) ///
       (lfitci y_staff z_staff if indexlegit_median==1, ///
        lcolor(gray*1.25) fcolor(gray*1)), ///
       legend(order(1 "Low legitimacy" 3 "High legitimacy")) xtitle("admin index") graphregion(color(white)) ytitle("Tax revenue excl. soc sec (% of GDP)") xtitle("Staff qualifications and tenure (index)") xlabel(-2(1)3)
graph save "$figures/Fig2C.gph", replace
graph export "$figures/Fig2C.pdf", replace

reg tax_ex_sc c.z_electronic##c.index_legitimate
predict y_electronic, xb
twoway (lfitci y_electronic z_electronic if indexlegit_median==0, ///
        lcolor(ltblue*1.25) fcolor(ltblue)) ///
       (lfitci y_electronic z_electronic  if indexlegit_median==1, ///
        lcolor(gray*1.25) fcolor(gray*1)), ///
       legend(order(1 "Low legitimacy" 3 "High legitimacy")) xtitle("admin index") graphregion(color(white)) ytitle("Tax revenue excl. soc sec (% of GDP)") xtitle("Share of payment received electronically (index)") xlabel(-2(1)3)
graph save "$figures/Fig2D.gph", replace
graph export "$figures/Fig2D.pdf", replace

