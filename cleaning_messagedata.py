import os
import pandas as pd
import numpy as np
from dotenv import load_dotenv
load_dotenv()

# Purpose is to create a clean csv with Names (id), Gender, avg Number of messages sent, number of likes per user's average message
# To see if the average number of messages sent by a user can be predicted from the number of likes they receive and their 
# Gender


messagedata = os.environ.get('MESSAGEDATA')
df = pd.read_csv(messagedata)

# Create a dictionary that matches a persons name to their user_id
users = df.set_index('user_id')['name'].to_dict()

# Creates a new dataframe with only names and sender_id
df_groupme = pd.DataFrame.from_dict(users, orient = 'index')

# Add total number of messages to clean data
df_groupme['Total Messages'] = df['user_id'].value_counts()
df_groupme = df_groupme.reset_index() # reseting index to not include 'user_id'
df_groupme = df_groupme.rename(columns = {'index': 'user_id'}) # correcting column label

# Create dataframe with only the like columns & user_id
df_likes = df.loc[:,'fav0':'user_id']
df_likes = df_likes.replace(np.nan, 0, regex=True) # Replacing NaNs with 0

# Iteratesthrough columns and replace User_id that liked the message with int 1
for label, content in df_likes.loc[:,'fav0':'fav19'].items(): # iterates through the columns as a series
	for like in content:
		value = 1
		if like != 0:
			df_likes.replace(to_replace = like, value = value, inplace = True)
	
df_likes['total_likes'] = df_likes.loc[:,'fav0':'fav19'].sum(axis = 1) # summation of likes for a given msg

# Creates dataframe with total sum of likes on messages and user_id
df_likes_sums = df_likes.loc[:, 'user_id':'total_likes'].groupby('user_id')['total_likes'].sum()
df_groupme_merged =  pd.merge(df_likes_sums, df_groupme, on='user_id', how='inner') # inner join of dataframes on 'user_id'

# Export df as csv
df_groupme_merged.to_csv('clean_msg_data.csv')






