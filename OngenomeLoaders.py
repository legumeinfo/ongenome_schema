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


class OngenomeLoaders:

    def __init__(self, logger):
        if not logger:
            sys.stderr.write("logger must be provided")
            sys.exit(1)
        self.logger = logger

    def load_organism(self, cursor, data):
        logger = self.logger
        if not data.get('name', False):
            logger.error('name attribute cannot be null for Organism!')
            return False
        check = '''select organism_id from ongenome.organism where name=%s'''
        cursor.execute(check, [data['name']])
        result = cursor.fetchall()
        if result:
            logger.warning('Organism {} already found in DB'.format(data['name']))
            #should I update etc
        else:
            logger.info('Adding new organism {}'.format(data['name']))
            insert = '''insert into ongenome.organism
                        (chado_organism_id, name, genus, species, subspecies,
                         cultivar_type, line, abbrev, common_name, synonyms,
                         description, notes) values
                        (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''
            params = [data['chado_organism_id'], data['name'],
                      data['genus'], data['species'], data['subspecies'],
                      data['cultivar_type'], data['line'], data['abbrev'],
                      data['common_name'], data['synonyms'],
                      data['description'], data['notes']]
            try:
                cursor.execute(insert, params)
            except psycopg2.Error as e:
                logger.error('Could not insert organism {}: {}'.format(
                                                                 data['name'],
                                                                 e)
                            )
                return False
        return True

    def load_genome(self, cursor, data):
        logger = self.logger
        if not data.get('name', False):
            logger.error('name required for genome load!')
            return False
        if not data.get('shortname', False):
            logger.error('short name required for genome load!')
            return False
        if not data.get('organism_id', False):
            logger.error('organism id required for genome load!')
            return False
        check = '''select name from ongenome.genome where name=%s'''
        cursor.execute(check, [data['name']])
        result = cursor.fetchall()
        if result:
            logger.warning('Genome {} already found in DB'.format(data['name']))
            #should I update etc
        else:
            logger.info('Adding new genome {}'.format(data['name']))
            insert = '''insert into ongenome.genome
                        (name, shortname, description, source, build, annotation,
                         organism_id, notes, chado_id) values
                        (%s, %s, %s, %s, %s, %s, %s, %s, %s)'''
            params = [data['name'], data['shortname'], data['description'],
                      data['source'], data['build'], data['annotation'],
                      data['organism_id'], data['notes'], data['chado_id']]
            try:
                cursor.execute(insert, params)
            except psycopg2.Error as e:
                logger.error('Could not insert genome {}: {}'.format(
                                                                 data['name'],
                                                                 e)
                            )
        return True

    def load_model(self, cursor, data):
        logger = self.logger
        if not data.get('genome_id', False):
            logger.error('genome id required for gene model load!')
            return False
        if not data.get('genemodel_name', False):
            logger.error('genemodel name required for genome load!')
            return False
        check = '''select genemodel_name from ongenome.genemodel where
                   genemodel_name=%s'''
        cursor.execute(check, [data['genemodel_name']])
        result = cursor.fetchall()
        if result:
            logger.warning('Gene model {} already found in DB'.format(
                                                        data['genemodel_name'])
                       )
            #should I update etc
        else:
            logger.info('Adding new gene model {}'.format(data['genemodel_name']))
            insert = '''insert into ongenome.genemodel
                        (genome_id, genemodel_name, chado_uniquename) values
                        (%s, %s, %s)'''
            params = [data['genome_id'], data['genemodel_name'],
                      data['chado_uniquename']]
            try:
                cursor.execute(insert, params)
            except psycopg2.Error as e:
                logger.error('Could not insert genome {}: {}'.format(
                                                                 data['name'],
                                                                 e)
                            )
        return True

    def load_datasetsource(self, data, cursor, adata):
        logger = self.logger
        if not data.get('name', None):
            logger.error('name not found for datasetsource!  will not load!')
            cursor.close()
            return False
        if not data.get('shortname', None):
            logger.error('shortname not found for datasetsource!  will not load!')
            cursor.close()
            return False
        name = data.get('name', None)
        shortname = data.get('shortname', None)
        origin = data.get('origin', None)
        description = data.get('description', None)
        bioproj_acc = data.get('bioproj_acc', None)
        bioproj_title = data.get('bioproj_title', None)
        bioproj_description = data.get('bioproj_description', None)
        sra_proj_acc = data.get('sra_proj_acc', None)
        geo_series = data.get('geo_series', None)
        notes = data.get('notes', None)
        check = '''select datasetsource_id from ongenome.datasetsource
                   where shortname=%s'''
        cursor.execute(check, [shortname])
        result = cursor.fetchone()
        if not result:
            logger.info('adding new datasetsource: {}'.format(shortname))
            insert = '''insert into ongenome.datasetsource
                        (name, shortname, origin, description, bioproj_acc,
                         bioproj_title, bioproj_description, sra_proj_acc,
                         geo_series, notes)
                        values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        returning datasetsource_id'''

            try:
                cursor.execute(insert, [name, shortname, origin, description,
                                        bioproj_acc, bioproj_title,
                                        bioproj_description, sra_proj_acc,
                                        geo_series, notes]
                              )
                new_id = cursor.fetchone()['datasetsource_id']
                adata['dataset']['datasetsource_id'] = new_id
                adata['samples']['datasetsource_id'] = new_id
            except psycopg2.Error as e:
                logger.error('insert failed for datasetsource: {}'.format(e))
                cursor.close()
                return False
            cursor.close()
            logger.info('datasetsource {} loaded successfully'.format(shortname))
        else:
            logger.warning('datasetsource {} already exists in db'.format(
                                                                    shortname))
            new_id = result['datasetsource_id']
            adata['dataset']['datasetsource_id'] = new_id
            adata['samples']['datasetsource_id'] = new_id
        cursor.close()
        return True

    def load_method(self, data, cursor, adata):
        logger = self.logger
        if not data.get('shortname', None):  #not null
            logger.error('shortname not found for method!  will not load!')
            cursor.close()
            return False
        name = data.get('name', None)
        shortname = data.get('shortname', None)
        version = data.get('version', None)
        analysis_date = data.get('analysis_date', None)
        description = data.get('description', None)
        details = data.get('details', None)
        notes = data.get('notes', None)
        check = '''select method_id from ongenome.method where shortname=%s'''
        cursor.execute(check, [shortname])
        result = cursor.fetchone()
        if not result:
            logger.info('adding new method: {}'.format(shortname))
            insert = '''insert into ongenome.method
                        (name, shortname, version, analysis_date, description,
                         details, notes)
                        values (%s, %s, %s, %s, %s, %s, %s)
                        returning method_id'''
            try:
                cursor.execute(insert, [name, shortname, version, analysis_date,
                                        description, details, notes]
                              )
                new_id = cursor.fetchone()['method_id']
                adata['dataset']['method_id'] = new_id
            except psycopg2.Error as e:
                logger.error('insert failed for method: {}'.format(e))
                cursor.close()
                return False
            cursor.close()
            logger.info('method {} loaded successfully'.format(shortname))
        else:
            logger.warning('method {} already exists in db'.format(shortname))
            new_id = result['method_id']
            adata['dataset']['method_id'] = new_id
        cursor.close()
        return True

    def load_dataset(self, data, cursor, adata):
        logger = self.logger
        if not data.get('shortname', None):#not null, key for lookup
            logger.error('shortname not found for dataset!  will not load!')
            cursor.close()
            return False
        if not data.get('method_id', None): #not null
            logger.error('method_id not found for dataset!  will not load!')
            cursor.close()
            return False
        if not data.get('datasetsource_id', None): #not null
            logger.error('datasetsource_id not found for dataset!  will not load!')
            cursor.close()
        if not data.get('accession_no', None):
            logger.error('accession_no not found for dataset!  will not load!')
            cursor.close()
            return False
    #    (genome, annotation) = ('.'.join(data['genome'].split('.')[:3]),
    #                         data['genome'].split('.')[-1]) #isolate lookup values
        get_genome = '''select genome_id from ongenome.genome
                        where name=%s'''
        cursor.execute(get_genome, [data['genome']]) #get genome_id
        result = cursor.fetchone()
        if not result:
            logger.error('could not find genome_id for {}'.format(data['genome']))
            cursor.close()
            return False
        genome_id = result['genome_id']
        get_organism = '''select organism_id from ongenome.genome where
                          genome_id=%s'''
        cursor.execute(get_organism, [genome_id])
        result = cursor.fetchone()
        if not result:
            logger.error('could not find organism_id for {}'.format(data['genome']))
            cursor.close()
            return False
        organism_id = result['organism_id']
        adata['samples']['organism_id'] = organism_id
        load_date = datetime.datetime.utcnow()
        datasetsource_id = data.get('datasetsource_id', None)
        method_id = data.get('method_id', None)
        accession_no = data.get('accession_no', None)
        name = data.get('name', None)
        shortname = data.get('shortname', None)
        description = data.get('description', None)
        notes = data.get('notes', None)
        check = '''select dataset_id from ongenome.dataset where accession_no=%s'''
        cursor.execute(check, [accession_no])
        result = cursor.fetchone()
        if not result:
            logger.info('adding new dataset {}'.format(shortname))
            insert = '''insert into ongenome.dataset
                    (genome_id, datasetsource_id, method_id, accession_no, name,
                     shortname, description, notes, load_date)
                    values
                    (%s, %s, %s, %s, %s, %s, %s, %s, %s) returning dataset_id'''
            try:
                cursor.execute(insert, [genome_id, datasetsource_id, method_id,
                                        accession_no, name, shortname,
                                        description, notes, load_date])
                result = cursor.fetchone()
                adata['samples']['dataset_id'] = result['dataset_id']
            except psycopg2.Error as e:
                logger.error('insert failed for dataset {}'.format(e))
                cursor.close()
                return False
            logger.info('dataset: {} added successfully'.format(shortname))
        else:
            logger.warning('dataset {} already exists in db'.format(shortname))
            adata['samples']['dataset_id'] = result['dataset_id']
        cursor.close()
        return True

    def load_sample(self, data, cursor, adata):  #populates sample and dataset_sample
        logger = self.logger
        if not data.get('organism_id', None): #not null
            logger.error('no organism_id for samples!')
            cursor.close()
            return False
        if not data.get('dataset_id', None): #not null
            logger.error('no dataset_id for samples!')
            cursor.close()
            return False
        if not data.get('datasetsource_id', None): #not null
            logger.error('no datasetsource_id for samples!')
            cursor.close()
            return False
        organism_id = data.get('organism_id', None)
        dataset_id = data.get('dataset_id', None)
        datasetsource_id = data.get('datasetsource_id', None)
        if not data.get('sample_data', None):  #if no sample data return
            logger.error('no sample data to load!')
            cursor.close()
            return False
        #may need to drop index for expression data here once they exist.  They can be remade and it is faster when they are large to drop them and remake them after the load
        for s in data['sample_data']:
            if not s.get('sample_uniquename', None):  #not null
                logger.error('no sample_uniquename for sample!')
                cursor.close()
                return False
            if not s.get('key'):
                logger.error('no key for sample!')
                cursor.close()
                return False
            sample_uniquename = s.get('sample_uniquename', None)
            key = s.get('key', None)
            expression = adata['expression'][key]
            name = s.get('sample_name', None)
            shortname = s.get('shortname', None)
            description = s.get('description', None)
            age = s.get('age', None)
            dev_stage = s.get('dev_stage', None)
            plant_part = s.get('plant_part', None)
            treatment = s.get('treatment', None)
            other_attributes = []
            ncbi_accessions = []
            for f in s:  #iterate through all fields and see if SRA, data or other
                if (f != 'sample_uniquename' and f != 'sample_name' and \
                    f != 'shortname' and f != 'description' and \
                    f != 'age' and f != 'dev_stage' and \
                    f != 'plant_part' and f != 'treatment'):
                    if f.lower().startswith('sra_') or \
                       f.lower() == 'bioproject_accession' or \
                       f.lower() == 'biosample_accession':
                        ncbi_accessions.append('{}:{}'.format(f, s[f]))
                    else:
                        if f:
                            other_attributes.append('{}:{}'.format(f, s[f]))
            ncbi_accessions = ';'.join(ncbi_accessions)
            if not ncbi_accessions:
                ncbi_accessions = None
            other_attributes = ';'.join(other_attributes)
            if not other_attributes:
                other_attributes = None
            check = '''select sample_id from ongenome.sample where
                       sample_uniquename=%s''' # check for existence
            cursor.execute(check, [sample_uniquename])
            result = cursor.fetchall()
            if not result:  #if not exists load it
                logger.info('inserting new sample {}'.format(sample_uniquename))
                insert = '''insert into ongenome.sample
                            (datasetsource_id, organism_id, sample_uniquename,
                             name, shortname, description, age, dev_stage,
                             plant_part, treatment, other_attributes,
                             ncbi_accessions)
                            values
                            (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                            returning sample_id'''  #return sample_id to pass
                try:
                    cursor.execute(insert, [datasetsource_id, organism_id,
                                            sample_uniquename, name, shortname,
                                            description, age, dev_stage,
                                            plant_part, treatment,
                                            other_attributes, ncbi_accessions])
                    result = cursor.fetchone()
                    sample_id = result['sample_id']
                    if not sample_id:
                        logger.error('could not retrieve sample id... odd...')
                        cursor.close()
                        return False
                    check = '''select dataset_sample_id from
                               ongenome.dataset_sample
                               where
                               dataset_id=%s and sample_id=%s'''
                    cursor.execute(check, [dataset_id, sample_id])  #check
                    result = cursor.fetchall()
                    if not result:  #if not exists load it
                        insert = '''insert into ongenome.dataset_sample
                                    (dataset_id, sample_id)
                                    values
                                    (%s, %s) returning dataset_sample_id'''
                        try:
                            logger.info('inserting dataset_sample')
                            cursor.execute(insert, [dataset_id, sample_id])
                            result = cursor.fetchone()
                            dataset_sample_id = result['dataset_sample_id']
                            exp_value_type = None
                            for e in expression:
    #                            check = '''select expressiondata_id from
    #                                       ongenome.expressiondata where
    #                                       dataset_sample_id=%s and dataset_id=%s
    #                                       and genemodel_id=%s
    #                                    '''
    #                            cursor.execute(check, [dataset_sample_id,
    #                                                   dataset_id,
    #                                                   e])
    #                            result = cursor.fetchall()
                                result = []
                                if not result:
                                    logger.info('inserting expressiondata for sample {}: {} {} {} with value {}'.format(sample_uniquename, e, dataset_id, dataset_sample_id, expression[e]))

                                    insert = '''insert into ongenome.expressiondata
                                            (genemodel_id, dataset_id,
                                             dataset_sample_id, exp_value_type,
                                             exp_value) values
                                             (%s, %s, %s, %s, %s)'''
                                    try:
                                        cursor.execute(insert, [e, dataset_id,
                                                            dataset_sample_id,
                                                            exp_value_type,
                                                            expression[e]])
                                    except psycopg2.Error as e:
                                        logger.error('expression insert failed {}!'.format(e))
                                        cursor.close()
                                        return False
                                else:
                                    logger.warning('expressiondata {} {} {} with value {} already exists in db'.format(e, dataset_id, dataset_sample_id, expression[e]))
                        except psycopg2.Error as e:
                            logger.error('could not insert dataset_sample: {}'.format(e))
                            cursor.close()
                            return False
                        logger.info('dataset_sample added successfully')
                    else:
                        logger.warning('dataset_sample already exists in db')
                except psycopg2.Error as e:
                    logger.error('could not insert sample: {}'.format(e))
                    cursor.close()
                    return False
                logger.info('sample {} added successfully'.format(
                                                            sample_uniquename))
            else:
                logger.warning('sample {} already exists in db'.format(
                                                                sample_uniquename))
        cursor.close()
        return True

    def load_neighbors(self, db, cursor, acc, data):
        logger = self.logger
        new_table = 'create table if not exists ongenome.{}'.format(acc)
        # THIS IS DANGEROUS USUALLY BUT ARGUABLY SAFE HERE AS THE KEY IS REFERENCED AGAINST THE ACCESSION.  NEWER PSYCOPG2 ALLOWS FOR SQL METHOD WHICH COULD SOLVE THIS
        new_table += """(
                        profileneighbor_id bigserial primary key,
                        genemodel_uniquename varchar(64) NOT NULL,
                        target_uniquename varchar(64) NOT NULL,
                        coorelation numeric(13,3) NOT NULL,
                        dataset_id integer references 
                         ongenome.dataset (dataset_id) NOT NULL
                       )"""
        try:
            cursor.execute(new_table)
            db.commit()
        except psycopg2.Error as e:
            logger.error('Could not add new table {}: {}'.format(acc, e))
            return False
        return True
        


if __name__ == '__main__':
    print "Class for OnGenome loaders, please import...\nexiting...\n"
    sys.exit(1)
