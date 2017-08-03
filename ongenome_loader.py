#!/usr/bin/env python

import os, sys
import string
import subprocess
import logging
import argparse
import simplejson as json
import psycopg2
import psycopg2.extras
import re
import datetime
import gzip
import openpyxl as opx
import OngenomeLoaders as loaders
from glob import glob
#from ongenome import app, session, g

parser = argparse.ArgumentParser(description='''

***STILL IN DEVELOPMENT SOME FUNCTIONALITY NOT YET SUPPORTED***

Data loader for expression module OnGenome

Supports loading of data from the datastore using annotation gff files.  The information in these and the associated README.KEY.md files is checked against the Chado database and the user is warned if the expected namespaces do not yeild keys from chado.  Please change the log level to Error if you do not want to see the Warning or Info messages.

Datasets are loaded from either xlsx or md files.  Support currently only exists for md files as this is still in development.

''', formatter_class=argparse.RawTextHelpFormatter)

parser.add_argument('--organisms', metavar = '<organisms.json>',
help='''Organisms JSON dump from Chado as list\n\n''')

parser.add_argument('--gff', metavar = '</path/to/my/datastore/organism/my_annotations.gff.gz>',
help='''Annotation file for this organism\n\n''')

parser.add_argument('--gfflist', metavar = '<file_of_organismgffs.txt>',
help='''File containing annotation gff files; one per line\n\n''')

parser.add_argument('--datasetmd', metavar = '<dataset.md>',
help='''Markdown file of dataset (See Sudhansu for now)\n\n''')

parser.add_argument('--datasetxlsx', metavar = '<dataset.xlsx>',
help='''Excell file of dataset (See Sudhansu for now)\n\n''')

parser.add_argument('--genes', metavar = '<genes.json>',
help='''Genes JSON dump from Chado as list\n\n''')

parser.add_argument('--drop_schema',
action='store_true',
help='''Will drop the ongenome schema\n\n''')

parser.add_argument('--load_schema', metavar = '<my_schema.sql>',
help='''Will load the provided schema\n\n''')

parser.add_argument('--counts', metavar = '<count_data.tab>',
help='''Count data tabular\n\n''')

parser._optionals.title = "Program Options"
args = parser.parse_args()

msg_format = '%(asctime)s|%(name)s|[%(levelname)s]: %(message)s'
logging.basicConfig(format=msg_format, datefmt='%m-%d %H:%M',
                    level=logging.INFO)
log_handler = logging.FileHandler(
                       '/home/ccameron/ongenome/logs/ongenome_loader.log')
formatter = logging.Formatter(msg_format)
log_handler.setFormatter(formatter)
logger = logging.getLogger('ongenome_loader')
logger.addHandler(log_handler)

loaders = loaders.OngenomeLoaders(logger)

def connect_db():
    database = 'drupal'
#    user = ''
#    host = ''
#    port = ''
#    conn_str = 'host={} port={} dbname={} user={}'.format(
#                host, port, database, user)
    conn_str = 'dbname={}'.format(database)
    conn = ''
    try:
        conn = psycopg2.connect(conn_str)
        logger.info('connection succeeded {}'.format(conn_str))
    except:
        raise
    return conn


def check_file(file):
    b = False
    try:
        b = os.path.isfile(file)
    except OSError as e:
        logger.error('error occured on file lookup: {}'.format(e))
        raise
    return b


def check_dir(dir):
    b = False
    try:
        b = os.path.isdir(dir)
    except OSError as e:
        logger.error('error occured on directory lookup: {}'.format(e))
        raise
    return b


