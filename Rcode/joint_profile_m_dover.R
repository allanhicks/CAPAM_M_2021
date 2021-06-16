#################################################################
#           Joint Profile Code
#           Code from Allan Hicks
#      Adapted by Chantel Wetzel for dover 2021
#
#       Plotting Code Begins on Line 110
#
#################################################################

library(r4ss)
mydir = "C:/Assessments/2021/CAPAM_M_2021/Dover" #/_sensitivities"
#base_name = "base_with_offsets" ; offset = TRUE
#base_name = "base_no_offsets"; offset = FALSE
#base_name = "base_lorenzen_m_offset"; offset = TRUE
#base_name = "7.0.1_base_no_bio_offsets_est_m"
#base_name = "base_2011_survey_select_no_offset"; offset = FALSE
base_name = "base_w_2011_survey_select_m_offset"; offset = TRUE

para = "M"
param = c("MGparm[1]", "MGparm[13]")
# Profile range for female M
M_f <- seq(0.06, 0.14, 0.005)
M_m <- seq(0.07, 0.14, 0.005)
if (offset == TRUE) { M_m <- seq(-0.2, 0.2, 0.025) } 
# Create a grid of all possible combinations
des <- expand.grid(M_f, M_m)
names(des) <- c("M_female", "M_male")
#if(offset){
#    des$M_converted <- log(des$M_m/des$M_f)
#} else { des$M_offset = des$M_m }

# Copy base model and create folder for profile
profile_dir = file.path(mydir, paste0(base_name, "_joint_profile_", para))
dir.create(profile_dir)
all_files <- list.files(file.path(mydir, base_name))
capture.output(file.copy(from = file.path(mydir, base_name, all_files), 
              to = profile_dir, overwrite = TRUE), 
              file = "run_diag_warning.txt")
setwd(profile_dir)

# Create a matrix for output
output <- matrix(NA,
                 nrow = nrow(des) + 1, 
                 ncol = 10, 
                 dimnames = list(NULL, c("M_f", "M_m", "negLogLike", "lengthlike", "agelike", "surveylike",
                    "SB0","depletion","Bmsy","Bcurr")))

# Grab MLE values from base model
model <- r4ss::SS_output(profile_dir)
Mf.mle <- model$parameters[model$parameters$Label == "NatM_p_1_Fem_GP_1", "Value"]
Mm.mle <- model$parameters[model$parameters$Label == "NatM_p_1_Mal_GP_1", "Value"]
negloglike <- model$likelihoods_used$values[1]
lengthlike <- model$likelihoods_used$values[7]
agelike <- model$likelihoods_used$values[8]
surveylike <- model$likelihoods_used$values[4]
depletion <- model$derived_quants[model$derived_quants$Label == "Bratio_2021", "Value"] 
SB0 <- model$derived_quants[model$derived_quants$Label == "SSB_Virgin", "Value"] 
Bmsy <- model$derived_quants[model$derived_quants$Label == "SSB_Btgt", "Value"] 
SBcurr <- model$derived_quants[model$derived_quants$Label == "SSB_2021", "Value"] 
output[nrow(des) + 1,] <- unlist(c(Mf.mle, Mm.mle, negloglike, lengthlike, agelike, surveylike, SB0, depletion, Bmsy, SBcurr))
file.copy("ss.par", "ssstart.par", overwrite = TRUE)

# Turn off phase for parameters
r4ss::SS_changepars(
  dir = profile_dir, 
  ctlfile = "control.ss_new", 
  newctlfile = "control_modified.ss",
  strings = c("NatM_p_1_Fem_GP_1", "NatM_p_1_Mal_GP_1"),
  newvals = c(Mf.mle, Mm.mle), estimate = c(FALSE, FALSE))

starter <- r4ss::SS_readstarter(file.path(profile_dir, 'starter.ss'))
starter$ctlfile <- "control_modified.ss"
starter$init_values_src <- 1
# make sure the prior likelihood is calculated for non-estimated quantities
starter$prior_like <- 0
r4ss::SS_writestarter(starter, dir = profile_dir, overwrite = TRUE) 

