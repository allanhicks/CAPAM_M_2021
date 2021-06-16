library(HandyCode); library(r4ss)

col = c("blue4", "blueviolet", "orange", 'red')
component.labels = c( "Total",
               "Index data",
               "Length data",
               "Age data")
components = c("TOTAL", "Survey", "Length_comp", "Age_comp")

##############################################################
# Females Direct
##############################################################
dir = "C:/Assessments/2021/dover_sole_2021/models/_sensitivities"
run_name = "7.0.1_base_no_bio_offsets_est_m_profile_NatM_p_1_Fem_GP_1"
load(file.path(dir, run_name, "NatM_p_1_Fem_GP_1_profile_output.Rdat"))

mydir = profile_output$mydir
vec = profile_output$vec
para = profile_output$para
profilesummary = profile_output$profilesummary
rep = profile_output$rep
model_settings = profile_output$model_settings
get = ifelse(para == "SR_LN(R0)", "R0", para)
label = ifelse(para == "SR_LN(R0)", expression(log(italic(R)[0])),
	      ifelse(para == "NatM_p_1_Fem_GP_1", "Natural Mortality (female)",
	      ifelse(para == "NatM_p_1_Mal_GP_1", "Natural Mortality (male)",
	      ifelse(para == "SR_BH_steep", "Steepness (h)",
	      para))))
exact = FALSE  
# Set unwanted likes to 0
find = which(profilesummary$likelihoods$Label %in% c("TOTAL", "Survey", "Length_comp", "Age_comp"))
profilesummary$likelihoods = profilesummary$likelihoods[find,]
ymax1 = 25

pngfun(wd = "C:/Assessments/2021/CAPAM_M_2021/Dover/_plots", 
	file = paste0("direct_and_offset_profiles_M.png"), h= 7, w = 7)
par(mfrow = c(2,2),mar = c(5, 4, 2, 2))

r4ss::SSplotProfile(summaryoutput = profilesummary, main = "", profile.string = get, 
              profile.label = label, ymax = ymax1, exact = exact,
              legendloc = "topleft", col = col, component.labels = component.labels,
              components = components)
abline(h = 1.92, lty = 3, col = 'red') 

##############################################################
# Males Direct
##############################################################

dir = "C:/Assessments/2021/dover_sole_2021/models/_sensitivities"
run_name = "7.0.1_base_no_bio_offsets_est_m_profile_NatM_p_1_Mal_GP_1"
load(file.path(dir, run_name, "NatM_p_1_Mal_GP_1_profile_output.Rdat"))

mydir = profile_output$mydir
vec = profile_output$vec
para = profile_output$para
profilesummary = profile_output$profilesummary
rep = profile_output$rep
model_settings = profile_output$model_settings
get = ifelse(para == "SR_LN(R0)", "R0", para)
label = ifelse(para == "SR_LN(R0)", expression(log(italic(R)[0])),
	      ifelse(para == "NatM_p_1_Fem_GP_1", "Natural Mortality (female)",
	      ifelse(para == "NatM_p_1_Mal_GP_1", "Direct: Natural Mortality (male)",
	      ifelse(para == "SR_BH_steep", "Steepness (h)",
	      para))))
exact = FALSE  
# Set unwanted likes to 0
find = which(profilesummary$likelihoods$Label %in% c("TOTAL", "Survey", "Length_comp", "Age_comp"))
profilesummary$likelihoods = profilesummary$likelihoods[find,]
#ymax1 = 35
col = c("blue4", "blueviolet", 'red', "orange")
#pngfun(wd = mydir, file = paste0("piner_panel_", para, ".png"), h= 7, w = 7)
#par(mfrow = panel)

r4ss::SSplotProfile(summaryoutput = profilesummary, main = "", profile.string = get, 
              profile.label = label, ymax = ymax1, exact = exact, col = col,
              component.labels = component.labels, components = components)
abline(h = 1.92, lty = 3, col = 'red') 


##############################################################
# Females Offset
##############################################################
dir = "C:/Assessments/2021/dover_sole_2021/models"
run_name = "7.0.1_base_profile_NatM_p_1_Fem_GP_1"
load(file.path(dir, run_name, "NatM_p_1_Fem_GP_1_profile_output.Rdat"))

mydir = profile_output$mydir
vec = profile_output$vec
para = profile_output$para
profilesummary = profile_output$profilesummary
rep = profile_output$rep
model_settings = profile_output$model_settings
get = ifelse(para == "SR_LN(R0)", "R0", para)
label = ifelse(para == "SR_LN(R0)", expression(log(italic(R)[0])),
	      ifelse(para == "NatM_p_1_Fem_GP_1", "Natural Mortality (female)",
	      ifelse(para == "NatM_p_1_Mal_GP_1", "Natural Mortality (male)",
	      ifelse(para == "SR_BH_steep", "Steepness (h)",
	      para))))
exact = FALSE  
# Set unwanted likes to 0
find = which(profilesummary$likelihoods$Label %in% c("TOTAL", "Survey", "Length_comp", "Age_comp"))
profilesummary$likelihoods = profilesummary$likelihoods[find,]
#ymax1 = 35
col = c("blue4", "blueviolet", "orange", 'red')

#pngfun(wd = mydir, file = paste0("piner_panel_", para, ".png"), h= 7, w = 7)
#par(mfrow = panel)

r4ss::SSplotProfile(summaryoutput = profilesummary, main = "", profile.string = get, 
              profile.label = label, ymax = ymax1, exact = exact, col = col,
              legendloc = "topleft", component.labels = component.labels, components = components)
abline(h = 1.92, lty = 3, col = 'red') 

#dev.off() 

##############################################################
# Male Offset
##############################################################

dir = "C:/Assessments/2021/dover_sole_2021/models"
run_name = "7.0.1_base_profile_NatM_p_1_Mal_GP_1"
load(file.path(dir, run_name, "NatM_p_1_Mal_GP_1_profile_output.Rdat"))

mydir = profile_output$mydir
vec = profile_output$vec
para = profile_output$para
profilesummary = profile_output$profilesummary
rep = profile_output$rep
model_settings = profile_output$model_settings

get = ifelse(para == "SR_LN(R0)", "R0", para)
label = ifelse(para == "SR_LN(R0)", expression(log(italic(R)[0])),
	      ifelse(para == "NatM_p_1_Fem_GP_1", "Natural Mortality (female)",
	      ifelse(para == "NatM_p_1_Mal_GP_1", "Offset: Natural Mortality (male)",
	      ifelse(para == "SR_BH_steep", "Steepness (h)",
	      para))))
exact = FALSE  
# Set unwanted likes to 0
find = which(profilesummary$likelihoods$Label %in% c("TOTAL", "Survey", "Length_comp", "Age_comp"))
profilesummary$likelihoods = profilesummary$likelihoods[find,]
#ymax1 = 35
col = c("blue4", "orange", "blueviolet", 'red')
#pngfun(wd = mydir, file = paste0("piner_panel_", para, ".png"), h= 7, w = 7)
#par(mfrow = panel)

r4ss::SSplotProfile(summaryoutput = profilesummary, main = "", 
		profile.string = get, profile.label = label, ymax = ymax1, exact = exact, 
		col = col, component.labels = component.labels, components = components)
abline(h = 1.92, lty = 3, col = 'red')
dev.off()