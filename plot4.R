## Getting and Cleaning Data, Week 1 Assignment

## Draws from UC Irvine Machine Learning Repository 
## File Electric power consumption (zipped text)
## Creates plot4.png graphic
## first requires 2x2 setup of 4 graphics with par-mfcol
## Then plots2 and 3 are recreated in the first 2 positions
## third plot is xy datetime,voltage with line
## fourth plot is xy datetime,GRP

# drawing from raw data should take no arguments
makeplot4 <- function() {
    
    #2 see plot1.R for additional notes
    #2 instructions didn't seem to leave room for dependent functioning
    #2 so they all start from scratch
    
    # <-- same as plot1.R from here to next tag Except par-mfcol is new
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
    # default is 480x480px
    

    # <-- old plot2.R content starts here
    # <-- Except plot4.png used and dev.off is skipped
    
    # first create blank plot type='n' then add lines for data, no x label
    pngfile <- png("plot4.png")
    par(mfcol=c(2,2)) # sets 2x2 to fill in order top-bottom, then left-right
    
    plot(newtable$Time,newtable$Global_active_power
         ,ylab="Global Active Power (kilowatts)",xlab="",type="n")
    lines(newtable$Time,newtable$Global_active_power)

    # <-- old plot3.R content starts here
    # <-- Except plot4.png used and dev.off is skipped
    
    # first create blank plot type='n', no xlab, Energy submetering y
    # add lines one at a time 1=black, 2=blue, 3=red
    # Then add legend with the lines, colors, and text needed, in order
#    pngfile <- png("plot4.png") # <-- png already open
    plot(newtable$Time,newtable$Sub_metering_1
         ,ylab="Energy sub metering",xlab="",type="n")
    lines(newtable$Time,newtable$Sub_metering_1)
    lines(newtable$Time,newtable$Sub_metering_2,col='blue')
    lines(newtable$Time,newtable$Sub_metering_3,col='red')
    legend('topright',lty=c(1,1,1),col=c('black','blue','red'),
           legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3')
           ,bty="n") # <-- added to eliminate legend box
    
    # <-- new plot4.R content starts here

    # next two plots same as plot2.R but with x Time as datetime 
    # and y as Voltage or GRP (to avoid $ in default)

    plot(newtable$Time,newtable$Voltage
         ,ylab="Voltage",xlab="datetime",type="n")
    lines(newtable$Time,newtable$Voltage)
    plot(newtable$Time,newtable$Global_reactive_power
         ,ylab="Global_reactive_power",xlab="datetime",type="n")
    lines(newtable$Time,newtable$Global_reactive_power)
    
    dev.off() # close file device
    # returns dev.off(), but that doesn't seem to be a problem
    
}