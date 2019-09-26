SP500 <- read.csv(file = "C:/Users/jinyoung/Desktop/R_finance/Introduction_Quantitative_Investing/data/SP500.csv")

print(tail(SP500))

price <- SP500$Close


# Assign "gain" from the first row to the second last row

gain <- price[1:(length(price) -1)]

# "cost" from the second last row to the very last row

cost <- price[2:length(price)]

# Difference of two series divided by cost will give you daily holding return

daily.return <- (gain-cost) /cost

# Keep in mind that the return figures are in decimals, not percentages.

print(daily.return)

# Assigning probability status

probability.status <- c(0.3, 0.2, 0.4, 0.1)

# Assigning expected return status 

expected.return.status <- c(0.2, 0.1, -0.05, -0.4)

# Expected return can be calculated 
# by multiplying probability.status and expected return.status

expected.return.with.probability <- probability.status * expected.return.status

print(expected.return.with.probability)

# Finally, assign the summed value from last slide as expected.return and annualize the returns.

daily.expected.return <- ((1+daily.return)^(1/365)-1)

print(daily.expected.return)
