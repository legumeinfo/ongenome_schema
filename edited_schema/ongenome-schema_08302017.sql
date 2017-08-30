--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: ongenome; Type: SCHEMA; Schema: -; Owner: www
--

CREATE SCHEMA ongenome;


ALTER SCHEMA ongenome OWNER TO www;

SET search_path = ongenome, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cicar1_test_profile_neighbors; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE cicar1_test_profile_neighbors (
    profileneighbor_id bigint NOT NULL,
    genemodel_id integer NOT NULL,
    target_id integer NOT NULL,
    coorelation numeric(13,3) NOT NULL,
    dataset_id integer NOT NULL
);


ALTER TABLE ongenome.cicar1_test_profile_neighbors OWNER TO www;

--
-- Name: cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq OWNER TO www;

--
-- Name: cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq OWNED BY cicar1_test_profile_neighbors.profileneighbor_id;


--
-- Name: dataset; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE dataset (
    dataset_id integer NOT NULL,
    genome_id integer NOT NULL,
    datasetsource_id integer NOT NULL,
    method_id integer NOT NULL,
    accession_no character varying(16),
    name character varying(250) NOT NULL,
    shortname character varying(64),
    description text,
    notes text,
    load_date timestamp without time zone
);


ALTER TABLE ongenome.dataset OWNER TO www;

--
-- Name: dataset_dataset_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE dataset_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.dataset_dataset_id_seq OWNER TO www;

--
-- Name: dataset_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE dataset_dataset_id_seq OWNED BY dataset.dataset_id;


--
-- Name: dataset_sample; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE dataset_sample (
    dataset_sample_id integer NOT NULL,
    dataset_id integer NOT NULL,
    sample_id integer NOT NULL
);


ALTER TABLE ongenome.dataset_sample OWNER TO www;

--
-- Name: dataset_sample_dataset_sample_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE dataset_sample_dataset_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.dataset_sample_dataset_sample_id_seq OWNER TO www;

--
-- Name: dataset_sample_dataset_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE dataset_sample_dataset_sample_id_seq OWNED BY dataset_sample.dataset_sample_id;


--
-- Name: datasetsource; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE datasetsource (
    datasetsource_id integer NOT NULL,
    name text NOT NULL,
    shortname character varying(250) NOT NULL,
    origin character varying(32),
    description text,
    bioproj_acc character varying(32),
    bioproj_title character varying(250),
    bioproj_description text,
    sra_proj_acc character varying(32),
    geo_series character varying(32),
    notes text
);


ALTER TABLE ongenome.datasetsource OWNER TO www;

--
-- Name: datasetsource_datasetsource_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE datasetsource_datasetsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.datasetsource_datasetsource_id_seq OWNER TO www;

--
-- Name: datasetsource_datasetsource_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE datasetsource_datasetsource_id_seq OWNED BY datasetsource.datasetsource_id;


--
-- Name: expressiondata; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE expressiondata (
    expressiondata_id integer NOT NULL,
    genemodel_id integer NOT NULL,
    dataset_id integer NOT NULL,
    dataset_sample_id integer NOT NULL,
    exp_value_type character varying(16),
    exp_value numeric(13,3)
);


ALTER TABLE ongenome.expressiondata OWNER TO www;

--
-- Name: expressiondata_expressiondata_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE expressiondata_expressiondata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.expressiondata_expressiondata_id_seq OWNER TO www;

--
-- Name: expressiondata_expressiondata_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE expressiondata_expressiondata_id_seq OWNED BY expressiondata.expressiondata_id;


--
-- Name: genemodel; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE genemodel (
    genemodel_id integer NOT NULL,
    genome_id integer NOT NULL,
    genemodel_name character varying(32) NOT NULL,
    chado_uniquename character varying(64)
);


ALTER TABLE ongenome.genemodel OWNER TO www;

--
-- Name: genemodel_genemodel_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE genemodel_genemodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.genemodel_genemodel_id_seq OWNER TO www;

--
-- Name: genemodel_genemodel_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE genemodel_genemodel_id_seq OWNED BY genemodel.genemodel_id;


--
-- Name: genome; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE genome (
    genome_id integer NOT NULL,
    name character varying(250) NOT NULL,
    shortname character varying(64) NOT NULL,
    description text,
    source character varying(32),
    build character varying(16),
    annotation character varying(16),
    organism_id integer NOT NULL,
    notes text,
    chado_id integer
);


ALTER TABLE ongenome.genome OWNER TO www;

--
-- Name: genome_genome_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE genome_genome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.genome_genome_id_seq OWNER TO www;

--
-- Name: genome_genome_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE genome_genome_id_seq OWNED BY genome.genome_id;


