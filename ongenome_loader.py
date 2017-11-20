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

Datasets are loaded from either xlsx or md files.

''', formatter_class=argparse.RawTextHelpFormatter)

parser.add_argument('--gff', metavar = '</path/to/my/datastore/organism/my_annotations.gff.gz>',
help='''Annotation file for this organism\n\n''')

parser.add_argument('--gfflist', metavar = '<file_of_organismgffs.txt>',
help='''File containing annotation gff files; one per line\n\n''')

parser.add_argument('--datasetmd', metavar = '<dataset.md>',
help='''Markdown file of dataset (See Sudhansu for now)\n\n''')

parser.add_argument('--datasetxlsx', metavar = '<dataset.xlsx>',
help='''Excell file of dataset (See Sudhansu for now)\n\n''')

parser.add_argument('--counts', metavar = '<count_data.tsv>',
help='''Count data tabular\n\n''')

parser.add_argument('--profile_neighbors', metavar = '<profile_neighbors.tsv>',
help='''Tabular matrix of profile neighbor coorelations\n\n''')

parser.add_argument('--dataset_accession', metavar = '<dataset.accession_no>',
help='''Dataset accesion to use to assocaite neighbor data. Ex: cicar1\n\n''')

parser.add_argument('--logger', metavar = '</path/to/log/my_log.log>',
help='''Provide the path and file for the logger Default: ./ongenome.log.\n\n''', 
default='./ongenome.log')

parser.add_argument('--drop_schema',
action='store_true',
help='''Will drop the ongenome schema\n\n''')

parser.add_argument('--load_schema', metavar = '<my_schema.sql>',
help='''Will load the provided schema\n\n''')

parser._optionals.title = "Program Options"
args = parser.parse_args()

msg_format = '%(asctime)s|%(name)s|[%(levelname)s]: %(message)s'
logging.basicConfig(format=msg_format, datefmt='%m-%d %H:%M',
                    level=logging.INFO)
#log_handler = logging.FileHandler(
#                       '/home/ccameron/ongenome/logs/ongenome_loader.log')

log_handler = logging.FileHandler(args.logger)

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


def make_expression_indexes(db):
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    make_dataset_id = 'create index on ongenome.expressiondata (dataset_id)'
    make_dataset_sample_id = '''create index on 
                                ongenome.expressiondata (dataset_sample_id)'''
    make_genemodel_id = '''create index on 
                                ongenome.expressiondata (genemodel_id)'''
    try:
        cursor.execute(make_dataset_id)
    except psycopg2.Error as e:
        logger.error('could not remake index on dataset_id: {}'.format(e))
        cursor.close()
        return False
    try:
        cursor.execute(make_dataset_sample_id)
    except psycopg2.Error as e:
        logger.error('could not remake index on dataset_sample_id: {}'.format(e)
                    )
        cursor.close()
        return False
    try:
        cursor.execute(make_genemodel_id)
    except psycopg2.Error as e:
        logger.error('could not remake index on genemodel_id: {}'.format(e))
        cursor.close()
        return False
    db.commit()


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
        logger.error('Could not find: {}'.format(readme))
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
    if not (odata['abbrev'] and odata['species'] and odata['genus']):
        logger.error(('Abbreviation, genus, or species is None: '+
                      '{}, {}, {}'.format(odata['abbrev'], 
                                          odata['species'], 
                                          odata['genus'])))
        return False
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
        #logger.warning('could not find chado entry for {}'.format(readme))
        logger.error('could not find chado entry for {}'.format(
                                                           odata['name']))
        return False
    elif len(result) > 1:
        #logger.warning('found multiple chado entries for {}'.format(readme))
        logger.error('found multiple chado entries for {}'.format(
                                                               odata['name']))
        return False
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
        #logger.warning('could not find chado entry for {}'.format(chado_name))
        logger.error('could not find chado entry for {}'.format(chado_name))
        return False
    elif len(result) > 1:
        #logger.warning('found multiple chado entries for {}'.format(chado_name))
        logger.error('multiple chado entries for {}'.format(chado_name))
        return False
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
                    #logger.warning('could not find chado entry for {}'.format(
                    #                                                     gid))
                    logger.error('could not find chado entry for {}'.format(
                                                                         gid))
                    return False
                elif len(result) > 1:
                    #logger.warning('found multiple chado entries for {}'.format(
                    #                                                       gid))
                    logger.error('found multiple chado entries for {}'.format(
                                                                           gid))
                    return False
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

        logger.info('Dropping Expression Indexes to Improve Speed...')
        db_drop = connect_db()
        cur_drop = db_drop.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        drop_dataset_id = '''drop index if exists 
                             ongenome.expressiondata_dataset_id_idx'''
        drop_dataset_sample_id = '''drop index if exists 
                                ongenome.expressiondata_dataset_sample_id_idx'''
        drop_genemodel_id = '''drop index if exists 
                                 ongenome.expressiondata_genemodel_id_idx'''
        try:
            cur_drop.execute(drop_dataset_id)
        except psycopg2.Error as e:
            logger.error('Error occured on expression dataset_id drop: {}'.format(e))
            return False
        try:
            cur_drop.execute(drop_dataset_sample_id)
        except psycopg2.Error as e:
            logger.error('Error occured on expression dataset_sample_id drop: {}'.format(e))
            return False
        try:
            cur_drop.execute(drop_genemodel_id)
        except psycopg2.Error as e:
            logger.error('Error occured on expression genemodel_id drop: {}'.format(e))
            return False
        db_drop.commit()
        if not loaders.load_sample(data[table], cursor, data):
            logger.info('Remaking Expression Indexes...')
            make_expression_indexes(db_drop)
            db_drop.close()
            return False
        logger.info('Remaking Expression Indexes...')
        make_expression_indexes(db_drop)
        db_drop.close()
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
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
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
                    if not s or s.lower() == 'geneid':
                        continue
                    if not s in expression:
                        logger.error('No sample information for {}'.format(
                                                                     s))
                        return False
                s_list = samples[1:]
            else:
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


def neighbors_loader(neighbors, db, acc, threshold):
    index = []
    id_lookup = {}
    values = {}
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    if not loaders.safe_chars.match(acc) or not acc:
        logger.error('Dataset accession can only ocntain alphanumeric chars and underscores not {}'.format(acc))
        return False
    query = '''select dataset_id from ongenome.dataset
               where accession_no=%s'''
    cursor.execute(query, [acc])
    result = cursor.fetchone()
    if not result:
        logger.error('Dataset accession {} was not found in db').format(acc)
        return False
    did = result['dataset_id']
    logger.info('Found PK:{} for dataset accession {}'.format(did, acc))
    acc = '{}_test_profile_neighbors'.format(acc)  # ADD REAL NAME LATER THIS IS FOR TESTING
    check = '''select exists (select 1 from pg_tables where
                schemaname=%s and tablename=%s)'''
    cursor.execute(check, ['ongenome', acc])
    result = cursor.fetchone()
    if not result['exists']:
        logger.info('Creating new table ongenome.{}'.format(acc))
        new_table = 'create table ongenome.{}'.format(acc)
# THIS IS DANGEROUS USUALLY BUT ARGUABLY SAFE HERE AS THE KEY IS REFERENCED AGAINST THE ACCESSION.  NEWER PSYCOPG2 ALLOWS FOR SQL METHOD WHICH COULD SOLVE THIS
        new_table += """(
                    profileneighbor_id bigserial primary key,
                    genemodel_id integer NOT NULL,
                    target_id integer NOT NULL,
                    coorelation numeric(13,3) NOT NULL,
                    dataset_id integer references
                     ongenome.dataset (dataset_id) NOT NULL
                                                                                                  )"""
        try:
            cursor.execute(new_table)
            db.commit()
        except psycopg2.Error as e:
            logger.error('Could not add new table {}: {}'.format(acc, e))
            cursor.close()
            return False
    else:
        logger.error('Coorelation table ongenome.{} already exists!  Drop to remake'.format(acc))
        return False
    logger.info('Loading data matrix and writing temp file for bulk load...')
    with open(neighbors) as n:
        for l in n:
            if not l or l.isspace():
                continue
            l = l.rstrip()
            fl = l.split('\t')
            if len(fl) < 2:
                logger.error('Less than 2 fields in neighbor file check tab')
                return False
            if not fl[0].replace('"', ''):
                for i in fl[1:]:
                    gene = i.replace('"', '')
                    index.append(gene)
                    query = '''select genemodel_id from ongenome.genemodel
                               where genemodel_name=%s'''
                    cursor.execute(query, [gene])
                    result = cursor.fetchone()
                    if not result:
                        logger.error('Could not find genemodel {}'.format(gene))
                        return False
                    if gene in id_lookup:
                        logger.error('Duplicate gene in header {}'.format(gene))
                        return False
                    id_lookup[gene] = result['genemodel_id']
            else:
                gene = fl[0].replace('"', '')
                if not gene in id_lookup:
                    logger.error('Gene {} not in header no db id'.format(gene))
                    return False
                gene = id_lookup[gene]
                if gene in values:
                    logger.error('Already seen gene {}... Duplicate data').format(gene)
                    return False
                values[gene] = {}
                v = values[gene]
                for i,s in enumerate(fl[1:]):
                    if s == 'NA':
                        continue
                    if abs(float(s)) >= threshold:
                        if not index[i] in id_lookup:
                            logger.error('No id for {}, check header'.format(index[i]))
                            return False
                        v[id_lookup[index[i]]] = s
    temp_file = './temp_data.csv'
    topen = open(temp_file, 'w')
    for g in values:
        for c in values[g]:
            topen.write('{},{},{},{}\n'.format(g, c, values[g][c], did))
    topen.close()
    if not loaders.load_neighbors(db, cursor, did, acc, values, temp_file):
        if loaders.remake_neighbor_index:
            db.close()
            db = connect_db()
            logger.info('Remaking Neighbor Indexes...')
            cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
            remake_index = 'create index on ongenome.{} (dataset_id)'.format(
                                                                         acc)
            try:
                cursor.execute(remake_index)
            except psycopg2.Error as e:
                logger.error('Could not remake dataset_id index: {}'.format(e))
            remake_index = 'create index on ongenome.{} (genemodel_id)'.format(
                                                                           acc)
            try:
                cursor.execute(remake_index)
            except psycopg2.Error as e:
                logger.error('Could not remake genemodel_id index: {}'.format(e)
                            )
            db.commit()
            cursor.close()
        return False
    if loaders.remake_neighbor_index:
        logger.info('Remaking Neighbor Indexes...')
        cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        remake_index = 'create index on ongenome.{} (dataset_id)'.format(
                                                                     acc)
        try:
            cursor.execute(remake_index)
        except psycopg2.Error as e:
            logger.error('Could not remake dataset_id index: {}'.format(e))
        remake_index = 'create index on ongenome.{} (genemodel_id)'.format(
                                                                       acc)
        try:
            cursor.execute(remake_index)
        except psycopg2.Error as e:
            logger.error('Could not remake genemodel_id index: {}'.format(e)
                        )
    db.commit()
    cursor.close()
    return True
#    for s in values:
#        for v in values[s]:
#            print '{}\t{}\t{}\t{}'.format(s, v, values[s][v], did)



if __name__ == '__main__':
    db = connect_db()    #connect db
    org_gff = args.gff
    schema = args.load_schema
    org_list = args.gfflist
    datasetmd = args.datasetmd
    datasetxlsx = args.datasetxlsx
    counts = args.counts
    neighbors = args.profile_neighbors
    accession = args.dataset_accession
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
    if neighbors:
        if not accession: #dataset accesion to lookup primary key with
            logger.error('A Dataset accesion must be provided with neighbors')
            db.close()
            sys.exit(1)
        if not check_file(neighbors):
            logger.error('Could not find: {}'.format(datasetxlsx))
            db.close()
            sys.exit(1)
        if not neighbors_loader(neighbors, db, accession, 0.7):
            logger.error('Neighbors loading failed for {}'.format(neighbors))
            db.close()
            sys.exit(1)
    db.close()
    logger.info('DONE')