def load_organisms_json(organisms):
    try: # Try to get JSON loaded into object
        org_obj = json.load(open(organisms))
    except ValueError:
        logger.error('could not decode JSON file {}'.format(organisms))
    if not isinstance(org_obj, list):
        logger.error('JSON provided in organisms must be a list')
        sys.exit(1)
    for o in org_obj:
        org_id = o.get('organism_id', None)
        genus = o.get('genus', None)
        species = o.get('species', None)
        subspecies = o.get('subspecies', None)
        cultivar_type = o.get('cultivar_type', None)
        line = o.get('line', None)
        abbrev = o.get('abbreviation', None)
        common_name = o.get('common_name', None)
        synonyms = o.get('synonyms', None)
        description = o.get('comment', None)
        notes = o.get('notes', None)
        


def load_genes_json(genes):
    try: # Try to get JSON loaded into object
        gene_obj = json.load(open(genes))
    except ValueError:
        logger.error('could not decode JSON file {}'.format(organisms))
    if not isinstance(gene_obj, list):
        logger.error('JSON provided in genes must be a list')
        sys.exit(1)
    for g in gene_obj:
        print g


def validate_dump(data, organisms, genes):
    try: # Try to get JSON loaded into object
        org_obj = json.load(open(organisms))
    except ValueError:
        sys.stderr.write('could not decode JSON file {}'.format(organisms))#log
    try: # Try to get JSON loaded into object
        gene_obj = json.load(open(genes))
    except ValueError:
        sys.stderr.write('could not decode JSON file {}'.format(genes)) #log
    for o in org_obj: #set organism_ids to keys to check and merge genes
        if o['organism_id'] in data['organisms']:
            sys.stderr.write('duplicate {}'.format(o)) #log
        data['organisms'][o['organism_id']] = o
    for g in gene_obj: #set genes feature_id to key to setup load
        if not g['organism_id'] in data['organisms']:
            sys.stderr.write('could not find organism for {}'.format(g)) #log
            sys.exit(1)
        data['genes'][g['feature_id']] = g


def drop_schema(db):
    drop = '''drop schema ongenome cascade'''
    logger.info('Dropping ongenome schema...')
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    try:
        cursor.execute(drop)
    except psycopg2.Error as e:
        logger.error('could not drop ongenome: {}'.format(e))
        return False
    logger.info('Dropped ongenome Schema')
    db.commit()
    return True


def load_schema(db, schema):
    logger.info('Loading schema')
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    with open(schema) as fopen:
        try:
            cursor.execute(fopen.read())
        except psycopg2.Error as e:
            logger.error('could not load schema: {}'.format(e))
            return False
    logger.info('Initialized schema')
    db.commit()
    return True


def organism_loader(annotation, db):
    odata = {
              'chado_organism_id' : None, 'genus' : None,
              'species' : None, 'subspecies' : None,
              'cultivar_type' : None, 'line' : None,
              'abbrev' : None, 'common_name' : None,
              'synonyms' : None, 'description' : None,
              'notes' : None, 'name' : None
             }
    directory = os.path.dirname(os.path.abspath(annotation))
    sci_name = '#### Scientific Name'
    sci_name_abr = '#### Scientific Name Abbrev'
    readme_key = directory.split('.')[-1] #get key
    source = directory.split('/')[-1].split('.')[0] #get source genome
    buildv = directory.split('/')[-1].split('.')[1] #get build version
    annov = directory.split('/')[-1].split('.')[2]  #get annotation version
    readme = '{}/README.{}.md'.format(directory, readme_key)
