** Preparation of the data dictionary for the TDA

cd "/Volumes/Files/Studies/RaPaed/3_analysis/04_TDA/Analysis/"
use "Der01_RefStandard.dta", clear

** Drop variables which are not necessary (all sep contents and merge)
drop __Sep_Icf __SepContents_Icf __Sep_Enr _merge_Icf __SepContents_Enr __Sep_Qes __SepContents_Qes __Sep_Inf __SepContents_Inf __Sep_Tst __SepContents_Tst __Sep_Dia __Sep_1_Dia __SepContents_1_Dia __Sep_2_Dia __SepContents_2_Dia __Sep_Eos __Sep_1_Eos __SepContents_1_Eos __Sep_2_Eos __SepContents_2_Eos __SepTbResPv_TLb __Sep_Xry _merge_Enr _merge_Qes _merge_Inf _merge_Tst _merge_Dia _merge_Eos _mergePrepHIV _mergePrepART _mergeHIV _mergeTBLab _mergeInclCrit _mergeExam _mergeSymptoms zwamerge1 zwamerge2 zwamerge3 zwamerge4 zwamerge5 zwamerge6 _mergeZscores _mergeTreat _mergeTAM _mergeNewTests _mergeXray

/*
describe,replace clear
list
export excel "test.xlsx", firstrow(varlabels) replace
*/
