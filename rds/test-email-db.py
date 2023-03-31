#!/usr/bin/python

import psycopg2
import os
import html
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#intialize Connection to NUll
conn = None
conn = psycopg2.connect(database="IDQD", user = "test", password = "test", host = "hostname", port = "5432")
print "Opened database successfully"
cur = conn.cursor()
cur.execute ("SELECT name, counter FROM breeding.test_email")
row = cur.fetchall()
print("| Name | Counter |")
for i in row :
    print(i)

htmlcode = html.table(rows)

htmlcode = html.table(row,
    header_row=['Name',     'Count'])
print htmlcode

conn.close()