#    anno_glob = '{}/*.gene_models.gff3.gz'.format(directory)
    sci_error = 'Complete scientific name not found for: {}'.format(readme)
    abr_error = 'Scientific abbreviation not found for: {}'.format(readme)
    if not check_file(readme):
        logger.error('Could not find: {}'.format(orgs))
        return False
    logger.info('README {} found'.format(readme))
    #if len(annotation) > 1:
    #    logger.error('found too many gene_model files: {}'.format(annotation))
    #    return False
    #annotation = annotation[0]
    #if not check_file(annotation):
    #    logger.error('Could not find: {}'.format(annotation))
    #    return False
    #logger.info('Annotation file {} found'.format(annotation))
    count = 0
    sswitch = 0
    aswitch = 0
    with open(readme) as fopen:
        for line in fopen:
            if line.isspace() or not line:
                continue
            line = line.rstrip()
            if line == sci_name:
                count = 0
                sswitch = 1
                continue
            if line == sci_name_abr:
                count = 0
                aswitch = 1
                continue
            count += 1
            if count%2 == 0:
                if sswitch:
                    if not len(line.split(' ')) >= 2:
                        logger.error(sci_error)
                        return False
                    genus = line.split(' ')[0]
                    species = line.split(' ')[1]
                    odata['species'] = species
                    odata['genus'] = genus
                    sswitch = 0
                if aswitch:
                    if not line:
                        logger.error(abr_error)
                        return False
                    abr = line
                    odata['abbrev'] = abr
                    aswitch = 0
    odata['name'] = '{}.{}'.format(odata['abbrev'], source)
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    #BETTER QUERY NEED TO TALK ABOUT ABBREVIATIONS
    #query = '''select organism_id, common_name from chado.organism 
    #           where species=%s and genus=%s and abbreviation=%s'''
#    query = '''select organism_id, common_name from chado.organism 
#               where species=%s and genus=%s and abbreviation=%s'''
#    args = [odata['species'], odata['genus'], odata['name']]
    query = '''select organism_id, common_name from chado.organism 
               where abbreviation=%s'''
    args = [odata['name']]
#    logger.info('searching for {} {} abbreviation {} in chado...'.format(
#                                                                    args[1], 
#                                                                    args[0],
#                                                                    args[2]
#                                                                  )
#               )
    logger.info('searching for abbreviation {} in chado...'.format(args[0]))
    cursor.execute(query, args)
    result = cursor.fetchall();
    if not result:
        logger.warning('could not find chado entry for {}'.format(readme))
    elif len(result) > 1:
        logger.warning('found multiple chado entries for {}'.format(readme))
    else:
        logger.info('found chado organism_id={} and common_name={}'.format(
                                                      result[0]['organism_id'],
                                                      result[0]['common_name']
                                                     )
                   )
        odata['common_name'] = result[0]['common_name']
        odata['chado_organism_id'] = int(result[0]['organism_id'])
    #LOAD ORGANISM DATA load_organism(cursor, odata)
    if not loaders.load_organism(cursor, odata):
        return False
    cursor.close()
    db.commit()
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    #GET JUST ADDED ID FOR ORGANISM from DB
    name = '{}.{}.{}.{}'.format(odata['abbrev'], source, buildv, annov)
    chado_name = '{}.{}.{}'.format(odata['abbrev'], source, buildv)
    aid = None #chado id for genome from analysis table
    logger.info('searching for genome {} in analysis...'.format(chado_name))
    query = '''select analysis_id from analysis where name=%s''' #get chado id
    cursor.execute(query, [chado_name])
    result = cursor.fetchall();
    if not result:
        logger.warning('could not find chado entry for {}'.format(chado_name))
    elif len(result) > 1:
        logger.warning('found multiple chado entries for {}'.format(chado_name))
    else:
        aid = int(result[0]['analysis_id'])
        logger.info('found chado analysis_id={} for genome={}'.format(
                                                                aid, chado_name
                                                                ))
    query = '''select organism_id from ongenome.organism where name=%s'''
    cursor.execute(query, [odata['name']])
    result = cursor.fetchall()
    if not result:
        logger.error('could not find organism id for genome {}'.format(
                                                                 shortname))
        return False
    oid = result[0]['organism_id']
    gdata = { #create object to load into db
              'name' : name, 'shortname' : chado_name, 'description' : None,
              'source' : source, 'build' : buildv, 'annotation' : annov,
              'organism_id' : oid, 'notes' : None, 'chado_id' : aid
             }
    #LOAD GENOME DATA load_genome(cursor, gdata)
    if not loaders.load_genome(cursor, gdata):
        return False
    cursor.close()
    db.commit()
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    #GET GENOME ID FROM DB
    query = '''select genome_id from ongenome.genome where name=%s'''
    cursor.execute(query, [name])
    result = cursor.fetchall()
    if not result:
        logger.error('could not find genome id for genome {}'.format(
                                                               name))
        return False
    goid = result[0]['genome_id']
    logger.info('Parsing gene models from {}'.format(annotation))
    with gzip.open(annotation) as fopen:
        for line in fopen:
            gmdata = {
                       'genemodel_name' : None, 'chado_uniquename' : None,
                       'genome_id' : goid
                      }
            if line.startswith('#') or line.isspace() or not line:
                continue
            line = line.rstrip()
            fields = line.split('\t')
            if fields[2] == 'gene':
                info = fields[8].split(';')
                for f in info:
                    if f.startswith('Name='):
                        name = f.replace('Name=', '')
                    if f.startswith('ID='):
                        gid = f.replace('ID=', '')
                    if f.startswith('Notes='):
                        notes = f.replace('Notes=', '')
                query = '''select uniquename from chado.feature 
                           where type_id = (select cvterm_id 
                                            from chado.cvterm where name='gene')
                           and uniquename=%s;'''
                cursor.execute(query, [gid])
                result = cursor.fetchall()
                if not result:
                    logger.warning('could not find chado entry for {}'.format(
                                                                         gid))
                elif len(result) > 1:
                    logger.warning('found multiple chado entries for {}'.format(
                                                                           gid))
                else:
                    logger.info('found chado uniquename={}'.format(gid))
                    gmdata['chado_uniquename'] = gid
                gmdata['genemodel_name'] = gid
            #LOAD gene model load_model(cursor, gmdata)
                if not loaders.load_model(cursor, gmdata):
                    return False
    cursor.close()
    db.commit()
    return True