for(i in nrow(des):1) {  #start at 113 because pretty close to MLE and ss3Base.par
    cat(i,"\n")
    flush.console()
    par = readLines("ssstart.par")
    part1 = grep(param[1], par, fixed = TRUE) + 1
    part2 = grep(param[2], par, fixed = TRUE) + 1
    par[part1] = des[i, "M_female"]
    par[part2] = des[i, "M_male"]
    writeLines(par,  paste0("ss_input_", i, ".par"))
    writeLines(par, "ss.par")
    # Run the model at the new values
    system("ss -nohess", invisible = TRUE, show.output.on.console = FALSE)
    file.copy("Report.sso", paste0("Report_", i, ".sso"), overwrite = TRUE)
    file.copy("ss.par", paste0("ss_",i,".par"), overwrite = TRUE)

    # Read profile run output
    model <- SS_output(profile_dir, printstats = FALSE, verbose = FALSE, covar = FALSE)
    negloglike <- model$likelihoods_used$values[1]
    lengthlike <- model$likelihoods_used$values[7]
    agelike <- model$likelihoods_used$values[8]
    surveylike <- model$likelihoods_used$values[4]
    depletion <- model$derived_quants[model$derived_quants$Label == "Bratio_2021", "Value"] 
    SB0 <- model$derived_quants[model$derived_quants$Label == "SSB_Virgin", "Value"] 
    Bmsy <- model$derived_quants[model$derived_quants$Label == "SSB_Btgt", "Value"] 
    SBcurr <- model$derived_quants[model$derived_quants$Label == "SSB_2021", "Value"] 
    # Add values to output matrix
    output[i,] <- unlist(c(des[i, "M_female"], des[i,"M_male"], negloglike, lengthlike, agelike, surveylike, SB0, depletion, Bmsy, SBcurr))
    #save the output at each loop so that I can analyze before it is done
    save(output, file = "output.Rdat")    
    file.copy("ss.par","ssstart.par", overwrite = TRUE)
}

###################################################################
# Plot Profile Figure using ggplot
###################################################################
library(plotly); library(stringr); library(reshape2); 
library(metR); library(ggplot2); library(HandyCode)

mydir = "C:/Assessments/2021/CAPAM_M_2021/Dover"

base_name = "base_with_offsets_joint_profile_M" ; offset = TRUE
base_name = "base_no_offsets_joint_profile_M"; offset = FALSE
#base_name = "base_lorenzen_m_offset"; offset = TRUE
#base_name = "7.0.1_base_no_bio_offsets_est_m"
#base_name = "base_2011_survey_select_no_offset"; offset = FALSE
#base_name = "base_w_2011_survey_select_m_offset"; offset = TRUE

setwd(file.path(mydir,base_name))
load("output.Rdat")

out.mle <- output[nrow(output),]
out <- as.data.frame(output[ -nrow(output), ])
out$diffNegLogLike <- out$negLogLike - min(out$negLogLike)#out.mle["negLogLike"]
out$diff_M <- out$M_f - out$M_m
out <- out[order(out$M_f, out$M_m),]

x <- unique(round(out$M_f, 4))
y <- unique(round(out$M_m, 4))
z <- matrix(out$diffNegLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

mtrx_melt <- melt(z, id.vars = c("M_f", "M_m"), measure.vars = 'Delta_NLL')
names(mtrx_melt) = c("M_f", "M_m", "Delta_NLL")

# Plot_ly figure
#plot_ly(mtrx_melt, x = ~M_f, y = ~M_m, z = ~Delta_NLL, type = 'contour', 
#        width = 600, height = 600)

#HandyCody::pngfun(wd = getwd(), file = "joint_m_profile_ggplot_large_range.png", w = 14, h = 12, pt = 12)
ggplot(mtrx_melt, aes(x = M_f, y = M_m)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0, 2, 3, 4, 6, 10, 20, 50, seq(100, 600, 100))) +
    geom_text_contour(aes(z = Delta_NLL), 
       breaks = c(2, 4, 6, seq(10, 100, 10)), size = 7, color = 'white') +
    xlab("Natural Mortality (F)") +
    ylab("Natural Mortality (M) - Offset") +
    theme(
      axis.text.y = element_text(size = 15, color = 1),
      axis.text.x = element_text(size = 15, color = 1), 
      axis.title.x = element_text(size = 20), 
      axis.title.y = element_text(size = 20),
      legend.text = element_text(size = 15), 
      legend.title = element_text(size = 15)) +
    guides(fill = guide_legend(title = "Change in NLL"))
ggsave(file.path(getwd(), "joint_m_profile_ggsave.png"), width = 14, height = 12)
#dev.off()


###############################################################################################
# Look at Age, Length, and Survey Likelihoods
###############################################################################################

out.mle <- output[nrow(output),]
out <- as.data.frame(output[ -nrow(output), ])
out$diffNegLogLike <- out$negLogLike - min(out$negLogLike)
out$diffLengthLogLike <- out$lengthlike - min(out$lengthlike)
out$diffAgeLogLike <- out$agelike - min(out$agelike)
out$diffSurveyLogLike <- out$surveylike - min(out$surveylike)

out$diff_M <- out$M_f - out$M_m
out <- out[order(out$M_f, out$M_m),]

