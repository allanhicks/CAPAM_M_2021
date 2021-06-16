
devtools::load_all("C:/Users/Chantel.Wetzel/Documents/GitHub/nwfscDiag")
#library(nwfscDiag)

#######################################################################################################
# Dover sole Profiling Script
#######################################################################################################

mydir = "C:/Assessments/2021/CAPAM_M_2021/Dover"
#base_name = "base_with_offsets" ; offset = TRUE
base_name = "base_no_offsets"

mydir = "C:/Assessments/2021/dover_sole_2021/models/_sensitivities"
base_name = "7.0.1_base_est_m"


get = get_settings_profile( parameters =  c("NatM_p_1_Mal_GP_1"),
							low =  c(0.06),
							high = c(0.14),
							step_size = c(0.01),
							param_space = c('real'))


model_settings = get_settings(settings = list(base_name = base_name,
											  run = "profile",
											  profile_details = get))

run_diagnostics(mydir = mydir, model_settings = model_settings)