def load_treatment(data, cursor):  #Will implement later
    cursor.close()
    return True


def select_loader(table, data, db):
    if table == 'datasource':
        logger.info('loading datasource')
        cursor = db.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor)
        if not loaders.load_datasetsource(data[table], cursor, data):
            return False
    elif table == 'method':
        logger.info('loading method')
        cursor = db.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor)
        if not loaders.load_method(data[table], cursor, data):
            return False
    elif table == 'dataset':
        logger.info('loading dataset')
        cursor = db.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor)
        if not loaders.load_dataset(data[table], cursor, data):
            return False
    elif table == 'samples':
        logger.info('loading sample')
        cursor = db.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor)
        if not loaders.load_sample(data[table], cursor, data):
            return False
    elif table == 'treatment':
        logger.info('loading treatment')
        cursor = db.cursor(
            cursor_factory=psycopg2.extras.RealDictCursor)
        if not loaders.load_treatment(data[table], cursor):
            return False
    else:
        logger.error('did not recognize {} will not load'.format(table))
        return False
#    print data[table]
    return True


def xlsx_attribute_parser(ws, data):
    for row in tuple(ws.rows):   # creates a tuple of all rows in ws_dataset
        if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
            continue
        if not row[1].value:
            continue
        k = row[1].value.lower()
        v = row[2].value
        if not k:
            logger.error('key could not be parsed for {}'.format(row))
            return False
#            if not v:
#                logger.error('value could not be parsed for {}'.format(row))
#                return False
        data[k] = v
    return True


