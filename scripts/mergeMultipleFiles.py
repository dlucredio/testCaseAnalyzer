import pandas as pd
import glob
import sys

args = sys.argv
input_folder = args[args.index("--input") + 1]
output_file = args[args.index("--output") + 1]

# Path where the CSV files are stored
path = input_folder + '/*.csv'

# Read all CSV files into Pandas dataframes and store them in a list
all_files = glob.glob(path)
df_list = []
for filename in all_files:
    df_list.append(pd.read_csv(filename))

# Concatenate all dataframes into one dataframe
concatenated_df = pd.concat(df_list, ignore_index=True)

# Write the concatenated dataframe to a new CSV file
concatenated_df.to_csv(output_file, index=False)
