# Instructions for Running ongenome_loader.py

### REQUIREMENTS

1. One or more Organsim GFF file(s) from the Datastore (for Novel Organisms)
   
   You do not need to include this if your organism already exists in OnGenome.  
   This must follow the standard datastore format and also must have an  
   associated README.KEY.md file.

2. A dataset

   md or xlsx file containing the attributes for your dataset.  

3. Tab-delimited Count Data

   Tabular file of expression data per sample per gene.  
   References the 'key' attribute from the datatset for the sample lookup.  
   
4. (EXPERIMENTAL) Neighbor Profile Matrix

   Tabular file of coorelation values for all expressed genes in a dataset.  
   This is still experimental and is under development.

5. Dataset Accession Loaded from Dataset

   This must be provided with Profile Neighbors Matrix.
   The dataset accession loaded in the dataset step, ex. cicar1  
   This must match a dataset.accesion_no in the database.  
   The dataset accession_no must start with a letter and contain only A-z0-9.

### USAGE
```
usage: ongenome_loader.py [-h]
                          [--gff </path/to/my/datastore/organism/my_annotations.gff.gz>]
                          [--gfflist <file_of_organismgffs.txt>]
                          [--datasetmd <dataset.md>]
                          [--datasetxlsx <dataset.xlsx>]
                          [--counts <count_data.tsv>]
                          [--profile_neighbors <profile_neighbors.tsv>]
                          [--dataset_accession <dataset.accession_no>]
                          [--logger </path/to/log/my_log.log>] [--drop_schema]
                          [--load_schema <my_schema.sql>]

***STILL IN DEVELOPMENT SOME FUNCTIONALITY NOT YET SUPPORTED***

Data loader for expression module OnGenome

Supports loading of data from the datastore using annotation gff files.  The information in these and the associated README.KEY.md files is checked against the Chado database and the user is warned if the expected namespaces do not yeild keys from chado.  Please change the log level to Error if you do not want to see the Warning or Info messages.

Datasets are loaded from either xlsx or md files.

Program Options:
  -h, --help            show this help message and exit
  --gff </path/to/my/datastore/organism/my_annotations.gff.gz>
                        Annotation file for this organism

  --gfflist <file_of_organismgffs.txt>
                        File containing annotation gff files; one per line

  --datasetmd <dataset.md>
                        Markdown file of dataset (See Sudhansu for now)

  --datasetxlsx <dataset.xlsx>
                        Excell file of dataset (See Sudhansu for now)

  --counts <count_data.tsv>
                        Count data tabular

  --profile_neighbors <profile_neighbors.tsv>
                        Tabular matrix of profile neighbor coorelations

  --dataset_accession <dataset.accession_no>
                        Dataset accesion to use to assocaite neighbor data. Ex: cicar1

  --logger </path/to/log/my_log.log>
                        Provide the path and file for the logger Default: ./ongenome.log.

  --drop_schema         Will drop the ongenome schema

  --load_schema <my_schema.sql>
                        Will load the provided schema
```

### Usage Examples

1. Load an Organism from the Datastore  
   ```
   python ongenome_loader.py --gff /usr/local/www/data/public/Cicer_arietinum/ICC4958.gnm2.ann1.LCVX/cicar.ICC4958.gnm2.ann1.LCVX.gene_function.gff3.gz  
   ```  
   This will load the organism, genome, and genemodel tables for cicar.ICC4958

2. Load a Dataset and Counts Information  
   ```
   python ongenome_loader.py --datasetxlsx /usr/local/www/data/private/Cicer_arietinum/expression_datasets/cicar-SRP017394-atlas-on-ICC4958_DataStoreFormat.xlsx --counts /usr/local/www/data/private/Cicer_arietinum/expression_datasets/cicar-SRP017394-on-ICC4958.gnm2.ann1_combinedSamplesTpm_uniquenameGene.tsv
   ```
   This will load datasetsource, dataset, sample, method and expression

3.  Load Profile Neighbors  
   ```
   python ongenome_loader.py --profile_neighbors /home/ccameron/ongenome/ongenome_schema/cor_matrix_df_rounded_corrected_names.tsv --dataset_accession cicar1
   ```
   This will create a new co-expression coorelations table for dataset cicar1


