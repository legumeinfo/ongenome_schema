--Printed from extract-sql-from-sql.puml.txt-file.pl
-- Need to go through file thoroughly before using the SQL statements.



/*
The sql file is being modified to generate UML diagram:
   sql portions are commented out.
   Schema Name: ongenome (ongenome => "On a Reference Genome". Anything that can be measured, mapped or assessed on a reference genome, this ongenome schema should be able to accommodate it with some modification.  This started as genexp, gene expression schema and found to be also suitable for a broader purpose.)
*/
/*
Extract the SQL Create Table statements from this file using:
<$> cat ongenome-schema.sql.puml.txt | perl extract-sql-from-sql.puml.txt-file.pl > ongenome-schema.sql

Generate Schema Dagram (.png):
<$> java -jar  /Applications/plantuml.jar  ongenome-schema.sql.puml.txt
Creates ongenome-schema.sql.puml.png
<$> open ongenome-schema.sql.puml.png
*/


-- schema: ongenome in database sdashtest
CREATE SCHEMA IF NOT EXISTS ongenome;


-- Tables:
-- --------


-- 1. organism

CREATE TABLE IF NOT EXISTS ongenome.organism (
  organism_id SERIAL NOT NULL, -- Pr
  chado_organism_id INTEGER,  --  relates to chado schema
  name VARCHAR(250) NOT NULL,  --  unique name to lookup genome by 
  genus VARCHAR(32),
  species VARCHAR(32),
  subspecies VARCHAR(32),
  cultivar_type VARCHAR(32),
  line VARCHAR(32),
  abbrev VARCHAR(16),  -- ex: phavu, cicar_kabuli, cicar_desi, etc.
  common_name VARCHAR(32),
  synonyms TEXT,
  description TEXT,
  notes TEXT,
  PRIMARY KEY (organism_id)
);
CREATE INDEX ON ongenome.organism (name);


-- 2. datasetsource
/*
Defines the primary dataset source of a dataset uses with description. The same datasetsource could be used by different datasets by using anaother method and/or genome.

datasource one to many dataset;
*/

CREATE TABLE IF NOT EXISTS  ongenome.datasetsource (
  datasetsource_id SERIAL NOT NULL, -- Pr
  name TEXT NOT NULL, -- 250 char
  shortname VARCHAR(250) NOT NULL,  -- 64 char
  origin VARCHAR(32), -- ex. SRA, GEO, A labname, etc.
  description TEXT,  -- text
  bioproj_acc VARCHAR(32),  -- from ncbi, 32 char
  bioproj_title VARCHAR(250),  -- from ncbi, 250 char
  bioproj_description TEXT,  -- from ncbi, text
  sra_proj_acc VARCHAR(32),  -- SRP No. from ncbi, char 32
  geo_series VARCHAR(32), -- GSE# if exists
  notes TEXT, -- text, curatorial notes
  PRIMARY KEY (datasetsource_id)
);
CREATE INDEX ON ongenome.datasetsource (name);
CREATE INDEX ON ongenome.datasetsource (shortname);

-- 3. method
/*
  Describes the method used for data analysis.
*/

CREATE TABLE IF NOT EXISTS  ongenome.method (
  method_id SERIAL NOT NULL,  --Pr
  name VARCHAR(250),  -- 250 char
  shortname VARCHAR(64), -- 64 char
  version VARCHAR(32),  -- 32 char
  analysis_date DATE,  -- date analysis performed
  description TEXT, -- text, just enough for display
  details TEXT,  --text, all other details
  notes TEXT,  -- text, curatorial
  PRIMARY KEY (method_id)
);
CREATE INDEX ON ongenome.method (name);

-- 4. genome
/*
Defines a 'genome build version and annotation version combination' for an organism. A dataset maps the reads from samples of a datasetsource to this genome version. When the same datasource maps the reads to anoter genome, it becomes a different dataset.

genome one to many dataset;
*/

CREATE TABLE IF NOT EXISTS  ongenome.genome (
  genome_id SERIAL NOT NULL, -- Pr
  name VARCHAR(250) NOT NULL, -- 250 char
  shortname VARCHAR(64) NOT NULL, -- 64 char
  description TEXT, -- text
  source VARCHAR(32), -- 32 char (the genome source cv/line/strain sequenced)
  build VARCHAR(16),  -- build version; 16 char
  annotation VARCHAR(16),  -- annotation version; 16 char
  organism_id INTEGER NOT NULL, --FK
  notes TEXT,  -- text, curatorial
  chado_id INTEGER,  -- Chado equivalent id for the genome
  PRIMARY KEY (genome_id),
  FOREIGN KEY (organism_id) REFERENCES ongenome.organism(organism_id)
);
CREATE INDEX ON ongenome.genome (name);
CREATE INDEX ON ongenome.genome (build);
CREATE INDEX ON ongenome.genome (annotation);

-- 5. genemodel
/*The genemodel IDs from a genome build annaotation. They will be reused in many datasets referencing to the genome.*/

CREATE TABLE IF NOT EXISTS  ongenome.genemodel (
   genemodel_id SERIAL NOT NULL, -- Pr
   genome_id INTEGER NOT NULL, -- FK
   genemodel_name VARCHAR(32) NOT NULL,  -- The name that needs to be displayed
   chado_uniquename VARCHAR(64), -- Chado.feature.uniquename (know one to be 41 char)
   PRIMARY KEY (genemodel_id),
   FOREIGN KEY (genome_id) REFERENCES ongenome.genome(genome_id)
);
CREATE INDEX ON ongenome.genemodel (genemodel_name);

 -- tripr.MilvusB.v2.Tp57577_TGAC_v2_gene243 (41 char); 
 --    vigan.Gyeongwon.v3.Vang0197s00120 (33 char) 

