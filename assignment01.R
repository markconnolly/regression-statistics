# load the xlsx package to use to read an excel file
library(xlsx)

# read the file and place the specified sheet and columns in a data frame
# named dbh
# a data frame is analogous to a spreadsheet
# the <- is the standard mechanish for making an assignment in R
dbh <- read.xlsx("Excel for Example 7.81 Fall 2014.xlsx", # excel file to read
                 1,                                       # sheet to read
                 colIndex=c(1,2))                         # columns to read
# The first two arguments to the function read.xlsx are positional parameters
# and need to be in a specific order position for the correct interpretation
# by the function. Since no directory location is specified, the file will be
# looked for in the current working directory.
# colIndex is a named argument. After the positional parameters 
# have been accounted for, named parameters can be in any order.  Named parameters
# have defult values and do not need to be supplied if the default is the desired 
# value. If colIndex had been left out, the default would be to read in all columns.
# ?read.xlsx for full details

# Note that the value passed to colIndex is a vector with two elements.  The 
# function c (c for combine) is used to construct the vector.  Assignments made
# inside function calls use = as the assignment operator rather than the <- operator


# show the summary statistics of all the variables
summary(dbh)

# perform two sample t-tests on vectors of data
# each vector is a named column in the data frame
t.test(dbh$north..dbh, dbh$south..dbh)


# extra stuff
str(dbh)

head(dbh)

?"$" # quote operators when asking for help