--
-- Name: method; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE method (
    method_id integer NOT NULL,
    name character varying(250),
    shortname character varying(64),
    version character varying(32),
    analysis_date date,
    description text,
    details text,
    notes text
);


ALTER TABLE ongenome.method OWNER TO www;

--
-- Name: method_method_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE method_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.method_method_id_seq OWNER TO www;

--
-- Name: method_method_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE method_method_id_seq OWNED BY method.method_id;


--
-- Name: organism; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE organism (
    organism_id integer NOT NULL,
    chado_organism_id integer,
    name character varying(250) NOT NULL,
    genus character varying(32),
    species character varying(32),
    subspecies character varying(32),
    cultivar_type character varying(32),
    line character varying(32),
    abbrev character varying(16),
    common_name character varying(32),
    synonyms text,
    description text,
    notes text
);


ALTER TABLE ongenome.organism OWNER TO www;

--
-- Name: organism_organism_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE organism_organism_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.organism_organism_id_seq OWNER TO www;

--
-- Name: organism_organism_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE organism_organism_id_seq OWNED BY organism.organism_id;


--
-- Name: profileneighbors_cicar1; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE profileneighbors_cicar1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_cicar1 OWNER TO www;

--
-- Name: profileneighbors_phavu1; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE profileneighbors_phavu1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_phavu1 OWNER TO www;

--
-- Name: profileneighbors_phavu1_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_phavu1_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_phavu1_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq OWNED BY profileneighbors_phavu1.profileneighbors_id;


--
-- Name: profileneighbors_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE profileneighbors_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE profileneighbors_profileneighbors_id_seq OWNED BY profileneighbors_cicar1.profileneighbors_id;


--
-- Name: sample; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE sample (
    sample_id integer NOT NULL,
    datasetsource_id integer NOT NULL,
    organism_id integer NOT NULL,
    sample_uniquename character varying(128) NOT NULL,
    name character varying(250),
    shortname character varying(48),
    description text,
    age character varying(32),
    dev_stage character varying(32),
    plant_part character varying(32),
    treatment character varying(128),
    other_attributes text,
    ncbi_accessions text,
    notes text
);


ALTER TABLE ongenome.sample OWNER TO www;

--
-- Name: sample_sample_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE sample_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.sample_sample_id_seq OWNER TO www;

--
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- Name: treatment; Type: TABLE; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE TABLE treatment (
    treatment_id integer NOT NULL,
    dataset_id integer,
    rep_count integer
);


ALTER TABLE ongenome.treatment OWNER TO www;

--
-- Name: treatment_treatment_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE treatment_treatment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.treatment_treatment_id_seq OWNER TO www;

--
-- Name: treatment_treatment_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE treatment_treatment_id_seq OWNED BY treatment.treatment_id;


--
-- Name: profileneighbor_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY cicar1_test_profile_neighbors ALTER COLUMN profileneighbor_id SET DEFAULT nextval('cicar1_test_profile_neighbors_profileneighbor_id_seq'::regclass);


--
-- Name: dataset_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset ALTER COLUMN dataset_id SET DEFAULT nextval('dataset_dataset_id_seq'::regclass);


--
-- Name: dataset_sample_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset_sample ALTER COLUMN dataset_sample_id SET DEFAULT nextval('dataset_sample_dataset_sample_id_seq'::regclass);


--
-- Name: datasetsource_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY datasetsource ALTER COLUMN datasetsource_id SET DEFAULT nextval('datasetsource_datasetsource_id_seq'::regclass);


--
-- Name: expressiondata_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY expressiondata ALTER COLUMN expressiondata_id SET DEFAULT nextval('expressiondata_expressiondata_id_seq'::regclass);


--
-- Name: genemodel_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY genemodel ALTER COLUMN genemodel_id SET DEFAULT nextval('genemodel_genemodel_id_seq'::regclass);


--
-- Name: genome_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY genome ALTER COLUMN genome_id SET DEFAULT nextval('genome_genome_id_seq'::regclass);


--
-- Name: method_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY method ALTER COLUMN method_id SET DEFAULT nextval('method_method_id_seq'::regclass);


