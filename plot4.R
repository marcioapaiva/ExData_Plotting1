# Reads the required data from file, making some useful type transformations
read.required.data = function() {
  # Reads lines 66638 to 69517 (inclusive), which corresponds to 2007 Feb 1 and Feb 2
  power <- read.csv("household_power_consumption.txt", sep = ";", na.strings = "?",
                    header = FALSE, nrows = 2880, skip = 66637)
  
  # Reads the header separately
  colnames(power) <- colnames(read.csv("household_power_consumption.txt", nrows = 1, sep = ";"))
  
  # Creates POSIX date from Date and Time columns
  power <- transform(power, datetime = strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))
  power <- power[,!(names(power) %in% c("Time", "Date"))]
}

power <- read.required.data()
png(file = "plot4.png", width = 480, height = 480)

# Plots will be drawn on a 2x2 matrix, filled by row
par(mfrow = c(2,2)) 

# First plot
plot(x = power$datetime,
     y = power$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power")

# Second plot
with(power, plot(
     x = datetime,
     y = Voltage,
     type = "l"))

# Third plot
plot(x = power$datetime,
     y = power$Sub_metering_1,
     type = "n",
     xlab = "",
     ylab = "Energy sub metering")
lines(x = power$datetime, y = power$Sub_metering_1, col = "black")
lines(x = power$datetime, y = power$Sub_metering_2, col = "red")
lines(x = power$datetime, y = power$Sub_metering_3, col = "blue")
legend("topright", 
       lty=c(1,1),
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n") # removes the box around the legends

# Fourth plot
with(power, plot(
  x = datetime,
  y = Global_reactive_power,
  type = "l"))

dev.off()
