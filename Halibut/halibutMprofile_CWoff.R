    incr <- 0.004; incr2 <- 0.1
    #both going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(-0.041909,-0.04,-0.02,0,0.02,0.04,0.06,0.16)
    file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    for(Mf in MfVals) {
        for(Mm in MmVals) {
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
                system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
                file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
                file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
            }
        }
        file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }
    #both going down from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(-0.041909,-0.05,-0.075,-0.10,-0.125,-0.15,0.25)
    file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    for(Mf in MfVals) {
        for(Mm in MmVals) {
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
                system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
                file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
                file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
            }
        }
        file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }
    #Female going down, Male going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min-incr,2),0.17,-1*incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(-0.041909,-0.04,-0.02,0,0.02,0.04,0.06,0.16)
    file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    for(Mf in MfVals) {
        for(Mm in MmVals) {
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
                system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
                file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
                file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
            }
        }
        file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }
    #Male going down, Female going up from min
    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))   #seq((ceiling(Mf.min*100)/100),0.25,0.005)
    MmVals <- c(-0.041909,-0.05,-0.075,-0.10,-0.125,-0.15,0.25)
    file.copy("ssMinimum.par","ss.par",overwrite=TRUE)
    for(Mf in MfVals) {
    	for(Mm in MmVals) {
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
			    system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
	    		file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
	    		file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
    		}
    	}
    	file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }




    MfVals <- c(Mf.min, seq(round(Mf.min+incr,2),0.26,incr))
    MfVals <- 0.17
    MmVals <- 0.02
    file.copy("ss_0.17_0.04.par","ss.par",overwrite=TRUE)
    for(Mf in MfVals) {
# file.copy(paste0("ss_",Mf,"_-0.175.par"),"ss.par",overwrite=TRUE)
        for(Mm in MmVals) {
            if(file.exists(paste0("Report_",Mf,"_",Mm,".sso"))) {
                #copy par file, if exists, for next run
                # if(file.exists(paste0("ss_",Mf,"_",Mm,".par"))) {
                #     file.copy(paste0("ss_",Mf,"_",Mm,".par"),"ss.par")
                # }
            } else {
                cat(Mf,Mm,"\n")
                parLines <- readLines("ss.par")
                parLines[which(parLines=="# MGparm[1]:")+1] <- Mf
                parLines[which(parLines=="# MGparm[13]:")+1] <- Mm
                writeLines(parLines,"ss.par")
                system2(command="ss_opt.exe",args="-nohess -phase 6",stdout = FALSE, stderr = FALSE,invisible=FALSE,minimized=TRUE)
                file.copy("Report.sso",paste0("Report_",Mf,"_",Mm,".sso"))
                file.copy("ss.par",paste0("ss_",Mf,"_",Mm,".par"),overwrite=TRUE)
            }
        }
        file.copy(paste0("ss_",Mf,"_",MmVals[1],".par"),"ss.par",overwrite=TRUE)
    }
