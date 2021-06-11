
#look at bivariate M profile for Pacific halibut assessment
#TURNED OFF PRIOR SO LIKELIHOODS ARE NOT THE SAME AS ASSESSMENT

#copy assessment files over, and
#make a file ssMinimum.par from ss.par
#Note that this will change the copied assessment files, so don't use originals

# install.packages("remotes")
# remotes::install_github("allanhicks/r4ss")
# remotes::install_github("r4ss/r4ss")

library(r4ss)

minimize.fn <- function(MfVals,MmVals,copyMinPar=T,deleteReports=F) {
    if(copyMinPar) {
        file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    }
    for(Mf in MfVals) {
        print(dir)
        for(Mm in MmVals) {
            if(deleteReports) {
                if(file.exists(paste0("Report_",Mf,"_",Mm,".sso"))) {
                    file.remove(paste0("Report_",Mf,"_",Mm,".sso"))
                }
            }
            if(file.exists(paste0("Report_",Mf,"_",Mm,".sso"))) {
                #copy par file, if exists, for next run
                if(file.exists(paste0("ss_",Mf,"_",Mm,".par"))) {
                    file.copy(paste0("ss_",Mf,"_",Mm,".par"),"ss.par")
                }
            } else {
                cat(Mf,Mm,"\n")
                parLines <- readLines("ss.par")
                parLines[which(parLines=="# MGparm[1]:")+1] <- Mf
                parLines[which(parLines=="# MGparm[13]:")+1] <- Mm
                writeLines(parLines,"ss.par")
                system2(command="ss_opt.exe",args="-nohess -nox -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
                file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
                file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
            }
        }
        file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }
}


readResults.fn <- function(folder,Mvals=NULL) {
    #Mvals is a list of list(female,male)
    #if Mvals=NULL, then determine vals from Report file names 
    folderDir <- dir(folder)
    reportNames <- folderDir[grep("Report_",folderDir)]
    reportNames <- unlist(strsplit(reportNames,"\\.sso"))
    Mf <- unique(as.numeric(unlist(lapply(strsplit(reportNames,"_"),function(x){x[2]}))))
    Mm <- unique(as.numeric(unlist(lapply(strsplit(reportNames,"_"),function(x){x[3]}))))

    Ms <- matrix(NA,nrow=length(Mf),ncol=length(Mm),dimnames=list(sort(Mf),sort(Mm)))

#get likelhood from Report
    for(ff in rownames(Ms)) {
        for(mm in colnames(Ms)) {
            if(file.exists(paste0(folder,"/Report_",ff,"_",mm,".sso"))) {
                rep <- readLines(paste0(folder,"/Report_",ff,"_",mm,".sso"),n=1000)
                Ms[ff,mm] <- as.numeric(scan(text=rep[grep("TOTAL",rep)],what="character",quiet=TRUE)[2])
            }
        }
    }
    return(Ms)
}



ssFiles = c("starter.ss","halibut.dat","halibut.ctl","forecast.ss","wtatage.ss","ss.par","Report.sso")


out <- vector(mode="list",length=4)
names(out) <- c("lcw","laaf","lcw_offset","laaf_offset")

# topDir <- "C:/IPHC/OneDrive - International Pacific Halibut Commission/Assessment/2019/Mprofile"
# topDir <- "F:/IPHC/Assessment/2019/Mprofile"
topDir <- "F:/IPHC/Assessment/2020/Mprofile"
# for(mod in 1:length(out)) {



mod <- 3 # 1 #or 2 or 3
	dir <- paste(names(out)[mod],"19_base2020")
	print(dir)
	setwd(file.path(topDir,dir))

	#set the natural mortality parameters to not be estimated in the control file
	ctlFile <- readLines("halibut.ctl")
	ind <- which(ctlFile == "# Female natural mortality")
	tmp <- scan(text=ctlFile[ind+1],what="character")
	tmp[7] <- as.character(-1 * abs(as.numeric(tmp[7])))
	ctlFile[ind+1] <- paste(tmp,collapse=" ")
	ind <- which(ctlFile == "# Male natural mortality")
	tmp <- scan(text=ctlFile[ind+1],what="character")
	tmp[7] <- as.character(-1 * abs(as.numeric(tmp[7])))
	ctlFile[ind+1] <- paste(tmp,collapse=" ")
	writeLines(ctlFile, "halibut.ctl")

	#set the starter file to read the par values and not jitter
	starter <- SS_readstarter("starter.ss",verbose=FALSE)
    starter$init_values_src <- 1       #read from par
    starter$N_bootstraps <- 0          #no extra writing of stuff
    starter$jitter_fraction <- 0       #no jitter of pars
    starter$converge_criterion <- 0.001
    SS_writestarter(starter, dir = getwd(), file = "starter.ss", overwrite = TRUE, verbose = FALSE, warn = FALSE)


    #first run SS from par file to get minimum
    file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    system2(command="ss_opt.exe",args="-nohess -nox",stdout = FALSE, stderr = FALSE, minimized=FALSE,invisible=FALSE)

    #determine M values at minimum
	model <- SS_output(getwd(),verbose=F,covar=F,printstats=F)
    Mf.min <- model$parameters["NatM_p_1_Fem_GP_1","Value"]
    Mm.min <- model$parameters["NatM_p_1_Mal_GP_1","Value"]
    #read a bunch of output
    file.copy("Report.sso",paste0("Report_",Mf.min,"_",Mm.min,".sso"))

    #set new M values in par file and run to get likelihood
    incr <- 0.002
    #both going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),0.26,incr))
    #both going down from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min-incr,2),0.17,-1*incr))
    #Female going down, Male going up from min
    MfVals <- seq(round(Mf.min-incr,2),0.17,-1*incr)   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- seq(round(Mm.min+incr,2),0.25,incr)
    #Male going down, Female going up from min
    MfVals <- seq(round(Mf.min+incr,2),0.25,incr)   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- seq(round(Mm.min-incr,2),0.17,-1*incr)

    ### MODEL 2
    incr <- 0.0025
    #both going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.21,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),0.18,incr))
    #both going down from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.13,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min-incr,2),0.15,-1*incr))
    #Female going down, Male going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.13,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),0.18,incr))
    #Female going up, male going down from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.21,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min-incr,2),0.15,-1*incr))

    #Model 3: coastwide long offset
    #set new M values in par file and run to get likelihood
    incr <- 0.004; incr2 <- 0.03
    #both going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),0.2,incr2))
    #both going down from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),-0.2,-1*incr2))
    #Female going down, Male going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),0.2,incr2))
    #Male going down, Female going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(Mm.min, seq(round(Mm.min+incr,2),-0.2,-1*incr2))

minimize.fn(MfVals,MmVals,copyMinPar=T,deleteReports=F)
# minimize.fn(MfVals,MmVals,copyMinPar=F,deleteReports=T)

    
    # #Model (coastwide short)
    # incr <- 0.0025
    # #both going up from min
    # MfVals <- seq(round(Mf.min+incr,2),0.2,incr)   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    # MmVals <- seq(round(Mm.min+incr,2),0.2,incr)
    # #both going down from min
    # MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.13,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    # MmVals <- c(Mm.min, seq(round(Mm.min-incr,2),0.13,-1*incr))
    # #coastwide short started producing nan at female M's greater than 0.16, even though likelihood was best around there. Good reason to fix M


    ### lcw
    # MfVals <- seq(0.205,0.217,incr)
    # MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    ###
    # MfVals <- seq(0.219,0.229,incr)
    # MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    ###
    # MfVals <- seq(0.217,0.205,-1*0.002)
    # MmVals <- seq(0.215,0.25,0.005)
    ###
    # MfVals <- seq(0.219,0.229,0.002)
    # MmVals <- seq(0.215,0.25,0.005)
    ###
    # MfVals <- Mf.min
    # MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    ###
    # MfVals <- Mf.min
    # MmVals <- seq(0.215,0.25,0.005)
    ###
    # MfVals <- seq(0.217,0.205,-1*0.002)
    # MmVals <- Mm.min
    ###
    # MfVals <- seq(0.219,0.229,0.002)
    # MmVals <- Mm.min
    ### 
    MfVals <- seq(0.231,0.265,0.002)
    MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    file.copy(paste0("ss_",0.245,"_",0.1625,".par"),"ss.par",overwrite=TRUE)
    ### 
    # MfVals <- seq(0.231,0.245,0.002)
    # MmVals <- c(Mm.min,seq(0.215,0.25,0.005))
    # file.copy(paste0("ss_",0.229,"_",Mm.min,".par"),"ss.par",overwrite=TRUE)
    ### 
    MfVals <- seq(0.201,0.161,-0.004)
    MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2,Mm.min,seq(0.215,0.25,0.005))
    file.copy(paste0("ss_",0.205,"_",0.1625,".par"),"ss.par",overwrite=TRUE)

    MfVals <- c(0.181,0.177,0.173,0.169,0.165,0.161)
    MmVals <- 0.255
    file.copy(paste0("ss_",0.185,"_",0.255,".par"),"ss.par",overwrite=TRUE)

    MfVals <- 0.227
    MmVals <- 0.2
    file.copy(paste0("ss_",0.225,"_",Mm.min,".par"),"ss.par",overwrite=TRUE)


    ### laaf
    # MfVals <- seq(0.1775,0.2025,0.0025)  #seq(0.1775,0.217,incr)
    # MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    ###
    # MfVals <- seq(0.175,0.13,-1*0.0025)
    # MmVals <- c(0.1625,0.165,0.1675,0.17,0.1725,0.175,0.1775,0.18,0.185,0.19,0.195,0.2)
    ###
    # MfVals <- seq(0.1775,0.2025,0.0025)
    # MmVals <- seq(0.160,0.13,-1*0.005)
    ###
    # MfVals <- seq(0.175,0.13,-1*0.0025)
    # MmVals <- seq(0.160,0.13,-1*0.005)
    # ###
    # MfVals <- seq(0.1775,0.2025,0.0025)
    # MmVals <- Mm.min
    # ###
    # MfVals <- seq(0.175,0.13,-1*0.0025)
    # MmVals <- Mm.min
    ###
    MfVals <- Mf.min
    MmVals <- seq(0.16,0.13,-0.005)

    MfVals <- 0.15 #seq(0.175,0.13,-1*0.0025)
    # MfVals <- seq(0.1575,0.1525,-0.0005)
    # MmVals <- 0.15
    MmVals <- 0.1525  #c(0.145,0.14,0.135,0.13)
    file.copy(paste0("ss_",0.15,"_",0.15,".par"),"ss.par",overwrite=TRUE)


