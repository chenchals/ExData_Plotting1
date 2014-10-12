##plot1.R
# Data source: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# Download prior to analysis
# size: wc: 2075260 2075260 132960755 household_power_consumption.txt
# Columns are ";" separated
library(data.table) ## for fast read
# date is dd/mm/yyyy
# time is hh:mm:ss
# We will only be using data from the dates 2007-02-01 and 2007-02-02.
#value form 1st row
firstDateTime=strptime("16/12/2006 17:24:00","%d/%m/%Y %H:%M:%S")
skipTillDateTime=strptime("1/2/2007 00:00:00","%d/%m/%Y %H:%M:%S")
## add 1 for header
nRowsToSkip=difftime(skipTillDateTime,firstDateTime, units="mins")+1 ## obs every minute
## inclusive
nRowsToRead=1440*2 ## 1440 min in a day
#read header for col names
DT_0<-fread("data/household_power_consumption.txt", sep = ";", nrows=0) 
## numeric not coerced due to "?" in data
DT<-fread("data/household_power_consumption.txt", sep = ";",skip=nRowsToSkip, nrows=nRowsToRead ) 
setnames(DT,names(DT),names(DT_0))
rm(DT_0)
# transform data as needed use:
# DT<-DT[,Voltage:=as.numeric(Voltage)] etc
hist(DT$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)", col="red")
#copy figure to PNG device
dev.copy(png,"plot1.png",width=480,height=480)
dev.off()


