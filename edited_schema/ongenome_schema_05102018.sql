--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.12
-- Dumped by pg_dump version 9.5.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ongenome; Type: SCHEMA; Schema: -; Owner: www
--

CREATE SCHEMA ongenome;


ALTER SCHEMA ongenome OWNER TO www;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cicar1_test_profile_neighbors; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.cicar1_test_profile_neighbors (
    profileneighbor_id bigint NOT NULL,
    genemodel_uniquename character varying(64) NOT NULL,
    target_uniquename character varying(64) NOT NULL,
    coorelation numeric(13,3) NOT NULL,
    dataset_id integer NOT NULL
);


ALTER TABLE ongenome.cicar1_test_profile_neighbors OWNER TO www;

--
-- Name: cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq OWNER TO www;

--
-- Name: cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq OWNED BY ongenome.cicar1_test_profile_neighbors.profileneighbor_id;


--
-- Name: copy_profileneighbors_cicar1; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.copy_profileneighbors_cicar1 (
    profileneighbors_id integer,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.copy_profileneighbors_cicar1 OWNER TO www;

--
-- Name: copygenemodel; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.copygenemodel (
    genemodel_id integer,
    genome_id integer,
    genemodel_name character varying(64),
    chado_uniquename character varying(64)
);


ALTER TABLE ongenome.copygenemodel OWNER TO www;

--
-- Name: dataset; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.dataset (
    dataset_id integer NOT NULL,
    genome_id integer NOT NULL,
    datasetsource_id integer NOT NULL,
    method_id integer NOT NULL,
    accession_no character varying(16),
    name character varying(250) NOT NULL,
    shortname character varying(64),
    description text,
    notes text,
    load_date timestamp without time zone,
    exemplar character varying(64)
);


ALTER TABLE ongenome.dataset OWNER TO www;

--
-- Name: dataset_dataset_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.dataset_dataset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.dataset_dataset_id_seq OWNER TO www;

--
-- Name: dataset_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.dataset_dataset_id_seq OWNED BY ongenome.dataset.dataset_id;


--
-- Name: dataset_sample; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.dataset_sample (
    dataset_sample_id integer NOT NULL,
    dataset_id integer NOT NULL,
    sample_id integer NOT NULL
);


ALTER TABLE ongenome.dataset_sample OWNER TO www;

--
-- Name: dataset_sample_dataset_sample_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.dataset_sample_dataset_sample_id_seq OWNER TO www;

--
-- Name: dataset_sample_dataset_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq OWNED BY ongenome.dataset_sample.dataset_sample_id;


--
-- Name: datasetsource; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.datasetsource (
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

CREATE SEQUENCE ongenome.datasetsource_datasetsource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.datasetsource_datasetsource_id_seq OWNER TO www;

--
-- Name: datasetsource_datasetsource_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.datasetsource_datasetsource_id_seq OWNED BY ongenome.datasetsource.datasetsource_id;


--
-- Name: expressiondata; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.expressiondata (
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

CREATE SEQUENCE ongenome.expressiondata_expressiondata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.expressiondata_expressiondata_id_seq OWNER TO www;

--
-- Name: expressiondata_expressiondata_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.expressiondata_expressiondata_id_seq OWNED BY ongenome.expressiondata.expressiondata_id;


--
-- Name: genemodel; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.genemodel (
    genemodel_id integer NOT NULL,
    genome_id integer NOT NULL,
    genemodel_name character varying(64) NOT NULL,
    chado_uniquename character varying(64)
);


ALTER TABLE ongenome.genemodel OWNER TO www;

--
-- Name: genemodel_genemodel_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.genemodel_genemodel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.genemodel_genemodel_id_seq OWNER TO www;

--
-- Name: genemodel_genemodel_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.genemodel_genemodel_id_seq OWNED BY ongenome.genemodel.genemodel_id;


--
-- Name: genome; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.genome (
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

CREATE SEQUENCE ongenome.genome_genome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.genome_genome_id_seq OWNER TO www;

--
-- Name: genome_genome_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.genome_genome_id_seq OWNED BY ongenome.genome.genome_id;


--
-- Name: method; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.method (
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

CREATE SEQUENCE ongenome.method_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.method_method_id_seq OWNER TO www;

--
-- Name: method_method_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.method_method_id_seq OWNED BY ongenome.method.method_id;


--
-- Name: organism; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.organism (
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

CREATE SEQUENCE ongenome.organism_organism_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.organism_organism_id_seq OWNER TO www;

--
-- Name: organism_organism_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.organism_organism_id_seq OWNED BY ongenome.organism.organism_id;


--
-- Name: profileneighbors_cajca1; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.profileneighbors_cajca1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_cajca1 OWNER TO www;

--
-- Name: profileneighbors_cajca1_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_cajca1_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_cajca1_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq OWNED BY ongenome.profileneighbors_cajca1.profileneighbors_id;


--
-- Name: profileneighbors_cicar1; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.profileneighbors_cicar1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_cicar1 OWNER TO www;

--
-- Name: profileneighbors_phavu1; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.profileneighbors_phavu1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_phavu1 OWNER TO www;

--
-- Name: profileneighbors_phavu1_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_phavu1_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_phavu1_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq OWNED BY ongenome.profileneighbors_phavu1.profileneighbors_id;


--
-- Name: profileneighbors_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq OWNED BY ongenome.profileneighbors_cicar1.profileneighbors_id;


--
-- Name: profileneighbors_vigun1; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.profileneighbors_vigun1 (
    profileneighbors_id integer NOT NULL,
    genemodel_uniquename character varying(64),
    dataset_id integer,
    profile_neighbors text
);


ALTER TABLE ongenome.profileneighbors_vigun1 OWNER TO www;

--
-- Name: profileneighbors_vigun1_profileneighbors_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.profileneighbors_vigun1_profileneighbors_id_seq OWNER TO www;

--
-- Name: profileneighbors_vigun1_profileneighbors_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq OWNED BY ongenome.profileneighbors_vigun1.profileneighbors_id;


--
-- Name: sample; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.sample (
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

CREATE SEQUENCE ongenome.sample_sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.sample_sample_id_seq OWNER TO www;

--
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.sample_sample_id_seq OWNED BY ongenome.sample.sample_id;


--
-- Name: treatment; Type: TABLE; Schema: ongenome; Owner: www
--

CREATE TABLE ongenome.treatment (
    treatment_id integer NOT NULL,
    dataset_id integer,
    rep_count integer
);


ALTER TABLE ongenome.treatment OWNER TO www;

--
-- Name: treatment_treatment_id_seq; Type: SEQUENCE; Schema: ongenome; Owner: www
--

CREATE SEQUENCE ongenome.treatment_treatment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ongenome.treatment_treatment_id_seq OWNER TO www;

--
-- Name: treatment_treatment_id_seq; Type: SEQUENCE OWNED BY; Schema: ongenome; Owner: www
--

ALTER SEQUENCE ongenome.treatment_treatment_id_seq OWNED BY ongenome.treatment.treatment_id;


--
-- Name: profileneighbor_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.cicar1_test_profile_neighbors ALTER COLUMN profileneighbor_id SET DEFAULT nextval('ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq'::regclass);


--
-- Name: dataset_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset ALTER COLUMN dataset_id SET DEFAULT nextval('ongenome.dataset_dataset_id_seq'::regclass);


--
-- Name: dataset_sample_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset_sample ALTER COLUMN dataset_sample_id SET DEFAULT nextval('ongenome.dataset_sample_dataset_sample_id_seq'::regclass);


--
-- Name: datasetsource_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.datasetsource ALTER COLUMN datasetsource_id SET DEFAULT nextval('ongenome.datasetsource_datasetsource_id_seq'::regclass);


--
-- Name: expressiondata_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.expressiondata ALTER COLUMN expressiondata_id SET DEFAULT nextval('ongenome.expressiondata_expressiondata_id_seq'::regclass);


--
-- Name: genemodel_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genemodel ALTER COLUMN genemodel_id SET DEFAULT nextval('ongenome.genemodel_genemodel_id_seq'::regclass);


--
-- Name: genome_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genome ALTER COLUMN genome_id SET DEFAULT nextval('ongenome.genome_genome_id_seq'::regclass);


--
-- Name: method_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.method ALTER COLUMN method_id SET DEFAULT nextval('ongenome.method_method_id_seq'::regclass);


--
-- Name: organism_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.organism ALTER COLUMN organism_id SET DEFAULT nextval('ongenome.organism_organism_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_cajca1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('ongenome.profileneighbors_cajca1_profileneighbors_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_cicar1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('ongenome.profileneighbors_profileneighbors_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_phavu1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('ongenome.profileneighbors_phavu1_profileneighbors_id_seq'::regclass);


--
-- Name: profileneighbors_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_vigun1 ALTER COLUMN profileneighbors_id SET DEFAULT nextval('ongenome.profileneighbors_vigun1_profileneighbors_id_seq'::regclass);


--
-- Name: sample_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.sample ALTER COLUMN sample_id SET DEFAULT nextval('ongenome.sample_sample_id_seq'::regclass);


--
-- Name: treatment_id; Type: DEFAULT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.treatment ALTER COLUMN treatment_id SET DEFAULT nextval('ongenome.treatment_treatment_id_seq'::regclass);


--
-- Name: cicar1_test_profile_neighbors_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.cicar1_test_profile_neighbors
    ADD CONSTRAINT cicar1_test_profile_neighbors_pkey PRIMARY KEY (profileneighbor_id);


--
-- Name: dataset_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset
    ADD CONSTRAINT dataset_pkey PRIMARY KEY (dataset_id);


--
-- Name: dataset_sample_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset_sample
    ADD CONSTRAINT dataset_sample_pkey PRIMARY KEY (dataset_sample_id);


--
-- Name: datasetsource_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.datasetsource
    ADD CONSTRAINT datasetsource_pkey PRIMARY KEY (datasetsource_id);


--
-- Name: expressiondata_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.expressiondata
    ADD CONSTRAINT expressiondata_pkey PRIMARY KEY (expressiondata_id);


--
-- Name: genemodel_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genemodel
    ADD CONSTRAINT genemodel_pkey PRIMARY KEY (genemodel_id);


--
-- Name: genome_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genome
    ADD CONSTRAINT genome_pkey PRIMARY KEY (genome_id);


--
-- Name: method_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.method
    ADD CONSTRAINT method_pkey PRIMARY KEY (method_id);


--
-- Name: organism_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.organism
    ADD CONSTRAINT organism_pkey PRIMARY KEY (organism_id);


--
-- Name: profileneighbors_cajca1_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_cajca1
    ADD CONSTRAINT profileneighbors_cajca1_pkey PRIMARY KEY (profileneighbors_id);


--
-- Name: profileneighbors_phavu1_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_phavu1
    ADD CONSTRAINT profileneighbors_phavu1_pkey PRIMARY KEY (profileneighbors_id);


--
-- Name: profileneighbors_vigun1_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.profileneighbors_vigun1
    ADD CONSTRAINT profileneighbors_vigun1_pkey PRIMARY KEY (profileneighbors_id);


--
-- Name: sample_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.sample
    ADD CONSTRAINT sample_pkey PRIMARY KEY (sample_id);


--
-- Name: treatment_pkey; Type: CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.treatment
    ADD CONSTRAINT treatment_pkey PRIMARY KEY (treatment_id);


--
-- Name: dataset_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX dataset_name_idx ON ongenome.dataset USING btree (name);


--
-- Name: dataset_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX dataset_name_idx1 ON ongenome.dataset USING btree (name);


--
-- Name: dataset_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX dataset_shortname_idx ON ongenome.dataset USING btree (shortname);


--
-- Name: dataset_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX dataset_shortname_idx1 ON ongenome.dataset USING btree (shortname);


--
-- Name: datasetsource_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX datasetsource_name_idx ON ongenome.datasetsource USING btree (name);


--
-- Name: datasetsource_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX datasetsource_name_idx1 ON ongenome.datasetsource USING btree (name);


--
-- Name: datasetsource_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX datasetsource_shortname_idx ON ongenome.datasetsource USING btree (shortname);


--
-- Name: datasetsource_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX datasetsource_shortname_idx1 ON ongenome.datasetsource USING btree (shortname);


--
-- Name: expressiondata_dataset_id_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX expressiondata_dataset_id_idx ON ongenome.expressiondata USING btree (dataset_id);


--
-- Name: expressiondata_dataset_sample_id_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX expressiondata_dataset_sample_id_idx ON ongenome.expressiondata USING btree (dataset_sample_id);


--
-- Name: expressiondata_genemodel_id_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX expressiondata_genemodel_id_idx ON ongenome.expressiondata USING btree (genemodel_id);


--
-- Name: genemodel_genemodel_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genemodel_genemodel_name_idx ON ongenome.genemodel USING btree (genemodel_name);


--
-- Name: genemodel_genemodel_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genemodel_genemodel_name_idx1 ON ongenome.genemodel USING btree (genemodel_name);


--
-- Name: genome_annotation_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_annotation_idx ON ongenome.genome USING btree (annotation);


--
-- Name: genome_annotation_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_annotation_idx1 ON ongenome.genome USING btree (annotation);


--
-- Name: genome_build_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_build_idx ON ongenome.genome USING btree (build);


--
-- Name: genome_build_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_build_idx1 ON ongenome.genome USING btree (build);


--
-- Name: genome_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_name_idx ON ongenome.genome USING btree (name);


--
-- Name: genome_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX genome_name_idx1 ON ongenome.genome USING btree (name);


--
-- Name: method_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX method_name_idx ON ongenome.method USING btree (name);


--
-- Name: method_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX method_name_idx1 ON ongenome.method USING btree (name);


--
-- Name: method_shortname_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX method_shortname_idx ON ongenome.method USING btree (shortname);


--
-- Name: method_shortname_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX method_shortname_idx1 ON ongenome.method USING btree (shortname);


--
-- Name: organism_name_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX organism_name_idx ON ongenome.organism USING btree (name);


--
-- Name: organism_name_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX organism_name_idx1 ON ongenome.organism USING btree (name);


--
-- Name: profileneighbors_cajca1_genemodel_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX profileneighbors_cajca1_genemodel_uniquename_idx ON ongenome.profileneighbors_cajca1 USING btree (genemodel_uniquename);


--
-- Name: profileneighbors_cicar1_genemodel_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE UNIQUE INDEX profileneighbors_cicar1_genemodel_uniquename_idx ON ongenome.profileneighbors_cicar1 USING btree (genemodel_uniquename);


--
-- Name: profileneighbors_phavu1_genemodel_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE UNIQUE INDEX profileneighbors_phavu1_genemodel_uniquename_idx ON ongenome.profileneighbors_phavu1 USING btree (genemodel_uniquename);


--
-- Name: profileneighbors_vigun1_genemodel_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX profileneighbors_vigun1_genemodel_uniquename_idx ON ongenome.profileneighbors_vigun1 USING btree (genemodel_uniquename);


--
-- Name: sample_sample_uniquename_idx; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX sample_sample_uniquename_idx ON ongenome.sample USING btree (sample_uniquename);


--
-- Name: sample_sample_uniquename_idx1; Type: INDEX; Schema: ongenome; Owner: www
--

CREATE INDEX sample_sample_uniquename_idx1 ON ongenome.sample USING btree (sample_uniquename);


--
-- Name: cicar1_test_profile_neighbors_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.cicar1_test_profile_neighbors
    ADD CONSTRAINT cicar1_test_profile_neighbors_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id);


--
-- Name: dataset_datasetsource_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset
    ADD CONSTRAINT dataset_datasetsource_id_fkey FOREIGN KEY (datasetsource_id) REFERENCES ongenome.datasetsource(datasetsource_id);


--
-- Name: dataset_genome_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset
    ADD CONSTRAINT dataset_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES ongenome.genome(genome_id);


--
-- Name: dataset_method_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset
    ADD CONSTRAINT dataset_method_id_fkey FOREIGN KEY (method_id) REFERENCES ongenome.method(method_id);


--
-- Name: dataset_sample_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset_sample
    ADD CONSTRAINT dataset_sample_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id);


--
-- Name: dataset_sample_sample_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.dataset_sample
    ADD CONSTRAINT dataset_sample_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES ongenome.sample(sample_id);


--
-- Name: expressiondata_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.expressiondata
    ADD CONSTRAINT expressiondata_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id);


--
-- Name: expressiondata_genemodel_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.expressiondata
    ADD CONSTRAINT expressiondata_genemodel_id_fkey FOREIGN KEY (genemodel_id) REFERENCES ongenome.genemodel(genemodel_id);


--
-- Name: genemodel_genome_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genemodel
    ADD CONSTRAINT genemodel_genome_id_fkey FOREIGN KEY (genome_id) REFERENCES ongenome.genome(genome_id);


--
-- Name: genome_organism_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.genome
    ADD CONSTRAINT genome_organism_id_fkey FOREIGN KEY (organism_id) REFERENCES ongenome.organism(organism_id);


--
-- Name: sample_datasetsource_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.sample
    ADD CONSTRAINT sample_datasetsource_id_fkey FOREIGN KEY (datasetsource_id) REFERENCES ongenome.datasetsource(datasetsource_id);


--
-- Name: sample_organism_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.sample
    ADD CONSTRAINT sample_organism_id_fkey FOREIGN KEY (organism_id) REFERENCES ongenome.organism(organism_id);


--
-- Name: treatment_dataset_id_fkey; Type: FK CONSTRAINT; Schema: ongenome; Owner: www
--

ALTER TABLE ONLY ongenome.treatment
    ADD CONSTRAINT treatment_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES ongenome.dataset(dataset_id);


--
-- Name: TABLE cicar1_test_profile_neighbors; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.cicar1_test_profile_neighbors FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.cicar1_test_profile_neighbors FROM www;
GRANT ALL ON TABLE ongenome.cicar1_test_profile_neighbors TO www;
GRANT ALL ON TABLE ongenome.cicar1_test_profile_neighbors TO staff;


--
-- Name: SEQUENCE cicar1_test_profile_neighbors_profileneighbor_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.cicar1_test_profile_neighbors_profileneighbor_id_seq TO staff;


--
-- Name: TABLE copy_profileneighbors_cicar1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.copy_profileneighbors_cicar1 FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.copy_profileneighbors_cicar1 FROM www;
GRANT ALL ON TABLE ongenome.copy_profileneighbors_cicar1 TO www;
GRANT ALL ON TABLE ongenome.copy_profileneighbors_cicar1 TO staff;


--
-- Name: TABLE copygenemodel; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.copygenemodel FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.copygenemodel FROM www;
GRANT ALL ON TABLE ongenome.copygenemodel TO www;
GRANT ALL ON TABLE ongenome.copygenemodel TO staff;


--
-- Name: TABLE dataset; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.dataset FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.dataset FROM www;
GRANT ALL ON TABLE ongenome.dataset TO www;
GRANT ALL ON TABLE ongenome.dataset TO staff;


--
-- Name: SEQUENCE dataset_dataset_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.dataset_dataset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.dataset_dataset_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.dataset_dataset_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.dataset_dataset_id_seq TO staff;


--
-- Name: TABLE dataset_sample; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.dataset_sample FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.dataset_sample FROM www;
GRANT ALL ON TABLE ongenome.dataset_sample TO www;
GRANT ALL ON TABLE ongenome.dataset_sample TO staff;


--
-- Name: SEQUENCE dataset_sample_dataset_sample_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.dataset_sample_dataset_sample_id_seq TO staff;


--
-- Name: TABLE datasetsource; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.datasetsource FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.datasetsource FROM www;
GRANT ALL ON TABLE ongenome.datasetsource TO www;
GRANT ALL ON TABLE ongenome.datasetsource TO staff;


--
-- Name: SEQUENCE datasetsource_datasetsource_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.datasetsource_datasetsource_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.datasetsource_datasetsource_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.datasetsource_datasetsource_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.datasetsource_datasetsource_id_seq TO staff;


--
-- Name: TABLE expressiondata; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.expressiondata FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.expressiondata FROM www;
GRANT ALL ON TABLE ongenome.expressiondata TO www;
GRANT ALL ON TABLE ongenome.expressiondata TO staff;


--
-- Name: SEQUENCE expressiondata_expressiondata_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.expressiondata_expressiondata_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.expressiondata_expressiondata_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.expressiondata_expressiondata_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.expressiondata_expressiondata_id_seq TO staff;


--
-- Name: TABLE genemodel; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.genemodel FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.genemodel FROM www;
GRANT ALL ON TABLE ongenome.genemodel TO www;
GRANT ALL ON TABLE ongenome.genemodel TO staff;


--
-- Name: SEQUENCE genemodel_genemodel_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.genemodel_genemodel_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.genemodel_genemodel_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.genemodel_genemodel_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.genemodel_genemodel_id_seq TO staff;


--
-- Name: TABLE genome; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.genome FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.genome FROM www;
GRANT ALL ON TABLE ongenome.genome TO www;
GRANT ALL ON TABLE ongenome.genome TO staff;


--
-- Name: SEQUENCE genome_genome_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.genome_genome_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.genome_genome_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.genome_genome_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.genome_genome_id_seq TO staff;


--
-- Name: TABLE method; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.method FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.method FROM www;
GRANT ALL ON TABLE ongenome.method TO www;
GRANT ALL ON TABLE ongenome.method TO staff;


--
-- Name: SEQUENCE method_method_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.method_method_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.method_method_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.method_method_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.method_method_id_seq TO staff;


--
-- Name: TABLE organism; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.organism FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.organism FROM www;
GRANT ALL ON TABLE ongenome.organism TO www;
GRANT ALL ON TABLE ongenome.organism TO staff;


--
-- Name: SEQUENCE organism_organism_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.organism_organism_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.organism_organism_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.organism_organism_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.organism_organism_id_seq TO staff;


--
-- Name: TABLE profileneighbors_cajca1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.profileneighbors_cajca1 FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.profileneighbors_cajca1 FROM www;
GRANT ALL ON TABLE ongenome.profileneighbors_cajca1 TO www;
GRANT ALL ON TABLE ongenome.profileneighbors_cajca1 TO staff;


--
-- Name: SEQUENCE profileneighbors_cajca1_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_cajca1_profileneighbors_id_seq TO staff;


--
-- Name: TABLE profileneighbors_cicar1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.profileneighbors_cicar1 FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.profileneighbors_cicar1 FROM www;
GRANT ALL ON TABLE ongenome.profileneighbors_cicar1 TO www;
GRANT ALL ON TABLE ongenome.profileneighbors_cicar1 TO staff;


--
-- Name: TABLE profileneighbors_phavu1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.profileneighbors_phavu1 FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.profileneighbors_phavu1 FROM www;
GRANT ALL ON TABLE ongenome.profileneighbors_phavu1 TO www;
GRANT ALL ON TABLE ongenome.profileneighbors_phavu1 TO staff;


--
-- Name: SEQUENCE profileneighbors_phavu1_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_phavu1_profileneighbors_id_seq TO staff;


--
-- Name: SEQUENCE profileneighbors_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_profileneighbors_id_seq TO staff;


--
-- Name: TABLE profileneighbors_vigun1; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.profileneighbors_vigun1 FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.profileneighbors_vigun1 FROM www;
GRANT ALL ON TABLE ongenome.profileneighbors_vigun1 TO www;
GRANT ALL ON TABLE ongenome.profileneighbors_vigun1 TO staff;


--
-- Name: SEQUENCE profileneighbors_vigun1_profileneighbors_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.profileneighbors_vigun1_profileneighbors_id_seq TO staff;


--
-- Name: TABLE sample; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.sample FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.sample FROM www;
GRANT ALL ON TABLE ongenome.sample TO www;
GRANT ALL ON TABLE ongenome.sample TO staff;


--
-- Name: SEQUENCE sample_sample_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.sample_sample_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.sample_sample_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.sample_sample_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.sample_sample_id_seq TO staff;


--
-- Name: TABLE treatment; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON TABLE ongenome.treatment FROM PUBLIC;
REVOKE ALL ON TABLE ongenome.treatment FROM www;
GRANT ALL ON TABLE ongenome.treatment TO www;
GRANT ALL ON TABLE ongenome.treatment TO staff;


--
-- Name: SEQUENCE treatment_treatment_id_seq; Type: ACL; Schema: ongenome; Owner: www
--

REVOKE ALL ON SEQUENCE ongenome.treatment_treatment_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ongenome.treatment_treatment_id_seq FROM www;
GRANT ALL ON SEQUENCE ongenome.treatment_treatment_id_seq TO www;
GRANT ALL ON SEQUENCE ongenome.treatment_treatment_id_seq TO staff;


--
-- PostgreSQL database dump complete
--