minimize.fn(MfVals,MmVals,copyMinPar=T,deleteReports=F)
# minimize.fn(MfVals,MmVals,copyMinPar=F,deleteReports=T)


##################
### CW (model 1)
# likeCW <- readResults.fn(folder="C:/IPHC/OneDrive - International Pacific Halibut Commission/Assessment/2019/Mprofile/coastwide long/25_base_2019")
# likeCW <- readResults.fn(folder="F:/IPHC/Assessment/2019/Mprofile/coastwide long/25_base_2019")
likeCW <- readResults.fn(folder="F:/IPHC/Assessment/2020/Mprofile/lcw 19_base2020")
diffLikeCW <- likeCW-min(likeCW,na.rm=T)
diffLikeCW <- diffLikeCW[-(2:6),]
par(mfrow=c(1,1))
contour(as.numeric(rownames(diffLikeCW)),as.numeric(colnames(diffLikeCW)),diffLikeCW,levels=c(0.5,1,2,3,5,10),xlab="Female M",ylab="Male M")

par(mfrow=c(4,6))
for(i in 1:ncol(diffLikeCW)) {
    plot(as.numeric(rownames(diffLikeCW)),diffLikeCW[,i],type="b",main=colnames(diffLikeCW)[i],ylim=c(0,10))
}
par(mfrow=c(3,5))
for(i in nrow(diffLikeCW)) {
    plot(as.numeric(colnames(diffLikeCW)),diffLikeCW[i,],type="b",main=rownames(diffLikeCW)[i])
}

