# import dataset
msg <- read.csv('/Users/maxwellthorpe/Documents/Git/GroupMe/clean_msg_data.csv', header = TRUE, na.strings=c("", "NA"))

# Install psych for describeby()
install.packages("psych")
library(psych)

# initial look at data between genders
describeBy(msg$Total.Messages, msg$Gender, IQR = TRUE, quant = c(0.25, 0.75), na.rm = TRUE)

# Is there a difference in mean total msgs between genders
t.test(msg$Total.Messages~msg$Gender,
              conf.level = 0.95, 
              mu = 0, 
              alternative = "two.sided", 
              var.equal = FALSE)

# is there a difference in mean total number of likes between genders
t.test(msg$total_likes~msg$Gender, 
       conf.level = 0.95,
       mu = 0, 
       alternative = 'two.sided',
       var.equal = FALSE)


# slr for number of msgs and gender
msg_slr <- lm(Total.Messages~Gender, data = msg)
summary(msg_slr) # results summary


# create mlr for number of msgs, likes, gender (do total msgs and gender predict total likes)
msg_mlr <- lm(total_likes ~ Total.Messages + factor(Gender), data = msg)
summary(msg_mlr) # results summary

# Diagnostics plots to check if mlr assumptions met, barely enough data to really tell so no. 
plot(msg_mlr)

# Scatter plot of mlr
plot(msg$Total.Messages, msg$total_likes,
     col = c("darkorange", "mediumturquoise")[factor(msg$Gender)], #specifies the color of the points based on the third explanatory variable
     pch = 16, # Changes the point shape in the plot
     xlab = "Total number of messages sent in chat",
     ylab = "total number of likes recieved",
     main = "Relationship between messaging & number of likes w/ gender")

legend("bottomright", 
       legend= levels(factor(msg$Gender)), # text of the legend
       fill = c("darkorange", "mediumturquoise"), # colors to use for filling the legend
       box.lty = 0, # changes the border of the legend box
       title = "Legend") # title 

# Trend lines added to plot
# Equations for the linear trend lines for each gender
# y = 39.4892 + 1.5208(x1) + 0 for Female group
abline( a = 39.4892, b = 1.5208, col = "mediumturquoise")

# y = 36.35 + 1.5208(x1) - 3.1392 for Male group
abline(a = 36.35, b = 1.5208, col = "darkorange")