import whois
import os
import csv
import sys
from time import sleep

'''
The script takes and input file and an ouput file,
if the output file does not exist it will create it,
if the input file is there, this will not work for obvious reasons
'''

domain_list_file = sys.argv[1]
domain_list_output = sys.argv[2]

if not os.path.exists(domain_list_output):
    open(domain_list_output, 'w').close()

with open(domain_list_file) as domain_list_file:
    reader = csv.DictReader(domain_list_file)
    with open(domain_list_output,'ab') as domain_list_ouput:
        domain_writer = csv.writer(domain_list_ouput, delimiter= ',',lineterminator='\n',)
        for row in reader:
            w = whois.whois(row['Domain'])
            domain_name = w.domain_name[0]
            org = w.org
            registrar = w.registrar
            dnssec = w.dnssec
            emails = w.emails
            domain_writer.writerow([domain_name,
                org,
                registrar,
                dnssec,
                emails])
            sleep(3)
