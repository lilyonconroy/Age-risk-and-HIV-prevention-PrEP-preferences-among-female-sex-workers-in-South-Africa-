gen age_group = .
replace age_group = 1 if qs_age < 25
replace age_group = 2 if qs_age >= 25
label define age_group 1 "Younger FSW" 2 "Older FSW"
label values age_group age_group

gen years_in_sexwork = qs_age - qs_exchangeage
bysort age_group: summarize qs_age years_in_sexwork
summarize qs_age years_in_sexwork
ttest qs_exchangeage, by(age_group)

tab qs_thcsite age_group, col chi2

tab qs_race age_group, col chi2

tab qs_countryborn age_group, col chi2

gen education_completed = .
replace education_completed = 1 if qs_gradelevel >= 12
replace education_completed = 0 if qs_gradelevel < 12
label define education_completed 0 "Did not complete grade school" 1 "Completed grade school"
label values education_completed education_completed
tab education_completed age_group, col chi2

tab qs_enrolledschool age_group, col chi2

tab qs_employmentstatus age_group, col chi2

tab qs_relationship age_group, col chi2

tab qs_children18live age_group, col chi2

tab qs_everhurt age_group, col chi2

tab qs_forcedsex age_group, col chi2

tab qs_illegaldrugs age_group, col chi2

tab qs_livingsituation age_group, col chi2

tab qs_fewfoods age_group, col chi2

tab qs_hivrisk age_group, col chi2

tab qs_contraception age_group, col chi2

gen ever_used_prep = .
replace ever_used_prep = 1 if qs_takenoralprep == 1 | qs_evertakenlai == 1 | qs_usedring == 1
replace ever_used_prep = 0 if (qs_takenoralprep == 0 | qs_takenoralprep == 2) & (qs_evertakenlai == 0 | qs_evertakenlai == 2) & (qs_usedring == 0 | qs_usedring == 2)
label define ever_used_prep 0 "Never used PrEP" 1 "Ever used PrEP"
label values ever_used_prep ever_used_prep
tab ever_used_prep age_group, col chi2

tab qs_prepcurrent age_group, col chi2

tab qs_pillorinjection age_group, col chi2