par(mfrow=c(1,1))
plot(1,1,xlim=c(0.1,0.3),ylim=c(0,30),xlab="Male M",ylab="Difference from Minimum")
for(i in 1:nrow(diffLikeCW)) {
    points(as.numeric(colnames(diffLikeCW)),diffLikeCW[i,],type="l")
}

##################
### CWoffset (model 3)
likeCWoff <- readResults.fn(folder="F:/IPHC/Assessment/2020/Mprofile/lcw_offset 19_base2020")
diffLikeCWoff <- likeCWoff-min(likeCWoff,na.rm=T)
par(mfrow=c(1,1))
contour(as.numeric(rownames(diffLikeCWoff)),as.numeric(colnames(diffLikeCWoff)),diffLikeCWoff,levels=c(0.5,1,2,3,5,10),xlab="Female M",ylab="Male M offset")

MmOffVal <- as.numeric(colnames(likeCWoff))

plot(1,1,xlim=c(0.1,0.3),ylim=c(0,30),xlab="Male M",ylab="Difference from Minimum")
for(i in 1:nrow(diffLikeCWoff)) {
    MfRealVal <- as.numeric(rownames(diffLikeCWoff)[i])
    MmRealVal <- MfRealVal * exp(MmOffVal)
    points(MmRealVal, diffLikeCWoff[i,],type="l")
}


