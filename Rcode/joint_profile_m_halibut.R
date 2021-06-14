# library(reshape2) #for melt function
library(ggplot2)
library(metR) #label contours (lots of dependencies)
# library(plotly); library(stringr); library(HandyCode)


##################################################
# FUNCTIONS
##################################################
readOutput.fn <- function(folder,offset,Mvals=NULL) {
    #Mvals is a list of list(female,male)
    #if Mvals=NULL, then determine vals from Report file names 
    folderDir <- dir(folder)
    reportNames <- folderDir[grep("Report_",folderDir)]
    reportNames <- unlist(strsplit(reportNames,"\\.sso"))
    Mf <- unique(as.numeric(unlist(lapply(strsplit(reportNames,"_"),function(x){x[2]}))))
    Mm <- unique(as.numeric(unlist(lapply(strsplit(reportNames,"_"),function(x){x[3]}))))

    # des <- expand.grid(Mf, Mm)
    # names(des) <- c("M_female", "M_male")
    Ms <- matrix(NA,nrow=length(Mf),ncol=length(Mm),dimnames=list(sort(Mf),sort(Mm)))
    output <- matrix(NA,
                 nrow = prod(dim(Ms)), #nrow(des) + 1, 
                 ncol = 10, 
                 dimnames = list(NULL, c("M_f", "M_m", "M_offset", "negLogLike","surveyLogLike","ageLogLike","SB0","depletion","Bmsy","Bcurr")))

    i <- 0
    #get values from Report
    for(ff in rownames(Ms)) {
        for(mm in colnames(Ms)) {
            if(file.exists(paste0(folder,"/Report_",ff,"_",mm,".sso"))) {
                print(paste0(folder,"/Report_",ff,"_",mm,".sso"))
                i <- i+1
                # Read profile run output
                rep <- readLines(paste0(folder,"/Report_",ff,"_",mm,".sso"),n=2000)
                negloglike <- as.numeric(scan(text=rep[grep("TOTAL",rep)],what="character",quiet=TRUE)[2])
                #these next two lines are relative to the "TOTAL" line. Make sure is correct for the model
                surveyloglike <- as.numeric(scan(text=rep[grep("TOTAL",rep)+2],what="character",quiet=TRUE)[2])
                ageloglike <- as.numeric(scan(text=rep[grep("TOTAL",rep)+3],what="character",quiet=TRUE)[2])
                depletion <- NA  #not sure how to bring in dynamic B0 right now
                SB0 <- as.numeric(scan(text=rep[grep("SSB_Virgin",rep)],what="character",quiet=TRUE)[2])
                Bmsy <- as.numeric(scan(text=rep[grep("SSB_Btgt",rep)],what="character",quiet=TRUE)[2])
                SBcurr <- as.numeric(scan(text=rep[grep("SSB_2021",rep)],what="character",quiet=TRUE)[2])

                # model <- SS_output(profile_dir, printstats = FALSE, verbose = FALSE, covar = FALSE)
                # negloglike <- model$likelihoods_used$values[1]
                # depletion <- model$derived_quants[model$derived_quants$Label == "Bratio_2021", "Value"] 
                # SB0 <- model$derived_quants[model$derived_quants$Label == "SSB_Virgin", "Value"] 
                # Bmsy <- model$derived_quants[model$derived_quants$Label == "SSB_Btgt", "Value"] 
                # SBcurr <- model$derived_quants[model$derived_quants$Label == "SSB_2021", "Value"] 
                # Add values to output matrix
                if(!offset){
                    Moffset <- log(as.numeric(mm)/as.numeric(ff))
                } else { 
                    Moffset = as.numeric(mm)
                    mm <- exp(Moffset)*as.numeric(ff)
                }
                output[i,] <- unlist(c(as.numeric(ff), as.numeric(mm), Moffset, negloglike, surveyloglike, ageloglike, SB0, depletion, Bmsy, SBcurr))

                Ms[ff,mm] <- negloglike
            }
        }
    }
    save(output, file = "output.Rdat")    
    return(Ms)
}





###################################################################
# Plot Profile Figure using ggplot
###################################################################

mydir = "F:/IPHC/Assessment/2020/Mprofile"
# mydir = "C:/IPHC/OneDrive - International Pacific Halibut Commission/Meetings/Other/CAPAM/2021_M/halibut"
model_name = "lcw 19_base2020"; offset<-F
runFolder <- file.path(mydir,model_name)

#run this function if output.Rdat is not created
# likeCW <- readOutput.fn(runFolder,offset=offset)

setwd(runFolder)
load("output.Rdat")

tmp <- out$negLogLike
tmp <- out$surveyLogLike
tmp <- out$ageLogLike
out <- as.data.frame(output)
out$diffNegLogLike <- tmp - min(tmp)
out$diff_M <- out$M_f - out$M_m
out <- out[order(out$M_f, out$M_m),]

