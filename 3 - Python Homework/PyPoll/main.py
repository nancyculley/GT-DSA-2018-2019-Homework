# Task - analyze the votes and calculates each of the following
# A - The total number of votes cast
# B - complete list of candidates who received votes
# C - The percentage of votes each candidate won
# D - The total number of votes each candidate won
# E - The winner of the election based on popular vote
# F - Print to the terminal and export a text file with the results

import os
import csv
import numpy as np

# Set variables
total_votes = 0
candidate_votes = []
candidate_names = []
candidate_num_votes = []
pct_of_votes = []
candidate = 0
index_for_print = 0
index_for_file = 0
rows = []

# Open resource file

csv_path = os.path.join("Resources", "election_data.csv")

with open(csv_path, newline="") as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=",")
    # Skip header
    csv_header = next(csv_reader)
    # Read each row of data after the header
    for row in csv_reader:
        # A - The total number of votes cast
        total_votes = total_votes + 1
        # B - for use in list of candidates
        candidate_votes.append(row[2])


# B - complete list of candidates who received votes
for x in candidate_votes:
    if x not in candidate_names:
        candidate_names.append(x)

# C - The percentage of votes each candidate won
# D - The total number of votes each candidate won
for y in candidate_names:
    num_of_votes = candidate_votes.count(y)   
    candidate_num_votes.append(num_of_votes) # D
    pct_of_votes_calc = round((num_of_votes / total_votes) * 100,3) # C
    pct_of_votes.append(pct_of_votes_calc)

# E - The winner of the election based on popular vote.
# winning_num_votes = max(num_of_votes)
winner_name_index = np.argmax(num_of_votes)
winner_name = candidate_names[winner_name_index]


#  Election Results
#  -------------------------
#  Total Votes: 3521001
#  -------------------------
#  Khan: 63.000% (2218231)
#  Correy: 20.000% (704200)
#  Li: 14.000% (492940)
#  O'Tooley: 3.000% (105630)
#  -------------------------
#  Winner: Khan
#  -------------------------
print("************************")
print("*   ELECTION RESULTS   *")
print("************************")
print(f"Total votes: {total_votes}")
print("------------------------")
for z in candidate_names:
    print_candidate = z
    print_pct = pct_of_votes[index_for_print]
    print_num_of_votes = candidate_num_votes[index_for_print]
    print(f"{print_candidate}: {print_pct}% ({print_num_of_votes})")
    index_for_print = index_for_print + 1
print("------------------------")
print(f"Winner: {winner_name}")
print("------------------------")

# Export

header = ["Votes", "Pct", "Count", "Winner"]
row = ["Total", 100.000, total_votes, "n/a"]
for x in candidate_names:
    if x == winner_name:
        winner_col = "yes"
    else:
        winner_col = "no"
    rows_data = (candidate_names[index_for_file], pct_of_votes[index_for_file], candidate_num_votes[index_for_file], winner_col)
    rows.append(rows_data)
    index_for_file = index_for_file + 1

# write csv sample code
# Open the output file

with open("elect_results.csv", "w", newline="") as datafile:
    writer = csv.writer(datafile)
    # Write the header row
    writer.writerow(header)
    # Data
    writer.writerow(row)
    writer.writerows(rows)



