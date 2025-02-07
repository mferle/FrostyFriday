import requests
from bs4 import BeautifulSoup
import pandas as pd
from snowflake.snowpark.session import Session

# URL to scrape
url = "https://medium.com/snowflake/celebrating-the-2025-data-superheroes-the-innovators-trailblazers-and-changemakers-8e219e48587a"

response = requests.get(url)
response.raise_for_status()
html_content = response.text

# Parse the HTML content using BeautifulSoup
soup = BeautifulSoup(html_content, 'html.parser')

# Find the section starting from the "Americas" header
start_section = soup.find(lambda tag: tag.name in ["h1", "h2", "h3"] and "Americas" in tag.text)
content = []
for tag in start_section.find_all_next("p", attrs = {'class': 'pw-post-body-paragraph ni nj gu nk b nl oz nn no np pa nr ns nt pb nv nw nx pc nz oa ob pd od oe of gn bk'}):
    for child in tag.children: 
       line = child.text
       if len(line) == 0:
           continue
       if line[0] == ',':
           content.append(prev_line + line)
       prev_line = line

print(content)

# rearrange the content into three columns by splitting on comma
split_content = [line.split(',', 2) for line in content]

# create a data frame from the split content
df = pd.DataFrame(split_content, columns=["NAME", "TITLE", "COMPANY"])
print(df)

# connect to Snowflake
session = Session.builder.config("connection_name", "my_connection").create()
# save the data frame as a table in Snowflake
session.write_pandas(table_name = 'SUPERHEROES', database = 'DEMO_DB', schema = 'FF_SCH', df = df, auto_create_table=True, overwrite=True)