##################
### AAF (model 2)
likeAAF <- readResults.fn(folder="F:/IPHC/Assessment/2020/Mprofile/laaf 19_base2020")
diffLikeAAF <- likeAAF-min(likeAAF,na.rm=T)
par(mfrow=c(1,1))
contour(as.numeric(rownames(diffLikeAAF)),as.numeric(colnames(diffLikeAAF)),diffLikeAAF,levels=c(1,2,3,5,10,25,50,100))

# likeAAFd <- readResults.fn(folder="C:/IPHC/OneDrive - International Pacific Halibut Commission/Assessment/2019/Mprofile/AAF long detail/25_base_2019")
# likeAAFd <- readResults.fn(folder="C:/IPHC/OneDrive - International Pacific Halibut Commission/Assessment/2019/Mprofile/AAF long detail/25_base_2019")
# diffLikeAAFd <- likeAAFd-min(likeAAFd,na.rm=T)
# diffLikeAAFd <- diffLikeAAFd[,-which(colnames(diffLikeAAFd)=="0.16")]
# diffLikeAAFd <- diffLikeAAFd[-which(rownames(diffLikeAAFd)=="0.1675"),]
# par(mfrow=c(1,1))
# contour(as.numeric(rownames(diffLikeAAFd)),as.numeric(colnames(diffLikeAAFd)),diffLikeAAFd,levels=c(0.5,1,2,3,5,10,30))

# plot(as.numeric(colnames(diffLikeAAFd)),diffLikeAAFd["0.2",],type="b")
# plot(as.numeric(rownames(diffLikeAAFd)),diffLikeAAFd[,1],type="b")
par(mfrow=c(4,6))
for(i in 1:23) {
    plot(as.numeric(rownames(diffLikeAAF)),diffLikeAAF[,i],type="b",main=colnames(diffLikeAAF)[i],ylim=c(0,10))
}
par(mfrow=c(4,6))
for(i in 6:(6+23)) {
    plot(as.numeric(colnames(diffLikeAAFd)),diffLikeAAFd[i,],type="b",main=rownames(diffLikeAAFd)[i],ylim=c(0,10))
}

i <- which(rownames(diffLikeAAF) == "0.15")
plot(as.numeric(colnames(diffLikeAAF)),diffLikeAAF[i,],type="b",main=paste0("Mf=",rownames(diffLikeAAF)[i]),ylim=c(0,10))

likeCWoff <- readResults.fn(folder="F:/IPHC/Assessment/2019/Mprofile/coastwide long offset/25_base_2019")
diffLikeCWoff <- likeCWoff-min(likeCWoff,na.rm=T)
par(mfrow=c(1,1))
contour(as.numeric(rownames(diffLikeCWoff)),exp(as.numeric(colnames(diffLikeCWoff))),diffLikeCWoff,levels=c(0.5,1,2,3,5,10,30))