def dataset_loader(dataset, db, t, counts): #could add checks beyond expression data
    table = ''  #Filled by lines with ##
    attribute = ''  #Filled by line with ####
    #order = ['datasource', 'method', 'dataset', 'samples', 'treatment',
    #         'dataset_sample', 'expressiondata'] # add treatment back when rdy
    order = ['datasource', 'method', 'dataset', 'samples']
    data = {}
    header = []
    if t == 'md':  #For markdown files
        with open(dataset) as mopen:
            for line in mopen:
                line = line.rstrip()
                if line.isspace() or not line:
                    continue
                if line.startswith('####'):  #parse attribute make lower
                    attribute = line.replace('#', '').replace(' ', '').lower()
                elif line.startswith('##'):  #parse table make lower
                    table = line.replace('#', '').replace(' ', '').lower()
                    data[table] = {}  #initialize dictionary for table
                else:  #data lines
                    if table == 'samples':
                        fields = line.split('\t')  #tab delimited data
                        if not 'sample_data' in data[table]:#first line header
                            data[table]['sample_data'] = [] #init sample_data
                            data['expression'] = {}
                            header = fields
                            continue
                        temp = {}
                        for i,f in enumerate(fields):
                            temp[header[i]] = f  #create sample object
                        if not temp.get('key', None):
                            logger.error('key attribute must be provided in samples!')
                            return False
                        data[table]['sample_data'].append(temp)
                        data['expression'][temp['key']] = {}
                    else:
                        data[table][attribute] = line
    elif t == 'xlsx':
        #Read xlfile into workbook obj
        tables = ['dataset', 'datasource', 'method', 'samples', 'expression']
        data = {'dataset' : {}, 'datasource' : {},
                'method' : {}, 'samples' : {}, 'expression' : {}}
        wb = opx.load_workbook(dataset, read_only=True)
        ws_dataset = wb.get_sheet_by_name('dataset')
        ws_datasource = wb.get_sheet_by_name('datasource')
        ws_method = wb.get_sheet_by_name('method')
        sets = [ws_dataset, ws_datasource, ws_method]
        ws_sample = wb.get_sheet_by_name('sample')
#        ws_expdesign = wb.get_sheet_by_name('expdesign')
        for i,s in enumerate(sets):
            logger.info('reading {}...'.format(tables[i]))
            if not xlsx_attribute_parser(s, data[tables[i]]):
                return False
        data['samples']['sample_data'] = []
        logger.info('reading samples...')
        for row in tuple(ws_sample):
            if (row[0].value == 'sample_name'):   # if 1st col is ?sample_name?
                for h in row:
                    header.append(h.value)
            else:
                if (row[0].value and re.match('^#', row[0].value)):   # skip commented line, 1st col/cel is '#'
                    continue
                if not row[1].value:
                    continue
                temp = {}
                for i,s in enumerate(row):
                    temp[header[i]] = s.value
                if not temp.get('key', None):
                    logger.error('key attribute must be provided in samples!')
                    return False
                data['samples']['sample_data'].append(temp)
                data['expression'][temp['key']] = {}
    else:
        logger.error('format {} not recognized'.format(t))
        return False
    logger.info('parsing counts data in {}...'.format(counts))
    with open(counts) as copen:
        count = 0
        s_list = []
        expression = data['expression']
        for line in copen:
            if line.isspace() or not line or line.startswith('#'):
                continue
            line = line.rstrip()
            samples = line.split('\t')
            if not count:
                for s in samples:
                    if not s:
                        continue
                    if not s in expression:
                        logger.error('No sample information for {}'.format(
                                                                     s))
                        return False
                s_list = samples[1:]
            else:
                cursor = db.cursor(
                            cursor_factory=psycopg2.extras.RealDictCursor
                         )
                get_model_id = '''select genemodel_id from 
                                  ongenome.genemodel where
                                  genemodel_name=%s'''
                cursor.execute(get_model_id, [samples[0]])
                result = cursor.fetchone()
                if not result:
                    logger.error('no gene model id for {}'.format(
                                                            samples[0]))
                    return False
                genemodel_id = result['genemodel_id']
                for i,v in enumerate(samples[1:]):
                    expression[s_list[i]][genemodel_id] = v
            count += 1
#            for s in expression:
#                for g in expression[s]:
#                    print '{}\t{}\t{}'.format(s, g, expression[s][g])
#        sys.exit(1)
    for o in order:  #load based on order. removes md order dependencies
        if not o in data:  #table seen in md
            logger.error('did not parse {} from md'.format(o))
            return False
        if not data[o]:  #data not empty
            logger.error('empty values for {}'.format(o))
            return False
        if not select_loader(o, data, db):  #load it
            return False
    logger.info('comminting transactions...')
    db.commit()
    logger.info('commited successfully!')
    return True


