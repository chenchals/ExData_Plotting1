## plot3.R

# Read data should be in a separate file, instead of copying the same lines.
################ Read Data necessary for this plot ############################
# Data source: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# Download prior to analysis
# size: wc: 2075260 2075260 132960755 household_power_consumption.txt
# Columns are ";" separated
library(data.table) ## for fast read
# Date: dd/mm/yyyy Time: hh:mm:ss
# Load only data from the dates 2007-02-01 and 2007-02-02.
#value from inspecting 1st row
firstDateTime=strptime("16/12/2006 17:24:00","%d/%m/%Y %H:%M:%S")
skipTillDateTime=strptime("1/2/2007 00:00:00","%d/%m/%Y %H:%M:%S")
## 1 row per minute, add 1 for header
nRowsToSkip=difftime(skipTillDateTime,firstDateTime, units="mins")+1 
## minutes in 2 days
nRowsToRead=24*60*2 
#read header for col names, 
DT_0<-fread("data/household_power_consumption.txt", sep = ";", nrows=0) 
## read data for days; numeric not coerced due to "?" in data
DT<-fread("data/household_power_consumption.txt", sep = ";",skip=nRowsToSkip, nrows=nRowsToRead ) 
setnames(DT,names(DT),names(DT_0))
rm(DT_0)

############# Sun-Functions to create plot on Screen or Device ################
# Functions need to be declared before using

## Function: plotFig creates the plots on the device of choice
#            called by createFig function since the resolution on screen and device are different
plotFig<-function(){
  cols=c("black","red","blue")
  with(DT,plot(strptime(paste(DT$Date,DT$Time),"%d/%m/%Y %H:%M:%S"),DT[[7]], type = "n", ylab="Energy sub metering",xlab=""))
  for (i in 1:3){
    # lines for cols: 7 through 9, offset = 6, col=cols[i]
    with(DT,lines(strptime(paste(DT$Date,DT$Time),"%d/%m/%Y %H:%M:%S"),DT[[i+6]], lty=1, col=cols[i]))
  }
  legend("topright", lty=1, col=cols, legend=names(DT)[7:9])
}

## Function: createFig function calls plotFig after setting the device of choice
createFig<-function(x="screen", file){
  #default is screen
  if(x=="png"){
    png(file=file,width=480,height=480)
  }
  plotFig()
  if(x!="screen"){
    dev.off()
  }
}
################ Create plot on device (default=screen) #######################
createFig()
createFig("png",file="plot3.png")
