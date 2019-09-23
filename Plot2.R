###########################################################################################
## load library
###########################################################################################

library(dplyr)
library(lubridate)

##################################################
## Download/load Dataset from URL/local.  
##################################################

dsURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dsFile <- "exdata_data_household_power_consumption.zip"

if(!file.exists(dsFile)){
    download.file(dsURL,destfile = dsFile,mode='wb')
}


##################################################
## Unzip the Dataset 
##################################################

dsFolder <-"exdata_data_household_power_consumption"

if(!file.exists(dsFolder)){
    unzip(zipfile = dsFile)
}

dsFile <- file.path(dsFolder,"household_power_consumption.txt")

##################################################
## Read the Dataset 
##################################################


hpc <- read.table(dsFile,sep=";",
                  header = TRUE,na.strings = "?",comment.char = "")


##################################################
## Filter the Dataset 
##################################################

hpc$Date <- dmy(hpc$Date)

hpc_2day_feb2007 <-filter(hpc,Date >= dmy("01/02/2007") ,
                          Date <= dmy("02/02/2007"))
hpc_2day_feb2007 <- tbl_df(hpc_2day_feb2007)


hpc_2day_feb2007 <- mutate(hpc_2day_feb2007,
                           ts=as.POSIXct(strptime(paste(Date,Time, sep = " "),
                                                  format = "%Y-%m-%d %H:%M:%S")))

rm(hpc)


##################################################
## Create the Plot 
##################################################

png(file="Plot2.png",width = 480,height = 480)
with(hpc_2day_feb2007,plot(ts,Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)"))
dev.off()