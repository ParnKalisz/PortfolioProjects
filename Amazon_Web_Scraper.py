#Import libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime

#Connect to Website

URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8'

headers =  {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36", "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8", "DNT":"1", "Connection":"close", "Upgrade-Insecure-Requests":"1"}

page = requests.get(URL, headers=headers)

Soup1 = BeautifulSoup(page.content, "html.parser")

#print(Soup1)

Soup2 = BeautifulSoup(Soup1.prettify(), "html.parser")

#print(Soup2)

Title = Soup2.find(id = 'productTitle').get_text()

Price = Soup2.find(id='priceblock_ourprice').get_text()

print(Title)
print(Price)

#There is a possibility there will be an error, the product is out of stock

# Clean up the data a little bit

Price = Price.strip()[1:]
Title = Title.strip()

print(Title)
print(Price)

# Create CSV and write headers and data into the file

import csv

Header = ['Product', 'Price', 'Date']
Data = [Title, Price, Today]

with open('AmazonWebScraperDataset.csv', 'w', newline='', encoding='UTF8') as f:
    Writer = csv.Writer(f)
    Writer.writerow(Header)
    Writer.writerow(Data)

# Create a Timestamp for your output to track when data was collected

import datetime

Today = datetime.date.today()

print(Today)


def Check_price():
    URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8'

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        "DNT": "1", "Connection": "close", "Upgrade-Insecure-Requests": "1"}

    page = requests.get(URL, headers=headers)

    Soup1 = BeautifulSoup(page.content, "html.parser")

    # print(Soup1)

    Soup2 = BeautifulSoup(Soup1.prettify(), "html.parser")

    # print(Soup2)

    Title = Soup2.find(id='productTitle').get_text()

    Price = Soup2.find(id='priceblock_ourprice').get_text()

    Price = Price.strip()[1:]
    Title = Title.strip()

    import datetime

    Today = datetime.date.today()

    import csv

    Header = ['Product', 'Price', 'Date']
    Data = [Title, Price, Today]

    with open('AmazonWebScraperDataset.csv', 'w', newline='', encoding='UTF8') as f:
        Writer = csv.Writer(f)
        Writer.writerow(Header)

# Runs check_price after a set time and inputs data into CSV

while(True):
    check_price()
    time.sleep(86400)

import pandas as pd

df = pd.read_csv(r'PATH...')

print(df)


# If I want to try sending to myself an email (just for fun) when a price hits below a certain level
# out with this script

def send_mail():
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    # server.starttls()
    server.ehlo()
    server.login('EMAIL ADDRESS', 'xxxxxxxxxxxxxx')

    subject = "The Shirt is below 15$"
    body = "BUY IT HERE!: https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data+analyst+tshirt&qid=1626655184&sr=8-3"

    msg = f"Subject: {subject}\n\n{body}"

    server.sendmail(
        'EMAIL ADDRESS',
        msg