--
-- Name: organism_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY organism ALTER COLUMN organism_id SET DEFAULT nextval('organism_organism_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY profileneighbors_cicar1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('profileneighbors_profileneighbors_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY profileneighbors_phavu1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('profileneighbors_phavu1_profileneighbors_id_seq'::regclass);


--
-- Name: sample_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- Name: treatment_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY treatment ALTER COLUMN treatment_id SET DEFAULT nextval('treatment_treatment_id_seq'::regclass);


--
-- Name: cicar1_test_profile_neighbors_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY cicar1_test_profile_neighbors
    ADD CONSTRAINT cicar1_test_profile_neighbors_pkey PRIMARY KEY (profileneighbor_id);


--
-- Name: dataset_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT dataset_pkey PRIMARY KEY (dataset_id);


--
-- Name: dataset_sample_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY dataset_sample
    ADD CONSTRAINT dataset_sample_pkey PRIMARY KEY (dataset_sample_id);


--
-- Name: datasetsource_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY datasetsource
    ADD CONSTRAINT datasetsource_pkey PRIMARY KEY (datasetsource_id);


--
-- Name: expressiondata_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY expressiondata
    ADD CONSTRAINT expressiondata_pkey PRIMARY KEY (expressiondata_id);


--
-- Name: genemodel_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY genemodel
    ADD CONSTRAINT genemodel_pkey PRIMARY KEY (genemodel_id);


--
-- Name: genome_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY genome
    ADD CONSTRAINT genome_pkey PRIMARY KEY (genome_id);


--
-- Name: method_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY method
    ADD CONSTRAINT method_pkey PRIMARY KEY (method_id);


--
-- Name: organism_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY organism
    ADD CONSTRAINT organism_pkey PRIMARY KEY (organism_id);


--
-- Name: profileneighbors_phavu1_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY profileneighbors_phavu1
    ADD CONSTRAINT profileneighbors_phavu1_pkey PRIMARY KEY (profileneighbors_id);


--
-- Name: sample_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_pkey PRIMARY KEY (sample_id);


--
-- Name: treatment_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www; Tablespace: 
--

ALTER TABLE ONLY treatment
    ADD CONSTRAINT treatment_pkey PRIMARY KEY (treatment_id);


--
-- Name: cicar1_test_profile_neighbors_dataset_id_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX cicar1_test_profile_neighbors_dataset_id_idx ON cicar1_test_profile_neighbors USING btree (dataset_id);


--
-- Name: cicar1_test_profile_neighbors_genemodel_id_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX cicar1_test_profile_neighbors_genemodel_id_idx ON cicar1_test_profile_neighbors USING btree (genemodel_id);


--
-- Name: dataset_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX dataset_name_idx ON dataset USING btree (name);


--
-- Name: dataset_name_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX dataset_name_idx1 ON dataset USING btree (name);


--
-- Name: dataset_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX dataset_shortname_idx ON dataset USING btree (shortname);


--
-- Name: dataset_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX dataset_shortname_idx1 ON dataset USING btree (shortname);


--
-- Name: datasetsource_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX datasetsource_name_idx ON datasetsource USING btree (name);


--
-- Name: datasetsource_name_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX datasetsource_name_idx1 ON datasetsource USING btree (name);


--
-- Name: datasetsource_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX datasetsource_shortname_idx ON datasetsource USING btree (shortname);


--
-- Name: datasetsource_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX datasetsource_shortname_idx1 ON datasetsource USING btree (shortname);


--
-- Name: expressiondata_dataset_id_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX expressiondata_dataset_id_idx ON expressiondata USING btree (dataset_id);


--
-- Name: expressiondata_dataset_sample_id_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX expressiondata_dataset_sample_id_idx ON expressiondata USING btree (dataset_sample_id);


--
-- Name: expressiondata_genemodel_id_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX expressiondata_genemodel_id_idx ON expressiondata USING btree (genemodel_id);


--
-- Name: genemodel_genemodel_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genemodel_genemodel_name_idx ON genemodel USING btree (genemodel_name);


--
-- Name: genome_annotation_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_annotation_idx ON genome USING btree (annotation);


--
-- Name: genome_annotation_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_annotation_idx1 ON genome USING btree (annotation);


--
-- Name: genome_build_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_build_idx ON genome USING btree (build);


--
-- Name: genome_build_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_build_idx1 ON genome USING btree (build);


--
-- Name: genome_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_name_idx ON genome USING btree (name);


--
-- Name: genome_name_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX genome_name_idx1 ON genome USING btree (name);


--
-- Name: method_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX method_name_idx ON method USING btree (name);


--
-- Name: method_name_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX method_name_idx1 ON method USING btree (name);


--
-- Name: method_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX method_shortname_idx ON method USING btree (shortname);


--
-- Name: method_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX method_shortname_idx1 ON method USING btree (shortname);


--
-- Name: organism_name_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX organism_name_idx ON organism USING btree (name);


--
-- Name: organism_name_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX organism_name_idx1 ON organism USING btree (name);


--
-- Name: profileneighbors_phavu1_genemodel_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE UNIQUE INDEX profileneighbors_phavu1_genemodel_uniquename_idx ON profileneighbors_phavu1 USING btree (genemodel_uniquename);


--
-- Name: sample_sample_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX sample_sample_uniquename_idx ON sample USING btree (sample_uniquename);


--
-- Name: sample_sample_uniquename_idx1; Type: INDEX; Schema: ongenome; Owner: www; Tablespace: 
--

CREATE INDEX sample_sample_uniquename_idx1 ON sample USING btree (sample_uniquename);


--
-- Name: cicar1_test_profile_neighbors_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY cicar1_test_profile_neighbors
    ADD CONSTRAINT cicar1_test_profile_neighbors_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES dataset(dataset_id);


--
-- Name: dataset_datasetsource_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT dataset_datasetsource_id_fkey FOREIGN KEY (datasetsource_id) REFERENCES datasetsource(datasetsource_id);


--
-- Name: dataset_genome_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT dataset_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES genome(genome_id);


--
-- Name: dataset_method_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset
    ADD CONSTRAINT dataset_method_id_fkey FOREIGN KEY (method_id) REFERENCES method(method_id);


--
-- Name: dataset_sample_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset_sample
    ADD CONSTRAINT dataset_sample_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES dataset(dataset_id);


--
-- Name: dataset_sample_sample_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY dataset_sample
    ADD CONSTRAINT dataset_sample_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES sample(sample_id);


--
-- Name: expressiondata_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY expressiondata
    ADD CONSTRAINT expressiondata_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES dataset(dataset_id);


--
-- Name: expressiondata_genemodel_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY expressiondata
    ADD CONSTRAINT expressiondata_genemodel_id_fkey FOREIGN KEY (genemodel_id) REFERENCES genemodel(genemodel_id);


--
-- Name: genemodel_genome_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY genemodel
    ADD CONSTRAINT genemodel_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES genome(genome_id);


--
-- Name: genome_organism_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY genome
    ADD CONSTRAINT genome_organism_id_fkey FOREIGN KEY (organism_id) REFERENCES organism(organism_id);


--
-- Name: sample_datasetsource_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_datasetsource_id_fkey FOREIGN KEY (datasetsource_id) REFERENCES datasetsource(datasetsource_id);


--
-- Name: sample_organism_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_organism_id_fkey FOREIGN KEY (organism_id) REFERENCES organism(organism_id);


--
-- Name: treatment_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY treatment
    ADD CONSTRAINT treatment_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES dataset(dataset_id);


--
-- Name: cicar1_test_profile_neighbors; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE cicar1_test_profile_neighbors FROM PUBLIC;
REVOKE ALL ON TABLE cicar1_test_profile_neighbors FROM www;
GRANT ALL ON TABLE cicar1_test_profile_neighbors TO www;
GRANT ALL ON TABLE cicar1_test_profile_neighbors TO staff;


--
-- Name: cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq FROM www;
GRANT ALL ON SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq TO www;
GRANT ALL ON SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq TO staff;


--
-- Name: dataset; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE dataset FROM PUBLIC;
REVOKE ALL ON TABLE dataset FROM www;
GRANT ALL ON TABLE dataset TO www;
GRANT ALL ON TABLE dataset TO staff;


--
-- Name: dataset_dataset_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE dataset_dataset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dataset_dataset_id_seq FROM www;
GRANT ALL ON SEQUENCE dataset_dataset_id_seq TO www;
GRANT ALL ON SEQUENCE dataset_dataset_id_seq TO staff;


--
-- Name: dataset_sample; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE dataset_sample FROM PUBLIC;
REVOKE ALL ON TABLE dataset_sample FROM www;
GRANT ALL ON TABLE dataset_sample TO www;
GRANT ALL ON TABLE dataset_sample TO staff;


--
-- Name: dataset_sample_dataset_sample_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE dataset_sample_dataset_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE dataset_sample_dataset_sample_id_seq FROM www;
GRANT ALL ON SEQUENCE dataset_sample_dataset_sample_id_seq TO www;
GRANT ALL ON SEQUENCE dataset_sample_dataset_sample_id_seq TO staff;


--
-- Name: datasetsource; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE datasetsource FROM PUBLIC;
REVOKE ALL ON TABLE datasetsource FROM www;
GRANT ALL ON TABLE datasetsource TO www;
GRANT ALL ON TABLE datasetsource TO staff;


--
-- Name: datasetsource_datasetsource_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE datasetsource_datasetsource_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE datasetsource_datasetsource_id_seq FROM www;
GRANT ALL ON SEQUENCE datasetsource_datasetsource_id_seq TO www;
GRANT ALL ON SEQUENCE datasetsource_datasetsource_id_seq TO staff;


--
-- Name: expressiondata; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE expressiondata FROM PUBLIC;
REVOKE ALL ON TABLE expressiondata FROM www;
GRANT ALL ON TABLE expressiondata TO www;
GRANT ALL ON TABLE expressiondata TO staff;


--
-- Name: expressiondata_expressiondata_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE expressiondata_expressiondata_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE expressiondata_expressiondata_id_seq FROM www;
GRANT ALL ON SEQUENCE expressiondata_expressiondata_id_seq TO www;
GRANT ALL ON SEQUENCE expressiondata_expressiondata_id_seq TO staff;


--
-- Name: genemodel; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE genemodel FROM PUBLIC;
REVOKE ALL ON TABLE genemodel FROM www;
GRANT ALL ON TABLE genemodel TO www;
GRANT ALL ON TABLE genemodel TO staff;


--
-- Name: genemodel_genemodel_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE genemodel_genemodel_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE genemodel_genemodel_id_seq FROM www;
GRANT ALL ON SEQUENCE genemodel_genemodel_id_seq TO www;
GRANT ALL ON SEQUENCE genemodel_genemodel_id_seq TO staff;


--
-- Name: genome; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE genome FROM PUBLIC;
REVOKE ALL ON TABLE genome FROM www;
GRANT ALL ON TABLE genome TO www;
GRANT ALL ON TABLE genome TO staff;


--
-- Name: genome_genome_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE genome_genome_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE genome_genome_id_seq FROM www;
GRANT ALL ON SEQUENCE genome_genome_id_seq TO www;
GRANT ALL ON SEQUENCE genome_genome_id_seq TO staff;


--
-- Name: method; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE method FROM PUBLIC;
REVOKE ALL ON TABLE method FROM www;
GRANT ALL ON TABLE method TO www;
GRANT ALL ON TABLE method TO staff;


--
-- Name: method_method_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE method_method_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE method_method_id_seq FROM www;
GRANT ALL ON SEQUENCE method_method_id_seq TO www;
GRANT ALL ON SEQUENCE method_method_id_seq TO staff;


--
-- Name: organism; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE organism FROM PUBLIC;
REVOKE ALL ON TABLE organism FROM www;
GRANT ALL ON TABLE organism TO www;
GRANT ALL ON TABLE organism TO staff;


--
-- Name: organism_organism_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE organism_organism_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE organism_organism_id_seq FROM www;
GRANT ALL ON SEQUENCE organism_organism_id_seq TO www;
GRANT ALL ON SEQUENCE organism_organism_id_seq TO staff;


--
-- Name: profileneighbors_cicar1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE profileneighbors_cicar1 FROM PUBLIC;
REVOKE ALL ON TABLE profileneighbors_cicar1 FROM www;
GRANT ALL ON TABLE profileneighbors_cicar1 TO www;
GRANT ALL ON TABLE profileneighbors_cicar1 TO staff;


--
-- Name: profileneighbors_phavu1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE profileneighbors_phavu1 FROM PUBLIC;
REVOKE ALL ON TABLE profileneighbors_phavu1 FROM www;
GRANT ALL ON TABLE profileneighbors_phavu1 TO www;
GRANT ALL ON TABLE profileneighbors_phavu1 TO staff;


--
-- Name: profileneighbors_phavu1_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq TO staff;


--
-- Name: profileneighbors_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE profileneighbors_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE profileneighbors_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE profileneighbors_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE profileneighbors_profileneighbors_id_seq TO staff;


--
-- Name: sample; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE sample FROM PUBLIC;
REVOKE ALL ON TABLE sample FROM www;
GRANT ALL ON TABLE sample TO www;
GRANT ALL ON TABLE sample TO staff;


--
-- Name: sample_sample_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE sample_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sample_sample_id_seq FROM www;
GRANT ALL ON SEQUENCE sample_sample_id_seq TO www;
GRANT ALL ON SEQUENCE sample_sample_id_seq TO staff;


--
-- Name: treatment; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE treatment FROM PUBLIC;
REVOKE ALL ON TABLE treatment FROM www;
GRANT ALL ON TABLE treatment TO www;
GRANT ALL ON TABLE treatment TO staff;


--
-- Name: treatment_treatment_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE treatment_treatment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE treatment_treatment_id_seq FROM www;
GRANT ALL ON SEQUENCE treatment_treatment_id_seq TO www;
GRANT ALL ON SEQUENCE treatment_treatment_id_seq TO staff;


--
-- PostgreSQL database dump complete
--