x <- unique(round(out$M_f, 4))
if(!offset) y <- unique(round(out$M_m, 4))
if(offset) y <- unique(round(out$M_offset, 4))
z <- matrix(out$diffNegLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))

# mtrx_melt <- melt(z, id.vars = c("M_f", "M_m"), measure.vars = 'Delta_NLL')
# names(mtrx_melt) = c("M_f", "M_m", "Delta_NLL")
minMf <- 0.181
mtrx_NoMelt <- out[out$M_f>=minMf,c("M_f","M_m","diffNegLogLike")]
names(mtrx_NoMelt) = c("M_f", "M_m", "Delta_NLL")

# contour(as.numeric(rownames(z)),as.numeric(colnames(z)),z,levels=c(0.5,1,2,3,5,10),xlab="Female M",ylab="Male M")

# Plot_ly figure
# plot_ly(mtrx_melt, x = ~M_f, y = ~M_m, z = ~Delta_NLL, type = 'contour', 
#         width = 600, height = 600)

# pngfun(wd = getwd(), file = "joint_m_profile_ggplot.png", w = 12, h = 12, pt = 12)
ggplot(mtrx_NoMelt, aes(x = M_f, y = M_m)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0, 2, 3, 4, 6, 10, seq(20,200, 20))) +
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
# ggsave("C:/GitHub/CAPAM_M_2021/Figures/joint_m_profile_direct_halibut.png", width = 14, height = 12)
# ggsave("C:/GitHub/CAPAM_M_2021/Figures/joint_m_profileSurvey_direct_halibut.png", width = 14, height = 12)
# ggsave("C:/GitHub/CAPAM_M_2021/Figures/joint_m_profileAge_direct_halibut.png", width = 14, height = 12)
# dev.off()
Mms <- diffMs <- rep(NA,nrow(z))
for(ff in 1:nrow(z)) {
    tmp <- z[ff,]
    opt <- which(tmp==min(tmp))
    Mms[ff] <- as.numeric(y[opt])
    diffMs[ff] <- as.numeric(x[ff])-Mms[ff]
}
plot(as.numeric(x),Mms)
abline(a=0,b=1)
plot(as.numeric(x),diffMs)



model_name <- "lcw_offset 19_base2020"; offset<-T
runFolder <- file.path(mydir,model_name)
#run this function if output.Rdat is not created
# likeCW <- readOutput.fn(runFolder,offset=offset)
setwd(runFolder)
load("output.Rdat")

# out.mle <- output[nrow(output),]
tmp <- out$negLogLike
# tmp <- out$surveyLogLike
# tmp <- out$ageLogLike
out <- as.data.frame(output)
out$diffNegLogLike <- out$negLogLike - min(out$negLogLike)#out.mle["negLogLike"]
out$diff_M <- out$M_f - out$M_m
out <- out[order(out$M_f, out$M_m),]
x <- unique(round(out$M_f, 4))
if(!offset) y <- unique(round(out$M_m, 4))
if(offset) y <- unique(round(out$M_offset, 4))
z <- matrix(out$diffNegLogLike, 
            ncol = length(y),
            byrow = TRUE, 
            dimnames = list(as.character(x), as.character(y)))
mtrx_NoMelt <- out[,c("M_f","M_offset","diffNegLogLike")]
names(mtrx_NoMelt) = c("M_f", "M_offset", "Delta_NLL")

# contour(as.numeric(rownames(z)),as.numeric(colnames(z)),z,levels=c(0.5,1,2,3,5,10),xlab="Female M",ylab="Male M")
ggplot(mtrx_NoMelt, aes(x = M_f, y = M_offset)) +
    geom_contour_filled(aes(z = Delta_NLL), breaks = c(0,0.5, 1, 2, 3, 4, 6, 10, seq(20,200, 20))) +
    geom_text_contour(aes(z = Delta_NLL), 
       breaks = c(1,2, 3, 6, seq(10, 100, 10)), size = 5, color = 'white') +
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
 # ggsave("C:/GitHub/CAPAM_M_2021/Figures/joint_m_profile_offset_halibut.png", width = 14, height = 12)

#find optimum M_m given M_f
Mms <- diffMs <- rep(NA,nrow(z))
for(ff in 1:nrow(z)) {
    tmp <- z[ff,]
    opt <- which(tmp==min(tmp))
    Mms[ff] <- as.numeric(x[ff]) * exp(as.numeric(y[opt]))
    diffMs[ff] <- as.numeric(x[ff])-Mms[ff]
}
plot(as.numeric(x),Mms)
abline(a=0,b=1)
plot(as.numeric(x),diffMs)
