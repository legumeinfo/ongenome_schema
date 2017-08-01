#!/usr/local/bin/python

#UNDER DEVELOPMENT  
#Modified from expr-dataset-excel-to-md.py


#USAGE:  expr-dataset-excel-to-json-for-loading.py  <path/to/file.xlsx>
#EX:  $ python expr-dataset-excel-to-json-for-loading.py /usr/local/www/data/private/Cicer_arietinum/expression_datasets/cicar-SRP017394-atlas-on-ICC4958_DataStoreFormat.xlsx


##STATUS:
## Functional and prints json_all
## Will modify after hearing Connor's need
## Need to delete lots of junk (remnant code pieces)




'''
-- Extracts from a structures Excel file, information about an expression 
   dataset for loading to ongenome schema.
-- Creates dict for each section.
-- Converts dict to json string.

Sudhansu Dash: 
    May 2017 (expr-dataset-excel-to-md.py)
    Jul 2017: Remove code for  printing to .md; create json string from py dict. 
	      Return one json object (for all the required data) reflecting dict of dataset,datasource, method, sample, etc.
'''
#-----------------------------------------------------------------------------

import sys
import re
import os
  #For reading Excel file
import openpyxl as opx  
  #For converting dict to json string
import json

#----------------------

#Excel File to read
xlfile = sys.argv[1]


#----------------


#Process the Excel file
#======================

print "Starting to process Excel file: ",xlfile

#outputfile = os.path.basename(xlfile) + ".out.md"
#print outputfile
#exit()
#outputfile = open(outputfile, 'w')
#print "Output file: ",outputfile
#exit()


#Read xlfile into workbook obj
wb = opx.load_workbook(xlfile, read_only=True)

print "Finished reading Excel file. Has sheets: "
print wb.get_sheet_names()  #prints all the worksheets in workbook

#Get the Sheet objs from Workbook obj 
ws_dataset = wb.get_sheet_by_name('dataset')
ws_datasource = wb.get_sheet_by_name('datasource')
ws_sample = wb.get_sheet_by_name('sample')
ws_method = wb.get_sheet_by_name('method')
ws_expdesign = wb.get_sheet_by_name('expdesign')


dict_all = {}  # Combined single dict obj for dataset, datasource, method, samples, etc. 
               # To be converted to json string the end.


#DATASET
#=======

dict_dataset = {}  ## to append to this dict of attrib=value

for row in tuple(ws_dataset.rows):   # creates a tuple of all rows in ws_dataset
    
    #print row[0].value #debug
    if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
          ##row[0].value must be a string for re.match; Caution about 'NoneObject'
        continue
    
    else:
        k = row[1].value
        v = row[2].value
       
        '''
        if (k):
            #k = k.rstrip()  #key k in 2nd cell
            #print '####  ' + k
            #outputfile.write('####  ' + k + "\n")
        
        if (v):
            #v = v.rstrip()  #value v in 3rd cell
            #print v
            #outputfile.write(v + "\n")
        '''
    dict_dataset[k] = v
#end for

json_dataset = json.dumps(dict_dataset)  # dict to json string
dict_all['dataset'] = dict_dataset  #into a single dict 


# DATASOURCE
#============
#
dict_dsource = {}  ## to append to this dict of attrib=value

for row in tuple(ws_datasource.rows):   # creates a tuple of all rows in ws_dataset
    if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
        continue
    else:
        k = row[1].value
        v = row[2].value
        
	'''
        if (k):
            #k = k.rstrip()  #key k in 2nd cell
            #print '####  ' + k
            #outputfile.write('####  ' + k + "\n")
        
        if (v):
            #v = v.rstrip()  #value v in 3rd cell
            #print v
            #outputfile.write(v + "\n")
        '''

    dict_dsource[k] = v
#end for
#
json_dsource = json.dumps(dict_dsource)   # dict to json string
dict_all['datasource'] = dict_dsource  #into a single dict


#METHOD
#======

dict_method = {}

for row in tuple(ws_method.rows):   # creates a tuple of all rows in ws_dataset
    if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
        continue
    else:
        k = row[1].value
        v = row[2].value
        
	'''
        if (k):
            #k = k.rstrip()  #key k in 2nd cell
            #print '####  ' + k
            #outputfile.write('####  ' + k + "\n")
        
        if (v):
            #v = v.rstrip()  #value v in 3rd cell
            #print v
            #outputfile.write(v + "\n")
        '''

    dict_method[k] = v
#end for
#
json_method = json.dumps(dict_dsource)   # dict to json string
dict_all['method'] = dict_method  #into a single dict


##SAMPLES INTO A LIST-OF-DICTIONARY
#==================================


#Collect sample attribute names from 
## cells in row starting with 'sample_name'
attribute_names = []  #a list, to append to
for row in tuple(ws_sample.rows):   # creates a tuple of all rows in ws_sample
    if (row[0].value == 'sample_name'):   # if 1st col is ?sample_name?
        for cell in row:    #start loop through that row
            #print cell.value  # print cell value
            attribute_names.append(cell.value)


attribute_names_str = "\t".join(attribute_names)    #list to string with '\t' as sep
#print "Sample attribute names: \n", attribute_names


## Collect sample attribute and values
samples_list_of_dict = []  ## To append to a list of dicts(each sample row is a dict)

for row in tuple(ws_sample.rows):   # creates a tuple of all rows in ws_sample
    if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
        continue
    
    rowvalues = []    #list
    
    for cell in row:    #start loop through that row
        rowvalues.append(cell.value)
    #End- inner for
    
    dict_col_value = dict(zip(attribute_names, rowvalues))  ##Creates a dict col-names and this row's values
    samples_list_of_dict.append(dict_col_value)  ## Appends this dict to a list (A list of dict at the end)
#End-outer for    


json_samples = json.dumps(samples_list_of_dict)  # to json string
dict_all['samples'] = samples_list_of_dict  #into a single dict


## To json, all sheets together into one json string
json_all = json.dumps(dict_all)    # Final json string from dict_all


## REMOVE IF NECESSARY
print  json_all





##=======   SCRATCH PAD   ==========


