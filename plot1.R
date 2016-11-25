## Getting and Cleaning Data, Week 1 Assignment

## Draws from UC Irvine Machine Learning Repository 
## File Electric power consumption (zipped text)
## Creates plot1.png graphic
## Graphic provides histogram titled Global Active Power
## y = Frequency, x=GAP (kilowatts)

# drawing from raw data should take no arguments
makeplot1 <- function() {

# The instructions didn't seem to leave room to draw from a local file
# This grabs the data from the source zip, unzips, and stores date accessed
# saves to a local csv file; step is redundant but it allows commenting out download
# then use local csv for quicker testing

# comment down to 'end new download' to avoid redownloading file
rawfile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(rawfile,destfile='epc.zip',method='curl') # curl for https
dateaccessed <- date() # not used, but also not called for in assignment
rawzip <- unz('epc.zip', filename="household_power_consumption.txt")
rawtable <- read.table(rawzip,na.strings='?',sep=";",header=TRUE)
write.table(rawtable,file="epc.csv",sep=",")
# end new download

newtable <- read.csv("epc.csv")

# convert table to dates and subset for needed dates
# Format has to be little d and m for short dates, and big Y for four digit years
# time format requires big H for 24 hour time used in file
# date is added to the time colmmn because strptime requires a date portion
newtable$Time <- paste(newtable$Date,newtable$Time,sep=" ")
newtable$Time <- strptime(newtable$Time,format="%d/%m/%Y %H:%M:%S")
newtable$Date <- as.Date(newtable$Date,format="%d/%m/%Y")
newtable <- newtable[newtable$Date %in% as.Date("2007-02-01"):as.Date("2007-02-02"),]
# ps. I realize this is far from the fastest way to do it, but it's done

# now the date subset is correct, create plot and output to png device
# default is 480x480px, others also but title added
pngfile <- png("plot1.png")
par(mfcol=c(1,1)) # sets 1x1 just in case plot4.R or something else changed it.

hist(newtable$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",col="red")
dev.off() # close file device


}