if __name__ == '__main__':
    db = connect_db()    #connect db
    orgs = args.organisms
    genes = args.genes
    org_gff = args.gff
    schema = args.load_schema
    org_list = args.gfflist
    datasetmd = args.datasetmd
    datasetxlsx = args.datasetxlsx
    counts = args.counts
#    data = {'organism' : [], 'genome' : [], 'gene_models' : []}
    if args.drop_schema:
        if not drop_schema(db):
            logger.error('Could not drop ongenome Schema!')
            db.close()
            sys.exit(1)
    if schema:
        if not check_file(schema):
            logger.error('Could not find: {}'.format(orgs))
            db.close()
            sys.exit(1)
        logger.info('Schema file {} found'.format(schema))
        if not load_schema(db, schema):
            logger.error('Could not load schema!')
            db.close()
            sys.exit(1)
    if orgs:
        if not check_file(orgs):
            logger.error('Could not find: {}'.format(orgs))
            db.close()
            sys.exit(1)
        logger.info('File {} found'.format(os.path.abspath(orgs)))
        load_organisms_json(orgs)
    if genes:
        if not check_file(genes):
            logger.error('Could not find: {}'.format(genes))
            db.close()
            sys.exit(1)
        logger.info('File {} found'.format(os.path.abspath(genes)))
        load_genes_json(genes)
    if org_gff:
        if not check_file(org_gff):
            logger.error('Could not find: {}'.format(org_gff))
            db.close()
            sys.exit(1)
        logger.info('File {} found'.format(os.path.abspath(org_gff)))
        org_dir = os.path.abspath(org_gff)
#        if not organism_loader(org_dir, data, db):
        if not organism_loader(org_gff, db):
            logger.error('Data loading failed!')
            db.close()
            sys.exit(1)
    if org_list:
        if not check_file(org_list):
            logger.error('Could not find: {}'.format(org_list))
            db.close()
            sys.exit(1)
        logger.info('File {} found'.format(os.path.abspath(org_list)))
        with open(org_list) as lopen:
            for line in lopen:
                if line.isspace():
                    continue
                line = line.rstrip()
                if not check_file(line):
                    logger.error('Could not find: {}'.format(line))
                    db.close()
                    sys.exit(1)
                org_gff = os.path.abspath(line)
#        if not organism_loader(org_dir, data, db):
                if not organism_loader(org_gff, db):
                    logger.error('Data loading failed for {}!'.format(line))
                    db.close()
                    sys.exit(1)
    if datasetmd: #check for markdown
        if not counts:
            logger.error('counts must be provided if dataset is provided')
            db.close()
            sys.exit(1)
        if not check_file(datasetmd):
            logger.error('Could not find: {}'.format(datasetmd))
            db.close()
            sys.exit(1)
        if not check_file(counts):
            logger.error('Could not find: {}'.format(datasetmd))
            db.close()
            sys.exit(1)
        if not dataset_loader(datasetmd, db, 'md', counts):
            logger.error('Dataset loading failed for {}'.format(datasetmd))
            db.close()
            sys.exit(1)
    if datasetxlsx: #check for excel
        if not counts:
            logger.error('counts must be provided if dataset is provided')
            db.close()
            sys.exit(1)
        if not check_file(datasetxlsx):
            logger.error('Could not find: {}'.format(datasetxlsx))
            db.close()
            sys.exit(1)
        if not check_file(counts):
            logger.error('Could not find: {}'.format(datasetmd))
            db.close()
            sys.exit(1)
        if not dataset_loader(datasetxlsx, db, 'xlsx', counts):
            logger.error('Dataset loading failed for {}'.format(datasetxlsx))
            db.close()
            sys.exit(1)
    db.close()
    logger.info('DONE')