# Length
x <- unique(round(out$M_f, 4))
y <- unique(round(out$M_m, 4))
z_length <- matrix(out$diffLengthLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

# Age
z_age <- matrix(out$diffAgeLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

# Survey
z_survey <- matrix(out$diffSurveyLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

length_melt <- melt(z_length, id.vars = c("M_f", "M_m"), measure.vars = 'Delta_NLL')
names(length_melt) = c("M_f", "M_m", "Delta_NLL")

age_melt <- melt(z_age, id.vars = c("M_f", "M_m"), measure.vars = 'Delta_NLL')
names(age_melt) = c("M_f", "M_m", "Delta_NLL")

survey_melt <- melt(z_survey, id.vars = c("M_f", "M_m"), measure.vars = 'Delta_NLL')
names(survey_melt) = c("M_f", "M_m", "Delta_NLL")

ggplot(length_melt, aes(x = M_f, y = M_m)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0, 2, 3, 4, 6, 10, 20, 50, seq(100, 600, 100))) +
    geom_text_contour(aes(z = Delta_NLL), 
       breaks = c(2, 4, 6, seq(10, 100, 10)), size = 7, color = 'white') +
    xlab("Natural Mortality (F)") +
    ylab("Natural Mortality (M)") +
    theme(
      axis.text.y = element_text(size = 15, color = 1),
      axis.text.x = element_text(size = 15, color = 1), 
      axis.title.x = element_text(size = 20), 
      axis.title.y = element_text(size = 20),
      legend.text = element_text(size = 15), 
      legend.title = element_text(size = 15)) +
    guides(fill = guide_legend(title = "Change in NLL"))
ggsave(file.path(getwd(), "length_like_joint_m_profile.png"), width = 14, height = 12)


ggplot(age_melt, aes(x = M_f, y = M_m)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0, 2, 3, 4, 6, 10, 20, 50, seq(100, 600, 100))) +
    geom_text_contour(aes(z = Delta_NLL), 
       breaks = c(2, 4, 6, seq(10, 100, 10)), size = 7, color = 'white') +
    xlab("Natural Mortality (F)") +
    ylab("Natural Mortality (M)") +
    theme(
      axis.text.y = element_text(size = 15, color = 1),
      axis.text.x = element_text(size = 15, color = 1), 
      axis.title.x = element_text(size = 20), 
      axis.title.y = element_text(size = 20),
      legend.text = element_text(size = 15), 
      legend.title = element_text(size = 15)) +
    guides(fill = guide_legend(title = "Change in NLL"))
ggsave(file.path(getwd(), "age_like_joint_m_profile.png"), width = 14, height = 12)

ggplot(survey_melt, aes(x = M_f, y = M_m)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0, 2, 3, 4, 6, 10, 20, 50, seq(100, 600, 100))) +
    geom_text_contour(aes(z = Delta_NLL), 
       breaks = c(2, 4, 6, seq(10, 100, 10)), size = 7, color = 'white') +
    xlab("Natural Mortality (F)") +
    ylab("Natural Mortality (M)") +
    theme(
      axis.text.y = element_text(size = 15, color = 1),
      axis.text.x = element_text(size = 15, color = 1), 
      axis.title.x = element_text(size = 20), 
      axis.title.y = element_text(size = 20),
      legend.text = element_text(size = 15), 
      legend.title = element_text(size = 15)) +
    guides(fill = guide_legend(title = "Change in NLL"))
ggsave(file.path(getwd(), "survey_like_joint_m_profile.png"), width = 14, height = 12)



###############################################################################################
# Plot profile using contours
###############################################################################################

out.mle <- output[nrow(output),]
out <- as.data.frame(output[ -nrow(output), ])

out$diffNegLogLike <- out$negLogLike - out.mle["negLogLike"]
#out$M_m <- round(out$M_f * exp(out$M_m),3)
out$diff_M <- out$M_f - out$M_m
out <- out[order(out$M_f, out$M_m),]
x <- unique(round(out$M_f, 4))
y <- unique(round(out$M_m, 4))
z <- matrix(out$diffNegLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

# Plot NLL Differences
pngfun(wd = getwd(), file = "joint_m_profile_orig_contour.png", w = 12, h = 12, pt = 12)
contour(x, y, z, 
    levels = c(0,2,4,5,8,seq(10, 100, 10)),
    xlim = c(0.07, 0.14), ylim = c(-.2, 0.2),
    xlab = "Female M", ylab = "Male M - Offset", cex = 1.2)
contour(x, y, z, levels = c(2), lwd = 3, add = TRUE)
dev.off()

pngfun(wd = getwd(), file = "joint_m_profile_w_depl.png", w = 12, h = 12, pt = 12)
contour(x, y, z, 
    levels = c(0,2,4,5,8,seq(10, 100, 10)),
    xlim = c(0.07, 0.14), ylim = c(-0.2, 0.2),
    xlab = "Female M", ylab = "Male M - Offset", cex = 1.2)
contour(x, y, z, levels = c(2), lwd = 3, add = TRUE)
# Plot depletion
zz <- matrix(out$depletion, 
            ncol = length(y), 
            byrow = TRUE,
            dimnames = list(as.character(x),as.character(y)))
par(new = TRUE)
contour(x, y, zz, 
        levels=c(0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95),
        method = "edge", lwd = 2, labcex = 1.1,
        col = 'darkorchid4', add = TRUE)
dev.off()