-- 6. sample
/*
The list and description of samples used in a dataset. A dataset will consist of many individual samples. A set samples can go into multiple datasets.

many datasets to many samples;
*/

CREATE TABLE IF NOT EXISTS  ongenome.sample (
  sample_id SERIAL NOT NULL, -- Pr
  datasetsource_id INTEGER NOT NULL, --  FK; part of which datasetsource
  organism_id INTEGER NOT NULL, --FK
  sample_uniquename VARCHAR(128) NOT NULL,
  name VARCHAR(250),  -- 250 char
  shortname VARCHAR(48), -- 48 char, serves as label
  description TEXT, -- text
  age VARCHAR(32),
  dev_stage VARCHAR(32),
  plant_part VARCHAR(32),  -- tissue, organ, whole plant, seedling, etc.
  treatment VARCHAR(128),  -- treatment the plant has undergone
  other_attributes TEXT, -- ';' separated key:value pairs; think about allowing quotes(`"`) in value
  ncbi_accessions TEXT, -- ';' separated key:value pairs; ex: sra_run:SRR#;sra_sample:SAMP#; etc.
  notes TEXT,  -- Curatorial
  PRIMARY KEY (sample_id),
  FOREIGN KEY (datasetsource_id) REFERENCES ongenome.datasetsource(datasetsource_id),
  FOREIGN KEY (organism_id) REFERENCES ongenome.organism(organism_id)
);
CREATE INDEX ON ongenome.sample (sample_uniquename);
--CREATE INDEX ON ongenome.sample (shortname);


-- 7. dataset
/*
A specific dataset which uses data from a primary datasetsource, uses a specific analysis method and relates to a specfic genome version (build and annotation version).
dataset many to one datasource; dataset many to one genome; dataset many to one method.
*/

CREATE TABLE  IF NOT EXISTS  ongenome.dataset (
  dataset_id serial NOT NULL, -- Pr
  genome_id INTEGER NOT NULL, -- FK
  datasetsource_id INTEGER NOT NULL, -- FK
  method_id INTEGER NOT NULL, -- FK
  accession_no VARCHAR(16) ,  -- ex. phavu1, cicar3, aradu1
  name VARCHAR(250) NOT NULL,  --250 char
  shortname VARCHAR(64), -- 64 char (?? =accession_no)
  description TEXT, -- text
  notes TEXT, -- text, curatorial notes
  load_date TIMESTAMP,  -- date dataset loaded (? necessary)
  PRIMARY KEY (dataset_id),
  FOREIGN KEY (genome_id) REFERENCES ongenome.genome(genome_id),
  FOREIGN KEY (datasetsource_id) REFERENCES ongenome.datasetsource(datasetsource_id),
  FOREIGN KEY (method_id) REFERENCES ongenome.method(method_id)
);
CREATE INDEX ON ongenome.dataset (name);


-- 8.  dataset_sample  table
/*
The main link table that connects the expression data to dataset, sample and treatment tables
*/
CREATE TABLE IF NOT EXISTS  ongenome.dataset_sample (
  dataset_sample_id SERIAL NOT NULL,  -- Pr
  dataset_id INTEGER NOT NULL, --FK
  sample_id INTEGER NOT NULL,  --FK
--  treatment_id INT,  --FK
  PRIMARY KEY (dataset_sample_id),
  FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id),
  FOREIGN KEY (sample_id) REFERENCES ongenome.sample(sample_id)
  /*
  FOREIGN KEY (treatment_id) REFERENCES ongenome.treatment(treatment_id)
  --Think and do later
  */
);



-- 9. expressiondata(main table)
/*
The main table that stores the expression data.
A gene_id for a dataset for a sample has an expression value.
*/
CREATE TABLE IF NOT EXISTS  ongenome.expressiondata (
  expressiondata_id SERIAL NOT NULL, -- Pr
  genemodel_id INTEGER NOT NULL,  -- FK
  dataset_id INTEGER NOT NULL,  -- FK
  dataset_sample_id INTEGER NOT NULL,  -- FK; links to sample_id and treatment_id
  exp_value_type VARCHAR(16),  -- ex: tpm, rpkm, raw count, etc.
  exp_value NUMERIC(13,3),  -- expression value
  PRIMARY KEY (expressiondata_id),
  FOREIGN KEY (genemodel_id) REFERENCES ongenome.genemodel(genemodel_id),
  FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id)
);

 --EXPTDESIGN 

  -- A. treatment

  CREATE TABLE IF NOT EXISTS ongenome.treatment(
    treatment_id SERIAL NOT NULL, -- Pr
    dataset_id INTEGER, -- FK
    rep_count INTEGER,
    PRIMARY KEY (treatment_id),
    FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id)
  );


  -- B. factor

  CREATE TABLE IF NOT EXISTS factor (
    factor_id SERIAL NOT NULL,
    factor_name VARCHAR(32),
    factor_order INTEGER,
    dataset_id  INTEGER,
    PRIMARY KEY (factor_id),
    FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id)
  );


  -- C. factor_level

  CREATE TABLE IF NOT EXISTS factor_level (
    factor_level_id SERIAL NOT NULL,  -- Pr
    dataset_id INT, --FK
    factor_name VARCHAR(32),  -- =factor.factor_name
    factor_level_name VARCHAR(32),
    factor_level_order INT,
    PRIMARY KEY (factor_level_id),
    FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id)
  );

