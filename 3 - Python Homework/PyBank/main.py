# Task - analyzing the financial records in budget_data.csv (`Date` and `Profit/Losses`): 
# A - The total number of months included in the dataset
# B - The net total amount of "Profit/Losses" over the entire period
# C - The average of the changes in "Profit/Losses" over the entire period
# D - The greatest increase in profits (date and amount) over the entire period
# E - The greatest decrease in losses (date and amount) over the entire period
# F - Print to the terminal and export a text file with the results

# ***************************************************************************************

# Get file budget_data.csv
import os
import csv
import numpy as np

# Setting up variables
total_months = 0
one_month_change = 0
net_profits = 0
prior_row = 0
current_row = 0
change = 0
profits_losses = []
dates = []
monthly_change = [] 
avg_change = 0
max_change = 0

# Setting up average function
def average(numbers):
    length = len(numbers)
    total = 0.0
    for number in numbers:
        total += number
    return round(total / length,2)

# Bringing in CSV file and updating new lists above

csv_path = os.path.join("Resources", "budget_data.csv")

with open(csv_path, newline="") as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=",")
    # Skip header
    csv_header = next(csv_reader)
    # Read each row of data after the header
    for row in csv_reader:
        # A - Total number of months included - count rows of dataset
        total_months = total_months + 1 
        dates.append(row[0])
        profits_losses.append(int(row[1]))

        # Setting monthly change
        current_row = int(row[1])
        change = current_row - prior_row
        prior_row = current_row
        monthly_change.append(change)
    # Out of loop
    monthly_change[0] = "n/a"

# B - Net total amount of "Profit/Losses" - sum "Profit/Losses" column
net_profits = sum(profits_losses)

# C - Avg of the changes in "Profit/Losses"
avg_change = average(monthly_change[1:])

# D - Greatest increase in profits (date and amount) over the entire period - index from list in D and use some location for date
max_change = max(monthly_change[1:])
max_index = np.argmax(monthly_change[1:])
max_date = dates[max_index+1]

# E - The greatest decrease in losses (date and amount) over the entire period - index from list in D and use some location for date
min_change = min(monthly_change[1:])
min_index = np.argmin(monthly_change[1:])
min_date = dates[min_index+1]


# F - Print to the terminal and export a text file with the results

print("**********************")
print("* FINANCIAL ANALYSIS *")
print("**********************")
print(f"Total months: {total_months}")
print(f"Total: ${net_profits}")
print(f"Average change: ${avg_change}")
print(f"Greatest increase in profits: {max_date} (${max_change})")
print(f"Greatest decrease in profits: {min_date} (${min_change})")

# Export

header = ["Total months", "Total", "Average Change", "Greatest increase", "Greatest decrease"]
row = [total_months, net_profits, avg_change, str(max_date) + " " + str(max_change), str(min_date) + " " + str(min_change)]

# write csv sample code
# Open the output file

with open("financial_analysis.csv", "w", newline="") as datafile:
    writer = csv.writer(datafile)
    # Write the header row
    writer.writerow(header)
    # Data
    writer.writerow(row)