incr <- 0.004
Mf.min <- 0.216527
MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr), seq(round(Mf.min+incr,2),0.26,incr))
MfVals <- as.character(sort(unique(MfVals)))
likeCWoffSm <- likeCWoff[MfVals,]
diffLikeCWoff <- likeCWoffSm-min(likeCWoffSm,na.rm=T)
par(mfrow=c(1,1))
contour(as.numeric(rownames(diffLikeCWoff)),exp(as.numeric(colnames(diffLikeCWoff))),diffLikeCWoff,levels=c(0.5,1,2,3,5,10,30))

plot(as.numeric(colnames(diffLikeCWoff)),diffLikeCWoff["0.228",],type="b")
plot(as.numeric(rownames(diffLikeCWoff)),diffLikeCWoff[,"0.16"],type="b")
par(mfrow=c(4,5))
for(i in 1:20) {
    plot(as.numeric(rownames(diffLikeCWoff)),diffLikeCWoff[,i],type="b",main=colnames(diffLikeCWoff)[i],ylim=c(0,30))
}
par(mfrow=c(4,6))
for(i in 6:(6+23)) {
    plot(as.numeric(colnames(diffLikeCWoff)),diffLikeCWoff[i,],type="b",main=rownames(diffLikeCWoff)[i],ylim=c(0,10))
}



#do some fill in going along the Mf axis
    ### MODEL 3
    incr <- 0.0025
    MmVals <- c(Mm.min,seq(0.16,0.18,incr))
    MfVals <- seq(0.17,0.13,-1*incr)
    file.copy("ss_0.1675_0.1625.par","ss.par",overwrite=TRUE)
    #
    incr <- 0.0025
    MmVals <- seq(0.1575,0.15,-1*incr)
    MfVals <- c(Mf.min,seq(0.17,0.13,-1*incr))
    file.copy("ss_0.177264_0.1575.par","ss.par",overwrite=TRUE)
    #
    incr <- 0.0025
    MmVals <- c(Mm.min,seq(0.16,0.18,incr))
    MfVals <- seq(0.18,0.21,incr)
    file.copy("ss_0.18_0.159574.par","ss.par",overwrite=TRUE)
    #
    incr <- 0.0025
    MmVals <- seq(0.1575,0.15,-1*incr)
    MfVals <- seq(0.1825,0.21,-1*incr)
    file.copy("ss_0.18_0.1575.par","ss.par",overwrite=TRUE)

	file.copy("ss_0.185_0.1625.par","ss.par",overwrite=TRUE)
	Mm <- 0.1625
	MfVals <- c(0.1825)

  #  	for(Mm in MmVals) {
		# print(dir)
	    # file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
	    for(Mf in MfVals) {
    		if(file.exists(paste0("Report_",Mf,"_",Mm,".sso"))) {
    			#copy par file, if exists, for next run
    			# if(file.exists(paste0("ss_",Mf,"_",Mm,".par"))) {
    			# 	file.copy(paste0("ss_",Mf,"_",Mm,".par"),"ss.par")
    			# }
    		} else {
    			cat(Mf,Mm,"\n")
				parLines <- readLines("ss.par")
				parLines[which(parLines=="# MGparm[1]:")+1] <- Mf
				parLines[which(parLines=="# MGparm[13]:")+1] <- Mm
				writeLines(parLines,"ss.par")
			    system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE)
	    		file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
	    		file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=T)
    		}
    	}
    # }

















likeCWsh <- readResults.fn(folder="C:/IPHC/OneDrive - International Pacific Halibut Commission/Assessment/2019/Mprofile/coastwide short/25_base_2019")
diffLikeCWsh <- likeCWsh-min(likeCWsh,na.rm=T)
contour(as.numeric(rownames(diffLikeCWsh)),as.numeric(colnames(diffLikeCWsh)),diffLikeCWsh,levels=c(1,2,3,5,10))
