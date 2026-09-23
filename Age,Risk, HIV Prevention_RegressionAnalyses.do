*new variables
gen prefers_injection = .
replace prefers_injection = 1 if qs_pillorinjection == 2 | qs_pillorinjection == 3
replace prefers_injection = 0 if qs_pillorinjection == 1 | qs_pillorinjection == 4 | qs_pillorinjection == 5
replace prefers_injection = . if qs_pillorinjection == .
label define prefers_injection_lbl 1 "Prefers Injection" 0 "Does Not Prefer Injection"
label values prefers_injection prefers_injection_lbl

gen age_group = .
replace age_group = 1 if qs_age < 25 & !missing(qs_age)
replace age_group = 2 if qs_age >= 25 & !missing(qs_age)
replace age_group = . if qs_age == .
label define age_group_lbl 1 "Younger FSW" 2 "Older FSW"
label values age_group age_group_lbl

gen steadyliving = .
replace steadyliving = 1 if qs_livingsituation == 1
replace steadyliving = 0 if qs_livingsituation == 2
replace steadyliving = 0 if qs_livingsituation == 3
replace steadyliving = 0 if qs_livingsituation == 4
replace steadyliving = 0 if qs_livingsituation == 5
replace steadyliving = . if qs_livingsituation == 99
label define housed_lbl 0 "Unsteady Living" 1 "Steady Living"
label values steadyliving housed_lbl

gen fewfoods = .
replace fewfoods = 1 if qs_fewfoods == 1
replace fewfoods = 1 if qs_fewfoods == 2
replace fewfoods = 1 if qs_fewfoods == 3
replace fewfoods = 0 if qs_fewfoods == 0
replace fewfoods = . if qs_fewfoods == 99
label define few_lbl 0 "Many foods" 1 "Few foods"
label values fewfoods few_lbl

gen prep_use = .
replace prep_use = 0 if qs_prepcurrent == 0
replace prep_use = 0 if ever_used_prep == 0
replace prep_use = 1 if qs_prepcurrent == 1
replace prep_use = 1 if qs_prepcurrent == 2
replace prep_use = 1 if qs_prepcurrent == 3
replace prep_use = 1 if qs_prepcurrent == 4
replace prep_use = . if qs_prepcurrent == 99
label define using_lbl 0 "No PrEP" 1 "Using PrEP"
label values prep_use using_lbl

gen risk_perception = . 
replace risk_perception = 0 if qs_hivrisk == 1
replace risk_perception = 0 if qs_hivrisk == 2
replace risk_perception = 1 if qs_hivrisk == 3
replace risk_perception = 1 if qs_hivrisk == 4
replace risk_perception = . if qs_hivrisk == 88
replace risk_perception = . if qs_hivrisk == 99
label define hivrisk_lbl 0 "High perception of risk" 1 "Low perception of risk"
label values risk_perception hivrisk_lbl

replace qs_everhurthusband = . if qs_everhurthusband == 99

gen husbandhurt = . 
replace husbandhurt = 0 if qs_everhurt == 0
replace husbandhurt = 0 if qs_everhurthusband == 0
replace husbandhurt = 1 if qs_everhurthusband == 1
replace husbandhurt = . if qs_everhurthusband == 99
label define husbandhurt_lbl 0 "Not hurt" 1 "Hurt by husband"
label values husbandhurt husbandhurt_lbl

replace qs_relationship = . if qs_relationship == 99

gen dependents = . 
replace dependents = 0 if qs_everpregnant == 0
replace dependents = 0 if qs_childrenliving == 0
replace dependents = 0 if qs_children18 == 0
replace dependents = 0 if qs_children18live == 2 
replace dependents = 1 if qs_children18live == 0
replace dependents = 1 if qs_children18live == 1
replace dependents = . if qs_everpregnant == 99
replace dependents = . if qs_children18live == 99
label define dependents_lbl 0 "No dependents" 1 "Dependents"
label values dependents dependents_lbl

* tabulation
tab age_group
tab risk_perception
tab dependents
tab qs_relationship
tab husbandhurt
tab qs_thcsite
tab fewfoods

*model 1 - unadjusted/crude analysis
poisson prefers_injection ib1.age_group , vce(robust) irr
estimates store e1
poisson prefers_injection ib0.dependents, vce(robust) irr
estimates store e2
poisson prefers_injection ib0.risk_perception, vce(robust) irr
estimates store e3
poisson prefers_injection ib1.qs_relationship, vce(robust) irr
estimates store e4
poisson prefers_injection ib0.husbandhurt, vce(robust) irr
estimates store e5
poisson prefers_injection ib1.qs_thcsite, vce(robust) irr
estimates store e6
poisson prefers_injection ib0.fewfoods, vce(robust) irr
estimates store e7

*correlation matrix
correlate prefers_injection husbandhurt fewfoods qs_thcsite qs_relationship race_black age_group risk_perception

*model 2 - RFA analysis
poisson prefers_injection ib1.age_group ib0.dependents ib0.risk_perception  ib0.husbandhurt ib1.qs_relationship ib1.qs_thcsite ib0.fewfoods, vce (robust) irr
etable, append

*model 3 - Stratified RFA
poisson prefers_injection ib0.dependents ib0.risk_perception ib0.husbandhurt ib1.qs_relationship ib1.qs_thcsite ib0.fewfoods if age_group == 1, vce(robust) irr

poisson prefers_injection ib0.dependents ib0.risk_perception ib0.husbandhurt ib1.qs_relationship ib1.qs_thcsite ib0.fewfoods if age_group == 2, vce(robust) irr













