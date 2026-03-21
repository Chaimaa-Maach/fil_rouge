--
-- PostgreSQL database dump
--

\restrict 20KTx39SexughlKI5N1gHbRYZEdQpPZR79cOvw3sk52TiaPXy8exEZRgcRjuY8I

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-03-21 11:25:42

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 19687)
-- Name: basic_user_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basic_user_info (
    user_id integer NOT NULL,
    status character varying(20),
    username character varying(45),
    first_name character varying(45) NOT NULL,
    last_name character varying(45) NOT NULL,
    gender character varying(15),
    email character varying(100),
    hiredate date NOT NULL,
    manager integer,
    hr integer,
    job_code character varying(35) NOT NULL,
    division character varying(60) NOT NULL,
    location text NOT NULL,
    city character varying(60),
    state character varying(60),
    zip character varying(5),
    country character varying(60),
    CONSTRAINT chk_city_state_fixed CHECK (((((state)::text = 'Île-de-France'::text) AND ((city)::text = 'Paris'::text)) OR (((state)::text = 'Auvergne-Rhône-Alpes'::text) AND ((city)::text = 'Lyon'::text)) OR (((state)::text = 'Occitanie'::text) AND ((city)::text = 'Toulouse'::text)) OR (((state)::text = 'Provence-Alpes-Côte d''Azur'::text) AND ((city)::text = 'Marseille'::text)) OR (((state)::text = 'Nouvelle-Aquitaine'::text) AND ((city)::text = 'Bordeaux'::text)) OR (((state)::text = 'Hauts-de-France'::text) AND ((city)::text = 'Lille'::text)))),
    CONSTRAINT chk_country_france CHECK (((country)::text = 'France'::text)),
    CONSTRAINT chk_email_domain CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@novaryn-tech\.com$'::text)),
    CONSTRAINT chk_gender CHECK (((gender)::text = ANY ((ARRAY['M'::character varying, 'F'::character varying, 'Other'::character varying])::text[]))),
    CONSTRAINT chk_hire_date CHECK ((hiredate <= CURRENT_DATE)),
    CONSTRAINT chk_hr_self CHECK ((hr <> user_id)),
    CONSTRAINT chk_manager_self CHECK ((manager <> user_id)),
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Inactive'::character varying, 'Leave'::character varying, 'Terminated'::character varying])::text[]))),
    CONSTRAINT chk_username_lower CHECK (((username)::text = lower((username)::text))),
    CONSTRAINT chk_zip_format CHECK (((zip)::text ~ '^[0-9]+$'::text))
);


ALTER TABLE public.basic_user_info OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 19724)
-- Name: compensation_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compensation_info (
    user_id integer NOT NULL,
    start_date date NOT NULL,
    event_reason character varying(50),
    bonus numeric(5,2),
    bonus_base_amount numeric(15,2),
    carallowance numeric(15,2),
    paygroup character varying(40),
    paytype character varying(20),
    payrollid character varying(50),
    targetincentive numeric(15,2),
    CONSTRAINT chk_bonus_cap CHECK (((bonus >= (0)::numeric) AND (bonus <= (100)::numeric))),
    CONSTRAINT chk_car_allowance_policy CHECK (((((paygroup)::text = 'FR_INTERN'::text) AND (carallowance = (0)::numeric)) OR ((paygroup)::text <> 'FR_INTERN'::text))),
    CONSTRAINT chk_comp_amounts_positive CHECK (((bonus_base_amount > (0)::numeric) AND (targetincentive >= (0)::numeric) AND (carallowance >= (0)::numeric))),
    CONSTRAINT chk_pay_group_sf CHECK (((paygroup)::text = ANY ((ARRAY['FR_EXECUTIVE'::character varying, 'FR_EXEMPT'::character varying, 'FR_NON_EXEMPT'::character varying, 'FR_INTERN'::character varying])::text[]))),
    CONSTRAINT chk_pay_type_sf CHECK (((paytype)::text = ANY ((ARRAY['Salary'::character varying, 'Hourly'::character varying, 'Commission'::character varying])::text[])))
);


ALTER TABLE public.compensation_info OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 19709)
-- Name: job_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_info (
    user_id integer NOT NULL,
    start_date date NOT NULL,
    seq_number integer NOT NULL,
    event_reason character varying(50) NOT NULL,
    businessunit character varying(50),
    company character varying(100),
    location character varying(100) NOT NULL,
    division character varying(100) NOT NULL,
    job_code character varying(35) NOT NULL,
    job_family character varying(50) NOT NULL,
    group_job character varying(50),
    hiresource character varying(50),
    contract_id character varying(30),
    contract_name character varying(40) NOT NULL,
    degreeofproductivity numeric(5,2),
    CONSTRAINT chk_business_unit CHECK (((businessunit)::text = ANY ((ARRAY['Engineering'::character varying, 'Sales'::character varying, 'Marketing'::character varying, 'Finance'::character varying, 'HR'::character varying, 'Product'::character varying])::text[]))),
    CONSTRAINT chk_company_name CHECK (((company)::text = 'Novaryn Tech'::text)),
    CONSTRAINT chk_contract_type CHECK (((contract_name)::text = ANY ((ARRAY['Permanent'::character varying, 'Fixed-term'::character varying, 'Freelance'::character varying, 'Internship'::character varying, 'Apprenticeship'::character varying])::text[]))),
    CONSTRAINT chk_event_reason_job CHECK (((event_reason)::text = ANY ((ARRAY['Hiring'::character varying, 'Promotion'::character varying, 'Job Change'::character varying, 'Transfer'::character varying, 'Data Change'::character varying, 'Rehire'::character varying])::text[]))),
    CONSTRAINT chk_group_job CHECK (((group_job)::text = ANY ((ARRAY['Executive'::character varying, 'Technical'::character varying, 'Marketing'::character varying, 'Operations'::character varying, 'Support'::character varying])::text[]))),
    CONSTRAINT chk_hire_source CHECK (((hiresource)::text = ANY ((ARRAY['LinkedIn'::character varying, 'Indeed'::character varying, 'Referral'::character varying, 'Headhunter'::character varying, 'Company Website'::character varying, 'Welcome to the Jungle'::character varying, 'Other'::character varying])::text[]))),
    CONSTRAINT chk_productivity_range CHECK (((degreeofproductivity >= (0)::numeric) AND (degreeofproductivity <= (100)::numeric)))
);


ALTER TABLE public.job_info OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 19777)
-- Name: learning_management_system; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_management_system (
    user_id integer NOT NULL,
    courseid character varying(25) NOT NULL,
    coursetitle character varying(150) NOT NULL,
    completiondate date NOT NULL,
    status character varying(20) NOT NULL,
    credithours numeric(5,2),
    grade numeric(5,2),
    trainingcost numeric(15,2),
    trainingtype character varying(50),
    CONSTRAINT chk_lms_grade_real CHECK (((grade >= (0)::numeric) AND (grade <= (100)::numeric))),
    CONSTRAINT chk_lms_metrics CHECK (((credithours >= (0)::numeric) AND (trainingcost >= (0)::numeric))),
    CONSTRAINT chk_lms_status_real CHECK (((status)::text = ANY ((ARRAY['COMP'::character varying, 'ENR'::character varying, 'FAIL'::character varying, 'EXMPT'::character varying])::text[]))),
    CONSTRAINT chk_training_type_real CHECK (((trainingtype)::text = ANY ((ARRAY['COURSE'::character varying, 'ELEARN'::character varying, 'OJT'::character varying, 'EXT'::character varying, 'COMPLIANCE'::character varying])::text[])))
);


ALTER TABLE public.learning_management_system OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 19750)
-- Name: pay_component_non_recurring; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pay_component_non_recurring (
    user_id integer NOT NULL,
    pay_date date NOT NULL,
    pay_component character varying(25) NOT NULL,
    value numeric(15,2) NOT NULL,
    currency_code character varying(3) NOT NULL,
    notes text,
    operation character varying(10) NOT NULL,
    CONSTRAINT chk_currency_eur_only CHECK (((currency_code)::text = 'EUR'::text)),
    CONSTRAINT chk_non_rec_comp_list CHECK (((pay_component)::text = ANY ((ARRAY['SPOTBONUS'::character varying, 'REFERRAL'::character varying, 'SIGNON'::character varying, 'PERFAWARD'::character varying, 'RELOCATION'::character varying, 'MILESTONE'::character varying])::text[]))),
    CONSTRAINT chk_non_rec_value_pos CHECK ((value > (0)::numeric)),
    CONSTRAINT chk_pay_op_logic CHECK (((operation)::text = ANY ((ARRAY['ADD'::character varying, 'SUB'::character varying])::text[])))
);


ALTER TABLE public.pay_component_non_recurring OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19736)
-- Name: pay_component_recurring; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pay_component_recurring (
    user_id integer NOT NULL,
    start_date date NOT NULL,
    pay_component character varying(50) NOT NULL,
    paycomponentvalue numeric(15,2),
    currency_code character varying(3),
    frequency character varying(20),
    seq_number integer NOT NULL,
    CONSTRAINT chk_pay_comp_value_positive CHECK ((paycomponentvalue > (0)::numeric)),
    CONSTRAINT chk_pay_component_name CHECK (((pay_component)::text = ANY ((ARRAY['Base Salary'::character varying, 'Car Allowance'::character varying, 'Housing Allowance'::character varying, 'Transport Allowance'::character varying])::text[]))),
    CONSTRAINT chk_pay_rec_details CHECK ((((currency_code)::text = 'EUR'::text) AND ((frequency)::text = ANY ((ARRAY['Monthly'::character varying, 'Annual'::character varying, 'Weekly'::character varying])::text[])))),
    CONSTRAINT chk_seq_num_rec CHECK ((seq_number >= 1))
);


ALTER TABLE public.pay_component_recurring OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19765)
-- Name: performance_management; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.performance_management (
    user_id integer NOT NULL,
    formcontentid character varying(25) NOT NULL,
    reviewdate date NOT NULL,
    rating numeric(3,2) NOT NULL,
    potential character varying(20),
    lastpromotiondate date,
    competencyscore numeric(5,2),
    objectivecompletion numeric(5,2),
    istopperformer boolean NOT NULL,
    CONSTRAINT chk_competency_score CHECK (((competencyscore >= (0)::numeric) AND (competencyscore <= (5)::numeric))),
    CONSTRAINT chk_last_promo_date CHECK ((lastpromotiondate <= CURRENT_DATE)),
    CONSTRAINT chk_obj_completion CHECK (((objectivecompletion >= (0)::numeric) AND (objectivecompletion <= (100)::numeric))),
    CONSTRAINT chk_perf_potential CHECK (((potential)::text = ANY ((ARRAY['Low'::character varying, 'Medium'::character varying, 'High'::character varying])::text[]))),
    CONSTRAINT chk_perf_rating CHECK (((rating >= (1)::numeric) AND (rating <= (5)::numeric))),
    CONSTRAINT chk_top_performer CHECK ((istopperformer = ANY (ARRAY[true, false])))
);


ALTER TABLE public.performance_management OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 19790)
-- Name: termination_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.termination_info (
    user_id integer NOT NULL,
    event_reason character varying(100) NOT NULL,
    company character varying(100),
    oktorehire boolean NOT NULL,
    lastdateworked date NOT NULL,
    bonuspayexpirationdate date,
    termination_detailed_reason text,
    termination_attachment character varying(255),
    CONSTRAINT chk_bonus_date_logic CHECK ((bonuspayexpirationdate >= lastdateworked)),
    CONSTRAINT chk_ok_to_rehire CHECK ((oktorehire = ANY (ARRAY[true, false]))),
    CONSTRAINT chk_term_company CHECK ((company IS NOT NULL)),
    CONSTRAINT chk_term_event_reason_sap CHECK (((event_reason)::text = ANY ((ARRAY['RESIGNATION'::character varying, 'INVOLUNTARY'::character varying, 'RETIREMENT'::character varying, 'NON_RENEWAL'::character varying, 'DEATH'::character varying])::text[])))
);


ALTER TABLE public.termination_info OWNER TO postgres;

--
-- TOC entry 5119 (class 0 OID 19687)
-- Dependencies: 219
-- Data for Name: basic_user_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.basic_user_info (user_id, status, username, first_name, last_name, gender, email, hiredate, manager, hr, job_code, division, location, city, state, zip, country) FROM stdin;
1001	Active	claurent	Cécile	Laurent	F	cecile.laurent@novaryn-tech.com	2024-08-12	1058	1108	CSM-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1002	Active	lmoulin	Laure	Moulin	F	laure.moulin@novaryn-tech.com	2015-10-18	1194	1161	LEAD-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1003	Active	dgallet	Daniel	Gallet	M	daniel.gallet@novaryn-tech.com	2013-09-28	1096	1104	SR-PAYROLL-OP	People & Culture	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1004	Active	ytraore	Yves	Traore	M	yves.traore@novaryn-tech.com	2021-04-11	1053	1108	LEAD-CSM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1005	Active	bmaury	Benjamin	Maury	M	benjamin.maury@novaryn-tech.com	2019-03-06	1160	1142	LEAD-CSM-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1006	Active	amartinez	Alexandria	Martinez	F	alexandria.martinez@novaryn-tech.com	2013-08-05	1121	1003	LEAD-ML-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1007	Inactive	grey	Gabrielle	Rey	F	gabrielle.rey@novaryn-tech.com	2020-08-06	1157	1064	SR-QA-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1008	Active	aguilbert	Alexandrie	Guilbert	F	alexandrie.guilbert@novaryn-tech.com	2015-05-20	1192	1104	LEAD-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1009	Active	pvasseur	Paulette	Vasseur	F	paulette.vasseur@novaryn-tech.com	2019-08-23	1213	1175	BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1010	Leave	tlopes	Théodore	Lopes	M	theodore.lopes@novaryn-tech.com	2025-10-08	1138	1134	SR-FA-FIN	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1011	Active	athierry	Adèle	Thierry	F	adele.thierry@novaryn-tech.com	2025-09-16	1053	1175	LEAD-FA-FIN	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1012	Active	erocher	Édouard	Rocher	M	edouard.rocher@novaryn-tech.com	2019-03-11	\N	1048	CMO	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1013	Active	jlopes	Jean	Lopes	M	jean.lopes@novaryn-tech.com	2014-08-24	1018	1108	SR-FA-FIN	Finance & Administration	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1014	Active	fledoux	Franck	Ledoux	M	franck.ledoux@novaryn-tech.com	2017-09-22	1186	1108	BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1015	Active	bmorin	Bernard	Morin	M	bernard.morin@novaryn-tech.com	2018-06-18	1006	1232	LEAD-DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1016	Active	bpelletier	Benoît	Pelletier	M	benoit.pelletier@novaryn-tech.com	2017-11-07	1162	1003	LEAD-DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1017	Inactive	taubry	Thibaut	Aubry	M	thibaut.aubry@novaryn-tech.com	2025-09-24	1116	1104	SECU-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1018	Active	achauveau	Amélie	Chauveau	F	amelie.chauveau@novaryn-tech.com	2019-10-25	1085	1142	SR-DEVOPS-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1019	Terminated	rdenis	René	Denis	M	rene.denis@novaryn-tech.com	2018-06-10	1221	1065	LEAD-DATA-SCI	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1020	Active	acourtois	Augustin	Courtois	M	augustin.courtois@novaryn-tech.com	2016-12-26	1115	1043	LEAD-PO-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1021	Active	tmaurice	Thomas	Maurice	M	thomas.maurice@novaryn-tech.com	2018-02-25	1003	1064	LEAD-FA-FIN	Finance & Administration	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1022	Inactive	solivier	Sébastien	Olivier	M	sebastien.olivier@novaryn-tech.com	2023-12-27	1209	1064	AM-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1023	Active	alambert	Arthur	Lambert	M	arthur.lambert@novaryn-tech.com	2023-04-01	1066	1232	SR-SMGR-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1024	Active	gleleu	Gabriel	Leleu	M	gabriel.leleu@novaryn-tech.com	2016-12-03	1224	1148	LEAD-FULL-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1025	Terminated	arey	Audrey	Rey	F	audrey.rey@novaryn-tech.com	2013-09-19	1038	1148	LEAD-DATA-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1026	Active	llopes	Laurent	Lopes	M	laurent.lopes@novaryn-tech.com	2019-09-18	1202	1060	CTRL-FIN	Finance & Administration	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1027	Terminated	tmarchal	Timothée	Marchal	M	timothee.marchal@novaryn-tech.com	2014-10-07	1116	1134	CONF-CONT-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1028	Terminated	mmonnier	Michèle	Monnier	F	michele.monnier@novaryn-tech.com	2015-07-25	1154	1064	LEAD-SMGR-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1029	Terminated	jboutin	Juliette	Boutin	F	juliette.boutin@novaryn-tech.com	2023-08-18	1146	1167	UX-PROD	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1030	Active	tguerin	Tristan	Guérin	M	tristan.guerin@novaryn-tech.com	2022-05-13	1158	1142	SR-BRAND-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1031	Active	tpicard	Timothée	Picard	M	timothee.picard@novaryn-tech.com	2021-02-01	1061	1242	GROWTH-MKT	Commercial	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1032	Active	jgoncalves	Jacqueline	Goncalves	F	jacqueline.goncalves@novaryn-tech.com	2019-11-12	1218	1108	CONF-BRAND-MKT	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1033	Active	mdupuy	Monique	Dupuy	F	monique.dupuy@novaryn-tech.com	2022-11-20	1185	1065	SR-FA-FIN	Finance & Administration	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1034	Active	rvasseur	Roger	Vasseur	M	roger.vasseur@novaryn-tech.com	2023-08-25	1235	1134	INFRA-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1035	Active	ilecoq	Isaac	Lecoq	M	isaac.lecoq@novaryn-tech.com	2025-03-14	1171	1134	SR-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1036	Active	arolland	Antoine	Rolland	M	antoine.rolland@novaryn-tech.com	2025-12-24	1146	1065	PM-PROD	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1037	Active	agomes	Alfred	Gomes	M	alfred.gomes@novaryn-tech.com	2018-10-28	1002	1161	SR-GROWTH-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1038	Active	jfrancois	Juliette	François	F	juliette.francois@novaryn-tech.com	2015-08-04	1160	1043	LEAD-SECU-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1039	Inactive	rwagner	Roland	Wagner	M	roland.wagner@novaryn-tech.com	2017-05-09	1055	1142	LEAD-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1040	Terminated	fbegue	Franck	Bègue	M	franck.begue@novaryn-tech.com	2020-06-29	1215	1108	CONF-DATA-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1041	Terminated	lweiss	Louis	Weiss	M	louis.weiss@novaryn-tech.com	2019-10-22	1061	1175	SR-PMM-MKT	Commercial	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1042	Active	caubry	Claire	Aubry	F	claire.aubry@novaryn-tech.com	2014-05-17	1048	1142	LEAD-CONT-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1043	Active	jvallet	Jeanne	Vallet	F	jeanne.vallet@novaryn-tech.com	2021-07-20	1205	1060	LEAD-HRBP-HR	People & Culture	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1044	Active	rcharles	René	Charles	M	rene.charles@novaryn-tech.com	2024-09-15	1038	1148	CONF-FRONT-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1045	Terminated	sgilbert	Stéphane	Gilbert	M	stephane.gilbert@novaryn-tech.com	2021-12-04	1111	1065	LEAD-CONT-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1046	Inactive	netienne	Noémi	Étienne	F	noemi.etienne@novaryn-tech.com	2015-09-24	1220	1048	LEAD-QA-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1047	Leave	cgregoire	Christine	Grégoire	F	christine.gregoire@novaryn-tech.com	2020-05-24	1042	1172	CONF-PMM-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1048	Active	bfaivre	Bernadette	Faivre	F	bernadette.faivre@novaryn-tech.com	2012-10-19	1004	1134	SR-PAYROLL-OP	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1049	Active	cbrunet	Cécile	Brunet	F	cecile.brunet@novaryn-tech.com	2022-09-03	1086	1108	CONF-QA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1050	Active	ebazin	Édouard	Bazin	M	edouard.bazin@novaryn-tech.com	2019-03-08	1014	1148	LEAD-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1051	Active	tandre	Théophile	Andre	M	theophile.andre@novaryn-tech.com	2018-07-18	1102	1060	SR-PO-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1052	Active	mgodard	Monique	Godard	F	monique.godard@novaryn-tech.com	2019-12-18	1171	1003	SR-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1053	Active	jlenoir	Jeannine	Lenoir	F	jeannine.lenoir@novaryn-tech.com	2012-03-12	1011	1161	LEAD-DEVOPS-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1054	Active	zmace	Zacharie	Mace	M	zacharie.mace@novaryn-tech.com	2013-12-12	1118	1167	LEAD-UX-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1055	Active	jlecoq	Juliette	Lecoq	F	juliette.lecoq@novaryn-tech.com	2022-11-26	1051	1167	SR-INFRA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1056	Active	jmarie	Jean	Marie	M	jean.marie@novaryn-tech.com	2016-12-28	1124	1161	SR-DATA-SCI	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1057	Active	mbarbier	Martin	Barbier	M	martin.barbier@novaryn-tech.com	2019-09-20	1112	1242	CONF-AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1058	Active	amace	Adrien	Mace	M	adrien.mace@novaryn-tech.com	2024-03-29	1226	1060	CONF-AM-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1059	Inactive	gcharrier	Gilles	Charrier	M	gilles.charrier@novaryn-tech.com	2024-12-17	1219	1108	LEAD-FA-FIN	Finance & Administration	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1060	Active	eguillou	Emmanuel	Guillou	M	emmanuel.guillou@novaryn-tech.com	2013-10-23	1078	1175	HRBP-HR	People & Culture	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1061	Active	lriou	Lucy	Riou	F	lucy.riou@novaryn-tech.com	2020-08-20	1071	1043	LEAD-BRAND-MKT	Commercial	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1062	Active	ebrunet	Élodie	Brunet	F	elodie.brunet@novaryn-tech.com	2018-05-12	1110	1003	CONF-BACK-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1063	Active	egimenez	Édouard	Gimenez	M	edouard.gimenez@novaryn-tech.com	2025-03-31	1085	1114	LEAD-PM-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1064	Active	ajoseph	Adélaïde	Joseph	F	adelaide.joseph@novaryn-tech.com	2017-07-07	1060	1048	SR-HRBP-HR	People & Culture	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1065	Active	pmoreau	Patrick	Moreau	M	patrick.moreau@novaryn-tech.com	2013-11-26	1126	1104	LEAD-TA-HR	People & Culture	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1066	Active	mlegall	Maryse	Le Gall	F	maryse.legall@novaryn-tech.com	2016-01-27	\N	1065	CSO	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1067	Active	aguillot	Andrée	Guillot	F	andree.guillot@novaryn-tech.com	2021-08-26	1075	1242	SR-UX-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1068	Active	aclement	Audrey	Clément	F	audrey.clement@novaryn-tech.com	2024-06-13	1016	1142	CONF-DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1069	Active	vmuller	Véronique	Muller	F	veronique.muller@novaryn-tech.com	2024-12-09	1185	1175	DEVOPS-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1070	Active	rgosselin	René	Gosselin	M	rene.gosselin@novaryn-tech.com	2014-02-20	1005	1167	CONF-ADMIN-OP	Finance & Administration	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1071	Active	cdelmas	Christophe	Delmas	M	christophe.delmas@novaryn-tech.com	2020-02-01	1244	1065	LEAD-DATA-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1072	Active	rgaillard	Robert	Gaillard	M	robert.gaillard@novaryn-tech.com	2016-07-05	1207	1065	LEAD-ML-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1073	Active	rseguin	Rémy	Seguin	M	remy.seguin@novaryn-tech.com	2019-03-14	1072	1060	CONF-FRONT-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1074	Active	fgimenez	Franck	Gimenez	M	franck.gimenez@novaryn-tech.com	2024-11-06	1130	1104	CSM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1075	Active	edelannoy	Eugène	Delannoy	M	eugene.delannoy@novaryn-tech.com	2017-04-20	1070	1167	CONF-PM-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1076	Inactive	lleconte	Luc	Leconte	M	luc.leconte@novaryn-tech.com	2023-01-21	1137	1134	CONF-CONT-MKT	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1077	Active	mnavarro	Michelle	Navarro	F	michelle.navarro@novaryn-tech.com	2020-10-21	1106	1108	LEAD-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1078	Active	mmathieu	Maurice	Mathieu	M	maurice.mathieu@novaryn-tech.com	2016-03-20	1060	1043	LEAD-QA-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1079	Active	fandre	Frédéric	Andre	M	frederic.andre@novaryn-tech.com	2017-10-01	1207	1242	LEAD-DEVOPS-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1080	Active	apruvost	Alain	Pruvost	M	alain.pruvost@novaryn-tech.com	2021-06-03	1194	1064	CONF-DATA-SCI	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1081	Leave	gpruvost	Gabriel	Pruvost	M	gabriel.pruvost@novaryn-tech.com	2015-09-30	1011	1148	LEAD-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1082	Active	aguerin	Adrien	Guérin	M	adrien.guerin@novaryn-tech.com	2024-01-16	1020	1167	CONF-PM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1083	Leave	arolland1	Anne	Rolland	F	anne.rolland@novaryn-tech.com	2013-02-22	1060	1134	LEAD-AM-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1084	Inactive	aremy	Alexandria	Rémy	F	alexandria.remy@novaryn-tech.com	2013-03-16	1241	1175	LEAD-CTRL-FIN	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1085	Active	pgomez	Pierre	Gomez	M	pierre.gomez@novaryn-tech.com	2016-09-26	1033	1060	LEAD-SECU-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1086	Leave	vbenoit	Véronique	Benoit	F	veronique.benoit@novaryn-tech.com	2021-03-04	1008	1104	LEAD-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1087	Active	cramos	Christophe	Ramos	M	christophe.ramos@novaryn-tech.com	2021-09-18	1038	1134	CONF-QA-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1088	Terminated	sreynaud	Sébastien	Reynaud	M	sebastien.reynaud@novaryn-tech.com	2016-02-18	1032	1175	LEAD-ML-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1089	Terminated	tcordier	Thérèse	Cordier	F	therese.cordier@novaryn-tech.com	2015-03-29	1054	1134	SR-BACK-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1090	Active	bpereira	Benoît	Pereira	M	benoit.pereira@novaryn-tech.com	2023-03-18	1203	1175	FRONT-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1091	Active	mmonnier1	Martin	Monnier	M	martin.monnier@novaryn-tech.com	2019-03-17	1153	1114	SR-PO-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1092	Active	lbigot	Lucas	Bigot	M	lucas.bigot@novaryn-tech.com	2024-05-27	1072	1242	LEAD-FULL-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1093	Active	amaillet	Anastasie	Maillet	F	anastasie.maillet@novaryn-tech.com	2023-02-12	1133	1065	LEAD-AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1094	Active	tperrin	Tristan	Perrin	M	tristan.perrin@novaryn-tech.com	2013-01-11	1202	1161	SR-PM-PROD	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1095	Active	opetitjean	Océane	Petitjean	F	oceane.petitjean@novaryn-tech.com	2017-10-09	1128	1065	SR-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1096	Active	cmenard	Catherine	Menard	F	catherine.menard@novaryn-tech.com	2015-04-05	1118	1043	LEAD-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1097	Active	eregnier	Élisabeth	Regnier	F	elisabeth.regnier@novaryn-tech.com	2019-08-19	1098	1172	LEAD-QA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1098	Active	dbriand	Daniel	Briand	M	daniel.briand@novaryn-tech.com	2015-02-14	1158	1114	SR-DATA-SCI	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1099	Active	lpinto	Laurence	Pinto	F	laurence.pinto@novaryn-tech.com	2016-04-01	1081	1114	LEAD-UX-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1100	Active	apichon	Auguste	Pichon	M	auguste.pichon@novaryn-tech.com	2025-09-29	1078	1064	ML-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1101	Active	rperrin	Robert	Perrin	M	robert.perrin@novaryn-tech.com	2012-11-10	1245	1060	SR-ADMIN-OP	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1102	Active	vgimenez	Victor	Gimenez	M	victor.gimenez@novaryn-tech.com	2012-04-01	1016	1148	LEAD-PM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1103	Leave	bchretien	Bernadette	Chrétien	F	bernadette.chretien@novaryn-tech.com	2016-01-08	1157	1167	LEAD-PRE-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1104	Active	ecordier	Émile	Cordier	M	emile.cordier@novaryn-tech.com	2020-04-05	1232	1114	TA-HR	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1105	Active	obenoit	Olivier	Benoit	M	olivier.benoit@novaryn-tech.com	2018-10-27	1186	1043	SR-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1106	Active	agaillard	Anne	Gaillard	F	anne.gaillard@novaryn-tech.com	2018-06-12	1135	1232	SR-SMGR-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1107	Active	aperrier	Adélaïde	Perrier	F	adelaide.perrier@novaryn-tech.com	2016-07-05	1110	1242	LEAD-QA-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1108	Leave	srenault	Susanne	Renault	F	susanne.renault@novaryn-tech.com	2019-03-13	1235	1114	SR-HRBP-HR	People & Culture	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1109	Terminated	rpeltier	Roger	Peltier	M	roger.peltier@novaryn-tech.com	2024-03-22	1238	1134	LEAD-SECU-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1110	Active	pmeyer	Patrick	Meyer	M	patrick.meyer@novaryn-tech.com	2015-03-25	1018	1161	CONF-DATA-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1111	Active	lcarpentier	Lucie	Carpentier	F	lucie.carpentier@novaryn-tech.com	2012-12-29	1009	1232	LEAD-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1112	Active	aletellier	Anne	Letellier	F	anne.letellier@novaryn-tech.com	2017-05-02	1194	1232	SR-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1113	Terminated	agirard	Antoine	Girard	M	antoine.girard@novaryn-tech.com	2021-12-08	1108	1060	CONF-TA-HR	People & Culture	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1114	Active	ogaudin	Olivier	Gaudin	M	olivier.gaudin@novaryn-tech.com	2021-01-13	1108	1065	TA-HR	People & Culture	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1115	Active	eboyer	Édouard	Boyer	M	edouard.boyer@novaryn-tech.com	2020-08-21	1099	1104	SR-SCRM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1116	Active	alemoine	Audrey	Lemoine	F	audrey.lemoine@novaryn-tech.com	2013-03-01	1055	1064	LEAD-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1117	Active	tmercier	Théophile	Mercier	M	theophile.mercier@novaryn-tech.com	2023-06-27	1020	1167	PM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1118	Active	gantoine	Georges	Antoine	M	georges.antoine@novaryn-tech.com	2014-01-14	1018	1167	LEAD-PM-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1119	Active	rhoarau	Roland	Hoarau	M	roland.hoarau@novaryn-tech.com	2021-11-06	1057	1064	LEAD-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1120	Inactive	alegendre	Alice	Legendre	F	alice.legendre@novaryn-tech.com	2013-05-24	1213	1114	CONF-DATA-SCI	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1121	Leave	pdescamps	Paulette	Descamps	F	paulette.descamps@novaryn-tech.com	2021-12-05	1086	1048	SR-DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1122	Active	rbarbe	Roland	Barbe	M	roland.barbe@novaryn-tech.com	2017-05-19	1061	1161	LEAD-GROWTH-MKT	Commercial	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1123	Active	jmartins	Josette	Martins	F	josette.martins@novaryn-tech.com	2023-05-24	1244	1161	BACK-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1124	Active	hdupuis	Hugues	Dupuis	M	hugues.dupuis@novaryn-tech.com	2016-07-08	1144	1142	LEAD-CSM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1125	Active	lpayet	Louis	Payet	M	louis.payet@novaryn-tech.com	2023-06-05	1037	1232	CONT-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1126	Active	tribeiro	Tristan	Ribeiro	M	tristan.ribeiro@novaryn-tech.com	2019-10-12	1129	1003	CTRL-FIN	Finance & Administration	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1127	Active	hhamel	Hugues	Hamel	M	hugues.hamel@novaryn-tech.com	2013-03-26	1229	1232	LEAD-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1128	Active	aalbert	Aimé	Albert	M	aime.albert@novaryn-tech.com	2022-07-26	\N	1060	CFO	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1129	Inactive	rroussel	Roland	Roussel	M	roland.roussel@novaryn-tech.com	2013-03-31	1140	1064	LEAD-ADMIN-OP	Finance & Administration	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1130	Active	rbenoit	René	Benoit	M	rene.benoit@novaryn-tech.com	2020-08-09	1066	1060	CONF-AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1131	Active	jpayet	Julie	Payet	F	julie.payet@novaryn-tech.com	2017-12-08	1030	1060	SR-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1132	Active	amoulin	Arthur	Moulin	M	arthur.moulin@novaryn-tech.com	2018-04-15	1110	1242	BACK-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1133	Active	gbarbier	Guy	Barbier	M	guy.barbier@novaryn-tech.com	2019-06-15	1119	1167	LEAD-INFRA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1134	Active	mraymond	Madeleine	Raymond	F	madeleine.raymond@novaryn-tech.com	2025-09-24	1064	1167	CONF-TA-HR	People & Culture	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1135	Active	vevrard	Victor	Evrard	M	victor.evrard@novaryn-tech.com	2012-02-18	1240	1175	SR-CSM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1136	Active	xlenoir	Xavier	Lenoir	M	xavier.lenoir@novaryn-tech.com	2017-02-03	1194	1175	SR-ML-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1137	Active	vduval	Vincent	Duval	M	vincent.duval@novaryn-tech.com	2014-04-14	1007	1065	LEAD-AM-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1138	Active	jferreira	Julie	Ferreira	F	julie.ferreira@novaryn-tech.com	2013-10-27	1099	1161	SR-ADMIN-OP	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1139	Active	rmeyer	Robert	Meyer	M	robert.meyer@novaryn-tech.com	2016-08-19	1047	1161	LEAD-ADMIN-OP	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1140	Leave	gtexier	Guy	Texier	M	guy.texier@novaryn-tech.com	2015-08-01	1007	1161	LEAD-CTRL-FIN	Finance & Administration	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1141	Active	jmartins1	Jean	Martins	M	jean.martins@novaryn-tech.com	2023-09-11	1157	1108	FRONT-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1142	Active	jbodin	Julie	Bodin	F	julie.bodin@novaryn-tech.com	2020-04-23	\N	1232	CHRO	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1143	Active	groux	Gilbert	Roux	M	gilbert.roux@novaryn-tech.com	2013-07-27	1098	1148	LEAD-FA-FIN	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1144	Active	tbriand	Timothée	Briand	M	timothee.briand@novaryn-tech.com	2016-09-15	1003	1142	SR-PM-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1145	Active	abernard	Amélie	Bernard	F	amelie.bernard@novaryn-tech.com	2017-09-03	1218	1134	SR-PM-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1146	Inactive	cdiaz	Christophe	Diaz	M	christophe.diaz@novaryn-tech.com	2016-06-15	1083	1114	SR-SCRM-PROD	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1147	Inactive	ctraore	Corinne	Traore	F	corinne.traore@novaryn-tech.com	2019-07-08	1165	1060	LEAD-CSM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1148	Active	pguilbert	Pénélope	Guilbert	F	penelope.guilbert@novaryn-tech.com	2012-03-01	1084	1064	LEAD-HRBP-HR	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1149	Active	bsanchez	Bertrand	Sanchez	M	bertrand.sanchez@novaryn-tech.com	2023-10-03	1112	1172	AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1150	Active	dmorvan	Denis	Morvan	M	denis.morvan@novaryn-tech.com	2012-08-11	1103	1114	SR-UX-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1151	Active	jguillon	Julien	Guillon	M	julien.guillon@novaryn-tech.com	2021-05-26	1171	1167	SR-DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1152	Active	dperret	David	Perret	M	david.perret@novaryn-tech.com	2014-03-02	1189	1048	LEAD-UX-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1153	Active	alegall	Alphonse	Le Gall	M	alphonse.legall@novaryn-tech.com	2018-03-15	1070	1172	SR-SCRM-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1154	Active	apelletier	Alice	Pelletier	F	alice.pelletier@novaryn-tech.com	2015-07-29	1033	1167	LEAD-BRAND-MKT	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1155	Active	zmenard	Zacharie	Menard	M	zacharie.menard@novaryn-tech.com	2023-05-07	1176	1232	SR-PO-PROD	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1156	Active	bmonnier	Bernard	Monnier	M	bernard.monnier@novaryn-tech.com	2025-04-09	1238	1148	INFRA-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1157	Active	rcordier	Roger	Cordier	M	roger.cordier@novaryn-tech.com	2022-07-23	1007	1232	LEAD-FULL-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1158	Active	cgomez	Colette	Gomez	F	colette.gomez@novaryn-tech.com	2014-10-06	1050	1048	SR-PMM-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1159	Terminated	epasquier	Emmanuel	Pasquier	M	emmanuel.pasquier@novaryn-tech.com	2012-06-03	1091	1232	LEAD-FULL-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1160	Active	egallet	Emmanuel	Gallet	M	emmanuel.gallet@novaryn-tech.com	2017-08-26	1153	1064	CONF-PMM-MKT	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1161	Active	olaroche	Olivie	Laroche	F	olivie.laroche@novaryn-tech.com	2024-07-03	1172	1003	SR-TA-HR	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1162	Active	gdacosta	Gérard	Da Costa	M	gerard.dacosta@novaryn-tech.com	2014-09-16	1052	1104	LEAD-PM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1163	Active	cweber	Catherine	Weber	F	catherine.weber@novaryn-tech.com	2012-08-28	1243	1104	CONF-CSM-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1164	Terminated	nlouis	Noël	Louis	M	noel.louis@novaryn-tech.com	2015-05-25	1021	1108	SR-CONT-MKT	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1165	Active	mmarty	Michel	Marty	M	michel.marty@novaryn-tech.com	2017-03-11	1009	1172	LEAD-PO-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1166	Active	ghubert	Gabriel	Hubert	M	gabriel.hubert@novaryn-tech.com	2012-05-27	1011	1148	CONF-DEVOPS-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1167	Inactive	volivier	Vincent	Olivier	M	vincent.olivier@novaryn-tech.com	2018-10-11	1057	1114	LEAD-PAYROLL-OP	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1168	Active	mlopes	Margot	Lopes	F	margot.lopes@novaryn-tech.com	2013-03-07	1155	1172	LEAD-CSM-SALES	Commercial	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1169	Active	gmarty	Guillaume	Marty	M	guillaume.marty@novaryn-tech.com	2022-11-30	1197	1161	DATA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1170	Inactive	dalexandre	Dominique	Alexandre	F	dominique.alexandre@novaryn-tech.com	2023-07-24	1243	1060	CONF-SECU-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1171	Active	rremy	René	Rémy	M	rene.remy@novaryn-tech.com	2012-06-20	1008	1108	LEAD-BACK-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1172	Active	cbertin	Céline	Bertin	F	celine.bertin@novaryn-tech.com	2015-01-14	1127	1232	LEAD-HRBP-HR	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1173	Active	saubry	Stéphane	Aubry	M	stephane.aubry@novaryn-tech.com	2012-08-25	1196	1172	SR-BACK-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1174	Active	bgodard	Bernard	Godard	M	bernard.godard@novaryn-tech.com	2019-05-24	1032	1175	LEAD-SECU-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1175	Active	jchauveau	Jérôme	Chauveau	M	jerome.chauveau@novaryn-tech.com	2025-05-18	1003	1148	CONF-HRBP-HR	People & Culture	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1176	Active	mnguyen	Margaux	Nguyen	F	margaux.nguyen@novaryn-tech.com	2022-04-24	1071	1114	LEAD-PO-PROD	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1177	Terminated	pferreira	Pierre	Ferreira	M	pierre.ferreira@novaryn-tech.com	2018-07-21	1137	1048	SR-BD-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1178	Active	saubert	Sébastien	Aubert	M	sebastien.aubert@novaryn-tech.com	2016-05-01	1101	1003	LEAD-AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1179	Inactive	aneveu	Amélie	Neveu	F	amelie.neveu@novaryn-tech.com	2019-06-02	1203	1043	SR-INFRA-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1180	Active	adijoux	Adélaïde	Dijoux	F	adelaide.dijoux@novaryn-tech.com	2025-09-20	1103	1104	SMGR-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1181	Active	emarchal	Élodie	Marchal	F	elodie.marchal@novaryn-tech.com	2019-05-03	1222	1108	SR-DATA-SCI	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1182	Active	achartier	Arthur	Chartier	M	arthur.chartier@novaryn-tech.com	2017-08-13	1203	1108	SR-PRE-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1183	Active	tbouvier	Thierry	Bouvier	M	thierry.bouvier@novaryn-tech.com	2023-04-15	1243	1104	CONF-INFRA-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1184	Active	cfouquet	Chantal	Fouquet	F	chantal.fouquet@novaryn-tech.com	2017-02-09	1098	1167	SR-PO-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1185	Active	pruiz	Philippe	Ruiz	M	philippe.ruiz@novaryn-tech.com	2023-05-06	1024	1003	SR-FULL-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1186	Active	lmillet	Lucas	Millet	M	lucas.millet@novaryn-tech.com	2018-11-05	1158	1064	LEAD-PRE-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1187	Active	wlenoir	William	Lenoir	M	william.lenoir@novaryn-tech.com	2014-03-01	1236	1065	LEAD-SCRM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1188	Active	edeoliveira	Élise	De Oliveira	F	elise.deoliveira@novaryn-tech.com	2023-04-24	1215	1003	CONF-BACK-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1189	Active	mlabbe	Monique	Labbé	F	monique.labbe@novaryn-tech.com	2024-09-22	1005	1114	SR-AM-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1190	Terminated	echauvet	Emmanuel	Chauvet	M	emmanuel.chauvet@novaryn-tech.com	2021-09-06	1182	1114	BD-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1191	Active	hlebon	Henri	Lebon	M	henri.lebon@novaryn-tech.com	2021-04-27	1248	1161	CONF-BD-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1192	Leave	abailly	Adélaïde	Bailly	F	adelaide.bailly@novaryn-tech.com	2016-11-17	1119	1172	SR-INFRA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1193	Active	fperret	Françoise	Perret	F	francoise.perret@novaryn-tech.com	2025-05-14	1106	1104	AM-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1194	Active	sseguin	Stéphane	Seguin	M	stephane.seguin@novaryn-tech.com	2023-02-20	1151	1134	LEAD-DEVOPS-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1195	Terminated	mturpin	Margot	Turpin	F	margot.turpin@novaryn-tech.com	2019-07-08	1201	1060	LEAD-ML-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1196	Active	mparent	Matthieu	Parent	M	matthieu.parent@novaryn-tech.com	2015-08-20	1043	1232	SR-ML-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1197	Active	preynaud	Pierre	Reynaud	M	pierre.reynaud@novaryn-tech.com	2025-07-03	1136	1148	SR-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1198	Inactive	edelmas	Émile	Delmas	M	emile.delmas@novaryn-tech.com	2013-06-10	1132	1134	CONF-ML-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1199	Active	gbuisson	Guy	Buisson	M	guy.buisson@novaryn-tech.com	2023-04-18	1209	1060	CONF-AM-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1200	Active	mmorin	Margaret	Morin	F	margaret.morin@novaryn-tech.com	2025-12-03	1238	1048	SR-DATA-SCI	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1201	Active	imaillet	Inès	Maillet	F	ines.maillet@novaryn-tech.com	2017-04-12	1063	1114	LEAD-CTRL-FIN	Finance & Administration	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1202	Active	hphilippe	Hélène	Philippe	F	helene.philippe@novaryn-tech.com	2014-07-04	1094	1114	SR-FA-FIN	Finance & Administration	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1203	Active	alambert1	Alexandre	Lambert	M	alexandre.lambert@novaryn-tech.com	2016-03-01	1083	1134	SR-FRONT-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1204	Leave	nbourdon	Noël	Bourdon	M	noel.bourdon@novaryn-tech.com	2025-01-27	1055	1064	DEVOPS-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1205	Active	apineau	Auguste	Pineau	M	auguste.pineau@novaryn-tech.com	2019-01-19	1179	1108	SR-BRAND-MKT	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1206	Active	ewagner	Élise	Wagner	F	elise.wagner@novaryn-tech.com	2023-11-05	1071	1161	QA-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1207	Leave	lcosta	Léon	Costa	M	leon.costa@novaryn-tech.com	2018-10-19	1215	1142	CONF-PRE-SALES	Commercial	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1208	Leave	jcaron	Jacqueline	Caron	F	jacqueline.caron@novaryn-tech.com	2023-02-28	1038	1003	DEVOPS-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1209	Active	ahamel	Adèle	Hamel	F	adele.hamel@novaryn-tech.com	2025-02-05	1248	1175	SR-AM-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1210	Terminated	cmerle	Catherine	Merle	F	catherine.merle@novaryn-tech.com	2019-03-26	1042	1114	CONF-PMM-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1211	Active	fschmitt	Frédéric	Schmitt	M	frederic.schmitt@novaryn-tech.com	2025-09-05	1131	1161	BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1212	Active	rbarthelemy	Raymond	Barthelemy	M	raymond.barthelemy@novaryn-tech.com	2012-11-08	1131	1043	LEAD-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1213	Active	jriviere	Jeanne	Rivière	F	jeanne.riviere@novaryn-tech.com	2019-10-07	1194	1104	LEAD-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1214	Leave	cbarthelemy	Christiane	Barthelemy	F	christiane.barthelemy@novaryn-tech.com	2023-05-11	1115	1108	UX-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1215	Active	mfaivre	Margaud	Faivre	F	margaud.faivre@novaryn-tech.com	2019-07-13	1231	1175	SR-ML-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1216	Inactive	claunay	Claude	Launay	F	claude.launay@novaryn-tech.com	2021-04-27	1153	1148	CONF-SCRM-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1217	Active	mleroux	Maurice	Leroux	M	maurice.leroux@novaryn-tech.com	2024-08-25	1137	1065	CONF-AM-SALES	Commercial	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1218	Active	nlebreton	Noël	Lebreton	M	noel.lebreton@novaryn-tech.com	2016-05-29	1209	1242	LEAD-GROWTH-MKT	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1219	Active	jdiaz	Jeanne	Diaz	F	jeanne.diaz@novaryn-tech.com	2016-09-19	1071	1134	LEAD-QA-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1220	Active	vtoussaint	Véronique	Toussaint	F	veronique.toussaint@novaryn-tech.com	2016-01-26	1046	1175	SR-PO-PROD	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1221	Active	gbesnard	Guillaume	Besnard	M	guillaume.besnard@novaryn-tech.com	2013-04-26	1065	1114	SR-FRONT-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1222	Active	ghuet	Guy	Huet	M	guy.huet@novaryn-tech.com	2016-08-15	1186	1065	LEAD-ML-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1223	Inactive	mjulien	Margaret	Julien	F	margaret.julien@novaryn-tech.com	2021-03-10	1121	1048	CONF-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1224	Active	adossantos	Audrey	Dos Santos	F	audrey.dossantos@novaryn-tech.com	2014-07-26	1054	1148	LEAD-PO-PROD	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1225	Active	gjacob	Gabriel	Jacob	M	gabriel.jacob@novaryn-tech.com	2023-10-22	1219	1134	SR-DATA-SCI	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1226	Active	dmunoz	Denis	Munoz	M	denis.munoz@novaryn-tech.com	2015-08-22	1163	1142	LEAD-CSM-SALES	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1227	Terminated	alegros	Arthur	Legros	M	arthur.legros@novaryn-tech.com	2018-12-07	1127	1114	LEAD-BACK-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1228	Active	jallard	Jacques	Allard	M	jacques.allard@novaryn-tech.com	2019-12-05	1138	1134	SR-ADMIN-OP	Finance & Administration	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1229	Active	pbonnet	Patricia	Bonnet	F	patricia.bonnet@novaryn-tech.com	2015-07-09	1151	1060	LEAD-INFRA-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1230	Active	mperrier	Marc	Perrier	M	marc.perrier@novaryn-tech.com	2025-02-04	1162	1043	SR-SCRM-PROD	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1231	Active	sgrenier	Stéphane	Grenier	M	stephane.grenier@novaryn-tech.com	2012-05-01	1072	1175	LEAD-ML-ENG	Technology	Novaryn Tech - Lille	Lille	Hauts-de-France	59000	France
1232	Active	mmartel	Monique	Martel	F	monique.martel@novaryn-tech.com	2012-02-06	1055	1242	CONF-PAYROLL-OP	People & Culture	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1233	Active	jleger	Joseph	Léger	M	joseph.leger@novaryn-tech.com	2024-10-25	1071	1161	ML-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1234	Active	lhumbert	Léon	Humbert	M	leon.humbert@novaryn-tech.com	2021-02-26	1213	1134	CONF-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1235	Active	gcoulon	Geneviève	Coulon	F	genevieve.coulon@novaryn-tech.com	2015-09-25	1168	1043	LEAD-ML-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1236	Active	gnguyen	Grégoire	Nguyen	M	gregoire.nguyen@novaryn-tech.com	2020-04-05	1222	1064	CONF-FRONT-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1237	Active	aperrier1	Alix	Perrier	F	alix.perrier@novaryn-tech.com	2017-09-19	1085	1104	SR-FRONT-ENG	Technology	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1238	Active	oramos	Océane	Ramos	F	oceane.ramos@novaryn-tech.com	2014-10-22	1063	1167	LEAD-SECU-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1239	Active	nrodriguez	Nicolas	Rodriguez	M	nicolas.rodriguez@novaryn-tech.com	2022-08-02	1212	1064	CONF-PRE-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1240	Active	acarlier	Alexandrie	Carlier	F	alexandrie.carlier@novaryn-tech.com	2022-01-25	1086	1065	SR-DEVOPS-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1241	Active	rdupre	Roland	Dupré	M	roland.dupre@novaryn-tech.com	2012-06-17	1016	1175	CONF-FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1242	Leave	aweiss	Aurélie	Weiss	F	aurelie.weiss@novaryn-tech.com	2019-04-17	1146	1065	LEAD-HRBP-HR	People & Culture	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1243	Active	cpinto	Christiane	Pinto	F	christiane.pinto@novaryn-tech.com	2015-02-03	1146	1043	LEAD-SECU-ENG	Technology	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1244	Active	abertin	André	Bertin	M	andre.bertin@novaryn-tech.com	2018-06-13	1059	1172	SR-DATA-ENG	Technology	Novaryn Tech - Bordeaux	Bordeaux	Nouvelle-Aquitaine	33000	France
1245	Active	mlecomte	Marguerite	Lecomte	F	marguerite.lecomte@novaryn-tech.com	2019-09-26	1095	1104	SR-BD-SALES	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1246	Active	mmarques	Marguerite	Marques	F	marguerite.marques@novaryn-tech.com	2024-12-13	1052	1065	FULL-ENG	Technology	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
1247	Active	mlopes1	Monique	Lopes	F	monique.lopes@novaryn-tech.com	2024-10-16	1205	1048	CONT-MKT	Commercial	Novaryn Tech - Marseille	Marseille	Provence-Alpes-Côte d'Azur	13001	France
1248	Active	mfleury	Marc	Fleury	M	marc.fleury@novaryn-tech.com	2013-05-23	1024	1167	LEAD-PRE-SALES	Commercial	Novaryn Tech - Lyon	Lyon	Auvergne-Rhône-Alpes	69001	France
1249	Active	nmoreau	Noël	Moreau	M	noel.moreau@novaryn-tech.com	2024-09-28	1208	1161	BACK-ENG	Technology	Novaryn Tech - Toulouse	Toulouse	Occitanie	31000	France
1250	Terminated	rroux	Richard	Roux	M	richard.roux@novaryn-tech.com	2017-12-14	1139	1175	LEAD-BRAND-MKT	Commercial	Novaryn Tech - Paris	Paris	Île-de-France	75001	France
\.


--
-- TOC entry 5121 (class 0 OID 19724)
-- Dependencies: 221
-- Data for Name: compensation_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compensation_info (user_id, start_date, event_reason, bonus, bonus_base_amount, carallowance, paygroup, paytype, payrollid, targetincentive) FROM stdin;
1001	2024-08-12	Hiring	2.49	34446.87	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1001	857.73
1001	2026-01-04	Data Change	3.32	36274.24	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1001-2	1204.30
1002	2015-10-18	Hiring	10.98	39607.37	0.00	FR_EXEMPT	Salary	PAY-NVT-1002	4348.89
1002	2021-09-19	Promotion	13.76	72737.21	0.00	FR_EXEMPT	Salary	PAY-NVT-1002-2	10648.73
1002	2024-10-03	Promotion	14.79	95076.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1002-3	13919.19
1002	2025-11-08	Data Change	14.64	95076.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1002-4	13919.19
1003	2013-09-28	Hiring	11.48	29091.90	0.00	FR_EXEMPT	Salary	PAY-NVT-1003	3339.75
1003	2016-09-30	Promotion	13.32	43564.76	0.00	FR_EXEMPT	Salary	PAY-NVT-1003-2	6669.76
1003	2019-10-20	Promotion	14.39	52418.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1003-3	8025.28
1003	2025-06-04	Data Change	15.31	69512.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1003-4	10642.33
1004	2021-04-11	Hiring	10.35	76540.40	0.00	FR_EXEMPT	Commission	PAY-NVT-1004	7921.93
1004	2025-11-01	Data Change	13.80	76540.40	0.00	FR_EXEMPT	Commission	PAY-NVT-1004-2	10562.58
1005	2019-03-06	Hiring	12.86	51108.10	0.00	FR_EXEMPT	Commission	PAY-NVT-1005	6572.50
1005	2025-04-02	Promotion	17.31	77393.69	0.00	FR_EXEMPT	Commission	PAY-NVT-1005-2	13265.28
1005	2025-04-21	Data Change	17.14	77954.12	0.00	FR_EXEMPT	Commission	PAY-NVT-1005-3	13361.34
1006	2013-08-05	Hiring	8.30	47349.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1006	3930.01
1006	2022-07-20	Promotion	11.18	132579.88	5400.00	FR_EXEMPT	Salary	PAY-NVT-1006-2	14676.59
1006	2025-07-24	Data Change	11.07	137597.95	5400.00	FR_EXEMPT	Salary	PAY-NVT-1006-3	15232.09
1007	2020-08-06	Hiring	8.45	49422.91	0.00	FR_EXEMPT	Salary	PAY-NVT-1007	4176.24
1007	2023-07-17	Promotion	10.59	67356.98	0.00	FR_EXEMPT	Salary	PAY-NVT-1007-2	7591.13
1007	2025-05-14	Data Change	11.27	69653.64	0.00	FR_EXEMPT	Salary	PAY-NVT-1007-3	7849.97
1008	2015-05-20	Hiring	7.96	75248.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1008	5989.75
1008	2018-05-30	Promotion	10.73	99700.88	5400.00	FR_EXEMPT	Salary	PAY-NVT-1008-2	10588.23
1008	2025-04-11	Data Change	10.62	99738.99	5400.00	FR_EXEMPT	Salary	PAY-NVT-1008-3	10592.28
1009	2019-08-23	Hiring	10.75	39482.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1009	4244.38
1009	2025-09-29	Data Change	14.34	72959.68	4800.00	FR_EXEMPT	Salary	PAY-NVT-1009-2	10462.42
1010	2025-10-08	Hiring	9.61	66833.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1010	6422.68
1011	2025-09-16	Hiring	10.43	93778.34	0.00	FR_EXEMPT	Salary	PAY-NVT-1011	9781.08
1012	2019-03-11	Hiring	20.26	190621.25	0.00	FR_EXECUTIVE	Salary	PAY-NVT-1012	38619.87
1012	2026-01-13	Data Change	27.01	197320.87	8400.00	FR_EXECUTIVE	Salary	PAY-NVT-1012-2	53296.37
1013	2014-08-24	Hiring	9.06	68600.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1013	6215.23
1013	2025-08-04	Data Change	12.08	94622.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1013-2	11430.38
1014	2017-09-22	Hiring	7.81	34150.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1014	2667.15
1014	2025-10-17	Data Change	10.42	64580.42	0.00	FR_EXEMPT	Salary	PAY-NVT-1014-2	6729.28
1015	2018-06-18	Hiring	8.42	97949.59	0.00	FR_EXEMPT	Salary	PAY-NVT-1015	8247.36
1015	2025-04-03	Data Change	11.22	100580.60	4200.00	FR_EXEMPT	Salary	PAY-NVT-1015-2	11285.14
1016	2017-11-07	Hiring	12.41	58275.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1016	7232.02
1016	2020-11-23	Promotion	15.56	85840.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1016-2	14206.60
1016	2023-11-27	Promotion	16.72	97842.37	0.00	FR_EXEMPT	Salary	PAY-NVT-1016-3	16192.91
1016	2025-10-24	Data Change	16.55	108644.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1016-4	17980.67
1017	2025-09-24	Hiring	3.11	44057.24	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1017	1370.18
1018	2019-10-25	Hiring	10.07	45015.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1018	4533.11
1018	2022-11-09	Promotion	11.68	68154.39	0.00	FR_EXEMPT	Salary	PAY-NVT-1018-2	9153.13
1018	2025-10-30	Promotion	12.62	94444.84	5400.00	FR_EXEMPT	Salary	PAY-NVT-1018-3	12683.94
1018	2025-12-29	Data Change	13.43	94444.84	5400.00	FR_EXEMPT	Salary	PAY-NVT-1018-4	12683.94
1019	2018-06-10	Hiring	10.11	69561.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1019	7032.72
1019	2021-05-11	Promotion	12.67	92385.02	0.00	FR_EXEMPT	Salary	PAY-NVT-1019-2	12453.50
1019	2024-05-18	Promotion	13.61	120294.90	0.00	FR_EXEMPT	Salary	PAY-NVT-1019-3	16215.75
1019	2025-08-07	Data Change	13.48	123430.24	0.00	FR_EXEMPT	Salary	PAY-NVT-1019-4	16638.40
1020	2016-12-26	Hiring	8.97	71964.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1020	6455.18
1020	2019-12-28	Promotion	12.08	92747.30	0.00	FR_EXEMPT	Salary	PAY-NVT-1020-2	11092.58
1020	2025-07-10	Data Change	11.96	93191.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1020-3	11145.65
1021	2018-02-25	Hiring	9.45	53557.28	0.00	FR_EXEMPT	Salary	PAY-NVT-1021	5061.16
1021	2021-02-24	Promotion	11.84	75037.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1021-2	9454.66
1021	2024-02-24	Promotion	12.73	87938.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1021-3	11080.26
1021	2026-01-09	Data Change	12.60	87938.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1021-4	11080.26
1022	2023-12-27	Hiring	0.32	33531.16	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1022	107.30
1022	2025-03-29	Data Change	0.43	33531.16	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1022-2	144.18
1023	2023-04-01	Hiring	11.65	96613.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1023	11255.43
1023	2025-09-24	Data Change	15.53	96613.16	5400.00	FR_EXEMPT	Salary	PAY-NVT-1023-2	15004.02
1024	2016-12-03	Hiring	11.83	41377.84	0.00	FR_EXEMPT	Salary	PAY-NVT-1024	4895.00
1024	2019-12-27	Promotion	13.72	61850.28	0.00	FR_EXEMPT	Salary	PAY-NVT-1024-2	9753.79
1024	2022-12-27	Promotion	14.82	86032.41	4800.00	FR_EXEMPT	Salary	PAY-NVT-1024-3	13567.31
1024	2025-11-24	Promotion	15.93	102157.36	4800.00	FR_EXEMPT	Salary	PAY-NVT-1024-4	16110.22
1024	2025-12-30	Data Change	15.77	102157.36	4800.00	FR_EXEMPT	Salary	PAY-NVT-1024-5	16110.22
1025	2013-09-19	Hiring	8.87	41158.59	0.00	FR_EXEMPT	Salary	PAY-NVT-1025	3650.77
1025	2019-10-11	Promotion	11.11	88484.97	4200.00	FR_EXEMPT	Salary	PAY-NVT-1025-2	10458.92
1025	2022-09-14	Promotion	11.94	99127.73	4200.00	FR_EXEMPT	Salary	PAY-NVT-1025-3	11716.90
1025	2025-12-20	Data Change	11.82	99127.73	4200.00	FR_EXEMPT	Salary	PAY-NVT-1025-4	11716.90
1026	2019-09-18	Hiring	12.73	45941.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1026	5848.32
1026	2025-12-18	Data Change	16.98	90751.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1026-2	15409.65
1027	2014-10-07	Hiring	10.45	30052.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1027	3140.51
1027	2017-10-21	Promotion	12.12	44768.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1027-2	6236.20
1027	2025-05-11	Data Change	13.93	66218.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1027-3	9224.17
1028	2015-07-25	Hiring	11.21	55740.18	0.00	FR_EXEMPT	Salary	PAY-NVT-1028	6248.47
1028	2018-07-31	Promotion	13.01	75665.47	0.00	FR_EXEMPT	Salary	PAY-NVT-1028-2	11311.99
1028	2021-07-19	Promotion	14.05	98048.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1028-3	14658.24
1028	2024-08-19	Promotion	15.10	126497.84	0.00	FR_EXEMPT	Salary	PAY-NVT-1028-4	18911.43
1028	2025-04-22	Data Change	14.95	126497.84	0.00	FR_EXEMPT	Salary	PAY-NVT-1028-5	18911.43
1029	2023-08-18	Hiring	3.56	36552.54	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1029	1301.27
1029	2025-03-24	Data Change	4.74	36552.54	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1029-2	1732.59
1030	2022-05-13	Hiring	11.63	51728.88	0.00	FR_EXEMPT	Salary	PAY-NVT-1030	6016.07
1030	2025-05-09	Promotion	14.58	65872.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1030-2	10216.82
1030	2025-07-25	Data Change	15.51	65872.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1030-3	10216.82
1031	2021-02-01	Hiring	7.04	37450.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1031	2636.53
1031	2025-04-28	Data Change	9.38	52119.90	0.00	FR_EXEMPT	Salary	PAY-NVT-1031-2	4888.85
1032	2019-11-12	Hiring	12.25	35657.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1032	4368.02
1032	2022-11-18	Promotion	14.22	51777.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1032-2	8460.49
1032	2025-12-15	Data Change	16.34	65733.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1032-3	10740.93
1033	2022-11-20	Hiring	10.50	76249.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1033	8006.23
1033	2025-01-11	Data Change	14.00	92516.64	0.00	FR_EXEMPT	Salary	PAY-NVT-1033-2	12952.33
1034	2023-08-25	Hiring	3.22	67343.46	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1034	2168.46
1034	2025-03-18	Data Change	4.30	67343.46	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1034-2	2895.77
1035	2025-03-14	Hiring	10.15	79512.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1035	8070.48
1035	2025-04-18	Data Change	13.54	79512.07	6000.00	FR_EXEMPT	Salary	PAY-NVT-1035-2	10765.93
1036	2025-12-24	Hiring	1.86	47625.77	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1036	885.84
1037	2018-10-28	Hiring	9.92	68852.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1037	6830.15
1037	2025-08-08	Data Change	13.23	78020.67	0.00	FR_EXEMPT	Salary	PAY-NVT-1037-2	10322.13
1038	2015-08-04	Hiring	10.49	68760.61	0.00	FR_EXEMPT	Salary	PAY-NVT-1038	7212.99
1038	2021-08-04	Promotion	14.13	118304.62	4200.00	FR_EXEMPT	Salary	PAY-NVT-1038-2	16550.82
1038	2025-02-13	Data Change	13.99	118304.62	4200.00	FR_EXEMPT	Salary	PAY-NVT-1038-3	16550.82
1039	2017-05-09	Hiring	12.29	84816.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1039	10423.93
1039	2020-04-24	Promotion	16.55	98074.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1039-2	16074.39
1039	2025-12-16	Data Change	16.39	98074.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1039-3	16074.39
1040	2020-06-29	Hiring	6.37	44999.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1040	2866.47
1040	2023-06-23	Promotion	7.39	58301.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1040-2	4949.76
1040	2025-11-07	Data Change	8.49	58301.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1040-3	4949.76
1041	2019-10-22	Hiring	10.55	42362.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1041	4469.24
1041	2025-11-15	Promotion	13.23	72597.21	0.00	FR_EXEMPT	Salary	PAY-NVT-1041-2	10214.43
1041	2026-01-05	Data Change	14.07	72597.21	0.00	FR_EXEMPT	Salary	PAY-NVT-1041-3	10214.43
1042	2014-05-17	Hiring	12.52	33012.71	0.00	FR_EXEMPT	Salary	PAY-NVT-1042	4133.19
1042	2020-05-12	Promotion	15.70	57950.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1042-2	9677.73
1042	2023-04-17	Promotion	16.87	65125.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1042-3	10875.90
1042	2025-04-06	Data Change	16.70	65125.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1042-4	10875.90
1043	2021-07-20	Hiring	10.23	70928.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1043	7256.00
1043	2024-08-15	Promotion	13.78	87297.91	0.00	FR_EXEMPT	Salary	PAY-NVT-1043-2	11907.43
1043	2025-08-11	Data Change	13.64	88639.62	0.00	FR_EXEMPT	Salary	PAY-NVT-1043-3	12090.44
1044	2024-09-15	Hiring	6.23	52235.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1044	3254.28
1044	2025-08-30	Data Change	8.31	52930.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1044-2	4398.52
1045	2021-12-04	Hiring	11.04	65462.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1045	7227.09
1045	2025-05-02	Data Change	14.72	65462.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1045-2	9636.12
1046	2015-09-24	Hiring	8.42	36780.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1046	3096.88
1046	2018-10-09	Promotion	9.77	53226.48	0.00	FR_EXEMPT	Salary	PAY-NVT-1046-2	5977.33
1046	2024-10-12	Promotion	11.34	79987.03	5400.00	FR_EXEMPT	Salary	PAY-NVT-1046-3	8982.54
1046	2025-08-01	Data Change	11.23	80966.55	5400.00	FR_EXEMPT	Salary	PAY-NVT-1046-4	9092.54
1047	2020-05-24	Hiring	11.81	54172.89	0.00	FR_EXEMPT	Salary	PAY-NVT-1047	6397.82
1047	2025-07-11	Data Change	15.75	72560.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1047-2	11428.24
1048	2012-10-19	Hiring	13.37	28279.59	0.00	FR_EXEMPT	Salary	PAY-NVT-1048	3780.98
1048	2018-09-29	Promotion	16.76	56723.12	0.00	FR_EXEMPT	Salary	PAY-NVT-1048-2	10113.73
1048	2025-07-02	Data Change	17.83	65405.67	0.00	FR_EXEMPT	Salary	PAY-NVT-1048-3	11661.83
1049	2022-09-03	Hiring	5.71	34958.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1049	1996.13
1049	2025-08-16	Promotion	6.63	51864.71	0.00	FR_EXEMPT	Salary	PAY-NVT-1049-2	3952.09
1049	2025-08-26	Data Change	7.62	51864.71	0.00	FR_EXEMPT	Salary	PAY-NVT-1049-3	3952.09
1050	2019-03-08	Hiring	8.95	58361.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1050	5223.40
1050	2022-03-28	Promotion	11.21	78879.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1050-2	9410.30
1050	2025-03-26	Promotion	12.05	98866.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1050-3	11794.76
1050	2025-10-21	Data Change	11.93	103087.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1050-4	12298.39
1051	2018-07-18	Hiring	7.94	40260.95	0.00	FR_EXEMPT	Salary	PAY-NVT-1051	3196.72
1051	2021-08-06	Promotion	9.21	54627.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1051-2	5785.05
1051	2024-07-25	Promotion	9.95	71605.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1051-3	7583.06
1051	2025-01-22	Data Change	10.59	71605.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1051-4	7583.06
1052	2019-12-18	Hiring	8.14	45127.08	0.00	FR_EXEMPT	Salary	PAY-NVT-1052	3673.34
1052	2022-11-21	Promotion	9.44	59479.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1052-2	6453.50
1052	2025-12-25	Promotion	10.20	88683.78	5400.00	FR_EXEMPT	Salary	PAY-NVT-1052-3	9622.19
1052	2026-02-18	Data Change	10.85	89123.69	5400.00	FR_EXEMPT	Salary	PAY-NVT-1052-4	9669.92
1053	2012-03-12	Hiring	12.50	47578.91	0.00	FR_EXEMPT	Salary	PAY-NVT-1053	5947.36
1053	2015-03-19	Promotion	14.49	62032.83	0.00	FR_EXEMPT	Salary	PAY-NVT-1053-2	10334.67
1053	2021-03-24	Promotion	16.83	107508.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1053-3	17910.84
1053	2025-09-15	Data Change	16.66	121610.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1053-4	20260.38
1054	2013-12-12	Hiring	11.45	70618.70	0.00	FR_EXEMPT	Salary	PAY-NVT-1054	8085.84
1054	2016-12-20	Promotion	15.42	87152.98	0.00	FR_EXEMPT	Salary	PAY-NVT-1054-2	13308.26
1054	2025-05-18	Data Change	15.27	88140.28	0.00	FR_EXEMPT	Salary	PAY-NVT-1054-3	13459.02
1084	2013-03-16	Hiring	12.39	67484.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1084	8361.34
1055	2022-11-26	Hiring	8.04	125968.70	0.00	FR_EXEMPT	Salary	PAY-NVT-1055	10127.88
1055	2025-11-30	Data Change	10.72	151671.05	6000.00	FR_EXEMPT	Salary	PAY-NVT-1055-2	16259.14
1056	2016-12-28	Hiring	12.45	65299.96	0.00	FR_EXEMPT	Salary	PAY-NVT-1056	8129.85
1056	2019-12-24	Promotion	15.60	99210.41	5400.00	FR_EXEMPT	Salary	PAY-NVT-1056-2	16468.93
1056	2025-09-06	Data Change	16.60	123459.41	5400.00	FR_EXEMPT	Salary	PAY-NVT-1056-3	20494.26
1057	2019-09-20	Hiring	12.33	38355.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1057	4729.18
1057	2022-09-10	Promotion	14.30	49990.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1057-2	8218.42
1057	2025-10-17	Data Change	16.44	79345.72	6000.00	FR_EXEMPT	Salary	PAY-NVT-1057-3	13044.44
1058	2024-03-29	Hiring	7.29	52733.74	0.00	FR_EXEMPT	Commission	PAY-NVT-1058	3844.29
1058	2025-10-21	Data Change	9.72	54741.61	0.00	FR_EXEMPT	Commission	PAY-NVT-1058-2	5320.88
1059	2024-12-17	Hiring	12.96	84496.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1059	10950.75
1059	2025-08-30	Data Change	17.28	84496.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1059-2	14601.00
1060	2013-10-23	Hiring	10.22	36061.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1060	3685.51
1060	2026-01-27	Data Change	13.63	92771.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1060-2	12644.69
1061	2020-08-20	Hiring	12.50	87865.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1061	10983.16
1061	2025-01-08	Data Change	16.67	90640.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1061-2	15109.75
1062	2018-05-12	Hiring	11.62	37756.39	0.00	FR_EXEMPT	Salary	PAY-NVT-1062	4387.29
1062	2021-05-12	Promotion	13.48	59987.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1062-2	9292.00
1062	2025-02-19	Data Change	15.49	81566.59	5400.00	FR_EXEMPT	Salary	PAY-NVT-1062-3	12634.66
1063	2025-03-31	Hiring	7.80	124382.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1063	9701.84
1063	2025-09-19	Data Change	10.40	124382.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1063-2	12935.78
1064	2017-07-07	Hiring	12.72	67696.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1064	8610.99
1064	2025-04-30	Data Change	16.96	84392.18	0.00	FR_EXEMPT	Salary	PAY-NVT-1064-2	14312.91
1065	2013-11-26	Hiring	12.29	66271.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1065	8144.71
1065	2016-11-20	Promotion	16.55	82129.40	0.00	FR_EXEMPT	Salary	PAY-NVT-1065-2	13461.01
1065	2025-04-21	Data Change	16.39	87596.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1065-3	14357.12
1066	2016-01-27	Hiring	15.59	200422.84	0.00	FR_EXECUTIVE	Commission	PAY-NVT-1066	31245.92
1066	2025-04-21	Data Change	20.79	204818.88	9600.00	FR_EXECUTIVE	Commission	PAY-NVT-1066-2	42581.85
1067	2021-08-26	Hiring	7.76	54180.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1067	4204.39
1067	2024-08-12	Promotion	9.73	65188.71	0.00	FR_EXEMPT	Salary	PAY-NVT-1067-2	6747.03
1067	2026-01-19	Data Change	10.35	68536.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1067-3	7093.56
1068	2024-06-13	Hiring	5.99	64595.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1068	3869.25
1068	2025-06-17	Data Change	7.98	65899.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1068-2	5258.80
1069	2024-12-09	Hiring	2.67	46549.75	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1069	1242.88
1069	2025-08-09	Data Change	3.56	46800.60	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1069-2	1666.10
1070	2014-02-20	Hiring	12.11	34718.36	0.00	FR_EXEMPT	Salary	PAY-NVT-1070	4204.39
1070	2017-02-14	Promotion	14.05	44927.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1070-2	7255.80
1070	2025-09-25	Data Change	16.15	81852.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1070-3	13219.18
1071	2020-02-01	Hiring	9.38	63580.18	0.00	FR_EXEMPT	Salary	PAY-NVT-1071	5963.82
1071	2026-02-21	Promotion	12.62	103046.12	5400.00	FR_EXEMPT	Salary	PAY-NVT-1071-2	12880.76
1072	2016-07-05	Hiring	9.73	105492.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1072	10264.44
1072	2019-06-21	Promotion	13.11	125140.49	4200.00	FR_EXEMPT	Salary	PAY-NVT-1072-2	16243.24
1072	2025-09-07	Data Change	12.98	128760.15	4200.00	FR_EXEMPT	Salary	PAY-NVT-1072-3	16713.07
1073	2019-03-14	Hiring	7.81	40212.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1073	3140.58
1073	2022-02-26	Promotion	9.06	50537.66	0.00	FR_EXEMPT	Salary	PAY-NVT-1073-2	5260.97
1073	2025-07-18	Data Change	10.41	71025.36	5400.00	FR_EXEMPT	Salary	PAY-NVT-1073-3	7393.74
1074	2024-11-06	Hiring	1.04	34059.02	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1074	354.21
1074	2025-04-22	Data Change	1.39	36283.58	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1074-2	504.34
1075	2017-04-20	Hiring	12.48	75901.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1075	9472.46
1075	2025-10-19	Data Change	16.64	113908.42	0.00	FR_EXEMPT	Salary	PAY-NVT-1075-2	18954.36
1076	2023-01-21	Hiring	11.45	41232.40	0.00	FR_EXEMPT	Salary	PAY-NVT-1076	4721.11
1076	2025-01-28	Data Change	15.26	54171.00	0.00	FR_EXEMPT	Salary	PAY-NVT-1076-2	8266.49
1077	2020-10-21	Hiring	9.72	87995.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1077	8553.14
1077	2025-12-30	Data Change	12.96	88989.89	0.00	FR_EXEMPT	Salary	PAY-NVT-1077-2	11533.09
1078	2016-03-20	Hiring	10.04	35713.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1078	3585.61
1078	2019-03-25	Promotion	11.65	51358.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1078-2	6876.94
1078	2022-04-13	Promotion	12.59	68602.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1078-3	9185.85
1078	2025-04-04	Promotion	13.52	77196.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1078-4	10336.62
1078	2025-06-17	Data Change	13.39	77196.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1078-5	10336.62
1079	2017-10-01	Hiring	11.50	66575.18	0.00	FR_EXEMPT	Salary	PAY-NVT-1079	7656.15
1079	2023-10-24	Promotion	15.49	116227.34	6000.00	FR_EXEMPT	Salary	PAY-NVT-1079-2	17829.27
1079	2025-12-21	Data Change	15.34	117873.63	6000.00	FR_EXEMPT	Salary	PAY-NVT-1079-3	18081.81
1080	2021-06-03	Hiring	6.01	45983.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1080	2763.59
1080	2024-06-23	Promotion	6.97	64003.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1080-2	5126.68
1080	2025-09-07	Data Change	8.01	64003.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1080-3	5126.68
1081	2015-09-30	Hiring	13.03	30776.59	0.00	FR_EXEMPT	Salary	PAY-NVT-1081	4010.19
1081	2018-10-20	Promotion	15.11	44610.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1081-2	7748.86
1081	2021-10-04	Promotion	16.33	67649.43	0.00	FR_EXEMPT	Salary	PAY-NVT-1081-3	11750.71
1081	2024-10-26	Promotion	17.54	76745.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1081-4	13330.72
1081	2026-01-10	Data Change	17.37	76745.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1081-5	13330.72
1082	2024-01-16	Hiring	8.72	68310.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1082	5956.71
1082	2025-01-09	Data Change	11.63	76273.19	0.00	FR_EXEMPT	Salary	PAY-NVT-1082-2	8870.57
1083	2013-02-22	Hiring	9.54	35043.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1083	3343.18
1083	2016-02-27	Promotion	11.07	52454.94	0.00	FR_EXEMPT	Salary	PAY-NVT-1083-2	6672.27
1083	2022-03-06	Promotion	12.85	93613.70	4800.00	FR_EXEMPT	Salary	PAY-NVT-1083-3	11907.66
1083	2025-06-30	Data Change	12.72	93613.70	4800.00	FR_EXEMPT	Salary	PAY-NVT-1083-4	11907.66
1084	2019-02-16	Promotion	16.69	106737.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1084-2	17633.09
1084	2025-12-08	Data Change	16.52	111437.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1084-3	18409.55
1085	2016-09-26	Hiring	10.28	46823.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1085	4813.51
1085	2022-09-30	Promotion	12.89	97604.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1085-2	13381.55
1085	2025-09-29	Promotion	13.85	113485.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1085-3	15558.85
1085	2025-12-22	Data Change	13.71	125455.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1085-4	17199.93
1086	2021-03-04	Hiring	10.15	73003.82	0.00	FR_EXEMPT	Salary	PAY-NVT-1086	7409.89
1086	2024-02-05	Promotion	13.68	93211.14	5400.00	FR_EXEMPT	Salary	PAY-NVT-1086-2	12620.79
1086	2026-02-02	Data Change	13.54	93211.14	5400.00	FR_EXEMPT	Salary	PAY-NVT-1086-3	12620.79
1087	2021-09-18	Hiring	8.24	37835.82	0.00	FR_EXEMPT	Salary	PAY-NVT-1087	3117.67
1087	2024-08-25	Promotion	9.56	46848.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1087-2	5148.70
1087	2025-03-21	Data Change	10.99	46848.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1087-3	5148.70
1088	2016-02-18	Hiring	10.93	78237.76	0.00	FR_EXEMPT	Salary	PAY-NVT-1088	8551.39
1088	2019-01-23	Promotion	13.70	100321.91	6000.00	FR_EXEMPT	Salary	PAY-NVT-1088-2	14616.90
1088	2022-02-01	Promotion	14.72	121646.61	6000.00	FR_EXEMPT	Salary	PAY-NVT-1088-3	17723.91
1088	2026-01-17	Data Change	14.57	121646.61	6000.00	FR_EXEMPT	Salary	PAY-NVT-1088-4	17723.91
1089	2015-03-29	Hiring	11.75	53696.55	0.00	FR_EXEMPT	Salary	PAY-NVT-1089	6309.34
1089	2018-04-12	Promotion	14.72	75734.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1089-2	11860.03
1089	2025-04-24	Data Change	15.66	100004.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1089-3	15660.76
1090	2023-03-18	Hiring	1.25	35618.58	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1090	445.23
1090	2025-11-23	Data Change	1.67	35618.58	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1090-2	594.83
1091	2019-03-17	Hiring	11.00	39066.83	0.00	FR_EXEMPT	Salary	PAY-NVT-1091	4297.35
1091	2022-02-26	Promotion	12.75	54252.06	0.00	FR_EXEMPT	Salary	PAY-NVT-1091-2	7953.35
1091	2025-03-23	Promotion	13.78	75843.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1091-3	11118.64
1091	2025-11-21	Data Change	14.66	77656.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1091-4	11384.48
1092	2024-05-27	Hiring	9.76	102200.85	0.00	FR_EXEMPT	Salary	PAY-NVT-1092	9974.80
1092	2026-01-13	Data Change	13.01	111438.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1092-2	14498.17
1093	2023-02-12	Hiring	8.78	71021.86	0.00	FR_EXEMPT	Commission	PAY-NVT-1093	6235.72
1093	2026-02-06	Promotion	11.83	93172.55	0.00	FR_EXEMPT	Commission	PAY-NVT-1093-2	10910.51
1094	2013-01-11	Hiring	10.66	51670.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1094	5508.08
1094	2016-01-29	Promotion	12.36	74134.47	0.00	FR_EXEMPT	Salary	PAY-NVT-1094-2	10534.51
1094	2019-02-04	Promotion	13.36	97819.85	0.00	FR_EXEMPT	Salary	PAY-NVT-1094-3	13900.20
1094	2025-12-23	Data Change	14.21	122679.28	0.00	FR_EXEMPT	Salary	PAY-NVT-1094-4	17432.73
1095	2017-10-09	Hiring	8.49	49763.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1095	4224.95
1095	2020-09-14	Promotion	10.64	62326.82	6000.00	FR_EXEMPT	Salary	PAY-NVT-1095-2	7055.40
1095	2025-09-12	Data Change	11.32	85112.20	6000.00	FR_EXEMPT	Salary	PAY-NVT-1095-3	9634.70
1096	2015-04-05	Hiring	12.35	79812.69	0.00	FR_EXEMPT	Commission	PAY-NVT-1096	9856.87
1096	2025-07-21	Data Change	16.47	82390.45	4800.00	FR_EXEMPT	Commission	PAY-NVT-1096-2	13569.71
1097	2019-08-19	Hiring	8.48	81066.23	0.00	FR_EXEMPT	Salary	PAY-NVT-1097	6874.42
1097	2025-11-24	Data Change	11.30	82033.37	4800.00	FR_EXEMPT	Salary	PAY-NVT-1097-2	9269.77
1098	2015-02-14	Hiring	9.21	70923.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1098	6532.05
1098	2018-02-03	Promotion	11.54	88021.40	0.00	FR_EXEMPT	Salary	PAY-NVT-1098-2	10809.03
1098	2025-12-27	Data Change	12.28	123714.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1098-3	15192.10
1099	2016-04-01	Hiring	9.99	38169.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1099	3813.14
1099	2019-05-01	Promotion	11.59	50827.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1099-2	6770.24
1099	2025-03-04	Promotion	13.45	88953.59	0.00	FR_EXEMPT	Salary	PAY-NVT-1099-3	11848.62
1099	2025-05-03	Data Change	13.32	90630.94	0.00	FR_EXEMPT	Salary	PAY-NVT-1099-4	12072.04
1100	2025-09-29	Hiring	2.97	51049.72	0.00	FR_INTERN	Salary	PAY-NVT-1100	1516.18
1101	2012-11-10	Hiring	7.61	66156.94	0.00	FR_EXEMPT	Salary	PAY-NVT-1101	5034.54
1101	2025-07-18	Data Change	10.15	79259.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1101-2	8044.85
1102	2012-04-01	Hiring	7.79	118380.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1102	9221.86
1102	2025-09-26	Data Change	10.38	118380.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1102-2	12287.92
1103	2016-01-08	Hiring	11.81	61337.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1103	7243.99
1103	2018-12-19	Promotion	14.81	76624.46	4200.00	FR_EXEMPT	Salary	PAY-NVT-1103-2	12068.35
1103	2021-12-25	Promotion	15.91	102026.03	4200.00	FR_EXEMPT	Salary	PAY-NVT-1103-3	16069.10
1103	2025-02-15	Data Change	15.75	103884.32	4200.00	FR_EXEMPT	Salary	PAY-NVT-1103-4	16361.78
1104	2020-04-05	Hiring	7.88	36222.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1104	2854.31
1104	2025-12-03	Data Change	10.50	52961.13	0.00	FR_EXEMPT	Salary	PAY-NVT-1104-2	5560.92
1105	2018-10-27	Hiring	12.23	72437.68	0.00	FR_EXEMPT	Salary	PAY-NVT-1105	8859.13
1105	2025-01-13	Data Change	16.31	94620.08	4200.00	FR_EXEMPT	Salary	PAY-NVT-1105-2	15432.54
1106	2018-06-12	Hiring	10.37	58702.31	0.00	FR_EXEMPT	Salary	PAY-NVT-1106	6087.43
1106	2021-05-17	Promotion	12.03	72969.02	0.00	FR_EXEMPT	Salary	PAY-NVT-1106-2	10091.62
1106	2024-06-19	Promotion	13.00	103300.49	4800.00	FR_EXEMPT	Salary	PAY-NVT-1106-3	14286.46
1106	2025-06-03	Data Change	13.83	105098.90	4800.00	FR_EXEMPT	Salary	PAY-NVT-1106-4	14535.18
1107	2016-07-05	Hiring	9.36	48514.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1107	4540.94
1107	2022-07-14	Promotion	12.60	80798.26	6000.00	FR_EXEMPT	Salary	PAY-NVT-1107-2	10083.62
1107	2025-04-21	Data Change	12.48	86428.87	6000.00	FR_EXEMPT	Salary	PAY-NVT-1107-3	10786.32
1108	2019-03-13	Hiring	10.12	39592.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1108	4006.76
1108	2022-03-25	Promotion	11.75	50745.06	0.00	FR_EXEMPT	Salary	PAY-NVT-1108-2	6850.58
1108	2025-03-19	Promotion	12.69	68261.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1108-3	9215.32
1108	2025-05-21	Data Change	13.50	68261.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1108-4	9215.32
1109	2024-03-22	Hiring	10.61	117959.09	0.00	FR_EXEMPT	Salary	PAY-NVT-1109	12515.46
1109	2025-10-04	Data Change	14.15	117959.09	0.00	FR_EXEMPT	Salary	PAY-NVT-1109-2	16691.21
1110	2015-03-25	Hiring	9.34	62987.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1110	5883.06
1110	2025-10-06	Data Change	12.45	98827.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1110-2	12303.96
1111	2012-12-29	Hiring	12.25	43839.61	0.00	FR_EXEMPT	Salary	PAY-NVT-1111	5370.35
1111	2016-01-11	Promotion	14.21	57905.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1111-2	9456.03
1111	2021-12-21	Promotion	16.49	104043.63	6000.00	FR_EXEMPT	Salary	PAY-NVT-1111-3	16990.32
1111	2025-08-26	Data Change	16.33	104043.63	6000.00	FR_EXEMPT	Salary	PAY-NVT-1111-4	16990.32
1112	2017-05-02	Hiring	12.17	44809.98	0.00	FR_EXEMPT	Salary	PAY-NVT-1112	5453.37
1112	2020-04-07	Promotion	15.26	66527.24	6000.00	FR_EXEMPT	Salary	PAY-NVT-1112-2	10797.37
1112	2025-04-19	Data Change	16.23	76659.49	6000.00	FR_EXEMPT	Salary	PAY-NVT-1112-3	12441.84
1113	2021-12-08	Hiring	5.84	36148.48	0.00	FR_EXEMPT	Salary	PAY-NVT-1113	2111.07
1113	2025-01-03	Promotion	6.78	46938.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1113-2	3656.52
1113	2025-03-01	Data Change	7.79	50315.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1113-3	3919.57
1114	2021-01-13	Hiring	7.45	37385.82	0.00	FR_EXEMPT	Salary	PAY-NVT-1114	2785.24
1114	2025-07-11	Data Change	9.93	47135.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1114-2	4680.51
1115	2020-08-21	Hiring	11.78	55532.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1115	6541.76
1115	2023-09-09	Promotion	14.77	72502.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1115-2	11390.11
1115	2025-08-13	Data Change	15.71	72502.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1115-3	11390.11
1116	2013-03-01	Hiring	9.30	87358.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1116	8124.35
1116	2025-11-02	Data Change	12.40	90629.96	4800.00	FR_EXEMPT	Salary	PAY-NVT-1116-2	11238.12
1117	2023-06-27	Hiring	1.75	49026.28	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1117	857.96
1117	2025-08-27	Data Change	2.34	49026.28	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1117-2	1147.21
1118	2014-01-14	Hiring	12.11	97148.23	0.00	FR_EXEMPT	Salary	PAY-NVT-1118	11764.65
1118	2016-12-29	Promotion	16.31	119344.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1118-2	19274.14
1118	2025-03-09	Data Change	16.15	125738.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1118-3	20306.73
1119	2021-11-06	Hiring	12.47	85317.02	0.00	FR_EXEMPT	Salary	PAY-NVT-1119	10639.03
1119	2026-01-26	Data Change	16.63	90218.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1119-2	15003.38
1120	2013-05-24	Hiring	8.48	44738.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1120	3793.83
1120	2016-05-17	Promotion	9.83	70152.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1120-2	7927.21
1120	2025-11-13	Data Change	11.30	118299.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1120-3	13367.79
1121	2021-12-05	Hiring	8.25	62038.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1121	5118.17
1121	2024-12-07	Promotion	10.34	84875.04	4200.00	FR_EXEMPT	Salary	PAY-NVT-1121-2	9336.25
1121	2025-03-29	Data Change	11.00	84875.04	4200.00	FR_EXEMPT	Salary	PAY-NVT-1121-3	9336.25
1122	2017-05-19	Hiring	13.04	78181.34	0.00	FR_EXEMPT	Salary	PAY-NVT-1122	10194.85
1122	2025-06-26	Data Change	17.39	84502.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1122-2	14694.97
1123	2023-05-24	Hiring	0.11	40403.97	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1123	44.44
1123	2025-03-25	Data Change	0.15	40403.97	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1123-2	60.61
1124	2016-07-08	Hiring	7.86	46822.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1124	3680.27
1124	2022-07-26	Promotion	10.58	77934.00	6000.00	FR_EXEMPT	Salary	PAY-NVT-1124-2	8167.48
1124	2026-01-16	Data Change	10.48	79674.54	6000.00	FR_EXEMPT	Salary	PAY-NVT-1124-3	8349.89
1125	2023-06-05	Hiring	1.93	31546.25	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1125	608.84
1125	2025-10-11	Data Change	2.57	31546.25	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1125-2	810.74
1126	2019-10-12	Hiring	8.99	46743.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1126	4202.20
1126	2025-10-28	Data Change	11.99	84900.30	0.00	FR_EXEMPT	Salary	PAY-NVT-1126-2	10179.55
1127	2013-03-26	Hiring	12.77	42800.23	0.00	FR_EXEMPT	Salary	PAY-NVT-1127	5465.59
1127	2016-03-13	Promotion	14.82	63198.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1127-2	10762.71
1127	2019-03-30	Promotion	16.01	79288.17	4200.00	FR_EXEMPT	Salary	PAY-NVT-1127-3	13502.78
1127	2022-03-20	Promotion	17.20	108358.76	4200.00	FR_EXEMPT	Salary	PAY-NVT-1127-4	18453.50
1127	2025-12-26	Data Change	17.03	112290.75	4200.00	FR_EXEMPT	Salary	PAY-NVT-1127-5	19123.11
1128	2022-07-26	Hiring	24.93	201471.27	0.00	FR_EXECUTIVE	Salary	PAY-NVT-1128	50226.79
1128	2025-12-12	Data Change	33.24	201471.27	9600.00	FR_EXECUTIVE	Salary	PAY-NVT-1128-2	66969.05
1129	2013-03-31	Hiring	10.92	33526.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1129	3661.12
1129	2019-03-23	Promotion	13.69	64699.69	0.00	FR_EXEMPT	Salary	PAY-NVT-1129-2	9420.27
1129	2022-04-20	Promotion	14.71	75194.09	0.00	FR_EXEMPT	Salary	PAY-NVT-1129-3	10948.26
1129	2025-03-27	Data Change	14.56	76536.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1129-4	11143.65
1130	2020-08-09	Hiring	4.26	34128.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1130	1453.87
1130	2023-07-20	Promotion	4.94	54534.82	0.00	FR_EXEMPT	Salary	PAY-NVT-1130-2	3097.58
1130	2025-09-13	Data Change	5.68	54534.82	0.00	FR_EXEMPT	Salary	PAY-NVT-1130-3	3097.58
1131	2017-12-08	Hiring	7.77	53600.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1131	4164.77
1131	2020-11-18	Promotion	9.74	66912.05	5400.00	FR_EXEMPT	Salary	PAY-NVT-1131-2	6932.09
1131	2025-02-17	Data Change	10.36	90114.94	5400.00	FR_EXEMPT	Salary	PAY-NVT-1131-3	9335.91
1132	2018-04-15	Hiring	12.55	40652.40	0.00	FR_EXEMPT	Salary	PAY-NVT-1132	5101.88
1132	2025-12-13	Data Change	16.74	76535.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1132-2	12812.05
1133	2019-06-15	Hiring	13.38	96287.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1133	12883.24
1133	2022-05-26	Promotion	16.77	118671.42	0.00	FR_EXEMPT	Salary	PAY-NVT-1133-2	21170.98
1133	2025-05-31	Promotion	18.02	147235.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1133-3	26266.81
1133	2025-08-22	Data Change	17.84	147235.51	0.00	FR_EXEMPT	Salary	PAY-NVT-1133-4	26266.81
1134	2025-09-24	Hiring	6.79	50884.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1134	3455.08
1135	2012-02-18	Hiring	7.69	51060.03	0.00	FR_EXEMPT	Salary	PAY-NVT-1135	3926.52
1135	2015-01-22	Promotion	9.63	63215.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1135-2	6479.57
1135	2025-05-08	Data Change	10.25	77956.47	0.00	FR_EXEMPT	Salary	PAY-NVT-1135-3	7990.54
1136	2017-02-03	Hiring	12.59	49801.24	0.00	FR_EXEMPT	Salary	PAY-NVT-1136	6269.98
1136	2023-03-01	Promotion	15.78	97885.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1136-2	16434.99
1136	2025-05-04	Data Change	16.79	132028.90	0.00	FR_EXEMPT	Salary	PAY-NVT-1136-3	22167.65
1137	2014-04-14	Hiring	10.78	53949.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1137	5815.71
1137	2017-04-14	Promotion	13.51	74592.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1137-2	10718.89
1137	2020-05-07	Promotion	14.51	91790.15	0.00	FR_EXEMPT	Salary	PAY-NVT-1137-3	13190.24
1137	2025-06-05	Data Change	14.37	94463.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1137-4	13574.41
1138	2013-10-27	Hiring	8.85	63109.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1138	5585.15
1138	2025-03-26	Data Change	11.80	75231.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1138-2	8877.37
1139	2016-08-19	Hiring	11.83	36068.15	0.00	FR_EXEMPT	Salary	PAY-NVT-1139	4266.86
1139	2019-09-01	Promotion	13.72	48719.34	0.00	FR_EXEMPT	Salary	PAY-NVT-1139-2	7683.04
1139	2022-08-26	Promotion	14.82	59456.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1139-3	9376.33
1139	2025-07-28	Promotion	15.93	78660.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1139-4	12404.76
1139	2026-01-29	Data Change	15.77	78660.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1139-5	12404.76
1140	2015-08-01	Hiring	9.23	62704.85	0.00	FR_EXEMPT	Salary	PAY-NVT-1140	5787.66
1140	2018-07-28	Promotion	11.56	84809.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1140-2	10431.53
1140	2021-07-13	Promotion	12.42	112605.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1140-3	13850.51
1140	2025-05-14	Data Change	12.30	112605.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1140-4	13850.51
1141	2023-09-11	Hiring	1.02	36782.43	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1141	375.18
1141	2026-01-16	Data Change	1.36	36782.43	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1141-2	500.24
1142	2020-04-23	Hiring	15.59	188817.01	0.00	FR_EXECUTIVE	Salary	PAY-NVT-1142	29436.57
1142	2025-09-30	Data Change	20.79	188817.01	9600.00	FR_EXECUTIVE	Salary	PAY-NVT-1142-2	39255.06
1143	2013-07-27	Hiring	13.11	52901.43	0.00	FR_EXEMPT	Salary	PAY-NVT-1143	6935.38
1143	2016-08-04	Promotion	16.43	68486.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1143-2	11971.36
1143	2019-08-26	Promotion	17.65	87278.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1143-3	15256.29
1143	2025-02-16	Data Change	17.48	95406.66	0.00	FR_EXEMPT	Salary	PAY-NVT-1143-4	16677.08
1144	2016-09-15	Hiring	10.71	50518.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1144	5410.58
1144	2019-08-18	Promotion	12.42	72782.48	0.00	FR_EXEMPT	Salary	PAY-NVT-1144-2	10393.34
1144	2022-10-15	Promotion	13.42	90743.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1144-3	12958.16
1144	2025-03-09	Data Change	14.28	114987.99	0.00	FR_EXEMPT	Salary	PAY-NVT-1144-4	16420.28
1145	2017-09-03	Hiring	12.52	90516.48	0.00	FR_EXEMPT	Salary	PAY-NVT-1145	11332.66
1145	2026-02-03	Data Change	16.69	129411.40	0.00	FR_EXEMPT	Salary	PAY-NVT-1145-2	21598.76
1146	2016-06-15	Hiring	13.39	55000.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1146	7364.54
1146	2019-05-24	Promotion	16.79	72421.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1146-2	12934.54
1146	2025-03-06	Data Change	17.86	96913.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1146-3	17308.74
1147	2019-07-08	Hiring	9.49	51953.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1147	4930.34
1147	2022-07-12	Promotion	11.89	63790.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1147-2	8069.45
1147	2025-07-23	Promotion	12.78	79392.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1147-3	10043.11
1147	2025-09-14	Data Change	12.65	79392.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1147-4	10043.11
1148	2012-03-01	Hiring	12.88	39894.70	0.00	FR_EXEMPT	Salary	PAY-NVT-1148	5138.44
1148	2015-03-12	Promotion	14.95	55702.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1148-2	9569.77
1148	2021-02-05	Promotion	17.35	82075.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1148-3	14100.49
1148	2025-03-12	Data Change	17.18	84002.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1148-4	14431.56
1149	2023-10-03	Hiring	1.44	33514.42	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1149	482.61
1149	2025-07-25	Data Change	1.92	38196.56	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1149-2	733.37
1150	2012-08-11	Hiring	8.21	33793.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1150	2774.41
1150	2015-07-29	Promotion	9.53	49080.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1150-2	5374.32
1150	2018-07-25	Promotion	10.29	67355.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1150-3	7375.47
1150	2025-02-09	Data Change	10.95	88320.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1150-4	9671.14
1151	2021-05-26	Hiring	9.71	65400.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1151	6350.34
1151	2024-05-12	Promotion	12.16	78630.58	4800.00	FR_EXEMPT	Salary	PAY-NVT-1151-2	10174.80
1151	2025-08-30	Data Change	12.94	84917.65	4800.00	FR_EXEMPT	Salary	PAY-NVT-1151-3	10988.34
1152	2014-03-02	Hiring	11.48	85648.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1152	9832.48
1152	2025-06-04	Data Change	15.31	85648.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1152-2	13112.83
1153	2018-03-15	Hiring	8.18	81603.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1153	6675.19
1153	2025-04-08	Data Change	10.90	94142.39	0.00	FR_EXEMPT	Salary	PAY-NVT-1153-2	10261.52
1154	2015-07-29	Hiring	11.00	36432.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1154	4007.60
1154	2024-07-31	Promotion	14.82	81379.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1154-2	11938.38
1154	2025-11-04	Data Change	14.67	81379.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1154-3	11938.38
1155	2023-05-07	Hiring	11.54	74407.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1155	8586.62
1155	2025-10-29	Data Change	15.38	74460.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1155-2	11452.00
1156	2025-04-09	Hiring	3.73	65724.85	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1156	2451.54
1156	2025-05-27	Data Change	4.97	68476.38	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1156-2	3403.28
1157	2022-07-23	Hiring	11.87	99640.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1157	11827.36
1157	2025-06-18	Data Change	15.83	99640.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1157-2	15773.14
1158	2014-10-06	Hiring	9.58	40859.79	0.00	FR_EXEMPT	Salary	PAY-NVT-1158	3914.37
1158	2017-09-20	Promotion	11.12	56072.39	0.00	FR_EXEMPT	Salary	PAY-NVT-1158-2	7166.05
1158	2020-10-22	Promotion	12.01	75995.23	0.00	FR_EXEMPT	Salary	PAY-NVT-1158-3	9712.19
1158	2026-01-18	Data Change	12.78	92506.19	0.00	FR_EXEMPT	Salary	PAY-NVT-1158-4	11822.29
1159	2012-06-03	Hiring	10.27	65726.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1159	6750.11
1159	2018-07-03	Promotion	13.84	101286.66	0.00	FR_EXEMPT	Salary	PAY-NVT-1159-2	13876.27
1159	2025-05-12	Data Change	13.70	108765.84	0.00	FR_EXEMPT	Salary	PAY-NVT-1159-3	14900.92
1160	2017-08-26	Hiring	12.36	37831.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1160	4676.03
1160	2020-09-19	Promotion	14.34	54081.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1160-2	8912.64
1160	2025-06-02	Data Change	16.48	76124.95	0.00	FR_EXEMPT	Salary	PAY-NVT-1160-3	12545.39
1161	2024-07-03	Hiring	11.54	65405.87	0.00	FR_EXEMPT	Salary	PAY-NVT-1161	7547.84
1161	2025-07-21	Data Change	15.38	66766.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1161-2	10268.72
1162	2014-09-16	Hiring	9.23	50027.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1162	4617.52
1162	2017-08-27	Promotion	10.71	74049.77	0.00	FR_EXEMPT	Salary	PAY-NVT-1162-2	9115.53
1162	2020-09-27	Promotion	11.57	90272.98	0.00	FR_EXEMPT	Salary	PAY-NVT-1162-3	11112.60
1162	2023-09-03	Promotion	12.43	114424.06	0.00	FR_EXEMPT	Salary	PAY-NVT-1162-4	14085.60
1162	2025-08-10	Data Change	12.31	114424.06	0.00	FR_EXEMPT	Salary	PAY-NVT-1162-5	14085.60
1163	2012-08-28	Hiring	9.98	36107.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1163	3603.49
1163	2015-08-31	Promotion	11.58	50673.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1163-2	6744.59
1163	2025-10-10	Data Change	13.31	87575.79	4800.00	FR_EXEMPT	Salary	PAY-NVT-1163-3	11656.34
1164	2015-05-25	Hiring	10.00	42298.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1164	4229.86
1164	2018-06-01	Promotion	12.53	60637.20	0.00	FR_EXEMPT	Salary	PAY-NVT-1164-2	8082.94
1164	2025-05-27	Data Change	13.33	72800.89	0.00	FR_EXEMPT	Salary	PAY-NVT-1164-3	9704.36
1165	2017-03-11	Hiring	10.27	70125.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1165	7201.88
1165	2020-04-09	Promotion	13.84	89113.31	0.00	FR_EXEMPT	Salary	PAY-NVT-1165-2	12208.52
1165	2026-01-07	Data Change	13.70	96605.13	0.00	FR_EXEMPT	Salary	PAY-NVT-1165-3	13234.90
1166	2012-05-27	Hiring	12.59	48719.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1166	6133.74
1166	2015-05-18	Promotion	14.60	67874.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1166-2	11389.37
1166	2025-07-24	Data Change	16.78	117361.96	4800.00	FR_EXEMPT	Salary	PAY-NVT-1166-3	19693.34
1167	2018-10-11	Hiring	10.85	42700.07	0.00	FR_EXEMPT	Salary	PAY-NVT-1167	4632.96
1167	2021-10-25	Promotion	13.60	57689.70	0.00	FR_EXEMPT	Salary	PAY-NVT-1167-2	8347.70
1167	2024-10-11	Promotion	14.61	70491.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1167-3	10200.10
1167	2026-01-23	Data Change	14.47	70491.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1167-4	10200.10
1168	2013-03-07	Hiring	11.68	38088.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1168	4448.77
1168	2016-03-06	Promotion	13.55	52896.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1168-2	8235.99
1168	2022-02-21	Promotion	15.73	84919.72	0.00	FR_EXEMPT	Salary	PAY-NVT-1168-3	13222.00
1168	2025-10-15	Data Change	15.57	84919.72	0.00	FR_EXEMPT	Salary	PAY-NVT-1168-4	13222.00
1169	2022-11-30	Hiring	6.36	43077.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1169	2739.71
1169	2025-11-22	Data Change	8.48	59543.71	0.00	FR_EXEMPT	Salary	PAY-NVT-1169-2	5049.31
1170	2023-07-24	Hiring	4.91	66785.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1170	3279.17
1170	2025-08-17	Data Change	6.55	66785.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1170-2	4374.45
1171	2012-06-20	Hiring	10.92	93831.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1171	10246.43
1171	2025-07-21	Data Change	14.56	93831.75	5400.00	FR_EXEMPT	Salary	PAY-NVT-1171-2	13661.90
1172	2015-01-14	Hiring	8.34	86178.81	0.00	FR_EXEMPT	Salary	PAY-NVT-1172	7187.31
1172	2025-03-08	Data Change	11.12	90867.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1172-2	10104.49
1173	2012-08-25	Hiring	7.79	81159.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1173	6322.30
1173	2025-11-29	Data Change	10.39	92159.81	4800.00	FR_EXEMPT	Salary	PAY-NVT-1173-2	9575.40
1174	2019-05-24	Hiring	13.10	68903.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1174	9026.35
1174	2025-06-23	Promotion	17.64	110738.64	0.00	FR_EXEMPT	Salary	PAY-NVT-1174-2	19346.04
1174	2025-07-27	Data Change	17.47	110738.64	0.00	FR_EXEMPT	Salary	PAY-NVT-1174-3	19346.04
1175	2025-05-18	Hiring	3.84	51328.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1175	1971.02
1175	2025-07-30	Data Change	5.12	51328.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1175-2	2628.02
1176	2022-04-24	Hiring	10.66	70617.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1176	7527.78
1176	2025-04-10	Promotion	14.35	87477.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1176-2	12430.60
1176	2025-06-22	Data Change	14.21	87477.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1176-3	12430.60
1177	2018-07-21	Hiring	7.98	34515.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1177	2754.35
1177	2021-06-30	Promotion	9.26	45879.76	0.00	FR_EXEMPT	Salary	PAY-NVT-1177-2	4881.61
1177	2024-06-26	Promotion	10.00	62492.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1177-3	6649.23
1177	2025-11-21	Data Change	10.64	63033.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1177-4	6706.81
1178	2016-05-01	Hiring	11.37	37740.46	0.00	FR_EXEMPT	Salary	PAY-NVT-1178	4291.09
1178	2022-04-03	Promotion	14.25	73584.57	4200.00	FR_EXEMPT	Salary	PAY-NVT-1178-2	11155.42
1178	2025-04-21	Promotion	15.31	89449.73	4200.00	FR_EXEMPT	Salary	PAY-NVT-1178-3	13560.58
1178	2025-06-11	Data Change	15.16	89449.73	4200.00	FR_EXEMPT	Salary	PAY-NVT-1178-4	13560.58
1179	2019-06-02	Hiring	12.89	74170.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1179	9560.61
1179	2025-06-20	Promotion	16.16	114729.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1179-2	19722.06
1179	2025-12-02	Data Change	17.19	114729.86	0.00	FR_EXEMPT	Salary	PAY-NVT-1179-3	19722.06
1180	2025-09-20	Hiring	0.61	51742.42	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1180	315.63
1181	2019-05-03	Hiring	10.51	47443.61	0.00	FR_EXEMPT	Salary	PAY-NVT-1181	4986.32
1181	2025-05-07	Promotion	13.17	88990.19	0.00	FR_EXEMPT	Salary	PAY-NVT-1181-2	12467.53
1181	2025-11-29	Data Change	14.01	99146.31	0.00	FR_EXEMPT	Salary	PAY-NVT-1181-3	13890.40
1182	2017-08-13	Hiring	11.30	79372.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1182	8969.10
1182	2025-04-16	Data Change	15.07	108696.19	0.00	FR_EXEMPT	Salary	PAY-NVT-1182-2	16380.52
1183	2023-04-15	Hiring	7.00	88547.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1183	6198.34
1183	2025-05-06	Data Change	9.33	96114.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1183-2	8967.48
1184	2017-02-09	Hiring	8.05	39219.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1184	3157.20
1184	2020-02-22	Promotion	9.34	57032.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1184-2	6119.60
1184	2023-01-30	Promotion	10.09	70724.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1184-3	7588.71
1184	2025-11-29	Data Change	10.73	90578.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1184-4	9719.05
1185	2023-05-06	Hiring	9.95	82703.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1185	8228.99
1185	2025-09-02	Data Change	13.26	82703.41	5400.00	FR_EXEMPT	Salary	PAY-NVT-1185-2	10966.47
1186	2018-11-05	Hiring	13.46	82028.06	0.00	FR_EXEMPT	Salary	PAY-NVT-1186	11040.98
1186	2021-10-17	Promotion	18.12	104692.24	4800.00	FR_EXEMPT	Salary	PAY-NVT-1186-2	18781.79
1186	2025-05-15	Data Change	17.94	105210.77	4800.00	FR_EXEMPT	Salary	PAY-NVT-1186-3	18874.81
1187	2014-03-01	Hiring	12.20	40822.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1187	4980.35
1187	2017-03-25	Promotion	14.15	61537.12	0.00	FR_EXEMPT	Salary	PAY-NVT-1187-2	10005.94
1187	2020-03-07	Promotion	15.28	76345.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1187-3	12413.71
1187	2023-02-13	Promotion	16.42	92988.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1187-4	15120.00
1187	2025-01-09	Data Change	16.26	92988.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1187-5	15120.00
1188	2023-04-24	Hiring	8.73	54241.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1188	4735.29
1188	2025-11-25	Data Change	11.64	54241.63	0.00	FR_EXEMPT	Salary	PAY-NVT-1188-2	6313.73
1189	2024-09-22	Hiring	9.30	75332.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1189	7005.93
1189	2025-03-09	Data Change	12.40	75922.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1189-2	9414.35
1190	2021-09-06	Hiring	5.72	31810.00	0.00	FR_EXEMPT	Salary	PAY-NVT-1190	1819.53
1190	2025-04-24	Data Change	7.63	48206.72	0.00	FR_EXEMPT	Salary	PAY-NVT-1190-2	3678.17
1191	2021-04-27	Hiring	8.70	34049.73	0.00	FR_EXEMPT	Salary	PAY-NVT-1191	2962.33
1191	2024-04-05	Promotion	10.09	44540.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1191-2	5166.73
1191	2025-08-29	Data Change	11.60	44540.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1191-3	5166.73
1192	2016-11-17	Hiring	11.30	121988.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1192	13784.66
1192	2026-01-04	Data Change	15.07	148091.97	4800.00	FR_EXEMPT	Salary	PAY-NVT-1192-2	22317.46
1193	2025-05-14	Hiring	2.04	36966.21	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1193	754.11
1193	2025-07-17	Data Change	2.72	38118.78	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1193-2	1036.83
1194	2023-02-20	Hiring	11.18	86606.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1194	9682.57
1194	2026-03-06	Promotion	15.05	117651.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1194-2	17530.08
1195	2019-07-08	Hiring	10.57	121091.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1195	12799.42
1195	2025-08-29	Data Change	14.09	121091.97	4800.00	FR_EXEMPT	Salary	PAY-NVT-1195-2	17061.86
1196	2015-08-20	Hiring	13.27	100800.13	0.00	FR_EXEMPT	Salary	PAY-NVT-1196	13376.18
1196	2025-11-25	Data Change	17.69	122802.80	4800.00	FR_EXEMPT	Salary	PAY-NVT-1196-2	21723.82
1197	2025-07-03	Hiring	7.90	82745.44	0.00	FR_EXEMPT	Salary	PAY-NVT-1197	6536.89
1198	2013-06-10	Hiring	10.06	48816.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1198	4910.98
1198	2016-06-06	Promotion	11.67	76352.54	0.00	FR_EXEMPT	Salary	PAY-NVT-1198-2	10238.88
1198	2025-01-12	Data Change	13.41	130944.77	6000.00	FR_EXEMPT	Salary	PAY-NVT-1198-3	17559.69
1199	2023-04-18	Hiring	7.45	52864.27	0.00	FR_EXEMPT	Commission	PAY-NVT-1199	3938.39
1199	2025-08-28	Data Change	9.93	54393.18	0.00	FR_EXEMPT	Commission	PAY-NVT-1199-2	5401.24
1200	2025-12-03	Hiring	8.69	91056.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1200	7912.80
1201	2017-04-12	Hiring	8.54	64218.89	0.00	FR_EXEMPT	Salary	PAY-NVT-1201	5484.29
1201	2023-04-29	Promotion	11.49	105762.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1201-2	12035.72
1201	2025-07-11	Data Change	11.38	105762.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1201-3	12035.72
1202	2014-07-04	Hiring	9.74	67949.57	0.00	FR_EXEMPT	Salary	PAY-NVT-1202	6618.29
1202	2025-07-12	Data Change	12.99	86706.02	0.00	FR_EXEMPT	Salary	PAY-NVT-1202-2	11263.11
1203	2016-03-01	Hiring	11.37	55051.52	0.00	FR_EXEMPT	Salary	PAY-NVT-1203	6259.36
1203	2019-03-10	Promotion	14.25	69823.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1203-2	10585.21
1203	2025-01-22	Data Change	15.16	91707.32	0.00	FR_EXEMPT	Salary	PAY-NVT-1203-3	13902.83
1204	2025-01-27	Hiring	0.73	45900.88	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1204	335.08
1204	2025-03-18	Data Change	0.98	48909.86	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1204-2	479.32
1205	2019-01-19	Hiring	8.00	52317.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1205	4185.37
1205	2022-01-06	Promotion	10.02	73397.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1205-2	7824.16
1205	2025-09-20	Data Change	10.66	90092.30	0.00	FR_EXEMPT	Salary	PAY-NVT-1205-3	9603.84
1206	2023-11-05	Hiring	1.86	36330.88	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1206	675.75
1206	2025-11-22	Data Change	2.48	36330.88	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1206-2	901.01
1207	2018-10-19	Hiring	13.44	43279.05	0.00	FR_EXEMPT	Commission	PAY-NVT-1207	5816.70
1207	2021-11-12	Promotion	15.59	63071.86	0.00	FR_EXEMPT	Commission	PAY-NVT-1207-2	11302.48
1207	2025-12-15	Data Change	17.92	83843.97	4800.00	FR_EXEMPT	Commission	PAY-NVT-1207-3	15024.84
1208	2023-02-28	Hiring	4.85	48008.56	0.00	FR_EXEMPT	Salary	PAY-NVT-1208	2328.42
1208	2025-12-02	Data Change	6.47	63127.15	0.00	FR_EXEMPT	Salary	PAY-NVT-1208-2	4084.33
1209	2025-02-05	Hiring	9.61	69763.36	0.00	FR_EXEMPT	Commission	PAY-NVT-1209	6704.26
1209	2025-11-05	Data Change	12.81	71299.57	4800.00	FR_EXEMPT	Commission	PAY-NVT-1209-2	9133.47
1210	2019-03-26	Hiring	12.00	37959.30	0.00	FR_EXEMPT	Salary	PAY-NVT-1210	4555.12
1210	2022-03-21	Promotion	13.92	51911.93	0.00	FR_EXEMPT	Salary	PAY-NVT-1210-2	8305.91
1210	2025-03-31	Data Change	16.00	77056.45	0.00	FR_EXEMPT	Salary	PAY-NVT-1210-3	12329.03
1211	2025-09-05	Hiring	2.86	41183.81	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1211	1177.86
1212	2012-11-08	Hiring	9.92	49495.61	0.00	FR_EXEMPT	Commission	PAY-NVT-1212	4909.96
1212	2015-10-23	Promotion	12.43	65911.76	0.00	FR_EXEMPT	Commission	PAY-NVT-1212-2	8713.53
1212	2018-11-18	Promotion	13.35	83212.34	0.00	FR_EXEMPT	Commission	PAY-NVT-1212-3	11000.67
1212	2025-03-31	Data Change	13.22	85381.99	0.00	FR_EXEMPT	Commission	PAY-NVT-1212-4	11287.50
1213	2019-10-07	Hiring	11.89	63607.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1213	7562.87
1213	2022-09-29	Promotion	14.90	80161.89	5400.00	FR_EXEMPT	Salary	PAY-NVT-1213-2	12705.66
1213	2025-10-07	Promotion	16.01	101063.08	5400.00	FR_EXEMPT	Salary	PAY-NVT-1213-3	16018.50
1213	2025-11-07	Data Change	15.85	109029.79	5400.00	FR_EXEMPT	Salary	PAY-NVT-1213-4	17281.22
1214	2023-05-11	Hiring	0.49	34909.31	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1214	171.06
1214	2025-08-08	Data Change	0.65	34909.31	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1214-2	226.91
1215	2019-07-13	Hiring	13.08	95092.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1215	12438.10
1215	2025-12-29	Data Change	17.44	136127.98	6000.00	FR_EXEMPT	Salary	PAY-NVT-1215-2	23740.72
1216	2021-04-27	Hiring	4.24	44214.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1216	1874.69
1216	2024-05-14	Promotion	4.92	59732.98	0.00	FR_EXEMPT	Salary	PAY-NVT-1216-2	3374.91
1216	2025-06-08	Data Change	5.65	61250.80	0.00	FR_EXEMPT	Salary	PAY-NVT-1216-3	3460.67
1217	2024-08-25	Hiring	7.19	51701.29	0.00	FR_EXEMPT	Commission	PAY-NVT-1217	3717.32
1217	2025-12-01	Data Change	9.59	55199.40	0.00	FR_EXEMPT	Commission	PAY-NVT-1217-2	5293.62
1218	2016-05-29	Hiring	9.56	45811.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1218	4379.58
1218	2019-06-02	Promotion	11.99	64621.02	0.00	FR_EXEMPT	Salary	PAY-NVT-1218-2	8239.18
1218	2022-05-18	Promotion	12.88	79384.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1218-3	10121.56
1218	2025-02-08	Data Change	12.75	79384.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1218-4	10121.56
1219	2016-09-19	Hiring	9.38	47028.12	0.00	FR_EXEMPT	Salary	PAY-NVT-1219	4411.24
1219	2019-10-11	Promotion	11.76	67279.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1219-2	8416.72
1219	2022-09-07	Promotion	12.64	78372.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1219-3	9804.34
1219	2025-07-24	Data Change	12.51	84649.16	0.00	FR_EXEMPT	Salary	PAY-NVT-1219-4	10589.61
1220	2016-01-26	Hiring	11.16	74453.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1220	8309.06
1220	2025-06-01	Data Change	14.88	86441.14	0.00	FR_EXEMPT	Salary	PAY-NVT-1220-2	12862.44
1221	2013-04-26	Hiring	8.10	35801.18	0.00	FR_EXEMPT	Salary	PAY-NVT-1221	2899.90
1221	2016-04-08	Promotion	9.40	53403.75	0.00	FR_EXEMPT	Salary	PAY-NVT-1221-2	5767.60
1221	2019-04-21	Promotion	10.15	68420.38	0.00	FR_EXEMPT	Salary	PAY-NVT-1221-3	7389.40
1221	2025-10-15	Data Change	10.80	94535.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1221-4	10209.84
1222	2016-08-15	Hiring	11.11	125416.64	0.00	FR_EXEMPT	Salary	PAY-NVT-1222	13933.79
1222	2026-01-22	Data Change	14.81	132632.09	0.00	FR_EXEMPT	Salary	PAY-NVT-1222-2	19642.81
1223	2021-03-10	Hiring	7.14	37424.12	0.00	FR_EXEMPT	Salary	PAY-NVT-1223	2672.08
1223	2024-03-13	Promotion	8.28	51263.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1223-2	4880.29
1223	2026-01-31	Data Change	9.52	51263.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1223-3	4880.29
1224	2014-07-26	Hiring	13.42	42675.10	0.00	FR_EXEMPT	Salary	PAY-NVT-1224	5727.00
1224	2020-08-12	Promotion	16.83	78195.60	0.00	FR_EXEMPT	Salary	PAY-NVT-1224-2	13997.01
1224	2023-07-08	Promotion	18.08	92364.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1224-3	16533.22
1224	2025-10-17	Data Change	17.90	92364.33	0.00	FR_EXEMPT	Salary	PAY-NVT-1224-4	16533.22
1225	2023-10-22	Hiring	12.12	96213.34	0.00	FR_EXEMPT	Salary	PAY-NVT-1225	11661.06
1225	2025-01-23	Data Change	16.16	96213.34	4200.00	FR_EXEMPT	Salary	PAY-NVT-1225-2	15548.08
1226	2015-08-22	Hiring	8.00	67761.90	0.00	FR_EXEMPT	Salary	PAY-NVT-1226	5420.95
1226	2018-08-31	Promotion	10.77	81029.16	4800.00	FR_EXEMPT	Salary	PAY-NVT-1226-2	8637.71
1226	2025-10-27	Data Change	10.66	81029.16	4800.00	FR_EXEMPT	Salary	PAY-NVT-1226-3	8637.71
1227	2018-12-07	Hiring	12.08	58094.61	0.00	FR_EXEMPT	Salary	PAY-NVT-1227	7017.83
1227	2024-11-13	Promotion	16.27	95623.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1227-2	15404.87
1227	2026-01-05	Data Change	16.11	95623.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1227-3	15404.87
1228	2019-12-05	Hiring	9.35	34518.04	0.00	FR_EXEMPT	Salary	PAY-NVT-1228	3227.44
1228	2022-11-10	Promotion	10.85	45066.13	0.00	FR_EXEMPT	Salary	PAY-NVT-1228-2	5619.75
1228	2025-11-26	Promotion	11.72	62191.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1228-3	7755.26
1228	2026-02-19	Data Change	12.47	62191.35	0.00	FR_EXEMPT	Salary	PAY-NVT-1228-4	7755.26
1229	2015-07-09	Hiring	12.20	70225.45	0.00	FR_EXEMPT	Salary	PAY-NVT-1229	8567.50
1229	2018-07-23	Promotion	14.15	95540.50	0.00	FR_EXEMPT	Salary	PAY-NVT-1229-2	15534.89
1229	2021-08-01	Promotion	15.28	125208.69	0.00	FR_EXEMPT	Salary	PAY-NVT-1229-3	20358.93
1229	2024-06-26	Promotion	16.42	157702.27	0.00	FR_EXEMPT	Salary	PAY-NVT-1229-4	25642.39
1229	2025-10-04	Data Change	16.26	159513.34	0.00	FR_EXEMPT	Salary	PAY-NVT-1229-5	25936.87
1230	2025-02-04	Hiring	10.07	75319.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1230	7584.63
1230	2025-07-04	Data Change	13.43	81416.49	0.00	FR_EXEMPT	Salary	PAY-NVT-1230-2	10934.23
1231	2012-05-01	Hiring	10.90	127454.25	0.00	FR_EXEMPT	Salary	PAY-NVT-1231	13892.51
1231	2025-07-15	Data Change	14.54	127454.25	5400.00	FR_EXEMPT	Salary	PAY-NVT-1231-2	18531.85
1232	2012-02-06	Hiring	8.97	43503.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1232	3902.27
1232	2026-01-17	Data Change	11.96	63659.24	0.00	FR_EXEMPT	Salary	PAY-NVT-1232-2	7613.65
1233	2024-10-25	Hiring	1.56	48752.61	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1233	760.54
1233	2025-04-02	Data Change	2.08	49435.59	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1233-2	1028.26
1234	2021-02-26	Hiring	3.99	38083.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1234	1519.55
1234	2024-03-14	Promotion	4.63	51522.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1234-2	2741.01
1234	2025-07-28	Data Change	5.32	51522.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1234-3	2741.01
1235	2015-09-25	Hiring	10.88	97725.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1235	10632.54
1235	2018-10-08	Promotion	14.66	121045.04	4800.00	FR_EXEMPT	Salary	PAY-NVT-1235-2	17563.64
1235	2025-07-21	Data Change	14.51	121045.04	4800.00	FR_EXEMPT	Salary	PAY-NVT-1235-3	17563.64
1236	2020-04-05	Hiring	13.10	50977.85	0.00	FR_EXEMPT	Salary	PAY-NVT-1236	6678.10
1236	2025-03-31	Data Change	17.46	74775.13	5400.00	FR_EXEMPT	Salary	PAY-NVT-1236-2	13055.74
1237	2017-09-19	Hiring	10.68	35893.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1237	3833.37
1237	2020-09-19	Promotion	12.39	56895.30	0.00	FR_EXEMPT	Salary	PAY-NVT-1237-2	8101.89
1237	2023-10-15	Promotion	13.39	72523.09	6000.00	FR_EXEMPT	Salary	PAY-NVT-1237-3	10327.29
1237	2025-05-09	Data Change	14.24	74083.97	6000.00	FR_EXEMPT	Salary	PAY-NVT-1237-4	10549.56
1238	2014-10-22	Hiring	9.73	47293.45	0.00	FR_EXEMPT	Salary	PAY-NVT-1238	4601.65
1238	2017-10-19	Promotion	11.29	67838.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1238-2	8805.47
1238	2020-10-09	Promotion	12.20	97682.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1238-3	12679.15
1238	2023-10-07	Promotion	13.11	118326.42	0.00	FR_EXEMPT	Salary	PAY-NVT-1238-4	15358.77
1238	2025-05-17	Data Change	12.98	118326.42	0.00	FR_EXEMPT	Salary	PAY-NVT-1238-5	15358.77
1239	2022-08-02	Hiring	5.41	41561.17	0.00	FR_EXEMPT	Salary	PAY-NVT-1239	2248.46
1239	2025-08-15	Promotion	6.27	57379.97	0.00	FR_EXEMPT	Salary	PAY-NVT-1239-2	4137.10
1239	2025-11-05	Data Change	7.21	58463.09	0.00	FR_EXEMPT	Salary	PAY-NVT-1239-3	4215.19
1240	2022-01-25	Hiring	12.12	63302.01	0.00	FR_EXEMPT	Salary	PAY-NVT-1240	7672.20
1240	2024-12-29	Promotion	15.19	95654.82	4200.00	FR_EXEMPT	Salary	PAY-NVT-1240-2	15457.82
1240	2025-10-05	Data Change	16.16	96491.57	4200.00	FR_EXEMPT	Salary	PAY-NVT-1240-3	15593.04
1241	2012-06-17	Hiring	8.04	45121.94	0.00	FR_EXEMPT	Salary	PAY-NVT-1241	3627.80
1241	2015-06-18	Promotion	9.33	61761.29	0.00	FR_EXEMPT	Salary	PAY-NVT-1241-2	6620.81
1241	2025-07-20	Data Change	10.72	104461.19	0.00	FR_EXEMPT	Salary	PAY-NVT-1241-3	11198.24
1242	2019-04-17	Hiring	9.64	51131.78	0.00	FR_EXEMPT	Salary	PAY-NVT-1242	4929.10
1242	2022-03-30	Promotion	12.08	75275.41	0.00	FR_EXEMPT	Salary	PAY-NVT-1242-2	9672.89
1242	2025-05-03	Promotion	12.98	82323.58	0.00	FR_EXEMPT	Salary	PAY-NVT-1242-3	10578.58
1242	2025-07-24	Data Change	12.85	82963.74	0.00	FR_EXEMPT	Salary	PAY-NVT-1242-4	10660.84
1243	2015-02-03	Hiring	10.27	44389.05	0.00	FR_EXEMPT	Salary	PAY-NVT-1243	4558.76
1243	2018-01-22	Promotion	11.92	67752.62	0.00	FR_EXEMPT	Salary	PAY-NVT-1243-2	9282.11
1243	2021-02-09	Promotion	12.88	94497.39	0.00	FR_EXEMPT	Salary	PAY-NVT-1243-3	12946.14
1243	2024-02-19	Promotion	13.84	110554.36	0.00	FR_EXEMPT	Salary	PAY-NVT-1243-4	15145.95
1243	2025-09-11	Data Change	13.70	122098.26	0.00	FR_EXEMPT	Salary	PAY-NVT-1243-5	16727.46
1244	2018-06-13	Hiring	11.37	84819.53	0.00	FR_EXEMPT	Salary	PAY-NVT-1244	9643.98
1244	2025-06-27	Data Change	15.16	103121.92	0.00	FR_EXEMPT	Salary	PAY-NVT-1244-2	15633.28
1245	2019-09-26	Hiring	8.23	34427.06	0.00	FR_EXEMPT	Commission	PAY-NVT-1245	2833.35
1245	2022-10-18	Promotion	9.55	47019.11	0.00	FR_EXEMPT	Commission	PAY-NVT-1245-2	5162.70
1245	2025-08-27	Promotion	10.32	63075.55	0.00	FR_EXEMPT	Commission	PAY-NVT-1245-3	6925.70
1245	2025-09-14	Data Change	10.98	68002.91	0.00	FR_EXEMPT	Commission	PAY-NVT-1245-4	7466.72
1246	2024-12-13	Hiring	0.70	41030.30	0.00	FR_INTERN	Salary	PAY-NVT-1246	287.21
1246	2025-06-16	Data Change	0.94	41030.30	0.00	FR_INTERN	Salary	PAY-NVT-1246-2	385.68
1247	2024-10-16	Hiring	0.33	31906.06	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1247	105.29
1247	2025-11-14	Data Change	0.44	33714.85	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1247-2	148.35
1248	2013-05-23	Hiring	11.78	59701.47	0.00	FR_EXEMPT	Salary	PAY-NVT-1248	7032.83
1248	2016-04-27	Promotion	14.77	80466.92	6000.00	FR_EXEMPT	Salary	PAY-NVT-1248-2	12641.35
1248	2019-05-17	Promotion	15.87	95138.89	6000.00	FR_EXEMPT	Salary	PAY-NVT-1248-3	14946.32
1248	2026-01-11	Data Change	15.71	95138.89	6000.00	FR_EXEMPT	Salary	PAY-NVT-1248-4	14946.32
1249	2024-09-28	Hiring	0.22	41559.81	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1249	91.43
1249	2025-02-19	Data Change	0.29	42216.28	0.00	FR_NON_EXEMPT	Salary	PAY-NVT-1249-2	122.43
1250	2017-12-14	Hiring	12.40	66938.11	0.00	FR_EXEMPT	Salary	PAY-NVT-1250	8300.33
1250	2020-12-04	Promotion	16.70	86204.31	0.00	FR_EXEMPT	Salary	PAY-NVT-1250-2	14249.57
1250	2025-11-27	Data Change	16.53	87888.65	0.00	FR_EXEMPT	Salary	PAY-NVT-1250-3	14527.99
\.


--
-- TOC entry 5120 (class 0 OID 19709)
-- Dependencies: 220
-- Data for Name: job_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_info (user_id, start_date, seq_number, event_reason, businessunit, company, location, division, job_code, job_family, group_job, hiresource, contract_id, contract_name, degreeofproductivity) FROM stdin;
1001	2024-08-12	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CSM-SALES	Customer Success	Operations	Indeed	CTR-NVT-00001	Permanent	74.58
1001	2025-09-20	2	Data Change	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CSM-SALES	Customer Success	Operations	Other	\N	Permanent	95.75
1002	2015-10-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	BACK-ENG	Software Engineering	Technical	Referral	CTR-NVT-00002	Permanent	87.30
1002	2021-09-19	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	90.89
1002	2024-10-03	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	82.98
1003	2013-09-28	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Lyon	People & Culture	PAYROLL-OP	Payroll	Operations	Headhunter	CTR-NVT-00003	Permanent	72.80
1003	2016-09-30	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Lyon	People & Culture	CONF-PAYROLL-OP	Payroll	Operations	Other	\N	Permanent	86.95
1003	2019-10-20	3	Promotion	HR	Novaryn Tech	Novaryn Tech - Lyon	People & Culture	SR-PAYROLL-OP	Payroll	Operations	Other	\N	Permanent	77.01
1004	2021-04-11	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CSM-SALES	Customer Success	Operations	LinkedIn	CTR-NVT-00004	Permanent	78.01
1005	2019-03-06	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-CSM-SALES	Customer Success	Operations	Welcome to the Jungle	CTR-NVT-00005	Permanent	75.84
1005	2025-04-02	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	88.78
1006	2013-08-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	ML-ENG	AI & Machine Learning	Technical	Other	CTR-NVT-00006	Internship	69.12
1006	2022-07-20	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Other	\N	Internship	94.00
1007	2020-08-06	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-QA-ENG	Quality Assurance	Technical	Referral	CTR-NVT-00007	Permanent	83.35
1007	2023-07-17	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	78.71
1008	2015-05-20	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-BACK-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00008	Permanent	84.80
1008	2018-05-30	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	83.63
1009	2019-08-23	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	BACK-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00009	Permanent	66.21
1010	2025-10-08	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-FA-FIN	Finance	Operations	Company Website	CTR-NVT-00010	Permanent	65.49
1011	2025-09-16	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	LEAD-FA-FIN	Finance	Operations	LinkedIn	CTR-NVT-00011	Permanent	75.42
1012	2019-03-11	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CMO	Executive	Executive	Other	CTR-NVT-00012	Permanent	78.68
1013	2014-08-24	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	SR-FA-FIN	Finance	Operations	Indeed	CTR-NVT-00013	Permanent	68.83
1014	2017-09-22	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	BD-SALES	Sales Development	Operations	LinkedIn	CTR-NVT-00014	Permanent	72.53
1015	2018-06-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-DATA-ENG	Data & Analytics	Technical	Referral	CTR-NVT-00015	Fixed-term	80.14
1016	2017-11-07	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-ENG	Data & Analytics	Technical	LinkedIn	CTR-NVT-00016	Permanent	85.77
1016	2020-11-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	89.59
1016	2023-11-27	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	80.34
1017	2025-09-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SECU-ENG	Cybersecurity	Technical	LinkedIn	CTR-NVT-00017	Fixed-term	69.99
1018	2019-10-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	DEVOPS-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00018	Fixed-term	78.08
1018	2022-11-09	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Fixed-term	83.01
1018	2025-10-30	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Fixed-term	86.92
1019	2018-06-10	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-DATA-SCI	AI & Machine Learning	Technical	Other	CTR-NVT-00019	Permanent	88.33
1019	2021-05-11	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Permanent	76.28
1019	2024-05-18	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Permanent	96.38
1020	2016-12-26	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-PO-PROD	Product Management	Technical	Welcome to the Jungle	CTR-NVT-00020	Permanent	68.73
1020	2019-12-28	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-PO-PROD	Product Management	Technical	Other	\N	Permanent	79.65
1021	2018-02-25	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	CONF-FA-FIN	Finance	Operations	Referral	CTR-NVT-00021	Permanent	87.62
1021	2021-02-24	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	SR-FA-FIN	Finance	Operations	Other	\N	Permanent	97.75
1021	2024-02-24	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	LEAD-FA-FIN	Finance	Operations	Other	\N	Permanent	79.10
1022	2023-12-27	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	AM-SALES	Enterprise Sales	Operations	Headhunter	CTR-NVT-00022	Permanent	86.85
1023	2023-04-01	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-SMGR-SALES	Sales Management	Operations	Referral	CTR-NVT-00023	Permanent	74.01
1024	2016-12-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	FULL-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00024	Permanent	75.65
1024	2019-12-27	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	90.68
1024	2022-12-27	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	79.04
1024	2025-11-24	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	85.87
1025	2013-09-19	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	DATA-ENG	Data & Analytics	Technical	Headhunter	CTR-NVT-00025	Permanent	80.55
1025	2019-10-11	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	83.54
1025	2022-09-14	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	99.17
1026	2019-09-18	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lille	Finance & Administration	CTRL-FIN	Finance	Operations	Referral	CTR-NVT-00026	Permanent	74.64
1027	2014-10-07	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONT-MKT	Content & Comms	Marketing	Referral	CTR-NVT-00027	Fixed-term	84.92
1027	2017-10-21	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-CONT-MKT	Content & Comms	Marketing	Other	\N	Fixed-term	89.98
1028	2015-07-25	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SMGR-SALES	Sales Management	Operations	Indeed	CTR-NVT-00028	Permanent	87.78
1028	2018-07-31	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-SMGR-SALES	Sales Management	Operations	Other	\N	Permanent	88.92
1028	2021-07-19	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SR-SMGR-SALES	Sales Management	Operations	Other	\N	Permanent	93.14
1028	2024-08-19	4	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-SMGR-SALES	Sales Management	Operations	Other	\N	Permanent	93.06
1029	2023-08-18	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Marseille	Technology	UX-PROD	Design	Technical	LinkedIn	CTR-NVT-00029	Permanent	89.34
1030	2022-05-13	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BRAND-MKT	Brand Management	Marketing	Referral	CTR-NVT-00030	Permanent	88.01
1030	2025-05-09	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BRAND-MKT	Brand Management	Marketing	Other	\N	Permanent	85.70
1031	2021-02-01	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	GROWTH-MKT	Growth Marketing	Marketing	Headhunter	CTR-NVT-00031	Permanent	72.86
1032	2019-11-12	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	BRAND-MKT	Brand Management	Marketing	Headhunter	CTR-NVT-00032	Permanent	84.19
1032	2022-11-18	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-BRAND-MKT	Brand Management	Marketing	Other	\N	Permanent	78.93
1033	2022-11-20	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	SR-FA-FIN	Finance	Operations	Referral	CTR-NVT-00033	Permanent	77.98
1034	2023-08-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	INFRA-ENG	Infrastructure	Technical	Headhunter	CTR-NVT-00034	Permanent	75.82
1035	2025-03-14	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00035	Permanent	77.05
1036	2025-12-24	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Marseille	Technology	PM-PROD	Product Management	Technical	Headhunter	CTR-NVT-00036	Permanent	81.04
1037	2018-10-28	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-GROWTH-MKT	Growth Marketing	Marketing	Referral	CTR-NVT-00037	Permanent	85.66
1038	2015-08-04	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-SECU-ENG	Cybersecurity	Technical	LinkedIn	CTR-NVT-00038	Permanent	65.29
1038	2021-08-04	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	96.74
1039	2017-05-09	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00039	Permanent	66.87
1039	2020-04-24	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	85.28
1040	2020-06-29	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	DATA-ENG	Data & Analytics	Technical	Headhunter	CTR-NVT-00040	Permanent	77.67
1040	2023-06-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	CONF-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	82.87
1041	2019-10-22	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	PMM-MKT	Product Marketing	Marketing	Welcome to the Jungle	CTR-NVT-00041	Permanent	76.48
1041	2025-11-15	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	SR-PMM-MKT	Product Marketing	Marketing	Other	\N	Permanent	86.97
1042	2014-05-17	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONT-MKT	Content & Comms	Marketing	Referral	CTR-NVT-00042	Permanent	89.52
1042	2020-05-12	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-CONT-MKT	Content & Comms	Marketing	Other	\N	Permanent	85.07
1042	2023-04-17	3	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CONT-MKT	Content & Comms	Marketing	Other	\N	Permanent	96.17
1043	2021-07-20	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	SR-HRBP-HR	Human Resources	Support	Indeed	CTR-NVT-00043	Permanent	89.08
1043	2024-08-15	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	LEAD-HRBP-HR	Human Resources	Support	Other	\N	Permanent	89.18
1044	2024-09-15	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Welcome to the Jungle	CTR-NVT-00044	Fixed-term	81.79
1045	2021-12-04	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CONT-MKT	Content & Comms	Marketing	Welcome to the Jungle	CTR-NVT-00045	Permanent	74.08
1045	2023-02-05	2	Data Change	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CONT-MKT	Content & Comms	Marketing	Other	\N	Permanent	80.30
1046	2015-09-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	QA-ENG	Quality Assurance	Technical	Indeed	CTR-NVT-00046	Internship	84.19
1046	2018-10-09	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-QA-ENG	Quality Assurance	Technical	Other	\N	Internship	88.46
1046	2024-10-12	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Other	\N	Internship	92.50
1047	2020-05-24	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-PMM-MKT	Product Marketing	Marketing	Company Website	CTR-NVT-00047	Fixed-term	85.75
1048	2012-10-19	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	PAYROLL-OP	Payroll	Operations	Company Website	CTR-NVT-00048	Permanent	78.05
1048	2018-09-29	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	SR-PAYROLL-OP	Payroll	Operations	Other	\N	Permanent	86.83
1049	2022-09-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	QA-ENG	Quality Assurance	Technical	LinkedIn	CTR-NVT-00049	Permanent	75.23
1049	2025-08-16	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	78.13
1050	2019-03-08	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-BACK-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00050	Permanent	74.82
1050	2022-03-28	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	80.19
1050	2025-03-26	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	87.12
1051	2018-07-18	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	PO-PROD	Product Management	Technical	Welcome to the Jungle	CTR-NVT-00051	Permanent	85.94
1051	2021-08-06	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-PO-PROD	Product Management	Technical	Other	\N	Permanent	93.62
1051	2024-07-25	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-PO-PROD	Product Management	Technical	Other	\N	Permanent	97.04
1052	2019-12-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FULL-ENG	Software Engineering	Technical	Referral	CTR-NVT-00052	Permanent	77.47
1052	2022-11-21	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	86.17
1052	2025-12-25	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	86.62
1053	2012-03-12	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DEVOPS-ENG	Infrastructure	Technical	Company Website	CTR-NVT-00053	Internship	88.03
1053	2015-03-19	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Internship	77.82
1053	2021-03-24	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Internship	91.21
1054	2013-12-12	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-UX-PROD	Design	Technical	Company Website	CTR-NVT-00054	Permanent	77.60
1054	2016-12-20	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-UX-PROD	Design	Technical	Other	\N	Permanent	98.15
1055	2022-11-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-INFRA-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00055	Permanent	71.84
1056	2016-12-28	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-DATA-SCI	AI & Machine Learning	Technical	Company Website	CTR-NVT-00056	Fixed-term	76.32
1056	2019-12-24	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Fixed-term	89.26
1057	2019-09-20	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	AM-SALES	Enterprise Sales	Operations	LinkedIn	CTR-NVT-00057	Fixed-term	86.08
1057	2022-09-10	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Other	\N	Fixed-term	89.66
1058	2024-03-29	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Referral	CTR-NVT-00058	Permanent	70.02
1059	2024-12-17	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Bordeaux	Finance & Administration	LEAD-FA-FIN	Finance	Operations	Indeed	CTR-NVT-00059	Permanent	72.26
1060	2013-10-23	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	HRBP-HR	Human Resources	Support	Headhunter	CTR-NVT-00060	Permanent	81.81
1061	2020-08-20	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	LEAD-BRAND-MKT	Brand Management	Marketing	Headhunter	CTR-NVT-00061	Permanent	82.36
1062	2018-05-12	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	BACK-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00062	Fixed-term	67.89
1062	2021-05-12	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-BACK-ENG	Software Engineering	Technical	Other	\N	Fixed-term	86.82
1063	2025-03-31	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-PM-PROD	Product Management	Technical	Indeed	CTR-NVT-00063	Permanent	81.86
1064	2017-07-07	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	SR-HRBP-HR	Human Resources	Support	Indeed	CTR-NVT-00064	Permanent	78.35
1065	2013-11-26	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Toulouse	People & Culture	SR-TA-HR	Talent Acquisition	Support	LinkedIn	CTR-NVT-00065	Fixed-term	65.32
1065	2016-11-20	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Toulouse	People & Culture	LEAD-TA-HR	Talent Acquisition	Support	Other	\N	Fixed-term	81.20
1066	2016-01-27	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CSO	Executive	Executive	Referral	CTR-NVT-00066	Permanent	70.00
1067	2021-08-26	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-UX-PROD	Design	Technical	Company Website	CTR-NVT-00067	Permanent	69.02
1067	2024-08-12	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-UX-PROD	Design	Technical	Other	\N	Permanent	79.22
1067	2025-12-27	3	Transfer	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-UX-PROD	Design	Technical	Other	\N	Permanent	80.97
1068	2024-06-13	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-ENG	Data & Analytics	Technical	LinkedIn	CTR-NVT-00068	Permanent	76.31
1069	2024-12-09	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	DEVOPS-ENG	Infrastructure	Technical	Indeed	CTR-NVT-00069	Permanent	81.89
1070	2014-02-20	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	ADMIN-OP	Operations	Operations	Headhunter	CTR-NVT-00070	Permanent	70.61
1070	2017-02-14	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	CONF-ADMIN-OP	Operations	Operations	Other	\N	Permanent	79.23
1071	2020-02-01	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	CONF-DATA-ENG	Data & Analytics	Technical	Indeed	CTR-NVT-00071	Permanent	81.61
1071	2026-02-21	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	99.47
1072	2016-07-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	SR-ML-ENG	AI & Machine Learning	Technical	Headhunter	CTR-NVT-00072	Permanent	78.80
1072	2019-06-21	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	82.47
1073	2019-03-14	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	FRONT-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00073	Fixed-term	86.51
1073	2022-02-26	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Other	\N	Fixed-term	94.05
1074	2024-11-06	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CSM-SALES	Customer Success	Operations	LinkedIn	CTR-NVT-00074	Permanent	83.88
1075	2017-04-20	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-PM-PROD	Product Management	Technical	LinkedIn	CTR-NVT-00075	Permanent	80.08
1076	2023-01-21	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-CONT-MKT	Content & Comms	Marketing	LinkedIn	CTR-NVT-00076	Permanent	69.44
1077	2020-10-21	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FRONT-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00077	Permanent	69.34
1078	2016-03-20	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	QA-ENG	Quality Assurance	Technical	Referral	CTR-NVT-00078	Permanent	74.43
1078	2019-03-25	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	79.81
1078	2022-04-13	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	81.61
1078	2025-04-04	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	98.62
1079	2017-10-01	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	CONF-DEVOPS-ENG	Infrastructure	Technical	Other	CTR-NVT-00079	Permanent	79.92
1079	2023-10-24	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	LEAD-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Permanent	92.56
1080	2021-06-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DATA-SCI	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00080	Permanent	79.32
1080	2024-06-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Permanent	89.57
1081	2015-09-30	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	BD-SALES	Sales Development	Operations	Referral	CTR-NVT-00081	Permanent	88.92
1081	2018-10-20	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BD-SALES	Sales Development	Operations	Other	\N	Permanent	85.11
1081	2021-10-04	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	84.88
1081	2024-10-26	4	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-BD-SALES	Sales Development	Operations	Other	\N	Permanent	82.69
1082	2024-01-16	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-PM-PROD	Product Management	Technical	Referral	CTR-NVT-00082	Permanent	74.02
1083	2013-02-22	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	AM-SALES	Enterprise Sales	Operations	LinkedIn	CTR-NVT-00083	Permanent	83.82
1083	2016-02-27	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	92.12
1083	2022-03-06	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	LEAD-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	85.61
1084	2013-03-16	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	CONF-CTRL-FIN	Finance	Operations	LinkedIn	CTR-NVT-00084	Permanent	81.06
1084	2019-02-16	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	LEAD-CTRL-FIN	Finance	Operations	Other	\N	Permanent	93.02
1085	2016-09-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SECU-ENG	Cybersecurity	Technical	Referral	CTR-NVT-00085	Permanent	87.90
1085	2022-09-30	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	91.93
1085	2025-09-29	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	96.09
1086	2021-03-04	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-BACK-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00086	Permanent	85.07
1086	2024-02-05	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	84.52
1087	2021-09-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	QA-ENG	Quality Assurance	Technical	Headhunter	CTR-NVT-00087	Apprenticeship	73.01
1087	2024-08-25	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-QA-ENG	Quality Assurance	Technical	Other	\N	Apprenticeship	77.68
1088	2016-02-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-ML-ENG	AI & Machine Learning	Technical	Referral	CTR-NVT-00088	Permanent	78.45
1088	2019-01-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	80.64
1088	2022-02-01	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	97.03
1089	2015-03-29	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-BACK-ENG	Software Engineering	Technical	Referral	CTR-NVT-00089	Permanent	67.60
1089	2018-04-12	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	95.33
1090	2023-03-18	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	FRONT-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00090	Permanent	85.42
1090	2024-03-09	2	Transfer	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	89.92
1091	2019-03-17	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	PO-PROD	Product Management	Technical	LinkedIn	CTR-NVT-00091	Fixed-term	65.95
1091	2022-02-26	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-PO-PROD	Product Management	Technical	Other	\N	Fixed-term	91.47
1091	2025-03-23	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-PO-PROD	Product Management	Technical	Other	\N	Fixed-term	94.08
1092	2024-05-27	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00092	Permanent	75.19
1093	2023-02-12	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-AM-SALES	Enterprise Sales	Operations	Referral	CTR-NVT-00093	Permanent	75.11
1093	2026-02-06	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	92.81
1094	2013-01-11	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lille	Technology	PM-PROD	Product Management	Technical	Headhunter	CTR-NVT-00094	Permanent	81.04
1094	2016-01-29	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Lille	Technology	CONF-PM-PROD	Product Management	Technical	Other	\N	Permanent	90.41
1094	2019-02-04	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Lille	Technology	SR-PM-PROD	Product Management	Technical	Other	\N	Permanent	77.60
1095	2017-10-09	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BD-SALES	Sales Development	Operations	Indeed	CTR-NVT-00095	Permanent	84.67
1095	2020-09-14	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	82.19
1096	2015-04-05	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-BD-SALES	Sales Development	Operations	Indeed	CTR-NVT-00096	Permanent	85.55
1096	2016-03-30	2	Transfer	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-BD-SALES	Sales Development	Operations	Other	\N	Permanent	90.67
1097	2019-08-19	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Welcome to the Jungle	CTR-NVT-00097	Permanent	84.92
1098	2015-02-14	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-SCI	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00098	Permanent	72.37
1098	2018-02-03	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Permanent	90.90
1099	2016-04-01	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	UX-PROD	Design	Technical	Indeed	CTR-NVT-00099	Permanent	83.23
1099	2019-05-01	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-UX-PROD	Design	Technical	Other	\N	Permanent	74.25
1099	2025-03-04	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-UX-PROD	Design	Technical	Other	\N	Permanent	78.11
1100	2025-09-29	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	ML-ENG	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00100	Internship	78.43
1101	2012-11-10	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-ADMIN-OP	Operations	Operations	LinkedIn	CTR-NVT-00101	Permanent	72.62
1102	2012-04-01	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-PM-PROD	Product Management	Technical	Referral	CTR-NVT-00102	Permanent	73.60
1103	2016-01-08	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-PRE-SALES	Sales Engineering	Technical	Headhunter	CTR-NVT-00103	Permanent	81.15
1103	2018-12-19	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	SR-PRE-SALES	Sales Engineering	Technical	Other	\N	Permanent	80.05
1103	2021-12-25	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	LEAD-PRE-SALES	Sales Engineering	Technical	Other	\N	Permanent	82.28
1104	2020-04-05	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	TA-HR	Talent Acquisition	Support	Referral	CTR-NVT-00104	Permanent	84.99
1105	2018-10-27	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-BACK-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00105	Fixed-term	88.31
1106	2018-06-12	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SMGR-SALES	Sales Management	Operations	LinkedIn	CTR-NVT-00106	Permanent	78.74
1106	2021-05-17	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-SMGR-SALES	Sales Management	Operations	Other	\N	Permanent	79.52
1106	2024-06-19	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-SMGR-SALES	Sales Management	Operations	Other	\N	Permanent	86.72
1107	2016-07-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-QA-ENG	Quality Assurance	Technical	LinkedIn	CTR-NVT-00107	Permanent	68.21
1107	2022-07-14	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	79.54
1108	2019-03-13	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	HRBP-HR	Human Resources	Support	Referral	CTR-NVT-00108	Apprenticeship	77.15
1108	2022-03-25	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	CONF-HRBP-HR	Human Resources	Support	Other	\N	Apprenticeship	80.72
1108	2025-03-19	3	Promotion	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	SR-HRBP-HR	Human Resources	Support	Other	\N	Apprenticeship	88.47
1109	2024-03-22	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Headhunter	CTR-NVT-00109	Permanent	88.97
1110	2015-03-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-DATA-ENG	Data & Analytics	Technical	Referral	CTR-NVT-00110	Permanent	72.83
1111	2012-12-29	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FULL-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00111	Permanent	71.92
1111	2016-01-11	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	90.13
1111	2021-12-21	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	95.04
1112	2017-05-02	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BD-SALES	Sales Development	Operations	Welcome to the Jungle	CTR-NVT-00112	Permanent	67.72
1112	2020-04-07	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	94.52
1113	2021-12-08	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	TA-HR	Talent Acquisition	Support	Headhunter	CTR-NVT-00113	Permanent	78.47
1113	2025-01-03	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	CONF-TA-HR	Talent Acquisition	Support	Other	\N	Permanent	87.79
1114	2021-01-13	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Bordeaux	People & Culture	TA-HR	Talent Acquisition	Support	LinkedIn	CTR-NVT-00114	Fixed-term	87.30
1115	2020-08-21	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-SCRM-PROD	Agile Methodology	Operations	Other	CTR-NVT-00115	Permanent	85.32
1115	2023-09-09	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-SCRM-PROD	Agile Methodology	Operations	Other	\N	Permanent	88.98
1116	2013-03-01	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FRONT-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00116	Permanent	78.79
1117	2023-06-27	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	PM-PROD	Product Management	Technical	Other	CTR-NVT-00117	Permanent	89.97
1118	2014-01-14	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-PM-PROD	Product Management	Technical	Company Website	CTR-NVT-00118	Fixed-term	84.38
1118	2016-12-29	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	97.61
1119	2021-11-06	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FRONT-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00119	Permanent	86.43
1120	2013-05-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DATA-SCI	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00120	Internship	77.53
1120	2016-05-17	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Internship	85.05
1121	2021-12-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-ENG	Data & Analytics	Technical	Referral	CTR-NVT-00121	Permanent	80.35
1121	2024-12-07	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	79.09
1122	2017-05-19	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	LEAD-GROWTH-MKT	Growth Marketing	Marketing	LinkedIn	CTR-NVT-00122	Permanent	79.16
1123	2023-05-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	BACK-ENG	Software Engineering	Technical	Welcome to the Jungle	CTR-NVT-00123	Permanent	86.80
1124	2016-07-08	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-CSM-SALES	Customer Success	Operations	Referral	CTR-NVT-00124	Permanent	83.30
1124	2022-07-26	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	88.73
1124	2024-02-24	3	Transfer	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	88.71
1125	2023-06-05	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONT-MKT	Content & Comms	Marketing	LinkedIn	CTR-NVT-00125	Permanent	77.95
1126	2019-10-12	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	CTRL-FIN	Finance	Operations	Welcome to the Jungle	CTR-NVT-00126	Permanent	74.70
1126	2022-02-22	2	Data Change	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	CTRL-FIN	Finance	Operations	Other	\N	Permanent	74.58
1127	2013-03-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FULL-ENG	Software Engineering	Technical	Welcome to the Jungle	CTR-NVT-00127	Permanent	89.21
1127	2016-03-13	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	92.37
1127	2019-03-30	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	88.54
1127	2022-03-20	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	86.04
1128	2022-07-26	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	CFO	Executive	Executive	Indeed	CTR-NVT-00128	Permanent	85.89
1129	2013-03-31	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	ADMIN-OP	Operations	Operations	LinkedIn	CTR-NVT-00129	Permanent	74.41
1129	2019-03-23	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	SR-ADMIN-OP	Operations	Operations	Other	\N	Permanent	93.98
1129	2022-04-20	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	LEAD-ADMIN-OP	Operations	Operations	Other	\N	Permanent	88.61
1130	2020-08-09	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	AM-SALES	Enterprise Sales	Operations	Indeed	CTR-NVT-00130	Permanent	77.55
1130	2023-07-20	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	79.06
1131	2017-12-08	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00131	Permanent	72.02
1131	2020-11-18	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	83.97
1132	2018-04-15	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	BACK-ENG	Software Engineering	Technical	Referral	CTR-NVT-00132	Permanent	70.76
1133	2019-06-15	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-INFRA-ENG	Infrastructure	Technical	Company Website	CTR-NVT-00133	Permanent	76.97
1133	2022-05-26	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-INFRA-ENG	Infrastructure	Technical	Other	\N	Permanent	90.24
1133	2025-05-31	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-INFRA-ENG	Infrastructure	Technical	Other	\N	Permanent	78.95
1134	2025-09-24	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	CONF-TA-HR	Talent Acquisition	Support	LinkedIn	CTR-NVT-00134	Permanent	69.03
1135	2012-02-18	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-CSM-SALES	Customer Success	Operations	LinkedIn	CTR-NVT-00135	Permanent	65.98
1135	2015-01-22	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	79.66
1136	2017-02-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	ML-ENG	AI & Machine Learning	Technical	Headhunter	CTR-NVT-00136	Permanent	75.14
1136	2023-03-01	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	91.83
1137	2014-04-14	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Welcome to the Jungle	CTR-NVT-00137	Permanent	67.14
1137	2017-04-14	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	SR-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	95.08
1137	2020-05-07	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	LEAD-AM-SALES	Enterprise Sales	Operations	Other	\N	Permanent	87.04
1138	2013-10-27	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-ADMIN-OP	Operations	Operations	Other	CTR-NVT-00138	Permanent	79.57
1139	2016-08-19	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	ADMIN-OP	Operations	Operations	Indeed	CTR-NVT-00139	Permanent	77.77
1139	2019-09-01	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	CONF-ADMIN-OP	Operations	Operations	Other	\N	Permanent	81.54
1139	2022-08-26	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-ADMIN-OP	Operations	Operations	Other	\N	Permanent	77.51
1139	2025-07-28	4	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	LEAD-ADMIN-OP	Operations	Operations	Other	\N	Permanent	80.39
1140	2015-08-01	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	CONF-CTRL-FIN	Finance	Operations	Headhunter	CTR-NVT-00140	Fixed-term	86.49
1140	2018-07-28	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	SR-CTRL-FIN	Finance	Operations	Other	\N	Fixed-term	94.18
1140	2021-07-13	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Toulouse	Finance & Administration	LEAD-CTRL-FIN	Finance	Operations	Other	\N	Fixed-term	88.47
1141	2023-09-11	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	FRONT-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00141	Permanent	65.98
1142	2020-04-23	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	CHRO	Executive	Executive	Indeed	CTR-NVT-00142	Permanent	77.58
1143	2013-07-27	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	CONF-FA-FIN	Finance	Operations	Welcome to the Jungle	CTR-NVT-00143	Permanent	77.06
1143	2016-08-04	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-FA-FIN	Finance	Operations	Other	\N	Permanent	87.86
1143	2019-08-26	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	LEAD-FA-FIN	Finance	Operations	Other	\N	Permanent	95.05
1144	2016-09-15	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	PM-PROD	Product Management	Technical	Headhunter	CTR-NVT-00144	Fixed-term	78.05
1144	2019-08-18	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	89.35
1144	2022-10-15	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	93.65
1145	2017-09-03	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-PM-PROD	Product Management	Technical	Company Website	CTR-NVT-00145	Fixed-term	79.73
1146	2016-06-15	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-SCRM-PROD	Agile Methodology	Operations	Indeed	CTR-NVT-00146	Permanent	82.42
1146	2019-05-24	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-SCRM-PROD	Agile Methodology	Operations	Other	\N	Permanent	81.60
1147	2019-07-08	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-CSM-SALES	Customer Success	Operations	Headhunter	CTR-NVT-00147	Permanent	67.10
1147	2022-07-12	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	84.99
1147	2025-07-23	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	94.36
1148	2012-03-01	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	HRBP-HR	Human Resources	Support	Company Website	CTR-NVT-00148	Permanent	67.95
1148	2015-03-12	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	CONF-HRBP-HR	Human Resources	Support	Other	\N	Permanent	78.52
1148	2021-02-05	3	Promotion	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	LEAD-HRBP-HR	Human Resources	Support	Other	\N	Permanent	81.41
1149	2023-10-03	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	AM-SALES	Enterprise Sales	Operations	Referral	CTR-NVT-00149	Permanent	71.34
1150	2012-08-11	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	UX-PROD	Design	Technical	Indeed	CTR-NVT-00150	Apprenticeship	75.59
1150	2015-07-29	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-UX-PROD	Design	Technical	Other	\N	Apprenticeship	95.82
1150	2018-07-25	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-UX-PROD	Design	Technical	Other	\N	Apprenticeship	85.09
1151	2021-05-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DATA-ENG	Data & Analytics	Technical	Referral	CTR-NVT-00151	Permanent	74.26
1151	2024-05-12	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DATA-ENG	Data & Analytics	Technical	Other	\N	Permanent	97.75
1152	2014-03-02	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-UX-PROD	Design	Technical	LinkedIn	CTR-NVT-00152	Permanent	84.35
1153	2018-03-15	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-SCRM-PROD	Agile Methodology	Operations	Company Website	CTR-NVT-00153	Permanent	68.45
1154	2015-07-29	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	BRAND-MKT	Brand Management	Marketing	LinkedIn	CTR-NVT-00154	Permanent	70.74
1154	2024-07-31	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-BRAND-MKT	Brand Management	Marketing	Other	\N	Permanent	86.81
1155	2023-05-07	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-PO-PROD	Product Management	Technical	Indeed	CTR-NVT-00155	Permanent	78.76
1156	2025-04-09	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	INFRA-ENG	Infrastructure	Technical	Welcome to the Jungle	CTR-NVT-00156	Permanent	82.67
1157	2022-07-23	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00157	Permanent	89.11
1157	2023-05-12	2	Transfer	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	95.15
1158	2014-10-06	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	PMM-MKT	Product Marketing	Marketing	LinkedIn	CTR-NVT-00158	Permanent	75.88
1158	2017-09-20	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-PMM-MKT	Product Marketing	Marketing	Other	\N	Permanent	82.16
1158	2020-10-22	3	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-PMM-MKT	Product Marketing	Marketing	Other	\N	Permanent	84.46
1159	2012-06-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-FULL-ENG	Software Engineering	Technical	Referral	CTR-NVT-00159	Fixed-term	78.03
1159	2018-07-03	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Fixed-term	95.02
1160	2017-08-26	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	PMM-MKT	Product Marketing	Marketing	Referral	CTR-NVT-00160	Fixed-term	77.36
1160	2020-09-19	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-PMM-MKT	Product Marketing	Marketing	Other	\N	Fixed-term	88.45
1161	2024-07-03	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	SR-TA-HR	Talent Acquisition	Support	Welcome to the Jungle	CTR-NVT-00161	Permanent	65.84
1162	2014-09-16	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	PM-PROD	Product Management	Technical	Company Website	CTR-NVT-00162	Fixed-term	77.90
1162	2017-08-27	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	88.83
1162	2020-09-27	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	76.01
1162	2023-09-03	4	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-PM-PROD	Product Management	Technical	Other	\N	Fixed-term	95.15
1163	2012-08-28	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CSM-SALES	Customer Success	Operations	Headhunter	CTR-NVT-00163	Permanent	74.88
1163	2015-08-31	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CONF-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	74.34
1164	2015-05-25	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-CONT-MKT	Content & Comms	Marketing	LinkedIn	CTR-NVT-00164	Permanent	83.15
1164	2018-06-01	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SR-CONT-MKT	Content & Comms	Marketing	Other	\N	Permanent	83.66
1165	2017-03-11	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-PO-PROD	Product Management	Technical	LinkedIn	CTR-NVT-00165	Permanent	80.16
1165	2020-04-09	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-PO-PROD	Product Management	Technical	Other	\N	Permanent	86.89
1165	2021-04-23	3	Data Change	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-PO-PROD	Product Management	Technical	Other	\N	Permanent	84.66
1166	2012-05-27	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DEVOPS-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00166	Permanent	78.97
1166	2015-05-18	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Permanent	94.83
1167	2018-10-11	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	CONF-PAYROLL-OP	Payroll	Operations	Referral	CTR-NVT-00167	Permanent	85.33
1167	2021-10-25	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	SR-PAYROLL-OP	Payroll	Operations	Other	\N	Permanent	85.74
1167	2024-10-11	3	Promotion	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	LEAD-PAYROLL-OP	Payroll	Operations	Other	\N	Permanent	94.94
1168	2013-03-07	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	CSM-SALES	Customer Success	Operations	Indeed	CTR-NVT-00168	Permanent	89.03
1168	2016-03-06	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	CONF-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	93.72
1168	2022-02-21	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Bordeaux	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	79.49
1169	2022-11-30	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DATA-ENG	Data & Analytics	Technical	LinkedIn	CTR-NVT-00169	Permanent	89.85
1170	2023-07-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-SECU-ENG	Cybersecurity	Technical	LinkedIn	CTR-NVT-00170	Permanent	72.89
1171	2012-06-20	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00171	Permanent	77.91
1171	2013-10-02	2	Transfer	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	74.33
1172	2015-01-14	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	LEAD-HRBP-HR	Human Resources	Support	Referral	CTR-NVT-00172	Permanent	81.84
1173	2012-08-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-BACK-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00173	Fixed-term	66.90
1174	2019-05-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-SECU-ENG	Cybersecurity	Technical	Headhunter	CTR-NVT-00174	Permanent	73.84
1174	2025-06-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	94.42
1175	2025-05-18	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Lyon	People & Culture	CONF-HRBP-HR	Human Resources	Support	Company Website	CTR-NVT-00175	Permanent	69.75
1176	2022-04-24	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-PO-PROD	Product Management	Technical	Company Website	CTR-NVT-00176	Permanent	70.87
1176	2025-04-10	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-PO-PROD	Product Management	Technical	Other	\N	Permanent	82.55
1177	2018-07-21	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	BD-SALES	Sales Development	Operations	Headhunter	CTR-NVT-00177	Permanent	71.24
1177	2021-06-30	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-BD-SALES	Sales Development	Operations	Other	\N	Permanent	91.14
1177	2024-06-26	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	90.87
1178	2016-05-01	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	AM-SALES	Enterprise Sales	Operations	Welcome to the Jungle	CTR-NVT-00178	Internship	80.35
1178	2022-04-03	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-AM-SALES	Enterprise Sales	Operations	Other	\N	Internship	94.66
1178	2025-04-21	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-AM-SALES	Enterprise Sales	Operations	Other	\N	Internship	88.83
1179	2019-06-02	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	INFRA-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00179	Permanent	87.42
1179	2025-06-20	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-INFRA-ENG	Infrastructure	Technical	Other	\N	Permanent	96.15
1180	2025-09-20	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	SMGR-SALES	Sales Management	Operations	LinkedIn	CTR-NVT-00180	Permanent	70.55
1181	2019-05-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DATA-SCI	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00181	Permanent	66.35
1181	2025-05-07	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	Other	\N	Permanent	76.72
1182	2017-08-13	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	SR-PRE-SALES	Sales Engineering	Technical	Referral	CTR-NVT-00182	Permanent	86.51
1183	2023-04-15	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-INFRA-ENG	Infrastructure	Technical	Company Website	CTR-NVT-00183	Permanent	68.01
1184	2017-02-09	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	PO-PROD	Product Management	Technical	Welcome to the Jungle	CTR-NVT-00184	Permanent	72.89
1184	2020-02-22	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-PO-PROD	Product Management	Technical	Other	\N	Permanent	78.64
1184	2023-01-30	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-PO-PROD	Product Management	Technical	Other	\N	Permanent	83.96
1185	2023-05-06	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-FULL-ENG	Software Engineering	Technical	Referral	CTR-NVT-00185	Permanent	71.57
1186	2018-11-05	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-PRE-SALES	Sales Engineering	Technical	Headhunter	CTR-NVT-00186	Permanent	88.96
1186	2021-10-17	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-PRE-SALES	Sales Engineering	Technical	Other	\N	Permanent	88.97
1187	2014-03-01	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SCRM-PROD	Agile Methodology	Operations	Indeed	CTR-NVT-00187	Apprenticeship	82.52
1187	2017-03-25	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-SCRM-PROD	Agile Methodology	Operations	Other	\N	Apprenticeship	82.81
1187	2020-03-07	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-SCRM-PROD	Agile Methodology	Operations	Other	\N	Apprenticeship	78.89
1187	2023-02-13	4	Promotion	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-SCRM-PROD	Agile Methodology	Operations	Other	\N	Apprenticeship	95.91
1188	2023-04-24	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	CONF-BACK-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00188	Permanent	85.10
1189	2024-09-22	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	SR-AM-SALES	Enterprise Sales	Operations	Headhunter	CTR-NVT-00189	Permanent	86.41
1190	2021-09-06	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	BD-SALES	Sales Development	Operations	Company Website	CTR-NVT-00190	Permanent	85.00
1191	2021-04-27	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	BD-SALES	Sales Development	Operations	LinkedIn	CTR-NVT-00191	Permanent	65.24
1191	2024-04-05	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-BD-SALES	Sales Development	Operations	Other	\N	Permanent	95.90
1192	2016-11-17	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-INFRA-ENG	Infrastructure	Technical	Headhunter	CTR-NVT-00192	Permanent	77.93
1193	2025-05-14	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	AM-SALES	Enterprise Sales	Operations	Company Website	CTR-NVT-00193	Permanent	72.50
1194	2023-02-20	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DEVOPS-ENG	Infrastructure	Technical	Headhunter	CTR-NVT-00194	Permanent	79.20
1194	2026-03-06	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Permanent	81.59
1195	2019-07-08	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Referral	CTR-NVT-00195	Permanent	71.36
1196	2015-08-20	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-ML-ENG	AI & Machine Learning	Technical	Indeed	CTR-NVT-00196	Permanent	67.41
1197	2025-07-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00197	Permanent	74.01
1198	2013-06-10	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	ML-ENG	AI & Machine Learning	Technical	Headhunter	CTR-NVT-00198	Permanent	85.25
1198	2016-06-06	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	76.67
1199	2023-04-18	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	LinkedIn	CTR-NVT-00199	Permanent	79.40
1200	2025-12-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	Referral	CTR-NVT-00200	Permanent	69.36
1201	2017-04-12	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	CONF-CTRL-FIN	Finance	Operations	Headhunter	CTR-NVT-00201	Permanent	73.88
1201	2023-04-29	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	LEAD-CTRL-FIN	Finance	Operations	Other	\N	Permanent	87.83
1201	2025-08-04	3	Data Change	Finance	Novaryn Tech	Novaryn Tech - Lyon	Finance & Administration	LEAD-CTRL-FIN	Finance	Operations	Other	\N	Permanent	83.59
1202	2014-07-04	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Lille	Finance & Administration	SR-FA-FIN	Finance	Operations	LinkedIn	CTR-NVT-00202	Permanent	88.91
1203	2016-03-01	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Referral	CTR-NVT-00203	Permanent	88.21
1203	2019-03-10	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	88.58
1203	2020-03-09	3	Data Change	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	77.71
1204	2025-01-27	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	DEVOPS-ENG	Infrastructure	Technical	Indeed	CTR-NVT-00204	Fixed-term	72.92
1205	2019-01-19	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CONF-BRAND-MKT	Brand Management	Marketing	LinkedIn	CTR-NVT-00205	Permanent	71.69
1205	2022-01-06	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Marseille	Commercial	SR-BRAND-MKT	Brand Management	Marketing	Other	\N	Permanent	95.53
1206	2023-11-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	QA-ENG	Quality Assurance	Technical	Referral	CTR-NVT-00206	Permanent	83.70
1207	2018-10-19	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lille	Commercial	PRE-SALES	Sales Engineering	Technical	Indeed	CTR-NVT-00207	Permanent	76.26
1207	2021-11-12	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lille	Commercial	CONF-PRE-SALES	Sales Engineering	Technical	Other	\N	Permanent	74.51
1208	2023-02-28	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	DEVOPS-ENG	Infrastructure	Technical	Company Website	CTR-NVT-00208	Fixed-term	88.51
1208	2024-03-04	2	Data Change	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	DEVOPS-ENG	Infrastructure	Technical	Other	\N	Fixed-term	74.58
1209	2025-02-05	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SR-AM-SALES	Enterprise Sales	Operations	Indeed	CTR-NVT-00209	Permanent	66.59
1210	2019-03-26	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	PMM-MKT	Product Marketing	Marketing	Referral	CTR-NVT-00210	Fixed-term	78.71
1210	2022-03-21	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-PMM-MKT	Product Marketing	Marketing	Other	\N	Fixed-term	85.53
1211	2025-09-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	BACK-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00211	Permanent	80.45
1212	2012-11-08	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BD-SALES	Sales Development	Operations	Headhunter	CTR-NVT-00212	Permanent	88.29
1212	2015-10-23	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	81.44
1212	2018-11-18	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-BD-SALES	Sales Development	Operations	Other	\N	Permanent	80.78
1213	2019-10-07	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FULL-ENG	Software Engineering	Technical	Welcome to the Jungle	CTR-NVT-00213	Permanent	69.27
1213	2022-09-29	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	94.93
1213	2025-10-07	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	88.28
1214	2023-05-11	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	UX-PROD	Design	Technical	Welcome to the Jungle	CTR-NVT-00214	Permanent	88.37
1215	2019-07-13	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	SR-ML-ENG	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00215	Permanent	68.38
1216	2021-04-27	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SCRM-PROD	Agile Methodology	Operations	Indeed	CTR-NVT-00216	Permanent	79.77
1216	2024-05-14	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-SCRM-PROD	Agile Methodology	Operations	Other	\N	Permanent	87.99
1217	2024-08-25	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Toulouse	Commercial	CONF-AM-SALES	Enterprise Sales	Operations	Headhunter	CTR-NVT-00217	Permanent	78.09
1218	2016-05-29	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-GROWTH-MKT	Growth Marketing	Marketing	LinkedIn	CTR-NVT-00218	Permanent	72.74
1218	2019-06-02	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SR-GROWTH-MKT	Growth Marketing	Marketing	Other	\N	Permanent	81.00
1218	2022-05-18	3	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-GROWTH-MKT	Growth Marketing	Marketing	Other	\N	Permanent	86.05
1219	2016-09-19	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	CONF-QA-ENG	Quality Assurance	Technical	LinkedIn	CTR-NVT-00219	Permanent	72.59
1219	2019-10-11	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	92.68
1219	2022-09-07	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	88.32
1219	2024-08-10	4	Data Change	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-QA-ENG	Quality Assurance	Technical	Other	\N	Permanent	79.49
1220	2016-01-26	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-PO-PROD	Product Management	Technical	LinkedIn	CTR-NVT-00220	Permanent	84.15
1221	2013-04-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	FRONT-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00221	Permanent	84.92
1221	2016-04-08	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	83.06
1221	2019-04-21	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	SR-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	81.50
1222	2016-08-15	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Indeed	CTR-NVT-00222	Permanent	85.71
1223	2021-03-10	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FRONT-ENG	Software Engineering	Technical	Company Website	CTR-NVT-00223	Permanent	66.98
1223	2024-03-13	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	90.82
1224	2014-07-26	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	PO-PROD	Product Management	Technical	Welcome to the Jungle	CTR-NVT-00224	Permanent	85.19
1224	2020-08-12	2	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-PO-PROD	Product Management	Technical	Other	\N	Permanent	87.70
1224	2023-07-08	3	Promotion	Product	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-PO-PROD	Product Management	Technical	Other	\N	Permanent	96.78
1225	2023-10-22	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-DATA-SCI	AI & Machine Learning	Technical	LinkedIn	CTR-NVT-00225	Permanent	72.24
1226	2015-08-22	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	SR-CSM-SALES	Customer Success	Operations	LinkedIn	CTR-NVT-00226	Permanent	80.44
1226	2018-08-31	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Marseille	Commercial	LEAD-CSM-SALES	Customer Success	Operations	Other	\N	Permanent	88.82
1227	2018-12-07	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-BACK-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00227	Permanent	68.80
1227	2024-11-13	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-BACK-ENG	Software Engineering	Technical	Other	\N	Permanent	84.21
1228	2019-12-05	1	Hiring	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	ADMIN-OP	Operations	Operations	Company Website	CTR-NVT-00228	Permanent	75.96
1228	2022-11-10	2	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	CONF-ADMIN-OP	Operations	Operations	Other	\N	Permanent	77.32
1228	2025-11-26	3	Promotion	Finance	Novaryn Tech	Novaryn Tech - Paris	Finance & Administration	SR-ADMIN-OP	Operations	Operations	Other	\N	Permanent	85.25
1229	2015-07-09	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	INFRA-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00229	Apprenticeship	77.46
1229	2018-07-23	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-INFRA-ENG	Infrastructure	Technical	Other	\N	Apprenticeship	91.41
1229	2021-08-01	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-INFRA-ENG	Infrastructure	Technical	Other	\N	Apprenticeship	92.51
1229	2024-06-26	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	LEAD-INFRA-ENG	Infrastructure	Technical	Other	\N	Apprenticeship	95.06
1230	2025-02-04	1	Hiring	Product	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-SCRM-PROD	Agile Methodology	Operations	Referral	CTR-NVT-00230	Permanent	69.54
1231	2012-05-01	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lille	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Company Website	CTR-NVT-00231	Permanent	71.25
1232	2012-02-06	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Paris	People & Culture	CONF-PAYROLL-OP	Payroll	Operations	Referral	CTR-NVT-00232	Permanent	65.32
1233	2024-10-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	ML-ENG	AI & Machine Learning	Technical	Headhunter	CTR-NVT-00233	Permanent	89.37
1234	2021-02-26	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FRONT-ENG	Software Engineering	Technical	Referral	CTR-NVT-00234	Permanent	89.86
1234	2024-03-14	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Other	\N	Permanent	90.96
1235	2015-09-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-ML-ENG	AI & Machine Learning	Technical	Referral	CTR-NVT-00235	Permanent	89.55
1235	2018-10-08	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	LEAD-ML-ENG	AI & Machine Learning	Technical	Other	\N	Permanent	99.15
1236	2020-04-05	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Headhunter	CTR-NVT-00236	Permanent	68.97
1237	2017-09-19	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	FRONT-ENG	Software Engineering	Technical	Other	CTR-NVT-00237	Fixed-term	78.74
1237	2020-09-19	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-FRONT-ENG	Software Engineering	Technical	Other	\N	Fixed-term	88.05
1237	2023-10-15	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-FRONT-ENG	Software Engineering	Technical	Other	\N	Fixed-term	77.15
1238	2014-10-22	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SECU-ENG	Cybersecurity	Technical	LinkedIn	CTR-NVT-00238	Fixed-term	89.33
1238	2017-10-19	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	CONF-SECU-ENG	Cybersecurity	Technical	Other	\N	Fixed-term	81.14
1238	2020-10-09	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	SR-SECU-ENG	Cybersecurity	Technical	Other	\N	Fixed-term	88.86
1238	2023-10-07	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Lyon	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Fixed-term	78.20
1238	2025-08-23	5	Transfer	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Fixed-term	91.27
1239	2022-08-02	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	PRE-SALES	Sales Engineering	Technical	Company Website	CTR-NVT-00239	Permanent	71.22
1239	2025-08-15	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-PRE-SALES	Sales Engineering	Technical	Other	\N	Permanent	87.61
1240	2022-01-25	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-DEVOPS-ENG	Infrastructure	Technical	LinkedIn	CTR-NVT-00240	Permanent	89.92
1240	2024-12-29	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	SR-DEVOPS-ENG	Infrastructure	Technical	Other	\N	Permanent	83.82
1241	2012-06-17	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FULL-ENG	Software Engineering	Technical	Indeed	CTR-NVT-00241	Permanent	78.41
1241	2015-06-18	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	CONF-FULL-ENG	Software Engineering	Technical	Other	\N	Permanent	79.12
1242	2019-04-17	1	Hiring	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	CONF-HRBP-HR	Human Resources	Support	Referral	CTR-NVT-00242	Permanent	85.14
1242	2022-03-30	2	Promotion	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	SR-HRBP-HR	Human Resources	Support	Other	\N	Permanent	76.47
1242	2025-05-03	3	Promotion	HR	Novaryn Tech	Novaryn Tech - Marseille	People & Culture	LEAD-HRBP-HR	Human Resources	Support	Other	\N	Permanent	80.96
1243	2015-02-03	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SECU-ENG	Cybersecurity	Technical	LinkedIn	CTR-NVT-00243	Permanent	77.13
1243	2018-01-22	2	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	CONF-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	85.94
1243	2021-02-09	3	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	SR-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	80.11
1243	2024-02-19	4	Promotion	Engineering	Novaryn Tech	Novaryn Tech - Marseille	Technology	LEAD-SECU-ENG	Cybersecurity	Technical	Other	\N	Permanent	88.30
1244	2018-06-13	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Bordeaux	Technology	SR-DATA-ENG	Data & Analytics	Technical	LinkedIn	CTR-NVT-00244	Permanent	79.97
1245	2019-09-26	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	BD-SALES	Sales Development	Operations	LinkedIn	CTR-NVT-00245	Permanent	78.28
1245	2022-10-18	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	CONF-BD-SALES	Sales Development	Operations	Other	\N	Permanent	79.79
1245	2025-08-27	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BD-SALES	Sales Development	Operations	Other	\N	Permanent	93.07
1246	2024-12-13	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Paris	Technology	FULL-ENG	Software Engineering	Technical	LinkedIn	CTR-NVT-00246	Apprenticeship	83.34
1247	2024-10-16	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Marseille	Commercial	CONT-MKT	Content & Comms	Marketing	Indeed	CTR-NVT-00247	Permanent	80.49
1248	2013-05-23	1	Hiring	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	CONF-PRE-SALES	Sales Engineering	Technical	Indeed	CTR-NVT-00248	Fixed-term	80.50
1248	2016-04-27	2	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	SR-PRE-SALES	Sales Engineering	Technical	Other	\N	Fixed-term	90.48
1248	2019-05-17	3	Promotion	Sales	Novaryn Tech	Novaryn Tech - Lyon	Commercial	LEAD-PRE-SALES	Sales Engineering	Technical	Other	\N	Fixed-term	82.18
1249	2024-09-28	1	Hiring	Engineering	Novaryn Tech	Novaryn Tech - Toulouse	Technology	BACK-ENG	Software Engineering	Technical	Other	CTR-NVT-00249	Permanent	84.14
1250	2017-12-14	1	Hiring	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	SR-BRAND-MKT	Brand Management	Marketing	Welcome to the Jungle	CTR-NVT-00250	Permanent	72.08
1250	2020-12-04	2	Promotion	Marketing	Novaryn Tech	Novaryn Tech - Paris	Commercial	LEAD-BRAND-MKT	Brand Management	Marketing	Other	\N	Permanent	80.43
\.


--
-- TOC entry 5125 (class 0 OID 19777)
-- Dependencies: 225
-- Data for Name: learning_management_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_management_system (user_id, courseid, coursetitle, completiondate, status, credithours, grade, trainingcost, trainingtype) FROM stdin;
1001	GDPR-001	RGPD & Protection des Données	2024-09-07	COMP	2.00	95.58	207.52	COMPLIANCE
1001	HEALTH-001	Santé & Sécurité au Travail	2024-08-29	COMP	4.00	79.45	228.47	COMPLIANCE
1001	FIRE-001	Sécurité & Évacuation Incendie	2024-08-30	COMP	1.00	79.96	99.10	COMPLIANCE
1001	DEI-001	Égalité Femmes-Hommes	2024-08-19	COMP	3.00	89.98	177.41	COMPLIANCE
1001	FRAUD-001	Prévention Fraude & Corruption	2024-08-20	COMP	2.00	75.33	142.91	COMPLIANCE
1001	ETHICS-001	Code de Déontologie Novaryn Tech	2024-08-23	COMP	1.50	75.12	126.25	COMPLIANCE
1001	PM-001	Product Management Essentials	2025-07-02	FAIL	20.00	51.08	1195.79	COURSE
1001	SQL-001	Advanced SQL for Analytics	2025-02-12	COMP	16.00	64.38	876.54	ELEARN
1002	GDPR-001	RGPD & Protection des Données	2015-11-30	COMP	2.00	90.40	191.63	COMPLIANCE
1002	HEALTH-001	Santé & Sécurité au Travail	2015-11-08	COMP	4.00	85.76	233.37	COMPLIANCE
1002	FIRE-001	Sécurité & Évacuation Incendie	2015-11-03	COMP	1.00	93.26	92.00	COMPLIANCE
1002	DEI-001	Égalité Femmes-Hommes	2015-12-15	COMP	3.00	92.09	178.29	COMPLIANCE
1002	FRAUD-001	Prévention Fraude & Corruption	2015-12-11	COMP	2.00	80.52	151.37	COMPLIANCE
1002	ETHICS-001	Code de Déontologie Novaryn Tech	2015-12-06	COMP	1.50	84.59	116.74	COMPLIANCE
1002	SQL-001	Advanced SQL for Analytics	2026-06-13	ENR	16.00	0.00	865.89	ELEARN
1002	AZURE-001	Microsoft Azure Fundamentals	2026-06-23	ENR	28.00	0.00	1592.49	ELEARN
1003	GDPR-001	RGPD & Protection des Données	2013-10-22	COMP	2.00	90.57	209.13	COMPLIANCE
1003	HEALTH-001	Santé & Sécurité au Travail	2013-10-06	COMP	4.00	74.44	245.52	COMPLIANCE
1003	FIRE-001	Sécurité & Évacuation Incendie	2013-10-19	COMP	1.00	89.78	92.83	COMPLIANCE
1003	DEI-001	Égalité Femmes-Hommes	2013-11-05	COMP	3.00	70.93	182.79	COMPLIANCE
1003	FRAUD-001	Prévention Fraude & Corruption	2013-11-18	COMP	2.00	99.20	145.78	COMPLIANCE
1003	ETHICS-001	Code de Déontologie Novaryn Tech	2013-11-21	COMP	1.50	72.68	130.10	COMPLIANCE
1003	SAFE-001	SAFe Agile Practitioner	2022-12-14	FAIL	16.00	56.65	1263.48	COURSE
1003	LEAD-001	Leadership & Management	2024-07-13	FAIL	20.00	46.63	1424.04	COURSE
1003	AZURE-001	Microsoft Azure Fundamentals	2023-08-23	COMP	28.00	97.81	1492.60	ELEARN
1003	ML-001	Machine Learning Fundamentals	2025-08-17	COMP	40.00	83.18	1696.88	ELEARN
1003	K8S-001	Kubernetes Fundamentals	2026-04-23	ENR	24.00	0.00	1078.04	ELEARN
1004	GDPR-001	RGPD & Protection des Données	2021-05-17	COMP	2.00	87.00	211.70	COMPLIANCE
1004	HEALTH-001	Santé & Sécurité au Travail	2021-05-10	COMP	4.00	78.65	273.47	COMPLIANCE
1004	FIRE-001	Sécurité & Évacuation Incendie	2021-05-19	COMP	1.00	97.82	92.94	COMPLIANCE
1004	DEI-001	Égalité Femmes-Hommes	2021-05-31	COMP	3.00	74.51	196.80	COMPLIANCE
1004	FRAUD-001	Prévention Fraude & Corruption	2021-05-27	COMP	2.00	86.74	139.88	COMPLIANCE
1004	ETHICS-001	Code de Déontologie Novaryn Tech	2021-05-19	COMP	1.50	78.65	127.19	COMPLIANCE
1004	K8S-001	Kubernetes Fundamentals	2022-02-09	COMP	24.00	93.02	975.73	ELEARN
1004	SCRUM-001	Scrum Fundamentals	2025-10-28	COMP	12.00	60.20	573.41	ELEARN
1005	GDPR-001	RGPD & Protection des Données	2019-05-05	COMP	2.00	70.02	190.06	COMPLIANCE
1005	HEALTH-001	Santé & Sécurité au Travail	2019-04-04	COMP	4.00	96.36	264.26	COMPLIANCE
1005	FIRE-001	Sécurité & Évacuation Incendie	2019-04-14	COMP	1.00	89.96	105.38	COMPLIANCE
1005	DEI-001	Égalité Femmes-Hommes	2019-03-22	COMP	3.00	98.61	187.68	COMPLIANCE
1005	FRAUD-001	Prévention Fraude & Corruption	2019-03-22	COMP	2.00	99.88	140.90	COMPLIANCE
1005	ETHICS-001	Code de Déontologie Novaryn Tech	2019-04-19	COMP	1.50	97.55	114.98	COMPLIANCE
1005	K8S-001	Kubernetes Fundamentals	2025-07-04	COMP	24.00	87.14	1062.46	ELEARN
1005	SQL-001	Advanced SQL for Analytics	2022-11-26	COMP	16.00	96.17	894.33	ELEARN
1006	GDPR-001	RGPD & Protection des Données	2013-08-31	COMP	2.00	87.91	186.93	COMPLIANCE
1006	HEALTH-001	Santé & Sécurité au Travail	2013-09-08	COMP	4.00	90.37	241.12	COMPLIANCE
1006	FIRE-001	Sécurité & Évacuation Incendie	2013-09-18	COMP	1.00	74.18	105.35	COMPLIANCE
1006	DEI-001	Égalité Femmes-Hommes	2013-08-28	COMP	3.00	74.07	181.95	COMPLIANCE
1006	FRAUD-001	Prévention Fraude & Corruption	2013-08-31	COMP	2.00	79.15	143.92	COMPLIANCE
1006	ETHICS-001	Code de Déontologie Novaryn Tech	2013-09-21	COMP	1.50	83.83	112.40	COMPLIANCE
1006	LEAD-001	Leadership & Management	2020-02-09	COMP	20.00	87.41	1435.90	COURSE
1006	PYTHON-001	Python for Data Science	2023-07-29	COMP	24.00	78.66	1138.43	ELEARN
1006	ML-001	Machine Learning Fundamentals	2024-03-03	COMP	40.00	96.50	1372.68	ELEARN
1006	K8S-001	Kubernetes Fundamentals	2026-04-19	ENR	24.00	0.00	1184.43	ELEARN
1006	SQL-001	Advanced SQL for Analytics	2023-09-08	COMP	16.00	72.10	738.23	ELEARN
1007	GDPR-001	RGPD & Protection des Données	2020-09-14	COMP	2.00	81.19	204.84	COMPLIANCE
1007	HEALTH-001	Santé & Sécurité au Travail	2020-09-18	COMP	4.00	96.33	227.68	COMPLIANCE
1007	FIRE-001	Sécurité & Évacuation Incendie	2020-09-07	COMP	1.00	73.78	103.40	COMPLIANCE
1007	DEI-001	Égalité Femmes-Hommes	2020-09-11	COMP	3.00	94.22	193.50	COMPLIANCE
1007	FRAUD-001	Prévention Fraude & Corruption	2020-09-11	COMP	2.00	95.18	137.54	COMPLIANCE
1007	ETHICS-001	Code de Déontologie Novaryn Tech	2020-08-30	COMP	1.50	94.90	123.60	COMPLIANCE
1007	PM-001	Product Management Essentials	2023-12-04	COMP	20.00	73.25	1041.91	COURSE
1007	LEAD-001	Leadership & Management	2026-07-03	ENR	20.00	0.00	1504.87	COURSE
1007	AZURE-001	Microsoft Azure Fundamentals	2026-07-06	ENR	28.00	0.00	1458.43	ELEARN
1007	EXCEL-001	Excel Avancé & Reporting	2024-07-19	COMP	8.00	89.62	399.44	ELEARN
1008	GDPR-001	RGPD & Protection des Données	2015-06-10	COMP	2.00	96.85	205.59	COMPLIANCE
1008	HEALTH-001	Santé & Sécurité au Travail	2015-06-05	COMP	4.00	79.03	240.54	COMPLIANCE
1008	FIRE-001	Sécurité & Évacuation Incendie	2015-05-27	COMP	1.00	94.17	102.47	COMPLIANCE
1008	DEI-001	Égalité Femmes-Hommes	2015-06-08	COMP	3.00	73.44	162.00	COMPLIANCE
1008	FRAUD-001	Prévention Fraude & Corruption	2015-07-04	COMP	2.00	96.40	150.59	COMPLIANCE
1008	ETHICS-001	Code de Déontologie Novaryn Tech	2015-06-11	COMP	1.50	76.13	119.37	COMPLIANCE
1008	REACT-001	React & TypeScript Masterclass	2021-07-01	COMP	36.00	67.36	1104.57	ELEARN
1008	SCRUM-001	Scrum Fundamentals	2026-05-11	ENR	12.00	0.00	657.90	ELEARN
1008	LEAD-001	Leadership & Management	2025-07-13	COMP	20.00	94.37	1552.72	COURSE
1008	AZURE-001	Microsoft Azure Fundamentals	2022-04-19	COMP	28.00	85.45	1448.71	ELEARN
1008	EXCEL-001	Excel Avancé & Reporting	2026-07-01	ENR	8.00	0.00	368.88	ELEARN
1009	GDPR-001	RGPD & Protection des Données	2019-10-01	COMP	2.00	92.25	201.87	COMPLIANCE
1009	HEALTH-001	Santé & Sécurité au Travail	2019-09-29	COMP	4.00	84.41	239.47	COMPLIANCE
1009	FIRE-001	Sécurité & Évacuation Incendie	2019-09-05	COMP	1.00	98.77	99.86	COMPLIANCE
1009	DEI-001	Égalité Femmes-Hommes	2019-10-11	COMP	3.00	78.26	175.89	COMPLIANCE
1009	FRAUD-001	Prévention Fraude & Corruption	2019-10-20	COMP	2.00	73.22	147.51	COMPLIANCE
1009	ETHICS-001	Code de Déontologie Novaryn Tech	2019-09-26	COMP	1.50	74.44	114.80	COMPLIANCE
1009	PM-001	Product Management Essentials	2024-07-30	COMP	20.00	72.11	1252.24	COURSE
1009	REACT-001	React & TypeScript Masterclass	2024-02-11	FAIL	36.00	51.78	1035.35	ELEARN
1010	GDPR-001	RGPD & Protection des Données	2025-11-06	COMP	2.00	98.88	198.72	COMPLIANCE
1010	HEALTH-001	Santé & Sécurité au Travail	2025-11-30	COMP	4.00	83.75	225.46	COMPLIANCE
1010	FIRE-001	Sécurité & Évacuation Incendie	2025-10-25	COMP	1.00	80.73	107.12	COMPLIANCE
1010	DEI-001	Égalité Femmes-Hommes	2025-11-16	COMP	3.00	76.32	194.49	COMPLIANCE
1010	FRAUD-001	Prévention Fraude & Corruption	2025-11-17	COMP	2.00	81.72	136.88	COMPLIANCE
1010	ETHICS-001	Code de Déontologie Novaryn Tech	2025-11-25	COMP	1.50	74.54	123.74	COMPLIANCE
1010	K8S-001	Kubernetes Fundamentals	2026-07-01	ENR	24.00	0.00	1034.97	ELEARN
1010	COMM-001	Communication & Public Speaking	2025-12-31	COMP	8.00	96.65	417.42	OJT
1010	PYTHON-001	Python for Data Science	2025-12-31	COMP	24.00	78.87	1047.69	ELEARN
1010	AZURE-001	Microsoft Azure Fundamentals	2025-12-31	COMP	28.00	97.10	1732.19	ELEARN
1011	GDPR-001	RGPD & Protection des Données	2025-10-26	COMP	2.00	77.78	207.91	COMPLIANCE
1011	HEALTH-001	Santé & Sécurité au Travail	2025-10-30	COMP	4.00	98.66	242.40	COMPLIANCE
1011	FIRE-001	Sécurité & Évacuation Incendie	2025-11-01	COMP	1.00	94.90	91.35	COMPLIANCE
1011	DEI-001	Égalité Femmes-Hommes	2025-09-24	COMP	3.00	95.56	167.73	COMPLIANCE
1011	FRAUD-001	Prévention Fraude & Corruption	2025-09-29	COMP	2.00	89.96	149.98	COMPLIANCE
1011	ETHICS-001	Code de Déontologie Novaryn Tech	2025-11-05	COMP	1.50	84.29	126.24	COMPLIANCE
1011	LEAD-001	Leadership & Management	2026-05-31	ENR	20.00	0.00	1690.07	COURSE
1011	PYTHON-001	Python for Data Science	2025-12-25	COMP	24.00	70.02	861.23	ELEARN
1011	REACT-001	React & TypeScript Masterclass	2026-06-03	ENR	36.00	0.00	1294.81	ELEARN
1012	GDPR-001	RGPD & Protection des Données	2019-04-25	COMP	2.00	88.94	181.18	COMPLIANCE
1012	HEALTH-001	Santé & Sécurité au Travail	2019-03-29	COMP	4.00	79.63	259.94	COMPLIANCE
1012	FIRE-001	Sécurité & Évacuation Incendie	2019-04-11	COMP	1.00	74.00	102.75	COMPLIANCE
1012	DEI-001	Égalité Femmes-Hommes	2019-04-22	COMP	3.00	75.99	171.09	COMPLIANCE
1012	FRAUD-001	Prévention Fraude & Corruption	2019-04-15	COMP	2.00	90.37	141.76	COMPLIANCE
1012	ETHICS-001	Code de Déontologie Novaryn Tech	2019-05-04	COMP	1.50	74.86	127.53	COMPLIANCE
1012	LEAD-001	Leadership & Management	2022-04-13	COMP	20.00	86.75	1366.59	COURSE
1012	PM-001	Product Management Essentials	2026-04-08	ENR	20.00	0.00	1149.44	COURSE
1012	SCRUM-001	Scrum Fundamentals	2022-02-01	COMP	12.00	81.86	522.95	ELEARN
1013	GDPR-001	RGPD & Protection des Données	2014-09-11	COMP	2.00	90.47	218.31	COMPLIANCE
1013	HEALTH-001	Santé & Sécurité au Travail	2014-10-16	COMP	4.00	89.27	249.81	COMPLIANCE
1013	FIRE-001	Sécurité & Évacuation Incendie	2014-10-23	COMP	1.00	76.22	106.55	COMPLIANCE
1013	DEI-001	Égalité Femmes-Hommes	2014-10-02	COMP	3.00	80.56	184.27	COMPLIANCE
1013	FRAUD-001	Prévention Fraude & Corruption	2014-10-05	COMP	2.00	95.60	159.05	COMPLIANCE
1013	ETHICS-001	Code de Déontologie Novaryn Tech	2014-09-28	COMP	1.50	82.83	117.03	COMPLIANCE
1013	PM-001	Product Management Essentials	2020-09-26	COMP	20.00	80.69	1056.33	COURSE
1013	LEAD-001	Leadership & Management	2022-05-16	COMP	20.00	62.06	1518.24	COURSE
1014	GDPR-001	RGPD & Protection des Données	2017-09-30	COMP	2.00	76.72	217.62	COMPLIANCE
1014	HEALTH-001	Santé & Sécurité au Travail	2017-11-21	COMP	4.00	77.54	260.16	COMPLIANCE
1014	FIRE-001	Sécurité & Évacuation Incendie	2017-10-03	COMP	1.00	96.17	93.16	COMPLIANCE
1014	DEI-001	Égalité Femmes-Hommes	2017-10-17	COMP	3.00	72.24	182.71	COMPLIANCE
1014	FRAUD-001	Prévention Fraude & Corruption	2017-11-01	COMP	2.00	97.95	150.00	COMPLIANCE
1014	ETHICS-001	Code de Déontologie Novaryn Tech	2017-10-24	COMP	1.50	88.56	121.10	COMPLIANCE
1014	PM-001	Product Management Essentials	2023-11-01	FAIL	20.00	58.71	1255.16	COURSE
1014	K8S-001	Kubernetes Fundamentals	2022-01-27	COMP	24.00	76.86	1001.17	ELEARN
1015	GDPR-001	RGPD & Protection des Données	2018-08-12	COMP	2.00	71.78	188.17	COMPLIANCE
1015	HEALTH-001	Santé & Sécurité au Travail	2018-08-16	COMP	4.00	92.02	271.21	COMPLIANCE
1015	FIRE-001	Sécurité & Évacuation Incendie	2018-08-06	COMP	1.00	97.37	91.25	COMPLIANCE
1015	DEI-001	Égalité Femmes-Hommes	2018-07-26	COMP	3.00	72.19	196.13	COMPLIANCE
1015	FRAUD-001	Prévention Fraude & Corruption	2018-08-03	COMP	2.00	91.09	157.97	COMPLIANCE
1015	ETHICS-001	Code de Déontologie Novaryn Tech	2018-06-27	COMP	1.50	80.38	109.70	COMPLIANCE
1015	PM-001	Product Management Essentials	2023-12-14	COMP	20.00	65.18	1280.40	COURSE
1015	COMM-001	Communication & Public Speaking	2024-11-05	COMP	8.00	79.86	367.03	OJT
1015	EXCEL-001	Excel Avancé & Reporting	2025-03-11	COMP	8.00	79.10	433.79	ELEARN
1015	LEAD-001	Leadership & Management	2026-05-07	ENR	20.00	0.00	1284.65	COURSE
1015	ML-001	Machine Learning Fundamentals	2023-03-23	COMP	40.00	90.94	1749.45	ELEARN
1016	GDPR-001	RGPD & Protection des Données	2017-12-18	COMP	2.00	88.24	195.18	COMPLIANCE
1016	HEALTH-001	Santé & Sécurité au Travail	2017-12-27	COMP	4.00	92.14	252.62	COMPLIANCE
1016	FIRE-001	Sécurité & Évacuation Incendie	2017-11-17	COMP	1.00	81.61	97.54	COMPLIANCE
1016	DEI-001	Égalité Femmes-Hommes	2017-11-22	COMP	3.00	82.89	177.37	COMPLIANCE
1016	FRAUD-001	Prévention Fraude & Corruption	2017-11-22	COMP	2.00	73.47	138.54	COMPLIANCE
1016	ETHICS-001	Code de Déontologie Novaryn Tech	2017-12-23	COMP	1.50	99.48	116.83	COMPLIANCE
1016	SQL-001	Advanced SQL for Analytics	2022-11-11	COMP	16.00	63.68	682.41	ELEARN
1016	REACT-001	React & TypeScript Masterclass	2020-03-30	COMP	36.00	90.10	1310.78	ELEARN
1016	SCRUM-001	Scrum Fundamentals	2024-03-15	COMP	12.00	61.83	654.32	ELEARN
1017	GDPR-001	RGPD & Protection des Données	2025-11-16	COMP	2.00	77.50	182.28	COMPLIANCE
1017	HEALTH-001	Santé & Sécurité au Travail	2025-10-04	COMP	4.00	73.80	234.03	COMPLIANCE
1017	FIRE-001	Sécurité & Évacuation Incendie	2025-10-03	COMP	1.00	79.42	102.05	COMPLIANCE
1017	DEI-001	Égalité Femmes-Hommes	2025-10-16	COMP	3.00	99.94	166.67	COMPLIANCE
1017	FRAUD-001	Prévention Fraude & Corruption	2025-10-26	COMP	2.00	84.36	138.67	COMPLIANCE
1017	ETHICS-001	Code de Déontologie Novaryn Tech	2025-10-05	COMP	1.50	72.29	130.52	COMPLIANCE
1017	K8S-001	Kubernetes Fundamentals	2025-12-26	FAIL	24.00	56.32	1081.37	ELEARN
1017	COMM-001	Communication & Public Speaking	2025-12-25	COMP	8.00	74.68	406.17	OJT
1017	SQL-001	Advanced SQL for Analytics	2026-05-09	ENR	16.00	0.00	806.44	ELEARN
1018	GDPR-001	RGPD & Protection des Données	2019-11-18	COMP	2.00	79.57	201.66	COMPLIANCE
1018	HEALTH-001	Santé & Sécurité au Travail	2019-11-07	COMP	4.00	71.62	270.02	COMPLIANCE
1018	FIRE-001	Sécurité & Évacuation Incendie	2019-12-16	COMP	1.00	98.52	99.72	COMPLIANCE
1018	DEI-001	Égalité Femmes-Hommes	2019-11-06	COMP	3.00	76.11	166.94	COMPLIANCE
1018	FRAUD-001	Prévention Fraude & Corruption	2019-12-04	COMP	2.00	76.92	157.26	COMPLIANCE
1018	ETHICS-001	Code de Déontologie Novaryn Tech	2019-11-14	COMP	1.50	73.68	125.40	COMPLIANCE
1018	SCRUM-001	Scrum Fundamentals	2021-11-12	COMP	12.00	78.15	530.56	ELEARN
1018	AWS-001	AWS Cloud Practitioner	2023-01-29	COMP	30.00	61.35	1680.10	ELEARN
1018	K8S-001	Kubernetes Fundamentals	2022-04-04	COMP	24.00	93.09	962.88	ELEARN
1020	GDPR-001	RGPD & Protection des Données	2017-01-19	COMP	2.00	95.64	195.36	COMPLIANCE
1020	HEALTH-001	Santé & Sécurité au Travail	2017-01-03	COMP	4.00	95.88	244.23	COMPLIANCE
1020	FIRE-001	Sécurité & Évacuation Incendie	2017-01-04	COMP	1.00	76.73	97.59	COMPLIANCE
1020	DEI-001	Égalité Femmes-Hommes	2017-02-13	COMP	3.00	82.93	163.88	COMPLIANCE
1020	FRAUD-001	Prévention Fraude & Corruption	2017-01-21	COMP	2.00	70.94	157.89	COMPLIANCE
1020	ETHICS-001	Code de Déontologie Novaryn Tech	2017-01-03	COMP	1.50	97.30	126.11	COMPLIANCE
1020	AZURE-001	Microsoft Azure Fundamentals	2022-11-23	COMP	28.00	93.17	1568.36	ELEARN
1020	PM-001	Product Management Essentials	2022-05-18	COMP	20.00	89.17	1284.75	COURSE
1020	AWS-001	AWS Cloud Practitioner	2025-01-26	COMP	30.00	64.37	1739.58	ELEARN
1020	SCRUM-001	Scrum Fundamentals	2026-07-03	ENR	12.00	0.00	561.74	ELEARN
1021	GDPR-001	RGPD & Protection des Données	2018-04-07	COMP	2.00	83.91	202.90	COMPLIANCE
1021	HEALTH-001	Santé & Sécurité au Travail	2018-04-09	COMP	4.00	93.07	238.01	COMPLIANCE
1021	FIRE-001	Sécurité & Évacuation Incendie	2018-03-28	COMP	1.00	84.02	109.85	COMPLIANCE
1021	DEI-001	Égalité Femmes-Hommes	2018-03-19	COMP	3.00	73.96	162.55	COMPLIANCE
1021	FRAUD-001	Prévention Fraude & Corruption	2018-04-24	COMP	2.00	90.48	143.23	COMPLIANCE
1021	ETHICS-001	Code de Déontologie Novaryn Tech	2018-03-19	COMP	1.50	93.14	115.10	COMPLIANCE
1021	SCRUM-001	Scrum Fundamentals	2022-05-08	COMP	12.00	91.30	655.85	ELEARN
1021	PM-001	Product Management Essentials	2024-09-22	COMP	20.00	64.97	1224.64	COURSE
1021	AZURE-001	Microsoft Azure Fundamentals	2020-02-01	COMP	28.00	70.58	1445.82	ELEARN
1021	SQL-001	Advanced SQL for Analytics	2024-05-24	COMP	16.00	77.60	791.95	ELEARN
1021	SAFE-001	SAFe Agile Practitioner	2021-08-16	FAIL	16.00	49.12	1544.62	COURSE
1022	GDPR-001	RGPD & Protection des Données	2024-01-16	COMP	2.00	82.26	203.18	COMPLIANCE
1022	HEALTH-001	Santé & Sécurité au Travail	2024-01-08	COMP	4.00	78.29	255.52	COMPLIANCE
1022	FIRE-001	Sécurité & Évacuation Incendie	2024-01-23	COMP	1.00	98.60	98.81	COMPLIANCE
1022	DEI-001	Égalité Femmes-Hommes	2024-01-19	COMP	3.00	92.98	171.94	COMPLIANCE
1022	FRAUD-001	Prévention Fraude & Corruption	2024-02-03	COMP	2.00	73.82	153.91	COMPLIANCE
1022	ETHICS-001	Code de Déontologie Novaryn Tech	2024-01-12	COMP	1.50	96.14	123.74	COMPLIANCE
1022	LEAD-001	Leadership & Management	2024-05-31	COMP	20.00	80.27	1473.14	COURSE
1022	SAFE-001	SAFe Agile Practitioner	2024-09-29	COMP	16.00	82.14	1285.74	COURSE
1022	SCRUM-001	Scrum Fundamentals	2025-10-06	FAIL	12.00	58.85	685.55	ELEARN
1023	GDPR-001	RGPD & Protection des Données	2023-04-09	COMP	2.00	90.35	214.30	COMPLIANCE
1023	HEALTH-001	Santé & Sécurité au Travail	2023-04-30	COMP	4.00	86.21	227.24	COMPLIANCE
1023	FIRE-001	Sécurité & Évacuation Incendie	2023-04-23	COMP	1.00	80.49	91.55	COMPLIANCE
1023	DEI-001	Égalité Femmes-Hommes	2023-05-06	COMP	3.00	73.40	164.79	COMPLIANCE
1023	FRAUD-001	Prévention Fraude & Corruption	2023-04-21	COMP	2.00	79.77	146.14	COMPLIANCE
1023	ETHICS-001	Code de Déontologie Novaryn Tech	2023-05-30	COMP	1.50	90.43	109.71	COMPLIANCE
1023	AZURE-001	Microsoft Azure Fundamentals	2025-03-22	COMP	28.00	76.33	1672.95	ELEARN
1023	PYTHON-001	Python for Data Science	2025-07-27	COMP	24.00	98.94	1036.57	ELEARN
1023	SCRUM-001	Scrum Fundamentals	2025-11-08	COMP	12.00	61.78	677.46	ELEARN
1023	SQL-001	Advanced SQL for Analytics	2024-07-07	FAIL	16.00	40.49	826.17	ELEARN
1023	PM-001	Product Management Essentials	2026-06-12	ENR	20.00	0.00	1277.68	COURSE
1024	GDPR-001	RGPD & Protection des Données	2017-01-26	COMP	2.00	85.25	203.26	COMPLIANCE
1024	HEALTH-001	Santé & Sécurité au Travail	2017-01-01	COMP	4.00	98.20	243.94	COMPLIANCE
1024	FIRE-001	Sécurité & Évacuation Incendie	2017-01-16	COMP	1.00	70.98	104.53	COMPLIANCE
1024	DEI-001	Égalité Femmes-Hommes	2017-01-03	COMP	3.00	92.88	185.37	COMPLIANCE
1024	FRAUD-001	Prévention Fraude & Corruption	2016-12-14	COMP	2.00	98.76	164.77	COMPLIANCE
1024	ETHICS-001	Code de Déontologie Novaryn Tech	2017-01-15	COMP	1.50	85.10	121.79	COMPLIANCE
1024	ML-001	Machine Learning Fundamentals	2025-06-29	COMP	40.00	86.37	1609.76	ELEARN
1024	COMM-001	Communication & Public Speaking	2024-03-04	COMP	8.00	67.80	409.03	OJT
1024	LEAD-001	Leadership & Management	2023-10-24	FAIL	20.00	46.25	1634.55	COURSE
1024	EXCEL-001	Excel Avancé & Reporting	2020-02-23	FAIL	8.00	44.39	377.78	ELEARN
1024	SCRUM-001	Scrum Fundamentals	2020-10-16	FAIL	12.00	53.17	590.10	ELEARN
1026	GDPR-001	RGPD & Protection des Données	2019-10-21	COMP	2.00	80.86	194.08	COMPLIANCE
1026	HEALTH-001	Santé & Sécurité au Travail	2019-10-27	COMP	4.00	72.29	243.11	COMPLIANCE
1026	FIRE-001	Sécurité & Évacuation Incendie	2019-10-25	COMP	1.00	88.16	98.98	COMPLIANCE
1026	DEI-001	Égalité Femmes-Hommes	2019-10-21	COMP	3.00	76.89	191.80	COMPLIANCE
1026	FRAUD-001	Prévention Fraude & Corruption	2019-10-03	COMP	2.00	97.77	142.35	COMPLIANCE
1026	ETHICS-001	Code de Déontologie Novaryn Tech	2019-10-21	COMP	1.50	90.22	123.98	COMPLIANCE
1026	EXCEL-001	Excel Avancé & Reporting	2022-07-03	COMP	8.00	76.34	400.60	ELEARN
1026	AZURE-001	Microsoft Azure Fundamentals	2021-11-19	COMP	28.00	79.77	1783.09	ELEARN
1026	SQL-001	Advanced SQL for Analytics	2023-06-10	COMP	16.00	67.20	788.98	ELEARN
1026	SAFE-001	SAFe Agile Practitioner	2025-11-19	COMP	16.00	76.75	1511.51	COURSE
1030	GDPR-001	RGPD & Protection des Données	2022-07-04	COMP	2.00	97.90	209.71	COMPLIANCE
1030	HEALTH-001	Santé & Sécurité au Travail	2022-05-28	COMP	4.00	96.08	266.69	COMPLIANCE
1030	FIRE-001	Sécurité & Évacuation Incendie	2022-05-21	COMP	1.00	90.70	109.80	COMPLIANCE
1030	DEI-001	Égalité Femmes-Hommes	2022-05-28	COMP	3.00	85.45	181.06	COMPLIANCE
1030	FRAUD-001	Prévention Fraude & Corruption	2022-06-13	COMP	2.00	97.13	145.63	COMPLIANCE
1030	ETHICS-001	Code de Déontologie Novaryn Tech	2022-06-14	COMP	1.50	90.91	113.79	COMPLIANCE
1030	LEAD-001	Leadership & Management	2023-08-23	COMP	20.00	64.31	1599.98	COURSE
1030	SQL-001	Advanced SQL for Analytics	2023-11-29	COMP	16.00	96.83	907.98	ELEARN
1030	COMM-001	Communication & Public Speaking	2025-06-07	FAIL	8.00	51.99	428.88	OJT
1030	PM-001	Product Management Essentials	2025-01-30	COMP	20.00	90.31	1272.04	COURSE
1031	GDPR-001	RGPD & Protection des Données	2021-03-26	COMP	2.00	75.50	210.64	COMPLIANCE
1031	HEALTH-001	Santé & Sécurité au Travail	2021-04-01	COMP	4.00	98.10	229.19	COMPLIANCE
1031	FIRE-001	Sécurité & Évacuation Incendie	2021-02-08	COMP	1.00	87.81	97.40	COMPLIANCE
1031	DEI-001	Égalité Femmes-Hommes	2021-03-21	COMP	3.00	83.61	173.54	COMPLIANCE
1031	FRAUD-001	Prévention Fraude & Corruption	2021-02-19	COMP	2.00	85.26	152.64	COMPLIANCE
1031	ETHICS-001	Code de Déontologie Novaryn Tech	2021-03-29	COMP	1.50	72.91	115.14	COMPLIANCE
1031	SCRUM-001	Scrum Fundamentals	2024-06-21	COMP	12.00	93.76	586.80	ELEARN
1031	PM-001	Product Management Essentials	2025-05-11	COMP	20.00	72.74	1084.23	COURSE
1031	ML-001	Machine Learning Fundamentals	2025-11-06	COMP	40.00	92.56	1712.62	ELEARN
1031	SAFE-001	SAFe Agile Practitioner	2024-04-04	FAIL	16.00	44.00	1408.04	COURSE
1032	GDPR-001	RGPD & Protection des Données	2019-12-25	COMP	2.00	96.39	192.57	COMPLIANCE
1032	HEALTH-001	Santé & Sécurité au Travail	2019-12-11	COMP	4.00	78.54	230.93	COMPLIANCE
1032	FIRE-001	Sécurité & Évacuation Incendie	2019-12-06	COMP	1.00	84.60	94.47	COMPLIANCE
1032	DEI-001	Égalité Femmes-Hommes	2019-11-29	COMP	3.00	78.65	195.04	COMPLIANCE
1032	FRAUD-001	Prévention Fraude & Corruption	2019-12-27	COMP	2.00	92.60	162.74	COMPLIANCE
1032	ETHICS-001	Code de Déontologie Novaryn Tech	2019-12-31	COMP	1.50	78.36	110.30	COMPLIANCE
1032	SCRUM-001	Scrum Fundamentals	2023-09-23	FAIL	12.00	50.26	653.82	ELEARN
1032	PM-001	Product Management Essentials	2024-10-15	COMP	20.00	93.30	1029.28	COURSE
1032	EXCEL-001	Excel Avancé & Reporting	2022-12-03	COMP	8.00	97.67	408.54	ELEARN
1033	GDPR-001	RGPD & Protection des Données	2023-01-12	COMP	2.00	83.34	185.05	COMPLIANCE
1033	HEALTH-001	Santé & Sécurité au Travail	2022-12-26	COMP	4.00	78.85	230.48	COMPLIANCE
1033	FIRE-001	Sécurité & Évacuation Incendie	2023-01-11	COMP	1.00	97.58	92.40	COMPLIANCE
1033	DEI-001	Égalité Femmes-Hommes	2022-12-24	COMP	3.00	84.80	165.13	COMPLIANCE
1033	FRAUD-001	Prévention Fraude & Corruption	2022-12-05	COMP	2.00	99.79	156.95	COMPLIANCE
1033	ETHICS-001	Code de Déontologie Novaryn Tech	2022-12-04	COMP	1.50	99.05	127.29	COMPLIANCE
1033	COMM-001	Communication & Public Speaking	2024-08-17	COMP	8.00	73.41	394.42	OJT
1033	LEAD-001	Leadership & Management	2026-07-03	ENR	20.00	0.00	1624.67	COURSE
1033	SQL-001	Advanced SQL for Analytics	2026-05-18	ENR	16.00	0.00	894.15	ELEARN
1034	GDPR-001	RGPD & Protection des Données	2023-09-03	COMP	2.00	83.00	217.29	COMPLIANCE
1034	HEALTH-001	Santé & Sécurité au Travail	2023-10-21	COMP	4.00	85.64	234.52	COMPLIANCE
1034	FIRE-001	Sécurité & Évacuation Incendie	2023-10-06	COMP	1.00	89.83	107.55	COMPLIANCE
1034	DEI-001	Égalité Femmes-Hommes	2023-09-03	COMP	3.00	98.48	184.58	COMPLIANCE
1034	FRAUD-001	Prévention Fraude & Corruption	2023-09-16	COMP	2.00	74.11	146.29	COMPLIANCE
1034	ETHICS-001	Code de Déontologie Novaryn Tech	2023-09-15	COMP	1.50	90.20	114.37	COMPLIANCE
1034	K8S-001	Kubernetes Fundamentals	2024-07-18	COMP	24.00	67.94	1224.04	ELEARN
1034	PYTHON-001	Python for Data Science	2024-06-05	FAIL	24.00	56.29	1074.83	ELEARN
1034	EXCEL-001	Excel Avancé & Reporting	2024-05-20	COMP	8.00	62.69	406.93	ELEARN
1035	GDPR-001	RGPD & Protection des Données	2025-04-03	COMP	2.00	91.30	181.55	COMPLIANCE
1035	HEALTH-001	Santé & Sécurité au Travail	2025-05-04	COMP	4.00	77.89	244.01	COMPLIANCE
1035	FIRE-001	Sécurité & Évacuation Incendie	2025-04-27	COMP	1.00	77.04	96.97	COMPLIANCE
1035	DEI-001	Égalité Femmes-Hommes	2025-04-23	COMP	3.00	89.71	168.48	COMPLIANCE
1035	FRAUD-001	Prévention Fraude & Corruption	2025-04-09	COMP	2.00	95.22	161.25	COMPLIANCE
1035	ETHICS-001	Code de Déontologie Novaryn Tech	2025-05-02	COMP	1.50	84.55	127.12	COMPLIANCE
1035	PM-001	Product Management Essentials	2025-07-28	COMP	20.00	64.49	1337.12	COURSE
1035	SQL-001	Advanced SQL for Analytics	2026-05-14	ENR	16.00	0.00	780.70	ELEARN
1035	ML-001	Machine Learning Fundamentals	2025-10-12	COMP	40.00	69.90	1563.94	ELEARN
1035	K8S-001	Kubernetes Fundamentals	2025-07-28	COMP	24.00	98.25	1153.00	ELEARN
1035	AZURE-001	Microsoft Azure Fundamentals	2025-08-22	COMP	28.00	75.92	1421.47	ELEARN
1036	GDPR-001	RGPD & Protection des Données	2026-01-30	COMP	2.00	95.20	214.56	COMPLIANCE
1036	HEALTH-001	Santé & Sécurité au Travail	2026-02-07	COMP	4.00	82.36	236.74	COMPLIANCE
1036	FIRE-001	Sécurité & Évacuation Incendie	2026-01-18	COMP	1.00	78.04	94.30	COMPLIANCE
1036	DEI-001	Égalité Femmes-Hommes	2026-02-19	COMP	3.00	82.27	182.24	COMPLIANCE
1036	FRAUD-001	Prévention Fraude & Corruption	2026-01-20	COMP	2.00	77.85	144.53	COMPLIANCE
1036	ETHICS-001	Code de Déontologie Novaryn Tech	2026-01-25	COMP	1.50	94.27	118.20	COMPLIANCE
1036	SCRUM-001	Scrum Fundamentals	2025-12-31	COMP	12.00	92.74	565.53	ELEARN
1036	AZURE-001	Microsoft Azure Fundamentals	2025-12-31	COMP	28.00	82.90	1439.94	ELEARN
1036	K8S-001	Kubernetes Fundamentals	2025-12-31	COMP	24.00	85.01	1247.80	ELEARN
1036	AWS-001	AWS Cloud Practitioner	2025-12-31	COMP	30.00	73.19	1856.68	ELEARN
1037	GDPR-001	RGPD & Protection des Données	2018-11-05	COMP	2.00	98.51	180.84	COMPLIANCE
1037	HEALTH-001	Santé & Sécurité au Travail	2018-11-28	COMP	4.00	72.71	260.24	COMPLIANCE
1037	FIRE-001	Sécurité & Évacuation Incendie	2018-11-26	COMP	1.00	93.01	101.06	COMPLIANCE
1037	DEI-001	Égalité Femmes-Hommes	2018-12-15	COMP	3.00	71.48	169.58	COMPLIANCE
1037	FRAUD-001	Prévention Fraude & Corruption	2018-12-08	COMP	2.00	75.95	139.71	COMPLIANCE
1037	ETHICS-001	Code de Déontologie Novaryn Tech	2018-12-08	COMP	1.50	81.87	125.23	COMPLIANCE
1037	EXCEL-001	Excel Avancé & Reporting	2021-08-18	COMP	8.00	82.12	369.84	ELEARN
1037	PYTHON-001	Python for Data Science	2021-11-03	COMP	24.00	93.82	1076.54	ELEARN
1037	SQL-001	Advanced SQL for Analytics	2024-02-13	COMP	16.00	80.06	869.92	ELEARN
1037	SAFE-001	SAFe Agile Practitioner	2022-05-09	COMP	16.00	71.32	1200.18	COURSE
1038	GDPR-001	RGPD & Protection des Données	2015-09-20	COMP	2.00	93.17	189.89	COMPLIANCE
1038	HEALTH-001	Santé & Sécurité au Travail	2015-08-28	COMP	4.00	92.50	265.65	COMPLIANCE
1038	FIRE-001	Sécurité & Évacuation Incendie	2015-09-04	COMP	1.00	89.66	92.62	COMPLIANCE
1038	DEI-001	Égalité Femmes-Hommes	2015-09-27	COMP	3.00	96.30	193.03	COMPLIANCE
1038	FRAUD-001	Prévention Fraude & Corruption	2015-08-15	COMP	2.00	72.22	156.66	COMPLIANCE
1038	ETHICS-001	Code de Déontologie Novaryn Tech	2015-09-28	COMP	1.50	91.98	108.48	COMPLIANCE
1038	LEAD-001	Leadership & Management	2026-05-02	ENR	20.00	0.00	1649.16	COURSE
1038	COMM-001	Communication & Public Speaking	2026-05-19	ENR	8.00	0.00	391.02	OJT
1038	PM-001	Product Management Essentials	2026-05-16	ENR	20.00	0.00	1118.66	COURSE
1039	GDPR-001	RGPD & Protection des Données	2017-05-28	COMP	2.00	72.99	218.77	COMPLIANCE
1039	HEALTH-001	Santé & Sécurité au Travail	2017-06-21	COMP	4.00	84.14	239.56	COMPLIANCE
1039	FIRE-001	Sécurité & Évacuation Incendie	2017-05-21	COMP	1.00	76.67	98.13	COMPLIANCE
1039	DEI-001	Égalité Femmes-Hommes	2017-06-02	COMP	3.00	84.50	194.68	COMPLIANCE
1039	FRAUD-001	Prévention Fraude & Corruption	2017-06-19	COMP	2.00	85.20	146.47	COMPLIANCE
1039	ETHICS-001	Code de Déontologie Novaryn Tech	2017-06-16	COMP	1.50	91.83	130.83	COMPLIANCE
1039	K8S-001	Kubernetes Fundamentals	2022-05-29	COMP	24.00	61.00	1189.50	ELEARN
1039	AWS-001	AWS Cloud Practitioner	2020-11-08	COMP	30.00	79.07	1588.83	ELEARN
1042	GDPR-001	RGPD & Protection des Données	2014-06-12	COMP	2.00	79.97	212.39	COMPLIANCE
1042	HEALTH-001	Santé & Sécurité au Travail	2014-05-29	COMP	4.00	72.86	233.46	COMPLIANCE
1042	FIRE-001	Sécurité & Évacuation Incendie	2014-06-24	COMP	1.00	87.80	91.68	COMPLIANCE
1042	DEI-001	Égalité Femmes-Hommes	2014-06-18	COMP	3.00	88.49	179.05	COMPLIANCE
1042	FRAUD-001	Prévention Fraude & Corruption	2014-07-09	COMP	2.00	95.19	157.82	COMPLIANCE
1042	ETHICS-001	Code de Déontologie Novaryn Tech	2014-05-27	COMP	1.50	93.02	114.05	COMPLIANCE
1042	COMM-001	Communication & Public Speaking	2021-08-26	COMP	8.00	82.61	388.78	OJT
1042	SQL-001	Advanced SQL for Analytics	2022-07-09	COMP	16.00	87.62	861.21	ELEARN
1042	PYTHON-001	Python for Data Science	2026-06-16	ENR	24.00	0.00	999.94	ELEARN
1042	SCRUM-001	Scrum Fundamentals	2023-01-26	FAIL	12.00	44.48	593.05	ELEARN
1043	GDPR-001	RGPD & Protection des Données	2021-08-26	COMP	2.00	85.43	214.35	COMPLIANCE
1043	HEALTH-001	Santé & Sécurité au Travail	2021-09-11	COMP	4.00	72.44	230.25	COMPLIANCE
1043	FIRE-001	Sécurité & Évacuation Incendie	2021-09-09	COMP	1.00	72.33	92.55	COMPLIANCE
1043	DEI-001	Égalité Femmes-Hommes	2021-07-27	COMP	3.00	74.86	188.93	COMPLIANCE
1043	FRAUD-001	Prévention Fraude & Corruption	2021-08-06	COMP	2.00	75.92	161.09	COMPLIANCE
1043	ETHICS-001	Code de Déontologie Novaryn Tech	2021-08-03	COMP	1.50	71.17	118.18	COMPLIANCE
1043	SAFE-001	SAFe Agile Practitioner	2022-07-23	COMP	16.00	94.97	1365.62	COURSE
1043	ML-001	Machine Learning Fundamentals	2023-01-30	COMP	40.00	64.70	1837.96	ELEARN
1043	K8S-001	Kubernetes Fundamentals	2026-07-03	ENR	24.00	0.00	1024.47	ELEARN
1044	GDPR-001	RGPD & Protection des Données	2024-10-12	COMP	2.00	88.45	194.87	COMPLIANCE
1044	HEALTH-001	Santé & Sécurité au Travail	2024-11-02	COMP	4.00	74.98	239.51	COMPLIANCE
1044	FIRE-001	Sécurité & Évacuation Incendie	2024-11-04	COMP	1.00	76.13	102.28	COMPLIANCE
1044	DEI-001	Égalité Femmes-Hommes	2024-11-06	COMP	3.00	81.14	183.76	COMPLIANCE
1044	FRAUD-001	Prévention Fraude & Corruption	2024-10-22	COMP	2.00	83.89	163.09	COMPLIANCE
1044	ETHICS-001	Code de Déontologie Novaryn Tech	2024-11-08	COMP	1.50	91.60	128.46	COMPLIANCE
1044	PYTHON-001	Python for Data Science	2025-09-14	COMP	24.00	76.65	895.10	ELEARN
1044	ML-001	Machine Learning Fundamentals	2025-07-09	COMP	40.00	99.08	1509.68	ELEARN
1044	K8S-001	Kubernetes Fundamentals	2025-02-01	COMP	24.00	87.76	1112.45	ELEARN
1046	GDPR-001	RGPD & Protection des Données	2015-10-22	COMP	2.00	72.84	205.00	COMPLIANCE
1046	HEALTH-001	Santé & Sécurité au Travail	2015-11-08	COMP	4.00	74.69	242.52	COMPLIANCE
1046	FIRE-001	Sécurité & Évacuation Incendie	2015-11-05	COMP	1.00	96.50	96.90	COMPLIANCE
1046	DEI-001	Égalité Femmes-Hommes	2015-10-01	COMP	3.00	97.84	171.88	COMPLIANCE
1046	FRAUD-001	Prévention Fraude & Corruption	2015-11-22	COMP	2.00	97.35	147.78	COMPLIANCE
1046	ETHICS-001	Code de Déontologie Novaryn Tech	2015-11-16	COMP	1.50	79.17	122.99	COMPLIANCE
1046	AZURE-001	Microsoft Azure Fundamentals	2022-05-02	COMP	28.00	64.12	1463.89	ELEARN
1046	ML-001	Machine Learning Fundamentals	2020-05-21	COMP	40.00	82.55	1420.82	ELEARN
1046	COMM-001	Communication & Public Speaking	2020-06-18	COMP	8.00	85.79	385.95	OJT
1046	AWS-001	AWS Cloud Practitioner	2024-09-15	COMP	30.00	94.14	1856.58	ELEARN
1046	LEAD-001	Leadership & Management	2022-06-26	FAIL	20.00	54.01	1552.15	COURSE
1047	GDPR-001	RGPD & Protection des Données	2020-06-30	COMP	2.00	76.28	180.11	COMPLIANCE
1047	HEALTH-001	Santé & Sécurité au Travail	2020-06-14	COMP	4.00	99.67	229.57	COMPLIANCE
1047	FIRE-001	Sécurité & Évacuation Incendie	2020-07-21	COMP	1.00	88.45	92.87	COMPLIANCE
1047	DEI-001	Égalité Femmes-Hommes	2020-06-30	COMP	3.00	96.24	173.64	COMPLIANCE
1047	FRAUD-001	Prévention Fraude & Corruption	2020-06-03	COMP	2.00	74.11	159.22	COMPLIANCE
1047	ETHICS-001	Code de Déontologie Novaryn Tech	2020-06-27	COMP	1.50	89.95	115.85	COMPLIANCE
1047	AWS-001	AWS Cloud Practitioner	2021-09-18	COMP	30.00	90.96	1911.37	ELEARN
1047	ML-001	Machine Learning Fundamentals	2024-10-25	COMP	40.00	93.55	1512.15	ELEARN
1048	GDPR-001	RGPD & Protection des Données	2012-10-31	COMP	2.00	96.50	213.69	COMPLIANCE
1048	HEALTH-001	Santé & Sécurité au Travail	2012-11-05	COMP	4.00	98.36	266.68	COMPLIANCE
1048	FIRE-001	Sécurité & Évacuation Incendie	2012-12-10	COMP	1.00	74.29	98.74	COMPLIANCE
1048	DEI-001	Égalité Femmes-Hommes	2012-11-23	COMP	3.00	84.70	190.40	COMPLIANCE
1048	FRAUD-001	Prévention Fraude & Corruption	2012-12-08	COMP	2.00	73.61	161.99	COMPLIANCE
1048	ETHICS-001	Code de Déontologie Novaryn Tech	2012-12-06	COMP	1.50	80.45	108.61	COMPLIANCE
1048	K8S-001	Kubernetes Fundamentals	2020-11-14	COMP	24.00	82.39	1264.31	ELEARN
1048	SAFE-001	SAFe Agile Practitioner	2020-02-08	FAIL	16.00	47.27	1265.18	COURSE
1048	SQL-001	Advanced SQL for Analytics	2026-04-09	ENR	16.00	0.00	727.00	ELEARN
1048	REACT-001	React & TypeScript Masterclass	2022-06-02	COMP	36.00	67.80	1231.03	ELEARN
1049	GDPR-001	RGPD & Protection des Données	2022-10-01	COMP	2.00	72.82	194.75	COMPLIANCE
1049	HEALTH-001	Santé & Sécurité au Travail	2022-09-26	COMP	4.00	85.08	225.65	COMPLIANCE
1049	FIRE-001	Sécurité & Évacuation Incendie	2022-09-27	COMP	1.00	71.01	95.50	COMPLIANCE
1049	DEI-001	Égalité Femmes-Hommes	2022-10-10	COMP	3.00	81.95	197.85	COMPLIANCE
1049	FRAUD-001	Prévention Fraude & Corruption	2022-10-25	COMP	2.00	77.59	153.76	COMPLIANCE
1049	ETHICS-001	Code de Déontologie Novaryn Tech	2022-10-16	COMP	1.50	94.70	128.72	COMPLIANCE
1049	PM-001	Product Management Essentials	2024-11-30	COMP	20.00	95.00	1290.21	COURSE
1049	SAFE-001	SAFe Agile Practitioner	2026-04-12	ENR	16.00	0.00	1345.20	COURSE
1049	K8S-001	Kubernetes Fundamentals	2024-10-16	COMP	24.00	88.53	1167.86	ELEARN
1049	COMM-001	Communication & Public Speaking	2024-05-14	COMP	8.00	94.04	349.94	OJT
1049	PYTHON-001	Python for Data Science	2026-04-23	ENR	24.00	0.00	866.81	ELEARN
1050	GDPR-001	RGPD & Protection des Données	2019-04-24	COMP	2.00	91.32	192.57	COMPLIANCE
1050	HEALTH-001	Santé & Sécurité au Travail	2019-04-18	COMP	4.00	78.32	267.63	COMPLIANCE
1050	FIRE-001	Sécurité & Évacuation Incendie	2019-04-25	COMP	1.00	88.42	90.33	COMPLIANCE
1050	DEI-001	Égalité Femmes-Hommes	2019-05-07	COMP	3.00	90.16	194.39	COMPLIANCE
1050	FRAUD-001	Prévention Fraude & Corruption	2019-04-29	COMP	2.00	75.08	164.59	COMPLIANCE
1050	ETHICS-001	Code de Déontologie Novaryn Tech	2019-04-30	COMP	1.50	98.33	120.39	COMPLIANCE
1050	REACT-001	React & TypeScript Masterclass	2020-06-08	COMP	36.00	90.45	1073.11	ELEARN
1050	SAFE-001	SAFe Agile Practitioner	2022-02-23	COMP	16.00	66.90	1208.69	COURSE
1050	COMM-001	Communication & Public Speaking	2024-01-24	COMP	8.00	87.55	389.11	OJT
1050	SCRUM-001	Scrum Fundamentals	2020-12-20	COMP	12.00	93.68	679.40	ELEARN
1050	LEAD-001	Leadership & Management	2020-07-22	COMP	20.00	82.42	1327.97	COURSE
1051	GDPR-001	RGPD & Protection des Données	2018-08-23	COMP	2.00	87.05	207.85	COMPLIANCE
1051	HEALTH-001	Santé & Sécurité au Travail	2018-08-30	COMP	4.00	97.91	229.41	COMPLIANCE
1051	FIRE-001	Sécurité & Évacuation Incendie	2018-07-30	COMP	1.00	75.48	91.73	COMPLIANCE
1051	DEI-001	Égalité Femmes-Hommes	2018-08-14	COMP	3.00	87.73	196.77	COMPLIANCE
1051	FRAUD-001	Prévention Fraude & Corruption	2018-09-12	COMP	2.00	75.08	135.31	COMPLIANCE
1051	ETHICS-001	Code de Déontologie Novaryn Tech	2018-09-03	COMP	1.50	81.24	109.95	COMPLIANCE
1051	AZURE-001	Microsoft Azure Fundamentals	2023-05-29	FAIL	28.00	56.43	1718.76	ELEARN
1051	SAFE-001	SAFe Agile Practitioner	2026-05-17	ENR	16.00	0.00	1212.40	COURSE
1051	COMM-001	Communication & Public Speaking	2026-04-30	ENR	8.00	0.00	373.48	OJT
1052	GDPR-001	RGPD & Protection des Données	2020-01-30	COMP	2.00	79.47	189.04	COMPLIANCE
1052	HEALTH-001	Santé & Sécurité au Travail	2020-01-06	COMP	4.00	78.18	234.96	COMPLIANCE
1052	FIRE-001	Sécurité & Évacuation Incendie	2020-01-12	COMP	1.00	77.78	98.79	COMPLIANCE
1052	DEI-001	Égalité Femmes-Hommes	2019-12-30	COMP	3.00	84.70	182.83	COMPLIANCE
1052	FRAUD-001	Prévention Fraude & Corruption	2020-01-16	COMP	2.00	93.17	150.69	COMPLIANCE
1052	ETHICS-001	Code de Déontologie Novaryn Tech	2020-02-16	COMP	1.50	88.93	127.96	COMPLIANCE
1052	PM-001	Product Management Essentials	2025-02-11	COMP	20.00	82.75	1377.75	COURSE
1052	REACT-001	React & TypeScript Masterclass	2025-07-24	COMP	36.00	85.84	1265.53	ELEARN
1053	GDPR-001	RGPD & Protection des Données	2012-04-06	COMP	2.00	76.22	207.99	COMPLIANCE
1053	HEALTH-001	Santé & Sécurité au Travail	2012-04-20	COMP	4.00	86.55	262.16	COMPLIANCE
1053	FIRE-001	Sécurité & Évacuation Incendie	2012-04-05	COMP	1.00	72.72	105.47	COMPLIANCE
1053	DEI-001	Égalité Femmes-Hommes	2012-04-04	COMP	3.00	76.55	171.39	COMPLIANCE
1053	FRAUD-001	Prévention Fraude & Corruption	2012-03-26	COMP	2.00	85.51	153.93	COMPLIANCE
1053	ETHICS-001	Code de Déontologie Novaryn Tech	2012-04-18	COMP	1.50	74.19	122.08	COMPLIANCE
1053	PM-001	Product Management Essentials	2025-11-02	FAIL	20.00	46.13	1057.66	COURSE
1053	REACT-001	React & TypeScript Masterclass	2020-06-15	COMP	36.00	96.04	1077.15	ELEARN
1053	SAFE-001	SAFe Agile Practitioner	2021-04-16	COMP	16.00	73.47	1569.25	COURSE
1053	EXCEL-001	Excel Avancé & Reporting	2021-04-08	COMP	8.00	74.32	359.53	ELEARN
1054	GDPR-001	RGPD & Protection des Données	2014-01-22	COMP	2.00	75.58	180.87	COMPLIANCE
1054	HEALTH-001	Santé & Sécurité au Travail	2014-02-08	COMP	4.00	88.50	254.68	COMPLIANCE
1054	FIRE-001	Sécurité & Évacuation Incendie	2014-02-01	COMP	1.00	83.05	97.99	COMPLIANCE
1054	DEI-001	Égalité Femmes-Hommes	2014-02-10	COMP	3.00	77.31	188.04	COMPLIANCE
1054	FRAUD-001	Prévention Fraude & Corruption	2014-01-26	COMP	2.00	80.14	155.36	COMPLIANCE
1054	ETHICS-001	Code de Déontologie Novaryn Tech	2014-01-07	COMP	1.50	71.20	130.30	COMPLIANCE
1054	EXCEL-001	Excel Avancé & Reporting	2024-10-14	COMP	8.00	90.96	454.48	ELEARN
1054	ML-001	Machine Learning Fundamentals	2022-08-01	COMP	40.00	61.14	1605.86	ELEARN
1054	LEAD-001	Leadership & Management	2020-09-21	FAIL	20.00	56.85	1709.36	COURSE
1055	GDPR-001	RGPD & Protection des Données	2023-01-05	COMP	2.00	75.95	218.90	COMPLIANCE
1055	HEALTH-001	Santé & Sécurité au Travail	2023-01-20	COMP	4.00	74.19	258.17	COMPLIANCE
1055	FIRE-001	Sécurité & Évacuation Incendie	2023-01-22	COMP	1.00	98.80	109.41	COMPLIANCE
1055	DEI-001	Égalité Femmes-Hommes	2022-12-22	COMP	3.00	93.79	167.09	COMPLIANCE
1055	FRAUD-001	Prévention Fraude & Corruption	2022-12-25	COMP	2.00	83.76	139.96	COMPLIANCE
1055	ETHICS-001	Code de Déontologie Novaryn Tech	2022-12-03	COMP	1.50	89.76	112.81	COMPLIANCE
1055	AZURE-001	Microsoft Azure Fundamentals	2024-03-15	COMP	28.00	94.31	1569.54	ELEARN
1055	EXCEL-001	Excel Avancé & Reporting	2026-04-27	ENR	8.00	0.00	422.17	ELEARN
1055	LEAD-001	Leadership & Management	2026-05-25	ENR	20.00	0.00	1277.23	COURSE
1056	GDPR-001	RGPD & Protection des Données	2017-01-14	COMP	2.00	80.34	198.83	COMPLIANCE
1056	HEALTH-001	Santé & Sécurité au Travail	2017-02-16	COMP	4.00	81.82	235.62	COMPLIANCE
1056	FIRE-001	Sécurité & Évacuation Incendie	2017-02-03	COMP	1.00	90.05	106.63	COMPLIANCE
1056	DEI-001	Égalité Femmes-Hommes	2017-02-18	COMP	3.00	77.28	195.01	COMPLIANCE
1056	FRAUD-001	Prévention Fraude & Corruption	2017-01-28	COMP	2.00	73.86	157.89	COMPLIANCE
1056	ETHICS-001	Code de Déontologie Novaryn Tech	2017-01-12	COMP	1.50	82.00	115.85	COMPLIANCE
1056	SAFE-001	SAFe Agile Practitioner	2023-07-17	COMP	16.00	62.87	1395.09	COURSE
1056	COMM-001	Communication & Public Speaking	2026-06-22	ENR	8.00	0.00	343.23	OJT
1056	REACT-001	React & TypeScript Masterclass	2025-01-26	FAIL	36.00	43.39	1104.66	ELEARN
1056	PM-001	Product Management Essentials	2025-04-05	COMP	20.00	80.06	1020.57	COURSE
1057	GDPR-001	RGPD & Protection des Données	2019-11-04	COMP	2.00	92.55	216.58	COMPLIANCE
1057	HEALTH-001	Santé & Sécurité au Travail	2019-11-07	COMP	4.00	76.90	250.00	COMPLIANCE
1057	FIRE-001	Sécurité & Évacuation Incendie	2019-09-29	COMP	1.00	76.34	98.71	COMPLIANCE
1057	DEI-001	Égalité Femmes-Hommes	2019-10-18	COMP	3.00	81.52	168.48	COMPLIANCE
1057	FRAUD-001	Prévention Fraude & Corruption	2019-10-06	COMP	2.00	78.55	146.60	COMPLIANCE
1057	ETHICS-001	Code de Déontologie Novaryn Tech	2019-11-18	COMP	1.50	84.42	114.26	COMPLIANCE
1057	PYTHON-001	Python for Data Science	2021-12-02	COMP	24.00	63.31	1055.82	ELEARN
1057	EXCEL-001	Excel Avancé & Reporting	2024-06-11	COMP	8.00	94.50	436.43	ELEARN
1057	REACT-001	React & TypeScript Masterclass	2023-03-27	COMP	36.00	72.76	1226.89	ELEARN
1057	ML-001	Machine Learning Fundamentals	2023-10-31	COMP	40.00	78.19	1593.35	ELEARN
1057	LEAD-001	Leadership & Management	2023-10-07	FAIL	20.00	47.63	1622.11	COURSE
1058	GDPR-001	RGPD & Protection des Données	2024-04-24	COMP	2.00	82.75	209.68	COMPLIANCE
1058	HEALTH-001	Santé & Sécurité au Travail	2024-04-12	COMP	4.00	88.11	265.12	COMPLIANCE
1058	FIRE-001	Sécurité & Évacuation Incendie	2024-05-03	COMP	1.00	85.06	105.62	COMPLIANCE
1058	DEI-001	Égalité Femmes-Hommes	2024-05-20	COMP	3.00	80.05	181.26	COMPLIANCE
1058	FRAUD-001	Prévention Fraude & Corruption	2024-04-28	COMP	2.00	73.35	140.37	COMPLIANCE
1058	ETHICS-001	Code de Déontologie Novaryn Tech	2024-05-02	COMP	1.50	85.95	117.20	COMPLIANCE
1058	PYTHON-001	Python for Data Science	2025-02-12	COMP	24.00	97.37	1027.05	ELEARN
1058	SCRUM-001	Scrum Fundamentals	2025-09-27	COMP	12.00	92.51	640.97	ELEARN
1059	GDPR-001	RGPD & Protection des Données	2025-01-22	COMP	2.00	83.05	198.59	COMPLIANCE
1059	HEALTH-001	Santé & Sécurité au Travail	2024-12-26	COMP	4.00	73.65	249.48	COMPLIANCE
1059	FIRE-001	Sécurité & Évacuation Incendie	2025-01-16	COMP	1.00	71.50	101.99	COMPLIANCE
1059	DEI-001	Égalité Femmes-Hommes	2025-01-16	COMP	3.00	77.57	174.15	COMPLIANCE
1059	FRAUD-001	Prévention Fraude & Corruption	2025-01-11	COMP	2.00	93.01	135.71	COMPLIANCE
1059	ETHICS-001	Code de Déontologie Novaryn Tech	2025-01-10	COMP	1.50	75.36	116.57	COMPLIANCE
1059	K8S-001	Kubernetes Fundamentals	2025-08-30	COMP	24.00	61.42	971.86	ELEARN
1059	SQL-001	Advanced SQL for Analytics	2026-06-15	ENR	16.00	0.00	857.28	ELEARN
1060	GDPR-001	RGPD & Protection des Données	2013-11-14	COMP	2.00	75.26	201.40	COMPLIANCE
1060	HEALTH-001	Santé & Sécurité au Travail	2013-11-07	COMP	4.00	91.80	256.65	COMPLIANCE
1060	FIRE-001	Sécurité & Évacuation Incendie	2013-11-26	COMP	1.00	96.78	96.91	COMPLIANCE
1060	DEI-001	Égalité Femmes-Hommes	2013-11-28	COMP	3.00	90.67	170.79	COMPLIANCE
1060	FRAUD-001	Prévention Fraude & Corruption	2013-12-21	COMP	2.00	97.11	162.97	COMPLIANCE
1060	ETHICS-001	Code de Déontologie Novaryn Tech	2013-12-21	COMP	1.50	85.71	119.00	COMPLIANCE
1060	SQL-001	Advanced SQL for Analytics	2024-11-01	COMP	16.00	84.37	853.71	ELEARN
1060	EXCEL-001	Excel Avancé & Reporting	2026-04-20	ENR	8.00	0.00	385.83	ELEARN
1061	GDPR-001	RGPD & Protection des Données	2020-10-12	COMP	2.00	72.36	217.10	COMPLIANCE
1061	HEALTH-001	Santé & Sécurité au Travail	2020-10-13	COMP	4.00	79.06	245.04	COMPLIANCE
1061	FIRE-001	Sécurité & Évacuation Incendie	2020-09-07	COMP	1.00	98.51	95.14	COMPLIANCE
1061	DEI-001	Égalité Femmes-Hommes	2020-10-07	COMP	3.00	92.28	164.85	COMPLIANCE
1061	FRAUD-001	Prévention Fraude & Corruption	2020-09-23	COMP	2.00	98.95	158.81	COMPLIANCE
1061	ETHICS-001	Code de Déontologie Novaryn Tech	2020-10-02	COMP	1.50	77.83	115.28	COMPLIANCE
1061	COMM-001	Communication & Public Speaking	2021-05-24	COMP	8.00	68.61	452.26	OJT
1061	SCRUM-001	Scrum Fundamentals	2021-09-22	COMP	12.00	87.55	543.43	ELEARN
1061	SQL-001	Advanced SQL for Analytics	2022-08-25	COMP	16.00	61.83	775.68	ELEARN
1062	GDPR-001	RGPD & Protection des Données	2018-05-30	COMP	2.00	90.35	190.91	COMPLIANCE
1062	HEALTH-001	Santé & Sécurité au Travail	2018-06-14	COMP	4.00	76.21	264.10	COMPLIANCE
1062	FIRE-001	Sécurité & Évacuation Incendie	2018-06-30	COMP	1.00	73.89	95.34	COMPLIANCE
1062	DEI-001	Égalité Femmes-Hommes	2018-06-26	COMP	3.00	93.71	184.85	COMPLIANCE
1062	FRAUD-001	Prévention Fraude & Corruption	2018-05-25	COMP	2.00	76.64	135.54	COMPLIANCE
1062	ETHICS-001	Code de Déontologie Novaryn Tech	2018-06-08	COMP	1.50	76.63	122.67	COMPLIANCE
1062	PM-001	Product Management Essentials	2025-04-27	COMP	20.00	79.02	1220.76	COURSE
1062	REACT-001	React & TypeScript Masterclass	2021-10-17	COMP	36.00	72.79	1316.15	ELEARN
1062	SAFE-001	SAFe Agile Practitioner	2022-04-02	COMP	16.00	94.17	1399.57	COURSE
1062	EXCEL-001	Excel Avancé & Reporting	2025-08-13	COMP	8.00	66.80	386.81	ELEARN
1062	SQL-001	Advanced SQL for Analytics	2020-09-09	COMP	16.00	86.43	817.12	ELEARN
1063	GDPR-001	RGPD & Protection des Données	2025-04-12	COMP	2.00	88.94	202.45	COMPLIANCE
1063	HEALTH-001	Santé & Sécurité au Travail	2025-04-29	COMP	4.00	72.49	262.40	COMPLIANCE
1063	FIRE-001	Sécurité & Évacuation Incendie	2025-05-10	COMP	1.00	81.08	95.84	COMPLIANCE
1063	DEI-001	Égalité Femmes-Hommes	2025-04-27	COMP	3.00	83.54	178.83	COMPLIANCE
1063	FRAUD-001	Prévention Fraude & Corruption	2025-04-16	COMP	2.00	88.75	140.00	COMPLIANCE
1063	ETHICS-001	Code de Déontologie Novaryn Tech	2025-04-29	COMP	1.50	86.95	117.97	COMPLIANCE
1063	EXCEL-001	Excel Avancé & Reporting	2025-07-29	COMP	8.00	79.63	368.17	ELEARN
1063	AZURE-001	Microsoft Azure Fundamentals	2025-08-14	FAIL	28.00	42.50	1651.42	ELEARN
1064	GDPR-001	RGPD & Protection des Données	2017-07-21	COMP	2.00	72.91	188.73	COMPLIANCE
1064	HEALTH-001	Santé & Sécurité au Travail	2017-07-21	COMP	4.00	87.12	233.93	COMPLIANCE
1064	FIRE-001	Sécurité & Évacuation Incendie	2017-07-24	COMP	1.00	93.01	109.69	COMPLIANCE
1064	DEI-001	Égalité Femmes-Hommes	2017-08-08	COMP	3.00	86.50	174.67	COMPLIANCE
1064	FRAUD-001	Prévention Fraude & Corruption	2017-07-27	COMP	2.00	82.55	152.98	COMPLIANCE
1064	ETHICS-001	Code de Déontologie Novaryn Tech	2017-08-03	COMP	1.50	93.11	123.13	COMPLIANCE
1064	ML-001	Machine Learning Fundamentals	2021-06-24	COMP	40.00	76.16	1723.28	ELEARN
1064	EXCEL-001	Excel Avancé & Reporting	2024-09-10	COMP	8.00	96.98	358.84	ELEARN
1064	COMM-001	Communication & Public Speaking	2026-05-29	ENR	8.00	0.00	374.61	OJT
1064	REACT-001	React & TypeScript Masterclass	2021-05-01	COMP	36.00	73.36	1187.05	ELEARN
1065	GDPR-001	RGPD & Protection des Données	2013-12-14	COMP	2.00	90.50	183.93	COMPLIANCE
1065	HEALTH-001	Santé & Sécurité au Travail	2014-01-09	COMP	4.00	89.59	273.71	COMPLIANCE
1065	FIRE-001	Sécurité & Évacuation Incendie	2013-12-29	COMP	1.00	75.67	90.58	COMPLIANCE
1065	DEI-001	Égalité Femmes-Hommes	2013-12-17	COMP	3.00	74.16	184.32	COMPLIANCE
1065	FRAUD-001	Prévention Fraude & Corruption	2013-12-08	COMP	2.00	87.99	156.96	COMPLIANCE
1065	ETHICS-001	Code de Déontologie Novaryn Tech	2013-12-04	COMP	1.50	79.75	114.00	COMPLIANCE
1065	SAFE-001	SAFe Agile Practitioner	2020-01-09	COMP	16.00	94.54	1547.13	COURSE
1065	LEAD-001	Leadership & Management	2023-06-23	COMP	20.00	74.76	1668.59	COURSE
1065	SQL-001	Advanced SQL for Analytics	2023-10-31	COMP	16.00	97.49	901.13	ELEARN
1065	SCRUM-001	Scrum Fundamentals	2025-11-11	COMP	12.00	71.72	671.00	ELEARN
1065	REACT-001	React & TypeScript Masterclass	2025-01-18	COMP	36.00	78.45	1108.22	ELEARN
1066	GDPR-001	RGPD & Protection des Données	2016-03-12	COMP	2.00	83.31	189.68	COMPLIANCE
1066	HEALTH-001	Santé & Sécurité au Travail	2016-02-14	COMP	4.00	99.18	250.01	COMPLIANCE
1066	FIRE-001	Sécurité & Évacuation Incendie	2016-02-10	COMP	1.00	94.11	106.76	COMPLIANCE
1066	DEI-001	Égalité Femmes-Hommes	2016-02-13	COMP	3.00	77.35	187.99	COMPLIANCE
1066	FRAUD-001	Prévention Fraude & Corruption	2016-02-07	COMP	2.00	70.21	135.97	COMPLIANCE
1066	ETHICS-001	Code de Déontologie Novaryn Tech	2016-03-17	COMP	1.50	82.19	120.47	COMPLIANCE
1066	REACT-001	React & TypeScript Masterclass	2023-12-30	COMP	36.00	91.06	1252.95	ELEARN
1066	LEAD-001	Leadership & Management	2022-06-23	COMP	20.00	60.95	1491.36	COURSE
1066	EXCEL-001	Excel Avancé & Reporting	2026-05-15	ENR	8.00	0.00	437.40	ELEARN
1066	AZURE-001	Microsoft Azure Fundamentals	2026-04-13	ENR	28.00	0.00	1534.42	ELEARN
1066	ML-001	Machine Learning Fundamentals	2026-06-12	ENR	40.00	0.00	1662.05	ELEARN
1067	GDPR-001	RGPD & Protection des Données	2021-09-30	COMP	2.00	82.86	184.96	COMPLIANCE
1067	HEALTH-001	Santé & Sécurité au Travail	2021-09-11	COMP	4.00	95.41	262.90	COMPLIANCE
1067	FIRE-001	Sécurité & Évacuation Incendie	2021-10-09	COMP	1.00	92.61	92.24	COMPLIANCE
1067	DEI-001	Égalité Femmes-Hommes	2021-09-12	COMP	3.00	80.99	185.64	COMPLIANCE
1067	FRAUD-001	Prévention Fraude & Corruption	2021-09-11	COMP	2.00	97.39	158.87	COMPLIANCE
1067	ETHICS-001	Code de Déontologie Novaryn Tech	2021-09-15	COMP	1.50	77.94	115.92	COMPLIANCE
1067	K8S-001	Kubernetes Fundamentals	2024-11-26	COMP	24.00	69.79	1020.80	ELEARN
1067	COMM-001	Communication & Public Speaking	2023-02-06	COMP	8.00	77.79	434.48	OJT
1068	GDPR-001	RGPD & Protection des Données	2024-08-03	COMP	2.00	77.74	191.01	COMPLIANCE
1068	HEALTH-001	Santé & Sécurité au Travail	2024-06-22	COMP	4.00	92.84	232.40	COMPLIANCE
1068	FIRE-001	Sécurité & Évacuation Incendie	2024-07-08	COMP	1.00	70.78	107.60	COMPLIANCE
1068	DEI-001	Égalité Femmes-Hommes	2024-07-26	COMP	3.00	80.88	172.48	COMPLIANCE
1068	FRAUD-001	Prévention Fraude & Corruption	2024-08-04	COMP	2.00	74.75	154.02	COMPLIANCE
1068	ETHICS-001	Code de Déontologie Novaryn Tech	2024-07-20	COMP	1.50	91.39	124.16	COMPLIANCE
1068	COMM-001	Communication & Public Speaking	2025-08-29	COMP	8.00	71.69	386.11	OJT
1068	EXCEL-001	Excel Avancé & Reporting	2024-11-05	COMP	8.00	61.12	365.40	ELEARN
1068	PYTHON-001	Python for Data Science	2025-03-11	COMP	24.00	83.37	927.83	ELEARN
1069	GDPR-001	RGPD & Protection des Données	2025-01-31	COMP	2.00	85.26	214.81	COMPLIANCE
1069	HEALTH-001	Santé & Sécurité au Travail	2025-01-18	COMP	4.00	82.18	255.92	COMPLIANCE
1069	FIRE-001	Sécurité & Évacuation Incendie	2024-12-26	COMP	1.00	99.17	102.88	COMPLIANCE
1069	DEI-001	Égalité Femmes-Hommes	2025-01-22	COMP	3.00	95.58	173.31	COMPLIANCE
1069	FRAUD-001	Prévention Fraude & Corruption	2025-01-08	COMP	2.00	81.34	162.78	COMPLIANCE
1069	ETHICS-001	Code de Déontologie Novaryn Tech	2025-01-26	COMP	1.50	75.07	120.61	COMPLIANCE
1069	K8S-001	Kubernetes Fundamentals	2025-06-19	COMP	24.00	62.59	1009.19	ELEARN
1069	REACT-001	React & TypeScript Masterclass	2025-11-06	COMP	36.00	66.00	1239.11	ELEARN
1069	SCRUM-001	Scrum Fundamentals	2026-04-23	ENR	12.00	0.00	627.00	ELEARN
1070	GDPR-001	RGPD & Protection des Données	2014-03-21	COMP	2.00	84.96	202.78	COMPLIANCE
1070	HEALTH-001	Santé & Sécurité au Travail	2014-04-08	COMP	4.00	97.19	267.00	COMPLIANCE
1070	FIRE-001	Sécurité & Évacuation Incendie	2014-04-20	COMP	1.00	93.49	100.48	COMPLIANCE
1070	DEI-001	Égalité Femmes-Hommes	2014-03-13	COMP	3.00	92.24	175.09	COMPLIANCE
1070	FRAUD-001	Prévention Fraude & Corruption	2014-03-01	COMP	2.00	81.95	137.97	COMPLIANCE
1070	ETHICS-001	Code de Déontologie Novaryn Tech	2014-03-20	COMP	1.50	85.22	114.52	COMPLIANCE
1070	EXCEL-001	Excel Avancé & Reporting	2025-08-16	COMP	8.00	80.92	369.36	ELEARN
1070	SCRUM-001	Scrum Fundamentals	2026-05-01	ENR	12.00	0.00	634.15	ELEARN
1071	GDPR-001	RGPD & Protection des Données	2020-03-20	COMP	2.00	95.73	189.13	COMPLIANCE
1071	HEALTH-001	Santé & Sécurité au Travail	2020-03-24	COMP	4.00	83.68	227.01	COMPLIANCE
1071	FIRE-001	Sécurité & Évacuation Incendie	2020-03-17	COMP	1.00	77.97	95.55	COMPLIANCE
1071	DEI-001	Égalité Femmes-Hommes	2020-03-26	COMP	3.00	75.70	191.90	COMPLIANCE
1071	FRAUD-001	Prévention Fraude & Corruption	2020-02-12	COMP	2.00	97.18	138.98	COMPLIANCE
1071	ETHICS-001	Code de Déontologie Novaryn Tech	2020-02-27	COMP	1.50	71.83	113.46	COMPLIANCE
1071	K8S-001	Kubernetes Fundamentals	2026-04-17	ENR	24.00	0.00	999.82	ELEARN
1071	LEAD-001	Leadership & Management	2021-04-22	COMP	20.00	63.34	1363.83	COURSE
1071	ML-001	Machine Learning Fundamentals	2024-12-17	COMP	40.00	68.60	1593.87	ELEARN
1071	SCRUM-001	Scrum Fundamentals	2022-03-30	COMP	12.00	83.27	665.01	ELEARN
1071	SQL-001	Advanced SQL for Analytics	2025-11-03	COMP	16.00	95.46	866.58	ELEARN
1072	GDPR-001	RGPD & Protection des Données	2016-07-24	COMP	2.00	87.67	205.40	COMPLIANCE
1072	HEALTH-001	Santé & Sécurité au Travail	2016-08-29	COMP	4.00	83.69	225.02	COMPLIANCE
1072	FIRE-001	Sécurité & Évacuation Incendie	2016-08-29	COMP	1.00	82.22	95.41	COMPLIANCE
1072	DEI-001	Égalité Femmes-Hommes	2016-08-21	COMP	3.00	75.30	180.26	COMPLIANCE
1072	FRAUD-001	Prévention Fraude & Corruption	2016-08-13	COMP	2.00	78.51	154.36	COMPLIANCE
1072	ETHICS-001	Code de Déontologie Novaryn Tech	2016-07-28	COMP	1.50	96.02	113.98	COMPLIANCE
1072	SAFE-001	SAFe Agile Practitioner	2021-04-07	COMP	16.00	64.46	1507.78	COURSE
1072	ML-001	Machine Learning Fundamentals	2022-04-05	COMP	40.00	60.26	1788.82	ELEARN
1072	COMM-001	Communication & Public Speaking	2021-03-17	COMP	8.00	79.83	361.46	OJT
1072	AZURE-001	Microsoft Azure Fundamentals	2026-07-03	ENR	28.00	0.00	1506.23	ELEARN
1073	GDPR-001	RGPD & Protection des Données	2019-04-18	COMP	2.00	80.27	207.48	COMPLIANCE
1073	HEALTH-001	Santé & Sécurité au Travail	2019-05-12	COMP	4.00	75.48	263.94	COMPLIANCE
1073	FIRE-001	Sécurité & Évacuation Incendie	2019-05-08	COMP	1.00	76.95	96.14	COMPLIANCE
1073	DEI-001	Égalité Femmes-Hommes	2019-04-09	COMP	3.00	79.60	181.09	COMPLIANCE
1073	FRAUD-001	Prévention Fraude & Corruption	2019-03-27	COMP	2.00	90.54	162.83	COMPLIANCE
1073	ETHICS-001	Code de Déontologie Novaryn Tech	2019-04-03	COMP	1.50	87.13	111.71	COMPLIANCE
1073	AWS-001	AWS Cloud Practitioner	2026-06-25	ENR	30.00	0.00	1887.80	ELEARN
1073	REACT-001	React & TypeScript Masterclass	2021-05-30	COMP	36.00	80.66	1190.56	ELEARN
1073	PYTHON-001	Python for Data Science	2022-08-13	COMP	24.00	76.68	1067.94	ELEARN
1074	GDPR-001	RGPD & Protection des Données	2024-11-27	COMP	2.00	97.99	198.88	COMPLIANCE
1074	HEALTH-001	Santé & Sécurité au Travail	2025-01-05	COMP	4.00	79.11	232.25	COMPLIANCE
1074	FIRE-001	Sécurité & Évacuation Incendie	2024-12-04	COMP	1.00	91.80	106.58	COMPLIANCE
1074	DEI-001	Égalité Femmes-Hommes	2024-12-03	COMP	3.00	83.49	177.31	COMPLIANCE
1074	FRAUD-001	Prévention Fraude & Corruption	2024-12-08	COMP	2.00	92.88	135.17	COMPLIANCE
1074	ETHICS-001	Code de Déontologie Novaryn Tech	2024-12-08	COMP	1.50	71.66	117.81	COMPLIANCE
1074	K8S-001	Kubernetes Fundamentals	2026-05-03	ENR	24.00	0.00	1003.84	ELEARN
1074	AZURE-001	Microsoft Azure Fundamentals	2026-05-15	ENR	28.00	0.00	1759.62	ELEARN
1074	SCRUM-001	Scrum Fundamentals	2025-12-21	COMP	12.00	77.10	578.83	ELEARN
1075	GDPR-001	RGPD & Protection des Données	2017-06-01	COMP	2.00	86.80	187.98	COMPLIANCE
1075	HEALTH-001	Santé & Sécurité au Travail	2017-05-10	COMP	4.00	88.53	247.01	COMPLIANCE
1075	FIRE-001	Sécurité & Évacuation Incendie	2017-05-14	COMP	1.00	73.21	94.86	COMPLIANCE
1075	DEI-001	Égalité Femmes-Hommes	2017-05-17	COMP	3.00	91.69	195.89	COMPLIANCE
1075	FRAUD-001	Prévention Fraude & Corruption	2017-06-03	COMP	2.00	84.10	164.13	COMPLIANCE
1075	ETHICS-001	Code de Déontologie Novaryn Tech	2017-04-29	COMP	1.50	93.44	117.36	COMPLIANCE
1075	AWS-001	AWS Cloud Practitioner	2024-11-03	COMP	30.00	62.24	1715.05	ELEARN
1075	AZURE-001	Microsoft Azure Fundamentals	2022-06-15	COMP	28.00	77.52	1496.43	ELEARN
1075	PM-001	Product Management Essentials	2023-09-26	COMP	20.00	95.23	1046.64	COURSE
1075	SAFE-001	SAFe Agile Practitioner	2021-01-21	FAIL	16.00	53.92	1536.21	COURSE
1075	REACT-001	React & TypeScript Masterclass	2026-06-22	ENR	36.00	0.00	1127.59	ELEARN
1076	GDPR-001	RGPD & Protection des Données	2023-02-09	COMP	2.00	86.86	197.53	COMPLIANCE
1076	HEALTH-001	Santé & Sécurité au Travail	2023-02-17	COMP	4.00	87.18	263.14	COMPLIANCE
1076	FIRE-001	Sécurité & Évacuation Incendie	2023-02-13	COMP	1.00	86.70	106.35	COMPLIANCE
1076	DEI-001	Égalité Femmes-Hommes	2023-03-13	COMP	3.00	70.66	189.80	COMPLIANCE
1076	FRAUD-001	Prévention Fraude & Corruption	2023-02-01	COMP	2.00	96.12	155.98	COMPLIANCE
1076	ETHICS-001	Code de Déontologie Novaryn Tech	2023-03-16	COMP	1.50	79.42	128.48	COMPLIANCE
1076	COMM-001	Communication & Public Speaking	2024-08-05	COMP	8.00	74.49	363.88	OJT
1076	AWS-001	AWS Cloud Practitioner	2025-01-05	FAIL	30.00	44.92	1855.95	ELEARN
1076	PYTHON-001	Python for Data Science	2024-06-16	FAIL	24.00	42.67	1042.67	ELEARN
1076	SQL-001	Advanced SQL for Analytics	2025-06-06	COMP	16.00	92.24	871.54	ELEARN
1076	K8S-001	Kubernetes Fundamentals	2026-04-15	ENR	24.00	0.00	1236.28	ELEARN
1077	GDPR-001	RGPD & Protection des Données	2020-11-29	COMP	2.00	81.20	202.63	COMPLIANCE
1077	HEALTH-001	Santé & Sécurité au Travail	2020-10-30	COMP	4.00	98.79	268.65	COMPLIANCE
1077	FIRE-001	Sécurité & Évacuation Incendie	2020-11-17	COMP	1.00	93.70	99.84	COMPLIANCE
1077	DEI-001	Égalité Femmes-Hommes	2020-12-03	COMP	3.00	80.01	164.42	COMPLIANCE
1077	FRAUD-001	Prévention Fraude & Corruption	2020-11-01	COMP	2.00	86.96	164.23	COMPLIANCE
1077	ETHICS-001	Code de Déontologie Novaryn Tech	2020-12-16	COMP	1.50	73.37	111.80	COMPLIANCE
1077	PM-001	Product Management Essentials	2025-04-02	COMP	20.00	99.72	1290.69	COURSE
1077	K8S-001	Kubernetes Fundamentals	2026-06-02	ENR	24.00	0.00	1204.86	ELEARN
1078	GDPR-001	RGPD & Protection des Données	2016-04-25	COMP	2.00	83.54	215.22	COMPLIANCE
1078	HEALTH-001	Santé & Sécurité au Travail	2016-05-13	COMP	4.00	74.57	241.52	COMPLIANCE
1078	FIRE-001	Sécurité & Évacuation Incendie	2016-04-07	COMP	1.00	89.44	96.80	COMPLIANCE
1078	DEI-001	Égalité Femmes-Hommes	2016-04-29	COMP	3.00	93.43	188.62	COMPLIANCE
1078	FRAUD-001	Prévention Fraude & Corruption	2016-04-23	COMP	2.00	96.68	147.04	COMPLIANCE
1078	ETHICS-001	Code de Déontologie Novaryn Tech	2016-04-14	COMP	1.50	70.19	127.88	COMPLIANCE
1078	SCRUM-001	Scrum Fundamentals	2020-09-06	COMP	12.00	66.02	664.00	ELEARN
1078	AWS-001	AWS Cloud Practitioner	2025-02-01	COMP	30.00	90.71	1817.48	ELEARN
1079	GDPR-001	RGPD & Protection des Données	2017-11-18	COMP	2.00	89.96	210.80	COMPLIANCE
1079	HEALTH-001	Santé & Sécurité au Travail	2017-11-13	COMP	4.00	97.76	269.66	COMPLIANCE
1079	FIRE-001	Sécurité & Évacuation Incendie	2017-11-22	COMP	1.00	96.02	93.05	COMPLIANCE
1079	DEI-001	Égalité Femmes-Hommes	2017-11-26	COMP	3.00	74.45	173.11	COMPLIANCE
1079	FRAUD-001	Prévention Fraude & Corruption	2017-10-14	COMP	2.00	70.79	153.06	COMPLIANCE
1079	ETHICS-001	Code de Déontologie Novaryn Tech	2017-10-10	COMP	1.50	93.38	120.96	COMPLIANCE
1079	SQL-001	Advanced SQL for Analytics	2020-05-03	FAIL	16.00	52.51	728.41	ELEARN
1079	EXCEL-001	Excel Avancé & Reporting	2023-09-04	COMP	8.00	99.64	367.96	ELEARN
1080	GDPR-001	RGPD & Protection des Données	2021-06-23	COMP	2.00	93.17	181.09	COMPLIANCE
1080	HEALTH-001	Santé & Sécurité au Travail	2021-07-08	COMP	4.00	73.69	272.40	COMPLIANCE
1080	FIRE-001	Sécurité & Évacuation Incendie	2021-06-11	COMP	1.00	83.32	104.88	COMPLIANCE
1080	DEI-001	Égalité Femmes-Hommes	2021-07-27	COMP	3.00	76.26	163.77	COMPLIANCE
1080	FRAUD-001	Prévention Fraude & Corruption	2021-07-08	COMP	2.00	81.98	141.17	COMPLIANCE
1080	ETHICS-001	Code de Déontologie Novaryn Tech	2021-07-04	COMP	1.50	87.71	110.99	COMPLIANCE
1080	ML-001	Machine Learning Fundamentals	2024-05-29	COMP	40.00	90.26	1417.77	ELEARN
1080	PM-001	Product Management Essentials	2023-10-18	COMP	20.00	84.19	1289.89	COURSE
1080	EXCEL-001	Excel Avancé & Reporting	2021-11-20	COMP	8.00	67.64	458.22	ELEARN
1081	GDPR-001	RGPD & Protection des Données	2015-11-27	COMP	2.00	85.21	199.12	COMPLIANCE
1081	HEALTH-001	Santé & Sécurité au Travail	2015-11-08	COMP	4.00	73.36	247.85	COMPLIANCE
1081	FIRE-001	Sécurité & Évacuation Incendie	2015-10-07	COMP	1.00	81.40	98.40	COMPLIANCE
1081	DEI-001	Égalité Femmes-Hommes	2015-10-13	COMP	3.00	80.64	196.05	COMPLIANCE
1081	FRAUD-001	Prévention Fraude & Corruption	2015-11-29	COMP	2.00	71.96	163.38	COMPLIANCE
1081	ETHICS-001	Code de Déontologie Novaryn Tech	2015-11-17	COMP	1.50	79.02	131.99	COMPLIANCE
1081	SAFE-001	SAFe Agile Practitioner	2026-06-07	ENR	16.00	0.00	1196.66	COURSE
1081	EXCEL-001	Excel Avancé & Reporting	2021-12-12	FAIL	8.00	53.86	447.68	ELEARN
1082	GDPR-001	RGPD & Protection des Données	2024-01-25	COMP	2.00	74.22	189.96	COMPLIANCE
1082	HEALTH-001	Santé & Sécurité au Travail	2024-02-28	COMP	4.00	70.28	250.93	COMPLIANCE
1082	FIRE-001	Sécurité & Évacuation Incendie	2024-01-31	COMP	1.00	90.85	105.25	COMPLIANCE
1082	DEI-001	Égalité Femmes-Hommes	2024-01-26	COMP	3.00	87.89	169.55	COMPLIANCE
1082	FRAUD-001	Prévention Fraude & Corruption	2024-03-10	COMP	2.00	89.83	146.15	COMPLIANCE
1082	ETHICS-001	Code de Déontologie Novaryn Tech	2024-02-18	COMP	1.50	94.70	118.06	COMPLIANCE
1082	ML-001	Machine Learning Fundamentals	2025-09-20	COMP	40.00	95.16	1412.51	ELEARN
1082	PYTHON-001	Python for Data Science	2025-07-05	COMP	24.00	79.90	941.82	ELEARN
1082	SAFE-001	SAFe Agile Practitioner	2025-07-15	COMP	16.00	96.36	1301.38	COURSE
1083	GDPR-001	RGPD & Protection des Données	2013-03-21	COMP	2.00	70.85	181.03	COMPLIANCE
1083	HEALTH-001	Santé & Sécurité au Travail	2013-03-02	COMP	4.00	96.66	226.71	COMPLIANCE
1083	FIRE-001	Sécurité & Évacuation Incendie	2013-03-10	COMP	1.00	97.41	90.93	COMPLIANCE
1083	DEI-001	Égalité Femmes-Hommes	2013-03-25	COMP	3.00	92.88	188.01	COMPLIANCE
1083	FRAUD-001	Prévention Fraude & Corruption	2013-03-11	COMP	2.00	74.75	135.45	COMPLIANCE
1083	ETHICS-001	Code de Déontologie Novaryn Tech	2013-03-15	COMP	1.50	72.76	131.72	COMPLIANCE
1083	K8S-001	Kubernetes Fundamentals	2020-03-05	FAIL	24.00	56.27	1112.12	ELEARN
1083	EXCEL-001	Excel Avancé & Reporting	2025-09-19	COMP	8.00	84.13	416.42	ELEARN
1084	GDPR-001	RGPD & Protection des Données	2013-04-11	COMP	2.00	84.29	215.98	COMPLIANCE
1084	HEALTH-001	Santé & Sécurité au Travail	2013-04-08	COMP	4.00	73.85	257.82	COMPLIANCE
1084	FIRE-001	Sécurité & Évacuation Incendie	2013-04-15	COMP	1.00	98.71	103.37	COMPLIANCE
1084	DEI-001	Égalité Femmes-Hommes	2013-03-29	COMP	3.00	84.33	188.95	COMPLIANCE
1084	FRAUD-001	Prévention Fraude & Corruption	2013-04-28	COMP	2.00	75.89	141.58	COMPLIANCE
1084	ETHICS-001	Code de Déontologie Novaryn Tech	2013-03-31	COMP	1.50	94.16	111.42	COMPLIANCE
1084	COMM-001	Communication & Public Speaking	2026-05-14	ENR	8.00	0.00	446.43	OJT
1084	LEAD-001	Leadership & Management	2024-11-25	COMP	20.00	69.05	1358.08	COURSE
1085	GDPR-001	RGPD & Protection des Données	2016-11-14	COMP	2.00	79.03	208.42	COMPLIANCE
1085	HEALTH-001	Santé & Sécurité au Travail	2016-11-01	COMP	4.00	90.05	251.00	COMPLIANCE
1085	FIRE-001	Sécurité & Évacuation Incendie	2016-11-08	COMP	1.00	99.63	95.33	COMPLIANCE
1085	DEI-001	Égalité Femmes-Hommes	2016-10-11	COMP	3.00	79.84	175.49	COMPLIANCE
1085	FRAUD-001	Prévention Fraude & Corruption	2016-10-12	COMP	2.00	87.38	163.04	COMPLIANCE
1085	ETHICS-001	Code de Déontologie Novaryn Tech	2016-10-05	COMP	1.50	92.44	127.19	COMPLIANCE
1085	EXCEL-001	Excel Avancé & Reporting	2020-05-04	FAIL	8.00	40.27	416.16	ELEARN
1085	AWS-001	AWS Cloud Practitioner	2026-05-08	ENR	30.00	0.00	1617.42	ELEARN
1086	GDPR-001	RGPD & Protection des Données	2021-03-31	COMP	2.00	70.35	199.23	COMPLIANCE
1086	HEALTH-001	Santé & Sécurité au Travail	2021-04-02	COMP	4.00	75.63	268.48	COMPLIANCE
1086	FIRE-001	Sécurité & Évacuation Incendie	2021-04-16	COMP	1.00	82.17	109.85	COMPLIANCE
1086	DEI-001	Égalité Femmes-Hommes	2021-04-09	COMP	3.00	88.64	181.65	COMPLIANCE
1086	FRAUD-001	Prévention Fraude & Corruption	2021-03-18	COMP	2.00	92.35	154.66	COMPLIANCE
1086	ETHICS-001	Code de Déontologie Novaryn Tech	2021-04-12	COMP	1.50	97.72	116.09	COMPLIANCE
1086	AZURE-001	Microsoft Azure Fundamentals	2026-06-05	ENR	28.00	0.00	1678.36	ELEARN
1086	SQL-001	Advanced SQL for Analytics	2025-10-31	COMP	16.00	73.70	804.58	ELEARN
1086	K8S-001	Kubernetes Fundamentals	2025-03-06	COMP	24.00	74.62	1146.96	ELEARN
1087	GDPR-001	RGPD & Protection des Données	2021-10-29	COMP	2.00	73.79	189.09	COMPLIANCE
1087	HEALTH-001	Santé & Sécurité au Travail	2021-10-24	COMP	4.00	94.90	231.01	COMPLIANCE
1087	FIRE-001	Sécurité & Évacuation Incendie	2021-11-09	COMP	1.00	78.87	107.47	COMPLIANCE
1087	DEI-001	Égalité Femmes-Hommes	2021-10-14	COMP	3.00	83.58	181.92	COMPLIANCE
1087	FRAUD-001	Prévention Fraude & Corruption	2021-09-30	COMP	2.00	98.99	164.15	COMPLIANCE
1087	ETHICS-001	Code de Déontologie Novaryn Tech	2021-10-06	COMP	1.50	81.93	130.59	COMPLIANCE
1087	PYTHON-001	Python for Data Science	2026-05-03	ENR	24.00	0.00	1070.02	ELEARN
1087	SAFE-001	SAFe Agile Practitioner	2023-02-22	COMP	16.00	84.04	1253.74	COURSE
1087	AWS-001	AWS Cloud Practitioner	2026-06-14	ENR	30.00	0.00	1555.38	ELEARN
1090	GDPR-001	RGPD & Protection des Données	2023-04-28	COMP	2.00	80.88	189.22	COMPLIANCE
1090	HEALTH-001	Santé & Sécurité au Travail	2023-04-27	COMP	4.00	75.00	232.94	COMPLIANCE
1090	FIRE-001	Sécurité & Évacuation Incendie	2023-05-07	COMP	1.00	74.97	102.69	COMPLIANCE
1090	DEI-001	Égalité Femmes-Hommes	2023-05-03	COMP	3.00	76.79	195.50	COMPLIANCE
1090	FRAUD-001	Prévention Fraude & Corruption	2023-05-09	COMP	2.00	74.56	163.27	COMPLIANCE
1090	ETHICS-001	Code de Déontologie Novaryn Tech	2023-05-03	COMP	1.50	82.72	112.85	COMPLIANCE
1090	REACT-001	React & TypeScript Masterclass	2025-12-11	COMP	36.00	80.87	1171.66	ELEARN
1090	AZURE-001	Microsoft Azure Fundamentals	2025-04-23	COMP	28.00	72.88	1706.34	ELEARN
1091	GDPR-001	RGPD & Protection des Données	2019-04-12	COMP	2.00	70.01	190.05	COMPLIANCE
1091	HEALTH-001	Santé & Sécurité au Travail	2019-04-28	COMP	4.00	90.04	235.44	COMPLIANCE
1091	FIRE-001	Sécurité & Évacuation Incendie	2019-05-09	COMP	1.00	88.39	109.19	COMPLIANCE
1091	DEI-001	Égalité Femmes-Hommes	2019-03-27	COMP	3.00	92.66	167.05	COMPLIANCE
1091	FRAUD-001	Prévention Fraude & Corruption	2019-04-23	COMP	2.00	94.67	157.94	COMPLIANCE
1091	ETHICS-001	Code de Déontologie Novaryn Tech	2019-05-14	COMP	1.50	99.29	131.48	COMPLIANCE
1091	EXCEL-001	Excel Avancé & Reporting	2025-05-26	COMP	8.00	69.94	382.05	ELEARN
1091	PYTHON-001	Python for Data Science	2024-03-07	COMP	24.00	97.96	892.13	ELEARN
1091	SAFE-001	SAFe Agile Practitioner	2020-10-10	COMP	16.00	89.04	1436.09	COURSE
1091	REACT-001	React & TypeScript Masterclass	2023-12-31	COMP	36.00	68.23	1071.27	ELEARN
1091	PM-001	Product Management Essentials	2022-12-17	COMP	20.00	73.10	1249.23	COURSE
1092	GDPR-001	RGPD & Protection des Données	2024-07-06	COMP	2.00	79.33	184.10	COMPLIANCE
1092	HEALTH-001	Santé & Sécurité au Travail	2024-07-13	COMP	4.00	87.95	236.61	COMPLIANCE
1092	FIRE-001	Sécurité & Évacuation Incendie	2024-07-01	COMP	1.00	78.96	92.50	COMPLIANCE
1092	DEI-001	Égalité Femmes-Hommes	2024-07-20	COMP	3.00	88.30	167.53	COMPLIANCE
1092	FRAUD-001	Prévention Fraude & Corruption	2024-07-21	COMP	2.00	97.32	145.24	COMPLIANCE
1092	ETHICS-001	Code de Déontologie Novaryn Tech	2024-06-20	COMP	1.50	98.48	108.98	COMPLIANCE
1092	LEAD-001	Leadership & Management	2025-07-08	COMP	20.00	95.05	1586.15	COURSE
1092	SAFE-001	SAFe Agile Practitioner	2026-05-15	ENR	16.00	0.00	1284.35	COURSE
1092	K8S-001	Kubernetes Fundamentals	2025-05-01	COMP	24.00	99.90	1134.09	ELEARN
1092	REACT-001	React & TypeScript Masterclass	2024-11-14	COMP	36.00	74.50	1332.97	ELEARN
1093	GDPR-001	RGPD & Protection des Données	2023-04-02	COMP	2.00	84.84	208.06	COMPLIANCE
1093	HEALTH-001	Santé & Sécurité au Travail	2023-03-18	COMP	4.00	82.65	256.90	COMPLIANCE
1093	FIRE-001	Sécurité & Évacuation Incendie	2023-04-09	COMP	1.00	78.41	104.48	COMPLIANCE
1093	DEI-001	Égalité Femmes-Hommes	2023-03-08	COMP	3.00	97.14	185.05	COMPLIANCE
1093	FRAUD-001	Prévention Fraude & Corruption	2023-03-12	COMP	2.00	82.59	160.09	COMPLIANCE
1093	ETHICS-001	Code de Déontologie Novaryn Tech	2023-03-13	COMP	1.50	72.49	110.43	COMPLIANCE
1093	AWS-001	AWS Cloud Practitioner	2024-01-17	COMP	30.00	64.16	1951.70	ELEARN
1093	PM-001	Product Management Essentials	2026-06-18	ENR	20.00	0.00	1238.39	COURSE
1093	K8S-001	Kubernetes Fundamentals	2025-02-10	COMP	24.00	84.27	1222.23	ELEARN
1093	EXCEL-001	Excel Avancé & Reporting	2025-06-20	COMP	8.00	61.68	352.94	ELEARN
1093	REACT-001	React & TypeScript Masterclass	2026-06-29	ENR	36.00	0.00	1363.47	ELEARN
1094	GDPR-001	RGPD & Protection des Données	2013-02-23	COMP	2.00	72.85	218.67	COMPLIANCE
1094	HEALTH-001	Santé & Sécurité au Travail	2013-02-02	COMP	4.00	80.82	258.63	COMPLIANCE
1094	FIRE-001	Sécurité & Évacuation Incendie	2013-02-25	COMP	1.00	82.65	97.87	COMPLIANCE
1094	DEI-001	Égalité Femmes-Hommes	2013-03-06	COMP	3.00	71.20	185.30	COMPLIANCE
1094	FRAUD-001	Prévention Fraude & Corruption	2013-02-15	COMP	2.00	95.57	152.20	COMPLIANCE
1094	ETHICS-001	Code de Déontologie Novaryn Tech	2013-02-20	COMP	1.50	71.12	117.57	COMPLIANCE
1094	SAFE-001	SAFe Agile Practitioner	2025-08-20	COMP	16.00	97.84	1231.50	COURSE
1094	SCRUM-001	Scrum Fundamentals	2023-05-29	FAIL	12.00	55.24	641.23	ELEARN
1094	AWS-001	AWS Cloud Practitioner	2026-05-10	ENR	30.00	0.00	1723.64	ELEARN
1094	PM-001	Product Management Essentials	2020-04-24	COMP	20.00	74.10	1367.61	COURSE
1094	PYTHON-001	Python for Data Science	2023-11-14	COMP	24.00	91.35	947.35	ELEARN
1095	GDPR-001	RGPD & Protection des Données	2017-11-29	COMP	2.00	99.73	190.53	COMPLIANCE
1095	HEALTH-001	Santé & Sécurité au Travail	2017-12-05	COMP	4.00	74.82	252.92	COMPLIANCE
1095	FIRE-001	Sécurité & Évacuation Incendie	2017-11-20	COMP	1.00	89.45	104.81	COMPLIANCE
1095	DEI-001	Égalité Femmes-Hommes	2017-12-03	COMP	3.00	80.46	191.36	COMPLIANCE
1095	FRAUD-001	Prévention Fraude & Corruption	2017-11-16	COMP	2.00	95.70	145.01	COMPLIANCE
1095	ETHICS-001	Code de Déontologie Novaryn Tech	2017-11-24	COMP	1.50	86.15	127.32	COMPLIANCE
1095	SQL-001	Advanced SQL for Analytics	2020-09-30	FAIL	16.00	41.72	777.46	ELEARN
1095	AZURE-001	Microsoft Azure Fundamentals	2022-09-04	COMP	28.00	85.58	1723.15	ELEARN
1095	LEAD-001	Leadership & Management	2022-02-23	COMP	20.00	94.24	1493.45	COURSE
1096	GDPR-001	RGPD & Protection des Données	2015-05-03	COMP	2.00	94.18	215.83	COMPLIANCE
1096	HEALTH-001	Santé & Sécurité au Travail	2015-05-30	COMP	4.00	74.78	233.43	COMPLIANCE
1096	FIRE-001	Sécurité & Évacuation Incendie	2015-04-13	COMP	1.00	73.34	101.64	COMPLIANCE
1096	DEI-001	Égalité Femmes-Hommes	2015-05-14	COMP	3.00	91.01	182.18	COMPLIANCE
1096	FRAUD-001	Prévention Fraude & Corruption	2015-05-30	COMP	2.00	86.80	140.34	COMPLIANCE
1096	ETHICS-001	Code de Déontologie Novaryn Tech	2015-05-21	COMP	1.50	90.87	112.77	COMPLIANCE
1096	COMM-001	Communication & Public Speaking	2022-10-01	FAIL	8.00	52.60	442.27	OJT
1096	PM-001	Product Management Essentials	2020-12-26	COMP	20.00	73.61	1147.37	COURSE
1097	GDPR-001	RGPD & Protection des Données	2019-09-03	COMP	2.00	97.64	184.15	COMPLIANCE
1097	HEALTH-001	Santé & Sécurité au Travail	2019-10-12	COMP	4.00	94.44	269.37	COMPLIANCE
1097	FIRE-001	Sécurité & Évacuation Incendie	2019-09-13	COMP	1.00	88.40	109.41	COMPLIANCE
1097	DEI-001	Égalité Femmes-Hommes	2019-09-15	COMP	3.00	99.98	177.93	COMPLIANCE
1097	FRAUD-001	Prévention Fraude & Corruption	2019-08-28	COMP	2.00	77.38	139.65	COMPLIANCE
1097	ETHICS-001	Code de Déontologie Novaryn Tech	2019-09-12	COMP	1.50	70.79	113.39	COMPLIANCE
1097	AWS-001	AWS Cloud Practitioner	2023-06-09	COMP	30.00	68.64	1536.71	ELEARN
1097	EXCEL-001	Excel Avancé & Reporting	2024-05-17	COMP	8.00	60.83	413.47	ELEARN
1097	K8S-001	Kubernetes Fundamentals	2026-05-31	ENR	24.00	0.00	1118.59	ELEARN
1098	GDPR-001	RGPD & Protection des Données	2015-03-29	COMP	2.00	75.77	187.44	COMPLIANCE
1098	HEALTH-001	Santé & Sécurité au Travail	2015-03-26	COMP	4.00	87.43	256.36	COMPLIANCE
1098	FIRE-001	Sécurité & Évacuation Incendie	2015-03-17	COMP	1.00	92.40	104.13	COMPLIANCE
1098	DEI-001	Égalité Femmes-Hommes	2015-03-16	COMP	3.00	94.10	171.49	COMPLIANCE
1098	FRAUD-001	Prévention Fraude & Corruption	2015-03-16	COMP	2.00	80.94	162.77	COMPLIANCE
1098	ETHICS-001	Code de Déontologie Novaryn Tech	2015-03-08	COMP	1.50	79.60	116.57	COMPLIANCE
1098	SQL-001	Advanced SQL for Analytics	2026-06-21	ENR	16.00	0.00	710.90	ELEARN
1098	COMM-001	Communication & Public Speaking	2024-08-12	FAIL	8.00	54.90	400.89	OJT
1098	AWS-001	AWS Cloud Practitioner	2023-12-06	COMP	30.00	72.54	1965.92	ELEARN
1099	GDPR-001	RGPD & Protection des Données	2016-05-16	COMP	2.00	76.83	193.93	COMPLIANCE
1099	HEALTH-001	Santé & Sécurité au Travail	2016-05-22	COMP	4.00	89.35	252.70	COMPLIANCE
1099	FIRE-001	Sécurité & Évacuation Incendie	2016-04-22	COMP	1.00	83.96	101.49	COMPLIANCE
1099	DEI-001	Égalité Femmes-Hommes	2016-04-11	COMP	3.00	83.81	177.76	COMPLIANCE
1099	FRAUD-001	Prévention Fraude & Corruption	2016-05-15	COMP	2.00	83.09	163.59	COMPLIANCE
1099	ETHICS-001	Code de Déontologie Novaryn Tech	2016-04-18	COMP	1.50	70.66	118.76	COMPLIANCE
1099	SQL-001	Advanced SQL for Analytics	2026-04-26	ENR	16.00	0.00	695.31	ELEARN
1099	K8S-001	Kubernetes Fundamentals	2020-06-17	COMP	24.00	98.19	1026.11	ELEARN
1100	GDPR-001	RGPD & Protection des Données	2025-10-22	COMP	2.00	98.42	209.11	COMPLIANCE
1100	HEALTH-001	Santé & Sécurité au Travail	2025-11-20	COMP	4.00	87.93	246.54	COMPLIANCE
1100	FIRE-001	Sécurité & Évacuation Incendie	2025-11-23	COMP	1.00	98.28	109.72	COMPLIANCE
1100	DEI-001	Égalité Femmes-Hommes	2025-10-19	COMP	3.00	89.85	173.15	COMPLIANCE
1100	FRAUD-001	Prévention Fraude & Corruption	2025-11-19	COMP	2.00	90.24	144.92	COMPLIANCE
1100	ETHICS-001	Code de Déontologie Novaryn Tech	2025-11-11	COMP	1.50	93.95	120.19	COMPLIANCE
1100	PYTHON-001	Python for Data Science	2026-06-25	ENR	24.00	0.00	865.89	ELEARN
1100	ML-001	Machine Learning Fundamentals	2026-06-22	ENR	40.00	0.00	1417.45	ELEARN
1100	SAFE-001	SAFe Agile Practitioner	2025-12-29	FAIL	16.00	51.66	1412.50	COURSE
1100	PM-001	Product Management Essentials	2026-05-02	ENR	20.00	0.00	1109.57	COURSE
1100	SQL-001	Advanced SQL for Analytics	2025-12-30	COMP	16.00	90.35	723.04	ELEARN
1101	GDPR-001	RGPD & Protection des Données	2012-11-28	COMP	2.00	70.88	217.15	COMPLIANCE
1101	HEALTH-001	Santé & Sécurité au Travail	2013-01-02	COMP	4.00	73.59	229.46	COMPLIANCE
1101	FIRE-001	Sécurité & Évacuation Incendie	2012-12-12	COMP	1.00	87.22	108.98	COMPLIANCE
1101	DEI-001	Égalité Femmes-Hommes	2012-12-11	COMP	3.00	94.15	175.73	COMPLIANCE
1101	FRAUD-001	Prévention Fraude & Corruption	2012-12-17	COMP	2.00	74.16	145.30	COMPLIANCE
1101	ETHICS-001	Code de Déontologie Novaryn Tech	2012-11-23	COMP	1.50	79.34	112.26	COMPLIANCE
1101	AZURE-001	Microsoft Azure Fundamentals	2024-03-28	COMP	28.00	69.07	1833.11	ELEARN
1101	K8S-001	Kubernetes Fundamentals	2025-04-27	COMP	24.00	73.59	1183.10	ELEARN
1101	LEAD-001	Leadership & Management	2023-10-05	COMP	20.00	60.82	1547.77	COURSE
1101	PYTHON-001	Python for Data Science	2020-06-09	FAIL	24.00	41.12	961.94	ELEARN
1101	EXCEL-001	Excel Avancé & Reporting	2021-09-24	COMP	8.00	98.54	403.49	ELEARN
1102	GDPR-001	RGPD & Protection des Données	2012-04-08	COMP	2.00	79.81	192.25	COMPLIANCE
1102	HEALTH-001	Santé & Sécurité au Travail	2012-05-29	COMP	4.00	97.15	253.17	COMPLIANCE
1102	FIRE-001	Sécurité & Évacuation Incendie	2012-04-12	COMP	1.00	98.67	93.77	COMPLIANCE
1102	DEI-001	Égalité Femmes-Hommes	2012-05-17	COMP	3.00	84.95	181.27	COMPLIANCE
1102	FRAUD-001	Prévention Fraude & Corruption	2012-04-30	COMP	2.00	72.91	155.50	COMPLIANCE
1102	ETHICS-001	Code de Déontologie Novaryn Tech	2012-04-17	COMP	1.50	87.99	121.78	COMPLIANCE
1102	COMM-001	Communication & Public Speaking	2022-04-09	COMP	8.00	61.55	404.51	OJT
1102	PYTHON-001	Python for Data Science	2024-09-02	FAIL	24.00	57.87	1092.16	ELEARN
1102	ML-001	Machine Learning Fundamentals	2021-02-11	COMP	40.00	71.66	1527.55	ELEARN
1102	EXCEL-001	Excel Avancé & Reporting	2022-06-13	COMP	8.00	80.74	448.03	ELEARN
1102	K8S-001	Kubernetes Fundamentals	2023-09-23	COMP	24.00	84.14	1264.12	ELEARN
1103	GDPR-001	RGPD & Protection des Données	2016-02-05	COMP	2.00	98.13	217.14	COMPLIANCE
1103	HEALTH-001	Santé & Sécurité au Travail	2016-02-19	COMP	4.00	94.95	264.20	COMPLIANCE
1103	FIRE-001	Sécurité & Évacuation Incendie	2016-01-22	COMP	1.00	90.06	91.31	COMPLIANCE
1103	DEI-001	Égalité Femmes-Hommes	2016-01-30	COMP	3.00	80.97	170.62	COMPLIANCE
1103	FRAUD-001	Prévention Fraude & Corruption	2016-03-07	COMP	2.00	84.72	158.82	COMPLIANCE
1103	ETHICS-001	Code de Déontologie Novaryn Tech	2016-01-17	COMP	1.50	80.75	130.00	COMPLIANCE
1103	EXCEL-001	Excel Avancé & Reporting	2025-12-09	COMP	8.00	86.19	449.42	ELEARN
1103	SAFE-001	SAFe Agile Practitioner	2024-02-14	COMP	16.00	88.09	1409.10	COURSE
1103	PM-001	Product Management Essentials	2026-06-29	ENR	20.00	0.00	1092.34	COURSE
1103	LEAD-001	Leadership & Management	2020-03-30	COMP	20.00	77.92	1364.12	COURSE
1103	ML-001	Machine Learning Fundamentals	2025-05-11	FAIL	40.00	48.10	1568.87	ELEARN
1104	GDPR-001	RGPD & Protection des Données	2020-04-17	COMP	2.00	84.71	199.65	COMPLIANCE
1104	HEALTH-001	Santé & Sécurité au Travail	2020-05-02	COMP	4.00	86.84	255.48	COMPLIANCE
1104	FIRE-001	Sécurité & Évacuation Incendie	2020-05-01	COMP	1.00	84.93	105.73	COMPLIANCE
1104	DEI-001	Égalité Femmes-Hommes	2020-04-30	COMP	3.00	93.13	187.16	COMPLIANCE
1104	FRAUD-001	Prévention Fraude & Corruption	2020-05-15	COMP	2.00	94.94	140.64	COMPLIANCE
1104	ETHICS-001	Code de Déontologie Novaryn Tech	2020-04-17	COMP	1.50	79.21	122.10	COMPLIANCE
1104	SAFE-001	SAFe Agile Practitioner	2025-09-07	COMP	16.00	61.89	1317.24	COURSE
1104	SQL-001	Advanced SQL for Analytics	2022-07-17	COMP	16.00	98.57	692.58	ELEARN
1104	SCRUM-001	Scrum Fundamentals	2026-06-02	ENR	12.00	0.00	642.94	ELEARN
1105	GDPR-001	RGPD & Protection des Données	2018-12-06	COMP	2.00	95.48	200.35	COMPLIANCE
1105	HEALTH-001	Santé & Sécurité au Travail	2018-12-16	COMP	4.00	90.98	270.53	COMPLIANCE
1105	FIRE-001	Sécurité & Évacuation Incendie	2018-11-09	COMP	1.00	83.72	93.71	COMPLIANCE
1105	DEI-001	Égalité Femmes-Hommes	2018-11-17	COMP	3.00	91.37	164.63	COMPLIANCE
1105	FRAUD-001	Prévention Fraude & Corruption	2018-11-16	COMP	2.00	84.86	152.13	COMPLIANCE
1105	ETHICS-001	Code de Déontologie Novaryn Tech	2018-12-12	COMP	1.50	70.47	130.13	COMPLIANCE
1105	COMM-001	Communication & Public Speaking	2022-08-23	COMP	8.00	69.62	437.64	OJT
1105	LEAD-001	Leadership & Management	2026-04-30	ENR	20.00	0.00	1719.19	COURSE
1105	AZURE-001	Microsoft Azure Fundamentals	2026-05-25	ENR	28.00	0.00	1800.44	ELEARN
1106	GDPR-001	RGPD & Protection des Données	2018-07-14	COMP	2.00	71.34	185.67	COMPLIANCE
1106	HEALTH-001	Santé & Sécurité au Travail	2018-07-04	COMP	4.00	88.65	237.91	COMPLIANCE
1106	FIRE-001	Sécurité & Évacuation Incendie	2018-07-16	COMP	1.00	90.41	104.20	COMPLIANCE
1106	DEI-001	Égalité Femmes-Hommes	2018-07-29	COMP	3.00	79.29	195.85	COMPLIANCE
1106	FRAUD-001	Prévention Fraude & Corruption	2018-07-30	COMP	2.00	92.10	143.18	COMPLIANCE
1106	ETHICS-001	Code de Déontologie Novaryn Tech	2018-08-02	COMP	1.50	70.31	127.77	COMPLIANCE
1106	AZURE-001	Microsoft Azure Fundamentals	2024-09-11	COMP	28.00	75.82	1694.08	ELEARN
1106	AWS-001	AWS Cloud Practitioner	2023-06-21	COMP	30.00	86.52	1650.41	ELEARN
1106	K8S-001	Kubernetes Fundamentals	2020-10-16	COMP	24.00	64.61	1232.73	ELEARN
1106	EXCEL-001	Excel Avancé & Reporting	2021-11-29	COMP	8.00	67.33	379.29	ELEARN
1106	SCRUM-001	Scrum Fundamentals	2020-12-18	FAIL	12.00	44.87	632.56	ELEARN
1107	GDPR-001	RGPD & Protection des Données	2016-08-25	COMP	2.00	81.95	201.45	COMPLIANCE
1107	HEALTH-001	Santé & Sécurité au Travail	2016-07-30	COMP	4.00	95.67	238.07	COMPLIANCE
1107	FIRE-001	Sécurité & Évacuation Incendie	2016-08-29	COMP	1.00	73.58	106.46	COMPLIANCE
1107	DEI-001	Égalité Femmes-Hommes	2016-07-24	COMP	3.00	98.51	181.97	COMPLIANCE
1107	FRAUD-001	Prévention Fraude & Corruption	2016-08-12	COMP	2.00	76.02	150.55	COMPLIANCE
1107	ETHICS-001	Code de Déontologie Novaryn Tech	2016-07-14	COMP	1.50	84.07	110.62	COMPLIANCE
1107	SCRUM-001	Scrum Fundamentals	2023-12-04	COMP	12.00	87.74	522.13	ELEARN
1107	REACT-001	React & TypeScript Masterclass	2020-12-30	COMP	36.00	74.84	1285.80	ELEARN
1107	PYTHON-001	Python for Data Science	2025-07-05	COMP	24.00	90.77	1048.86	ELEARN
1108	GDPR-001	RGPD & Protection des Données	2019-04-21	COMP	2.00	93.00	187.56	COMPLIANCE
1108	HEALTH-001	Santé & Sécurité au Travail	2019-04-02	COMP	4.00	91.75	227.19	COMPLIANCE
1108	FIRE-001	Sécurité & Évacuation Incendie	2019-03-20	COMP	1.00	98.46	96.83	COMPLIANCE
1108	DEI-001	Égalité Femmes-Hommes	2019-04-05	COMP	3.00	97.66	174.60	COMPLIANCE
1108	FRAUD-001	Prévention Fraude & Corruption	2019-04-01	COMP	2.00	97.05	136.69	COMPLIANCE
1108	ETHICS-001	Code de Déontologie Novaryn Tech	2019-04-13	COMP	1.50	74.59	115.00	COMPLIANCE
1108	AWS-001	AWS Cloud Practitioner	2021-04-23	COMP	30.00	73.44	1919.44	ELEARN
1108	PYTHON-001	Python for Data Science	2024-03-28	COMP	24.00	77.62	1103.03	ELEARN
1110	GDPR-001	RGPD & Protection des Données	2015-05-09	COMP	2.00	85.86	202.27	COMPLIANCE
1110	HEALTH-001	Santé & Sécurité au Travail	2015-04-10	COMP	4.00	86.41	240.88	COMPLIANCE
1110	FIRE-001	Sécurité & Évacuation Incendie	2015-04-08	COMP	1.00	90.54	98.20	COMPLIANCE
1110	DEI-001	Égalité Femmes-Hommes	2015-05-05	COMP	3.00	70.52	187.94	COMPLIANCE
1110	FRAUD-001	Prévention Fraude & Corruption	2015-05-17	COMP	2.00	97.98	146.11	COMPLIANCE
1110	ETHICS-001	Code de Déontologie Novaryn Tech	2015-04-10	COMP	1.50	97.05	124.42	COMPLIANCE
1110	REACT-001	React & TypeScript Masterclass	2022-06-25	COMP	36.00	92.55	1296.73	ELEARN
1110	SCRUM-001	Scrum Fundamentals	2024-04-30	COMP	12.00	68.98	623.09	ELEARN
1111	GDPR-001	RGPD & Protection des Données	2013-02-10	COMP	2.00	86.37	180.79	COMPLIANCE
1111	HEALTH-001	Santé & Sécurité au Travail	2013-02-26	COMP	4.00	97.32	271.86	COMPLIANCE
1111	FIRE-001	Sécurité & Évacuation Incendie	2013-02-15	COMP	1.00	81.58	103.71	COMPLIANCE
1111	DEI-001	Égalité Femmes-Hommes	2013-01-29	COMP	3.00	83.49	188.93	COMPLIANCE
1111	FRAUD-001	Prévention Fraude & Corruption	2013-02-17	COMP	2.00	84.72	142.50	COMPLIANCE
1111	ETHICS-001	Code de Déontologie Novaryn Tech	2013-02-14	COMP	1.50	83.65	130.07	COMPLIANCE
1111	K8S-001	Kubernetes Fundamentals	2022-04-29	COMP	24.00	71.47	1176.22	ELEARN
1111	ML-001	Machine Learning Fundamentals	2023-07-14	FAIL	40.00	47.38	1483.46	ELEARN
1111	SQL-001	Advanced SQL for Analytics	2024-02-08	COMP	16.00	89.60	783.62	ELEARN
1112	GDPR-001	RGPD & Protection des Données	2017-05-28	COMP	2.00	74.32	198.40	COMPLIANCE
1112	HEALTH-001	Santé & Sécurité au Travail	2017-06-23	COMP	4.00	96.39	267.58	COMPLIANCE
1112	FIRE-001	Sécurité & Évacuation Incendie	2017-06-03	COMP	1.00	73.75	102.53	COMPLIANCE
1112	DEI-001	Égalité Femmes-Hommes	2017-05-22	COMP	3.00	98.26	177.16	COMPLIANCE
1112	FRAUD-001	Prévention Fraude & Corruption	2017-06-04	COMP	2.00	83.82	148.57	COMPLIANCE
1112	ETHICS-001	Code de Déontologie Novaryn Tech	2017-06-02	COMP	1.50	83.91	116.11	COMPLIANCE
1112	PYTHON-001	Python for Data Science	2024-01-07	COMP	24.00	67.64	908.38	ELEARN
1112	COMM-001	Communication & Public Speaking	2026-07-01	ENR	8.00	0.00	434.10	OJT
1112	ML-001	Machine Learning Fundamentals	2023-11-20	COMP	40.00	78.54	1773.97	ELEARN
1112	AWS-001	AWS Cloud Practitioner	2026-05-25	ENR	30.00	0.00	1877.76	ELEARN
1112	PM-001	Product Management Essentials	2021-03-25	COMP	20.00	65.65	1059.11	COURSE
1114	GDPR-001	RGPD & Protection des Données	2021-03-02	COMP	2.00	83.57	216.19	COMPLIANCE
1114	HEALTH-001	Santé & Sécurité au Travail	2021-03-10	COMP	4.00	96.10	245.61	COMPLIANCE
1114	FIRE-001	Sécurité & Évacuation Incendie	2021-02-01	COMP	1.00	76.52	101.03	COMPLIANCE
1114	DEI-001	Égalité Femmes-Hommes	2021-01-30	COMP	3.00	89.79	195.74	COMPLIANCE
1114	FRAUD-001	Prévention Fraude & Corruption	2021-02-16	COMP	2.00	75.41	148.29	COMPLIANCE
1114	ETHICS-001	Code de Déontologie Novaryn Tech	2021-03-05	COMP	1.50	76.19	121.62	COMPLIANCE
1114	AZURE-001	Microsoft Azure Fundamentals	2024-07-17	COMP	28.00	66.23	1552.90	ELEARN
1114	COMM-001	Communication & Public Speaking	2026-05-03	ENR	8.00	0.00	358.08	OJT
1114	SAFE-001	SAFe Agile Practitioner	2025-08-09	COMP	16.00	69.83	1500.16	COURSE
1115	GDPR-001	RGPD & Protection des Données	2020-10-15	COMP	2.00	97.94	192.65	COMPLIANCE
1115	HEALTH-001	Santé & Sécurité au Travail	2020-10-15	COMP	4.00	88.37	261.77	COMPLIANCE
1115	FIRE-001	Sécurité & Évacuation Incendie	2020-08-30	COMP	1.00	90.29	105.74	COMPLIANCE
1115	DEI-001	Égalité Femmes-Hommes	2020-09-02	COMP	3.00	70.64	195.13	COMPLIANCE
1115	FRAUD-001	Prévention Fraude & Corruption	2020-08-31	COMP	2.00	79.95	137.70	COMPLIANCE
1115	ETHICS-001	Code de Déontologie Novaryn Tech	2020-09-19	COMP	1.50	76.09	111.61	COMPLIANCE
1115	AZURE-001	Microsoft Azure Fundamentals	2022-01-17	COMP	28.00	72.62	1794.17	ELEARN
1115	LEAD-001	Leadership & Management	2021-06-23	COMP	20.00	73.54	1353.85	COURSE
1115	SQL-001	Advanced SQL for Analytics	2023-03-27	COMP	16.00	92.09	718.35	ELEARN
1116	GDPR-001	RGPD & Protection des Données	2013-03-17	COMP	2.00	74.90	184.74	COMPLIANCE
1116	HEALTH-001	Santé & Sécurité au Travail	2013-04-16	COMP	4.00	82.29	253.08	COMPLIANCE
1116	FIRE-001	Sécurité & Évacuation Incendie	2013-04-17	COMP	1.00	84.09	109.67	COMPLIANCE
1116	DEI-001	Égalité Femmes-Hommes	2013-04-21	COMP	3.00	95.44	170.98	COMPLIANCE
1116	FRAUD-001	Prévention Fraude & Corruption	2013-03-15	COMP	2.00	89.92	139.40	COMPLIANCE
1116	ETHICS-001	Code de Déontologie Novaryn Tech	2013-04-05	COMP	1.50	72.91	108.95	COMPLIANCE
1116	K8S-001	Kubernetes Fundamentals	2023-07-13	COMP	24.00	99.51	1054.59	ELEARN
1116	REACT-001	React & TypeScript Masterclass	2022-11-21	COMP	36.00	82.88	1181.04	ELEARN
1116	EXCEL-001	Excel Avancé & Reporting	2024-04-26	COMP	8.00	79.67	420.61	ELEARN
1116	PYTHON-001	Python for Data Science	2022-04-10	COMP	24.00	73.59	875.50	ELEARN
1116	SCRUM-001	Scrum Fundamentals	2020-01-08	COMP	12.00	67.09	622.33	ELEARN
1117	GDPR-001	RGPD & Protection des Données	2023-08-16	COMP	2.00	81.81	185.98	COMPLIANCE
1117	HEALTH-001	Santé & Sécurité au Travail	2023-08-23	COMP	4.00	98.81	234.86	COMPLIANCE
1117	FIRE-001	Sécurité & Évacuation Incendie	2023-08-13	COMP	1.00	79.62	104.23	COMPLIANCE
1117	DEI-001	Égalité Femmes-Hommes	2023-08-23	COMP	3.00	72.49	183.70	COMPLIANCE
1117	FRAUD-001	Prévention Fraude & Corruption	2023-08-24	COMP	2.00	84.84	153.66	COMPLIANCE
1117	ETHICS-001	Code de Déontologie Novaryn Tech	2023-08-10	COMP	1.50	82.53	112.06	COMPLIANCE
1117	AWS-001	AWS Cloud Practitioner	2024-12-07	FAIL	30.00	40.45	1702.03	ELEARN
1117	ML-001	Machine Learning Fundamentals	2024-12-31	COMP	40.00	85.98	1696.25	ELEARN
1117	AZURE-001	Microsoft Azure Fundamentals	2025-10-24	COMP	28.00	99.85	1522.01	ELEARN
1117	COMM-001	Communication & Public Speaking	2024-05-12	COMP	8.00	99.80	418.80	OJT
1118	GDPR-001	RGPD & Protection des Données	2014-03-04	COMP	2.00	72.41	202.05	COMPLIANCE
1118	HEALTH-001	Santé & Sécurité au Travail	2014-01-29	COMP	4.00	96.16	271.33	COMPLIANCE
1118	FIRE-001	Sécurité & Évacuation Incendie	2014-01-21	COMP	1.00	92.04	90.38	COMPLIANCE
1118	DEI-001	Égalité Femmes-Hommes	2014-02-14	COMP	3.00	75.99	178.92	COMPLIANCE
1118	FRAUD-001	Prévention Fraude & Corruption	2014-02-14	COMP	2.00	71.08	155.16	COMPLIANCE
1118	ETHICS-001	Code de Déontologie Novaryn Tech	2014-03-06	COMP	1.50	81.25	116.80	COMPLIANCE
1118	REACT-001	React & TypeScript Masterclass	2026-06-17	ENR	36.00	0.00	1089.45	ELEARN
1118	COMM-001	Communication & Public Speaking	2024-07-31	COMP	8.00	63.33	393.98	OJT
1118	SQL-001	Advanced SQL for Analytics	2024-02-13	COMP	16.00	92.22	899.20	ELEARN
1118	PYTHON-001	Python for Data Science	2026-04-22	ENR	24.00	0.00	856.90	ELEARN
1118	SAFE-001	SAFe Agile Practitioner	2022-10-29	COMP	16.00	90.48	1292.04	COURSE
1119	GDPR-001	RGPD & Protection des Données	2021-11-24	COMP	2.00	81.20	186.16	COMPLIANCE
1119	HEALTH-001	Santé & Sécurité au Travail	2022-01-03	COMP	4.00	77.11	229.37	COMPLIANCE
1119	FIRE-001	Sécurité & Évacuation Incendie	2021-11-17	COMP	1.00	70.29	90.27	COMPLIANCE
1119	DEI-001	Égalité Femmes-Hommes	2022-01-03	COMP	3.00	80.23	194.72	COMPLIANCE
1119	FRAUD-001	Prévention Fraude & Corruption	2021-11-17	COMP	2.00	74.69	153.78	COMPLIANCE
1119	ETHICS-001	Code de Déontologie Novaryn Tech	2021-12-12	COMP	1.50	88.93	115.94	COMPLIANCE
1119	PM-001	Product Management Essentials	2024-06-10	COMP	20.00	65.55	1350.48	COURSE
1119	LEAD-001	Leadership & Management	2025-05-04	FAIL	20.00	43.53	1598.21	COURSE
1120	GDPR-001	RGPD & Protection des Données	2013-06-05	COMP	2.00	70.12	211.66	COMPLIANCE
1120	HEALTH-001	Santé & Sécurité au Travail	2013-06-14	COMP	4.00	76.31	260.85	COMPLIANCE
1120	FIRE-001	Sécurité & Évacuation Incendie	2013-06-24	COMP	1.00	79.61	100.59	COMPLIANCE
1120	DEI-001	Égalité Femmes-Hommes	2013-06-30	COMP	3.00	94.53	187.50	COMPLIANCE
1120	FRAUD-001	Prévention Fraude & Corruption	2013-07-01	COMP	2.00	88.16	140.58	COMPLIANCE
1120	ETHICS-001	Code de Déontologie Novaryn Tech	2013-06-18	COMP	1.50	91.95	122.20	COMPLIANCE
1120	K8S-001	Kubernetes Fundamentals	2024-08-15	COMP	24.00	63.18	1256.48	ELEARN
1120	PYTHON-001	Python for Data Science	2023-03-17	COMP	24.00	95.13	1022.63	ELEARN
1121	GDPR-001	RGPD & Protection des Données	2021-12-24	COMP	2.00	91.00	208.11	COMPLIANCE
1121	HEALTH-001	Santé & Sécurité au Travail	2021-12-16	COMP	4.00	75.65	267.43	COMPLIANCE
1121	FIRE-001	Sécurité & Évacuation Incendie	2022-01-29	COMP	1.00	99.76	93.25	COMPLIANCE
1121	DEI-001	Égalité Femmes-Hommes	2022-01-21	COMP	3.00	95.08	172.68	COMPLIANCE
1121	FRAUD-001	Prévention Fraude & Corruption	2022-01-07	COMP	2.00	85.20	143.56	COMPLIANCE
1121	ETHICS-001	Code de Déontologie Novaryn Tech	2022-01-08	COMP	1.50	77.53	116.27	COMPLIANCE
1121	ML-001	Machine Learning Fundamentals	2024-02-10	FAIL	40.00	52.99	1495.10	ELEARN
1121	SCRUM-001	Scrum Fundamentals	2023-07-17	COMP	12.00	62.46	598.91	ELEARN
1121	SAFE-001	SAFe Agile Practitioner	2025-11-14	FAIL	16.00	41.15	1507.37	COURSE
1122	GDPR-001	RGPD & Protection des Données	2017-06-22	COMP	2.00	72.40	210.58	COMPLIANCE
1122	HEALTH-001	Santé & Sécurité au Travail	2017-07-10	COMP	4.00	83.38	273.86	COMPLIANCE
1122	FIRE-001	Sécurité & Évacuation Incendie	2017-07-08	COMP	1.00	72.65	101.76	COMPLIANCE
1122	DEI-001	Égalité Femmes-Hommes	2017-06-18	COMP	3.00	90.94	183.80	COMPLIANCE
1122	FRAUD-001	Prévention Fraude & Corruption	2017-05-30	COMP	2.00	87.08	156.81	COMPLIANCE
1122	ETHICS-001	Code de Déontologie Novaryn Tech	2017-06-15	COMP	1.50	83.52	125.81	COMPLIANCE
1122	SQL-001	Advanced SQL for Analytics	2021-08-09	COMP	16.00	89.80	734.75	ELEARN
1122	K8S-001	Kubernetes Fundamentals	2025-12-07	COMP	24.00	87.63	1070.21	ELEARN
1122	AZURE-001	Microsoft Azure Fundamentals	2026-05-19	ENR	28.00	0.00	1803.25	ELEARN
1122	COMM-001	Communication & Public Speaking	2026-05-29	ENR	8.00	0.00	395.63	OJT
1122	EXCEL-001	Excel Avancé & Reporting	2023-04-04	FAIL	8.00	48.59	357.05	ELEARN
1123	GDPR-001	RGPD & Protection des Données	2023-07-18	COMP	2.00	81.57	217.99	COMPLIANCE
1123	HEALTH-001	Santé & Sécurité au Travail	2023-06-08	COMP	4.00	93.65	244.07	COMPLIANCE
1123	FIRE-001	Sécurité & Évacuation Incendie	2023-07-10	COMP	1.00	74.48	97.31	COMPLIANCE
1123	DEI-001	Égalité Femmes-Hommes	2023-06-27	COMP	3.00	93.74	185.82	COMPLIANCE
1123	FRAUD-001	Prévention Fraude & Corruption	2023-06-11	COMP	2.00	74.53	163.38	COMPLIANCE
1123	ETHICS-001	Code de Déontologie Novaryn Tech	2023-06-13	COMP	1.50	72.85	117.39	COMPLIANCE
1123	AZURE-001	Microsoft Azure Fundamentals	2024-08-18	COMP	28.00	75.69	1505.69	ELEARN
1123	SQL-001	Advanced SQL for Analytics	2025-05-21	FAIL	16.00	50.44	734.66	ELEARN
1123	AWS-001	AWS Cloud Practitioner	2023-10-28	COMP	30.00	88.95	1763.74	ELEARN
1124	GDPR-001	RGPD & Protection des Données	2016-07-25	COMP	2.00	84.62	206.63	COMPLIANCE
1124	HEALTH-001	Santé & Sécurité au Travail	2016-08-06	COMP	4.00	98.84	228.35	COMPLIANCE
1124	FIRE-001	Sécurité & Évacuation Incendie	2016-08-04	COMP	1.00	91.18	102.16	COMPLIANCE
1124	DEI-001	Égalité Femmes-Hommes	2016-07-24	COMP	3.00	77.05	195.96	COMPLIANCE
1124	FRAUD-001	Prévention Fraude & Corruption	2016-09-04	COMP	2.00	76.49	149.72	COMPLIANCE
1124	ETHICS-001	Code de Déontologie Novaryn Tech	2016-08-03	COMP	1.50	88.95	116.13	COMPLIANCE
1124	SAFE-001	SAFe Agile Practitioner	2022-09-15	COMP	16.00	65.18	1308.40	COURSE
1124	PM-001	Product Management Essentials	2026-07-05	ENR	20.00	0.00	1331.08	COURSE
1124	REACT-001	React & TypeScript Masterclass	2023-03-30	COMP	36.00	98.82	1042.72	ELEARN
1124	COMM-001	Communication & Public Speaking	2023-04-14	COMP	8.00	76.68	365.13	OJT
1125	GDPR-001	RGPD & Protection des Données	2023-07-02	COMP	2.00	90.65	216.41	COMPLIANCE
1125	HEALTH-001	Santé & Sécurité au Travail	2023-07-02	COMP	4.00	89.02	270.09	COMPLIANCE
1125	FIRE-001	Sécurité & Évacuation Incendie	2023-07-12	COMP	1.00	93.60	101.10	COMPLIANCE
1125	DEI-001	Égalité Femmes-Hommes	2023-07-18	COMP	3.00	93.81	187.14	COMPLIANCE
1125	FRAUD-001	Prévention Fraude & Corruption	2023-06-20	COMP	2.00	98.96	158.45	COMPLIANCE
1125	ETHICS-001	Code de Déontologie Novaryn Tech	2023-07-18	COMP	1.50	99.13	113.49	COMPLIANCE
1125	AWS-001	AWS Cloud Practitioner	2024-04-26	COMP	30.00	60.78	1805.92	ELEARN
1125	K8S-001	Kubernetes Fundamentals	2025-10-11	COMP	24.00	90.01	1140.79	ELEARN
1125	PM-001	Product Management Essentials	2023-10-30	COMP	20.00	79.64	1236.94	COURSE
1126	GDPR-001	RGPD & Protection des Données	2019-12-04	COMP	2.00	77.98	197.98	COMPLIANCE
1126	HEALTH-001	Santé & Sécurité au Travail	2019-12-07	COMP	4.00	75.80	263.50	COMPLIANCE
1126	FIRE-001	Sécurité & Évacuation Incendie	2019-12-03	COMP	1.00	74.29	106.96	COMPLIANCE
1126	DEI-001	Égalité Femmes-Hommes	2019-10-22	COMP	3.00	84.21	170.04	COMPLIANCE
1126	FRAUD-001	Prévention Fraude & Corruption	2019-10-19	COMP	2.00	79.82	159.75	COMPLIANCE
1126	ETHICS-001	Code de Déontologie Novaryn Tech	2019-11-18	COMP	1.50	86.86	126.81	COMPLIANCE
1126	K8S-001	Kubernetes Fundamentals	2021-02-05	COMP	24.00	92.43	997.10	ELEARN
1126	SQL-001	Advanced SQL for Analytics	2024-04-18	FAIL	16.00	51.50	750.95	ELEARN
1126	PM-001	Product Management Essentials	2025-01-16	COMP	20.00	95.39	1208.46	COURSE
1126	ML-001	Machine Learning Fundamentals	2022-11-06	COMP	40.00	69.93	1540.48	ELEARN
1127	GDPR-001	RGPD & Protection des Données	2013-05-16	COMP	2.00	94.56	180.44	COMPLIANCE
1127	HEALTH-001	Santé & Sécurité au Travail	2013-04-18	COMP	4.00	76.13	239.81	COMPLIANCE
1127	FIRE-001	Sécurité & Évacuation Incendie	2013-04-03	COMP	1.00	89.55	105.25	COMPLIANCE
1127	DEI-001	Égalité Femmes-Hommes	2013-04-07	COMP	3.00	81.06	189.93	COMPLIANCE
1127	FRAUD-001	Prévention Fraude & Corruption	2013-04-11	COMP	2.00	83.40	146.46	COMPLIANCE
1127	ETHICS-001	Code de Déontologie Novaryn Tech	2013-04-12	COMP	1.50	87.82	126.20	COMPLIANCE
1127	AZURE-001	Microsoft Azure Fundamentals	2020-11-07	COMP	28.00	88.25	1577.60	ELEARN
1127	K8S-001	Kubernetes Fundamentals	2023-09-29	COMP	24.00	65.14	1250.51	ELEARN
1128	GDPR-001	RGPD & Protection des Données	2022-08-09	COMP	2.00	71.57	193.06	COMPLIANCE
1128	HEALTH-001	Santé & Sécurité au Travail	2022-09-01	COMP	4.00	81.06	240.76	COMPLIANCE
1128	FIRE-001	Sécurité & Évacuation Incendie	2022-09-17	COMP	1.00	81.25	90.51	COMPLIANCE
1128	DEI-001	Égalité Femmes-Hommes	2022-08-29	COMP	3.00	89.39	176.24	COMPLIANCE
1128	FRAUD-001	Prévention Fraude & Corruption	2022-08-22	COMP	2.00	88.39	157.82	COMPLIANCE
1128	ETHICS-001	Code de Déontologie Novaryn Tech	2022-09-12	COMP	1.50	78.49	121.57	COMPLIANCE
1128	ML-001	Machine Learning Fundamentals	2026-04-24	ENR	40.00	0.00	1598.40	ELEARN
1128	SCRUM-001	Scrum Fundamentals	2025-01-18	FAIL	12.00	42.66	528.41	ELEARN
1129	GDPR-001	RGPD & Protection des Données	2013-04-17	COMP	2.00	98.20	189.40	COMPLIANCE
1129	HEALTH-001	Santé & Sécurité au Travail	2013-05-25	COMP	4.00	80.81	242.85	COMPLIANCE
1129	FIRE-001	Sécurité & Évacuation Incendie	2013-04-12	COMP	1.00	82.38	105.02	COMPLIANCE
1129	DEI-001	Égalité Femmes-Hommes	2013-05-08	COMP	3.00	82.02	164.24	COMPLIANCE
1129	FRAUD-001	Prévention Fraude & Corruption	2013-05-03	COMP	2.00	89.25	146.88	COMPLIANCE
1129	ETHICS-001	Code de Déontologie Novaryn Tech	2013-04-16	COMP	1.50	86.44	110.15	COMPLIANCE
1129	K8S-001	Kubernetes Fundamentals	2026-05-11	ENR	24.00	0.00	1010.04	ELEARN
1129	PYTHON-001	Python for Data Science	2020-02-17	COMP	24.00	87.34	857.27	ELEARN
1129	LEAD-001	Leadership & Management	2021-03-23	COMP	20.00	87.89	1490.41	COURSE
1130	GDPR-001	RGPD & Protection des Données	2020-08-18	COMP	2.00	76.57	189.31	COMPLIANCE
1130	HEALTH-001	Santé & Sécurité au Travail	2020-08-25	COMP	4.00	98.63	231.88	COMPLIANCE
1130	FIRE-001	Sécurité & Évacuation Incendie	2020-09-05	COMP	1.00	79.69	105.12	COMPLIANCE
1130	DEI-001	Égalité Femmes-Hommes	2020-09-27	COMP	3.00	81.87	180.37	COMPLIANCE
1130	FRAUD-001	Prévention Fraude & Corruption	2020-09-03	COMP	2.00	84.77	155.09	COMPLIANCE
1130	ETHICS-001	Code de Déontologie Novaryn Tech	2020-09-29	COMP	1.50	82.45	109.63	COMPLIANCE
1130	PM-001	Product Management Essentials	2024-05-03	COMP	20.00	79.66	1145.78	COURSE
1130	SCRUM-001	Scrum Fundamentals	2022-03-01	COMP	12.00	95.27	601.65	ELEARN
1130	AWS-001	AWS Cloud Practitioner	2026-05-28	ENR	30.00	0.00	1644.90	ELEARN
1131	GDPR-001	RGPD & Protection des Données	2018-01-18	COMP	2.00	70.22	205.11	COMPLIANCE
1131	HEALTH-001	Santé & Sécurité au Travail	2018-01-23	COMP	4.00	78.44	252.81	COMPLIANCE
1131	FIRE-001	Sécurité & Évacuation Incendie	2018-01-16	COMP	1.00	81.65	106.70	COMPLIANCE
1131	DEI-001	Égalité Femmes-Hommes	2018-02-01	COMP	3.00	88.23	174.04	COMPLIANCE
1131	FRAUD-001	Prévention Fraude & Corruption	2018-01-04	COMP	2.00	96.94	146.78	COMPLIANCE
1131	ETHICS-001	Code de Déontologie Novaryn Tech	2018-01-25	COMP	1.50	78.56	108.69	COMPLIANCE
1131	AWS-001	AWS Cloud Practitioner	2026-05-04	ENR	30.00	0.00	1638.08	ELEARN
1131	PYTHON-001	Python for Data Science	2022-04-03	COMP	24.00	89.89	1099.88	ELEARN
1131	LEAD-001	Leadership & Management	2022-11-17	COMP	20.00	95.47	1643.04	COURSE
1131	SCRUM-001	Scrum Fundamentals	2025-04-20	COMP	12.00	62.17	622.70	ELEARN
1131	REACT-001	React & TypeScript Masterclass	2025-11-22	COMP	36.00	95.38	1110.84	ELEARN
1132	GDPR-001	RGPD & Protection des Données	2018-05-24	COMP	2.00	70.71	180.49	COMPLIANCE
1132	HEALTH-001	Santé & Sécurité au Travail	2018-06-14	COMP	4.00	75.43	241.70	COMPLIANCE
1132	FIRE-001	Sécurité & Évacuation Incendie	2018-05-23	COMP	1.00	98.40	97.77	COMPLIANCE
1132	DEI-001	Égalité Femmes-Hommes	2018-05-12	COMP	3.00	83.74	176.07	COMPLIANCE
1132	FRAUD-001	Prévention Fraude & Corruption	2018-06-09	COMP	2.00	74.96	149.75	COMPLIANCE
1132	ETHICS-001	Code de Déontologie Novaryn Tech	2018-05-27	COMP	1.50	87.90	127.08	COMPLIANCE
1132	LEAD-001	Leadership & Management	2023-05-19	FAIL	20.00	56.20	1553.67	COURSE
1132	PM-001	Product Management Essentials	2026-05-13	ENR	20.00	0.00	1354.86	COURSE
1132	EXCEL-001	Excel Avancé & Reporting	2020-09-06	COMP	8.00	75.26	408.17	ELEARN
1133	GDPR-001	RGPD & Protection des Données	2019-07-02	COMP	2.00	72.92	194.72	COMPLIANCE
1133	HEALTH-001	Santé & Sécurité au Travail	2019-08-02	COMP	4.00	75.72	246.16	COMPLIANCE
1133	FIRE-001	Sécurité & Évacuation Incendie	2019-07-15	COMP	1.00	72.28	98.35	COMPLIANCE
1133	DEI-001	Égalité Femmes-Hommes	2019-06-23	COMP	3.00	78.92	163.26	COMPLIANCE
1133	FRAUD-001	Prévention Fraude & Corruption	2019-06-29	COMP	2.00	79.06	142.88	COMPLIANCE
1133	ETHICS-001	Code de Déontologie Novaryn Tech	2019-08-12	COMP	1.50	97.44	110.89	COMPLIANCE
1133	K8S-001	Kubernetes Fundamentals	2022-10-17	COMP	24.00	63.44	1012.48	ELEARN
1133	PYTHON-001	Python for Data Science	2026-06-21	ENR	24.00	0.00	1058.48	ELEARN
1134	GDPR-001	RGPD & Protection des Données	2025-10-18	COMP	2.00	78.10	208.12	COMPLIANCE
1134	HEALTH-001	Santé & Sécurité au Travail	2025-10-31	COMP	4.00	71.90	259.59	COMPLIANCE
1134	FIRE-001	Sécurité & Évacuation Incendie	2025-10-14	COMP	1.00	71.95	103.56	COMPLIANCE
1134	DEI-001	Égalité Femmes-Hommes	2025-10-02	COMP	3.00	71.11	177.57	COMPLIANCE
1134	FRAUD-001	Prévention Fraude & Corruption	2025-10-30	COMP	2.00	82.37	164.19	COMPLIANCE
1134	ETHICS-001	Code de Déontologie Novaryn Tech	2025-11-06	COMP	1.50	96.92	123.76	COMPLIANCE
1134	COMM-001	Communication & Public Speaking	2026-04-11	ENR	8.00	0.00	420.55	OJT
1134	AZURE-001	Microsoft Azure Fundamentals	2025-12-27	FAIL	28.00	43.57	1691.04	ELEARN
1134	K8S-001	Kubernetes Fundamentals	2026-06-30	ENR	24.00	0.00	949.56	ELEARN
1134	AWS-001	AWS Cloud Practitioner	2025-12-30	COMP	30.00	94.28	1831.83	ELEARN
1135	GDPR-001	RGPD & Protection des Données	2012-04-09	COMP	2.00	84.66	189.26	COMPLIANCE
1135	HEALTH-001	Santé & Sécurité au Travail	2012-04-12	COMP	4.00	71.42	243.20	COMPLIANCE
1135	FIRE-001	Sécurité & Évacuation Incendie	2012-04-03	COMP	1.00	81.02	106.41	COMPLIANCE
1135	DEI-001	Égalité Femmes-Hommes	2012-03-30	COMP	3.00	74.92	185.71	COMPLIANCE
1135	FRAUD-001	Prévention Fraude & Corruption	2012-03-19	COMP	2.00	91.79	151.22	COMPLIANCE
1135	ETHICS-001	Code de Déontologie Novaryn Tech	2012-03-16	COMP	1.50	92.06	116.32	COMPLIANCE
1135	PM-001	Product Management Essentials	2024-02-25	COMP	20.00	73.90	1125.28	COURSE
1135	REACT-001	React & TypeScript Masterclass	2026-06-10	ENR	36.00	0.00	1263.26	ELEARN
1135	SQL-001	Advanced SQL for Analytics	2020-04-21	COMP	16.00	98.46	700.75	ELEARN
1136	GDPR-001	RGPD & Protection des Données	2017-02-26	COMP	2.00	96.54	193.31	COMPLIANCE
1136	HEALTH-001	Santé & Sécurité au Travail	2017-03-04	COMP	4.00	89.36	247.54	COMPLIANCE
1136	FIRE-001	Sécurité & Évacuation Incendie	2017-03-16	COMP	1.00	95.85	93.29	COMPLIANCE
1136	DEI-001	Égalité Femmes-Hommes	2017-02-12	COMP	3.00	80.30	195.06	COMPLIANCE
1136	FRAUD-001	Prévention Fraude & Corruption	2017-03-22	COMP	2.00	74.35	145.25	COMPLIANCE
1136	ETHICS-001	Code de Déontologie Novaryn Tech	2017-03-22	COMP	1.50	94.96	111.83	COMPLIANCE
1136	EXCEL-001	Excel Avancé & Reporting	2025-04-02	COMP	8.00	76.76	353.43	ELEARN
1136	AWS-001	AWS Cloud Practitioner	2020-07-31	COMP	30.00	61.68	1586.06	ELEARN
1136	REACT-001	React & TypeScript Masterclass	2021-12-30	COMP	36.00	97.38	1259.27	ELEARN
1137	GDPR-001	RGPD & Protection des Données	2014-05-01	COMP	2.00	92.19	207.36	COMPLIANCE
1137	HEALTH-001	Santé & Sécurité au Travail	2014-06-10	COMP	4.00	80.05	230.85	COMPLIANCE
1137	FIRE-001	Sécurité & Évacuation Incendie	2014-06-06	COMP	1.00	95.09	97.47	COMPLIANCE
1137	DEI-001	Égalité Femmes-Hommes	2014-05-16	COMP	3.00	85.69	191.50	COMPLIANCE
1137	FRAUD-001	Prévention Fraude & Corruption	2014-05-05	COMP	2.00	87.31	157.49	COMPLIANCE
1137	ETHICS-001	Code de Déontologie Novaryn Tech	2014-06-04	COMP	1.50	92.55	110.55	COMPLIANCE
1137	PYTHON-001	Python for Data Science	2026-06-10	ENR	24.00	0.00	893.31	ELEARN
1137	COMM-001	Communication & Public Speaking	2025-10-27	COMP	8.00	98.00	369.02	OJT
1137	AWS-001	AWS Cloud Practitioner	2022-06-11	COMP	30.00	93.01	1822.66	ELEARN
1137	SCRUM-001	Scrum Fundamentals	2021-12-07	COMP	12.00	92.58	514.23	ELEARN
1137	ML-001	Machine Learning Fundamentals	2020-10-07	COMP	40.00	64.84	1449.14	ELEARN
1138	GDPR-001	RGPD & Protection des Données	2013-12-22	COMP	2.00	90.41	182.68	COMPLIANCE
1138	HEALTH-001	Santé & Sécurité au Travail	2013-12-01	COMP	4.00	98.53	246.10	COMPLIANCE
1138	FIRE-001	Sécurité & Évacuation Incendie	2013-11-25	COMP	1.00	89.85	90.21	COMPLIANCE
1138	DEI-001	Égalité Femmes-Hommes	2013-12-11	COMP	3.00	79.01	175.96	COMPLIANCE
1138	FRAUD-001	Prévention Fraude & Corruption	2013-11-16	COMP	2.00	79.11	153.58	COMPLIANCE
1138	ETHICS-001	Code de Déontologie Novaryn Tech	2013-12-03	COMP	1.50	89.06	122.24	COMPLIANCE
1138	SCRUM-001	Scrum Fundamentals	2023-09-10	COMP	12.00	78.94	653.61	ELEARN
1138	K8S-001	Kubernetes Fundamentals	2026-04-20	ENR	24.00	0.00	1074.49	ELEARN
1138	SQL-001	Advanced SQL for Analytics	2025-05-22	COMP	16.00	95.23	907.79	ELEARN
1138	SAFE-001	SAFe Agile Practitioner	2025-12-26	COMP	16.00	99.79	1349.59	COURSE
1138	EXCEL-001	Excel Avancé & Reporting	2020-11-08	FAIL	8.00	54.42	350.42	ELEARN
1139	GDPR-001	RGPD & Protection des Données	2016-09-11	COMP	2.00	86.31	183.32	COMPLIANCE
1139	HEALTH-001	Santé & Sécurité au Travail	2016-10-11	COMP	4.00	94.92	256.56	COMPLIANCE
1139	FIRE-001	Sécurité & Évacuation Incendie	2016-09-01	COMP	1.00	83.64	104.98	COMPLIANCE
1139	DEI-001	Égalité Femmes-Hommes	2016-09-10	COMP	3.00	88.11	178.89	COMPLIANCE
1139	FRAUD-001	Prévention Fraude & Corruption	2016-09-15	COMP	2.00	79.29	158.31	COMPLIANCE
1139	ETHICS-001	Code de Déontologie Novaryn Tech	2016-09-23	COMP	1.50	76.50	117.85	COMPLIANCE
1139	SAFE-001	SAFe Agile Practitioner	2023-10-10	COMP	16.00	87.01	1201.86	COURSE
1139	PYTHON-001	Python for Data Science	2021-05-31	COMP	24.00	62.76	904.37	ELEARN
1140	GDPR-001	RGPD & Protection des Données	2015-08-25	COMP	2.00	90.91	195.53	COMPLIANCE
1140	HEALTH-001	Santé & Sécurité au Travail	2015-09-11	COMP	4.00	89.61	227.44	COMPLIANCE
1140	FIRE-001	Sécurité & Évacuation Incendie	2015-09-14	COMP	1.00	73.53	100.33	COMPLIANCE
1140	DEI-001	Égalité Femmes-Hommes	2015-08-19	COMP	3.00	97.07	172.56	COMPLIANCE
1140	FRAUD-001	Prévention Fraude & Corruption	2015-08-18	COMP	2.00	71.19	153.03	COMPLIANCE
1140	ETHICS-001	Code de Déontologie Novaryn Tech	2015-09-04	COMP	1.50	73.29	111.72	COMPLIANCE
1140	AWS-001	AWS Cloud Practitioner	2025-11-26	COMP	30.00	60.23	1948.90	ELEARN
1140	K8S-001	Kubernetes Fundamentals	2026-04-30	ENR	24.00	0.00	1189.91	ELEARN
1141	GDPR-001	RGPD & Protection des Données	2023-09-20	COMP	2.00	79.07	188.94	COMPLIANCE
1141	HEALTH-001	Santé & Sécurité au Travail	2023-10-31	COMP	4.00	87.51	249.67	COMPLIANCE
1141	FIRE-001	Sécurité & Évacuation Incendie	2023-11-02	COMP	1.00	83.34	104.02	COMPLIANCE
1141	DEI-001	Égalité Femmes-Hommes	2023-09-25	COMP	3.00	73.05	167.01	COMPLIANCE
1141	FRAUD-001	Prévention Fraude & Corruption	2023-11-04	COMP	2.00	99.36	153.16	COMPLIANCE
1141	ETHICS-001	Code de Déontologie Novaryn Tech	2023-09-19	COMP	1.50	83.14	116.80	COMPLIANCE
1141	SCRUM-001	Scrum Fundamentals	2025-11-10	COMP	12.00	78.95	560.20	ELEARN
1141	COMM-001	Communication & Public Speaking	2024-01-01	COMP	8.00	76.89	347.82	OJT
1141	ML-001	Machine Learning Fundamentals	2024-01-14	COMP	40.00	97.95	1531.67	ELEARN
1141	SQL-001	Advanced SQL for Analytics	2024-08-17	COMP	16.00	96.77	897.59	ELEARN
1141	SAFE-001	SAFe Agile Practitioner	2026-04-23	ENR	16.00	0.00	1200.13	COURSE
1142	GDPR-001	RGPD & Protection des Données	2020-05-05	COMP	2.00	87.11	206.59	COMPLIANCE
1142	HEALTH-001	Santé & Sécurité au Travail	2020-05-28	COMP	4.00	89.80	252.30	COMPLIANCE
1142	FIRE-001	Sécurité & Évacuation Incendie	2020-06-04	COMP	1.00	77.89	91.34	COMPLIANCE
1142	DEI-001	Égalité Femmes-Hommes	2020-06-19	COMP	3.00	89.69	182.96	COMPLIANCE
1142	FRAUD-001	Prévention Fraude & Corruption	2020-05-07	COMP	2.00	86.79	141.97	COMPLIANCE
1142	ETHICS-001	Code de Déontologie Novaryn Tech	2020-05-09	COMP	1.50	79.01	125.92	COMPLIANCE
1142	SCRUM-001	Scrum Fundamentals	2021-01-12	COMP	12.00	86.64	615.40	ELEARN
1142	SQL-001	Advanced SQL for Analytics	2023-01-19	COMP	16.00	95.22	712.89	ELEARN
1142	EXCEL-001	Excel Avancé & Reporting	2023-08-09	FAIL	8.00	56.35	436.15	ELEARN
1142	ML-001	Machine Learning Fundamentals	2023-09-29	COMP	40.00	78.99	1589.79	ELEARN
1142	SAFE-001	SAFe Agile Practitioner	2024-03-21	COMP	16.00	75.51	1456.03	COURSE
1143	GDPR-001	RGPD & Protection des Données	2013-09-06	COMP	2.00	95.76	182.84	COMPLIANCE
1143	HEALTH-001	Santé & Sécurité au Travail	2013-09-14	COMP	4.00	73.81	250.49	COMPLIANCE
1143	FIRE-001	Sécurité & Évacuation Incendie	2013-09-20	COMP	1.00	72.04	100.27	COMPLIANCE
1143	DEI-001	Égalité Femmes-Hommes	2013-08-07	COMP	3.00	86.98	170.89	COMPLIANCE
1143	FRAUD-001	Prévention Fraude & Corruption	2013-09-20	COMP	2.00	82.41	153.77	COMPLIANCE
1143	ETHICS-001	Code de Déontologie Novaryn Tech	2013-08-17	COMP	1.50	94.84	117.75	COMPLIANCE
1143	SCRUM-001	Scrum Fundamentals	2021-03-28	COMP	12.00	97.23	580.34	ELEARN
1143	SQL-001	Advanced SQL for Analytics	2022-01-28	COMP	16.00	94.68	859.67	ELEARN
1143	REACT-001	React & TypeScript Masterclass	2024-07-08	COMP	36.00	84.60	1304.57	ELEARN
1143	EXCEL-001	Excel Avancé & Reporting	2023-07-04	FAIL	8.00	52.27	430.65	ELEARN
1143	AWS-001	AWS Cloud Practitioner	2024-10-24	COMP	30.00	83.96	1685.32	ELEARN
1144	GDPR-001	RGPD & Protection des Données	2016-11-10	COMP	2.00	72.25	203.99	COMPLIANCE
1144	HEALTH-001	Santé & Sécurité au Travail	2016-10-18	COMP	4.00	71.99	229.24	COMPLIANCE
1144	FIRE-001	Sécurité & Évacuation Incendie	2016-11-10	COMP	1.00	74.37	102.83	COMPLIANCE
1144	DEI-001	Égalité Femmes-Hommes	2016-10-15	COMP	3.00	78.32	172.11	COMPLIANCE
1144	FRAUD-001	Prévention Fraude & Corruption	2016-11-02	COMP	2.00	94.20	162.51	COMPLIANCE
1144	ETHICS-001	Code de Déontologie Novaryn Tech	2016-10-11	COMP	1.50	95.09	122.53	COMPLIANCE
1144	K8S-001	Kubernetes Fundamentals	2026-07-05	ENR	24.00	0.00	1129.56	ELEARN
1144	ML-001	Machine Learning Fundamentals	2021-07-13	COMP	40.00	87.29	1647.68	ELEARN
1144	EXCEL-001	Excel Avancé & Reporting	2026-04-25	ENR	8.00	0.00	396.32	ELEARN
1144	REACT-001	React & TypeScript Masterclass	2021-06-27	COMP	36.00	79.59	1143.27	ELEARN
1145	GDPR-001	RGPD & Protection des Données	2017-10-13	COMP	2.00	88.49	182.52	COMPLIANCE
1145	HEALTH-001	Santé & Sécurité au Travail	2017-10-20	COMP	4.00	78.05	238.56	COMPLIANCE
1145	FIRE-001	Sécurité & Évacuation Incendie	2017-09-28	COMP	1.00	87.83	94.56	COMPLIANCE
1145	DEI-001	Égalité Femmes-Hommes	2017-09-30	COMP	3.00	97.22	182.38	COMPLIANCE
1145	FRAUD-001	Prévention Fraude & Corruption	2017-10-02	COMP	2.00	99.17	140.76	COMPLIANCE
1145	ETHICS-001	Code de Déontologie Novaryn Tech	2017-10-01	COMP	1.50	85.53	117.88	COMPLIANCE
1145	PM-001	Product Management Essentials	2026-04-25	ENR	20.00	0.00	1308.81	COURSE
1145	REACT-001	React & TypeScript Masterclass	2025-03-08	COMP	36.00	67.60	1266.95	ELEARN
1145	SAFE-001	SAFe Agile Practitioner	2026-06-17	ENR	16.00	0.00	1324.88	COURSE
1145	AWS-001	AWS Cloud Practitioner	2026-06-21	ENR	30.00	0.00	1810.86	ELEARN
1146	GDPR-001	RGPD & Protection des Données	2016-06-29	COMP	2.00	91.74	215.05	COMPLIANCE
1146	HEALTH-001	Santé & Sécurité au Travail	2016-08-01	COMP	4.00	77.41	254.91	COMPLIANCE
1146	FIRE-001	Sécurité & Évacuation Incendie	2016-08-01	COMP	1.00	94.91	93.66	COMPLIANCE
1146	DEI-001	Égalité Femmes-Hommes	2016-08-02	COMP	3.00	94.29	175.50	COMPLIANCE
1146	FRAUD-001	Prévention Fraude & Corruption	2016-07-17	COMP	2.00	84.53	143.12	COMPLIANCE
1146	ETHICS-001	Code de Déontologie Novaryn Tech	2016-07-28	COMP	1.50	83.77	116.19	COMPLIANCE
1146	PM-001	Product Management Essentials	2025-10-23	FAIL	20.00	55.45	1374.19	COURSE
1146	LEAD-001	Leadership & Management	2022-01-18	COMP	20.00	67.56	1695.35	COURSE
1146	AZURE-001	Microsoft Azure Fundamentals	2024-03-26	FAIL	28.00	48.64	1835.61	ELEARN
1146	COMM-001	Communication & Public Speaking	2024-12-16	COMP	8.00	71.08	408.09	OJT
1147	GDPR-001	RGPD & Protection des Données	2019-07-27	COMP	2.00	77.97	219.26	COMPLIANCE
1147	HEALTH-001	Santé & Sécurité au Travail	2019-08-24	COMP	4.00	99.45	254.76	COMPLIANCE
1147	FIRE-001	Sécurité & Évacuation Incendie	2019-08-14	COMP	1.00	83.12	96.26	COMPLIANCE
1147	DEI-001	Égalité Femmes-Hommes	2019-07-23	COMP	3.00	75.43	175.01	COMPLIANCE
1147	FRAUD-001	Prévention Fraude & Corruption	2019-09-04	COMP	2.00	99.83	136.23	COMPLIANCE
1147	ETHICS-001	Code de Déontologie Novaryn Tech	2019-07-19	COMP	1.50	78.32	121.16	COMPLIANCE
1147	PYTHON-001	Python for Data Science	2021-03-20	COMP	24.00	95.65	1019.97	ELEARN
1147	LEAD-001	Leadership & Management	2021-12-22	COMP	20.00	73.50	1555.96	COURSE
1147	SAFE-001	SAFe Agile Practitioner	2023-12-03	COMP	16.00	77.19	1286.81	COURSE
1147	REACT-001	React & TypeScript Masterclass	2025-06-04	COMP	36.00	82.82	1116.02	ELEARN
1148	GDPR-001	RGPD & Protection des Données	2012-04-12	COMP	2.00	80.61	189.45	COMPLIANCE
1148	HEALTH-001	Santé & Sécurité au Travail	2012-03-09	COMP	4.00	86.61	240.84	COMPLIANCE
1148	FIRE-001	Sécurité & Évacuation Incendie	2012-03-22	COMP	1.00	75.16	109.33	COMPLIANCE
1148	DEI-001	Égalité Femmes-Hommes	2012-04-01	COMP	3.00	76.09	184.19	COMPLIANCE
1148	FRAUD-001	Prévention Fraude & Corruption	2012-03-18	COMP	2.00	72.74	157.21	COMPLIANCE
1148	ETHICS-001	Code de Déontologie Novaryn Tech	2012-03-25	COMP	1.50	94.29	110.99	COMPLIANCE
1148	REACT-001	React & TypeScript Masterclass	2022-02-28	COMP	36.00	66.63	1082.48	ELEARN
1148	AWS-001	AWS Cloud Practitioner	2023-11-28	COMP	30.00	64.30	1658.94	ELEARN
1148	COMM-001	Communication & Public Speaking	2022-03-04	COMP	8.00	83.19	411.97	OJT
1149	GDPR-001	RGPD & Protection des Données	2023-11-03	COMP	2.00	83.38	189.29	COMPLIANCE
1149	HEALTH-001	Santé & Sécurité au Travail	2023-10-15	COMP	4.00	82.26	247.21	COMPLIANCE
1149	FIRE-001	Sécurité & Évacuation Incendie	2023-10-19	COMP	1.00	92.17	97.69	COMPLIANCE
1149	DEI-001	Égalité Femmes-Hommes	2023-11-18	COMP	3.00	92.52	162.83	COMPLIANCE
1149	FRAUD-001	Prévention Fraude & Corruption	2023-11-27	COMP	2.00	78.15	161.45	COMPLIANCE
1149	ETHICS-001	Code de Déontologie Novaryn Tech	2023-11-10	COMP	1.50	83.10	129.00	COMPLIANCE
1149	SQL-001	Advanced SQL for Analytics	2025-06-01	COMP	16.00	93.53	825.57	ELEARN
1149	SCRUM-001	Scrum Fundamentals	2024-01-08	COMP	12.00	88.14	618.17	ELEARN
1149	K8S-001	Kubernetes Fundamentals	2025-11-29	COMP	24.00	75.11	1195.06	ELEARN
1149	ML-001	Machine Learning Fundamentals	2025-09-16	COMP	40.00	72.57	1554.45	ELEARN
1150	GDPR-001	RGPD & Protection des Données	2012-09-02	COMP	2.00	91.45	215.94	COMPLIANCE
1150	HEALTH-001	Santé & Sécurité au Travail	2012-09-11	COMP	4.00	88.01	248.49	COMPLIANCE
1150	FIRE-001	Sécurité & Évacuation Incendie	2012-08-19	COMP	1.00	90.59	101.27	COMPLIANCE
1150	DEI-001	Égalité Femmes-Hommes	2012-09-28	COMP	3.00	90.93	178.28	COMPLIANCE
1150	FRAUD-001	Prévention Fraude & Corruption	2012-10-08	COMP	2.00	70.66	152.15	COMPLIANCE
1150	ETHICS-001	Code de Déontologie Novaryn Tech	2012-09-10	COMP	1.50	81.43	119.78	COMPLIANCE
1150	REACT-001	React & TypeScript Masterclass	2023-12-16	COMP	36.00	74.66	1378.96	ELEARN
1150	LEAD-001	Leadership & Management	2022-06-12	COMP	20.00	66.74	1659.14	COURSE
1150	EXCEL-001	Excel Avancé & Reporting	2025-10-06	COMP	8.00	83.96	437.22	ELEARN
1150	AZURE-001	Microsoft Azure Fundamentals	2026-05-26	ENR	28.00	0.00	1534.99	ELEARN
1150	SQL-001	Advanced SQL for Analytics	2026-04-19	ENR	16.00	0.00	849.71	ELEARN
1151	GDPR-001	RGPD & Protection des Données	2021-06-12	COMP	2.00	72.77	207.81	COMPLIANCE
1151	HEALTH-001	Santé & Sécurité au Travail	2021-06-05	COMP	4.00	77.51	251.26	COMPLIANCE
1151	FIRE-001	Sécurité & Évacuation Incendie	2021-06-18	COMP	1.00	83.59	95.86	COMPLIANCE
1151	DEI-001	Égalité Femmes-Hommes	2021-06-29	COMP	3.00	78.36	194.97	COMPLIANCE
1151	FRAUD-001	Prévention Fraude & Corruption	2021-06-16	COMP	2.00	82.28	140.00	COMPLIANCE
1151	ETHICS-001	Code de Déontologie Novaryn Tech	2021-06-06	COMP	1.50	76.95	110.21	COMPLIANCE
1151	PM-001	Product Management Essentials	2026-04-30	ENR	20.00	0.00	1123.77	COURSE
1151	SAFE-001	SAFe Agile Practitioner	2025-05-27	COMP	16.00	76.93	1260.53	COURSE
1152	GDPR-001	RGPD & Protection des Données	2014-03-10	COMP	2.00	94.23	187.82	COMPLIANCE
1152	HEALTH-001	Santé & Sécurité au Travail	2014-04-23	COMP	4.00	72.31	263.64	COMPLIANCE
1152	FIRE-001	Sécurité & Évacuation Incendie	2014-03-26	COMP	1.00	94.52	93.57	COMPLIANCE
1152	DEI-001	Égalité Femmes-Hommes	2014-03-16	COMP	3.00	93.37	181.92	COMPLIANCE
1152	FRAUD-001	Prévention Fraude & Corruption	2014-04-01	COMP	2.00	91.70	139.58	COMPLIANCE
1152	ETHICS-001	Code de Déontologie Novaryn Tech	2014-03-20	COMP	1.50	77.37	108.21	COMPLIANCE
1152	EXCEL-001	Excel Avancé & Reporting	2026-06-11	ENR	8.00	0.00	400.54	ELEARN
1152	AZURE-001	Microsoft Azure Fundamentals	2024-12-30	COMP	28.00	65.40	1383.21	ELEARN
1152	ML-001	Machine Learning Fundamentals	2022-07-18	COMP	40.00	65.29	1773.61	ELEARN
1153	GDPR-001	RGPD & Protection des Données	2018-05-14	COMP	2.00	81.02	211.33	COMPLIANCE
1153	HEALTH-001	Santé & Sécurité au Travail	2018-04-20	COMP	4.00	77.37	233.76	COMPLIANCE
1153	FIRE-001	Sécurité & Évacuation Incendie	2018-03-29	COMP	1.00	91.40	93.24	COMPLIANCE
1153	DEI-001	Égalité Femmes-Hommes	2018-04-29	COMP	3.00	92.64	164.41	COMPLIANCE
1153	FRAUD-001	Prévention Fraude & Corruption	2018-04-15	COMP	2.00	74.08	143.62	COMPLIANCE
1153	ETHICS-001	Code de Déontologie Novaryn Tech	2018-04-24	COMP	1.50	93.97	124.26	COMPLIANCE
1153	ML-001	Machine Learning Fundamentals	2025-06-08	FAIL	40.00	57.92	1529.89	ELEARN
1153	EXCEL-001	Excel Avancé & Reporting	2023-08-11	COMP	8.00	88.73	429.92	ELEARN
1153	REACT-001	React & TypeScript Masterclass	2026-06-14	ENR	36.00	0.00	1357.27	ELEARN
1153	COMM-001	Communication & Public Speaking	2022-02-16	COMP	8.00	94.32	355.15	OJT
1153	K8S-001	Kubernetes Fundamentals	2023-11-20	COMP	24.00	62.94	1263.26	ELEARN
1154	GDPR-001	RGPD & Protection des Données	2015-09-27	COMP	2.00	78.95	204.18	COMPLIANCE
1154	HEALTH-001	Santé & Sécurité au Travail	2015-08-31	COMP	4.00	81.48	239.98	COMPLIANCE
1154	FIRE-001	Sécurité & Évacuation Incendie	2015-08-06	COMP	1.00	79.44	93.97	COMPLIANCE
1154	DEI-001	Égalité Femmes-Hommes	2015-08-06	COMP	3.00	76.47	189.90	COMPLIANCE
1154	FRAUD-001	Prévention Fraude & Corruption	2015-09-22	COMP	2.00	74.42	160.96	COMPLIANCE
1154	ETHICS-001	Code de Déontologie Novaryn Tech	2015-09-24	COMP	1.50	92.76	111.36	COMPLIANCE
1154	REACT-001	React & TypeScript Masterclass	2022-07-27	FAIL	36.00	57.17	1111.05	ELEARN
1154	AWS-001	AWS Cloud Practitioner	2021-09-10	COMP	30.00	88.52	1730.65	ELEARN
1154	PYTHON-001	Python for Data Science	2023-04-10	COMP	24.00	65.22	1137.89	ELEARN
1154	SCRUM-001	Scrum Fundamentals	2024-02-10	COMP	12.00	65.82	625.20	ELEARN
1155	GDPR-001	RGPD & Protection des Données	2023-05-20	COMP	2.00	78.86	182.12	COMPLIANCE
1155	HEALTH-001	Santé & Sécurité au Travail	2023-06-12	COMP	4.00	97.28	269.35	COMPLIANCE
1155	FIRE-001	Sécurité & Évacuation Incendie	2023-06-10	COMP	1.00	72.34	95.88	COMPLIANCE
1155	DEI-001	Égalité Femmes-Hommes	2023-07-05	COMP	3.00	85.38	179.18	COMPLIANCE
1155	FRAUD-001	Prévention Fraude & Corruption	2023-06-13	COMP	2.00	72.03	144.94	COMPLIANCE
1155	ETHICS-001	Code de Déontologie Novaryn Tech	2023-06-02	COMP	1.50	97.66	111.98	COMPLIANCE
1155	PYTHON-001	Python for Data Science	2026-05-12	ENR	24.00	0.00	867.97	ELEARN
1155	COMM-001	Communication & Public Speaking	2024-08-07	COMP	8.00	85.23	384.55	OJT
1156	GDPR-001	RGPD & Protection des Données	2025-05-14	COMP	2.00	82.10	211.94	COMPLIANCE
1156	HEALTH-001	Santé & Sécurité au Travail	2025-05-15	COMP	4.00	80.41	241.33	COMPLIANCE
1156	FIRE-001	Sécurité & Évacuation Incendie	2025-05-09	COMP	1.00	71.53	100.34	COMPLIANCE
1156	DEI-001	Égalité Femmes-Hommes	2025-04-23	COMP	3.00	96.51	189.31	COMPLIANCE
1156	FRAUD-001	Prévention Fraude & Corruption	2025-05-13	COMP	2.00	92.91	136.08	COMPLIANCE
1156	ETHICS-001	Code de Déontologie Novaryn Tech	2025-06-04	COMP	1.50	86.44	125.97	COMPLIANCE
1156	PYTHON-001	Python for Data Science	2025-09-20	COMP	24.00	88.57	1069.43	ELEARN
1156	REACT-001	React & TypeScript Masterclass	2025-10-27	COMP	36.00	65.76	1294.36	ELEARN
1157	GDPR-001	RGPD & Protection des Données	2022-08-11	COMP	2.00	72.80	195.36	COMPLIANCE
1157	HEALTH-001	Santé & Sécurité au Travail	2022-08-24	COMP	4.00	76.61	227.20	COMPLIANCE
1157	FIRE-001	Sécurité & Évacuation Incendie	2022-07-30	COMP	1.00	98.61	93.89	COMPLIANCE
1157	DEI-001	Égalité Femmes-Hommes	2022-09-04	COMP	3.00	75.81	190.78	COMPLIANCE
1157	FRAUD-001	Prévention Fraude & Corruption	2022-08-08	COMP	2.00	82.81	152.05	COMPLIANCE
1157	ETHICS-001	Code de Déontologie Novaryn Tech	2022-08-12	COMP	1.50	70.02	109.59	COMPLIANCE
1157	AZURE-001	Microsoft Azure Fundamentals	2024-04-30	COMP	28.00	62.64	1584.79	ELEARN
1157	COMM-001	Communication & Public Speaking	2025-03-31	FAIL	8.00	57.57	399.22	OJT
1158	GDPR-001	RGPD & Protection des Données	2014-10-18	COMP	2.00	90.08	212.47	COMPLIANCE
1158	HEALTH-001	Santé & Sécurité au Travail	2014-11-03	COMP	4.00	88.50	273.97	COMPLIANCE
1158	FIRE-001	Sécurité & Évacuation Incendie	2014-11-12	COMP	1.00	98.67	95.16	COMPLIANCE
1158	DEI-001	Égalité Femmes-Hommes	2014-11-17	COMP	3.00	86.44	194.45	COMPLIANCE
1158	FRAUD-001	Prévention Fraude & Corruption	2014-11-29	COMP	2.00	79.92	154.95	COMPLIANCE
1158	ETHICS-001	Code de Déontologie Novaryn Tech	2014-11-15	COMP	1.50	74.67	124.37	COMPLIANCE
1158	EXCEL-001	Excel Avancé & Reporting	2026-06-02	ENR	8.00	0.00	398.01	ELEARN
1158	PM-001	Product Management Essentials	2025-12-12	COMP	20.00	80.35	1199.59	COURSE
1158	AWS-001	AWS Cloud Practitioner	2026-05-29	ENR	30.00	0.00	1557.69	ELEARN
1158	SAFE-001	SAFe Agile Practitioner	2020-03-09	COMP	16.00	92.07	1298.21	COURSE
1160	GDPR-001	RGPD & Protection des Données	2017-10-24	COMP	2.00	74.44	188.95	COMPLIANCE
1160	HEALTH-001	Santé & Sécurité au Travail	2017-10-22	COMP	4.00	76.57	272.81	COMPLIANCE
1160	FIRE-001	Sécurité & Évacuation Incendie	2017-10-01	COMP	1.00	97.16	108.52	COMPLIANCE
1160	DEI-001	Égalité Femmes-Hommes	2017-10-16	COMP	3.00	86.27	175.07	COMPLIANCE
1160	FRAUD-001	Prévention Fraude & Corruption	2017-10-19	COMP	2.00	82.00	152.00	COMPLIANCE
1160	ETHICS-001	Code de Déontologie Novaryn Tech	2017-09-21	COMP	1.50	72.43	111.90	COMPLIANCE
1160	SAFE-001	SAFe Agile Practitioner	2025-08-07	COMP	16.00	77.29	1363.97	COURSE
1160	LEAD-001	Leadership & Management	2023-05-14	FAIL	20.00	46.34	1441.67	COURSE
1160	SQL-001	Advanced SQL for Analytics	2022-05-02	COMP	16.00	79.46	919.47	ELEARN
1160	SCRUM-001	Scrum Fundamentals	2020-01-26	FAIL	12.00	47.53	548.53	ELEARN
1160	REACT-001	React & TypeScript Masterclass	2024-10-24	COMP	36.00	69.40	1107.56	ELEARN
1161	GDPR-001	RGPD & Protection des Données	2024-08-30	COMP	2.00	74.95	186.37	COMPLIANCE
1161	HEALTH-001	Santé & Sécurité au Travail	2024-07-30	COMP	4.00	87.80	267.66	COMPLIANCE
1161	FIRE-001	Sécurité & Évacuation Incendie	2024-07-16	COMP	1.00	72.46	105.92	COMPLIANCE
1161	DEI-001	Égalité Femmes-Hommes	2024-07-10	COMP	3.00	74.50	177.43	COMPLIANCE
1161	FRAUD-001	Prévention Fraude & Corruption	2024-07-15	COMP	2.00	98.03	158.81	COMPLIANCE
1161	ETHICS-001	Code de Déontologie Novaryn Tech	2024-08-23	COMP	1.50	89.44	131.80	COMPLIANCE
1161	K8S-001	Kubernetes Fundamentals	2024-11-08	COMP	24.00	71.66	1213.38	ELEARN
1161	PYTHON-001	Python for Data Science	2025-10-21	COMP	24.00	96.72	1060.00	ELEARN
1162	GDPR-001	RGPD & Protection des Données	2014-11-04	COMP	2.00	87.16	181.62	COMPLIANCE
1162	HEALTH-001	Santé & Sécurité au Travail	2014-10-12	COMP	4.00	79.90	226.95	COMPLIANCE
1162	FIRE-001	Sécurité & Évacuation Incendie	2014-10-30	COMP	1.00	72.47	90.79	COMPLIANCE
1162	DEI-001	Égalité Femmes-Hommes	2014-09-23	COMP	3.00	94.64	168.92	COMPLIANCE
1162	FRAUD-001	Prévention Fraude & Corruption	2014-10-03	COMP	2.00	96.91	159.73	COMPLIANCE
1162	ETHICS-001	Code de Déontologie Novaryn Tech	2014-10-24	COMP	1.50	73.23	122.24	COMPLIANCE
1162	PM-001	Product Management Essentials	2022-06-08	COMP	20.00	78.49	1326.86	COURSE
1162	AZURE-001	Microsoft Azure Fundamentals	2021-12-15	COMP	28.00	91.04	1607.15	ELEARN
1163	GDPR-001	RGPD & Protection des Données	2012-10-05	COMP	2.00	88.19	207.56	COMPLIANCE
1163	HEALTH-001	Santé & Sécurité au Travail	2012-09-06	COMP	4.00	81.80	241.93	COMPLIANCE
1163	FIRE-001	Sécurité & Évacuation Incendie	2012-09-14	COMP	1.00	90.85	106.21	COMPLIANCE
1163	DEI-001	Égalité Femmes-Hommes	2012-09-26	COMP	3.00	98.55	173.03	COMPLIANCE
1163	FRAUD-001	Prévention Fraude & Corruption	2012-10-15	COMP	2.00	91.17	147.03	COMPLIANCE
1163	ETHICS-001	Code de Déontologie Novaryn Tech	2012-10-25	COMP	1.50	97.91	127.06	COMPLIANCE
1163	SAFE-001	SAFe Agile Practitioner	2025-03-01	COMP	16.00	88.13	1205.46	COURSE
1163	SQL-001	Advanced SQL for Analytics	2022-12-30	COMP	16.00	95.01	715.44	ELEARN
1163	AWS-001	AWS Cloud Practitioner	2021-11-11	FAIL	30.00	42.40	1920.30	ELEARN
1163	EXCEL-001	Excel Avancé & Reporting	2025-05-31	COMP	8.00	73.31	378.39	ELEARN
1165	GDPR-001	RGPD & Protection des Données	2017-04-02	COMP	2.00	91.56	197.41	COMPLIANCE
1165	HEALTH-001	Santé & Sécurité au Travail	2017-03-25	COMP	4.00	97.90	258.41	COMPLIANCE
1165	FIRE-001	Sécurité & Évacuation Incendie	2017-04-29	COMP	1.00	86.56	101.75	COMPLIANCE
1165	DEI-001	Égalité Femmes-Hommes	2017-05-02	COMP	3.00	76.29	179.04	COMPLIANCE
1165	FRAUD-001	Prévention Fraude & Corruption	2017-03-20	COMP	2.00	80.93	146.72	COMPLIANCE
1165	ETHICS-001	Code de Déontologie Novaryn Tech	2017-04-09	COMP	1.50	71.98	108.75	COMPLIANCE
1165	REACT-001	React & TypeScript Masterclass	2021-08-13	COMP	36.00	75.90	1275.29	ELEARN
1165	PYTHON-001	Python for Data Science	2025-04-13	COMP	24.00	65.32	948.07	ELEARN
1165	K8S-001	Kubernetes Fundamentals	2022-02-17	FAIL	24.00	48.02	1038.88	ELEARN
1165	SAFE-001	SAFe Agile Practitioner	2025-10-06	FAIL	16.00	50.76	1483.94	COURSE
1166	GDPR-001	RGPD & Protection des Données	2012-06-03	COMP	2.00	96.08	186.57	COMPLIANCE
1166	HEALTH-001	Santé & Sécurité au Travail	2012-06-19	COMP	4.00	82.47	249.34	COMPLIANCE
1166	FIRE-001	Sécurité & Évacuation Incendie	2012-06-24	COMP	1.00	74.45	107.68	COMPLIANCE
1166	DEI-001	Égalité Femmes-Hommes	2012-06-18	COMP	3.00	85.38	179.83	COMPLIANCE
1166	FRAUD-001	Prévention Fraude & Corruption	2012-06-20	COMP	2.00	97.22	156.62	COMPLIANCE
1166	ETHICS-001	Code de Déontologie Novaryn Tech	2012-06-29	COMP	1.50	71.15	108.22	COMPLIANCE
1166	COMM-001	Communication & Public Speaking	2025-08-10	COMP	8.00	64.18	432.59	OJT
1166	SQL-001	Advanced SQL for Analytics	2025-10-16	FAIL	16.00	43.83	715.47	ELEARN
1166	PM-001	Product Management Essentials	2021-02-28	COMP	20.00	94.31	1287.86	COURSE
1166	EXCEL-001	Excel Avancé & Reporting	2025-05-05	COMP	8.00	75.63	403.45	ELEARN
1167	GDPR-001	RGPD & Protection des Données	2018-11-24	COMP	2.00	88.37	204.49	COMPLIANCE
1167	HEALTH-001	Santé & Sécurité au Travail	2018-11-14	COMP	4.00	93.09	261.56	COMPLIANCE
1167	FIRE-001	Sécurité & Évacuation Incendie	2018-10-20	COMP	1.00	83.65	104.38	COMPLIANCE
1167	DEI-001	Égalité Femmes-Hommes	2018-11-22	COMP	3.00	78.71	197.88	COMPLIANCE
1167	FRAUD-001	Prévention Fraude & Corruption	2018-11-16	COMP	2.00	71.34	144.98	COMPLIANCE
1167	ETHICS-001	Code de Déontologie Novaryn Tech	2018-11-13	COMP	1.50	87.68	131.16	COMPLIANCE
1167	K8S-001	Kubernetes Fundamentals	2020-10-28	FAIL	24.00	57.37	1135.89	ELEARN
1167	REACT-001	React & TypeScript Masterclass	2025-05-03	COMP	36.00	72.61	1232.72	ELEARN
1168	GDPR-001	RGPD & Protection des Données	2013-04-11	COMP	2.00	77.94	215.66	COMPLIANCE
1168	HEALTH-001	Santé & Sécurité au Travail	2013-03-16	COMP	4.00	94.50	258.42	COMPLIANCE
1168	FIRE-001	Sécurité & Évacuation Incendie	2013-04-20	COMP	1.00	77.62	95.31	COMPLIANCE
1168	DEI-001	Égalité Femmes-Hommes	2013-04-16	COMP	3.00	76.88	169.98	COMPLIANCE
1168	FRAUD-001	Prévention Fraude & Corruption	2013-05-05	COMP	2.00	83.48	146.91	COMPLIANCE
1168	ETHICS-001	Code de Déontologie Novaryn Tech	2013-04-10	COMP	1.50	71.43	109.83	COMPLIANCE
1168	ML-001	Machine Learning Fundamentals	2025-07-01	COMP	40.00	98.10	1741.42	ELEARN
1168	EXCEL-001	Excel Avancé & Reporting	2020-05-02	COMP	8.00	72.25	412.03	ELEARN
1168	REACT-001	React & TypeScript Masterclass	2022-08-17	COMP	36.00	99.55	1096.83	ELEARN
1168	SCRUM-001	Scrum Fundamentals	2023-10-01	COMP	12.00	71.50	530.86	ELEARN
1169	GDPR-001	RGPD & Protection des Données	2022-12-22	COMP	2.00	97.77	195.56	COMPLIANCE
1169	HEALTH-001	Santé & Sécurité au Travail	2023-01-22	COMP	4.00	79.86	252.25	COMPLIANCE
1169	FIRE-001	Sécurité & Évacuation Incendie	2022-12-19	COMP	1.00	70.43	98.59	COMPLIANCE
1169	DEI-001	Égalité Femmes-Hommes	2022-12-28	COMP	3.00	89.41	196.08	COMPLIANCE
1169	FRAUD-001	Prévention Fraude & Corruption	2022-12-08	COMP	2.00	72.98	162.93	COMPLIANCE
1169	ETHICS-001	Code de Déontologie Novaryn Tech	2023-01-22	COMP	1.50	77.75	123.78	COMPLIANCE
1169	REACT-001	React & TypeScript Masterclass	2026-05-24	ENR	36.00	0.00	1055.14	ELEARN
1169	PYTHON-001	Python for Data Science	2025-08-16	FAIL	24.00	45.88	1012.70	ELEARN
1169	EXCEL-001	Excel Avancé & Reporting	2024-09-16	COMP	8.00	62.74	457.94	ELEARN
1169	AWS-001	AWS Cloud Practitioner	2026-04-08	ENR	30.00	0.00	2044.94	ELEARN
1170	GDPR-001	RGPD & Protection des Données	2023-08-04	COMP	2.00	93.36	211.78	COMPLIANCE
1170	HEALTH-001	Santé & Sécurité au Travail	2023-08-17	COMP	4.00	98.95	230.67	COMPLIANCE
1170	FIRE-001	Sécurité & Évacuation Incendie	2023-08-28	COMP	1.00	80.13	100.01	COMPLIANCE
1170	DEI-001	Égalité Femmes-Hommes	2023-09-22	COMP	3.00	93.39	178.75	COMPLIANCE
1170	FRAUD-001	Prévention Fraude & Corruption	2023-08-07	COMP	2.00	84.44	153.43	COMPLIANCE
1170	ETHICS-001	Code de Déontologie Novaryn Tech	2023-09-19	COMP	1.50	72.50	126.94	COMPLIANCE
1170	PYTHON-001	Python for Data Science	2024-03-10	FAIL	24.00	53.78	1123.28	ELEARN
1170	REACT-001	React & TypeScript Masterclass	2025-01-22	COMP	36.00	98.78	1295.93	ELEARN
1170	AWS-001	AWS Cloud Practitioner	2025-03-12	FAIL	30.00	43.08	1714.73	ELEARN
1170	ML-001	Machine Learning Fundamentals	2025-07-28	COMP	40.00	87.58	1453.20	ELEARN
1171	GDPR-001	RGPD & Protection des Données	2012-08-14	COMP	2.00	88.95	181.19	COMPLIANCE
1171	HEALTH-001	Santé & Sécurité au Travail	2012-07-21	COMP	4.00	93.78	246.62	COMPLIANCE
1171	FIRE-001	Sécurité & Évacuation Incendie	2012-08-17	COMP	1.00	85.37	106.24	COMPLIANCE
1171	DEI-001	Égalité Femmes-Hommes	2012-07-10	COMP	3.00	75.03	184.36	COMPLIANCE
1171	FRAUD-001	Prévention Fraude & Corruption	2012-07-27	COMP	2.00	93.20	157.43	COMPLIANCE
1171	ETHICS-001	Code de Déontologie Novaryn Tech	2012-07-01	COMP	1.50	99.28	125.87	COMPLIANCE
1171	ML-001	Machine Learning Fundamentals	2021-06-29	COMP	40.00	61.68	1577.40	ELEARN
1171	K8S-001	Kubernetes Fundamentals	2021-09-15	COMP	24.00	74.22	1260.93	ELEARN
1171	REACT-001	React & TypeScript Masterclass	2021-02-14	FAIL	36.00	52.33	1169.59	ELEARN
1171	SQL-001	Advanced SQL for Analytics	2026-05-18	ENR	16.00	0.00	886.88	ELEARN
1171	PM-001	Product Management Essentials	2023-02-10	COMP	20.00	93.72	1234.07	COURSE
1172	GDPR-001	RGPD & Protection des Données	2015-02-25	COMP	2.00	92.98	203.72	COMPLIANCE
1172	HEALTH-001	Santé & Sécurité au Travail	2015-02-20	COMP	4.00	84.83	274.81	COMPLIANCE
1172	FIRE-001	Sécurité & Évacuation Incendie	2015-03-08	COMP	1.00	92.85	92.40	COMPLIANCE
1172	DEI-001	Égalité Femmes-Hommes	2015-03-13	COMP	3.00	70.97	192.07	COMPLIANCE
1172	FRAUD-001	Prévention Fraude & Corruption	2015-02-10	COMP	2.00	77.38	151.11	COMPLIANCE
1172	ETHICS-001	Code de Déontologie Novaryn Tech	2015-02-17	COMP	1.50	78.80	128.61	COMPLIANCE
1172	AZURE-001	Microsoft Azure Fundamentals	2024-07-07	FAIL	28.00	42.60	1483.98	ELEARN
1172	SAFE-001	SAFe Agile Practitioner	2024-04-08	COMP	16.00	66.12	1332.78	COURSE
1173	GDPR-001	RGPD & Protection des Données	2012-09-27	COMP	2.00	99.44	219.01	COMPLIANCE
1173	HEALTH-001	Santé & Sécurité au Travail	2012-09-24	COMP	4.00	72.25	240.42	COMPLIANCE
1173	FIRE-001	Sécurité & Évacuation Incendie	2012-09-20	COMP	1.00	82.21	90.52	COMPLIANCE
1173	DEI-001	Égalité Femmes-Hommes	2012-09-19	COMP	3.00	79.83	187.62	COMPLIANCE
1173	FRAUD-001	Prévention Fraude & Corruption	2012-09-09	COMP	2.00	97.94	153.09	COMPLIANCE
1173	ETHICS-001	Code de Déontologie Novaryn Tech	2012-09-07	COMP	1.50	80.88	110.28	COMPLIANCE
1173	EXCEL-001	Excel Avancé & Reporting	2022-04-26	COMP	8.00	68.49	436.04	ELEARN
1173	SQL-001	Advanced SQL for Analytics	2021-05-26	COMP	16.00	71.06	881.95	ELEARN
1173	COMM-001	Communication & Public Speaking	2022-03-09	COMP	8.00	81.65	443.11	OJT
1173	LEAD-001	Leadership & Management	2026-06-17	ENR	20.00	0.00	1695.84	COURSE
1174	GDPR-001	RGPD & Protection des Données	2019-07-14	COMP	2.00	86.38	216.25	COMPLIANCE
1174	HEALTH-001	Santé & Sécurité au Travail	2019-07-12	COMP	4.00	78.93	269.77	COMPLIANCE
1174	FIRE-001	Sécurité & Évacuation Incendie	2019-07-18	COMP	1.00	97.92	96.24	COMPLIANCE
1174	DEI-001	Égalité Femmes-Hommes	2019-06-26	COMP	3.00	72.79	174.00	COMPLIANCE
1174	FRAUD-001	Prévention Fraude & Corruption	2019-07-17	COMP	2.00	71.56	137.06	COMPLIANCE
1174	ETHICS-001	Code de Déontologie Novaryn Tech	2019-07-07	COMP	1.50	70.12	129.39	COMPLIANCE
1174	K8S-001	Kubernetes Fundamentals	2022-07-05	COMP	24.00	64.28	987.41	ELEARN
1174	SQL-001	Advanced SQL for Analytics	2022-11-18	FAIL	16.00	57.01	739.42	ELEARN
1175	GDPR-001	RGPD & Protection des Données	2025-06-15	COMP	2.00	75.05	205.94	COMPLIANCE
1175	HEALTH-001	Santé & Sécurité au Travail	2025-06-30	COMP	4.00	91.02	230.19	COMPLIANCE
1175	FIRE-001	Sécurité & Évacuation Incendie	2025-07-15	COMP	1.00	70.51	94.37	COMPLIANCE
1175	DEI-001	Égalité Femmes-Hommes	2025-07-09	COMP	3.00	73.80	188.56	COMPLIANCE
1175	FRAUD-001	Prévention Fraude & Corruption	2025-07-16	COMP	2.00	95.91	150.29	COMPLIANCE
1175	ETHICS-001	Code de Déontologie Novaryn Tech	2025-06-20	COMP	1.50	70.16	120.55	COMPLIANCE
1175	PM-001	Product Management Essentials	2025-09-07	COMP	20.00	62.37	1095.96	COURSE
1175	COMM-001	Communication & Public Speaking	2025-11-14	COMP	8.00	67.70	403.33	OJT
1175	AWS-001	AWS Cloud Practitioner	2025-08-30	COMP	30.00	76.18	1849.02	ELEARN
1175	K8S-001	Kubernetes Fundamentals	2025-09-12	FAIL	24.00	45.47	1017.18	ELEARN
1176	GDPR-001	RGPD & Protection des Données	2022-05-08	COMP	2.00	91.21	190.20	COMPLIANCE
1176	HEALTH-001	Santé & Sécurité au Travail	2022-06-08	COMP	4.00	84.93	273.89	COMPLIANCE
1176	FIRE-001	Sécurité & Évacuation Incendie	2022-05-26	COMP	1.00	87.72	104.94	COMPLIANCE
1176	DEI-001	Égalité Femmes-Hommes	2022-06-14	COMP	3.00	73.85	168.64	COMPLIANCE
1176	FRAUD-001	Prévention Fraude & Corruption	2022-06-11	COMP	2.00	87.41	164.02	COMPLIANCE
1176	ETHICS-001	Code de Déontologie Novaryn Tech	2022-05-16	COMP	1.50	73.97	108.96	COMPLIANCE
1176	COMM-001	Communication & Public Speaking	2025-10-06	COMP	8.00	65.32	366.18	OJT
1176	SCRUM-001	Scrum Fundamentals	2023-07-08	FAIL	12.00	50.92	627.33	ELEARN
1176	LEAD-001	Leadership & Management	2026-07-06	ENR	20.00	0.00	1281.19	COURSE
1178	GDPR-001	RGPD & Protection des Données	2016-05-14	COMP	2.00	80.24	197.88	COMPLIANCE
1178	HEALTH-001	Santé & Sécurité au Travail	2016-05-17	COMP	4.00	91.73	264.28	COMPLIANCE
1178	FIRE-001	Sécurité & Évacuation Incendie	2016-05-31	COMP	1.00	79.75	98.22	COMPLIANCE
1178	DEI-001	Égalité Femmes-Hommes	2016-06-19	COMP	3.00	85.57	171.90	COMPLIANCE
1178	FRAUD-001	Prévention Fraude & Corruption	2016-06-19	COMP	2.00	76.05	154.05	COMPLIANCE
1178	ETHICS-001	Code de Déontologie Novaryn Tech	2016-05-21	COMP	1.50	81.68	112.51	COMPLIANCE
1178	K8S-001	Kubernetes Fundamentals	2025-09-26	COMP	24.00	70.08	1077.99	ELEARN
1178	EXCEL-001	Excel Avancé & Reporting	2023-05-19	COMP	8.00	91.26	440.04	ELEARN
1178	AZURE-001	Microsoft Azure Fundamentals	2026-06-14	ENR	28.00	0.00	1498.75	ELEARN
1179	GDPR-001	RGPD & Protection des Données	2019-07-05	COMP	2.00	73.31	191.49	COMPLIANCE
1179	HEALTH-001	Santé & Sécurité au Travail	2019-06-27	COMP	4.00	78.38	246.31	COMPLIANCE
1179	FIRE-001	Sécurité & Évacuation Incendie	2019-06-09	COMP	1.00	84.20	105.25	COMPLIANCE
1179	DEI-001	Égalité Femmes-Hommes	2019-06-13	COMP	3.00	87.59	174.52	COMPLIANCE
1179	FRAUD-001	Prévention Fraude & Corruption	2019-07-20	COMP	2.00	76.73	141.03	COMPLIANCE
1179	ETHICS-001	Code de Déontologie Novaryn Tech	2019-06-26	COMP	1.50	95.18	131.12	COMPLIANCE
1179	PYTHON-001	Python for Data Science	2023-02-10	FAIL	24.00	40.33	920.33	ELEARN
1179	K8S-001	Kubernetes Fundamentals	2020-10-07	COMP	24.00	68.75	1248.01	ELEARN
1179	AWS-001	AWS Cloud Practitioner	2023-05-10	COMP	30.00	97.36	1589.31	ELEARN
1179	COMM-001	Communication & Public Speaking	2026-06-13	ENR	8.00	0.00	370.58	OJT
1180	GDPR-001	RGPD & Protection des Données	2025-10-03	COMP	2.00	78.15	206.33	COMPLIANCE
1180	HEALTH-001	Santé & Sécurité au Travail	2025-11-17	COMP	4.00	79.31	245.19	COMPLIANCE
1180	FIRE-001	Sécurité & Évacuation Incendie	2025-10-01	COMP	1.00	87.01	107.70	COMPLIANCE
1180	DEI-001	Égalité Femmes-Hommes	2025-10-12	COMP	3.00	96.96	171.08	COMPLIANCE
1180	FRAUD-001	Prévention Fraude & Corruption	2025-10-12	COMP	2.00	92.73	155.05	COMPLIANCE
1180	ETHICS-001	Code de Déontologie Novaryn Tech	2025-11-01	COMP	1.50	95.68	121.79	COMPLIANCE
1180	SAFE-001	SAFe Agile Practitioner	2025-12-22	COMP	16.00	98.34	1327.50	COURSE
1180	K8S-001	Kubernetes Fundamentals	2025-12-25	COMP	24.00	82.15	1122.42	ELEARN
1180	ML-001	Machine Learning Fundamentals	2025-12-20	COMP	40.00	67.74	1412.06	ELEARN
1181	GDPR-001	RGPD & Protection des Données	2019-05-29	COMP	2.00	91.63	196.99	COMPLIANCE
1181	HEALTH-001	Santé & Sécurité au Travail	2019-06-23	COMP	4.00	94.14	254.31	COMPLIANCE
1181	FIRE-001	Sécurité & Évacuation Incendie	2019-06-19	COMP	1.00	82.06	106.84	COMPLIANCE
1181	DEI-001	Égalité Femmes-Hommes	2019-06-17	COMP	3.00	86.96	174.85	COMPLIANCE
1181	FRAUD-001	Prévention Fraude & Corruption	2019-06-03	COMP	2.00	84.16	140.89	COMPLIANCE
1181	ETHICS-001	Code de Déontologie Novaryn Tech	2019-05-25	COMP	1.50	79.74	128.59	COMPLIANCE
1181	K8S-001	Kubernetes Fundamentals	2023-11-13	COMP	24.00	77.23	1120.60	ELEARN
1181	AWS-001	AWS Cloud Practitioner	2023-02-19	COMP	30.00	64.13	2013.80	ELEARN
1181	ML-001	Machine Learning Fundamentals	2025-09-21	COMP	40.00	94.66	1458.38	ELEARN
1181	SQL-001	Advanced SQL for Analytics	2025-09-19	COMP	16.00	99.84	697.42	ELEARN
1182	GDPR-001	RGPD & Protection des Données	2017-10-02	COMP	2.00	99.69	201.94	COMPLIANCE
1182	HEALTH-001	Santé & Sécurité au Travail	2017-10-04	COMP	4.00	74.07	261.90	COMPLIANCE
1182	FIRE-001	Sécurité & Évacuation Incendie	2017-09-02	COMP	1.00	81.13	90.73	COMPLIANCE
1182	DEI-001	Égalité Femmes-Hommes	2017-08-20	COMP	3.00	97.55	176.73	COMPLIANCE
1182	FRAUD-001	Prévention Fraude & Corruption	2017-09-06	COMP	2.00	89.29	161.69	COMPLIANCE
1182	ETHICS-001	Code de Déontologie Novaryn Tech	2017-09-02	COMP	1.50	72.80	130.17	COMPLIANCE
1182	LEAD-001	Leadership & Management	2026-06-15	ENR	20.00	0.00	1610.89	COURSE
1182	AZURE-001	Microsoft Azure Fundamentals	2024-12-21	FAIL	28.00	44.58	1588.49	ELEARN
1183	GDPR-001	RGPD & Protection des Données	2023-05-09	COMP	2.00	86.23	206.29	COMPLIANCE
1183	HEALTH-001	Santé & Sécurité au Travail	2023-06-05	COMP	4.00	91.86	271.31	COMPLIANCE
1183	FIRE-001	Sécurité & Évacuation Incendie	2023-05-23	COMP	1.00	94.51	94.33	COMPLIANCE
1183	DEI-001	Égalité Femmes-Hommes	2023-05-18	COMP	3.00	96.62	165.60	COMPLIANCE
1183	FRAUD-001	Prévention Fraude & Corruption	2023-05-24	COMP	2.00	87.49	162.74	COMPLIANCE
1183	ETHICS-001	Code de Déontologie Novaryn Tech	2023-05-09	COMP	1.50	70.00	124.71	COMPLIANCE
1183	EXCEL-001	Excel Avancé & Reporting	2025-02-24	COMP	8.00	63.90	415.26	ELEARN
1183	K8S-001	Kubernetes Fundamentals	2025-02-10	COMP	24.00	71.01	991.78	ELEARN
1183	ML-001	Machine Learning Fundamentals	2023-12-29	COMP	40.00	89.50	1711.57	ELEARN
1183	PYTHON-001	Python for Data Science	2024-07-11	COMP	24.00	68.36	889.79	ELEARN
1184	GDPR-001	RGPD & Protection des Données	2017-03-17	COMP	2.00	71.84	197.98	COMPLIANCE
1184	HEALTH-001	Santé & Sécurité au Travail	2017-03-27	COMP	4.00	74.04	230.89	COMPLIANCE
1184	FIRE-001	Sécurité & Évacuation Incendie	2017-04-03	COMP	1.00	76.12	102.54	COMPLIANCE
1184	DEI-001	Égalité Femmes-Hommes	2017-04-05	COMP	3.00	78.99	186.72	COMPLIANCE
1184	FRAUD-001	Prévention Fraude & Corruption	2017-02-25	COMP	2.00	90.64	160.01	COMPLIANCE
1184	ETHICS-001	Code de Déontologie Novaryn Tech	2017-02-26	COMP	1.50	84.21	108.18	COMPLIANCE
1184	SCRUM-001	Scrum Fundamentals	2024-01-04	COMP	12.00	90.58	548.12	ELEARN
1184	ML-001	Machine Learning Fundamentals	2020-03-18	COMP	40.00	64.34	1470.04	ELEARN
1184	PYTHON-001	Python for Data Science	2026-05-12	ENR	24.00	0.00	1064.11	ELEARN
1184	REACT-001	React & TypeScript Masterclass	2026-07-03	ENR	36.00	0.00	1211.11	ELEARN
1185	GDPR-001	RGPD & Protection des Données	2023-06-19	COMP	2.00	96.97	216.69	COMPLIANCE
1185	HEALTH-001	Santé & Sécurité au Travail	2023-06-03	COMP	4.00	96.59	232.87	COMPLIANCE
1185	FIRE-001	Sécurité & Évacuation Incendie	2023-06-20	COMP	1.00	85.99	101.35	COMPLIANCE
1185	DEI-001	Égalité Femmes-Hommes	2023-06-10	COMP	3.00	82.75	183.99	COMPLIANCE
1185	FRAUD-001	Prévention Fraude & Corruption	2023-07-02	COMP	2.00	83.35	144.47	COMPLIANCE
1185	ETHICS-001	Code de Déontologie Novaryn Tech	2023-06-20	COMP	1.50	76.42	125.60	COMPLIANCE
1185	AWS-001	AWS Cloud Practitioner	2024-12-25	COMP	30.00	90.90	1781.03	ELEARN
1185	REACT-001	React & TypeScript Masterclass	2024-07-12	COMP	36.00	83.26	1306.78	ELEARN
1186	GDPR-001	RGPD & Protection des Données	2018-11-20	COMP	2.00	97.02	189.19	COMPLIANCE
1186	HEALTH-001	Santé & Sécurité au Travail	2018-12-26	COMP	4.00	86.01	267.86	COMPLIANCE
1186	FIRE-001	Sécurité & Évacuation Incendie	2018-12-17	COMP	1.00	84.38	108.19	COMPLIANCE
1186	DEI-001	Égalité Femmes-Hommes	2018-12-19	COMP	3.00	91.37	191.40	COMPLIANCE
1186	FRAUD-001	Prévention Fraude & Corruption	2018-11-15	COMP	2.00	85.54	151.17	COMPLIANCE
1186	ETHICS-001	Code de Déontologie Novaryn Tech	2018-11-26	COMP	1.50	93.97	113.77	COMPLIANCE
1186	ML-001	Machine Learning Fundamentals	2025-07-05	COMP	40.00	62.97	1618.72	ELEARN
1186	PM-001	Product Management Essentials	2020-07-15	COMP	20.00	81.00	1053.67	COURSE
1187	GDPR-001	RGPD & Protection des Données	2014-03-24	COMP	2.00	79.96	185.45	COMPLIANCE
1187	HEALTH-001	Santé & Sécurité au Travail	2014-03-19	COMP	4.00	71.32	249.53	COMPLIANCE
1187	FIRE-001	Sécurité & Évacuation Incendie	2014-04-30	COMP	1.00	76.16	106.06	COMPLIANCE
1187	DEI-001	Égalité Femmes-Hommes	2014-03-22	COMP	3.00	90.96	165.22	COMPLIANCE
1187	FRAUD-001	Prévention Fraude & Corruption	2014-03-17	COMP	2.00	88.75	137.14	COMPLIANCE
1187	ETHICS-001	Code de Déontologie Novaryn Tech	2014-04-23	COMP	1.50	89.02	109.92	COMPLIANCE
1187	K8S-001	Kubernetes Fundamentals	2025-05-28	FAIL	24.00	46.42	945.93	ELEARN
1187	PYTHON-001	Python for Data Science	2023-12-13	COMP	24.00	61.09	1049.46	ELEARN
1187	SAFE-001	SAFe Agile Practitioner	2025-12-18	COMP	16.00	92.38	1202.75	COURSE
1187	AZURE-001	Microsoft Azure Fundamentals	2022-07-27	COMP	28.00	90.30	1747.83	ELEARN
1188	GDPR-001	RGPD & Protection des Données	2023-06-07	COMP	2.00	72.43	207.52	COMPLIANCE
1188	HEALTH-001	Santé & Sécurité au Travail	2023-05-31	COMP	4.00	98.59	229.91	COMPLIANCE
1188	FIRE-001	Sécurité & Évacuation Incendie	2023-06-20	COMP	1.00	96.83	102.95	COMPLIANCE
1188	DEI-001	Égalité Femmes-Hommes	2023-05-04	COMP	3.00	93.62	188.94	COMPLIANCE
1188	FRAUD-001	Prévention Fraude & Corruption	2023-06-08	COMP	2.00	70.78	139.49	COMPLIANCE
1188	ETHICS-001	Code de Déontologie Novaryn Tech	2023-05-23	COMP	1.50	79.39	124.13	COMPLIANCE
1188	EXCEL-001	Excel Avancé & Reporting	2025-04-17	COMP	8.00	92.51	412.04	ELEARN
1188	AZURE-001	Microsoft Azure Fundamentals	2024-01-20	COMP	28.00	79.07	1595.75	ELEARN
1188	COMM-001	Communication & Public Speaking	2024-02-25	FAIL	8.00	41.46	361.09	OJT
1188	PYTHON-001	Python for Data Science	2026-06-11	ENR	24.00	0.00	1036.50	ELEARN
1189	GDPR-001	RGPD & Protection des Données	2024-10-01	COMP	2.00	79.42	198.75	COMPLIANCE
1189	HEALTH-001	Santé & Sécurité au Travail	2024-10-31	COMP	4.00	83.04	226.31	COMPLIANCE
1189	FIRE-001	Sécurité & Évacuation Incendie	2024-11-06	COMP	1.00	71.47	103.24	COMPLIANCE
1189	DEI-001	Égalité Femmes-Hommes	2024-10-14	COMP	3.00	81.34	184.92	COMPLIANCE
1189	FRAUD-001	Prévention Fraude & Corruption	2024-10-04	COMP	2.00	80.84	150.48	COMPLIANCE
1189	ETHICS-001	Code de Déontologie Novaryn Tech	2024-11-01	COMP	1.50	74.50	117.07	COMPLIANCE
1189	AWS-001	AWS Cloud Practitioner	2025-12-23	COMP	30.00	70.78	1653.04	ELEARN
1189	REACT-001	React & TypeScript Masterclass	2025-01-04	COMP	36.00	86.45	1151.84	ELEARN
1191	GDPR-001	RGPD & Protection des Données	2021-06-25	COMP	2.00	75.11	203.07	COMPLIANCE
1191	HEALTH-001	Santé & Sécurité au Travail	2021-06-19	COMP	4.00	71.26	260.71	COMPLIANCE
1191	FIRE-001	Sécurité & Évacuation Incendie	2021-06-13	COMP	1.00	84.09	98.13	COMPLIANCE
1191	DEI-001	Égalité Femmes-Hommes	2021-05-19	COMP	3.00	82.31	192.82	COMPLIANCE
1191	FRAUD-001	Prévention Fraude & Corruption	2021-06-08	COMP	2.00	83.80	145.65	COMPLIANCE
1191	ETHICS-001	Code de Déontologie Novaryn Tech	2021-05-05	COMP	1.50	93.17	126.69	COMPLIANCE
1191	PYTHON-001	Python for Data Science	2024-02-26	COMP	24.00	61.88	886.72	ELEARN
1191	LEAD-001	Leadership & Management	2025-10-03	COMP	20.00	93.40	1330.92	COURSE
1191	SCRUM-001	Scrum Fundamentals	2022-07-21	COMP	12.00	81.17	510.89	ELEARN
1192	GDPR-001	RGPD & Protection des Données	2017-01-03	COMP	2.00	92.00	218.49	COMPLIANCE
1192	HEALTH-001	Santé & Sécurité au Travail	2017-01-04	COMP	4.00	75.32	272.42	COMPLIANCE
1192	FIRE-001	Sécurité & Évacuation Incendie	2016-12-25	COMP	1.00	96.41	94.98	COMPLIANCE
1192	DEI-001	Égalité Femmes-Hommes	2016-12-06	COMP	3.00	81.34	189.50	COMPLIANCE
1192	FRAUD-001	Prévention Fraude & Corruption	2016-12-27	COMP	2.00	89.43	146.99	COMPLIANCE
1192	ETHICS-001	Code de Déontologie Novaryn Tech	2016-12-09	COMP	1.50	74.65	109.57	COMPLIANCE
1192	PM-001	Product Management Essentials	2020-10-28	COMP	20.00	86.78	1283.00	COURSE
1192	SAFE-001	SAFe Agile Practitioner	2021-12-30	COMP	16.00	66.34	1291.94	COURSE
1192	AZURE-001	Microsoft Azure Fundamentals	2024-07-28	COMP	28.00	88.68	1536.76	ELEARN
1192	PYTHON-001	Python for Data Science	2026-06-14	ENR	24.00	0.00	979.27	ELEARN
1192	ML-001	Machine Learning Fundamentals	2023-04-22	COMP	40.00	98.43	1480.89	ELEARN
1193	GDPR-001	RGPD & Protection des Données	2025-06-19	COMP	2.00	96.20	212.88	COMPLIANCE
1193	HEALTH-001	Santé & Sécurité au Travail	2025-06-08	COMP	4.00	98.36	256.58	COMPLIANCE
1193	FIRE-001	Sécurité & Évacuation Incendie	2025-05-31	COMP	1.00	80.64	105.01	COMPLIANCE
1193	DEI-001	Égalité Femmes-Hommes	2025-07-08	COMP	3.00	78.72	193.44	COMPLIANCE
1193	FRAUD-001	Prévention Fraude & Corruption	2025-06-01	COMP	2.00	82.10	141.87	COMPLIANCE
1193	ETHICS-001	Code de Déontologie Novaryn Tech	2025-07-03	COMP	1.50	81.07	121.04	COMPLIANCE
1193	AZURE-001	Microsoft Azure Fundamentals	2025-11-08	COMP	28.00	78.79	1507.71	ELEARN
1193	AWS-001	AWS Cloud Practitioner	2026-05-15	ENR	30.00	0.00	1807.01	ELEARN
1193	SCRUM-001	Scrum Fundamentals	2025-12-20	FAIL	12.00	50.08	674.93	ELEARN
1194	GDPR-001	RGPD & Protection des Données	2023-02-28	COMP	2.00	93.16	209.23	COMPLIANCE
1194	HEALTH-001	Santé & Sécurité au Travail	2023-03-22	COMP	4.00	77.24	259.87	COMPLIANCE
1194	FIRE-001	Sécurité & Évacuation Incendie	2023-04-01	COMP	1.00	75.35	109.65	COMPLIANCE
1194	DEI-001	Égalité Femmes-Hommes	2023-03-20	COMP	3.00	91.76	166.83	COMPLIANCE
1194	FRAUD-001	Prévention Fraude & Corruption	2023-04-07	COMP	2.00	94.95	136.85	COMPLIANCE
1194	ETHICS-001	Code de Déontologie Novaryn Tech	2023-04-12	COMP	1.50	80.20	114.95	COMPLIANCE
1194	AZURE-001	Microsoft Azure Fundamentals	2025-09-06	COMP	28.00	68.65	1825.47	ELEARN
1194	AWS-001	AWS Cloud Practitioner	2026-05-02	ENR	30.00	0.00	1977.40	ELEARN
1196	GDPR-001	RGPD & Protection des Données	2015-09-12	COMP	2.00	87.61	215.34	COMPLIANCE
1196	HEALTH-001	Santé & Sécurité au Travail	2015-09-03	COMP	4.00	81.84	236.09	COMPLIANCE
1196	FIRE-001	Sécurité & Évacuation Incendie	2015-09-05	COMP	1.00	94.18	91.80	COMPLIANCE
1196	DEI-001	Égalité Femmes-Hommes	2015-10-11	COMP	3.00	88.00	180.94	COMPLIANCE
1196	FRAUD-001	Prévention Fraude & Corruption	2015-10-12	COMP	2.00	96.36	138.71	COMPLIANCE
1196	ETHICS-001	Code de Déontologie Novaryn Tech	2015-08-30	COMP	1.50	88.19	112.77	COMPLIANCE
1196	SAFE-001	SAFe Agile Practitioner	2024-12-29	COMP	16.00	68.67	1360.10	COURSE
1196	EXCEL-001	Excel Avancé & Reporting	2021-04-25	COMP	8.00	69.03	445.89	ELEARN
1197	GDPR-001	RGPD & Protection des Données	2025-07-12	COMP	2.00	91.70	218.25	COMPLIANCE
1197	HEALTH-001	Santé & Sécurité au Travail	2025-08-27	COMP	4.00	88.36	250.24	COMPLIANCE
1197	FIRE-001	Sécurité & Évacuation Incendie	2025-08-27	COMP	1.00	98.85	109.83	COMPLIANCE
1197	DEI-001	Égalité Femmes-Hommes	2025-07-16	COMP	3.00	83.85	180.02	COMPLIANCE
1197	FRAUD-001	Prévention Fraude & Corruption	2025-08-05	COMP	2.00	93.37	156.61	COMPLIANCE
1197	ETHICS-001	Code de Déontologie Novaryn Tech	2025-08-12	COMP	1.50	96.75	108.26	COMPLIANCE
1197	AWS-001	AWS Cloud Practitioner	2025-12-25	COMP	30.00	73.38	1754.11	ELEARN
1197	SCRUM-001	Scrum Fundamentals	2025-11-10	COMP	12.00	93.50	604.30	ELEARN
1197	COMM-001	Communication & Public Speaking	2025-12-03	COMP	8.00	87.54	380.06	OJT
1198	GDPR-001	RGPD & Protection des Données	2013-07-27	COMP	2.00	91.09	190.56	COMPLIANCE
1198	HEALTH-001	Santé & Sécurité au Travail	2013-07-05	COMP	4.00	94.69	254.80	COMPLIANCE
1198	FIRE-001	Sécurité & Évacuation Incendie	2013-08-02	COMP	1.00	97.24	108.33	COMPLIANCE
1198	DEI-001	Égalité Femmes-Hommes	2013-07-26	COMP	3.00	90.40	176.10	COMPLIANCE
1198	FRAUD-001	Prévention Fraude & Corruption	2013-07-26	COMP	2.00	93.76	139.02	COMPLIANCE
1198	ETHICS-001	Code de Déontologie Novaryn Tech	2013-06-20	COMP	1.50	72.29	122.49	COMPLIANCE
1198	ML-001	Machine Learning Fundamentals	2026-05-14	ENR	40.00	0.00	1412.25	ELEARN
1198	SAFE-001	SAFe Agile Practitioner	2024-02-29	COMP	16.00	69.25	1412.55	COURSE
1199	GDPR-001	RGPD & Protection des Données	2023-05-16	COMP	2.00	95.14	203.46	COMPLIANCE
1199	HEALTH-001	Santé & Sécurité au Travail	2023-06-12	COMP	4.00	99.91	234.74	COMPLIANCE
1199	FIRE-001	Sécurité & Évacuation Incendie	2023-06-16	COMP	1.00	91.69	108.83	COMPLIANCE
1199	DEI-001	Égalité Femmes-Hommes	2023-06-02	COMP	3.00	88.06	167.32	COMPLIANCE
1199	FRAUD-001	Prévention Fraude & Corruption	2023-05-10	COMP	2.00	83.54	145.06	COMPLIANCE
1199	ETHICS-001	Code de Déontologie Novaryn Tech	2023-05-21	COMP	1.50	72.30	114.12	COMPLIANCE
1199	COMM-001	Communication & Public Speaking	2026-05-15	ENR	8.00	0.00	355.61	OJT
1199	EXCEL-001	Excel Avancé & Reporting	2024-09-23	COMP	8.00	97.63	345.14	ELEARN
1200	GDPR-001	RGPD & Protection des Données	2026-01-02	COMP	2.00	88.91	211.12	COMPLIANCE
1200	HEALTH-001	Santé & Sécurité au Travail	2025-12-31	COMP	4.00	77.13	271.78	COMPLIANCE
1200	FIRE-001	Sécurité & Évacuation Incendie	2026-01-06	COMP	1.00	83.06	105.81	COMPLIANCE
1200	DEI-001	Égalité Femmes-Hommes	2025-12-12	COMP	3.00	85.58	165.46	COMPLIANCE
1200	FRAUD-001	Prévention Fraude & Corruption	2026-01-26	COMP	2.00	73.86	158.41	COMPLIANCE
1200	ETHICS-001	Code de Déontologie Novaryn Tech	2025-12-11	COMP	1.50	98.17	130.65	COMPLIANCE
1200	ML-001	Machine Learning Fundamentals	2025-12-31	COMP	40.00	75.91	1651.57	ELEARN
1200	AWS-001	AWS Cloud Practitioner	2026-04-11	ENR	30.00	0.00	1738.59	ELEARN
1201	GDPR-001	RGPD & Protection des Données	2017-06-01	COMP	2.00	83.67	192.82	COMPLIANCE
1201	HEALTH-001	Santé & Sécurité au Travail	2017-06-05	COMP	4.00	76.39	272.64	COMPLIANCE
1201	FIRE-001	Sécurité & Évacuation Incendie	2017-06-07	COMP	1.00	76.56	107.95	COMPLIANCE
1201	DEI-001	Égalité Femmes-Hommes	2017-05-11	COMP	3.00	71.56	177.47	COMPLIANCE
1201	FRAUD-001	Prévention Fraude & Corruption	2017-05-24	COMP	2.00	75.50	152.16	COMPLIANCE
1201	ETHICS-001	Code de Déontologie Novaryn Tech	2017-05-20	COMP	1.50	88.79	119.65	COMPLIANCE
1201	PM-001	Product Management Essentials	2026-05-15	ENR	20.00	0.00	1289.88	COURSE
1201	AWS-001	AWS Cloud Practitioner	2025-11-14	COMP	30.00	69.68	2014.03	ELEARN
1201	ML-001	Machine Learning Fundamentals	2023-02-25	COMP	40.00	81.11	1574.77	ELEARN
1202	GDPR-001	RGPD & Protection des Données	2014-07-23	COMP	2.00	80.28	189.50	COMPLIANCE
1202	HEALTH-001	Santé & Sécurité au Travail	2014-08-22	COMP	4.00	97.38	261.83	COMPLIANCE
1202	FIRE-001	Sécurité & Évacuation Incendie	2014-08-13	COMP	1.00	74.09	90.92	COMPLIANCE
1202	DEI-001	Égalité Femmes-Hommes	2014-07-25	COMP	3.00	89.35	184.12	COMPLIANCE
1202	FRAUD-001	Prévention Fraude & Corruption	2014-07-18	COMP	2.00	71.60	155.01	COMPLIANCE
1202	ETHICS-001	Code de Déontologie Novaryn Tech	2014-08-08	COMP	1.50	90.73	108.43	COMPLIANCE
1202	ML-001	Machine Learning Fundamentals	2021-11-06	FAIL	40.00	51.04	1391.12	ELEARN
1202	SQL-001	Advanced SQL for Analytics	2023-10-09	COMP	16.00	82.96	904.39	ELEARN
1203	GDPR-001	RGPD & Protection des Données	2016-04-22	COMP	2.00	99.86	219.68	COMPLIANCE
1203	HEALTH-001	Santé & Sécurité au Travail	2016-04-14	COMP	4.00	94.22	245.14	COMPLIANCE
1203	FIRE-001	Sécurité & Évacuation Incendie	2016-04-15	COMP	1.00	91.18	102.48	COMPLIANCE
1203	DEI-001	Égalité Femmes-Hommes	2016-04-17	COMP	3.00	82.62	184.48	COMPLIANCE
1203	FRAUD-001	Prévention Fraude & Corruption	2016-04-28	COMP	2.00	81.28	158.42	COMPLIANCE
1203	ETHICS-001	Code de Déontologie Novaryn Tech	2016-03-26	COMP	1.50	94.91	123.40	COMPLIANCE
1203	LEAD-001	Leadership & Management	2026-06-21	ENR	20.00	0.00	1447.84	COURSE
1203	ML-001	Machine Learning Fundamentals	2022-01-03	FAIL	40.00	44.72	1518.57	ELEARN
1203	AZURE-001	Microsoft Azure Fundamentals	2023-01-31	COMP	28.00	60.85	1600.21	ELEARN
1203	PYTHON-001	Python for Data Science	2020-11-04	COMP	24.00	84.75	1142.46	ELEARN
1203	COMM-001	Communication & Public Speaking	2025-10-31	COMP	8.00	67.00	362.85	OJT
1204	GDPR-001	RGPD & Protection des Données	2025-02-14	COMP	2.00	95.18	212.28	COMPLIANCE
1204	HEALTH-001	Santé & Sécurité au Travail	2025-02-17	COMP	4.00	78.83	232.06	COMPLIANCE
1204	FIRE-001	Sécurité & Évacuation Incendie	2025-03-02	COMP	1.00	82.13	101.20	COMPLIANCE
1204	DEI-001	Égalité Femmes-Hommes	2025-02-06	COMP	3.00	82.23	187.19	COMPLIANCE
1204	FRAUD-001	Prévention Fraude & Corruption	2025-03-10	COMP	2.00	84.19	146.94	COMPLIANCE
1204	ETHICS-001	Code de Déontologie Novaryn Tech	2025-02-10	COMP	1.50	83.72	118.02	COMPLIANCE
1204	SAFE-001	SAFe Agile Practitioner	2025-09-16	COMP	16.00	68.64	1425.90	COURSE
1204	K8S-001	Kubernetes Fundamentals	2025-11-24	FAIL	24.00	44.33	1135.22	ELEARN
1205	GDPR-001	RGPD & Protection des Données	2019-02-15	COMP	2.00	90.10	204.10	COMPLIANCE
1205	HEALTH-001	Santé & Sécurité au Travail	2019-02-18	COMP	4.00	89.51	269.93	COMPLIANCE
1205	FIRE-001	Sécurité & Évacuation Incendie	2019-02-28	COMP	1.00	74.16	107.94	COMPLIANCE
1205	DEI-001	Égalité Femmes-Hommes	2019-03-15	COMP	3.00	70.52	191.48	COMPLIANCE
1205	FRAUD-001	Prévention Fraude & Corruption	2019-02-13	COMP	2.00	94.84	161.92	COMPLIANCE
1205	ETHICS-001	Code de Déontologie Novaryn Tech	2019-02-21	COMP	1.50	96.62	110.83	COMPLIANCE
1205	COMM-001	Communication & Public Speaking	2025-06-26	COMP	8.00	61.20	436.55	OJT
1205	PM-001	Product Management Essentials	2026-05-29	ENR	20.00	0.00	1232.58	COURSE
1205	EXCEL-001	Excel Avancé & Reporting	2020-07-07	COMP	8.00	87.06	392.10	ELEARN
1206	GDPR-001	RGPD & Protection des Données	2023-11-29	COMP	2.00	72.80	202.02	COMPLIANCE
1206	HEALTH-001	Santé & Sécurité au Travail	2023-12-18	COMP	4.00	81.35	245.35	COMPLIANCE
1206	FIRE-001	Sécurité & Évacuation Incendie	2023-11-16	COMP	1.00	97.70	94.33	COMPLIANCE
1206	DEI-001	Égalité Femmes-Hommes	2023-12-17	COMP	3.00	84.46	177.33	COMPLIANCE
1206	FRAUD-001	Prévention Fraude & Corruption	2023-12-25	COMP	2.00	94.92	161.47	COMPLIANCE
1206	ETHICS-001	Code de Déontologie Novaryn Tech	2023-12-31	COMP	1.50	75.71	120.68	COMPLIANCE
1206	EXCEL-001	Excel Avancé & Reporting	2026-05-29	ENR	8.00	0.00	404.98	ELEARN
1206	LEAD-001	Leadership & Management	2024-09-04	COMP	20.00	91.85	1414.83	COURSE
1206	AZURE-001	Microsoft Azure Fundamentals	2024-06-29	COMP	28.00	85.04	1379.47	ELEARN
1206	AWS-001	AWS Cloud Practitioner	2024-05-07	COMP	30.00	98.37	1788.35	ELEARN
1207	GDPR-001	RGPD & Protection des Données	2018-11-09	COMP	2.00	70.03	206.71	COMPLIANCE
1207	HEALTH-001	Santé & Sécurité au Travail	2018-11-27	COMP	4.00	83.03	244.53	COMPLIANCE
1207	FIRE-001	Sécurité & Évacuation Incendie	2018-11-19	COMP	1.00	71.88	91.10	COMPLIANCE
1207	DEI-001	Égalité Femmes-Hommes	2018-12-18	COMP	3.00	99.39	175.94	COMPLIANCE
1207	FRAUD-001	Prévention Fraude & Corruption	2018-11-07	COMP	2.00	72.25	155.05	COMPLIANCE
1207	ETHICS-001	Code de Déontologie Novaryn Tech	2018-12-17	COMP	1.50	88.36	127.77	COMPLIANCE
1207	SCRUM-001	Scrum Fundamentals	2023-11-13	COMP	12.00	62.24	626.69	ELEARN
1207	LEAD-001	Leadership & Management	2020-10-11	COMP	20.00	85.19	1307.92	COURSE
1208	GDPR-001	RGPD & Protection des Données	2023-04-23	COMP	2.00	79.64	198.13	COMPLIANCE
1208	HEALTH-001	Santé & Sécurité au Travail	2023-04-25	COMP	4.00	75.32	256.48	COMPLIANCE
1208	FIRE-001	Sécurité & Évacuation Incendie	2023-03-19	COMP	1.00	96.16	108.99	COMPLIANCE
1208	DEI-001	Égalité Femmes-Hommes	2023-04-17	COMP	3.00	82.33	167.17	COMPLIANCE
1208	FRAUD-001	Prévention Fraude & Corruption	2023-04-22	COMP	2.00	81.05	154.13	COMPLIANCE
1208	ETHICS-001	Code de Déontologie Novaryn Tech	2023-03-24	COMP	1.50	70.50	119.89	COMPLIANCE
1208	PM-001	Product Management Essentials	2026-06-04	ENR	20.00	0.00	1338.76	COURSE
1208	AZURE-001	Microsoft Azure Fundamentals	2026-05-30	ENR	28.00	0.00	1682.27	ELEARN
1208	REACT-001	React & TypeScript Masterclass	2023-07-01	COMP	36.00	73.78	1219.97	ELEARN
1208	PYTHON-001	Python for Data Science	2023-08-15	COMP	24.00	94.90	1067.50	ELEARN
1208	SCRUM-001	Scrum Fundamentals	2026-05-27	ENR	12.00	0.00	676.16	ELEARN
1209	GDPR-001	RGPD & Protection des Données	2025-02-22	COMP	2.00	86.96	217.30	COMPLIANCE
1209	HEALTH-001	Santé & Sécurité au Travail	2025-02-16	COMP	4.00	93.07	238.18	COMPLIANCE
1209	FIRE-001	Sécurité & Évacuation Incendie	2025-03-09	COMP	1.00	98.10	103.49	COMPLIANCE
1209	DEI-001	Égalité Femmes-Hommes	2025-02-28	COMP	3.00	72.01	169.03	COMPLIANCE
1209	FRAUD-001	Prévention Fraude & Corruption	2025-02-24	COMP	2.00	83.62	137.68	COMPLIANCE
1209	ETHICS-001	Code de Déontologie Novaryn Tech	2025-02-20	COMP	1.50	98.63	115.54	COMPLIANCE
1209	AWS-001	AWS Cloud Practitioner	2025-08-08	COMP	30.00	81.79	1572.74	ELEARN
1209	SQL-001	Advanced SQL for Analytics	2025-06-23	COMP	16.00	93.98	895.79	ELEARN
1209	REACT-001	React & TypeScript Masterclass	2025-12-11	COMP	36.00	64.07	1237.05	ELEARN
1211	GDPR-001	RGPD & Protection des Données	2025-09-12	COMP	2.00	81.39	188.75	COMPLIANCE
1211	HEALTH-001	Santé & Sécurité au Travail	2025-10-09	COMP	4.00	77.14	250.66	COMPLIANCE
1211	FIRE-001	Sécurité & Évacuation Incendie	2025-10-24	COMP	1.00	79.53	99.35	COMPLIANCE
1211	DEI-001	Égalité Femmes-Hommes	2025-10-16	COMP	3.00	87.20	174.42	COMPLIANCE
1211	FRAUD-001	Prévention Fraude & Corruption	2025-09-19	COMP	2.00	75.71	148.42	COMPLIANCE
1211	ETHICS-001	Code de Déontologie Novaryn Tech	2025-10-24	COMP	1.50	86.36	115.37	COMPLIANCE
1211	COMM-001	Communication & Public Speaking	2026-05-19	ENR	8.00	0.00	345.73	OJT
1211	PYTHON-001	Python for Data Science	2026-05-15	ENR	24.00	0.00	1003.08	ELEARN
1212	GDPR-001	RGPD & Protection des Données	2013-01-06	COMP	2.00	72.84	191.02	COMPLIANCE
1212	HEALTH-001	Santé & Sécurité au Travail	2012-11-18	COMP	4.00	77.10	235.24	COMPLIANCE
1212	FIRE-001	Sécurité & Évacuation Incendie	2012-12-01	COMP	1.00	94.96	97.97	COMPLIANCE
1212	DEI-001	Égalité Femmes-Hommes	2012-12-19	COMP	3.00	73.25	167.10	COMPLIANCE
1212	FRAUD-001	Prévention Fraude & Corruption	2012-12-14	COMP	2.00	92.23	149.99	COMPLIANCE
1212	ETHICS-001	Code de Déontologie Novaryn Tech	2012-12-17	COMP	1.50	75.11	112.48	COMPLIANCE
1212	PYTHON-001	Python for Data Science	2024-09-17	COMP	24.00	79.66	1096.19	ELEARN
1212	SAFE-001	SAFe Agile Practitioner	2021-10-05	COMP	16.00	67.30	1453.87	COURSE
1213	GDPR-001	RGPD & Protection des Données	2019-10-30	COMP	2.00	85.58	218.95	COMPLIANCE
1213	HEALTH-001	Santé & Sécurité au Travail	2019-10-24	COMP	4.00	87.18	242.01	COMPLIANCE
1213	FIRE-001	Sécurité & Évacuation Incendie	2019-12-06	COMP	1.00	84.74	104.62	COMPLIANCE
1213	DEI-001	Égalité Femmes-Hommes	2019-11-21	COMP	3.00	83.14	189.28	COMPLIANCE
1213	FRAUD-001	Prévention Fraude & Corruption	2019-12-05	COMP	2.00	76.95	159.68	COMPLIANCE
1213	ETHICS-001	Code de Déontologie Novaryn Tech	2019-10-29	COMP	1.50	96.30	128.35	COMPLIANCE
1213	ML-001	Machine Learning Fundamentals	2024-12-30	COMP	40.00	73.54	1634.76	ELEARN
1213	SAFE-001	SAFe Agile Practitioner	2021-11-05	COMP	16.00	89.55	1396.99	COURSE
1213	SQL-001	Advanced SQL for Analytics	2026-06-16	ENR	16.00	0.00	852.60	ELEARN
1214	GDPR-001	RGPD & Protection des Données	2023-06-14	COMP	2.00	82.08	217.08	COMPLIANCE
1214	HEALTH-001	Santé & Sécurité au Travail	2023-05-25	COMP	4.00	83.61	260.01	COMPLIANCE
1214	FIRE-001	Sécurité & Évacuation Incendie	2023-06-12	COMP	1.00	95.83	99.93	COMPLIANCE
1214	DEI-001	Égalité Femmes-Hommes	2023-06-12	COMP	3.00	85.55	191.07	COMPLIANCE
1214	FRAUD-001	Prévention Fraude & Corruption	2023-07-07	COMP	2.00	70.46	157.94	COMPLIANCE
1214	ETHICS-001	Code de Déontologie Novaryn Tech	2023-06-11	COMP	1.50	86.22	110.02	COMPLIANCE
1214	PYTHON-001	Python for Data Science	2024-12-31	COMP	24.00	86.96	875.86	ELEARN
1214	AWS-001	AWS Cloud Practitioner	2024-03-25	COMP	30.00	94.94	1727.66	ELEARN
1214	SAFE-001	SAFe Agile Practitioner	2026-06-16	ENR	16.00	0.00	1605.33	COURSE
1215	GDPR-001	RGPD & Protection des Données	2019-07-26	COMP	2.00	90.60	196.20	COMPLIANCE
1215	HEALTH-001	Santé & Sécurité au Travail	2019-07-29	COMP	4.00	91.97	251.14	COMPLIANCE
1215	FIRE-001	Sécurité & Évacuation Incendie	2019-09-07	COMP	1.00	98.11	91.46	COMPLIANCE
1215	DEI-001	Égalité Femmes-Hommes	2019-08-25	COMP	3.00	74.16	182.44	COMPLIANCE
1215	FRAUD-001	Prévention Fraude & Corruption	2019-08-18	COMP	2.00	92.65	163.65	COMPLIANCE
1215	ETHICS-001	Code de Déontologie Novaryn Tech	2019-08-24	COMP	1.50	87.72	126.54	COMPLIANCE
1215	AWS-001	AWS Cloud Practitioner	2022-05-11	COMP	30.00	91.33	1998.76	ELEARN
1215	REACT-001	React & TypeScript Masterclass	2021-03-25	FAIL	36.00	42.41	1350.69	ELEARN
1215	PM-001	Product Management Essentials	2026-04-12	ENR	20.00	0.00	1362.50	COURSE
1215	SAFE-001	SAFe Agile Practitioner	2024-08-05	COMP	16.00	69.19	1543.54	COURSE
1216	GDPR-001	RGPD & Protection des Données	2021-05-31	COMP	2.00	99.25	203.93	COMPLIANCE
1216	HEALTH-001	Santé & Sécurité au Travail	2021-06-17	COMP	4.00	77.52	273.45	COMPLIANCE
1216	FIRE-001	Sécurité & Évacuation Incendie	2021-06-14	COMP	1.00	73.90	107.65	COMPLIANCE
1216	DEI-001	Égalité Femmes-Hommes	2021-05-25	COMP	3.00	95.38	183.95	COMPLIANCE
1216	FRAUD-001	Prévention Fraude & Corruption	2021-06-08	COMP	2.00	88.89	154.42	COMPLIANCE
1216	ETHICS-001	Code de Déontologie Novaryn Tech	2021-05-22	COMP	1.50	80.40	123.03	COMPLIANCE
1216	EXCEL-001	Excel Avancé & Reporting	2023-09-12	COMP	8.00	67.16	447.42	ELEARN
1216	SCRUM-001	Scrum Fundamentals	2023-01-19	COMP	12.00	75.62	545.28	ELEARN
1216	SAFE-001	SAFe Agile Practitioner	2026-07-01	ENR	16.00	0.00	1268.44	COURSE
1216	K8S-001	Kubernetes Fundamentals	2021-10-14	FAIL	24.00	48.59	1060.55	ELEARN
1216	LEAD-001	Leadership & Management	2022-09-08	COMP	20.00	84.56	1598.73	COURSE
1217	GDPR-001	RGPD & Protection des Données	2024-10-13	COMP	2.00	99.20	199.80	COMPLIANCE
1217	HEALTH-001	Santé & Sécurité au Travail	2024-10-05	COMP	4.00	84.77	252.10	COMPLIANCE
1217	FIRE-001	Sécurité & Évacuation Incendie	2024-10-10	COMP	1.00	87.24	98.73	COMPLIANCE
1217	DEI-001	Égalité Femmes-Hommes	2024-10-02	COMP	3.00	91.56	167.54	COMPLIANCE
1217	FRAUD-001	Prévention Fraude & Corruption	2024-10-24	COMP	2.00	73.88	150.48	COMPLIANCE
1217	ETHICS-001	Code de Déontologie Novaryn Tech	2024-09-13	COMP	1.50	84.82	125.99	COMPLIANCE
1217	SAFE-001	SAFe Agile Practitioner	2024-12-04	COMP	16.00	87.29	1522.81	COURSE
1217	ML-001	Machine Learning Fundamentals	2025-08-28	COMP	40.00	87.82	1783.85	ELEARN
1217	SCRUM-001	Scrum Fundamentals	2025-05-26	COMP	12.00	94.71	646.00	ELEARN
1217	REACT-001	React & TypeScript Masterclass	2025-08-01	COMP	36.00	89.11	1139.48	ELEARN
1218	GDPR-001	RGPD & Protection des Données	2016-07-04	COMP	2.00	87.08	181.23	COMPLIANCE
1218	HEALTH-001	Santé & Sécurité au Travail	2016-06-12	COMP	4.00	75.04	269.99	COMPLIANCE
1218	FIRE-001	Sécurité & Évacuation Incendie	2016-06-16	COMP	1.00	93.35	96.85	COMPLIANCE
1218	DEI-001	Égalité Femmes-Hommes	2016-06-28	COMP	3.00	78.05	168.57	COMPLIANCE
1218	FRAUD-001	Prévention Fraude & Corruption	2016-07-08	COMP	2.00	81.80	152.81	COMPLIANCE
1218	ETHICS-001	Code de Déontologie Novaryn Tech	2016-06-17	COMP	1.50	74.21	127.84	COMPLIANCE
1218	PYTHON-001	Python for Data Science	2020-02-19	COMP	24.00	89.57	1104.02	ELEARN
1218	SAFE-001	SAFe Agile Practitioner	2026-05-06	ENR	16.00	0.00	1553.84	COURSE
1218	AWS-001	AWS Cloud Practitioner	2022-04-04	COMP	30.00	98.42	2028.84	ELEARN
1218	EXCEL-001	Excel Avancé & Reporting	2020-06-11	FAIL	8.00	46.46	359.73	ELEARN
1219	GDPR-001	RGPD & Protection des Données	2016-10-01	COMP	2.00	90.53	216.64	COMPLIANCE
1219	HEALTH-001	Santé & Sécurité au Travail	2016-10-07	COMP	4.00	85.99	241.89	COMPLIANCE
1219	FIRE-001	Sécurité & Évacuation Incendie	2016-10-26	COMP	1.00	75.34	108.90	COMPLIANCE
1219	DEI-001	Égalité Femmes-Hommes	2016-10-20	COMP	3.00	75.03	182.72	COMPLIANCE
1219	FRAUD-001	Prévention Fraude & Corruption	2016-10-21	COMP	2.00	98.38	141.65	COMPLIANCE
1219	ETHICS-001	Code de Déontologie Novaryn Tech	2016-11-09	COMP	1.50	76.67	120.71	COMPLIANCE
1219	LEAD-001	Leadership & Management	2021-01-28	COMP	20.00	75.65	1439.61	COURSE
1219	AWS-001	AWS Cloud Practitioner	2023-07-31	FAIL	30.00	49.30	1671.94	ELEARN
1219	ML-001	Machine Learning Fundamentals	2024-06-22	COMP	40.00	94.00	1515.70	ELEARN
1219	EXCEL-001	Excel Avancé & Reporting	2020-12-19	COMP	8.00	90.24	432.76	ELEARN
1220	GDPR-001	RGPD & Protection des Données	2016-02-20	COMP	2.00	94.75	188.97	COMPLIANCE
1220	HEALTH-001	Santé & Sécurité au Travail	2016-02-14	COMP	4.00	79.20	256.16	COMPLIANCE
1220	FIRE-001	Sécurité & Évacuation Incendie	2016-03-16	COMP	1.00	96.82	106.49	COMPLIANCE
1220	DEI-001	Égalité Femmes-Hommes	2016-02-06	COMP	3.00	97.79	166.08	COMPLIANCE
1220	FRAUD-001	Prévention Fraude & Corruption	2016-03-03	COMP	2.00	87.97	139.94	COMPLIANCE
1220	ETHICS-001	Code de Déontologie Novaryn Tech	2016-02-14	COMP	1.50	85.65	124.91	COMPLIANCE
1220	AZURE-001	Microsoft Azure Fundamentals	2026-05-04	ENR	28.00	0.00	1549.37	ELEARN
1220	SCRUM-001	Scrum Fundamentals	2024-01-19	COMP	12.00	71.75	529.35	ELEARN
1220	LEAD-001	Leadership & Management	2026-05-03	ENR	20.00	0.00	1323.25	COURSE
1221	GDPR-001	RGPD & Protection des Données	2013-06-18	COMP	2.00	75.21	204.78	COMPLIANCE
1221	HEALTH-001	Santé & Sécurité au Travail	2013-05-16	COMP	4.00	94.53	248.79	COMPLIANCE
1221	FIRE-001	Sécurité & Évacuation Incendie	2013-06-05	COMP	1.00	72.92	105.98	COMPLIANCE
1221	DEI-001	Égalité Femmes-Hommes	2013-05-31	COMP	3.00	95.55	163.65	COMPLIANCE
1221	FRAUD-001	Prévention Fraude & Corruption	2013-06-11	COMP	2.00	77.97	160.40	COMPLIANCE
1221	ETHICS-001	Code de Déontologie Novaryn Tech	2013-06-16	COMP	1.50	95.93	127.26	COMPLIANCE
1221	EXCEL-001	Excel Avancé & Reporting	2023-01-29	COMP	8.00	75.32	403.51	ELEARN
1221	LEAD-001	Leadership & Management	2024-05-13	FAIL	20.00	53.23	1510.67	COURSE
1221	SCRUM-001	Scrum Fundamentals	2025-01-18	COMP	12.00	84.20	660.28	ELEARN
1221	SQL-001	Advanced SQL for Analytics	2026-04-08	ENR	16.00	0.00	745.20	ELEARN
1222	GDPR-001	RGPD & Protection des Données	2016-08-30	COMP	2.00	77.05	200.57	COMPLIANCE
1222	HEALTH-001	Santé & Sécurité au Travail	2016-09-26	COMP	4.00	95.69	242.42	COMPLIANCE
1222	FIRE-001	Sécurité & Évacuation Incendie	2016-09-01	COMP	1.00	96.71	108.70	COMPLIANCE
1222	DEI-001	Égalité Femmes-Hommes	2016-09-26	COMP	3.00	94.27	191.14	COMPLIANCE
1222	FRAUD-001	Prévention Fraude & Corruption	2016-09-18	COMP	2.00	82.48	163.67	COMPLIANCE
1222	ETHICS-001	Code de Déontologie Novaryn Tech	2016-10-10	COMP	1.50	87.51	117.97	COMPLIANCE
1222	ML-001	Machine Learning Fundamentals	2023-11-05	COMP	40.00	88.24	1604.90	ELEARN
1222	K8S-001	Kubernetes Fundamentals	2024-04-14	FAIL	24.00	56.97	1027.27	ELEARN
1222	AZURE-001	Microsoft Azure Fundamentals	2021-11-19	COMP	28.00	89.32	1562.54	ELEARN
1222	SAFE-001	SAFe Agile Practitioner	2025-03-26	COMP	16.00	94.67	1520.80	COURSE
1222	PYTHON-001	Python for Data Science	2026-05-14	ENR	24.00	0.00	903.33	ELEARN
1223	GDPR-001	RGPD & Protection des Données	2021-03-25	COMP	2.00	79.14	204.58	COMPLIANCE
1223	HEALTH-001	Santé & Sécurité au Travail	2021-03-24	COMP	4.00	99.03	265.62	COMPLIANCE
1223	FIRE-001	Sécurité & Évacuation Incendie	2021-04-13	COMP	1.00	99.56	90.51	COMPLIANCE
1223	DEI-001	Égalité Femmes-Hommes	2021-03-17	COMP	3.00	96.47	163.54	COMPLIANCE
1223	FRAUD-001	Prévention Fraude & Corruption	2021-05-07	COMP	2.00	79.21	154.17	COMPLIANCE
1223	ETHICS-001	Code de Déontologie Novaryn Tech	2021-04-23	COMP	1.50	89.42	113.57	COMPLIANCE
1223	PYTHON-001	Python for Data Science	2026-05-18	ENR	24.00	0.00	870.77	ELEARN
1223	SAFE-001	SAFe Agile Practitioner	2024-01-01	COMP	16.00	73.60	1204.19	COURSE
1223	LEAD-001	Leadership & Management	2025-05-01	COMP	20.00	85.32	1525.00	COURSE
1224	GDPR-001	RGPD & Protection des Données	2014-08-13	COMP	2.00	90.46	191.36	COMPLIANCE
1224	HEALTH-001	Santé & Sécurité au Travail	2014-08-20	COMP	4.00	95.53	251.24	COMPLIANCE
1224	FIRE-001	Sécurité & Évacuation Incendie	2014-08-26	COMP	1.00	81.57	102.40	COMPLIANCE
1224	DEI-001	Égalité Femmes-Hommes	2014-09-16	COMP	3.00	84.72	179.99	COMPLIANCE
1224	FRAUD-001	Prévention Fraude & Corruption	2014-09-15	COMP	2.00	99.71	141.66	COMPLIANCE
1224	ETHICS-001	Code de Déontologie Novaryn Tech	2014-08-30	COMP	1.50	96.97	126.93	COMPLIANCE
1224	SAFE-001	SAFe Agile Practitioner	2025-06-21	COMP	16.00	93.84	1603.61	COURSE
1224	REACT-001	React & TypeScript Masterclass	2026-05-25	ENR	36.00	0.00	1123.65	ELEARN
1224	PYTHON-001	Python for Data Science	2020-07-07	FAIL	24.00	41.32	915.53	ELEARN
1224	SCRUM-001	Scrum Fundamentals	2026-07-07	ENR	12.00	0.00	607.81	ELEARN
1225	GDPR-001	RGPD & Protection des Données	2023-12-20	COMP	2.00	73.18	185.35	COMPLIANCE
1225	HEALTH-001	Santé & Sécurité au Travail	2023-12-21	COMP	4.00	71.89	235.01	COMPLIANCE
1225	FIRE-001	Sécurité & Évacuation Incendie	2023-11-07	COMP	1.00	96.36	102.90	COMPLIANCE
1225	DEI-001	Égalité Femmes-Hommes	2023-12-08	COMP	3.00	79.15	165.33	COMPLIANCE
1225	FRAUD-001	Prévention Fraude & Corruption	2023-11-22	COMP	2.00	92.15	161.56	COMPLIANCE
1225	ETHICS-001	Code de Déontologie Novaryn Tech	2023-12-01	COMP	1.50	77.34	114.30	COMPLIANCE
1225	AWS-001	AWS Cloud Practitioner	2025-11-08	COMP	30.00	60.97	1619.13	ELEARN
1225	COMM-001	Communication & Public Speaking	2024-11-26	COMP	8.00	80.75	350.45	OJT
1225	ML-001	Machine Learning Fundamentals	2024-12-16	COMP	40.00	91.48	1791.93	ELEARN
1226	GDPR-001	RGPD & Protection des Données	2015-09-28	COMP	2.00	83.93	190.41	COMPLIANCE
1226	HEALTH-001	Santé & Sécurité au Travail	2015-09-21	COMP	4.00	86.86	238.28	COMPLIANCE
1226	FIRE-001	Sécurité & Évacuation Incendie	2015-09-06	COMP	1.00	81.37	107.25	COMPLIANCE
1226	DEI-001	Égalité Femmes-Hommes	2015-08-31	COMP	3.00	79.76	184.27	COMPLIANCE
1226	FRAUD-001	Prévention Fraude & Corruption	2015-09-30	COMP	2.00	94.50	160.65	COMPLIANCE
1226	ETHICS-001	Code de Déontologie Novaryn Tech	2015-10-15	COMP	1.50	83.61	129.59	COMPLIANCE
1226	COMM-001	Communication & Public Speaking	2025-11-01	COMP	8.00	94.76	426.19	OJT
1226	LEAD-001	Leadership & Management	2020-12-01	FAIL	20.00	52.26	1354.00	COURSE
1226	REACT-001	React & TypeScript Masterclass	2024-03-03	COMP	36.00	68.60	1179.44	ELEARN
1228	GDPR-001	RGPD & Protection des Données	2020-01-26	COMP	2.00	91.85	217.03	COMPLIANCE
1228	HEALTH-001	Santé & Sécurité au Travail	2020-01-22	COMP	4.00	87.48	234.31	COMPLIANCE
1228	FIRE-001	Sécurité & Évacuation Incendie	2020-02-03	COMP	1.00	97.78	96.52	COMPLIANCE
1228	DEI-001	Égalité Femmes-Hommes	2019-12-23	COMP	3.00	74.66	196.39	COMPLIANCE
1228	FRAUD-001	Prévention Fraude & Corruption	2020-01-20	COMP	2.00	76.42	147.36	COMPLIANCE
1228	ETHICS-001	Code de Déontologie Novaryn Tech	2019-12-22	COMP	1.50	98.66	125.59	COMPLIANCE
1228	SAFE-001	SAFe Agile Practitioner	2023-12-12	COMP	16.00	82.03	1289.31	COURSE
1228	PM-001	Product Management Essentials	2020-10-18	COMP	20.00	86.13	1272.89	COURSE
1228	LEAD-001	Leadership & Management	2020-11-10	COMP	20.00	83.10	1677.53	COURSE
1228	AZURE-001	Microsoft Azure Fundamentals	2022-11-29	COMP	28.00	82.24	1507.87	ELEARN
1229	GDPR-001	RGPD & Protection des Données	2015-08-11	COMP	2.00	73.66	208.99	COMPLIANCE
1229	HEALTH-001	Santé & Sécurité au Travail	2015-08-14	COMP	4.00	92.11	269.13	COMPLIANCE
1229	FIRE-001	Sécurité & Évacuation Incendie	2015-07-30	COMP	1.00	74.85	97.86	COMPLIANCE
1229	DEI-001	Égalité Femmes-Hommes	2015-07-31	COMP	3.00	98.26	182.56	COMPLIANCE
1229	FRAUD-001	Prévention Fraude & Corruption	2015-08-01	COMP	2.00	95.96	152.33	COMPLIANCE
1229	ETHICS-001	Code de Déontologie Novaryn Tech	2015-09-03	COMP	1.50	84.94	125.17	COMPLIANCE
1229	PYTHON-001	Python for Data Science	2025-03-04	COMP	24.00	93.92	1024.68	ELEARN
1229	K8S-001	Kubernetes Fundamentals	2021-04-05	COMP	24.00	82.84	1080.25	ELEARN
1230	GDPR-001	RGPD & Protection des Données	2025-02-21	COMP	2.00	71.66	189.86	COMPLIANCE
1230	HEALTH-001	Santé & Sécurité au Travail	2025-03-21	COMP	4.00	84.06	251.35	COMPLIANCE
1230	FIRE-001	Sécurité & Évacuation Incendie	2025-03-14	COMP	1.00	91.56	94.28	COMPLIANCE
1230	DEI-001	Égalité Femmes-Hommes	2025-03-28	COMP	3.00	96.86	173.77	COMPLIANCE
1230	FRAUD-001	Prévention Fraude & Corruption	2025-03-20	COMP	2.00	98.54	163.37	COMPLIANCE
1230	ETHICS-001	Code de Déontologie Novaryn Tech	2025-03-16	COMP	1.50	77.29	111.58	COMPLIANCE
1230	PYTHON-001	Python for Data Science	2025-05-30	COMP	24.00	91.62	1108.89	ELEARN
1230	SQL-001	Advanced SQL for Analytics	2025-06-23	COMP	16.00	66.93	892.01	ELEARN
1231	GDPR-001	RGPD & Protection des Données	2012-05-24	COMP	2.00	92.83	199.56	COMPLIANCE
1231	HEALTH-001	Santé & Sécurité au Travail	2012-06-28	COMP	4.00	98.19	269.24	COMPLIANCE
1231	FIRE-001	Sécurité & Évacuation Incendie	2012-06-10	COMP	1.00	85.10	107.27	COMPLIANCE
1231	DEI-001	Égalité Femmes-Hommes	2012-06-05	COMP	3.00	80.48	169.58	COMPLIANCE
1231	FRAUD-001	Prévention Fraude & Corruption	2012-06-24	COMP	2.00	91.66	161.36	COMPLIANCE
1231	ETHICS-001	Code de Déontologie Novaryn Tech	2012-06-19	COMP	1.50	85.43	112.43	COMPLIANCE
1231	SCRUM-001	Scrum Fundamentals	2022-05-04	FAIL	12.00	44.49	579.81	ELEARN
1231	EXCEL-001	Excel Avancé & Reporting	2025-04-23	COMP	8.00	82.91	435.31	ELEARN
1231	AWS-001	AWS Cloud Practitioner	2025-05-20	COMP	30.00	78.41	1717.32	ELEARN
1231	COMM-001	Communication & Public Speaking	2026-05-04	ENR	8.00	0.00	444.64	OJT
1231	AZURE-001	Microsoft Azure Fundamentals	2024-08-30	COMP	28.00	97.14	1404.91	ELEARN
1232	GDPR-001	RGPD & Protection des Données	2012-04-02	COMP	2.00	74.48	203.09	COMPLIANCE
1232	HEALTH-001	Santé & Sécurité au Travail	2012-04-02	COMP	4.00	97.81	272.09	COMPLIANCE
1232	FIRE-001	Sécurité & Évacuation Incendie	2012-03-31	COMP	1.00	80.45	90.48	COMPLIANCE
1232	DEI-001	Égalité Femmes-Hommes	2012-03-03	COMP	3.00	75.97	171.98	COMPLIANCE
1232	FRAUD-001	Prévention Fraude & Corruption	2012-03-31	COMP	2.00	85.34	136.70	COMPLIANCE
1232	ETHICS-001	Code de Déontologie Novaryn Tech	2012-04-05	COMP	1.50	75.89	108.12	COMPLIANCE
1232	K8S-001	Kubernetes Fundamentals	2022-10-07	COMP	24.00	98.70	982.91	ELEARN
1232	LEAD-001	Leadership & Management	2023-03-29	COMP	20.00	66.04	1343.30	COURSE
1232	AWS-001	AWS Cloud Practitioner	2025-01-30	COMP	30.00	64.72	1900.86	ELEARN
1232	PM-001	Product Management Essentials	2026-06-05	ENR	20.00	0.00	1167.64	COURSE
1232	EXCEL-001	Excel Avancé & Reporting	2026-04-25	ENR	8.00	0.00	346.42	ELEARN
1233	GDPR-001	RGPD & Protection des Données	2024-12-09	COMP	2.00	93.14	206.94	COMPLIANCE
1233	HEALTH-001	Santé & Sécurité au Travail	2024-11-08	COMP	4.00	73.38	245.13	COMPLIANCE
1233	FIRE-001	Sécurité & Évacuation Incendie	2024-11-09	COMP	1.00	97.40	90.84	COMPLIANCE
1233	DEI-001	Égalité Femmes-Hommes	2024-12-10	COMP	3.00	91.65	178.07	COMPLIANCE
1233	FRAUD-001	Prévention Fraude & Corruption	2024-12-17	COMP	2.00	80.29	157.28	COMPLIANCE
1233	ETHICS-001	Code de Déontologie Novaryn Tech	2024-12-04	COMP	1.50	92.80	130.38	COMPLIANCE
1233	PM-001	Product Management Essentials	2025-07-18	COMP	20.00	82.88	1175.32	COURSE
1233	COMM-001	Communication & Public Speaking	2025-08-07	COMP	8.00	81.45	419.24	OJT
1233	AWS-001	AWS Cloud Practitioner	2025-09-15	COMP	30.00	95.07	1968.08	ELEARN
1234	GDPR-001	RGPD & Protection des Données	2021-04-23	COMP	2.00	85.63	185.99	COMPLIANCE
1234	HEALTH-001	Santé & Sécurité au Travail	2021-04-24	COMP	4.00	78.46	230.02	COMPLIANCE
1234	FIRE-001	Sécurité & Évacuation Incendie	2021-03-23	COMP	1.00	70.68	101.17	COMPLIANCE
1234	DEI-001	Égalité Femmes-Hommes	2021-03-30	COMP	3.00	88.76	167.06	COMPLIANCE
1234	FRAUD-001	Prévention Fraude & Corruption	2021-03-26	COMP	2.00	95.80	152.29	COMPLIANCE
1234	ETHICS-001	Code de Déontologie Novaryn Tech	2021-03-25	COMP	1.50	99.46	111.60	COMPLIANCE
1234	REACT-001	React & TypeScript Masterclass	2025-01-22	COMP	36.00	93.87	1378.04	ELEARN
1234	PYTHON-001	Python for Data Science	2022-03-31	COMP	24.00	75.22	1087.29	ELEARN
1234	SCRUM-001	Scrum Fundamentals	2026-06-30	ENR	12.00	0.00	510.22	ELEARN
1234	PM-001	Product Management Essentials	2023-03-26	FAIL	20.00	53.60	1224.79	COURSE
1235	GDPR-001	RGPD & Protection des Données	2015-10-24	COMP	2.00	73.85	207.78	COMPLIANCE
1235	HEALTH-001	Santé & Sécurité au Travail	2015-11-02	COMP	4.00	94.70	263.82	COMPLIANCE
1235	FIRE-001	Sécurité & Évacuation Incendie	2015-10-16	COMP	1.00	99.07	92.37	COMPLIANCE
1235	DEI-001	Égalité Femmes-Hommes	2015-10-19	COMP	3.00	75.72	195.67	COMPLIANCE
1235	FRAUD-001	Prévention Fraude & Corruption	2015-11-06	COMP	2.00	79.80	146.00	COMPLIANCE
1235	ETHICS-001	Code de Déontologie Novaryn Tech	2015-10-21	COMP	1.50	92.88	111.13	COMPLIANCE
1235	AZURE-001	Microsoft Azure Fundamentals	2023-08-29	FAIL	28.00	54.79	1372.31	ELEARN
1235	LEAD-001	Leadership & Management	2023-11-03	FAIL	20.00	57.67	1465.11	COURSE
1236	GDPR-001	RGPD & Protection des Données	2020-05-05	COMP	2.00	88.43	199.17	COMPLIANCE
1236	HEALTH-001	Santé & Sécurité au Travail	2020-05-17	COMP	4.00	84.85	228.02	COMPLIANCE
1236	FIRE-001	Sécurité & Évacuation Incendie	2020-05-20	COMP	1.00	88.58	98.86	COMPLIANCE
1236	DEI-001	Égalité Femmes-Hommes	2020-05-28	COMP	3.00	98.92	177.52	COMPLIANCE
1236	FRAUD-001	Prévention Fraude & Corruption	2020-05-19	COMP	2.00	70.67	141.85	COMPLIANCE
1236	ETHICS-001	Code de Déontologie Novaryn Tech	2020-04-20	COMP	1.50	95.80	120.75	COMPLIANCE
1236	SQL-001	Advanced SQL for Analytics	2022-06-13	COMP	16.00	94.56	878.66	ELEARN
1236	EXCEL-001	Excel Avancé & Reporting	2024-01-10	COMP	8.00	85.68	366.62	ELEARN
1237	GDPR-001	RGPD & Protection des Données	2017-11-10	COMP	2.00	95.99	181.30	COMPLIANCE
1237	HEALTH-001	Santé & Sécurité au Travail	2017-09-29	COMP	4.00	73.74	255.81	COMPLIANCE
1237	FIRE-001	Sécurité & Évacuation Incendie	2017-10-21	COMP	1.00	98.70	101.29	COMPLIANCE
1237	DEI-001	Égalité Femmes-Hommes	2017-11-14	COMP	3.00	89.20	175.27	COMPLIANCE
1237	FRAUD-001	Prévention Fraude & Corruption	2017-11-15	COMP	2.00	79.25	136.95	COMPLIANCE
1237	ETHICS-001	Code de Déontologie Novaryn Tech	2017-10-24	COMP	1.50	87.70	126.68	COMPLIANCE
1237	SQL-001	Advanced SQL for Analytics	2022-11-19	FAIL	16.00	44.77	881.98	ELEARN
1237	AZURE-001	Microsoft Azure Fundamentals	2023-11-09	COMP	28.00	92.40	1581.64	ELEARN
1237	REACT-001	React & TypeScript Masterclass	2023-05-23	COMP	36.00	61.76	1041.38	ELEARN
1237	PYTHON-001	Python for Data Science	2023-07-16	COMP	24.00	91.34	886.79	ELEARN
1238	GDPR-001	RGPD & Protection des Données	2014-11-11	COMP	2.00	70.80	216.46	COMPLIANCE
1238	HEALTH-001	Santé & Sécurité au Travail	2014-12-18	COMP	4.00	82.38	236.49	COMPLIANCE
1238	FIRE-001	Sécurité & Évacuation Incendie	2014-11-26	COMP	1.00	81.96	105.27	COMPLIANCE
1238	DEI-001	Égalité Femmes-Hommes	2014-11-03	COMP	3.00	84.67	177.26	COMPLIANCE
1238	FRAUD-001	Prévention Fraude & Corruption	2014-10-31	COMP	2.00	86.33	150.51	COMPLIANCE
1238	ETHICS-001	Code de Déontologie Novaryn Tech	2014-12-19	COMP	1.50	91.80	116.79	COMPLIANCE
1238	PYTHON-001	Python for Data Science	2020-10-22	COMP	24.00	88.79	1142.26	ELEARN
1238	PM-001	Product Management Essentials	2026-06-06	ENR	20.00	0.00	1050.40	COURSE
1239	GDPR-001	RGPD & Protection des Données	2022-09-10	COMP	2.00	71.27	198.12	COMPLIANCE
1239	HEALTH-001	Santé & Sécurité au Travail	2022-08-24	COMP	4.00	71.62	260.63	COMPLIANCE
1239	FIRE-001	Sécurité & Évacuation Incendie	2022-08-30	COMP	1.00	72.39	90.96	COMPLIANCE
1239	DEI-001	Égalité Femmes-Hommes	2022-08-27	COMP	3.00	80.83	181.10	COMPLIANCE
1239	FRAUD-001	Prévention Fraude & Corruption	2022-08-26	COMP	2.00	84.76	140.98	COMPLIANCE
1239	ETHICS-001	Code de Déontologie Novaryn Tech	2022-09-03	COMP	1.50	75.25	124.90	COMPLIANCE
1239	SCRUM-001	Scrum Fundamentals	2024-08-23	COMP	12.00	73.96	664.69	ELEARN
1239	PM-001	Product Management Essentials	2024-02-28	COMP	20.00	77.87	1273.23	COURSE
1240	GDPR-001	RGPD & Protection des Données	2022-03-11	COMP	2.00	77.61	181.19	COMPLIANCE
1240	HEALTH-001	Santé & Sécurité au Travail	2022-02-08	COMP	4.00	86.84	241.69	COMPLIANCE
1240	FIRE-001	Sécurité & Évacuation Incendie	2022-03-15	COMP	1.00	94.11	105.54	COMPLIANCE
1240	DEI-001	Égalité Femmes-Hommes	2022-03-11	COMP	3.00	82.08	191.61	COMPLIANCE
1240	FRAUD-001	Prévention Fraude & Corruption	2022-03-01	COMP	2.00	97.66	160.15	COMPLIANCE
1240	ETHICS-001	Code de Déontologie Novaryn Tech	2022-02-26	COMP	1.50	83.10	111.57	COMPLIANCE
1240	PM-001	Product Management Essentials	2026-07-06	ENR	20.00	0.00	1327.35	COURSE
1240	LEAD-001	Leadership & Management	2023-05-25	COMP	20.00	62.30	1394.70	COURSE
1240	ML-001	Machine Learning Fundamentals	2023-11-27	COMP	40.00	64.01	1823.24	ELEARN
1240	AWS-001	AWS Cloud Practitioner	2022-12-18	COMP	30.00	61.00	1566.62	ELEARN
1241	GDPR-001	RGPD & Protection des Données	2012-07-01	COMP	2.00	71.52	203.54	COMPLIANCE
1241	HEALTH-001	Santé & Sécurité au Travail	2012-08-05	COMP	4.00	84.02	270.70	COMPLIANCE
1241	FIRE-001	Sécurité & Évacuation Incendie	2012-06-26	COMP	1.00	70.59	103.10	COMPLIANCE
1241	DEI-001	Égalité Femmes-Hommes	2012-07-31	COMP	3.00	77.08	189.66	COMPLIANCE
1241	FRAUD-001	Prévention Fraude & Corruption	2012-07-29	COMP	2.00	72.04	156.45	COMPLIANCE
1241	ETHICS-001	Code de Déontologie Novaryn Tech	2012-08-11	COMP	1.50	91.00	124.98	COMPLIANCE
1241	PM-001	Product Management Essentials	2025-11-03	COMP	20.00	88.31	1134.00	COURSE
1241	SCRUM-001	Scrum Fundamentals	2024-01-13	COMP	12.00	70.22	619.59	ELEARN
1241	SQL-001	Advanced SQL for Analytics	2020-07-27	COMP	16.00	83.59	835.18	ELEARN
1241	AWS-001	AWS Cloud Practitioner	2020-10-10	COMP	30.00	79.88	2022.79	ELEARN
1242	GDPR-001	RGPD & Protection des Données	2019-06-13	COMP	2.00	88.18	219.59	COMPLIANCE
1242	HEALTH-001	Santé & Sécurité au Travail	2019-06-03	COMP	4.00	76.71	228.26	COMPLIANCE
1242	FIRE-001	Sécurité & Évacuation Incendie	2019-05-23	COMP	1.00	87.71	103.70	COMPLIANCE
1242	DEI-001	Égalité Femmes-Hommes	2019-06-15	COMP	3.00	82.44	183.71	COMPLIANCE
1242	FRAUD-001	Prévention Fraude & Corruption	2019-06-10	COMP	2.00	78.78	147.33	COMPLIANCE
1242	ETHICS-001	Code de Déontologie Novaryn Tech	2019-05-18	COMP	1.50	98.66	111.56	COMPLIANCE
1242	AZURE-001	Microsoft Azure Fundamentals	2020-09-22	COMP	28.00	93.24	1725.85	ELEARN
1242	SCRUM-001	Scrum Fundamentals	2020-10-16	COMP	12.00	68.44	634.00	ELEARN
1242	K8S-001	Kubernetes Fundamentals	2023-09-03	COMP	24.00	83.64	1030.40	ELEARN
1242	SAFE-001	SAFe Agile Practitioner	2020-10-27	COMP	16.00	64.56	1446.43	COURSE
1242	EXCEL-001	Excel Avancé & Reporting	2026-04-16	ENR	8.00	0.00	425.38	ELEARN
1243	GDPR-001	RGPD & Protection des Données	2015-02-26	COMP	2.00	74.95	197.23	COMPLIANCE
1243	HEALTH-001	Santé & Sécurité au Travail	2015-03-24	COMP	4.00	74.19	235.72	COMPLIANCE
1243	FIRE-001	Sécurité & Évacuation Incendie	2015-02-13	COMP	1.00	85.47	106.40	COMPLIANCE
1243	DEI-001	Égalité Femmes-Hommes	2015-03-16	COMP	3.00	95.33	165.80	COMPLIANCE
1243	FRAUD-001	Prévention Fraude & Corruption	2015-03-08	COMP	2.00	71.65	139.75	COMPLIANCE
1243	ETHICS-001	Code de Déontologie Novaryn Tech	2015-03-24	COMP	1.50	89.78	123.14	COMPLIANCE
1243	LEAD-001	Leadership & Management	2021-02-08	COMP	20.00	88.07	1551.84	COURSE
1243	ML-001	Machine Learning Fundamentals	2024-09-24	COMP	40.00	80.18	1836.66	ELEARN
1243	EXCEL-001	Excel Avancé & Reporting	2020-07-05	COMP	8.00	96.03	447.69	ELEARN
1243	AWS-001	AWS Cloud Practitioner	2024-12-27	COMP	30.00	77.78	1542.10	ELEARN
1244	GDPR-001	RGPD & Protection des Données	2018-08-12	COMP	2.00	86.13	205.04	COMPLIANCE
1244	HEALTH-001	Santé & Sécurité au Travail	2018-07-08	COMP	4.00	97.83	250.41	COMPLIANCE
1244	FIRE-001	Sécurité & Évacuation Incendie	2018-08-11	COMP	1.00	94.61	91.41	COMPLIANCE
1244	DEI-001	Égalité Femmes-Hommes	2018-07-24	COMP	3.00	97.84	194.19	COMPLIANCE
1244	FRAUD-001	Prévention Fraude & Corruption	2018-07-09	COMP	2.00	86.05	139.82	COMPLIANCE
1244	ETHICS-001	Code de Déontologie Novaryn Tech	2018-06-27	COMP	1.50	83.54	129.12	COMPLIANCE
1244	ML-001	Machine Learning Fundamentals	2024-10-10	FAIL	40.00	58.48	1539.42	ELEARN
1244	EXCEL-001	Excel Avancé & Reporting	2024-10-11	FAIL	8.00	50.24	347.41	ELEARN
1244	AWS-001	AWS Cloud Practitioner	2022-10-21	COMP	30.00	81.60	1756.15	ELEARN
1244	PM-001	Product Management Essentials	2025-09-12	COMP	20.00	86.66	1318.37	COURSE
1245	GDPR-001	RGPD & Protection des Données	2019-10-14	COMP	2.00	95.26	195.21	COMPLIANCE
1245	HEALTH-001	Santé & Sécurité au Travail	2019-10-08	COMP	4.00	78.99	245.16	COMPLIANCE
1245	FIRE-001	Sécurité & Évacuation Incendie	2019-11-20	COMP	1.00	89.44	91.68	COMPLIANCE
1245	DEI-001	Égalité Femmes-Hommes	2019-10-13	COMP	3.00	85.33	179.99	COMPLIANCE
1245	FRAUD-001	Prévention Fraude & Corruption	2019-11-24	COMP	2.00	87.71	158.74	COMPLIANCE
1245	ETHICS-001	Code de Déontologie Novaryn Tech	2019-11-10	COMP	1.50	90.11	121.43	COMPLIANCE
1245	K8S-001	Kubernetes Fundamentals	2021-01-14	COMP	24.00	99.96	1241.97	ELEARN
1245	COMM-001	Communication & Public Speaking	2023-06-30	COMP	8.00	85.42	372.06	OJT
1245	REACT-001	React & TypeScript Masterclass	2023-01-03	COMP	36.00	69.17	1062.45	ELEARN
1246	GDPR-001	RGPD & Protection des Données	2025-02-08	COMP	2.00	72.65	203.24	COMPLIANCE
1246	HEALTH-001	Santé & Sécurité au Travail	2024-12-27	COMP	4.00	80.64	227.20	COMPLIANCE
1246	FIRE-001	Sécurité & Évacuation Incendie	2025-01-24	COMP	1.00	89.27	93.54	COMPLIANCE
1246	DEI-001	Égalité Femmes-Hommes	2025-01-07	COMP	3.00	90.23	191.11	COMPLIANCE
1246	FRAUD-001	Prévention Fraude & Corruption	2025-01-24	COMP	2.00	86.75	145.00	COMPLIANCE
1246	ETHICS-001	Code de Déontologie Novaryn Tech	2025-01-13	COMP	1.50	80.62	126.70	COMPLIANCE
1246	PM-001	Product Management Essentials	2025-11-26	COMP	20.00	61.81	1237.71	COURSE
1246	SAFE-001	SAFe Agile Practitioner	2025-12-29	COMP	16.00	85.59	1540.74	COURSE
1246	COMM-001	Communication & Public Speaking	2025-08-24	COMP	8.00	81.87	426.44	OJT
1246	REACT-001	React & TypeScript Masterclass	2025-12-18	FAIL	36.00	48.16	1115.63	ELEARN
1246	PYTHON-001	Python for Data Science	2025-04-01	COMP	24.00	66.07	983.18	ELEARN
1247	GDPR-001	RGPD & Protection des Données	2024-11-01	COMP	2.00	86.82	184.09	COMPLIANCE
1247	HEALTH-001	Santé & Sécurité au Travail	2024-11-01	COMP	4.00	74.79	271.67	COMPLIANCE
1247	FIRE-001	Sécurité & Évacuation Incendie	2024-11-29	COMP	1.00	92.80	106.51	COMPLIANCE
1247	DEI-001	Égalité Femmes-Hommes	2024-11-18	COMP	3.00	78.26	181.68	COMPLIANCE
1247	FRAUD-001	Prévention Fraude & Corruption	2024-10-23	COMP	2.00	85.08	152.22	COMPLIANCE
1247	ETHICS-001	Code de Déontologie Novaryn Tech	2024-12-12	COMP	1.50	93.36	114.38	COMPLIANCE
1247	ML-001	Machine Learning Fundamentals	2025-05-05	FAIL	40.00	42.61	1484.10	ELEARN
1247	COMM-001	Communication & Public Speaking	2025-09-04	COMP	8.00	99.62	430.35	OJT
1247	EXCEL-001	Excel Avancé & Reporting	2025-05-15	COMP	8.00	83.03	390.99	ELEARN
1247	AWS-001	AWS Cloud Practitioner	2025-05-30	COMP	30.00	62.54	1691.95	ELEARN
1247	SCRUM-001	Scrum Fundamentals	2025-02-23	COMP	12.00	93.19	615.57	ELEARN
1248	GDPR-001	RGPD & Protection des Données	2013-07-17	COMP	2.00	99.83	189.93	COMPLIANCE
1248	HEALTH-001	Santé & Sécurité au Travail	2013-07-11	COMP	4.00	92.66	254.98	COMPLIANCE
1248	FIRE-001	Sécurité & Évacuation Incendie	2013-07-21	COMP	1.00	74.90	106.41	COMPLIANCE
1248	DEI-001	Égalité Femmes-Hommes	2013-06-12	COMP	3.00	91.44	165.89	COMPLIANCE
1248	FRAUD-001	Prévention Fraude & Corruption	2013-06-12	COMP	2.00	84.25	147.23	COMPLIANCE
1248	ETHICS-001	Code de Déontologie Novaryn Tech	2013-05-30	COMP	1.50	80.25	131.54	COMPLIANCE
1248	AZURE-001	Microsoft Azure Fundamentals	2024-11-30	COMP	28.00	63.78	1519.58	ELEARN
1248	SQL-001	Advanced SQL for Analytics	2026-04-10	ENR	16.00	0.00	898.40	ELEARN
1249	GDPR-001	RGPD & Protection des Données	2024-10-28	COMP	2.00	97.19	191.14	COMPLIANCE
1249	HEALTH-001	Santé & Sécurité au Travail	2024-10-24	COMP	4.00	84.87	238.11	COMPLIANCE
1249	FIRE-001	Sécurité & Évacuation Incendie	2024-11-13	COMP	1.00	72.92	96.36	COMPLIANCE
1249	DEI-001	Égalité Femmes-Hommes	2024-10-07	COMP	3.00	96.19	187.09	COMPLIANCE
1249	FRAUD-001	Prévention Fraude & Corruption	2024-10-22	COMP	2.00	70.85	152.02	COMPLIANCE
1249	ETHICS-001	Code de Déontologie Novaryn Tech	2024-10-30	COMP	1.50	95.35	119.28	COMPLIANCE
1249	COMM-001	Communication & Public Speaking	2025-03-19	COMP	8.00	82.93	405.59	OJT
1249	LEAD-001	Leadership & Management	2025-02-25	COMP	20.00	81.64	1683.40	COURSE
1249	ML-001	Machine Learning Fundamentals	2025-09-08	COMP	40.00	76.03	1760.00	ELEARN
1249	PYTHON-001	Python for Data Science	2025-07-02	COMP	24.00	70.86	982.86	ELEARN
1249	AZURE-001	Microsoft Azure Fundamentals	2025-03-24	COMP	28.00	93.91	1410.20	ELEARN
\.


--
-- TOC entry 5123 (class 0 OID 19750)
-- Dependencies: 223
-- Data for Name: pay_component_non_recurring; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pay_component_non_recurring (user_id, pay_date, pay_component, value, currency_code, notes, operation) FROM stdin;
1001	2025-03-15	PERFAWARD	1233.07	EUR	Prime de performance annuelle 2025	ADD
1002	2022-03-15	PERFAWARD	11876.34	EUR	Prime de performance annuelle 2022	ADD
1002	2023-03-15	PERFAWARD	15614.78	EUR	Prime de performance annuelle 2023	ADD
1002	2024-03-15	PERFAWARD	13215.63	EUR	Prime de performance annuelle 2024	ADD
1002	2025-03-15	PERFAWARD	15914.20	EUR	Prime de performance annuelle 2025	ADD
1002	2020-11-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1002	2025-11-02	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1003	2022-03-15	PERFAWARD	10016.79	EUR	Prime de performance annuelle 2022	ADD
1003	2023-03-15	PERFAWARD	9877.50	EUR	Prime de performance annuelle 2023	ADD
1003	2024-03-15	PERFAWARD	10891.81	EUR	Prime de performance annuelle 2024	ADD
1003	2025-03-15	PERFAWARD	11141.41	EUR	Prime de performance annuelle 2025	ADD
1003	2018-10-13	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1003	2023-10-13	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1004	2022-03-15	PERFAWARD	10514.29	EUR	Prime de performance annuelle 2022	ADD
1004	2023-03-15	PERFAWARD	9221.75	EUR	Prime de performance annuelle 2023	ADD
1004	2024-03-15	PERFAWARD	9776.89	EUR	Prime de performance annuelle 2024	ADD
1004	2025-03-15	PERFAWARD	9850.29	EUR	Prime de performance annuelle 2025	ADD
1005	2023-03-15	PERFAWARD	13999.30	EUR	Prime de performance annuelle 2023	ADD
1005	2024-03-15	PERFAWARD	12060.21	EUR	Prime de performance annuelle 2024	ADD
1005	2025-03-15	PERFAWARD	12303.91	EUR	Prime de performance annuelle 2025	ADD
1005	2024-03-21	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1006	2022-03-15	PERFAWARD	17444.12	EUR	Prime de performance annuelle 2022	ADD
1006	2024-03-15	PERFAWARD	16702.25	EUR	Prime de performance annuelle 2024	ADD
1006	2018-08-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1006	2023-08-20	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1007	2022-03-15	PERFAWARD	8382.20	EUR	Prime de performance annuelle 2022	ADD
1007	2023-03-15	PERFAWARD	8033.09	EUR	Prime de performance annuelle 2023	ADD
1007	2025-03-15	PERFAWARD	7295.12	EUR	Prime de performance annuelle 2025	ADD
1007	2025-08-21	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1007	2022-12-15	SPOTBONUS	1562.03	EUR	Prime d'excellence	ADD
1008	2022-03-15	PERFAWARD	10516.86	EUR	Prime de performance annuelle 2022	ADD
1008	2025-03-15	PERFAWARD	11175.42	EUR	Prime de performance annuelle 2025	ADD
1008	2020-06-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1008	2025-06-04	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1009	2022-03-15	PERFAWARD	9799.50	EUR	Prime de performance annuelle 2022	ADD
1009	2023-03-15	PERFAWARD	10092.06	EUR	Prime de performance annuelle 2023	ADD
1009	2024-03-15	PERFAWARD	10557.38	EUR	Prime de performance annuelle 2024	ADD
1009	2024-10-06	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1009	2024-09-07	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1010	2025-11-22	SIGNON	7143.32	EUR	Bonus de signature de contrat	ADD
1011	2025-10-31	SIGNON	3999.25	EUR	Bonus de signature de contrat	ADD
1012	2022-03-15	PERFAWARD	54642.27	EUR	Prime de performance annuelle 2022	ADD
1012	2023-03-15	PERFAWARD	56099.08	EUR	Prime de performance annuelle 2023	ADD
1012	2024-03-15	PERFAWARD	56044.70	EUR	Prime de performance annuelle 2024	ADD
1012	2025-03-15	PERFAWARD	53615.39	EUR	Prime de performance annuelle 2025	ADD
1012	2024-03-26	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1013	2022-03-15	PERFAWARD	9744.89	EUR	Prime de performance annuelle 2022	ADD
1013	2023-03-15	PERFAWARD	11126.04	EUR	Prime de performance annuelle 2023	ADD
1013	2024-03-15	PERFAWARD	12066.48	EUR	Prime de performance annuelle 2024	ADD
1013	2025-03-15	PERFAWARD	12202.79	EUR	Prime de performance annuelle 2025	ADD
1013	2019-09-08	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1013	2024-09-08	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1013	2022-04-17	SPOTBONUS	1833.95	EUR	Prime d'excellence	ADD
1014	2022-03-15	PERFAWARD	6919.33	EUR	Prime de performance annuelle 2022	ADD
1014	2024-03-15	PERFAWARD	6929.92	EUR	Prime de performance annuelle 2024	ADD
1014	2025-03-15	PERFAWARD	7653.47	EUR	Prime de performance annuelle 2025	ADD
1014	2025-04-28	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1014	2022-10-07	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1015	2022-03-15	PERFAWARD	11785.88	EUR	Prime de performance annuelle 2022	ADD
1015	2023-03-15	PERFAWARD	10217.91	EUR	Prime de performance annuelle 2023	ADD
1015	2024-03-15	PERFAWARD	10216.20	EUR	Prime de performance annuelle 2024	ADD
1015	2025-03-15	PERFAWARD	11828.44	EUR	Prime de performance annuelle 2025	ADD
1015	2024-10-09	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1015	2023-07-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1016	2022-03-15	PERFAWARD	19017.55	EUR	Prime de performance annuelle 2022	ADD
1016	2023-03-15	PERFAWARD	19437.75	EUR	Prime de performance annuelle 2023	ADD
1016	2024-03-15	PERFAWARD	19494.99	EUR	Prime de performance annuelle 2024	ADD
1016	2025-03-15	PERFAWARD	15620.10	EUR	Prime de performance annuelle 2025	ADD
1016	2022-11-22	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1017	2025-11-08	SIGNON	6970.40	EUR	Bonus de signature de contrat	ADD
1017	2022-03-04	SPOTBONUS	2463.99	EUR	Prime d'excellence	ADD
1018	2022-03-15	PERFAWARD	12275.39	EUR	Prime de performance annuelle 2022	ADD
1018	2023-03-15	PERFAWARD	11193.95	EUR	Prime de performance annuelle 2023	ADD
1018	2024-03-15	PERFAWARD	12422.35	EUR	Prime de performance annuelle 2024	ADD
1018	2025-03-15	PERFAWARD	11185.65	EUR	Prime de performance annuelle 2025	ADD
1018	2024-11-09	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1020	2022-03-15	PERFAWARD	9709.24	EUR	Prime de performance annuelle 2022	ADD
1020	2023-03-15	PERFAWARD	12072.65	EUR	Prime de performance annuelle 2023	ADD
1020	2024-03-15	PERFAWARD	11137.96	EUR	Prime de performance annuelle 2024	ADD
1020	2025-03-15	PERFAWARD	9476.70	EUR	Prime de performance annuelle 2025	ADD
1020	2025-03-17	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1020	2022-01-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1021	2022-03-15	PERFAWARD	10719.03	EUR	Prime de performance annuelle 2022	ADD
1021	2023-03-15	PERFAWARD	11770.36	EUR	Prime de performance annuelle 2023	ADD
1021	2024-03-15	PERFAWARD	11007.59	EUR	Prime de performance annuelle 2024	ADD
1021	2025-03-15	PERFAWARD	11837.38	EUR	Prime de performance annuelle 2025	ADD
1021	2023-03-12	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1021	2022-02-18	SPOTBONUS	1145.23	EUR	Prime d'excellence	ADD
1022	2024-03-15	PERFAWARD	152.37	EUR	Prime de performance annuelle 2024	ADD
1022	2025-03-15	PERFAWARD	127.80	EUR	Prime de performance annuelle 2025	ADD
1023	2024-03-15	PERFAWARD	14116.51	EUR	Prime de performance annuelle 2024	ADD
1023	2025-03-15	PERFAWARD	17241.19	EUR	Prime de performance annuelle 2025	ADD
1024	2022-03-15	PERFAWARD	17759.17	EUR	Prime de performance annuelle 2022	ADD
1024	2023-03-15	PERFAWARD	15095.08	EUR	Prime de performance annuelle 2023	ADD
1024	2024-03-15	PERFAWARD	16373.50	EUR	Prime de performance annuelle 2024	ADD
1024	2021-12-18	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1026	2022-03-15	PERFAWARD	13591.78	EUR	Prime de performance annuelle 2022	ADD
1026	2023-03-15	PERFAWARD	15347.26	EUR	Prime de performance annuelle 2023	ADD
1026	2025-03-15	PERFAWARD	13974.08	EUR	Prime de performance annuelle 2025	ADD
1026	2023-01-20	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1026	2024-10-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1026	2022-11-06	SPOTBONUS	2493.67	EUR	Prime d'excellence	ADD
1030	2023-03-15	PERFAWARD	9875.89	EUR	Prime de performance annuelle 2023	ADD
1030	2024-03-15	PERFAWARD	10656.37	EUR	Prime de performance annuelle 2024	ADD
1030	2025-03-15	PERFAWARD	11641.92	EUR	Prime de performance annuelle 2025	ADD
1030	2022-09-06	RELOCATION	3168.16	EUR	Aide à la mobilité géographique	ADD
1031	2022-03-15	PERFAWARD	4218.32	EUR	Prime de performance annuelle 2022	ADD
1031	2023-03-15	PERFAWARD	5339.27	EUR	Prime de performance annuelle 2023	ADD
1031	2024-03-15	PERFAWARD	4827.79	EUR	Prime de performance annuelle 2024	ADD
1031	2025-03-15	PERFAWARD	5437.75	EUR	Prime de performance annuelle 2025	ADD
1031	2025-07-27	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1031	2026-02-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1032	2023-03-15	PERFAWARD	9586.03	EUR	Prime de performance annuelle 2023	ADD
1032	2024-03-15	PERFAWARD	10648.19	EUR	Prime de performance annuelle 2024	ADD
1032	2022-02-01	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1032	2024-11-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1033	2023-03-15	PERFAWARD	11678.79	EUR	Prime de performance annuelle 2023	ADD
1033	2024-03-15	PERFAWARD	12203.70	EUR	Prime de performance annuelle 2024	ADD
1033	2025-03-15	PERFAWARD	12782.08	EUR	Prime de performance annuelle 2025	ADD
1034	2024-03-15	PERFAWARD	2553.78	EUR	Prime de performance annuelle 2024	ADD
1034	2025-03-15	PERFAWARD	3155.67	EUR	Prime de performance annuelle 2025	ADD
1035	2025-04-28	SIGNON	4844.16	EUR	Bonus de signature de contrat	ADD
1036	2026-02-07	SIGNON	6231.19	EUR	Bonus de signature de contrat	ADD
1037	2022-03-15	PERFAWARD	9199.07	EUR	Prime de performance annuelle 2022	ADD
1037	2024-03-15	PERFAWARD	11140.35	EUR	Prime de performance annuelle 2024	ADD
1037	2025-03-15	PERFAWARD	9812.74	EUR	Prime de performance annuelle 2025	ADD
1037	2024-08-23	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1037	2023-11-12	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1038	2022-03-15	PERFAWARD	16816.00	EUR	Prime de performance annuelle 2022	ADD
1038	2023-03-15	PERFAWARD	18664.40	EUR	Prime de performance annuelle 2023	ADD
1038	2024-03-15	PERFAWARD	14564.56	EUR	Prime de performance annuelle 2024	ADD
1038	2020-08-19	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1038	2025-08-19	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1039	2022-03-15	PERFAWARD	16011.54	EUR	Prime de performance annuelle 2022	ADD
1039	2023-03-15	PERFAWARD	14528.42	EUR	Prime de performance annuelle 2023	ADD
1039	2024-03-15	PERFAWARD	16806.20	EUR	Prime de performance annuelle 2024	ADD
1039	2022-05-24	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1042	2022-03-15	PERFAWARD	9917.17	EUR	Prime de performance annuelle 2022	ADD
1042	2023-03-15	PERFAWARD	10951.23	EUR	Prime de performance annuelle 2023	ADD
1042	2024-03-15	PERFAWARD	12305.29	EUR	Prime de performance annuelle 2024	ADD
1042	2025-03-15	PERFAWARD	9367.26	EUR	Prime de performance annuelle 2025	ADD
1042	2019-06-01	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1042	2024-06-01	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1043	2022-03-15	PERFAWARD	13115.41	EUR	Prime de performance annuelle 2022	ADD
1043	2023-03-15	PERFAWARD	10293.45	EUR	Prime de performance annuelle 2023	ADD
1043	2024-03-15	PERFAWARD	10703.09	EUR	Prime de performance annuelle 2024	ADD
1043	2025-03-15	PERFAWARD	10623.93	EUR	Prime de performance annuelle 2025	ADD
1044	2025-03-15	PERFAWARD	4028.09	EUR	Prime de performance annuelle 2025	ADD
1046	2022-03-15	PERFAWARD	8257.08	EUR	Prime de performance annuelle 2022	ADD
1046	2023-03-15	PERFAWARD	9597.84	EUR	Prime de performance annuelle 2023	ADD
1046	2025-03-15	PERFAWARD	8209.63	EUR	Prime de performance annuelle 2025	ADD
1046	2020-10-09	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1046	2025-10-09	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1046	2022-08-25	SPOTBONUS	1878.51	EUR	Prime d'excellence	ADD
1047	2022-03-15	PERFAWARD	11204.26	EUR	Prime de performance annuelle 2022	ADD
1047	2023-03-15	PERFAWARD	12474.45	EUR	Prime de performance annuelle 2023	ADD
1047	2024-03-15	PERFAWARD	9862.52	EUR	Prime de performance annuelle 2024	ADD
1047	2025-03-15	PERFAWARD	12884.87	EUR	Prime de performance annuelle 2025	ADD
1047	2025-06-08	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1048	2022-03-15	PERFAWARD	13044.03	EUR	Prime de performance annuelle 2022	ADD
1048	2023-03-15	PERFAWARD	11986.17	EUR	Prime de performance annuelle 2023	ADD
1048	2024-03-15	PERFAWARD	10607.90	EUR	Prime de performance annuelle 2024	ADD
1048	2025-03-15	PERFAWARD	11051.98	EUR	Prime de performance annuelle 2025	ADD
1048	2017-11-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1048	2022-11-03	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1049	2023-03-15	PERFAWARD	4390.64	EUR	Prime de performance annuelle 2023	ADD
1049	2024-03-15	PERFAWARD	3620.90	EUR	Prime de performance annuelle 2024	ADD
1049	2025-03-15	PERFAWARD	3933.60	EUR	Prime de performance annuelle 2025	ADD
1050	2022-03-15	PERFAWARD	11882.69	EUR	Prime de performance annuelle 2022	ADD
1050	2023-03-15	PERFAWARD	13109.42	EUR	Prime de performance annuelle 2023	ADD
1050	2024-03-15	PERFAWARD	14052.96	EUR	Prime de performance annuelle 2024	ADD
1050	2025-03-15	PERFAWARD	10922.98	EUR	Prime de performance annuelle 2025	ADD
1050	2024-03-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1050	2023-01-06	SPOTBONUS	988.88	EUR	Prime d'excellence	ADD
1051	2022-03-15	PERFAWARD	6835.07	EUR	Prime de performance annuelle 2022	ADD
1051	2023-03-15	PERFAWARD	8462.11	EUR	Prime de performance annuelle 2023	ADD
1051	2024-03-15	PERFAWARD	8241.76	EUR	Prime de performance annuelle 2024	ADD
1051	2025-03-15	PERFAWARD	7836.78	EUR	Prime de performance annuelle 2025	ADD
1051	2023-08-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1052	2022-03-15	PERFAWARD	10705.49	EUR	Prime de performance annuelle 2022	ADD
1052	2023-03-15	PERFAWARD	11107.83	EUR	Prime de performance annuelle 2023	ADD
1052	2024-03-15	PERFAWARD	10647.52	EUR	Prime de performance annuelle 2024	ADD
1052	2025-03-15	PERFAWARD	10337.20	EUR	Prime de performance annuelle 2025	ADD
1052	2025-01-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1053	2022-03-15	PERFAWARD	22641.92	EUR	Prime de performance annuelle 2022	ADD
1053	2023-03-15	PERFAWARD	18126.78	EUR	Prime de performance annuelle 2023	ADD
1053	2024-03-15	PERFAWARD	17252.19	EUR	Prime de performance annuelle 2024	ADD
1053	2022-07-16	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1053	2017-03-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1053	2022-03-27	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1054	2022-03-15	PERFAWARD	13584.68	EUR	Prime de performance annuelle 2022	ADD
1054	2023-03-15	PERFAWARD	14662.33	EUR	Prime de performance annuelle 2023	ADD
1054	2025-03-15	PERFAWARD	12411.28	EUR	Prime de performance annuelle 2025	ADD
1054	2018-12-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1054	2023-12-27	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1054	2024-01-06	SPOTBONUS	2030.63	EUR	Prime d'excellence	ADD
1055	2024-03-15	PERFAWARD	15263.06	EUR	Prime de performance annuelle 2024	ADD
1055	2025-03-15	PERFAWARD	14262.82	EUR	Prime de performance annuelle 2025	ADD
1056	2023-03-15	PERFAWARD	17570.22	EUR	Prime de performance annuelle 2023	ADD
1056	2024-03-15	PERFAWARD	22165.58	EUR	Prime de performance annuelle 2024	ADD
1056	2022-01-12	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1057	2022-03-15	PERFAWARD	12904.72	EUR	Prime de performance annuelle 2022	ADD
1057	2023-03-15	PERFAWARD	14454.74	EUR	Prime de performance annuelle 2023	ADD
1057	2024-03-15	PERFAWARD	14584.08	EUR	Prime de performance annuelle 2024	ADD
1057	2025-03-15	PERFAWARD	11215.80	EUR	Prime de performance annuelle 2025	ADD
1057	2024-10-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1058	2025-03-15	PERFAWARD	5790.95	EUR	Prime de performance annuelle 2025	ADD
1059	2024-11-05	SPOTBONUS	2404.31	EUR	Prime d'excellence	ADD
1060	2022-03-15	PERFAWARD	14116.45	EUR	Prime de performance annuelle 2022	ADD
1060	2023-03-15	PERFAWARD	12134.82	EUR	Prime de performance annuelle 2023	ADD
1060	2024-03-15	PERFAWARD	12134.75	EUR	Prime de performance annuelle 2024	ADD
1060	2025-03-15	PERFAWARD	12867.71	EUR	Prime de performance annuelle 2025	ADD
1060	2022-06-27	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1060	2018-11-07	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1060	2023-11-07	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1061	2022-03-15	PERFAWARD	17291.23	EUR	Prime de performance annuelle 2022	ADD
1061	2023-03-15	PERFAWARD	13358.04	EUR	Prime de performance annuelle 2023	ADD
1061	2024-03-15	PERFAWARD	17100.37	EUR	Prime de performance annuelle 2024	ADD
1061	2025-03-15	PERFAWARD	17190.83	EUR	Prime de performance annuelle 2025	ADD
1061	2025-09-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1062	2022-03-15	PERFAWARD	12076.38	EUR	Prime de performance annuelle 2022	ADD
1062	2023-03-15	PERFAWARD	13317.79	EUR	Prime de performance annuelle 2023	ADD
1062	2024-03-15	PERFAWARD	10979.66	EUR	Prime de performance annuelle 2024	ADD
1062	2025-03-15	PERFAWARD	12582.45	EUR	Prime de performance annuelle 2025	ADD
1062	2023-05-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1063	2025-05-15	SIGNON	6404.04	EUR	Bonus de signature de contrat	ADD
1064	2022-03-15	PERFAWARD	14832.26	EUR	Prime de performance annuelle 2022	ADD
1064	2023-03-15	PERFAWARD	16225.25	EUR	Prime de performance annuelle 2023	ADD
1064	2024-03-15	PERFAWARD	16205.98	EUR	Prime de performance annuelle 2024	ADD
1064	2025-03-15	PERFAWARD	15995.69	EUR	Prime de performance annuelle 2025	ADD
1064	2022-07-22	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1065	2023-03-15	PERFAWARD	16323.87	EUR	Prime de performance annuelle 2023	ADD
1065	2024-03-15	PERFAWARD	13392.07	EUR	Prime de performance annuelle 2024	ADD
1065	2025-03-15	PERFAWARD	14341.31	EUR	Prime de performance annuelle 2025	ADD
1065	2018-12-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1065	2023-12-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1066	2022-03-15	PERFAWARD	39939.68	EUR	Prime de performance annuelle 2022	ADD
1066	2024-03-15	PERFAWARD	37881.16	EUR	Prime de performance annuelle 2024	ADD
1066	2025-03-15	PERFAWARD	41864.69	EUR	Prime de performance annuelle 2025	ADD
1066	2021-02-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1066	2026-02-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1067	2023-03-15	PERFAWARD	8045.76	EUR	Prime de performance annuelle 2023	ADD
1067	2024-03-15	PERFAWARD	6905.63	EUR	Prime de performance annuelle 2024	ADD
1067	2025-03-15	PERFAWARD	7404.37	EUR	Prime de performance annuelle 2025	ADD
1069	2025-03-15	PERFAWARD	1502.02	EUR	Prime de performance annuelle 2025	ADD
1070	2023-03-15	PERFAWARD	11423.96	EUR	Prime de performance annuelle 2023	ADD
1070	2024-03-15	PERFAWARD	13044.40	EUR	Prime de performance annuelle 2024	ADD
1070	2025-03-15	PERFAWARD	14901.18	EUR	Prime de performance annuelle 2025	ADD
1070	2019-03-07	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1070	2024-03-06	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1071	2024-03-15	PERFAWARD	13584.66	EUR	Prime de performance annuelle 2024	ADD
1071	2025-03-15	PERFAWARD	11921.55	EUR	Prime de performance annuelle 2025	ADD
1071	2024-05-26	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1071	2025-02-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1072	2022-03-15	PERFAWARD	15511.77	EUR	Prime de performance annuelle 2022	ADD
1072	2023-03-15	PERFAWARD	17026.38	EUR	Prime de performance annuelle 2023	ADD
1072	2024-03-15	PERFAWARD	15795.24	EUR	Prime de performance annuelle 2024	ADD
1072	2025-03-15	PERFAWARD	16075.88	EUR	Prime de performance annuelle 2025	ADD
1072	2021-07-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1073	2022-03-15	PERFAWARD	8326.31	EUR	Prime de performance annuelle 2022	ADD
1073	2023-03-15	PERFAWARD	7392.45	EUR	Prime de performance annuelle 2023	ADD
1073	2024-03-15	PERFAWARD	7300.67	EUR	Prime de performance annuelle 2024	ADD
1073	2025-03-15	PERFAWARD	6294.20	EUR	Prime de performance annuelle 2025	ADD
1073	2024-03-29	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1074	2025-03-15	PERFAWARD	535.43	EUR	Prime de performance annuelle 2025	ADD
1075	2023-03-15	PERFAWARD	16947.57	EUR	Prime de performance annuelle 2023	ADD
1075	2024-03-15	PERFAWARD	21268.01	EUR	Prime de performance annuelle 2024	ADD
1075	2025-03-15	PERFAWARD	20029.91	EUR	Prime de performance annuelle 2025	ADD
1075	2022-05-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1076	2024-03-15	PERFAWARD	8392.87	EUR	Prime de performance annuelle 2024	ADD
1076	2025-03-15	PERFAWARD	8022.54	EUR	Prime de performance annuelle 2025	ADD
1077	2022-03-15	PERFAWARD	9993.54	EUR	Prime de performance annuelle 2022	ADD
1077	2023-03-15	PERFAWARD	11821.76	EUR	Prime de performance annuelle 2023	ADD
1077	2024-03-15	PERFAWARD	13040.46	EUR	Prime de performance annuelle 2024	ADD
1077	2025-03-15	PERFAWARD	9881.14	EUR	Prime de performance annuelle 2025	ADD
1077	2025-11-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1078	2022-03-15	PERFAWARD	10373.17	EUR	Prime de performance annuelle 2022	ADD
1078	2023-03-15	PERFAWARD	9771.49	EUR	Prime de performance annuelle 2023	ADD
1078	2024-03-15	PERFAWARD	11711.60	EUR	Prime de performance annuelle 2024	ADD
1078	2021-04-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1079	2023-03-15	PERFAWARD	17391.98	EUR	Prime de performance annuelle 2023	ADD
1079	2024-03-15	PERFAWARD	17275.48	EUR	Prime de performance annuelle 2024	ADD
1079	2022-10-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1080	2022-03-15	PERFAWARD	5040.89	EUR	Prime de performance annuelle 2022	ADD
1080	2024-03-15	PERFAWARD	4801.60	EUR	Prime de performance annuelle 2024	ADD
1080	2025-03-15	PERFAWARD	5850.10	EUR	Prime de performance annuelle 2025	ADD
1081	2022-03-15	PERFAWARD	11675.36	EUR	Prime de performance annuelle 2022	ADD
1081	2023-03-15	PERFAWARD	13229.19	EUR	Prime de performance annuelle 2023	ADD
1081	2022-12-05	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1081	2020-10-15	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1081	2025-10-15	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1082	2025-03-15	PERFAWARD	8629.63	EUR	Prime de performance annuelle 2025	ADD
1083	2022-03-15	PERFAWARD	12819.47	EUR	Prime de performance annuelle 2022	ADD
1083	2023-03-15	PERFAWARD	10785.98	EUR	Prime de performance annuelle 2023	ADD
1083	2024-03-15	PERFAWARD	12100.09	EUR	Prime de performance annuelle 2024	ADD
1083	2025-03-15	PERFAWARD	13073.12	EUR	Prime de performance annuelle 2025	ADD
1083	2018-03-09	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1083	2023-03-09	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1084	2022-03-15	PERFAWARD	18207.70	EUR	Prime de performance annuelle 2022	ADD
1084	2023-03-15	PERFAWARD	15661.63	EUR	Prime de performance annuelle 2023	ADD
1084	2024-03-15	PERFAWARD	20928.12	EUR	Prime de performance annuelle 2024	ADD
1084	2018-03-31	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1084	2023-03-31	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1085	2022-03-15	PERFAWARD	17158.06	EUR	Prime de performance annuelle 2022	ADD
1085	2023-03-15	PERFAWARD	15882.85	EUR	Prime de performance annuelle 2023	ADD
1085	2024-03-15	PERFAWARD	16050.37	EUR	Prime de performance annuelle 2024	ADD
1085	2023-12-24	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1085	2021-10-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1086	2022-03-15	PERFAWARD	12869.07	EUR	Prime de performance annuelle 2022	ADD
1086	2024-03-15	PERFAWARD	12530.07	EUR	Prime de performance annuelle 2024	ADD
1086	2025-03-15	PERFAWARD	11180.44	EUR	Prime de performance annuelle 2025	ADD
1087	2022-03-15	PERFAWARD	4466.77	EUR	Prime de performance annuelle 2022	ADD
1087	2023-03-15	PERFAWARD	5733.05	EUR	Prime de performance annuelle 2023	ADD
1087	2024-03-15	PERFAWARD	4628.64	EUR	Prime de performance annuelle 2024	ADD
1087	2025-03-15	PERFAWARD	5024.38	EUR	Prime de performance annuelle 2025	ADD
1090	2024-03-15	PERFAWARD	600.11	EUR	Prime de performance annuelle 2024	ADD
1091	2022-03-15	PERFAWARD	9999.59	EUR	Prime de performance annuelle 2022	ADD
1091	2023-03-15	PERFAWARD	11533.77	EUR	Prime de performance annuelle 2023	ADD
1091	2024-04-01	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1092	2025-03-15	PERFAWARD	15317.37	EUR	Prime de performance annuelle 2025	ADD
1092	2024-12-22	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1093	2025-03-15	PERFAWARD	10969.99	EUR	Prime de performance annuelle 2025	ADD
1094	2023-03-15	PERFAWARD	15626.11	EUR	Prime de performance annuelle 2023	ADD
1094	2024-03-15	PERFAWARD	15803.21	EUR	Prime de performance annuelle 2024	ADD
1094	2018-01-26	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1094	2023-01-26	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1095	2022-03-15	PERFAWARD	9727.47	EUR	Prime de performance annuelle 2022	ADD
1095	2023-03-15	PERFAWARD	10375.53	EUR	Prime de performance annuelle 2023	ADD
1095	2024-03-15	PERFAWARD	9520.50	EUR	Prime de performance annuelle 2024	ADD
1095	2025-03-15	PERFAWARD	10556.29	EUR	Prime de performance annuelle 2025	ADD
1095	2022-10-24	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1096	2022-03-15	PERFAWARD	14860.35	EUR	Prime de performance annuelle 2022	ADD
1096	2024-03-15	PERFAWARD	14642.76	EUR	Prime de performance annuelle 2024	ADD
1096	2025-03-15	PERFAWARD	14424.17	EUR	Prime de performance annuelle 2025	ADD
1096	2023-02-03	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1096	2020-04-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1096	2025-04-20	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1097	2023-03-15	PERFAWARD	8509.39	EUR	Prime de performance annuelle 2023	ADD
1097	2024-03-15	PERFAWARD	8241.43	EUR	Prime de performance annuelle 2024	ADD
1097	2025-03-15	PERFAWARD	9800.42	EUR	Prime de performance annuelle 2025	ADD
1097	2024-09-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1097	2025-04-06	SPOTBONUS	2105.71	EUR	Prime d'excellence	ADD
1098	2022-03-15	PERFAWARD	13404.68	EUR	Prime de performance annuelle 2022	ADD
1098	2023-03-15	PERFAWARD	15253.53	EUR	Prime de performance annuelle 2023	ADD
1098	2024-03-15	PERFAWARD	13455.29	EUR	Prime de performance annuelle 2024	ADD
1098	2025-03-15	PERFAWARD	13215.22	EUR	Prime de performance annuelle 2025	ADD
1098	2020-02-29	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1098	2025-03-01	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1099	2023-03-15	PERFAWARD	13524.94	EUR	Prime de performance annuelle 2023	ADD
1099	2024-03-15	PERFAWARD	11534.35	EUR	Prime de performance annuelle 2024	ADD
1099	2025-03-15	PERFAWARD	13324.62	EUR	Prime de performance annuelle 2025	ADD
1099	2021-04-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1100	2025-11-13	SIGNON	3383.07	EUR	Bonus de signature de contrat	ADD
1101	2022-03-15	PERFAWARD	8214.36	EUR	Prime de performance annuelle 2022	ADD
1101	2023-03-15	PERFAWARD	8233.42	EUR	Prime de performance annuelle 2023	ADD
1101	2024-03-15	PERFAWARD	7361.84	EUR	Prime de performance annuelle 2024	ADD
1101	2025-03-15	PERFAWARD	7518.37	EUR	Prime de performance annuelle 2025	ADD
1101	2017-11-25	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1101	2022-11-25	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1102	2022-03-15	PERFAWARD	11233.67	EUR	Prime de performance annuelle 2022	ADD
1102	2023-03-15	PERFAWARD	13053.79	EUR	Prime de performance annuelle 2023	ADD
1102	2024-03-15	PERFAWARD	12617.41	EUR	Prime de performance annuelle 2024	ADD
1102	2025-03-15	PERFAWARD	13975.35	EUR	Prime de performance annuelle 2025	ADD
1102	2017-04-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1102	2022-04-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1103	2022-03-15	PERFAWARD	15024.47	EUR	Prime de performance annuelle 2022	ADD
1103	2023-03-15	PERFAWARD	18740.52	EUR	Prime de performance annuelle 2023	ADD
1103	2024-03-15	PERFAWARD	14449.00	EUR	Prime de performance annuelle 2024	ADD
1103	2025-03-15	PERFAWARD	17649.16	EUR	Prime de performance annuelle 2025	ADD
1103	2021-01-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1103	2026-01-23	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1104	2022-03-15	PERFAWARD	5274.17	EUR	Prime de performance annuelle 2022	ADD
1104	2023-03-15	PERFAWARD	5199.92	EUR	Prime de performance annuelle 2023	ADD
1104	2024-03-15	PERFAWARD	5247.30	EUR	Prime de performance annuelle 2024	ADD
1104	2025-04-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1105	2023-03-15	PERFAWARD	13439.93	EUR	Prime de performance annuelle 2023	ADD
1105	2025-03-15	PERFAWARD	16261.87	EUR	Prime de performance annuelle 2025	ADD
1105	2023-11-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1106	2022-03-15	PERFAWARD	14265.08	EUR	Prime de performance annuelle 2022	ADD
1106	2023-03-15	PERFAWARD	12725.58	EUR	Prime de performance annuelle 2023	ADD
1106	2024-03-15	PERFAWARD	14101.85	EUR	Prime de performance annuelle 2024	ADD
1106	2025-03-15	PERFAWARD	12798.47	EUR	Prime de performance annuelle 2025	ADD
1106	2023-06-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1107	2023-03-15	PERFAWARD	11093.60	EUR	Prime de performance annuelle 2023	ADD
1107	2025-03-15	PERFAWARD	11880.41	EUR	Prime de performance annuelle 2025	ADD
1107	2021-07-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1108	2022-03-15	PERFAWARD	9441.79	EUR	Prime de performance annuelle 2022	ADD
1108	2023-03-15	PERFAWARD	10015.65	EUR	Prime de performance annuelle 2023	ADD
1108	2024-03-15	PERFAWARD	8939.51	EUR	Prime de performance annuelle 2024	ADD
1108	2025-03-15	PERFAWARD	9500.53	EUR	Prime de performance annuelle 2025	ADD
1108	2024-03-28	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1110	2022-03-15	PERFAWARD	13293.20	EUR	Prime de performance annuelle 2022	ADD
1110	2023-03-15	PERFAWARD	11383.71	EUR	Prime de performance annuelle 2023	ADD
1110	2024-03-15	PERFAWARD	12777.80	EUR	Prime de performance annuelle 2024	ADD
1110	2025-03-15	PERFAWARD	10826.02	EUR	Prime de performance annuelle 2025	ADD
1110	2023-07-28	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1110	2020-04-09	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1110	2025-04-09	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1110	2022-09-18	SPOTBONUS	1936.69	EUR	Prime d'excellence	ADD
1111	2023-03-15	PERFAWARD	17903.74	EUR	Prime de performance annuelle 2023	ADD
1111	2024-03-15	PERFAWARD	17612.00	EUR	Prime de performance annuelle 2024	ADD
1111	2025-03-15	PERFAWARD	14831.79	EUR	Prime de performance annuelle 2025	ADD
1111	2018-01-13	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1111	2023-01-13	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1112	2022-03-15	PERFAWARD	13046.86	EUR	Prime de performance annuelle 2022	ADD
1112	2023-03-15	PERFAWARD	11552.24	EUR	Prime de performance annuelle 2023	ADD
1112	2024-03-15	PERFAWARD	13784.34	EUR	Prime de performance annuelle 2024	ADD
1112	2025-03-15	PERFAWARD	14131.12	EUR	Prime de performance annuelle 2025	ADD
1112	2024-07-30	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1112	2022-05-17	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1114	2022-03-15	PERFAWARD	4420.12	EUR	Prime de performance annuelle 2022	ADD
1114	2023-03-15	PERFAWARD	4623.86	EUR	Prime de performance annuelle 2023	ADD
1114	2024-03-15	PERFAWARD	4760.08	EUR	Prime de performance annuelle 2024	ADD
1114	2026-01-28	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1115	2022-03-15	PERFAWARD	10141.14	EUR	Prime de performance annuelle 2022	ADD
1115	2023-03-15	PERFAWARD	11347.24	EUR	Prime de performance annuelle 2023	ADD
1115	2024-03-15	PERFAWARD	11988.17	EUR	Prime de performance annuelle 2024	ADD
1115	2025-03-15	PERFAWARD	12023.54	EUR	Prime de performance annuelle 2025	ADD
1115	2025-09-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1116	2022-03-15	PERFAWARD	10871.93	EUR	Prime de performance annuelle 2022	ADD
1116	2023-03-15	PERFAWARD	12825.63	EUR	Prime de performance annuelle 2023	ADD
1116	2024-03-15	PERFAWARD	10741.72	EUR	Prime de performance annuelle 2024	ADD
1116	2018-03-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1116	2023-03-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1116	2024-08-01	SPOTBONUS	828.96	EUR	Prime d'excellence	ADD
1117	2024-03-15	PERFAWARD	1230.52	EUR	Prime de performance annuelle 2024	ADD
1117	2025-03-15	PERFAWARD	1281.90	EUR	Prime de performance annuelle 2025	ADD
1118	2022-03-15	PERFAWARD	19400.66	EUR	Prime de performance annuelle 2022	ADD
1118	2023-03-15	PERFAWARD	18769.19	EUR	Prime de performance annuelle 2023	ADD
1118	2024-03-15	PERFAWARD	20870.43	EUR	Prime de performance annuelle 2024	ADD
1118	2025-03-07	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1118	2019-01-29	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1118	2024-01-29	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1119	2022-03-15	PERFAWARD	12841.60	EUR	Prime de performance annuelle 2022	ADD
1119	2023-03-15	PERFAWARD	14827.43	EUR	Prime de performance annuelle 2023	ADD
1119	2025-03-15	PERFAWARD	16810.13	EUR	Prime de performance annuelle 2025	ADD
1120	2023-03-15	PERFAWARD	12927.86	EUR	Prime de performance annuelle 2023	ADD
1120	2024-03-15	PERFAWARD	14604.28	EUR	Prime de performance annuelle 2024	ADD
1120	2025-03-15	PERFAWARD	14070.05	EUR	Prime de performance annuelle 2025	ADD
1120	2018-06-08	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1120	2023-06-08	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1121	2022-03-15	PERFAWARD	9657.87	EUR	Prime de performance annuelle 2022	ADD
1121	2023-03-15	PERFAWARD	9156.97	EUR	Prime de performance annuelle 2023	ADD
1121	2024-03-15	PERFAWARD	10309.09	EUR	Prime de performance annuelle 2024	ADD
1121	2025-03-15	PERFAWARD	10289.61	EUR	Prime de performance annuelle 2025	ADD
1122	2023-03-15	PERFAWARD	13486.54	EUR	Prime de performance annuelle 2023	ADD
1122	2024-03-15	PERFAWARD	12896.12	EUR	Prime de performance annuelle 2024	ADD
1122	2025-01-20	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1122	2022-06-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1123	2024-03-15	PERFAWARD	66.09	EUR	Prime de performance annuelle 2024	ADD
1123	2025-03-15	PERFAWARD	55.33	EUR	Prime de performance annuelle 2025	ADD
1124	2022-03-15	PERFAWARD	9111.72	EUR	Prime de performance annuelle 2022	ADD
1124	2023-03-15	PERFAWARD	8449.96	EUR	Prime de performance annuelle 2023	ADD
1124	2024-03-15	PERFAWARD	8105.16	EUR	Prime de performance annuelle 2024	ADD
1124	2025-03-15	PERFAWARD	8232.73	EUR	Prime de performance annuelle 2025	ADD
1124	2021-07-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1124	2016-12-17	RELOCATION	5588.13	EUR	Aide à la mobilité géographique	ADD
1125	2024-03-15	PERFAWARD	740.92	EUR	Prime de performance annuelle 2024	ADD
1126	2022-03-15	PERFAWARD	10528.98	EUR	Prime de performance annuelle 2022	ADD
1126	2023-03-15	PERFAWARD	9977.15	EUR	Prime de performance annuelle 2023	ADD
1126	2024-03-15	PERFAWARD	10566.65	EUR	Prime de performance annuelle 2024	ADD
1126	2025-03-15	PERFAWARD	9765.06	EUR	Prime de performance annuelle 2025	ADD
1126	2022-06-27	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1126	2024-10-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1127	2022-03-15	PERFAWARD	17977.30	EUR	Prime de performance annuelle 2022	ADD
1127	2023-03-15	PERFAWARD	18082.74	EUR	Prime de performance annuelle 2023	ADD
1127	2025-03-15	PERFAWARD	17422.44	EUR	Prime de performance annuelle 2025	ADD
1127	2018-04-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1127	2023-04-10	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1128	2023-03-15	PERFAWARD	69002.88	EUR	Prime de performance annuelle 2023	ADD
1128	2024-03-15	PERFAWARD	59205.17	EUR	Prime de performance annuelle 2024	ADD
1128	2025-03-15	PERFAWARD	61857.70	EUR	Prime de performance annuelle 2025	ADD
1129	2022-03-15	PERFAWARD	11634.82	EUR	Prime de performance annuelle 2022	ADD
1129	2023-03-15	PERFAWARD	10004.85	EUR	Prime de performance annuelle 2023	ADD
1129	2024-03-15	PERFAWARD	10335.95	EUR	Prime de performance annuelle 2024	ADD
1129	2025-03-15	PERFAWARD	11674.10	EUR	Prime de performance annuelle 2025	ADD
1129	2018-04-15	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1129	2023-04-15	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1130	2023-03-15	PERFAWARD	2651.44	EUR	Prime de performance annuelle 2023	ADD
1130	2025-03-15	PERFAWARD	3191.99	EUR	Prime de performance annuelle 2025	ADD
1130	2025-08-24	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1131	2022-03-15	PERFAWARD	9776.84	EUR	Prime de performance annuelle 2022	ADD
1131	2023-03-15	PERFAWARD	10577.11	EUR	Prime de performance annuelle 2023	ADD
1131	2024-03-15	PERFAWARD	8329.20	EUR	Prime de performance annuelle 2024	ADD
1131	2025-03-15	PERFAWARD	9992.64	EUR	Prime de performance annuelle 2025	ADD
1131	2022-12-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1132	2024-03-15	PERFAWARD	14290.17	EUR	Prime de performance annuelle 2024	ADD
1132	2025-03-15	PERFAWARD	11360.23	EUR	Prime de performance annuelle 2025	ADD
1132	2023-04-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1133	2022-03-15	PERFAWARD	25399.62	EUR	Prime de performance annuelle 2022	ADD
1133	2023-03-15	PERFAWARD	24185.99	EUR	Prime de performance annuelle 2023	ADD
1133	2024-03-15	PERFAWARD	23463.70	EUR	Prime de performance annuelle 2024	ADD
1133	2025-03-15	PERFAWARD	29969.83	EUR	Prime de performance annuelle 2025	ADD
1133	2024-06-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1134	2025-11-08	SIGNON	5196.97	EUR	Bonus de signature de contrat	ADD
1135	2022-03-15	PERFAWARD	7807.83	EUR	Prime de performance annuelle 2022	ADD
1135	2023-03-15	PERFAWARD	9101.18	EUR	Prime de performance annuelle 2023	ADD
1135	2017-03-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1135	2022-03-05	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1136	2022-03-15	PERFAWARD	25272.04	EUR	Prime de performance annuelle 2022	ADD
1136	2023-03-15	PERFAWARD	24438.55	EUR	Prime de performance annuelle 2023	ADD
1136	2024-03-15	PERFAWARD	25099.42	EUR	Prime de performance annuelle 2024	ADD
1136	2025-03-15	PERFAWARD	24088.27	EUR	Prime de performance annuelle 2025	ADD
1136	2022-02-18	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1137	2023-03-15	PERFAWARD	14845.99	EUR	Prime de performance annuelle 2023	ADD
1137	2024-03-15	PERFAWARD	15068.76	EUR	Prime de performance annuelle 2024	ADD
1137	2019-04-29	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1137	2024-04-29	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1138	2022-03-15	PERFAWARD	10150.37	EUR	Prime de performance annuelle 2022	ADD
1138	2023-03-15	PERFAWARD	7786.12	EUR	Prime de performance annuelle 2023	ADD
1138	2025-03-15	PERFAWARD	8106.07	EUR	Prime de performance annuelle 2025	ADD
1138	2018-11-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1138	2023-11-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1139	2023-03-15	PERFAWARD	12056.02	EUR	Prime de performance annuelle 2023	ADD
1139	2024-03-15	PERFAWARD	13768.46	EUR	Prime de performance annuelle 2024	ADD
1139	2021-09-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1140	2023-03-15	PERFAWARD	15416.01	EUR	Prime de performance annuelle 2023	ADD
1140	2020-08-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1140	2025-08-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1141	2024-03-15	PERFAWARD	515.56	EUR	Prime de performance annuelle 2024	ADD
1141	2025-03-15	PERFAWARD	535.92	EUR	Prime de performance annuelle 2025	ADD
1141	2025-04-23	SPOTBONUS	841.17	EUR	Prime d'excellence	ADD
1142	2022-03-15	PERFAWARD	40787.85	EUR	Prime de performance annuelle 2022	ADD
1142	2023-03-15	PERFAWARD	34969.49	EUR	Prime de performance annuelle 2023	ADD
1142	2024-03-15	PERFAWARD	40765.94	EUR	Prime de performance annuelle 2024	ADD
1142	2025-03-15	PERFAWARD	34335.21	EUR	Prime de performance annuelle 2025	ADD
1142	2025-05-08	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1143	2023-03-15	PERFAWARD	18412.97	EUR	Prime de performance annuelle 2023	ADD
1143	2024-03-15	PERFAWARD	18141.21	EUR	Prime de performance annuelle 2024	ADD
1143	2025-03-15	PERFAWARD	16568.84	EUR	Prime de performance annuelle 2025	ADD
1143	2018-08-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1143	2023-08-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1144	2023-03-15	PERFAWARD	14935.87	EUR	Prime de performance annuelle 2023	ADD
1144	2024-03-15	PERFAWARD	14853.24	EUR	Prime de performance annuelle 2024	ADD
1144	2021-09-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1145	2022-03-15	PERFAWARD	24502.34	EUR	Prime de performance annuelle 2022	ADD
1145	2024-03-15	PERFAWARD	22419.26	EUR	Prime de performance annuelle 2024	ADD
1145	2022-09-18	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1146	2022-03-15	PERFAWARD	15588.71	EUR	Prime de performance annuelle 2022	ADD
1146	2023-03-15	PERFAWARD	16939.56	EUR	Prime de performance annuelle 2023	ADD
1146	2024-03-15	PERFAWARD	15174.89	EUR	Prime de performance annuelle 2024	ADD
1146	2025-03-15	PERFAWARD	19631.11	EUR	Prime de performance annuelle 2025	ADD
1146	2025-06-26	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1146	2021-06-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1147	2022-03-15	PERFAWARD	11308.51	EUR	Prime de performance annuelle 2022	ADD
1147	2023-03-15	PERFAWARD	10566.19	EUR	Prime de performance annuelle 2023	ADD
1147	2024-03-15	PERFAWARD	10686.56	EUR	Prime de performance annuelle 2024	ADD
1147	2025-03-15	PERFAWARD	11133.60	EUR	Prime de performance annuelle 2025	ADD
1147	2024-07-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1148	2022-03-15	PERFAWARD	15974.31	EUR	Prime de performance annuelle 2022	ADD
1148	2023-03-15	PERFAWARD	16575.54	EUR	Prime de performance annuelle 2023	ADD
1148	2024-03-15	PERFAWARD	15198.69	EUR	Prime de performance annuelle 2024	ADD
1148	2025-03-15	PERFAWARD	14035.52	EUR	Prime de performance annuelle 2025	ADD
1148	2022-09-12	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1148	2017-03-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1148	2022-03-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1149	2024-03-15	PERFAWARD	822.99	EUR	Prime de performance annuelle 2024	ADD
1149	2025-03-15	PERFAWARD	773.91	EUR	Prime de performance annuelle 2025	ADD
1149	2023-04-29	SPOTBONUS	983.11	EUR	Prime d'excellence	ADD
1150	2022-03-15	PERFAWARD	10213.26	EUR	Prime de performance annuelle 2022	ADD
1150	2023-03-15	PERFAWARD	10275.93	EUR	Prime de performance annuelle 2023	ADD
1150	2024-03-15	PERFAWARD	8963.87	EUR	Prime de performance annuelle 2024	ADD
1150	2025-03-15	PERFAWARD	8390.93	EUR	Prime de performance annuelle 2025	ADD
1150	2017-08-26	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1150	2022-08-26	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1152	2022-03-15	PERFAWARD	13583.55	EUR	Prime de performance annuelle 2022	ADD
1152	2023-03-15	PERFAWARD	12698.58	EUR	Prime de performance annuelle 2023	ADD
1152	2024-03-15	PERFAWARD	14954.10	EUR	Prime de performance annuelle 2024	ADD
1152	2025-03-15	PERFAWARD	13429.45	EUR	Prime de performance annuelle 2025	ADD
1152	2019-03-17	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1152	2024-03-17	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1153	2024-03-15	PERFAWARD	9699.14	EUR	Prime de performance annuelle 2024	ADD
1153	2025-03-15	PERFAWARD	9158.80	EUR	Prime de performance annuelle 2025	ADD
1153	2022-06-17	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1153	2023-03-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1153	2024-06-17	SPOTBONUS	973.78	EUR	Prime d'excellence	ADD
1154	2024-03-15	PERFAWARD	13464.95	EUR	Prime de performance annuelle 2024	ADD
1154	2025-03-15	PERFAWARD	13288.38	EUR	Prime de performance annuelle 2025	ADD
1154	2020-08-13	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1154	2025-08-13	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1155	2024-03-15	PERFAWARD	10809.58	EUR	Prime de performance annuelle 2024	ADD
1156	2025-05-24	SIGNON	6700.21	EUR	Bonus de signature de contrat	ADD
1157	2023-03-15	PERFAWARD	17184.30	EUR	Prime de performance annuelle 2023	ADD
1157	2024-03-15	PERFAWARD	14110.43	EUR	Prime de performance annuelle 2024	ADD
1157	2025-03-15	PERFAWARD	13576.87	EUR	Prime de performance annuelle 2025	ADD
1158	2022-03-15	PERFAWARD	13578.62	EUR	Prime de performance annuelle 2022	ADD
1158	2024-03-15	PERFAWARD	11313.41	EUR	Prime de performance annuelle 2024	ADD
1158	2025-03-15	PERFAWARD	11769.80	EUR	Prime de performance annuelle 2025	ADD
1158	2019-10-21	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1158	2024-10-21	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1160	2022-03-15	PERFAWARD	11015.77	EUR	Prime de performance annuelle 2022	ADD
1160	2024-03-15	PERFAWARD	11296.98	EUR	Prime de performance annuelle 2024	ADD
1160	2025-03-15	PERFAWARD	11690.26	EUR	Prime de performance annuelle 2025	ADD
1160	2022-09-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1161	2025-03-15	PERFAWARD	11721.62	EUR	Prime de performance annuelle 2025	ADD
1162	2022-03-15	PERFAWARD	15219.15	EUR	Prime de performance annuelle 2022	ADD
1162	2023-03-15	PERFAWARD	15722.49	EUR	Prime de performance annuelle 2023	ADD
1162	2024-03-15	PERFAWARD	14851.77	EUR	Prime de performance annuelle 2024	ADD
1162	2025-03-15	PERFAWARD	13638.40	EUR	Prime de performance annuelle 2025	ADD
1162	2019-10-01	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1162	2024-10-01	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1163	2022-03-15	PERFAWARD	10191.36	EUR	Prime de performance annuelle 2022	ADD
1163	2024-03-15	PERFAWARD	11495.68	EUR	Prime de performance annuelle 2024	ADD
1163	2017-09-12	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1163	2022-09-12	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1163	2022-02-09	SPOTBONUS	2447.10	EUR	Prime d'excellence	ADD
1165	2022-03-15	PERFAWARD	15025.17	EUR	Prime de performance annuelle 2022	ADD
1165	2023-03-15	PERFAWARD	14154.24	EUR	Prime de performance annuelle 2023	ADD
1165	2024-03-15	PERFAWARD	15051.00	EUR	Prime de performance annuelle 2024	ADD
1165	2025-03-15	PERFAWARD	12088.89	EUR	Prime de performance annuelle 2025	ADD
1165	2025-12-13	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1165	2022-03-26	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1166	2022-03-15	PERFAWARD	17157.18	EUR	Prime de performance annuelle 2022	ADD
1166	2024-03-15	PERFAWARD	19095.80	EUR	Prime de performance annuelle 2024	ADD
1166	2025-03-15	PERFAWARD	22440.85	EUR	Prime de performance annuelle 2025	ADD
1166	2017-06-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1166	2022-06-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1167	2022-03-15	PERFAWARD	11055.36	EUR	Prime de performance annuelle 2022	ADD
1167	2023-03-15	PERFAWARD	10972.94	EUR	Prime de performance annuelle 2023	ADD
1167	2024-03-15	PERFAWARD	9039.13	EUR	Prime de performance annuelle 2024	ADD
1167	2025-03-15	PERFAWARD	9993.11	EUR	Prime de performance annuelle 2025	ADD
1167	2023-10-26	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1168	2022-03-15	PERFAWARD	13878.55	EUR	Prime de performance annuelle 2022	ADD
1168	2024-03-15	PERFAWARD	13180.84	EUR	Prime de performance annuelle 2024	ADD
1168	2018-03-22	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1168	2023-03-22	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1169	2023-03-15	PERFAWARD	5437.84	EUR	Prime de performance annuelle 2023	ADD
1169	2024-03-15	PERFAWARD	5221.80	EUR	Prime de performance annuelle 2024	ADD
1169	2025-03-15	PERFAWARD	4937.24	EUR	Prime de performance annuelle 2025	ADD
1169	2023-04-30	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1170	2024-03-15	PERFAWARD	4618.85	EUR	Prime de performance annuelle 2024	ADD
1170	2025-03-15	PERFAWARD	4368.31	EUR	Prime de performance annuelle 2025	ADD
1171	2022-03-15	PERFAWARD	13405.15	EUR	Prime de performance annuelle 2022	ADD
1171	2024-03-15	PERFAWARD	12221.69	EUR	Prime de performance annuelle 2024	ADD
1171	2025-03-15	PERFAWARD	15313.23	EUR	Prime de performance annuelle 2025	ADD
1171	2017-07-05	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1171	2022-07-05	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1172	2022-03-15	PERFAWARD	8733.50	EUR	Prime de performance annuelle 2022	ADD
1172	2023-03-15	PERFAWARD	8725.51	EUR	Prime de performance annuelle 2023	ADD
1172	2024-03-15	PERFAWARD	9876.88	EUR	Prime de performance annuelle 2024	ADD
1172	2025-03-15	PERFAWARD	10592.10	EUR	Prime de performance annuelle 2025	ADD
1172	2020-01-29	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1172	2025-01-29	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1173	2022-03-15	PERFAWARD	9585.29	EUR	Prime de performance annuelle 2022	ADD
1173	2023-03-15	PERFAWARD	10039.55	EUR	Prime de performance annuelle 2023	ADD
1173	2024-03-15	PERFAWARD	8662.50	EUR	Prime de performance annuelle 2024	ADD
1173	2025-03-15	PERFAWARD	8378.35	EUR	Prime de performance annuelle 2025	ADD
1173	2017-09-09	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1173	2022-09-09	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1174	2022-03-15	PERFAWARD	19084.86	EUR	Prime de performance annuelle 2022	ADD
1174	2023-03-15	PERFAWARD	20064.61	EUR	Prime de performance annuelle 2023	ADD
1174	2024-03-15	PERFAWARD	22054.79	EUR	Prime de performance annuelle 2024	ADD
1174	2024-06-08	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1175	2025-07-02	SIGNON	6608.66	EUR	Bonus de signature de contrat	ADD
1176	2023-03-15	PERFAWARD	12558.79	EUR	Prime de performance annuelle 2023	ADD
1176	2024-03-15	PERFAWARD	11001.12	EUR	Prime de performance annuelle 2024	ADD
1176	2025-03-15	PERFAWARD	12345.28	EUR	Prime de performance annuelle 2025	ADD
1178	2023-03-15	PERFAWARD	13506.56	EUR	Prime de performance annuelle 2023	ADD
1178	2024-03-15	PERFAWARD	15488.58	EUR	Prime de performance annuelle 2024	ADD
1178	2025-03-15	PERFAWARD	14267.64	EUR	Prime de performance annuelle 2025	ADD
1178	2021-05-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1179	2022-03-15	PERFAWARD	16845.85	EUR	Prime de performance annuelle 2022	ADD
1179	2023-03-15	PERFAWARD	16857.74	EUR	Prime de performance annuelle 2023	ADD
1179	2024-06-17	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1180	2025-11-04	SIGNON	6073.57	EUR	Bonus de signature de contrat	ADD
1181	2022-03-15	PERFAWARD	12602.40	EUR	Prime de performance annuelle 2022	ADD
1181	2023-03-15	PERFAWARD	13737.99	EUR	Prime de performance annuelle 2023	ADD
1181	2024-03-15	PERFAWARD	11897.75	EUR	Prime de performance annuelle 2024	ADD
1181	2025-03-15	PERFAWARD	12442.00	EUR	Prime de performance annuelle 2025	ADD
1181	2024-05-18	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1182	2023-03-15	PERFAWARD	14912.85	EUR	Prime de performance annuelle 2023	ADD
1182	2024-03-15	PERFAWARD	18021.05	EUR	Prime de performance annuelle 2024	ADD
1182	2025-03-15	PERFAWARD	13962.14	EUR	Prime de performance annuelle 2025	ADD
1182	2022-08-28	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1184	2022-03-15	PERFAWARD	9109.01	EUR	Prime de performance annuelle 2022	ADD
1184	2023-03-15	PERFAWARD	9678.52	EUR	Prime de performance annuelle 2023	ADD
1184	2024-03-15	PERFAWARD	10044.14	EUR	Prime de performance annuelle 2024	ADD
1184	2025-03-15	PERFAWARD	10642.43	EUR	Prime de performance annuelle 2025	ADD
1184	2022-02-24	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1185	2024-03-15	PERFAWARD	10360.63	EUR	Prime de performance annuelle 2024	ADD
1185	2025-03-15	PERFAWARD	12259.01	EUR	Prime de performance annuelle 2025	ADD
1186	2022-03-15	PERFAWARD	21360.42	EUR	Prime de performance annuelle 2022	ADD
1186	2023-03-15	PERFAWARD	19993.22	EUR	Prime de performance annuelle 2023	ADD
1186	2024-03-15	PERFAWARD	17674.43	EUR	Prime de performance annuelle 2024	ADD
1186	2025-03-15	PERFAWARD	17990.60	EUR	Prime de performance annuelle 2025	ADD
1186	2023-11-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1187	2022-03-15	PERFAWARD	15583.13	EUR	Prime de performance annuelle 2022	ADD
1187	2024-03-15	PERFAWARD	13446.94	EUR	Prime de performance annuelle 2024	ADD
1187	2025-03-15	PERFAWARD	16078.84	EUR	Prime de performance annuelle 2025	ADD
1187	2019-03-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1187	2024-03-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1188	2024-03-15	PERFAWARD	6874.34	EUR	Prime de performance annuelle 2024	ADD
1188	2025-03-15	PERFAWARD	6966.31	EUR	Prime de performance annuelle 2025	ADD
1189	2025-03-15	PERFAWARD	9886.17	EUR	Prime de performance annuelle 2025	ADD
1189	2024-06-13	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1191	2022-03-15	PERFAWARD	4548.12	EUR	Prime de performance annuelle 2022	ADD
1191	2023-03-15	PERFAWARD	5932.08	EUR	Prime de performance annuelle 2023	ADD
1191	2024-03-15	PERFAWARD	4716.35	EUR	Prime de performance annuelle 2024	ADD
1191	2025-03-15	PERFAWARD	4419.82	EUR	Prime de performance annuelle 2025	ADD
1192	2022-03-15	PERFAWARD	24513.15	EUR	Prime de performance annuelle 2022	ADD
1192	2024-03-15	PERFAWARD	19396.10	EUR	Prime de performance annuelle 2024	ADD
1192	2025-03-15	PERFAWARD	23104.57	EUR	Prime de performance annuelle 2025	ADD
1192	2024-11-18	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1192	2021-12-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1193	2025-06-28	SIGNON	4371.78	EUR	Bonus de signature de contrat	ADD
1193	2025-11-11	SPOTBONUS	2286.00	EUR	Prime d'excellence	ADD
1194	2024-03-15	PERFAWARD	15695.62	EUR	Prime de performance annuelle 2024	ADD
1194	2025-03-15	PERFAWARD	17611.00	EUR	Prime de performance annuelle 2025	ADD
1196	2022-03-15	PERFAWARD	21444.47	EUR	Prime de performance annuelle 2022	ADD
1196	2024-03-15	PERFAWARD	19155.36	EUR	Prime de performance annuelle 2024	ADD
1196	2025-03-15	PERFAWARD	23562.67	EUR	Prime de performance annuelle 2025	ADD
1196	2020-09-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1196	2025-09-04	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1197	2025-08-17	SIGNON	2730.83	EUR	Bonus de signature de contrat	ADD
1197	2023-08-07	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1198	2024-03-15	PERFAWARD	16464.61	EUR	Prime de performance annuelle 2024	ADD
1198	2025-03-15	PERFAWARD	17590.75	EUR	Prime de performance annuelle 2025	ADD
1198	2018-06-25	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1198	2023-06-25	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1199	2024-03-15	PERFAWARD	5133.24	EUR	Prime de performance annuelle 2024	ADD
1199	2025-03-15	PERFAWARD	5966.09	EUR	Prime de performance annuelle 2025	ADD
1200	2026-01-17	SIGNON	6729.68	EUR	Bonus de signature de contrat	ADD
1201	2022-03-15	PERFAWARD	12053.86	EUR	Prime de performance annuelle 2022	ADD
1201	2023-03-15	PERFAWARD	11575.12	EUR	Prime de performance annuelle 2023	ADD
1201	2024-03-15	PERFAWARD	11532.54	EUR	Prime de performance annuelle 2024	ADD
1201	2025-03-15	PERFAWARD	10777.79	EUR	Prime de performance annuelle 2025	ADD
1201	2022-04-27	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1202	2022-03-15	PERFAWARD	12282.77	EUR	Prime de performance annuelle 2022	ADD
1202	2023-03-15	PERFAWARD	10956.67	EUR	Prime de performance annuelle 2023	ADD
1202	2024-03-15	PERFAWARD	12453.81	EUR	Prime de performance annuelle 2024	ADD
1202	2025-03-15	PERFAWARD	10796.05	EUR	Prime de performance annuelle 2025	ADD
1202	2023-09-09	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1202	2019-07-19	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1202	2024-07-19	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1203	2022-03-15	PERFAWARD	15180.14	EUR	Prime de performance annuelle 2022	ADD
1203	2024-03-15	PERFAWARD	13130.41	EUR	Prime de performance annuelle 2024	ADD
1203	2021-03-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1203	2025-01-15	SPOTBONUS	2078.59	EUR	Prime d'excellence	ADD
1205	2022-03-15	PERFAWARD	9983.02	EUR	Prime de performance annuelle 2022	ADD
1205	2023-03-15	PERFAWARD	10065.87	EUR	Prime de performance annuelle 2023	ADD
1205	2024-03-15	PERFAWARD	9015.29	EUR	Prime de performance annuelle 2024	ADD
1205	2025-03-15	PERFAWARD	10124.96	EUR	Prime de performance annuelle 2025	ADD
1205	2024-02-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1206	2024-03-15	PERFAWARD	1011.63	EUR	Prime de performance annuelle 2024	ADD
1206	2025-03-15	PERFAWARD	841.48	EUR	Prime de performance annuelle 2025	ADD
1207	2022-03-15	PERFAWARD	14782.29	EUR	Prime de performance annuelle 2022	ADD
1207	2023-03-15	PERFAWARD	15225.08	EUR	Prime de performance annuelle 2023	ADD
1207	2024-03-15	PERFAWARD	15710.14	EUR	Prime de performance annuelle 2024	ADD
1207	2025-03-15	PERFAWARD	16772.27	EUR	Prime de performance annuelle 2025	ADD
1207	2023-11-03	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1208	2024-03-15	PERFAWARD	3841.15	EUR	Prime de performance annuelle 2024	ADD
1208	2025-03-15	PERFAWARD	3881.53	EUR	Prime de performance annuelle 2025	ADD
1209	2022-11-05	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1211	2025-10-20	SIGNON	4061.60	EUR	Bonus de signature de contrat	ADD
1211	2022-04-29	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1212	2022-03-15	PERFAWARD	12157.92	EUR	Prime de performance annuelle 2022	ADD
1212	2023-03-15	PERFAWARD	9688.82	EUR	Prime de performance annuelle 2023	ADD
1212	2024-03-15	PERFAWARD	11600.74	EUR	Prime de performance annuelle 2024	ADD
1212	2025-03-15	PERFAWARD	12215.87	EUR	Prime de performance annuelle 2025	ADD
1212	2017-11-23	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1212	2022-11-23	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1213	2022-03-15	PERFAWARD	16622.70	EUR	Prime de performance annuelle 2022	ADD
1213	2023-03-15	PERFAWARD	16526.76	EUR	Prime de performance annuelle 2023	ADD
1213	2024-03-15	PERFAWARD	18063.86	EUR	Prime de performance annuelle 2024	ADD
1213	2025-03-15	PERFAWARD	16233.78	EUR	Prime de performance annuelle 2025	ADD
1213	2024-10-22	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1214	2024-03-15	PERFAWARD	260.20	EUR	Prime de performance annuelle 2024	ADD
1214	2025-03-15	PERFAWARD	253.75	EUR	Prime de performance annuelle 2025	ADD
1215	2022-03-15	PERFAWARD	22206.14	EUR	Prime de performance annuelle 2022	ADD
1215	2023-03-15	PERFAWARD	25270.96	EUR	Prime de performance annuelle 2023	ADD
1215	2024-03-15	PERFAWARD	25267.37	EUR	Prime de performance annuelle 2024	ADD
1215	2025-03-15	PERFAWARD	21943.31	EUR	Prime de performance annuelle 2025	ADD
1215	2024-07-28	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1216	2023-03-15	PERFAWARD	3043.30	EUR	Prime de performance annuelle 2023	ADD
1216	2024-03-15	PERFAWARD	3801.65	EUR	Prime de performance annuelle 2024	ADD
1216	2025-03-15	PERFAWARD	3006.14	EUR	Prime de performance annuelle 2025	ADD
1217	2025-03-15	PERFAWARD	5086.05	EUR	Prime de performance annuelle 2025	ADD
1218	2022-03-15	PERFAWARD	9802.07	EUR	Prime de performance annuelle 2022	ADD
1218	2023-03-15	PERFAWARD	10118.00	EUR	Prime de performance annuelle 2023	ADD
1218	2024-03-15	PERFAWARD	9939.61	EUR	Prime de performance annuelle 2024	ADD
1218	2021-06-13	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1219	2023-03-15	PERFAWARD	9405.03	EUR	Prime de performance annuelle 2023	ADD
1219	2024-03-15	PERFAWARD	9412.21	EUR	Prime de performance annuelle 2024	ADD
1219	2025-03-15	PERFAWARD	11743.68	EUR	Prime de performance annuelle 2025	ADD
1219	2024-07-08	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1219	2021-10-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1220	2022-03-15	PERFAWARD	13813.60	EUR	Prime de performance annuelle 2022	ADD
1220	2024-03-15	PERFAWARD	14605.90	EUR	Prime de performance annuelle 2024	ADD
1220	2025-03-15	PERFAWARD	12509.83	EUR	Prime de performance annuelle 2025	ADD
1220	2024-12-08	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1220	2021-02-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1220	2026-02-10	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1221	2022-03-15	PERFAWARD	9147.93	EUR	Prime de performance annuelle 2022	ADD
1221	2023-03-15	PERFAWARD	11713.81	EUR	Prime de performance annuelle 2023	ADD
1221	2024-03-15	PERFAWARD	10166.73	EUR	Prime de performance annuelle 2024	ADD
1221	2025-03-15	PERFAWARD	9113.73	EUR	Prime de performance annuelle 2025	ADD
1221	2018-05-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1221	2023-05-11	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1221	2025-07-14	SPOTBONUS	2314.94	EUR	Prime d'excellence	ADD
1222	2023-03-15	PERFAWARD	21523.36	EUR	Prime de performance annuelle 2023	ADD
1222	2024-03-15	PERFAWARD	17417.25	EUR	Prime de performance annuelle 2024	ADD
1222	2025-03-15	PERFAWARD	21825.68	EUR	Prime de performance annuelle 2025	ADD
1222	2021-08-30	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1223	2023-03-15	PERFAWARD	4844.02	EUR	Prime de performance annuelle 2023	ADD
1223	2024-03-15	PERFAWARD	5035.06	EUR	Prime de performance annuelle 2024	ADD
1223	2025-03-15	PERFAWARD	4887.26	EUR	Prime de performance annuelle 2025	ADD
1224	2023-03-15	PERFAWARD	18020.28	EUR	Prime de performance annuelle 2023	ADD
1224	2024-03-15	PERFAWARD	16084.98	EUR	Prime de performance annuelle 2024	ADD
1224	2025-03-15	PERFAWARD	16014.39	EUR	Prime de performance annuelle 2025	ADD
1224	2019-08-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1224	2024-08-10	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1225	2025-03-15	PERFAWARD	16228.70	EUR	Prime de performance annuelle 2025	ADD
1226	2022-03-15	PERFAWARD	9405.15	EUR	Prime de performance annuelle 2022	ADD
1226	2023-03-15	PERFAWARD	8795.90	EUR	Prime de performance annuelle 2023	ADD
1226	2024-03-15	PERFAWARD	8791.51	EUR	Prime de performance annuelle 2024	ADD
1226	2025-03-15	PERFAWARD	8945.31	EUR	Prime de performance annuelle 2025	ADD
1226	2020-09-06	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1226	2025-09-06	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1226	2024-09-01	SPOTBONUS	1747.93	EUR	Prime d'excellence	ADD
1228	2022-03-15	PERFAWARD	7699.04	EUR	Prime de performance annuelle 2022	ADD
1228	2024-03-15	PERFAWARD	8770.07	EUR	Prime de performance annuelle 2024	ADD
1228	2025-03-15	PERFAWARD	6636.11	EUR	Prime de performance annuelle 2025	ADD
1228	2024-12-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1229	2023-03-15	PERFAWARD	28325.04	EUR	Prime de performance annuelle 2023	ADD
1229	2024-03-15	PERFAWARD	25172.75	EUR	Prime de performance annuelle 2024	ADD
1229	2025-03-15	PERFAWARD	28753.41	EUR	Prime de performance annuelle 2025	ADD
1229	2023-01-13	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1229	2020-07-24	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1229	2025-07-24	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1231	2022-03-15	PERFAWARD	16304.32	EUR	Prime de performance annuelle 2022	ADD
1231	2023-03-15	PERFAWARD	16552.84	EUR	Prime de performance annuelle 2023	ADD
1231	2024-03-15	PERFAWARD	16250.37	EUR	Prime de performance annuelle 2024	ADD
1231	2025-03-15	PERFAWARD	18016.35	EUR	Prime de performance annuelle 2025	ADD
1231	2017-05-16	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1231	2022-05-16	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1232	2022-03-15	PERFAWARD	6533.66	EUR	Prime de performance annuelle 2022	ADD
1232	2023-03-15	PERFAWARD	7362.26	EUR	Prime de performance annuelle 2023	ADD
1232	2024-03-15	PERFAWARD	7414.53	EUR	Prime de performance annuelle 2024	ADD
1232	2025-03-15	PERFAWARD	7329.31	EUR	Prime de performance annuelle 2025	ADD
1232	2017-02-21	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1232	2022-02-21	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1233	2025-03-15	PERFAWARD	1054.80	EUR	Prime de performance annuelle 2025	ADD
1234	2022-03-15	PERFAWARD	2424.49	EUR	Prime de performance annuelle 2022	ADD
1234	2023-03-15	PERFAWARD	2712.08	EUR	Prime de performance annuelle 2023	ADD
1234	2024-03-15	PERFAWARD	2727.99	EUR	Prime de performance annuelle 2024	ADD
1234	2025-03-15	PERFAWARD	2522.06	EUR	Prime de performance annuelle 2025	ADD
1235	2022-03-15	PERFAWARD	16226.96	EUR	Prime de performance annuelle 2022	ADD
1235	2023-03-15	PERFAWARD	19066.46	EUR	Prime de performance annuelle 2023	ADD
1235	2024-03-15	PERFAWARD	17072.28	EUR	Prime de performance annuelle 2024	ADD
1235	2025-03-15	PERFAWARD	18279.18	EUR	Prime de performance annuelle 2025	ADD
1235	2020-10-10	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1235	2025-10-10	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1236	2022-03-15	PERFAWARD	14956.56	EUR	Prime de performance annuelle 2022	ADD
1236	2023-03-15	PERFAWARD	13202.76	EUR	Prime de performance annuelle 2023	ADD
1236	2024-03-15	PERFAWARD	14667.44	EUR	Prime de performance annuelle 2024	ADD
1236	2025-03-15	PERFAWARD	11101.30	EUR	Prime de performance annuelle 2025	ADD
1236	2025-04-20	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1237	2023-03-15	PERFAWARD	11921.55	EUR	Prime de performance annuelle 2023	ADD
1237	2024-03-15	PERFAWARD	10859.30	EUR	Prime de performance annuelle 2024	ADD
1237	2022-10-04	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1238	2022-03-15	PERFAWARD	15751.15	EUR	Prime de performance annuelle 2022	ADD
1238	2023-03-15	PERFAWARD	13264.53	EUR	Prime de performance annuelle 2023	ADD
1238	2024-03-15	PERFAWARD	15649.43	EUR	Prime de performance annuelle 2024	ADD
1238	2025-03-15	PERFAWARD	14876.37	EUR	Prime de performance annuelle 2025	ADD
1238	2022-06-08	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1238	2019-11-06	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1238	2024-11-06	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1239	2023-03-15	PERFAWARD	3936.30	EUR	Prime de performance annuelle 2023	ADD
1239	2024-03-15	PERFAWARD	4354.85	EUR	Prime de performance annuelle 2024	ADD
1240	2023-03-15	PERFAWARD	16775.12	EUR	Prime de performance annuelle 2023	ADD
1240	2024-03-15	PERFAWARD	14404.51	EUR	Prime de performance annuelle 2024	ADD
1241	2022-03-15	PERFAWARD	11842.74	EUR	Prime de performance annuelle 2022	ADD
1241	2023-03-15	PERFAWARD	9525.38	EUR	Prime de performance annuelle 2023	ADD
1241	2024-03-15	PERFAWARD	12546.88	EUR	Prime de performance annuelle 2024	ADD
1241	2025-03-15	PERFAWARD	10906.51	EUR	Prime de performance annuelle 2025	ADD
1241	2017-07-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1241	2022-07-02	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1242	2022-03-15	PERFAWARD	11579.71	EUR	Prime de performance annuelle 2022	ADD
1242	2023-03-15	PERFAWARD	9309.65	EUR	Prime de performance annuelle 2023	ADD
1242	2024-03-15	PERFAWARD	11722.93	EUR	Prime de performance annuelle 2024	ADD
1242	2025-03-15	PERFAWARD	11211.73	EUR	Prime de performance annuelle 2025	ADD
1242	2024-05-02	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1243	2023-03-15	PERFAWARD	15107.51	EUR	Prime de performance annuelle 2023	ADD
1243	2024-03-15	PERFAWARD	17716.20	EUR	Prime de performance annuelle 2024	ADD
1243	2025-03-15	PERFAWARD	16540.24	EUR	Prime de performance annuelle 2025	ADD
1243	2020-02-18	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1243	2025-02-18	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1244	2022-03-15	PERFAWARD	13381.06	EUR	Prime de performance annuelle 2022	ADD
1244	2023-03-15	PERFAWARD	17609.63	EUR	Prime de performance annuelle 2023	ADD
1244	2024-03-15	PERFAWARD	13710.23	EUR	Prime de performance annuelle 2024	ADD
1244	2025-03-15	PERFAWARD	14710.19	EUR	Prime de performance annuelle 2025	ADD
1244	2023-06-28	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1245	2022-03-15	PERFAWARD	7159.84	EUR	Prime de performance annuelle 2022	ADD
1245	2023-03-15	PERFAWARD	8372.82	EUR	Prime de performance annuelle 2023	ADD
1245	2024-03-15	PERFAWARD	6815.07	EUR	Prime de performance annuelle 2024	ADD
1245	2025-03-15	PERFAWARD	8186.04	EUR	Prime de performance annuelle 2025	ADD
1245	2024-10-11	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1246	2025-03-15	PERFAWARD	391.67	EUR	Prime de performance annuelle 2025	ADD
1247	2025-03-15	PERFAWARD	129.01	EUR	Prime de performance annuelle 2025	ADD
1247	2024-12-19	REFERRAL	2500.00	EUR	Prime de cooptation	ADD
1247	2025-04-15	SPOTBONUS	1204.34	EUR	Prime d'excellence	ADD
1248	2022-03-15	PERFAWARD	13726.54	EUR	Prime de performance annuelle 2022	ADD
1248	2023-03-15	PERFAWARD	16211.91	EUR	Prime de performance annuelle 2023	ADD
1248	2024-03-15	PERFAWARD	15744.36	EUR	Prime de performance annuelle 2024	ADD
1248	2018-06-07	MILESTONE	5000.00	EUR	Prime d'ancienneté 5 ans	ADD
1248	2023-06-07	MILESTONE	10000.00	EUR	Prime d'ancienneté 10 ans	ADD
1249	2025-03-15	PERFAWARD	124.64	EUR	Prime de performance annuelle 2025	ADD
\.


--
-- TOC entry 5122 (class 0 OID 19736)
-- Dependencies: 222
-- Data for Name: pay_component_recurring; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pay_component_recurring (user_id, start_date, pay_component, paycomponentvalue, currency_code, frequency, seq_number) FROM stdin;
1001	2024-08-12	Base Salary	2870.57	EUR	Monthly	1
1001	2024-08-12	Transport Allowance	61.23	EUR	Monthly	2
1001	2026-01-04	Base Salary	3022.85	EUR	Monthly	1
1001	2026-01-04	Transport Allowance	61.23	EUR	Monthly	2
1002	2015-10-18	Base Salary	3300.61	EUR	Monthly	1
1002	2015-10-18	Transport Allowance	67.61	EUR	Monthly	2
1002	2021-09-19	Base Salary	6061.43	EUR	Monthly	1
1002	2021-09-19	Transport Allowance	67.61	EUR	Monthly	2
1002	2021-09-19	Housing Allowance	219.90	EUR	Monthly	3
1002	2024-10-03	Base Salary	7923.04	EUR	Monthly	1
1002	2024-10-03	Transport Allowance	67.61	EUR	Monthly	2
1002	2024-10-03	Housing Allowance	310.14	EUR	Monthly	3
1002	2025-11-08	Base Salary	7923.04	EUR	Monthly	1
1002	2025-11-08	Transport Allowance	67.61	EUR	Monthly	2
1002	2025-11-08	Housing Allowance	239.55	EUR	Monthly	3
1003	2013-09-28	Base Salary	2424.33	EUR	Monthly	1
1003	2013-09-28	Transport Allowance	65.49	EUR	Monthly	2
1003	2016-09-30	Base Salary	3630.40	EUR	Monthly	1
1003	2016-09-30	Transport Allowance	65.49	EUR	Monthly	2
1003	2019-10-20	Base Salary	4368.21	EUR	Monthly	1
1003	2019-10-20	Transport Allowance	65.49	EUR	Monthly	2
1003	2025-06-04	Base Salary	5792.69	EUR	Monthly	1
1003	2025-06-04	Transport Allowance	65.49	EUR	Monthly	2
1004	2021-04-11	Base Salary	6378.37	EUR	Monthly	1
1004	2021-04-11	Transport Allowance	76.30	EUR	Monthly	2
1004	2021-04-11	Housing Allowance	320.21	EUR	Monthly	3
1004	2025-11-01	Base Salary	6378.37	EUR	Monthly	1
1004	2025-11-01	Transport Allowance	76.30	EUR	Monthly	2
1004	2025-11-01	Housing Allowance	286.47	EUR	Monthly	3
1005	2019-03-06	Base Salary	4259.01	EUR	Monthly	1
1005	2019-03-06	Transport Allowance	56.32	EUR	Monthly	2
1005	2025-04-02	Base Salary	6449.47	EUR	Monthly	1
1005	2025-04-02	Transport Allowance	56.32	EUR	Monthly	2
1005	2025-04-21	Base Salary	6496.18	EUR	Monthly	1
1005	2025-04-21	Transport Allowance	56.32	EUR	Monthly	2
1006	2013-08-05	Base Salary	3945.79	EUR	Monthly	1
1006	2013-08-05	Transport Allowance	45.87	EUR	Monthly	2
1006	2022-07-20	Base Salary	11048.32	EUR	Monthly	1
1006	2022-07-20	Transport Allowance	45.87	EUR	Monthly	2
1006	2022-07-20	Car Allowance	450.00	EUR	Monthly	3
1006	2022-07-20	Housing Allowance	299.81	EUR	Monthly	4
1006	2025-07-24	Base Salary	11466.50	EUR	Monthly	1
1006	2025-07-24	Transport Allowance	45.87	EUR	Monthly	2
1006	2025-07-24	Car Allowance	450.00	EUR	Monthly	3
1006	2025-07-24	Housing Allowance	397.26	EUR	Monthly	4
1007	2020-08-06	Base Salary	4118.58	EUR	Monthly	1
1007	2020-08-06	Transport Allowance	76.35	EUR	Monthly	2
1007	2023-07-17	Base Salary	5613.08	EUR	Monthly	1
1007	2023-07-17	Transport Allowance	76.35	EUR	Monthly	2
1007	2025-05-14	Base Salary	5804.47	EUR	Monthly	1
1007	2025-05-14	Transport Allowance	76.35	EUR	Monthly	2
1008	2015-05-20	Base Salary	6270.67	EUR	Monthly	1
1008	2015-05-20	Transport Allowance	75.89	EUR	Monthly	2
1008	2015-05-20	Housing Allowance	219.84	EUR	Monthly	3
1008	2018-05-30	Base Salary	8308.41	EUR	Monthly	1
1008	2018-05-30	Transport Allowance	75.89	EUR	Monthly	2
1008	2018-05-30	Car Allowance	450.00	EUR	Monthly	3
1008	2018-05-30	Housing Allowance	271.30	EUR	Monthly	4
1008	2025-04-11	Base Salary	8311.58	EUR	Monthly	1
1008	2025-04-11	Transport Allowance	75.89	EUR	Monthly	2
1008	2025-04-11	Car Allowance	450.00	EUR	Monthly	3
1008	2025-04-11	Housing Allowance	342.69	EUR	Monthly	4
1009	2019-08-23	Base Salary	3290.21	EUR	Monthly	1
1009	2019-08-23	Transport Allowance	69.90	EUR	Monthly	2
1009	2025-09-29	Base Salary	6079.97	EUR	Monthly	1
1009	2025-09-29	Transport Allowance	69.90	EUR	Monthly	2
1009	2025-09-29	Car Allowance	400.00	EUR	Monthly	3
1010	2025-10-08	Base Salary	5569.44	EUR	Monthly	1
1010	2025-10-08	Transport Allowance	50.74	EUR	Monthly	2
1010	2025-10-08	Housing Allowance	361.32	EUR	Monthly	3
1011	2025-09-16	Base Salary	7814.86	EUR	Monthly	1
1011	2025-09-16	Transport Allowance	48.19	EUR	Monthly	2
1011	2025-09-16	Housing Allowance	355.37	EUR	Monthly	3
1012	2019-03-11	Base Salary	15885.10	EUR	Monthly	1
1012	2019-03-11	Transport Allowance	67.19	EUR	Monthly	2
1012	2019-03-11	Housing Allowance	218.77	EUR	Monthly	3
1012	2026-01-13	Base Salary	16443.41	EUR	Monthly	1
1012	2026-01-13	Transport Allowance	67.19	EUR	Monthly	2
1012	2026-01-13	Car Allowance	700.00	EUR	Monthly	3
1012	2026-01-13	Housing Allowance	355.60	EUR	Monthly	4
1013	2014-08-24	Base Salary	5716.73	EUR	Monthly	1
1013	2014-08-24	Transport Allowance	70.44	EUR	Monthly	2
1013	2025-08-04	Base Salary	7885.19	EUR	Monthly	1
1013	2025-08-04	Transport Allowance	70.44	EUR	Monthly	2
1014	2017-09-22	Base Salary	2845.87	EUR	Monthly	1
1014	2017-09-22	Transport Allowance	79.13	EUR	Monthly	2
1014	2025-10-17	Base Salary	5381.70	EUR	Monthly	1
1014	2025-10-17	Transport Allowance	79.13	EUR	Monthly	2
1015	2018-06-18	Base Salary	8162.47	EUR	Monthly	1
1015	2018-06-18	Transport Allowance	66.42	EUR	Monthly	2
1015	2018-06-18	Housing Allowance	235.18	EUR	Monthly	3
1015	2025-04-03	Base Salary	8381.72	EUR	Monthly	1
1015	2025-04-03	Transport Allowance	66.42	EUR	Monthly	2
1015	2025-04-03	Car Allowance	350.00	EUR	Monthly	3
1015	2025-04-03	Housing Allowance	321.08	EUR	Monthly	4
1016	2017-11-07	Base Salary	4856.31	EUR	Monthly	1
1016	2017-11-07	Transport Allowance	46.54	EUR	Monthly	2
1016	2020-11-23	Base Salary	7153.38	EUR	Monthly	1
1016	2020-11-23	Transport Allowance	46.54	EUR	Monthly	2
1016	2020-11-23	Housing Allowance	237.59	EUR	Monthly	3
1016	2023-11-27	Base Salary	8153.53	EUR	Monthly	1
1016	2023-11-27	Transport Allowance	46.54	EUR	Monthly	2
1016	2023-11-27	Housing Allowance	273.74	EUR	Monthly	3
1016	2025-10-24	Base Salary	9053.71	EUR	Monthly	1
1016	2025-10-24	Transport Allowance	46.54	EUR	Monthly	2
1016	2025-10-24	Housing Allowance	391.69	EUR	Monthly	3
1017	2025-09-24	Base Salary	3671.44	EUR	Monthly	1
1017	2025-09-24	Transport Allowance	75.19	EUR	Monthly	2
1018	2019-10-25	Base Salary	3751.33	EUR	Monthly	1
1018	2019-10-25	Transport Allowance	50.67	EUR	Monthly	2
1018	2022-11-09	Base Salary	5679.53	EUR	Monthly	1
1018	2022-11-09	Transport Allowance	50.67	EUR	Monthly	2
1018	2025-10-30	Base Salary	7870.40	EUR	Monthly	1
1018	2025-10-30	Transport Allowance	50.67	EUR	Monthly	2
1018	2025-10-30	Car Allowance	450.00	EUR	Monthly	3
1018	2025-12-29	Base Salary	7870.40	EUR	Monthly	1
1018	2025-12-29	Transport Allowance	50.67	EUR	Monthly	2
1018	2025-12-29	Car Allowance	450.00	EUR	Monthly	3
1019	2018-06-10	Base Salary	5796.83	EUR	Monthly	1
1019	2018-06-10	Transport Allowance	50.06	EUR	Monthly	2
1019	2021-05-11	Base Salary	7698.75	EUR	Monthly	1
1019	2021-05-11	Transport Allowance	50.06	EUR	Monthly	2
1019	2024-05-18	Base Salary	10024.57	EUR	Monthly	1
1019	2024-05-18	Transport Allowance	50.06	EUR	Monthly	2
1019	2025-08-07	Base Salary	10285.85	EUR	Monthly	1
1019	2025-08-07	Transport Allowance	50.06	EUR	Monthly	2
1020	2016-12-26	Base Salary	5997.00	EUR	Monthly	1
1020	2016-12-26	Transport Allowance	71.92	EUR	Monthly	2
1020	2016-12-26	Housing Allowance	211.29	EUR	Monthly	3
1020	2019-12-28	Base Salary	7728.94	EUR	Monthly	1
1020	2019-12-28	Transport Allowance	71.92	EUR	Monthly	2
1020	2019-12-28	Housing Allowance	267.77	EUR	Monthly	3
1020	2025-07-10	Base Salary	7765.92	EUR	Monthly	1
1020	2025-07-10	Transport Allowance	71.92	EUR	Monthly	2
1020	2025-07-10	Housing Allowance	360.64	EUR	Monthly	3
1021	2018-02-25	Base Salary	4463.11	EUR	Monthly	1
1021	2018-02-25	Transport Allowance	78.63	EUR	Monthly	2
1021	2021-02-24	Base Salary	6253.08	EUR	Monthly	1
1021	2021-02-24	Transport Allowance	78.63	EUR	Monthly	2
1021	2024-02-24	Base Salary	7328.22	EUR	Monthly	1
1021	2024-02-24	Transport Allowance	78.63	EUR	Monthly	2
1021	2026-01-09	Base Salary	7328.22	EUR	Monthly	1
1021	2026-01-09	Transport Allowance	78.63	EUR	Monthly	2
1022	2023-12-27	Base Salary	2794.26	EUR	Monthly	1
1022	2023-12-27	Transport Allowance	55.11	EUR	Monthly	2
1022	2025-03-29	Base Salary	2794.26	EUR	Monthly	1
1022	2025-03-29	Transport Allowance	55.11	EUR	Monthly	2
1023	2023-04-01	Base Salary	8051.10	EUR	Monthly	1
1023	2023-04-01	Transport Allowance	51.32	EUR	Monthly	2
1023	2023-04-01	Housing Allowance	397.68	EUR	Monthly	3
1023	2025-09-24	Base Salary	8051.10	EUR	Monthly	1
1023	2025-09-24	Transport Allowance	51.32	EUR	Monthly	2
1023	2025-09-24	Car Allowance	450.00	EUR	Monthly	3
1023	2025-09-24	Housing Allowance	411.30	EUR	Monthly	4
1024	2016-12-03	Base Salary	3448.15	EUR	Monthly	1
1024	2016-12-03	Transport Allowance	45.12	EUR	Monthly	2
1024	2019-12-27	Base Salary	5154.19	EUR	Monthly	1
1024	2019-12-27	Transport Allowance	45.12	EUR	Monthly	2
1024	2022-12-27	Base Salary	7169.37	EUR	Monthly	1
1024	2022-12-27	Transport Allowance	45.12	EUR	Monthly	2
1024	2022-12-27	Car Allowance	400.00	EUR	Monthly	3
1024	2025-11-24	Base Salary	8513.11	EUR	Monthly	1
1024	2025-11-24	Transport Allowance	45.12	EUR	Monthly	2
1024	2025-11-24	Car Allowance	400.00	EUR	Monthly	3
1024	2025-12-30	Base Salary	8513.11	EUR	Monthly	1
1024	2025-12-30	Transport Allowance	45.12	EUR	Monthly	2
1024	2025-12-30	Car Allowance	400.00	EUR	Monthly	3
1025	2013-09-19	Base Salary	3429.88	EUR	Monthly	1
1025	2013-09-19	Transport Allowance	71.79	EUR	Monthly	2
1025	2019-10-11	Base Salary	7373.75	EUR	Monthly	1
1025	2019-10-11	Transport Allowance	71.79	EUR	Monthly	2
1025	2019-10-11	Car Allowance	350.00	EUR	Monthly	3
1025	2022-09-14	Base Salary	8260.64	EUR	Monthly	1
1025	2022-09-14	Transport Allowance	71.79	EUR	Monthly	2
1025	2022-09-14	Car Allowance	350.00	EUR	Monthly	3
1025	2025-12-20	Base Salary	8260.64	EUR	Monthly	1
1025	2025-12-20	Transport Allowance	71.79	EUR	Monthly	2
1025	2025-12-20	Car Allowance	350.00	EUR	Monthly	3
1026	2019-09-18	Base Salary	3828.44	EUR	Monthly	1
1026	2019-09-18	Transport Allowance	45.43	EUR	Monthly	2
1026	2025-12-18	Base Salary	7562.65	EUR	Monthly	1
1026	2025-12-18	Transport Allowance	45.43	EUR	Monthly	2
1027	2014-10-07	Base Salary	2504.39	EUR	Monthly	1
1027	2014-10-07	Transport Allowance	62.42	EUR	Monthly	2
1027	2017-10-21	Base Salary	3730.68	EUR	Monthly	1
1027	2017-10-21	Transport Allowance	62.42	EUR	Monthly	2
1027	2025-05-11	Base Salary	5518.17	EUR	Monthly	1
1027	2025-05-11	Transport Allowance	62.42	EUR	Monthly	2
1028	2015-07-25	Base Salary	4645.02	EUR	Monthly	1
1028	2015-07-25	Transport Allowance	62.45	EUR	Monthly	2
1028	2018-07-31	Base Salary	6305.46	EUR	Monthly	1
1028	2018-07-31	Transport Allowance	62.45	EUR	Monthly	2
1028	2021-07-19	Base Salary	8170.70	EUR	Monthly	1
1028	2021-07-19	Transport Allowance	62.45	EUR	Monthly	2
1028	2024-08-19	Base Salary	10541.49	EUR	Monthly	1
1028	2024-08-19	Transport Allowance	62.45	EUR	Monthly	2
1028	2025-04-22	Base Salary	10541.49	EUR	Monthly	1
1028	2025-04-22	Transport Allowance	62.45	EUR	Monthly	2
1029	2023-08-18	Base Salary	3046.05	EUR	Monthly	1
1029	2023-08-18	Transport Allowance	73.26	EUR	Monthly	2
1029	2025-03-24	Base Salary	3046.05	EUR	Monthly	1
1029	2025-03-24	Transport Allowance	73.26	EUR	Monthly	2
1030	2022-05-13	Base Salary	4310.74	EUR	Monthly	1
1030	2022-05-13	Transport Allowance	66.28	EUR	Monthly	2
1030	2025-05-09	Base Salary	5489.37	EUR	Monthly	1
1030	2025-05-09	Transport Allowance	66.28	EUR	Monthly	2
1030	2025-05-09	Housing Allowance	308.56	EUR	Monthly	3
1030	2025-07-25	Base Salary	5489.37	EUR	Monthly	1
1030	2025-07-25	Transport Allowance	66.28	EUR	Monthly	2
1030	2025-07-25	Housing Allowance	247.71	EUR	Monthly	3
1031	2021-02-01	Base Salary	3120.89	EUR	Monthly	1
1031	2021-02-01	Transport Allowance	68.08	EUR	Monthly	2
1031	2025-04-28	Base Salary	4343.32	EUR	Monthly	1
1031	2025-04-28	Transport Allowance	68.08	EUR	Monthly	2
1032	2019-11-12	Base Salary	2971.44	EUR	Monthly	1
1032	2019-11-12	Transport Allowance	60.88	EUR	Monthly	2
1032	2022-11-18	Base Salary	4314.82	EUR	Monthly	1
1032	2022-11-18	Transport Allowance	60.88	EUR	Monthly	2
1032	2025-12-15	Base Salary	5477.83	EUR	Monthly	1
1032	2025-12-15	Transport Allowance	60.88	EUR	Monthly	2
1033	2022-11-20	Base Salary	6354.15	EUR	Monthly	1
1033	2022-11-20	Transport Allowance	60.47	EUR	Monthly	2
1033	2025-01-11	Base Salary	7709.72	EUR	Monthly	1
1033	2025-01-11	Transport Allowance	60.47	EUR	Monthly	2
1034	2023-08-25	Base Salary	5611.96	EUR	Monthly	1
1034	2023-08-25	Transport Allowance	66.04	EUR	Monthly	2
1034	2025-03-18	Base Salary	5611.96	EUR	Monthly	1
1034	2025-03-18	Transport Allowance	66.04	EUR	Monthly	2
1035	2025-03-14	Base Salary	6626.01	EUR	Monthly	1
1035	2025-03-14	Transport Allowance	45.23	EUR	Monthly	2
1035	2025-03-14	Housing Allowance	394.08	EUR	Monthly	3
1035	2025-04-18	Base Salary	6626.01	EUR	Monthly	1
1035	2025-04-18	Transport Allowance	45.23	EUR	Monthly	2
1035	2025-04-18	Car Allowance	500.00	EUR	Monthly	3
1035	2025-04-18	Housing Allowance	261.18	EUR	Monthly	4
1036	2025-12-24	Base Salary	3968.81	EUR	Monthly	1
1036	2025-12-24	Transport Allowance	67.00	EUR	Monthly	2
1037	2018-10-28	Base Salary	5737.70	EUR	Monthly	1
1037	2018-10-28	Transport Allowance	73.70	EUR	Monthly	2
1037	2018-10-28	Housing Allowance	245.68	EUR	Monthly	3
1037	2025-08-08	Base Salary	6501.72	EUR	Monthly	1
1037	2025-08-08	Transport Allowance	73.70	EUR	Monthly	2
1037	2025-08-08	Housing Allowance	240.66	EUR	Monthly	3
1038	2015-08-04	Base Salary	5730.05	EUR	Monthly	1
1038	2015-08-04	Transport Allowance	46.93	EUR	Monthly	2
1038	2021-08-04	Base Salary	9858.72	EUR	Monthly	1
1038	2021-08-04	Transport Allowance	46.93	EUR	Monthly	2
1038	2021-08-04	Car Allowance	350.00	EUR	Monthly	3
1038	2025-02-13	Base Salary	9858.72	EUR	Monthly	1
1038	2025-02-13	Transport Allowance	46.93	EUR	Monthly	2
1038	2025-02-13	Car Allowance	350.00	EUR	Monthly	3
1039	2017-05-09	Base Salary	7068.03	EUR	Monthly	1
1039	2017-05-09	Transport Allowance	57.22	EUR	Monthly	2
1039	2017-05-09	Housing Allowance	231.98	EUR	Monthly	3
1039	2020-04-24	Base Salary	8172.87	EUR	Monthly	1
1039	2020-04-24	Transport Allowance	57.22	EUR	Monthly	2
1039	2020-04-24	Housing Allowance	207.14	EUR	Monthly	3
1039	2025-12-16	Base Salary	8172.87	EUR	Monthly	1
1039	2025-12-16	Transport Allowance	57.22	EUR	Monthly	2
1039	2025-12-16	Housing Allowance	327.18	EUR	Monthly	3
1040	2020-06-29	Base Salary	3749.96	EUR	Monthly	1
1040	2020-06-29	Transport Allowance	66.11	EUR	Monthly	2
1040	2023-06-23	Base Salary	4858.42	EUR	Monthly	1
1040	2023-06-23	Transport Allowance	66.11	EUR	Monthly	2
1040	2025-11-07	Base Salary	4858.42	EUR	Monthly	1
1040	2025-11-07	Transport Allowance	66.11	EUR	Monthly	2
1041	2019-10-22	Base Salary	3530.20	EUR	Monthly	1
1041	2019-10-22	Transport Allowance	56.59	EUR	Monthly	2
1041	2025-11-15	Base Salary	6049.77	EUR	Monthly	1
1041	2025-11-15	Transport Allowance	56.59	EUR	Monthly	2
1041	2026-01-05	Base Salary	6049.77	EUR	Monthly	1
1041	2026-01-05	Transport Allowance	56.59	EUR	Monthly	2
1042	2014-05-17	Base Salary	2751.06	EUR	Monthly	1
1042	2014-05-17	Transport Allowance	48.07	EUR	Monthly	2
1042	2020-05-12	Base Salary	4829.21	EUR	Monthly	1
1042	2020-05-12	Transport Allowance	48.07	EUR	Monthly	2
1042	2020-05-12	Housing Allowance	223.96	EUR	Monthly	3
1042	2023-04-17	Base Salary	5427.10	EUR	Monthly	1
1042	2023-04-17	Transport Allowance	48.07	EUR	Monthly	2
1042	2023-04-17	Housing Allowance	418.62	EUR	Monthly	3
1042	2025-04-06	Base Salary	5427.10	EUR	Monthly	1
1042	2025-04-06	Transport Allowance	48.07	EUR	Monthly	2
1042	2025-04-06	Housing Allowance	235.49	EUR	Monthly	3
1043	2021-07-20	Base Salary	5910.72	EUR	Monthly	1
1043	2021-07-20	Transport Allowance	54.95	EUR	Monthly	2
1043	2024-08-15	Base Salary	7274.83	EUR	Monthly	1
1043	2024-08-15	Transport Allowance	54.95	EUR	Monthly	2
1043	2025-08-11	Base Salary	7386.63	EUR	Monthly	1
1043	2025-08-11	Transport Allowance	54.95	EUR	Monthly	2
1044	2024-09-15	Base Salary	4352.97	EUR	Monthly	1
1044	2024-09-15	Transport Allowance	68.13	EUR	Monthly	2
1044	2025-08-30	Base Salary	4410.87	EUR	Monthly	1
1044	2025-08-30	Transport Allowance	68.13	EUR	Monthly	2
1045	2021-12-04	Base Salary	5455.23	EUR	Monthly	1
1045	2021-12-04	Transport Allowance	69.49	EUR	Monthly	2
1045	2021-12-04	Housing Allowance	325.90	EUR	Monthly	3
1045	2025-05-02	Base Salary	5455.23	EUR	Monthly	1
1045	2025-05-02	Transport Allowance	69.49	EUR	Monthly	2
1045	2025-05-02	Housing Allowance	323.68	EUR	Monthly	3
1046	2015-09-24	Base Salary	3065.01	EUR	Monthly	1
1046	2015-09-24	Transport Allowance	78.82	EUR	Monthly	2
1046	2018-10-09	Base Salary	4435.54	EUR	Monthly	1
1046	2018-10-09	Transport Allowance	78.82	EUR	Monthly	2
1046	2024-10-12	Base Salary	6665.59	EUR	Monthly	1
1046	2024-10-12	Transport Allowance	78.82	EUR	Monthly	2
1046	2024-10-12	Car Allowance	450.00	EUR	Monthly	3
1046	2025-08-01	Base Salary	6747.21	EUR	Monthly	1
1046	2025-08-01	Transport Allowance	78.82	EUR	Monthly	2
1046	2025-08-01	Car Allowance	450.00	EUR	Monthly	3
1047	2020-05-24	Base Salary	4514.41	EUR	Monthly	1
1047	2020-05-24	Transport Allowance	71.23	EUR	Monthly	2
1047	2025-07-11	Base Salary	6046.69	EUR	Monthly	1
1047	2025-07-11	Transport Allowance	71.23	EUR	Monthly	2
1048	2012-10-19	Base Salary	2356.63	EUR	Monthly	1
1048	2012-10-19	Transport Allowance	57.61	EUR	Monthly	2
1048	2018-09-29	Base Salary	4726.93	EUR	Monthly	1
1048	2018-09-29	Transport Allowance	57.61	EUR	Monthly	2
1048	2018-09-29	Housing Allowance	207.88	EUR	Monthly	3
1048	2025-07-02	Base Salary	5450.47	EUR	Monthly	1
1048	2025-07-02	Transport Allowance	57.61	EUR	Monthly	2
1048	2025-07-02	Housing Allowance	369.07	EUR	Monthly	3
1049	2022-09-03	Base Salary	2913.21	EUR	Monthly	1
1049	2022-09-03	Transport Allowance	56.30	EUR	Monthly	2
1049	2025-08-16	Base Salary	4322.06	EUR	Monthly	1
1049	2025-08-16	Transport Allowance	56.30	EUR	Monthly	2
1049	2025-08-26	Base Salary	4322.06	EUR	Monthly	1
1049	2025-08-26	Transport Allowance	56.30	EUR	Monthly	2
1050	2019-03-08	Base Salary	4863.50	EUR	Monthly	1
1050	2019-03-08	Transport Allowance	76.41	EUR	Monthly	2
1050	2022-03-28	Base Salary	6573.28	EUR	Monthly	1
1050	2022-03-28	Transport Allowance	76.41	EUR	Monthly	2
1050	2022-03-28	Housing Allowance	380.46	EUR	Monthly	3
1050	2025-03-26	Base Salary	8238.86	EUR	Monthly	1
1050	2025-03-26	Transport Allowance	76.41	EUR	Monthly	2
1050	2025-03-26	Housing Allowance	366.86	EUR	Monthly	3
1050	2025-10-21	Base Salary	8590.66	EUR	Monthly	1
1050	2025-10-21	Transport Allowance	76.41	EUR	Monthly	2
1050	2025-10-21	Housing Allowance	385.53	EUR	Monthly	3
1051	2018-07-18	Base Salary	3355.08	EUR	Monthly	1
1051	2018-07-18	Transport Allowance	47.27	EUR	Monthly	2
1051	2021-08-06	Base Salary	4552.29	EUR	Monthly	1
1051	2021-08-06	Transport Allowance	47.27	EUR	Monthly	2
1051	2024-07-25	Base Salary	5967.15	EUR	Monthly	1
1051	2024-07-25	Transport Allowance	47.27	EUR	Monthly	2
1051	2024-07-25	Housing Allowance	303.58	EUR	Monthly	3
1051	2025-01-22	Base Salary	5967.15	EUR	Monthly	1
1051	2025-01-22	Transport Allowance	47.27	EUR	Monthly	2
1051	2025-01-22	Housing Allowance	226.85	EUR	Monthly	3
1052	2019-12-18	Base Salary	3760.59	EUR	Monthly	1
1052	2019-12-18	Transport Allowance	75.08	EUR	Monthly	2
1052	2022-11-21	Base Salary	4956.61	EUR	Monthly	1
1052	2022-11-21	Transport Allowance	75.08	EUR	Monthly	2
1052	2025-12-25	Base Salary	7390.31	EUR	Monthly	1
1052	2025-12-25	Transport Allowance	75.08	EUR	Monthly	2
1052	2025-12-25	Car Allowance	450.00	EUR	Monthly	3
1052	2025-12-25	Housing Allowance	272.43	EUR	Monthly	4
1052	2026-02-18	Base Salary	7426.97	EUR	Monthly	1
1052	2026-02-18	Transport Allowance	75.08	EUR	Monthly	2
1052	2026-02-18	Car Allowance	450.00	EUR	Monthly	3
1052	2026-02-18	Housing Allowance	291.03	EUR	Monthly	4
1053	2012-03-12	Base Salary	3964.91	EUR	Monthly	1
1053	2012-03-12	Transport Allowance	52.34	EUR	Monthly	2
1053	2015-03-19	Base Salary	5169.40	EUR	Monthly	1
1053	2015-03-19	Transport Allowance	52.34	EUR	Monthly	2
1053	2021-03-24	Base Salary	8959.01	EUR	Monthly	1
1053	2021-03-24	Transport Allowance	52.34	EUR	Monthly	2
1053	2021-03-24	Housing Allowance	245.99	EUR	Monthly	3
1053	2025-09-15	Base Salary	10134.24	EUR	Monthly	1
1053	2025-09-15	Transport Allowance	52.34	EUR	Monthly	2
1053	2025-09-15	Housing Allowance	212.80	EUR	Monthly	3
1054	2013-12-12	Base Salary	5884.89	EUR	Monthly	1
1054	2013-12-12	Transport Allowance	65.00	EUR	Monthly	2
1054	2016-12-20	Base Salary	7262.75	EUR	Monthly	1
1054	2016-12-20	Transport Allowance	65.00	EUR	Monthly	2
1054	2025-05-18	Base Salary	7345.02	EUR	Monthly	1
1054	2025-05-18	Transport Allowance	65.00	EUR	Monthly	2
1055	2022-11-26	Base Salary	10497.39	EUR	Monthly	1
1055	2022-11-26	Transport Allowance	79.28	EUR	Monthly	2
1055	2022-11-26	Housing Allowance	316.37	EUR	Monthly	3
1055	2025-11-30	Base Salary	12639.25	EUR	Monthly	1
1055	2025-11-30	Transport Allowance	79.28	EUR	Monthly	2
1055	2025-11-30	Car Allowance	500.00	EUR	Monthly	3
1055	2025-11-30	Housing Allowance	219.29	EUR	Monthly	4
1056	2016-12-28	Base Salary	5441.66	EUR	Monthly	1
1056	2016-12-28	Transport Allowance	70.34	EUR	Monthly	2
1056	2019-12-24	Base Salary	8267.53	EUR	Monthly	1
1056	2019-12-24	Transport Allowance	70.34	EUR	Monthly	2
1056	2019-12-24	Car Allowance	450.00	EUR	Monthly	3
1056	2025-09-06	Base Salary	10288.28	EUR	Monthly	1
1056	2025-09-06	Transport Allowance	70.34	EUR	Monthly	2
1056	2025-09-06	Car Allowance	450.00	EUR	Monthly	3
1057	2019-09-20	Base Salary	3196.25	EUR	Monthly	1
1057	2019-09-20	Transport Allowance	66.17	EUR	Monthly	2
1057	2022-09-10	Base Salary	4165.86	EUR	Monthly	1
1057	2022-09-10	Transport Allowance	66.17	EUR	Monthly	2
1057	2025-10-17	Base Salary	6612.14	EUR	Monthly	1
1057	2025-10-17	Transport Allowance	66.17	EUR	Monthly	2
1057	2025-10-17	Car Allowance	500.00	EUR	Monthly	3
1058	2024-03-29	Base Salary	4394.48	EUR	Monthly	1
1058	2024-03-29	Transport Allowance	72.59	EUR	Monthly	2
1058	2025-10-21	Base Salary	4561.80	EUR	Monthly	1
1058	2025-10-21	Transport Allowance	72.59	EUR	Monthly	2
1059	2024-12-17	Base Salary	7041.38	EUR	Monthly	1
1059	2024-12-17	Transport Allowance	69.74	EUR	Monthly	2
1059	2025-08-30	Base Salary	7041.38	EUR	Monthly	1
1059	2025-08-30	Transport Allowance	69.74	EUR	Monthly	2
1060	2013-10-23	Base Salary	3005.14	EUR	Monthly	1
1060	2013-10-23	Transport Allowance	59.95	EUR	Monthly	2
1060	2026-01-27	Base Salary	7730.92	EUR	Monthly	1
1060	2026-01-27	Transport Allowance	59.95	EUR	Monthly	2
1061	2020-08-20	Base Salary	7322.10	EUR	Monthly	1
1061	2020-08-20	Transport Allowance	74.67	EUR	Monthly	2
1061	2025-01-08	Base Salary	7553.37	EUR	Monthly	1
1061	2025-01-08	Transport Allowance	74.67	EUR	Monthly	2
1062	2018-05-12	Base Salary	3146.37	EUR	Monthly	1
1062	2018-05-12	Transport Allowance	54.09	EUR	Monthly	2
1062	2021-05-12	Base Salary	4998.93	EUR	Monthly	1
1062	2021-05-12	Transport Allowance	54.09	EUR	Monthly	2
1062	2025-02-19	Base Salary	6797.22	EUR	Monthly	1
1062	2025-02-19	Transport Allowance	54.09	EUR	Monthly	2
1062	2025-02-19	Car Allowance	450.00	EUR	Monthly	3
1063	2025-03-31	Base Salary	10365.21	EUR	Monthly	1
1063	2025-03-31	Transport Allowance	65.13	EUR	Monthly	2
1063	2025-09-19	Base Salary	10365.21	EUR	Monthly	1
1063	2025-09-19	Transport Allowance	65.13	EUR	Monthly	2
1064	2017-07-07	Base Salary	5641.37	EUR	Monthly	1
1064	2017-07-07	Transport Allowance	66.81	EUR	Monthly	2
1064	2025-04-30	Base Salary	7032.68	EUR	Monthly	1
1064	2025-04-30	Transport Allowance	66.81	EUR	Monthly	2
1065	2013-11-26	Base Salary	5522.59	EUR	Monthly	1
1065	2013-11-26	Transport Allowance	77.45	EUR	Monthly	2
1065	2016-11-20	Base Salary	6844.12	EUR	Monthly	1
1065	2016-11-20	Transport Allowance	77.45	EUR	Monthly	2
1065	2025-04-21	Base Salary	7299.73	EUR	Monthly	1
1065	2025-04-21	Transport Allowance	77.45	EUR	Monthly	2
1066	2016-01-27	Base Salary	16701.90	EUR	Monthly	1
1066	2016-01-27	Transport Allowance	66.50	EUR	Monthly	2
1066	2016-01-27	Housing Allowance	309.21	EUR	Monthly	3
1066	2025-04-21	Base Salary	17068.24	EUR	Monthly	1
1066	2025-04-21	Transport Allowance	66.50	EUR	Monthly	2
1066	2025-04-21	Car Allowance	800.00	EUR	Monthly	3
1066	2025-04-21	Housing Allowance	360.42	EUR	Monthly	4
1067	2021-08-26	Base Salary	4515.02	EUR	Monthly	1
1067	2021-08-26	Transport Allowance	62.42	EUR	Monthly	2
1067	2024-08-12	Base Salary	5432.39	EUR	Monthly	1
1067	2024-08-12	Transport Allowance	62.42	EUR	Monthly	2
1067	2024-08-12	Housing Allowance	377.76	EUR	Monthly	3
1067	2026-01-19	Base Salary	5711.40	EUR	Monthly	1
1067	2026-01-19	Transport Allowance	62.42	EUR	Monthly	2
1067	2026-01-19	Housing Allowance	394.41	EUR	Monthly	3
1068	2024-06-13	Base Salary	5382.93	EUR	Monthly	1
1068	2024-06-13	Transport Allowance	53.15	EUR	Monthly	2
1068	2025-06-17	Base Salary	5491.65	EUR	Monthly	1
1068	2025-06-17	Transport Allowance	53.15	EUR	Monthly	2
1069	2024-12-09	Base Salary	3879.15	EUR	Monthly	1
1069	2024-12-09	Transport Allowance	55.17	EUR	Monthly	2
1069	2025-08-09	Base Salary	3900.05	EUR	Monthly	1
1069	2025-08-09	Transport Allowance	55.17	EUR	Monthly	2
1070	2014-02-20	Base Salary	2893.20	EUR	Monthly	1
1070	2014-02-20	Transport Allowance	51.77	EUR	Monthly	2
1070	2017-02-14	Base Salary	3743.96	EUR	Monthly	1
1070	2017-02-14	Transport Allowance	51.77	EUR	Monthly	2
1070	2025-09-25	Base Salary	6821.04	EUR	Monthly	1
1070	2025-09-25	Transport Allowance	51.77	EUR	Monthly	2
1071	2020-02-01	Base Salary	5298.35	EUR	Monthly	1
1071	2020-02-01	Transport Allowance	49.14	EUR	Monthly	2
1071	2026-02-21	Base Salary	8587.18	EUR	Monthly	1
1071	2026-02-21	Transport Allowance	49.14	EUR	Monthly	2
1071	2026-02-21	Car Allowance	450.00	EUR	Monthly	3
1072	2016-07-05	Base Salary	8791.06	EUR	Monthly	1
1072	2016-07-05	Transport Allowance	61.27	EUR	Monthly	2
1072	2019-06-21	Base Salary	10428.37	EUR	Monthly	1
1072	2019-06-21	Transport Allowance	61.27	EUR	Monthly	2
1072	2019-06-21	Car Allowance	350.00	EUR	Monthly	3
1072	2025-09-07	Base Salary	10730.01	EUR	Monthly	1
1072	2025-09-07	Transport Allowance	61.27	EUR	Monthly	2
1072	2025-09-07	Car Allowance	350.00	EUR	Monthly	3
1073	2019-03-14	Base Salary	3351.02	EUR	Monthly	1
1073	2019-03-14	Transport Allowance	72.89	EUR	Monthly	2
1073	2022-02-26	Base Salary	4211.47	EUR	Monthly	1
1073	2022-02-26	Transport Allowance	72.89	EUR	Monthly	2
1073	2025-07-18	Base Salary	5918.78	EUR	Monthly	1
1073	2025-07-18	Transport Allowance	72.89	EUR	Monthly	2
1073	2025-07-18	Car Allowance	450.00	EUR	Monthly	3
1074	2024-11-06	Base Salary	2838.25	EUR	Monthly	1
1074	2024-11-06	Transport Allowance	70.81	EUR	Monthly	2
1074	2025-04-22	Base Salary	3023.63	EUR	Monthly	1
1074	2025-04-22	Transport Allowance	70.81	EUR	Monthly	2
1075	2017-04-20	Base Salary	6325.10	EUR	Monthly	1
1075	2017-04-20	Transport Allowance	52.26	EUR	Monthly	2
1075	2025-10-19	Base Salary	9492.37	EUR	Monthly	1
1075	2025-10-19	Transport Allowance	52.26	EUR	Monthly	2
1076	2023-01-21	Base Salary	3436.03	EUR	Monthly	1
1076	2023-01-21	Transport Allowance	66.54	EUR	Monthly	2
1076	2025-01-28	Base Salary	4514.25	EUR	Monthly	1
1076	2025-01-28	Transport Allowance	66.54	EUR	Monthly	2
1077	2020-10-21	Base Salary	7332.94	EUR	Monthly	1
1077	2020-10-21	Transport Allowance	59.51	EUR	Monthly	2
1077	2020-10-21	Housing Allowance	210.01	EUR	Monthly	3
1077	2025-12-30	Base Salary	7415.82	EUR	Monthly	1
1077	2025-12-30	Transport Allowance	59.51	EUR	Monthly	2
1077	2025-12-30	Housing Allowance	276.92	EUR	Monthly	3
1078	2016-03-20	Base Salary	2976.11	EUR	Monthly	1
1078	2016-03-20	Transport Allowance	73.21	EUR	Monthly	2
1078	2019-03-25	Base Salary	4279.90	EUR	Monthly	1
1078	2019-03-25	Transport Allowance	73.21	EUR	Monthly	2
1078	2022-04-13	Base Salary	5716.86	EUR	Monthly	1
1078	2022-04-13	Transport Allowance	73.21	EUR	Monthly	2
1078	2025-04-04	Base Salary	6433.05	EUR	Monthly	1
1078	2025-04-04	Transport Allowance	73.21	EUR	Monthly	2
1078	2025-06-17	Base Salary	6433.05	EUR	Monthly	1
1078	2025-06-17	Transport Allowance	73.21	EUR	Monthly	2
1079	2017-10-01	Base Salary	5547.93	EUR	Monthly	1
1079	2017-10-01	Transport Allowance	52.43	EUR	Monthly	2
1079	2023-10-24	Base Salary	9685.61	EUR	Monthly	1
1079	2023-10-24	Transport Allowance	52.43	EUR	Monthly	2
1079	2023-10-24	Car Allowance	500.00	EUR	Monthly	3
1079	2025-12-21	Base Salary	9822.80	EUR	Monthly	1
1079	2025-12-21	Transport Allowance	52.43	EUR	Monthly	2
1079	2025-12-21	Car Allowance	500.00	EUR	Monthly	3
1080	2021-06-03	Base Salary	3831.93	EUR	Monthly	1
1080	2021-06-03	Transport Allowance	67.42	EUR	Monthly	2
1080	2024-06-23	Base Salary	5333.63	EUR	Monthly	1
1080	2024-06-23	Transport Allowance	67.42	EUR	Monthly	2
1080	2025-09-07	Base Salary	5333.63	EUR	Monthly	1
1080	2025-09-07	Transport Allowance	67.42	EUR	Monthly	2
1081	2015-09-30	Base Salary	2564.72	EUR	Monthly	1
1081	2015-09-30	Transport Allowance	69.15	EUR	Monthly	2
1081	2018-10-20	Base Salary	3717.55	EUR	Monthly	1
1081	2018-10-20	Transport Allowance	69.15	EUR	Monthly	2
1081	2021-10-04	Base Salary	5637.45	EUR	Monthly	1
1081	2021-10-04	Transport Allowance	69.15	EUR	Monthly	2
1081	2021-10-04	Housing Allowance	255.97	EUR	Monthly	3
1081	2024-10-26	Base Salary	6395.47	EUR	Monthly	1
1081	2024-10-26	Transport Allowance	69.15	EUR	Monthly	2
1081	2024-10-26	Housing Allowance	214.92	EUR	Monthly	3
1081	2026-01-10	Base Salary	6395.47	EUR	Monthly	1
1081	2026-01-10	Transport Allowance	69.15	EUR	Monthly	2
1081	2026-01-10	Housing Allowance	266.06	EUR	Monthly	3
1082	2024-01-16	Base Salary	5692.57	EUR	Monthly	1
1082	2024-01-16	Transport Allowance	64.25	EUR	Monthly	2
1082	2025-01-09	Base Salary	6356.10	EUR	Monthly	1
1082	2025-01-09	Transport Allowance	64.25	EUR	Monthly	2
1083	2013-02-22	Base Salary	2920.32	EUR	Monthly	1
1083	2013-02-22	Transport Allowance	71.85	EUR	Monthly	2
1083	2016-02-27	Base Salary	4371.24	EUR	Monthly	1
1083	2016-02-27	Transport Allowance	71.85	EUR	Monthly	2
1083	2022-03-06	Base Salary	7801.14	EUR	Monthly	1
1083	2022-03-06	Transport Allowance	71.85	EUR	Monthly	2
1083	2022-03-06	Car Allowance	400.00	EUR	Monthly	3
1083	2025-06-30	Base Salary	7801.14	EUR	Monthly	1
1083	2025-06-30	Transport Allowance	71.85	EUR	Monthly	2
1083	2025-06-30	Car Allowance	400.00	EUR	Monthly	3
1084	2013-03-16	Base Salary	5623.71	EUR	Monthly	1
1084	2013-03-16	Transport Allowance	48.98	EUR	Monthly	2
1084	2019-02-16	Base Salary	8894.82	EUR	Monthly	1
1084	2019-02-16	Transport Allowance	48.98	EUR	Monthly	2
1084	2019-02-16	Housing Allowance	273.32	EUR	Monthly	3
1084	2025-12-08	Base Salary	9286.50	EUR	Monthly	1
1084	2025-12-08	Transport Allowance	48.98	EUR	Monthly	2
1084	2025-12-08	Housing Allowance	287.13	EUR	Monthly	3
1085	2016-09-26	Base Salary	3902.00	EUR	Monthly	1
1085	2016-09-26	Transport Allowance	64.91	EUR	Monthly	2
1085	2022-09-30	Base Salary	8133.69	EUR	Monthly	1
1085	2022-09-30	Transport Allowance	64.91	EUR	Monthly	2
1085	2025-09-29	Base Salary	9457.11	EUR	Monthly	1
1085	2025-09-29	Transport Allowance	64.91	EUR	Monthly	2
1085	2025-12-22	Base Salary	10454.61	EUR	Monthly	1
1085	2025-12-22	Transport Allowance	64.91	EUR	Monthly	2
1086	2021-03-04	Base Salary	6083.65	EUR	Monthly	1
1086	2021-03-04	Transport Allowance	78.60	EUR	Monthly	2
1086	2021-03-04	Housing Allowance	383.05	EUR	Monthly	3
1086	2024-02-05	Base Salary	7767.60	EUR	Monthly	1
1086	2024-02-05	Transport Allowance	78.60	EUR	Monthly	2
1086	2024-02-05	Car Allowance	450.00	EUR	Monthly	3
1086	2024-02-05	Housing Allowance	242.68	EUR	Monthly	4
1086	2026-02-02	Base Salary	7767.60	EUR	Monthly	1
1086	2026-02-02	Transport Allowance	78.60	EUR	Monthly	2
1086	2026-02-02	Car Allowance	450.00	EUR	Monthly	3
1086	2026-02-02	Housing Allowance	383.44	EUR	Monthly	4
1087	2021-09-18	Base Salary	3152.99	EUR	Monthly	1
1087	2021-09-18	Transport Allowance	77.28	EUR	Monthly	2
1087	2024-08-25	Base Salary	3904.08	EUR	Monthly	1
1087	2024-08-25	Transport Allowance	77.28	EUR	Monthly	2
1087	2025-03-21	Base Salary	3904.08	EUR	Monthly	1
1087	2025-03-21	Transport Allowance	77.28	EUR	Monthly	2
1088	2016-02-18	Base Salary	6519.81	EUR	Monthly	1
1088	2016-02-18	Transport Allowance	61.77	EUR	Monthly	2
1088	2019-01-23	Base Salary	8360.16	EUR	Monthly	1
1088	2019-01-23	Transport Allowance	61.77	EUR	Monthly	2
1088	2019-01-23	Car Allowance	500.00	EUR	Monthly	3
1088	2022-02-01	Base Salary	10137.22	EUR	Monthly	1
1088	2022-02-01	Transport Allowance	61.77	EUR	Monthly	2
1088	2022-02-01	Car Allowance	500.00	EUR	Monthly	3
1088	2026-01-17	Base Salary	10137.22	EUR	Monthly	1
1088	2026-01-17	Transport Allowance	61.77	EUR	Monthly	2
1088	2026-01-17	Car Allowance	500.00	EUR	Monthly	3
1089	2015-03-29	Base Salary	4474.71	EUR	Monthly	1
1089	2015-03-29	Transport Allowance	61.61	EUR	Monthly	2
1089	2018-04-12	Base Salary	6311.21	EUR	Monthly	1
1089	2018-04-12	Transport Allowance	61.61	EUR	Monthly	2
1089	2025-04-24	Base Salary	8333.74	EUR	Monthly	1
1089	2025-04-24	Transport Allowance	61.61	EUR	Monthly	2
1090	2023-03-18	Base Salary	2968.22	EUR	Monthly	1
1090	2023-03-18	Transport Allowance	46.24	EUR	Monthly	2
1090	2025-11-23	Base Salary	2968.22	EUR	Monthly	1
1090	2025-11-23	Transport Allowance	46.24	EUR	Monthly	2
1091	2019-03-17	Base Salary	3255.57	EUR	Monthly	1
1091	2019-03-17	Transport Allowance	49.75	EUR	Monthly	2
1091	2022-02-26	Base Salary	4521.01	EUR	Monthly	1
1091	2022-02-26	Transport Allowance	49.75	EUR	Monthly	2
1091	2025-03-23	Base Salary	6320.28	EUR	Monthly	1
1091	2025-03-23	Transport Allowance	49.75	EUR	Monthly	2
1091	2025-11-21	Base Salary	6471.39	EUR	Monthly	1
1091	2025-11-21	Transport Allowance	49.75	EUR	Monthly	2
1092	2024-05-27	Base Salary	8516.74	EUR	Monthly	1
1092	2024-05-27	Transport Allowance	50.44	EUR	Monthly	2
1092	2026-01-13	Base Salary	9286.55	EUR	Monthly	1
1092	2026-01-13	Transport Allowance	50.44	EUR	Monthly	2
1093	2023-02-12	Base Salary	5918.49	EUR	Monthly	1
1093	2023-02-12	Transport Allowance	61.12	EUR	Monthly	2
1093	2023-02-12	Housing Allowance	390.35	EUR	Monthly	3
1093	2026-02-06	Base Salary	7764.38	EUR	Monthly	1
1093	2026-02-06	Transport Allowance	61.12	EUR	Monthly	2
1093	2026-02-06	Housing Allowance	397.10	EUR	Monthly	3
1094	2013-01-11	Base Salary	4305.88	EUR	Monthly	1
1094	2013-01-11	Transport Allowance	61.19	EUR	Monthly	2
1094	2016-01-29	Base Salary	6177.87	EUR	Monthly	1
1094	2016-01-29	Transport Allowance	61.19	EUR	Monthly	2
1094	2019-02-04	Base Salary	8151.65	EUR	Monthly	1
1094	2019-02-04	Transport Allowance	61.19	EUR	Monthly	2
1094	2025-12-23	Base Salary	10223.27	EUR	Monthly	1
1094	2025-12-23	Transport Allowance	61.19	EUR	Monthly	2
1095	2017-10-09	Base Salary	4146.98	EUR	Monthly	1
1095	2017-10-09	Transport Allowance	73.50	EUR	Monthly	2
1095	2020-09-14	Base Salary	5193.90	EUR	Monthly	1
1095	2020-09-14	Transport Allowance	73.50	EUR	Monthly	2
1095	2020-09-14	Car Allowance	500.00	EUR	Monthly	3
1095	2020-09-14	Housing Allowance	404.11	EUR	Monthly	4
1095	2025-09-12	Base Salary	7092.68	EUR	Monthly	1
1095	2025-09-12	Transport Allowance	73.50	EUR	Monthly	2
1095	2025-09-12	Car Allowance	500.00	EUR	Monthly	3
1095	2025-09-12	Housing Allowance	212.32	EUR	Monthly	4
1096	2015-04-05	Base Salary	6651.06	EUR	Monthly	1
1096	2015-04-05	Transport Allowance	63.24	EUR	Monthly	2
1096	2015-04-05	Housing Allowance	324.29	EUR	Monthly	3
1096	2025-07-21	Base Salary	6865.87	EUR	Monthly	1
1096	2025-07-21	Transport Allowance	63.24	EUR	Monthly	2
1096	2025-07-21	Car Allowance	400.00	EUR	Monthly	3
1096	2025-07-21	Housing Allowance	349.20	EUR	Monthly	4
1097	2019-08-19	Base Salary	6755.52	EUR	Monthly	1
1097	2019-08-19	Transport Allowance	64.43	EUR	Monthly	2
1097	2019-08-19	Housing Allowance	204.12	EUR	Monthly	3
1097	2025-11-24	Base Salary	6836.11	EUR	Monthly	1
1097	2025-11-24	Transport Allowance	64.43	EUR	Monthly	2
1097	2025-11-24	Car Allowance	400.00	EUR	Monthly	3
1097	2025-11-24	Housing Allowance	327.03	EUR	Monthly	4
1098	2015-02-14	Base Salary	5910.29	EUR	Monthly	1
1098	2015-02-14	Transport Allowance	56.61	EUR	Monthly	2
1098	2018-02-03	Base Salary	7335.12	EUR	Monthly	1
1098	2018-02-03	Transport Allowance	56.61	EUR	Monthly	2
1098	2018-02-03	Housing Allowance	401.56	EUR	Monthly	3
1098	2025-12-27	Base Salary	10309.51	EUR	Monthly	1
1098	2025-12-27	Transport Allowance	56.61	EUR	Monthly	2
1098	2025-12-27	Housing Allowance	375.07	EUR	Monthly	3
1099	2016-04-01	Base Salary	3180.80	EUR	Monthly	1
1099	2016-04-01	Transport Allowance	47.32	EUR	Monthly	2
1099	2019-05-01	Base Salary	4235.63	EUR	Monthly	1
1099	2019-05-01	Transport Allowance	47.32	EUR	Monthly	2
1099	2025-03-04	Base Salary	7412.80	EUR	Monthly	1
1099	2025-03-04	Transport Allowance	47.32	EUR	Monthly	2
1099	2025-03-04	Housing Allowance	232.85	EUR	Monthly	3
1099	2025-05-03	Base Salary	7552.58	EUR	Monthly	1
1099	2025-05-03	Transport Allowance	47.32	EUR	Monthly	2
1099	2025-05-03	Housing Allowance	384.96	EUR	Monthly	3
1100	2025-09-29	Base Salary	4254.14	EUR	Monthly	1
1100	2025-09-29	Transport Allowance	56.87	EUR	Monthly	2
1101	2012-11-10	Base Salary	5513.08	EUR	Monthly	1
1101	2012-11-10	Transport Allowance	58.13	EUR	Monthly	2
1101	2012-11-10	Housing Allowance	317.54	EUR	Monthly	3
1101	2025-07-18	Base Salary	6604.97	EUR	Monthly	1
1101	2025-07-18	Transport Allowance	58.13	EUR	Monthly	2
1101	2025-07-18	Housing Allowance	236.51	EUR	Monthly	3
1102	2012-04-01	Base Salary	9865.06	EUR	Monthly	1
1102	2012-04-01	Transport Allowance	66.20	EUR	Monthly	2
1102	2012-04-01	Housing Allowance	241.22	EUR	Monthly	3
1102	2025-09-26	Base Salary	9865.06	EUR	Monthly	1
1102	2025-09-26	Transport Allowance	66.20	EUR	Monthly	2
1102	2025-09-26	Housing Allowance	225.71	EUR	Monthly	3
1103	2016-01-08	Base Salary	5111.48	EUR	Monthly	1
1103	2016-01-08	Transport Allowance	72.38	EUR	Monthly	2
1103	2018-12-19	Base Salary	6385.37	EUR	Monthly	1
1103	2018-12-19	Transport Allowance	72.38	EUR	Monthly	2
1103	2018-12-19	Car Allowance	350.00	EUR	Monthly	3
1103	2021-12-25	Base Salary	8502.17	EUR	Monthly	1
1103	2021-12-25	Transport Allowance	72.38	EUR	Monthly	2
1103	2021-12-25	Car Allowance	350.00	EUR	Monthly	3
1103	2025-02-15	Base Salary	8657.03	EUR	Monthly	1
1103	2025-02-15	Transport Allowance	72.38	EUR	Monthly	2
1103	2025-02-15	Car Allowance	350.00	EUR	Monthly	3
1104	2020-04-05	Base Salary	3018.51	EUR	Monthly	1
1104	2020-04-05	Transport Allowance	55.79	EUR	Monthly	2
1104	2025-12-03	Base Salary	4413.43	EUR	Monthly	1
1104	2025-12-03	Transport Allowance	55.79	EUR	Monthly	2
1105	2018-10-27	Base Salary	6036.47	EUR	Monthly	1
1105	2018-10-27	Transport Allowance	75.02	EUR	Monthly	2
1105	2018-10-27	Housing Allowance	356.16	EUR	Monthly	3
1105	2025-01-13	Base Salary	7885.01	EUR	Monthly	1
1105	2025-01-13	Transport Allowance	75.02	EUR	Monthly	2
1105	2025-01-13	Car Allowance	350.00	EUR	Monthly	3
1105	2025-01-13	Housing Allowance	259.73	EUR	Monthly	4
1106	2018-06-12	Base Salary	4891.86	EUR	Monthly	1
1106	2018-06-12	Transport Allowance	48.04	EUR	Monthly	2
1106	2021-05-17	Base Salary	6080.75	EUR	Monthly	1
1106	2021-05-17	Transport Allowance	48.04	EUR	Monthly	2
1106	2024-06-19	Base Salary	8608.37	EUR	Monthly	1
1106	2024-06-19	Transport Allowance	48.04	EUR	Monthly	2
1106	2024-06-19	Car Allowance	400.00	EUR	Monthly	3
1106	2024-06-19	Housing Allowance	392.95	EUR	Monthly	4
1106	2025-06-03	Base Salary	8758.24	EUR	Monthly	1
1106	2025-06-03	Transport Allowance	48.04	EUR	Monthly	2
1106	2025-06-03	Car Allowance	400.00	EUR	Monthly	3
1106	2025-06-03	Housing Allowance	281.75	EUR	Monthly	4
1107	2016-07-05	Base Salary	4042.86	EUR	Monthly	1
1107	2016-07-05	Transport Allowance	74.03	EUR	Monthly	2
1107	2022-07-14	Base Salary	6733.19	EUR	Monthly	1
1107	2022-07-14	Transport Allowance	74.03	EUR	Monthly	2
1107	2022-07-14	Car Allowance	500.00	EUR	Monthly	3
1107	2025-04-21	Base Salary	7202.41	EUR	Monthly	1
1107	2025-04-21	Transport Allowance	74.03	EUR	Monthly	2
1107	2025-04-21	Car Allowance	500.00	EUR	Monthly	3
1108	2019-03-13	Base Salary	3299.38	EUR	Monthly	1
1108	2019-03-13	Transport Allowance	55.59	EUR	Monthly	2
1108	2022-03-25	Base Salary	4228.76	EUR	Monthly	1
1108	2022-03-25	Transport Allowance	55.59	EUR	Monthly	2
1108	2025-03-19	Base Salary	5688.47	EUR	Monthly	1
1108	2025-03-19	Transport Allowance	55.59	EUR	Monthly	2
1108	2025-05-21	Base Salary	5688.47	EUR	Monthly	1
1108	2025-05-21	Transport Allowance	55.59	EUR	Monthly	2
1109	2024-03-22	Base Salary	9829.92	EUR	Monthly	1
1109	2024-03-22	Transport Allowance	63.38	EUR	Monthly	2
1109	2025-10-04	Base Salary	9829.92	EUR	Monthly	1
1109	2025-10-04	Transport Allowance	63.38	EUR	Monthly	2
1110	2015-03-25	Base Salary	5248.98	EUR	Monthly	1
1110	2015-03-25	Transport Allowance	51.13	EUR	Monthly	2
1110	2025-10-06	Base Salary	8235.58	EUR	Monthly	1
1110	2025-10-06	Transport Allowance	51.13	EUR	Monthly	2
1111	2012-12-29	Base Salary	3653.30	EUR	Monthly	1
1111	2012-12-29	Transport Allowance	58.10	EUR	Monthly	2
1111	2016-01-11	Base Salary	4825.49	EUR	Monthly	1
1111	2016-01-11	Transport Allowance	58.10	EUR	Monthly	2
1111	2021-12-21	Base Salary	8670.30	EUR	Monthly	1
1111	2021-12-21	Transport Allowance	58.10	EUR	Monthly	2
1111	2021-12-21	Car Allowance	500.00	EUR	Monthly	3
1111	2021-12-21	Housing Allowance	208.23	EUR	Monthly	4
1111	2025-08-26	Base Salary	8670.30	EUR	Monthly	1
1111	2025-08-26	Transport Allowance	58.10	EUR	Monthly	2
1111	2025-08-26	Car Allowance	500.00	EUR	Monthly	3
1111	2025-08-26	Housing Allowance	244.46	EUR	Monthly	4
1112	2017-05-02	Base Salary	3734.17	EUR	Monthly	1
1112	2017-05-02	Transport Allowance	48.24	EUR	Monthly	2
1112	2020-04-07	Base Salary	5543.94	EUR	Monthly	1
1112	2020-04-07	Transport Allowance	48.24	EUR	Monthly	2
1112	2020-04-07	Car Allowance	500.00	EUR	Monthly	3
1112	2020-04-07	Housing Allowance	311.32	EUR	Monthly	4
1112	2025-04-19	Base Salary	6388.29	EUR	Monthly	1
1112	2025-04-19	Transport Allowance	48.24	EUR	Monthly	2
1112	2025-04-19	Car Allowance	500.00	EUR	Monthly	3
1112	2025-04-19	Housing Allowance	375.79	EUR	Monthly	4
1113	2021-12-08	Base Salary	3012.37	EUR	Monthly	1
1113	2021-12-08	Transport Allowance	76.67	EUR	Monthly	2
1113	2025-01-03	Base Salary	3911.55	EUR	Monthly	1
1113	2025-01-03	Transport Allowance	76.67	EUR	Monthly	2
1113	2025-03-01	Base Salary	4192.95	EUR	Monthly	1
1113	2025-03-01	Transport Allowance	76.67	EUR	Monthly	2
1114	2021-01-13	Base Salary	3115.49	EUR	Monthly	1
1114	2021-01-13	Transport Allowance	50.39	EUR	Monthly	2
1114	2025-07-11	Base Salary	3927.92	EUR	Monthly	1
1114	2025-07-11	Transport Allowance	50.39	EUR	Monthly	2
1115	2020-08-21	Base Salary	4627.73	EUR	Monthly	1
1115	2020-08-21	Transport Allowance	56.90	EUR	Monthly	2
1115	2023-09-09	Base Salary	6041.86	EUR	Monthly	1
1115	2023-09-09	Transport Allowance	56.90	EUR	Monthly	2
1115	2023-09-09	Housing Allowance	306.36	EUR	Monthly	3
1115	2025-08-13	Base Salary	6041.86	EUR	Monthly	1
1115	2025-08-13	Transport Allowance	56.90	EUR	Monthly	2
1115	2025-08-13	Housing Allowance	392.25	EUR	Monthly	3
1116	2013-03-01	Base Salary	7279.88	EUR	Monthly	1
1116	2013-03-01	Transport Allowance	55.86	EUR	Monthly	2
1116	2013-03-01	Housing Allowance	272.01	EUR	Monthly	3
1116	2025-11-02	Base Salary	7552.50	EUR	Monthly	1
1116	2025-11-02	Transport Allowance	55.86	EUR	Monthly	2
1116	2025-11-02	Car Allowance	400.00	EUR	Monthly	3
1116	2025-11-02	Housing Allowance	369.29	EUR	Monthly	4
1117	2023-06-27	Base Salary	4085.52	EUR	Monthly	1
1117	2023-06-27	Transport Allowance	48.44	EUR	Monthly	2
1117	2025-08-27	Base Salary	4085.52	EUR	Monthly	1
1117	2025-08-27	Transport Allowance	48.44	EUR	Monthly	2
1118	2014-01-14	Base Salary	8095.69	EUR	Monthly	1
1118	2014-01-14	Transport Allowance	79.38	EUR	Monthly	2
1118	2016-12-29	Base Salary	9945.37	EUR	Monthly	1
1118	2016-12-29	Transport Allowance	79.38	EUR	Monthly	2
1118	2025-03-09	Base Salary	10478.19	EUR	Monthly	1
1118	2025-03-09	Transport Allowance	79.38	EUR	Monthly	2
1119	2021-11-06	Base Salary	7109.75	EUR	Monthly	1
1119	2021-11-06	Transport Allowance	63.07	EUR	Monthly	2
1119	2021-11-06	Housing Allowance	418.40	EUR	Monthly	3
1119	2026-01-26	Base Salary	7518.23	EUR	Monthly	1
1119	2026-01-26	Transport Allowance	63.07	EUR	Monthly	2
1119	2026-01-26	Housing Allowance	245.14	EUR	Monthly	3
1120	2013-05-24	Base Salary	3728.21	EUR	Monthly	1
1120	2013-05-24	Transport Allowance	46.28	EUR	Monthly	2
1120	2016-05-17	Base Salary	5846.02	EUR	Monthly	1
1120	2016-05-17	Transport Allowance	46.28	EUR	Monthly	2
1120	2025-11-13	Base Salary	9858.25	EUR	Monthly	1
1120	2025-11-13	Transport Allowance	46.28	EUR	Monthly	2
1121	2021-12-05	Base Salary	5169.87	EUR	Monthly	1
1121	2021-12-05	Transport Allowance	58.57	EUR	Monthly	2
1121	2024-12-07	Base Salary	7072.92	EUR	Monthly	1
1121	2024-12-07	Transport Allowance	58.57	EUR	Monthly	2
1121	2024-12-07	Car Allowance	350.00	EUR	Monthly	3
1121	2024-12-07	Housing Allowance	390.26	EUR	Monthly	4
1121	2025-03-29	Base Salary	7072.92	EUR	Monthly	1
1121	2025-03-29	Transport Allowance	58.57	EUR	Monthly	2
1121	2025-03-29	Car Allowance	350.00	EUR	Monthly	3
1121	2025-03-29	Housing Allowance	225.48	EUR	Monthly	4
1122	2017-05-19	Base Salary	6515.11	EUR	Monthly	1
1122	2017-05-19	Transport Allowance	55.88	EUR	Monthly	2
1122	2025-06-26	Base Salary	7041.87	EUR	Monthly	1
1122	2025-06-26	Transport Allowance	55.88	EUR	Monthly	2
1123	2023-05-24	Base Salary	3367.00	EUR	Monthly	1
1123	2023-05-24	Transport Allowance	46.54	EUR	Monthly	2
1123	2025-03-25	Base Salary	3367.00	EUR	Monthly	1
1123	2025-03-25	Transport Allowance	46.54	EUR	Monthly	2
1124	2016-07-08	Base Salary	3901.90	EUR	Monthly	1
1124	2016-07-08	Transport Allowance	74.68	EUR	Monthly	2
1124	2022-07-26	Base Salary	6494.50	EUR	Monthly	1
1124	2022-07-26	Transport Allowance	74.68	EUR	Monthly	2
1124	2022-07-26	Car Allowance	500.00	EUR	Monthly	3
1124	2022-07-26	Housing Allowance	391.81	EUR	Monthly	4
1124	2026-01-16	Base Salary	6639.54	EUR	Monthly	1
1124	2026-01-16	Transport Allowance	74.68	EUR	Monthly	2
1124	2026-01-16	Car Allowance	500.00	EUR	Monthly	3
1124	2026-01-16	Housing Allowance	273.32	EUR	Monthly	4
1125	2023-06-05	Base Salary	2628.85	EUR	Monthly	1
1125	2023-06-05	Transport Allowance	76.12	EUR	Monthly	2
1125	2025-10-11	Base Salary	2628.85	EUR	Monthly	1
1125	2025-10-11	Transport Allowance	76.12	EUR	Monthly	2
1126	2019-10-12	Base Salary	3895.25	EUR	Monthly	1
1126	2019-10-12	Transport Allowance	48.61	EUR	Monthly	2
1126	2025-10-28	Base Salary	7075.03	EUR	Monthly	1
1126	2025-10-28	Transport Allowance	48.61	EUR	Monthly	2
1127	2013-03-26	Base Salary	3566.69	EUR	Monthly	1
1127	2013-03-26	Transport Allowance	71.82	EUR	Monthly	2
1127	2016-03-13	Base Salary	5266.55	EUR	Monthly	1
1127	2016-03-13	Transport Allowance	71.82	EUR	Monthly	2
1127	2019-03-30	Base Salary	6607.35	EUR	Monthly	1
1127	2019-03-30	Transport Allowance	71.82	EUR	Monthly	2
1127	2019-03-30	Car Allowance	350.00	EUR	Monthly	3
1127	2019-03-30	Housing Allowance	364.02	EUR	Monthly	4
1127	2022-03-20	Base Salary	9029.90	EUR	Monthly	1
1127	2022-03-20	Transport Allowance	71.82	EUR	Monthly	2
1127	2022-03-20	Car Allowance	350.00	EUR	Monthly	3
1127	2022-03-20	Housing Allowance	204.95	EUR	Monthly	4
1127	2025-12-26	Base Salary	9357.56	EUR	Monthly	1
1127	2025-12-26	Transport Allowance	71.82	EUR	Monthly	2
1127	2025-12-26	Car Allowance	350.00	EUR	Monthly	3
1127	2025-12-26	Housing Allowance	366.87	EUR	Monthly	4
1128	2022-07-26	Base Salary	16789.27	EUR	Monthly	1
1128	2022-07-26	Transport Allowance	67.36	EUR	Monthly	2
1128	2022-07-26	Housing Allowance	246.17	EUR	Monthly	3
1128	2025-12-12	Base Salary	16789.27	EUR	Monthly	1
1128	2025-12-12	Transport Allowance	67.36	EUR	Monthly	2
1128	2025-12-12	Car Allowance	800.00	EUR	Monthly	3
1128	2025-12-12	Housing Allowance	244.12	EUR	Monthly	4
1129	2013-03-31	Base Salary	2793.90	EUR	Monthly	1
1129	2013-03-31	Transport Allowance	55.03	EUR	Monthly	2
1129	2019-03-23	Base Salary	5391.64	EUR	Monthly	1
1129	2019-03-23	Transport Allowance	55.03	EUR	Monthly	2
1129	2022-04-20	Base Salary	6266.17	EUR	Monthly	1
1129	2022-04-20	Transport Allowance	55.03	EUR	Monthly	2
1129	2025-03-27	Base Salary	6378.00	EUR	Monthly	1
1129	2025-03-27	Transport Allowance	55.03	EUR	Monthly	2
1130	2020-08-09	Base Salary	2844.04	EUR	Monthly	1
1130	2020-08-09	Transport Allowance	63.63	EUR	Monthly	2
1130	2023-07-20	Base Salary	4544.57	EUR	Monthly	1
1130	2023-07-20	Transport Allowance	63.63	EUR	Monthly	2
1130	2025-09-13	Base Salary	4544.57	EUR	Monthly	1
1130	2025-09-13	Transport Allowance	63.63	EUR	Monthly	2
1131	2017-12-08	Base Salary	4466.72	EUR	Monthly	1
1131	2017-12-08	Transport Allowance	72.05	EUR	Monthly	2
1131	2020-11-18	Base Salary	5576.00	EUR	Monthly	1
1131	2020-11-18	Transport Allowance	72.05	EUR	Monthly	2
1131	2020-11-18	Car Allowance	450.00	EUR	Monthly	3
1131	2020-11-18	Housing Allowance	347.65	EUR	Monthly	4
1131	2025-02-17	Base Salary	7509.58	EUR	Monthly	1
1131	2025-02-17	Transport Allowance	72.05	EUR	Monthly	2
1131	2025-02-17	Car Allowance	450.00	EUR	Monthly	3
1131	2025-02-17	Housing Allowance	259.98	EUR	Monthly	4
1132	2018-04-15	Base Salary	3387.70	EUR	Monthly	1
1132	2018-04-15	Transport Allowance	50.51	EUR	Monthly	2
1132	2025-12-13	Base Salary	6377.96	EUR	Monthly	1
1132	2025-12-13	Transport Allowance	50.51	EUR	Monthly	2
1133	2019-06-15	Base Salary	8023.94	EUR	Monthly	1
1133	2019-06-15	Transport Allowance	49.01	EUR	Monthly	2
1133	2022-05-26	Base Salary	9889.28	EUR	Monthly	1
1133	2022-05-26	Transport Allowance	49.01	EUR	Monthly	2
1133	2022-05-26	Housing Allowance	410.83	EUR	Monthly	3
1133	2025-05-31	Base Salary	12269.63	EUR	Monthly	1
1133	2025-05-31	Transport Allowance	49.01	EUR	Monthly	2
1133	2025-05-31	Housing Allowance	323.12	EUR	Monthly	3
1133	2025-08-22	Base Salary	12269.63	EUR	Monthly	1
1133	2025-08-22	Transport Allowance	49.01	EUR	Monthly	2
1133	2025-08-22	Housing Allowance	222.52	EUR	Monthly	3
1134	2025-09-24	Base Salary	4240.40	EUR	Monthly	1
1134	2025-09-24	Transport Allowance	63.99	EUR	Monthly	2
1135	2012-02-18	Base Salary	4255.00	EUR	Monthly	1
1135	2012-02-18	Transport Allowance	64.23	EUR	Monthly	2
1135	2015-01-22	Base Salary	5267.94	EUR	Monthly	1
1135	2015-01-22	Transport Allowance	64.23	EUR	Monthly	2
1135	2015-01-22	Housing Allowance	259.63	EUR	Monthly	3
1135	2025-05-08	Base Salary	6496.37	EUR	Monthly	1
1135	2025-05-08	Transport Allowance	64.23	EUR	Monthly	2
1135	2025-05-08	Housing Allowance	407.52	EUR	Monthly	3
1136	2017-02-03	Base Salary	4150.10	EUR	Monthly	1
1136	2017-02-03	Transport Allowance	73.14	EUR	Monthly	2
1136	2023-03-01	Base Salary	8157.13	EUR	Monthly	1
1136	2023-03-01	Transport Allowance	73.14	EUR	Monthly	2
1136	2023-03-01	Housing Allowance	326.30	EUR	Monthly	3
1136	2025-05-04	Base Salary	11002.41	EUR	Monthly	1
1136	2025-05-04	Transport Allowance	73.14	EUR	Monthly	2
1136	2025-05-04	Housing Allowance	237.68	EUR	Monthly	3
1137	2014-04-14	Base Salary	4495.75	EUR	Monthly	1
1137	2014-04-14	Transport Allowance	55.90	EUR	Monthly	2
1137	2017-04-14	Base Salary	6216.01	EUR	Monthly	1
1137	2017-04-14	Transport Allowance	55.90	EUR	Monthly	2
1137	2020-05-07	Base Salary	7649.18	EUR	Monthly	1
1137	2020-05-07	Transport Allowance	55.90	EUR	Monthly	2
1137	2025-06-05	Base Salary	7871.96	EUR	Monthly	1
1137	2025-06-05	Transport Allowance	55.90	EUR	Monthly	2
1138	2013-10-27	Base Salary	5259.09	EUR	Monthly	1
1138	2013-10-27	Transport Allowance	76.23	EUR	Monthly	2
1138	2013-10-27	Housing Allowance	318.93	EUR	Monthly	3
1138	2025-03-26	Base Salary	6269.33	EUR	Monthly	1
1138	2025-03-26	Transport Allowance	76.23	EUR	Monthly	2
1138	2025-03-26	Housing Allowance	211.16	EUR	Monthly	3
1139	2016-08-19	Base Salary	3005.68	EUR	Monthly	1
1139	2016-08-19	Transport Allowance	46.01	EUR	Monthly	2
1139	2019-09-01	Base Salary	4059.94	EUR	Monthly	1
1139	2019-09-01	Transport Allowance	46.01	EUR	Monthly	2
1139	2022-08-26	Base Salary	4954.73	EUR	Monthly	1
1139	2022-08-26	Transport Allowance	46.01	EUR	Monthly	2
1139	2022-08-26	Housing Allowance	398.72	EUR	Monthly	3
1139	2025-07-28	Base Salary	6555.04	EUR	Monthly	1
1139	2025-07-28	Transport Allowance	46.01	EUR	Monthly	2
1139	2025-07-28	Housing Allowance	211.10	EUR	Monthly	3
1139	2026-01-29	Base Salary	6555.04	EUR	Monthly	1
1139	2026-01-29	Transport Allowance	46.01	EUR	Monthly	2
1139	2026-01-29	Housing Allowance	284.39	EUR	Monthly	3
1140	2015-08-01	Base Salary	5225.40	EUR	Monthly	1
1140	2015-08-01	Transport Allowance	48.01	EUR	Monthly	2
1140	2018-07-28	Base Salary	7067.43	EUR	Monthly	1
1140	2018-07-28	Transport Allowance	48.01	EUR	Monthly	2
1140	2021-07-13	Base Salary	9383.82	EUR	Monthly	1
1140	2021-07-13	Transport Allowance	48.01	EUR	Monthly	2
1140	2025-05-14	Base Salary	9383.82	EUR	Monthly	1
1140	2025-05-14	Transport Allowance	48.01	EUR	Monthly	2
1141	2023-09-11	Base Salary	3065.20	EUR	Monthly	1
1141	2023-09-11	Transport Allowance	58.72	EUR	Monthly	2
1141	2026-01-16	Base Salary	3065.20	EUR	Monthly	1
1141	2026-01-16	Transport Allowance	58.72	EUR	Monthly	2
1142	2020-04-23	Base Salary	15734.75	EUR	Monthly	1
1142	2020-04-23	Transport Allowance	69.66	EUR	Monthly	2
1142	2020-04-23	Housing Allowance	396.08	EUR	Monthly	3
1142	2025-09-30	Base Salary	15734.75	EUR	Monthly	1
1142	2025-09-30	Transport Allowance	69.66	EUR	Monthly	2
1142	2025-09-30	Car Allowance	800.00	EUR	Monthly	3
1142	2025-09-30	Housing Allowance	338.48	EUR	Monthly	4
1143	2013-07-27	Base Salary	4408.45	EUR	Monthly	1
1143	2013-07-27	Transport Allowance	69.15	EUR	Monthly	2
1143	2016-08-04	Base Salary	5707.17	EUR	Monthly	1
1143	2016-08-04	Transport Allowance	69.15	EUR	Monthly	2
1143	2016-08-04	Housing Allowance	298.08	EUR	Monthly	3
1143	2019-08-26	Base Salary	7273.21	EUR	Monthly	1
1143	2019-08-26	Transport Allowance	69.15	EUR	Monthly	2
1143	2019-08-26	Housing Allowance	278.24	EUR	Monthly	3
1143	2025-02-16	Base Salary	7950.56	EUR	Monthly	1
1143	2025-02-16	Transport Allowance	69.15	EUR	Monthly	2
1143	2025-02-16	Housing Allowance	273.11	EUR	Monthly	3
1144	2016-09-15	Base Salary	4209.91	EUR	Monthly	1
1144	2016-09-15	Transport Allowance	51.94	EUR	Monthly	2
1144	2019-08-18	Base Salary	6065.21	EUR	Monthly	1
1144	2019-08-18	Transport Allowance	51.94	EUR	Monthly	2
1144	2022-10-15	Base Salary	7561.95	EUR	Monthly	1
1144	2022-10-15	Transport Allowance	51.94	EUR	Monthly	2
1144	2025-03-09	Base Salary	9582.33	EUR	Monthly	1
1144	2025-03-09	Transport Allowance	51.94	EUR	Monthly	2
1145	2017-09-03	Base Salary	7543.04	EUR	Monthly	1
1145	2017-09-03	Transport Allowance	71.54	EUR	Monthly	2
1145	2026-02-03	Base Salary	10784.28	EUR	Monthly	1
1145	2026-02-03	Transport Allowance	71.54	EUR	Monthly	2
1146	2016-06-15	Base Salary	4583.36	EUR	Monthly	1
1146	2016-06-15	Transport Allowance	73.33	EUR	Monthly	2
1146	2019-05-24	Base Salary	6035.15	EUR	Monthly	1
1146	2019-05-24	Transport Allowance	73.33	EUR	Monthly	2
1146	2025-03-06	Base Salary	8076.12	EUR	Monthly	1
1146	2025-03-06	Transport Allowance	73.33	EUR	Monthly	2
1147	2019-07-08	Base Salary	4329.42	EUR	Monthly	1
1147	2019-07-08	Transport Allowance	47.75	EUR	Monthly	2
1147	2022-07-12	Base Salary	5315.84	EUR	Monthly	1
1147	2022-07-12	Transport Allowance	47.75	EUR	Monthly	2
1147	2022-07-12	Housing Allowance	403.01	EUR	Monthly	3
1147	2025-07-23	Base Salary	6616.01	EUR	Monthly	1
1147	2025-07-23	Transport Allowance	47.75	EUR	Monthly	2
1147	2025-07-23	Housing Allowance	368.17	EUR	Monthly	3
1147	2025-09-14	Base Salary	6616.01	EUR	Monthly	1
1147	2025-09-14	Transport Allowance	47.75	EUR	Monthly	2
1147	2025-09-14	Housing Allowance	324.91	EUR	Monthly	3
1148	2012-03-01	Base Salary	3324.56	EUR	Monthly	1
1148	2012-03-01	Transport Allowance	48.25	EUR	Monthly	2
1148	2015-03-12	Base Salary	4641.91	EUR	Monthly	1
1148	2015-03-12	Transport Allowance	48.25	EUR	Monthly	2
1148	2021-02-05	Base Salary	6839.59	EUR	Monthly	1
1148	2021-02-05	Transport Allowance	48.25	EUR	Monthly	2
1148	2021-02-05	Housing Allowance	376.52	EUR	Monthly	3
1148	2025-03-12	Base Salary	7000.18	EUR	Monthly	1
1148	2025-03-12	Transport Allowance	48.25	EUR	Monthly	2
1148	2025-03-12	Housing Allowance	353.69	EUR	Monthly	3
1149	2023-10-03	Base Salary	2792.87	EUR	Monthly	1
1149	2023-10-03	Transport Allowance	48.40	EUR	Monthly	2
1149	2025-07-25	Base Salary	3183.05	EUR	Monthly	1
1149	2025-07-25	Transport Allowance	48.40	EUR	Monthly	2
1150	2012-08-11	Base Salary	2816.09	EUR	Monthly	1
1150	2012-08-11	Transport Allowance	55.86	EUR	Monthly	2
1150	2015-07-29	Base Salary	4090.05	EUR	Monthly	1
1150	2015-07-29	Transport Allowance	55.86	EUR	Monthly	2
1150	2018-07-25	Base Salary	5612.99	EUR	Monthly	1
1150	2018-07-25	Transport Allowance	55.86	EUR	Monthly	2
1150	2025-02-09	Base Salary	7360.08	EUR	Monthly	1
1150	2025-02-09	Transport Allowance	55.86	EUR	Monthly	2
1151	2021-05-26	Base Salary	5450.00	EUR	Monthly	1
1151	2021-05-26	Transport Allowance	67.55	EUR	Monthly	2
1151	2024-05-12	Base Salary	6552.55	EUR	Monthly	1
1151	2024-05-12	Transport Allowance	67.55	EUR	Monthly	2
1151	2024-05-12	Car Allowance	400.00	EUR	Monthly	3
1151	2024-05-12	Housing Allowance	368.63	EUR	Monthly	4
1151	2025-08-30	Base Salary	7076.47	EUR	Monthly	1
1151	2025-08-30	Transport Allowance	67.55	EUR	Monthly	2
1151	2025-08-30	Car Allowance	400.00	EUR	Monthly	3
1151	2025-08-30	Housing Allowance	303.52	EUR	Monthly	4
1152	2014-03-02	Base Salary	7137.40	EUR	Monthly	1
1152	2014-03-02	Transport Allowance	78.16	EUR	Monthly	2
1152	2025-06-04	Base Salary	7137.40	EUR	Monthly	1
1152	2025-06-04	Transport Allowance	78.16	EUR	Monthly	2
1153	2018-03-15	Base Salary	6800.31	EUR	Monthly	1
1153	2018-03-15	Transport Allowance	50.03	EUR	Monthly	2
1153	2025-04-08	Base Salary	7845.20	EUR	Monthly	1
1153	2025-04-08	Transport Allowance	50.03	EUR	Monthly	2
1154	2015-07-29	Base Salary	3036.06	EUR	Monthly	1
1154	2015-07-29	Transport Allowance	76.35	EUR	Monthly	2
1154	2024-07-31	Base Salary	6781.63	EUR	Monthly	1
1154	2024-07-31	Transport Allowance	76.35	EUR	Monthly	2
1154	2025-11-04	Base Salary	6781.63	EUR	Monthly	1
1154	2025-11-04	Transport Allowance	76.35	EUR	Monthly	2
1155	2023-05-07	Base Salary	6200.62	EUR	Monthly	1
1155	2023-05-07	Transport Allowance	54.03	EUR	Monthly	2
1155	2025-10-29	Base Salary	6205.03	EUR	Monthly	1
1155	2025-10-29	Transport Allowance	54.03	EUR	Monthly	2
1156	2025-04-09	Base Salary	5477.07	EUR	Monthly	1
1156	2025-04-09	Transport Allowance	57.72	EUR	Monthly	2
1156	2025-05-27	Base Salary	5706.37	EUR	Monthly	1
1156	2025-05-27	Transport Allowance	57.72	EUR	Monthly	2
1157	2022-07-23	Base Salary	8303.40	EUR	Monthly	1
1157	2022-07-23	Transport Allowance	51.42	EUR	Monthly	2
1157	2025-06-18	Base Salary	8303.40	EUR	Monthly	1
1157	2025-06-18	Transport Allowance	51.42	EUR	Monthly	2
1158	2014-10-06	Base Salary	3404.98	EUR	Monthly	1
1158	2014-10-06	Transport Allowance	77.10	EUR	Monthly	2
1158	2017-09-20	Base Salary	4672.70	EUR	Monthly	1
1158	2017-09-20	Transport Allowance	77.10	EUR	Monthly	2
1158	2020-10-22	Base Salary	6332.94	EUR	Monthly	1
1158	2020-10-22	Transport Allowance	77.10	EUR	Monthly	2
1158	2020-10-22	Housing Allowance	272.67	EUR	Monthly	3
1158	2026-01-18	Base Salary	7708.85	EUR	Monthly	1
1158	2026-01-18	Transport Allowance	77.10	EUR	Monthly	2
1158	2026-01-18	Housing Allowance	389.37	EUR	Monthly	3
1159	2012-06-03	Base Salary	5477.21	EUR	Monthly	1
1159	2012-06-03	Transport Allowance	56.37	EUR	Monthly	2
1159	2018-07-03	Base Salary	8440.56	EUR	Monthly	1
1159	2018-07-03	Transport Allowance	56.37	EUR	Monthly	2
1159	2025-05-12	Base Salary	9063.82	EUR	Monthly	1
1159	2025-05-12	Transport Allowance	56.37	EUR	Monthly	2
1160	2017-08-26	Base Salary	3152.66	EUR	Monthly	1
1160	2017-08-26	Transport Allowance	62.06	EUR	Monthly	2
1160	2020-09-19	Base Salary	4506.80	EUR	Monthly	1
1160	2020-09-19	Transport Allowance	62.06	EUR	Monthly	2
1160	2025-06-02	Base Salary	6343.75	EUR	Monthly	1
1160	2025-06-02	Transport Allowance	62.06	EUR	Monthly	2
1161	2024-07-03	Base Salary	5450.49	EUR	Monthly	1
1161	2024-07-03	Transport Allowance	47.29	EUR	Monthly	2
1161	2024-07-03	Housing Allowance	224.84	EUR	Monthly	3
1161	2025-07-21	Base Salary	5563.89	EUR	Monthly	1
1161	2025-07-21	Transport Allowance	47.29	EUR	Monthly	2
1161	2025-07-21	Housing Allowance	305.30	EUR	Monthly	3
1162	2014-09-16	Base Salary	4168.94	EUR	Monthly	1
1162	2014-09-16	Transport Allowance	74.60	EUR	Monthly	2
1162	2017-08-27	Base Salary	6170.81	EUR	Monthly	1
1162	2017-08-27	Transport Allowance	74.60	EUR	Monthly	2
1162	2020-09-27	Base Salary	7522.75	EUR	Monthly	1
1162	2020-09-27	Transport Allowance	74.60	EUR	Monthly	2
1162	2020-09-27	Housing Allowance	262.10	EUR	Monthly	3
1162	2023-09-03	Base Salary	9535.34	EUR	Monthly	1
1162	2023-09-03	Transport Allowance	74.60	EUR	Monthly	2
1162	2023-09-03	Housing Allowance	276.70	EUR	Monthly	3
1162	2025-08-10	Base Salary	9535.34	EUR	Monthly	1
1162	2025-08-10	Transport Allowance	74.60	EUR	Monthly	2
1162	2025-08-10	Housing Allowance	326.43	EUR	Monthly	3
1163	2012-08-28	Base Salary	3008.93	EUR	Monthly	1
1163	2012-08-28	Transport Allowance	62.78	EUR	Monthly	2
1163	2015-08-31	Base Salary	4222.76	EUR	Monthly	1
1163	2015-08-31	Transport Allowance	62.78	EUR	Monthly	2
1163	2025-10-10	Base Salary	7297.98	EUR	Monthly	1
1163	2025-10-10	Transport Allowance	62.78	EUR	Monthly	2
1163	2025-10-10	Car Allowance	400.00	EUR	Monthly	3
1164	2015-05-25	Base Salary	3524.89	EUR	Monthly	1
1164	2015-05-25	Transport Allowance	59.20	EUR	Monthly	2
1164	2018-06-01	Base Salary	5053.10	EUR	Monthly	1
1164	2018-06-01	Transport Allowance	59.20	EUR	Monthly	2
1164	2025-05-27	Base Salary	6066.74	EUR	Monthly	1
1164	2025-05-27	Transport Allowance	59.20	EUR	Monthly	2
1165	2017-03-11	Base Salary	5843.79	EUR	Monthly	1
1165	2017-03-11	Transport Allowance	70.00	EUR	Monthly	2
1165	2017-03-11	Housing Allowance	223.54	EUR	Monthly	3
1165	2020-04-09	Base Salary	7426.11	EUR	Monthly	1
1165	2020-04-09	Transport Allowance	70.00	EUR	Monthly	2
1165	2020-04-09	Housing Allowance	322.35	EUR	Monthly	3
1165	2026-01-07	Base Salary	8050.43	EUR	Monthly	1
1165	2026-01-07	Transport Allowance	70.00	EUR	Monthly	2
1165	2026-01-07	Housing Allowance	215.60	EUR	Monthly	3
1166	2012-05-27	Base Salary	4059.93	EUR	Monthly	1
1166	2012-05-27	Transport Allowance	55.57	EUR	Monthly	2
1166	2015-05-18	Base Salary	5656.22	EUR	Monthly	1
1166	2015-05-18	Transport Allowance	55.57	EUR	Monthly	2
1166	2025-07-24	Base Salary	9780.16	EUR	Monthly	1
1166	2025-07-24	Transport Allowance	55.57	EUR	Monthly	2
1166	2025-07-24	Car Allowance	400.00	EUR	Monthly	3
1167	2018-10-11	Base Salary	3558.34	EUR	Monthly	1
1167	2018-10-11	Transport Allowance	61.13	EUR	Monthly	2
1167	2021-10-25	Base Salary	4807.47	EUR	Monthly	1
1167	2021-10-25	Transport Allowance	61.13	EUR	Monthly	2
1167	2021-10-25	Housing Allowance	329.92	EUR	Monthly	3
1167	2024-10-11	Base Salary	5874.28	EUR	Monthly	1
1167	2024-10-11	Transport Allowance	61.13	EUR	Monthly	2
1167	2024-10-11	Housing Allowance	252.49	EUR	Monthly	3
1167	2026-01-23	Base Salary	5874.28	EUR	Monthly	1
1167	2026-01-23	Transport Allowance	61.13	EUR	Monthly	2
1167	2026-01-23	Housing Allowance	253.61	EUR	Monthly	3
1168	2013-03-07	Base Salary	3174.07	EUR	Monthly	1
1168	2013-03-07	Transport Allowance	50.57	EUR	Monthly	2
1168	2016-03-06	Base Salary	4408.04	EUR	Monthly	1
1168	2016-03-06	Transport Allowance	50.57	EUR	Monthly	2
1168	2022-02-21	Base Salary	7076.64	EUR	Monthly	1
1168	2022-02-21	Transport Allowance	50.57	EUR	Monthly	2
1168	2025-10-15	Base Salary	7076.64	EUR	Monthly	1
1168	2025-10-15	Transport Allowance	50.57	EUR	Monthly	2
1169	2022-11-30	Base Salary	3589.76	EUR	Monthly	1
1169	2022-11-30	Transport Allowance	61.88	EUR	Monthly	2
1169	2025-11-22	Base Salary	4961.98	EUR	Monthly	1
1169	2025-11-22	Transport Allowance	61.88	EUR	Monthly	2
1170	2023-07-24	Base Salary	5565.45	EUR	Monthly	1
1170	2023-07-24	Transport Allowance	47.31	EUR	Monthly	2
1170	2025-08-17	Base Salary	5565.45	EUR	Monthly	1
1170	2025-08-17	Transport Allowance	47.31	EUR	Monthly	2
1171	2012-06-20	Base Salary	7819.31	EUR	Monthly	1
1171	2012-06-20	Transport Allowance	52.29	EUR	Monthly	2
1171	2025-07-21	Base Salary	7819.31	EUR	Monthly	1
1171	2025-07-21	Transport Allowance	52.29	EUR	Monthly	2
1171	2025-07-21	Car Allowance	450.00	EUR	Monthly	3
1172	2015-01-14	Base Salary	7181.57	EUR	Monthly	1
1172	2015-01-14	Transport Allowance	69.29	EUR	Monthly	2
1172	2015-01-14	Housing Allowance	294.85	EUR	Monthly	3
1172	2025-03-08	Base Salary	7572.31	EUR	Monthly	1
1172	2025-03-08	Transport Allowance	69.29	EUR	Monthly	2
1172	2025-03-08	Housing Allowance	415.65	EUR	Monthly	3
1173	2012-08-25	Base Salary	6763.26	EUR	Monthly	1
1173	2012-08-25	Transport Allowance	64.85	EUR	Monthly	2
1173	2025-11-29	Base Salary	7679.98	EUR	Monthly	1
1173	2025-11-29	Transport Allowance	64.85	EUR	Monthly	2
1173	2025-11-29	Car Allowance	400.00	EUR	Monthly	3
1174	2019-05-24	Base Salary	5741.96	EUR	Monthly	1
1174	2019-05-24	Transport Allowance	56.98	EUR	Monthly	2
1174	2025-06-23	Base Salary	9228.22	EUR	Monthly	1
1174	2025-06-23	Transport Allowance	56.98	EUR	Monthly	2
1174	2025-07-27	Base Salary	9228.22	EUR	Monthly	1
1174	2025-07-27	Transport Allowance	56.98	EUR	Monthly	2
1175	2025-05-18	Base Salary	4277.38	EUR	Monthly	1
1175	2025-05-18	Transport Allowance	69.29	EUR	Monthly	2
1175	2025-07-30	Base Salary	4277.38	EUR	Monthly	1
1175	2025-07-30	Transport Allowance	69.29	EUR	Monthly	2
1176	2022-04-24	Base Salary	5884.75	EUR	Monthly	1
1176	2022-04-24	Transport Allowance	51.06	EUR	Monthly	2
1176	2025-04-10	Base Salary	7289.82	EUR	Monthly	1
1176	2025-04-10	Transport Allowance	51.06	EUR	Monthly	2
1176	2025-06-22	Base Salary	7289.82	EUR	Monthly	1
1176	2025-06-22	Transport Allowance	51.06	EUR	Monthly	2
1177	2018-07-21	Base Salary	2876.30	EUR	Monthly	1
1177	2018-07-21	Transport Allowance	68.44	EUR	Monthly	2
1177	2021-06-30	Base Salary	3823.31	EUR	Monthly	1
1177	2021-06-30	Transport Allowance	68.44	EUR	Monthly	2
1177	2024-06-26	Base Salary	5207.73	EUR	Monthly	1
1177	2024-06-26	Transport Allowance	68.44	EUR	Monthly	2
1177	2025-11-21	Base Salary	5252.83	EUR	Monthly	1
1177	2025-11-21	Transport Allowance	68.44	EUR	Monthly	2
1178	2016-05-01	Base Salary	3145.04	EUR	Monthly	1
1178	2016-05-01	Transport Allowance	70.88	EUR	Monthly	2
1178	2022-04-03	Base Salary	6132.05	EUR	Monthly	1
1178	2022-04-03	Transport Allowance	70.88	EUR	Monthly	2
1178	2022-04-03	Car Allowance	350.00	EUR	Monthly	3
1178	2022-04-03	Housing Allowance	356.62	EUR	Monthly	4
1178	2025-04-21	Base Salary	7454.14	EUR	Monthly	1
1178	2025-04-21	Transport Allowance	70.88	EUR	Monthly	2
1178	2025-04-21	Car Allowance	350.00	EUR	Monthly	3
1178	2025-04-21	Housing Allowance	384.08	EUR	Monthly	4
1178	2025-06-11	Base Salary	7454.14	EUR	Monthly	1
1178	2025-06-11	Transport Allowance	70.88	EUR	Monthly	2
1178	2025-06-11	Car Allowance	350.00	EUR	Monthly	3
1178	2025-06-11	Housing Allowance	225.15	EUR	Monthly	4
1179	2019-06-02	Base Salary	6180.89	EUR	Monthly	1
1179	2019-06-02	Transport Allowance	65.86	EUR	Monthly	2
1179	2025-06-20	Base Salary	9560.82	EUR	Monthly	1
1179	2025-06-20	Transport Allowance	65.86	EUR	Monthly	2
1179	2025-12-02	Base Salary	9560.82	EUR	Monthly	1
1179	2025-12-02	Transport Allowance	65.86	EUR	Monthly	2
1180	2025-09-20	Base Salary	4311.87	EUR	Monthly	1
1180	2025-09-20	Transport Allowance	56.39	EUR	Monthly	2
1181	2019-05-03	Base Salary	3953.63	EUR	Monthly	1
1181	2019-05-03	Transport Allowance	48.42	EUR	Monthly	2
1181	2025-05-07	Base Salary	7415.85	EUR	Monthly	1
1181	2025-05-07	Transport Allowance	48.42	EUR	Monthly	2
1181	2025-05-07	Housing Allowance	297.95	EUR	Monthly	3
1181	2025-11-29	Base Salary	8262.19	EUR	Monthly	1
1181	2025-11-29	Transport Allowance	48.42	EUR	Monthly	2
1181	2025-11-29	Housing Allowance	267.77	EUR	Monthly	3
1182	2017-08-13	Base Salary	6614.38	EUR	Monthly	1
1182	2017-08-13	Transport Allowance	59.20	EUR	Monthly	2
1182	2025-04-16	Base Salary	9058.02	EUR	Monthly	1
1182	2025-04-16	Transport Allowance	59.20	EUR	Monthly	2
1183	2023-04-15	Base Salary	7378.98	EUR	Monthly	1
1183	2023-04-15	Transport Allowance	65.94	EUR	Monthly	2
1183	2025-05-06	Base Salary	8009.54	EUR	Monthly	1
1183	2025-05-06	Transport Allowance	65.94	EUR	Monthly	2
1184	2017-02-09	Base Salary	3268.33	EUR	Monthly	1
1184	2017-02-09	Transport Allowance	68.99	EUR	Monthly	2
1184	2020-02-22	Base Salary	4752.72	EUR	Monthly	1
1184	2020-02-22	Transport Allowance	68.99	EUR	Monthly	2
1184	2023-01-30	Base Salary	5893.69	EUR	Monthly	1
1184	2023-01-30	Transport Allowance	68.99	EUR	Monthly	2
1184	2023-01-30	Housing Allowance	331.21	EUR	Monthly	3
1184	2025-11-29	Base Salary	7548.19	EUR	Monthly	1
1184	2025-11-29	Transport Allowance	68.99	EUR	Monthly	2
1184	2025-11-29	Housing Allowance	380.37	EUR	Monthly	3
1185	2023-05-06	Base Salary	6891.95	EUR	Monthly	1
1185	2023-05-06	Transport Allowance	56.46	EUR	Monthly	2
1185	2025-09-02	Base Salary	6891.95	EUR	Monthly	1
1185	2025-09-02	Transport Allowance	56.46	EUR	Monthly	2
1185	2025-09-02	Car Allowance	450.00	EUR	Monthly	3
1186	2018-11-05	Base Salary	6835.67	EUR	Monthly	1
1186	2018-11-05	Transport Allowance	67.57	EUR	Monthly	2
1186	2018-11-05	Housing Allowance	213.53	EUR	Monthly	3
1186	2021-10-17	Base Salary	8724.35	EUR	Monthly	1
1186	2021-10-17	Transport Allowance	67.57	EUR	Monthly	2
1186	2021-10-17	Car Allowance	400.00	EUR	Monthly	3
1186	2021-10-17	Housing Allowance	247.87	EUR	Monthly	4
1186	2025-05-15	Base Salary	8767.56	EUR	Monthly	1
1186	2025-05-15	Transport Allowance	67.57	EUR	Monthly	2
1186	2025-05-15	Car Allowance	400.00	EUR	Monthly	3
1186	2025-05-15	Housing Allowance	230.56	EUR	Monthly	4
1187	2014-03-01	Base Salary	3401.88	EUR	Monthly	1
1187	2014-03-01	Transport Allowance	65.33	EUR	Monthly	2
1187	2017-03-25	Base Salary	5128.09	EUR	Monthly	1
1187	2017-03-25	Transport Allowance	65.33	EUR	Monthly	2
1187	2020-03-07	Base Salary	6362.09	EUR	Monthly	1
1187	2020-03-07	Transport Allowance	65.33	EUR	Monthly	2
1187	2020-03-07	Housing Allowance	366.10	EUR	Monthly	3
1187	2023-02-13	Base Salary	7749.08	EUR	Monthly	1
1187	2023-02-13	Transport Allowance	65.33	EUR	Monthly	2
1187	2023-02-13	Housing Allowance	378.16	EUR	Monthly	3
1187	2025-01-09	Base Salary	7749.08	EUR	Monthly	1
1187	2025-01-09	Transport Allowance	65.33	EUR	Monthly	2
1187	2025-01-09	Housing Allowance	366.56	EUR	Monthly	3
1188	2023-04-24	Base Salary	4520.14	EUR	Monthly	1
1188	2023-04-24	Transport Allowance	68.13	EUR	Monthly	2
1188	2025-11-25	Base Salary	4520.14	EUR	Monthly	1
1188	2025-11-25	Transport Allowance	68.13	EUR	Monthly	2
1189	2024-09-22	Base Salary	6277.71	EUR	Monthly	1
1189	2024-09-22	Transport Allowance	60.85	EUR	Monthly	2
1189	2025-03-09	Base Salary	6326.85	EUR	Monthly	1
1189	2025-03-09	Transport Allowance	60.85	EUR	Monthly	2
1190	2021-09-06	Base Salary	2650.83	EUR	Monthly	1
1190	2021-09-06	Transport Allowance	55.20	EUR	Monthly	2
1190	2025-04-24	Base Salary	4017.23	EUR	Monthly	1
1190	2025-04-24	Transport Allowance	55.20	EUR	Monthly	2
1191	2021-04-27	Base Salary	2837.48	EUR	Monthly	1
1191	2021-04-27	Transport Allowance	66.55	EUR	Monthly	2
1191	2024-04-05	Base Salary	3711.73	EUR	Monthly	1
1191	2024-04-05	Transport Allowance	66.55	EUR	Monthly	2
1191	2025-08-29	Base Salary	3711.73	EUR	Monthly	1
1191	2025-08-29	Transport Allowance	66.55	EUR	Monthly	2
1192	2016-11-17	Base Salary	10165.68	EUR	Monthly	1
1192	2016-11-17	Transport Allowance	60.65	EUR	Monthly	2
1192	2016-11-17	Housing Allowance	245.25	EUR	Monthly	3
1192	2026-01-04	Base Salary	12341.00	EUR	Monthly	1
1192	2026-01-04	Transport Allowance	60.65	EUR	Monthly	2
1192	2026-01-04	Car Allowance	400.00	EUR	Monthly	3
1192	2026-01-04	Housing Allowance	393.03	EUR	Monthly	4
1193	2025-05-14	Base Salary	3080.52	EUR	Monthly	1
1193	2025-05-14	Transport Allowance	55.49	EUR	Monthly	2
1193	2025-07-17	Base Salary	3176.57	EUR	Monthly	1
1193	2025-07-17	Transport Allowance	55.49	EUR	Monthly	2
1194	2023-02-20	Base Salary	7217.18	EUR	Monthly	1
1194	2023-02-20	Transport Allowance	72.80	EUR	Monthly	2
1194	2023-02-20	Housing Allowance	349.50	EUR	Monthly	3
1194	2026-03-06	Base Salary	9804.30	EUR	Monthly	1
1194	2026-03-06	Transport Allowance	72.80	EUR	Monthly	2
1194	2026-03-06	Housing Allowance	402.07	EUR	Monthly	3
1195	2019-07-08	Base Salary	10091.00	EUR	Monthly	1
1195	2019-07-08	Transport Allowance	77.78	EUR	Monthly	2
1195	2025-08-29	Base Salary	10091.00	EUR	Monthly	1
1195	2025-08-29	Transport Allowance	77.78	EUR	Monthly	2
1195	2025-08-29	Car Allowance	400.00	EUR	Monthly	3
1196	2015-08-20	Base Salary	8400.01	EUR	Monthly	1
1196	2015-08-20	Transport Allowance	70.12	EUR	Monthly	2
1196	2025-11-25	Base Salary	10233.57	EUR	Monthly	1
1196	2025-11-25	Transport Allowance	70.12	EUR	Monthly	2
1196	2025-11-25	Car Allowance	400.00	EUR	Monthly	3
1197	2025-07-03	Base Salary	6895.45	EUR	Monthly	1
1197	2025-07-03	Transport Allowance	77.03	EUR	Monthly	2
1197	2025-07-03	Housing Allowance	417.86	EUR	Monthly	3
1198	2013-06-10	Base Salary	4068.08	EUR	Monthly	1
1198	2013-06-10	Transport Allowance	65.40	EUR	Monthly	2
1198	2016-06-06	Base Salary	6362.71	EUR	Monthly	1
1198	2016-06-06	Transport Allowance	65.40	EUR	Monthly	2
1198	2025-01-12	Base Salary	10912.06	EUR	Monthly	1
1198	2025-01-12	Transport Allowance	65.40	EUR	Monthly	2
1198	2025-01-12	Car Allowance	500.00	EUR	Monthly	3
1199	2023-04-18	Base Salary	4405.36	EUR	Monthly	1
1199	2023-04-18	Transport Allowance	66.40	EUR	Monthly	2
1199	2025-08-28	Base Salary	4532.77	EUR	Monthly	1
1199	2025-08-28	Transport Allowance	66.40	EUR	Monthly	2
1200	2025-12-03	Base Salary	7588.03	EUR	Monthly	1
1200	2025-12-03	Transport Allowance	62.86	EUR	Monthly	2
1201	2017-04-12	Base Salary	5351.57	EUR	Monthly	1
1201	2017-04-12	Transport Allowance	74.67	EUR	Monthly	2
1201	2023-04-29	Base Salary	8813.50	EUR	Monthly	1
1201	2023-04-29	Transport Allowance	74.67	EUR	Monthly	2
1201	2025-07-11	Base Salary	8813.50	EUR	Monthly	1
1201	2025-07-11	Transport Allowance	74.67	EUR	Monthly	2
1202	2014-07-04	Base Salary	5662.46	EUR	Monthly	1
1202	2014-07-04	Transport Allowance	74.84	EUR	Monthly	2
1202	2025-07-12	Base Salary	7225.50	EUR	Monthly	1
1202	2025-07-12	Transport Allowance	74.84	EUR	Monthly	2
1203	2016-03-01	Base Salary	4587.63	EUR	Monthly	1
1203	2016-03-01	Transport Allowance	47.18	EUR	Monthly	2
1203	2019-03-10	Base Salary	5818.60	EUR	Monthly	1
1203	2019-03-10	Transport Allowance	47.18	EUR	Monthly	2
1203	2025-01-22	Base Salary	7642.28	EUR	Monthly	1
1203	2025-01-22	Transport Allowance	47.18	EUR	Monthly	2
1204	2025-01-27	Base Salary	3825.07	EUR	Monthly	1
1204	2025-01-27	Transport Allowance	76.54	EUR	Monthly	2
1204	2025-03-18	Base Salary	4075.82	EUR	Monthly	1
1204	2025-03-18	Transport Allowance	76.54	EUR	Monthly	2
1205	2019-01-19	Base Salary	4359.76	EUR	Monthly	1
1205	2019-01-19	Transport Allowance	78.88	EUR	Monthly	2
1205	2022-01-06	Base Salary	6116.44	EUR	Monthly	1
1205	2022-01-06	Transport Allowance	78.88	EUR	Monthly	2
1205	2025-09-20	Base Salary	7507.69	EUR	Monthly	1
1205	2025-09-20	Transport Allowance	78.88	EUR	Monthly	2
1206	2023-11-05	Base Salary	3027.57	EUR	Monthly	1
1206	2023-11-05	Transport Allowance	45.03	EUR	Monthly	2
1206	2025-11-22	Base Salary	3027.57	EUR	Monthly	1
1206	2025-11-22	Transport Allowance	45.03	EUR	Monthly	2
1207	2018-10-19	Base Salary	3606.59	EUR	Monthly	1
1207	2018-10-19	Transport Allowance	64.60	EUR	Monthly	2
1207	2021-11-12	Base Salary	5255.99	EUR	Monthly	1
1207	2021-11-12	Transport Allowance	64.60	EUR	Monthly	2
1207	2025-12-15	Base Salary	6987.00	EUR	Monthly	1
1207	2025-12-15	Transport Allowance	64.60	EUR	Monthly	2
1207	2025-12-15	Car Allowance	400.00	EUR	Monthly	3
1208	2023-02-28	Base Salary	4000.71	EUR	Monthly	1
1208	2023-02-28	Transport Allowance	79.25	EUR	Monthly	2
1208	2025-12-02	Base Salary	5260.60	EUR	Monthly	1
1208	2025-12-02	Transport Allowance	79.25	EUR	Monthly	2
1209	2025-02-05	Base Salary	5813.61	EUR	Monthly	1
1209	2025-02-05	Transport Allowance	48.84	EUR	Monthly	2
1209	2025-11-05	Base Salary	5941.63	EUR	Monthly	1
1209	2025-11-05	Transport Allowance	48.84	EUR	Monthly	2
1209	2025-11-05	Car Allowance	400.00	EUR	Monthly	3
1210	2019-03-26	Base Salary	3163.28	EUR	Monthly	1
1210	2019-03-26	Transport Allowance	54.88	EUR	Monthly	2
1210	2022-03-21	Base Salary	4325.99	EUR	Monthly	1
1210	2022-03-21	Transport Allowance	54.88	EUR	Monthly	2
1210	2025-03-31	Base Salary	6421.37	EUR	Monthly	1
1210	2025-03-31	Transport Allowance	54.88	EUR	Monthly	2
1211	2025-09-05	Base Salary	3431.98	EUR	Monthly	1
1211	2025-09-05	Transport Allowance	46.09	EUR	Monthly	2
1212	2012-11-08	Base Salary	4124.63	EUR	Monthly	1
1212	2012-11-08	Transport Allowance	60.11	EUR	Monthly	2
1212	2015-10-23	Base Salary	5492.65	EUR	Monthly	1
1212	2015-10-23	Transport Allowance	60.11	EUR	Monthly	2
1212	2015-10-23	Housing Allowance	329.84	EUR	Monthly	3
1212	2018-11-18	Base Salary	6934.36	EUR	Monthly	1
1212	2018-11-18	Transport Allowance	60.11	EUR	Monthly	2
1212	2018-11-18	Housing Allowance	337.55	EUR	Monthly	3
1212	2025-03-31	Base Salary	7115.17	EUR	Monthly	1
1212	2025-03-31	Transport Allowance	60.11	EUR	Monthly	2
1212	2025-03-31	Housing Allowance	356.59	EUR	Monthly	3
1213	2019-10-07	Base Salary	5300.58	EUR	Monthly	1
1213	2019-10-07	Transport Allowance	59.21	EUR	Monthly	2
1213	2022-09-29	Base Salary	6680.16	EUR	Monthly	1
1213	2022-09-29	Transport Allowance	59.21	EUR	Monthly	2
1213	2022-09-29	Car Allowance	450.00	EUR	Monthly	3
1213	2022-09-29	Housing Allowance	295.74	EUR	Monthly	4
1213	2025-10-07	Base Salary	8421.92	EUR	Monthly	1
1213	2025-10-07	Transport Allowance	59.21	EUR	Monthly	2
1213	2025-10-07	Car Allowance	450.00	EUR	Monthly	3
1213	2025-10-07	Housing Allowance	246.47	EUR	Monthly	4
1213	2025-11-07	Base Salary	9085.82	EUR	Monthly	1
1213	2025-11-07	Transport Allowance	59.21	EUR	Monthly	2
1213	2025-11-07	Car Allowance	450.00	EUR	Monthly	3
1213	2025-11-07	Housing Allowance	238.15	EUR	Monthly	4
1214	2023-05-11	Base Salary	2909.11	EUR	Monthly	1
1214	2023-05-11	Transport Allowance	49.87	EUR	Monthly	2
1214	2025-08-08	Base Salary	2909.11	EUR	Monthly	1
1214	2025-08-08	Transport Allowance	49.87	EUR	Monthly	2
1215	2019-07-13	Base Salary	7924.38	EUR	Monthly	1
1215	2019-07-13	Transport Allowance	64.44	EUR	Monthly	2
1215	2025-12-29	Base Salary	11344.00	EUR	Monthly	1
1215	2025-12-29	Transport Allowance	64.44	EUR	Monthly	2
1215	2025-12-29	Car Allowance	500.00	EUR	Monthly	3
1216	2021-04-27	Base Salary	3684.53	EUR	Monthly	1
1216	2021-04-27	Transport Allowance	74.52	EUR	Monthly	2
1216	2024-05-14	Base Salary	4977.75	EUR	Monthly	1
1216	2024-05-14	Transport Allowance	74.52	EUR	Monthly	2
1216	2025-06-08	Base Salary	5104.23	EUR	Monthly	1
1216	2025-06-08	Transport Allowance	74.52	EUR	Monthly	2
1217	2024-08-25	Base Salary	4308.44	EUR	Monthly	1
1217	2024-08-25	Transport Allowance	57.61	EUR	Monthly	2
1217	2025-12-01	Base Salary	4599.95	EUR	Monthly	1
1217	2025-12-01	Transport Allowance	57.61	EUR	Monthly	2
1218	2016-05-29	Base Salary	3817.63	EUR	Monthly	1
1218	2016-05-29	Transport Allowance	59.60	EUR	Monthly	2
1218	2019-06-02	Base Salary	5385.09	EUR	Monthly	1
1218	2019-06-02	Transport Allowance	59.60	EUR	Monthly	2
1218	2022-05-18	Base Salary	6615.40	EUR	Monthly	1
1218	2022-05-18	Transport Allowance	59.60	EUR	Monthly	2
1218	2025-02-08	Base Salary	6615.40	EUR	Monthly	1
1218	2025-02-08	Transport Allowance	59.60	EUR	Monthly	2
1219	2016-09-19	Base Salary	3919.01	EUR	Monthly	1
1219	2016-09-19	Transport Allowance	55.10	EUR	Monthly	2
1219	2019-10-11	Base Salary	5606.66	EUR	Monthly	1
1219	2019-10-11	Transport Allowance	55.10	EUR	Monthly	2
1219	2022-09-07	Base Salary	6531.00	EUR	Monthly	1
1219	2022-09-07	Transport Allowance	55.10	EUR	Monthly	2
1219	2025-07-24	Base Salary	7054.10	EUR	Monthly	1
1219	2025-07-24	Transport Allowance	55.10	EUR	Monthly	2
1220	2016-01-26	Base Salary	6204.49	EUR	Monthly	1
1220	2016-01-26	Transport Allowance	75.55	EUR	Monthly	2
1220	2025-06-01	Base Salary	7203.43	EUR	Monthly	1
1220	2025-06-01	Transport Allowance	75.55	EUR	Monthly	2
1221	2013-04-26	Base Salary	2983.43	EUR	Monthly	1
1221	2013-04-26	Transport Allowance	49.39	EUR	Monthly	2
1221	2016-04-08	Base Salary	4450.31	EUR	Monthly	1
1221	2016-04-08	Transport Allowance	49.39	EUR	Monthly	2
1221	2019-04-21	Base Salary	5701.70	EUR	Monthly	1
1221	2019-04-21	Transport Allowance	49.39	EUR	Monthly	2
1221	2025-10-15	Base Salary	7877.96	EUR	Monthly	1
1221	2025-10-15	Transport Allowance	49.39	EUR	Monthly	2
1222	2016-08-15	Base Salary	10451.39	EUR	Monthly	1
1222	2016-08-15	Transport Allowance	45.41	EUR	Monthly	2
1222	2016-08-15	Housing Allowance	342.65	EUR	Monthly	3
1222	2026-01-22	Base Salary	11052.67	EUR	Monthly	1
1222	2026-01-22	Transport Allowance	45.41	EUR	Monthly	2
1222	2026-01-22	Housing Allowance	231.68	EUR	Monthly	3
1223	2021-03-10	Base Salary	3118.68	EUR	Monthly	1
1223	2021-03-10	Transport Allowance	75.97	EUR	Monthly	2
1223	2024-03-13	Base Salary	4271.97	EUR	Monthly	1
1223	2024-03-13	Transport Allowance	75.97	EUR	Monthly	2
1223	2026-01-31	Base Salary	4271.97	EUR	Monthly	1
1223	2026-01-31	Transport Allowance	75.97	EUR	Monthly	2
1224	2014-07-26	Base Salary	3556.26	EUR	Monthly	1
1224	2014-07-26	Transport Allowance	68.03	EUR	Monthly	2
1224	2020-08-12	Base Salary	6516.30	EUR	Monthly	1
1224	2020-08-12	Transport Allowance	68.03	EUR	Monthly	2
1224	2023-07-08	Base Salary	7697.03	EUR	Monthly	1
1224	2023-07-08	Transport Allowance	68.03	EUR	Monthly	2
1224	2025-10-17	Base Salary	7697.03	EUR	Monthly	1
1224	2025-10-17	Transport Allowance	68.03	EUR	Monthly	2
1225	2023-10-22	Base Salary	8017.78	EUR	Monthly	1
1225	2023-10-22	Transport Allowance	79.12	EUR	Monthly	2
1225	2025-01-23	Base Salary	8017.78	EUR	Monthly	1
1225	2025-01-23	Transport Allowance	79.12	EUR	Monthly	2
1225	2025-01-23	Car Allowance	350.00	EUR	Monthly	3
1226	2015-08-22	Base Salary	5646.82	EUR	Monthly	1
1226	2015-08-22	Transport Allowance	49.75	EUR	Monthly	2
1226	2018-08-31	Base Salary	6752.43	EUR	Monthly	1
1226	2018-08-31	Transport Allowance	49.75	EUR	Monthly	2
1226	2018-08-31	Car Allowance	400.00	EUR	Monthly	3
1226	2025-10-27	Base Salary	6752.43	EUR	Monthly	1
1226	2025-10-27	Transport Allowance	49.75	EUR	Monthly	2
1226	2025-10-27	Car Allowance	400.00	EUR	Monthly	3
1227	2018-12-07	Base Salary	4841.22	EUR	Monthly	1
1227	2018-12-07	Transport Allowance	49.80	EUR	Monthly	2
1227	2024-11-13	Base Salary	7968.58	EUR	Monthly	1
1227	2024-11-13	Transport Allowance	49.80	EUR	Monthly	2
1227	2024-11-13	Housing Allowance	377.31	EUR	Monthly	3
1227	2026-01-05	Base Salary	7968.58	EUR	Monthly	1
1227	2026-01-05	Transport Allowance	49.80	EUR	Monthly	2
1227	2026-01-05	Housing Allowance	389.23	EUR	Monthly	3
1228	2019-12-05	Base Salary	2876.50	EUR	Monthly	1
1228	2019-12-05	Transport Allowance	76.28	EUR	Monthly	2
1228	2022-11-10	Base Salary	3755.51	EUR	Monthly	1
1228	2022-11-10	Transport Allowance	76.28	EUR	Monthly	2
1228	2025-11-26	Base Salary	5182.61	EUR	Monthly	1
1228	2025-11-26	Transport Allowance	76.28	EUR	Monthly	2
1228	2025-11-26	Housing Allowance	352.99	EUR	Monthly	3
1228	2026-02-19	Base Salary	5182.61	EUR	Monthly	1
1228	2026-02-19	Transport Allowance	76.28	EUR	Monthly	2
1228	2026-02-19	Housing Allowance	404.67	EUR	Monthly	3
1229	2015-07-09	Base Salary	5852.12	EUR	Monthly	1
1229	2015-07-09	Transport Allowance	66.81	EUR	Monthly	2
1229	2018-07-23	Base Salary	7961.71	EUR	Monthly	1
1229	2018-07-23	Transport Allowance	66.81	EUR	Monthly	2
1229	2021-08-01	Base Salary	10434.06	EUR	Monthly	1
1229	2021-08-01	Transport Allowance	66.81	EUR	Monthly	2
1229	2021-08-01	Housing Allowance	299.97	EUR	Monthly	3
1229	2024-06-26	Base Salary	13141.86	EUR	Monthly	1
1229	2024-06-26	Transport Allowance	66.81	EUR	Monthly	2
1229	2024-06-26	Housing Allowance	293.31	EUR	Monthly	3
1229	2025-10-04	Base Salary	13292.78	EUR	Monthly	1
1229	2025-10-04	Transport Allowance	66.81	EUR	Monthly	2
1229	2025-10-04	Housing Allowance	380.42	EUR	Monthly	3
1230	2025-02-04	Base Salary	6276.59	EUR	Monthly	1
1230	2025-02-04	Transport Allowance	58.47	EUR	Monthly	2
1230	2025-02-04	Housing Allowance	249.66	EUR	Monthly	3
1230	2025-07-04	Base Salary	6784.71	EUR	Monthly	1
1230	2025-07-04	Transport Allowance	58.47	EUR	Monthly	2
1230	2025-07-04	Housing Allowance	293.45	EUR	Monthly	3
1231	2012-05-01	Base Salary	10621.19	EUR	Monthly	1
1231	2012-05-01	Transport Allowance	45.26	EUR	Monthly	2
1231	2025-07-15	Base Salary	10621.19	EUR	Monthly	1
1231	2025-07-15	Transport Allowance	45.26	EUR	Monthly	2
1231	2025-07-15	Car Allowance	450.00	EUR	Monthly	3
1232	2012-02-06	Base Salary	3625.29	EUR	Monthly	1
1232	2012-02-06	Transport Allowance	62.44	EUR	Monthly	2
1232	2026-01-17	Base Salary	5304.94	EUR	Monthly	1
1232	2026-01-17	Transport Allowance	62.44	EUR	Monthly	2
1233	2024-10-25	Base Salary	4062.72	EUR	Monthly	1
1233	2024-10-25	Transport Allowance	70.58	EUR	Monthly	2
1233	2025-04-02	Base Salary	4119.63	EUR	Monthly	1
1233	2025-04-02	Transport Allowance	70.58	EUR	Monthly	2
1234	2021-02-26	Base Salary	3173.66	EUR	Monthly	1
1234	2021-02-26	Transport Allowance	69.92	EUR	Monthly	2
1234	2024-03-14	Base Salary	4293.56	EUR	Monthly	1
1234	2024-03-14	Transport Allowance	69.92	EUR	Monthly	2
1234	2025-07-28	Base Salary	4293.56	EUR	Monthly	1
1234	2025-07-28	Transport Allowance	69.92	EUR	Monthly	2
1235	2015-09-25	Base Salary	8143.80	EUR	Monthly	1
1235	2015-09-25	Transport Allowance	54.42	EUR	Monthly	2
1235	2018-10-08	Base Salary	10087.09	EUR	Monthly	1
1235	2018-10-08	Transport Allowance	54.42	EUR	Monthly	2
1235	2018-10-08	Car Allowance	400.00	EUR	Monthly	3
1235	2025-07-21	Base Salary	10087.09	EUR	Monthly	1
1235	2025-07-21	Transport Allowance	54.42	EUR	Monthly	2
1235	2025-07-21	Car Allowance	400.00	EUR	Monthly	3
1236	2020-04-05	Base Salary	4248.15	EUR	Monthly	1
1236	2020-04-05	Transport Allowance	77.43	EUR	Monthly	2
1236	2025-03-31	Base Salary	6231.26	EUR	Monthly	1
1236	2025-03-31	Transport Allowance	77.43	EUR	Monthly	2
1236	2025-03-31	Car Allowance	450.00	EUR	Monthly	3
1237	2017-09-19	Base Salary	2991.08	EUR	Monthly	1
1237	2017-09-19	Transport Allowance	65.17	EUR	Monthly	2
1237	2020-09-19	Base Salary	4741.28	EUR	Monthly	1
1237	2020-09-19	Transport Allowance	65.17	EUR	Monthly	2
1237	2023-10-15	Base Salary	6043.59	EUR	Monthly	1
1237	2023-10-15	Transport Allowance	65.17	EUR	Monthly	2
1237	2023-10-15	Car Allowance	500.00	EUR	Monthly	3
1237	2025-05-09	Base Salary	6173.66	EUR	Monthly	1
1237	2025-05-09	Transport Allowance	65.17	EUR	Monthly	2
1237	2025-05-09	Car Allowance	500.00	EUR	Monthly	3
1238	2014-10-22	Base Salary	3941.12	EUR	Monthly	1
1238	2014-10-22	Transport Allowance	46.17	EUR	Monthly	2
1238	2017-10-19	Base Salary	5653.23	EUR	Monthly	1
1238	2017-10-19	Transport Allowance	46.17	EUR	Monthly	2
1238	2020-10-09	Base Salary	8140.18	EUR	Monthly	1
1238	2020-10-09	Transport Allowance	46.17	EUR	Monthly	2
1238	2023-10-07	Base Salary	9860.53	EUR	Monthly	1
1238	2023-10-07	Transport Allowance	46.17	EUR	Monthly	2
1238	2025-05-17	Base Salary	9860.53	EUR	Monthly	1
1238	2025-05-17	Transport Allowance	46.17	EUR	Monthly	2
1239	2022-08-02	Base Salary	3463.43	EUR	Monthly	1
1239	2022-08-02	Transport Allowance	46.33	EUR	Monthly	2
1239	2025-08-15	Base Salary	4781.66	EUR	Monthly	1
1239	2025-08-15	Transport Allowance	46.33	EUR	Monthly	2
1239	2025-11-05	Base Salary	4871.92	EUR	Monthly	1
1239	2025-11-05	Transport Allowance	46.33	EUR	Monthly	2
1240	2022-01-25	Base Salary	5275.17	EUR	Monthly	1
1240	2022-01-25	Transport Allowance	61.91	EUR	Monthly	2
1240	2024-12-29	Base Salary	7971.24	EUR	Monthly	1
1240	2024-12-29	Transport Allowance	61.91	EUR	Monthly	2
1240	2024-12-29	Car Allowance	350.00	EUR	Monthly	3
1240	2024-12-29	Housing Allowance	281.09	EUR	Monthly	4
1240	2025-10-05	Base Salary	8040.96	EUR	Monthly	1
1240	2025-10-05	Transport Allowance	61.91	EUR	Monthly	2
1240	2025-10-05	Car Allowance	350.00	EUR	Monthly	3
1240	2025-10-05	Housing Allowance	327.66	EUR	Monthly	4
1241	2012-06-17	Base Salary	3760.16	EUR	Monthly	1
1241	2012-06-17	Transport Allowance	78.66	EUR	Monthly	2
1241	2015-06-18	Base Salary	5146.77	EUR	Monthly	1
1241	2015-06-18	Transport Allowance	78.66	EUR	Monthly	2
1241	2025-07-20	Base Salary	8705.10	EUR	Monthly	1
1241	2025-07-20	Transport Allowance	78.66	EUR	Monthly	2
1242	2019-04-17	Base Salary	4260.98	EUR	Monthly	1
1242	2019-04-17	Transport Allowance	47.80	EUR	Monthly	2
1242	2022-03-30	Base Salary	6272.95	EUR	Monthly	1
1242	2022-03-30	Transport Allowance	47.80	EUR	Monthly	2
1242	2025-05-03	Base Salary	6860.30	EUR	Monthly	1
1242	2025-05-03	Transport Allowance	47.80	EUR	Monthly	2
1242	2025-07-24	Base Salary	6913.65	EUR	Monthly	1
1242	2025-07-24	Transport Allowance	47.80	EUR	Monthly	2
1243	2015-02-03	Base Salary	3699.09	EUR	Monthly	1
1243	2015-02-03	Transport Allowance	70.56	EUR	Monthly	2
1243	2018-01-22	Base Salary	5646.05	EUR	Monthly	1
1243	2018-01-22	Transport Allowance	70.56	EUR	Monthly	2
1243	2021-02-09	Base Salary	7874.78	EUR	Monthly	1
1243	2021-02-09	Transport Allowance	70.56	EUR	Monthly	2
1243	2024-02-19	Base Salary	9212.86	EUR	Monthly	1
1243	2024-02-19	Transport Allowance	70.56	EUR	Monthly	2
1243	2025-09-11	Base Salary	10174.85	EUR	Monthly	1
1243	2025-09-11	Transport Allowance	70.56	EUR	Monthly	2
1244	2018-06-13	Base Salary	7068.29	EUR	Monthly	1
1244	2018-06-13	Transport Allowance	63.42	EUR	Monthly	2
1244	2025-06-27	Base Salary	8593.49	EUR	Monthly	1
1244	2025-06-27	Transport Allowance	63.42	EUR	Monthly	2
1245	2019-09-26	Base Salary	2868.92	EUR	Monthly	1
1245	2019-09-26	Transport Allowance	75.08	EUR	Monthly	2
1245	2022-10-18	Base Salary	3918.26	EUR	Monthly	1
1245	2022-10-18	Transport Allowance	75.08	EUR	Monthly	2
1245	2025-08-27	Base Salary	5256.30	EUR	Monthly	1
1245	2025-08-27	Transport Allowance	75.08	EUR	Monthly	2
1245	2025-08-27	Housing Allowance	365.13	EUR	Monthly	3
1245	2025-09-14	Base Salary	5666.91	EUR	Monthly	1
1245	2025-09-14	Transport Allowance	75.08	EUR	Monthly	2
1245	2025-09-14	Housing Allowance	261.47	EUR	Monthly	3
1246	2024-12-13	Base Salary	3419.19	EUR	Monthly	1
1246	2024-12-13	Transport Allowance	63.09	EUR	Monthly	2
1246	2025-06-16	Base Salary	3419.19	EUR	Monthly	1
1246	2025-06-16	Transport Allowance	63.09	EUR	Monthly	2
1247	2024-10-16	Base Salary	2658.84	EUR	Monthly	1
1247	2024-10-16	Transport Allowance	63.32	EUR	Monthly	2
1247	2025-11-14	Base Salary	2809.57	EUR	Monthly	1
1247	2025-11-14	Transport Allowance	63.32	EUR	Monthly	2
1248	2013-05-23	Base Salary	4975.12	EUR	Monthly	1
1248	2013-05-23	Transport Allowance	66.35	EUR	Monthly	2
1248	2016-04-27	Base Salary	6705.58	EUR	Monthly	1
1248	2016-04-27	Transport Allowance	66.35	EUR	Monthly	2
1248	2016-04-27	Car Allowance	500.00	EUR	Monthly	3
1248	2019-05-17	Base Salary	7928.24	EUR	Monthly	1
1248	2019-05-17	Transport Allowance	66.35	EUR	Monthly	2
1248	2019-05-17	Car Allowance	500.00	EUR	Monthly	3
1248	2026-01-11	Base Salary	7928.24	EUR	Monthly	1
1248	2026-01-11	Transport Allowance	66.35	EUR	Monthly	2
1248	2026-01-11	Car Allowance	500.00	EUR	Monthly	3
1249	2024-09-28	Base Salary	3463.32	EUR	Monthly	1
1249	2024-09-28	Transport Allowance	53.58	EUR	Monthly	2
1249	2025-02-19	Base Salary	3518.02	EUR	Monthly	1
1249	2025-02-19	Transport Allowance	53.58	EUR	Monthly	2
1250	2017-12-14	Base Salary	5578.18	EUR	Monthly	1
1250	2017-12-14	Transport Allowance	67.07	EUR	Monthly	2
1250	2017-12-14	Housing Allowance	346.02	EUR	Monthly	3
1250	2020-12-04	Base Salary	7183.69	EUR	Monthly	1
1250	2020-12-04	Transport Allowance	67.07	EUR	Monthly	2
1250	2020-12-04	Housing Allowance	347.12	EUR	Monthly	3
1250	2025-11-27	Base Salary	7324.05	EUR	Monthly	1
1250	2025-11-27	Transport Allowance	67.07	EUR	Monthly	2
1250	2025-11-27	Housing Allowance	350.50	EUR	Monthly	3
\.


--
-- TOC entry 5124 (class 0 OID 19765)
-- Dependencies: 224
-- Data for Name: performance_management; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.performance_management (user_id, formcontentid, reviewdate, rating, potential, lastpromotiondate, competencyscore, objectivecompletion, istopperformer) FROM stdin;
1001	FORM-2025	2025-12-15	1.74	Low	\N	1.28	48.23	f
1002	FORM-2022	2022-12-15	4.23	High	2024-10-18	3.49	92.65	f
1002	FORM-2023	2023-12-15	3.74	Medium	2024-10-18	4.11	69.24	f
1002	FORM-2024	2024-12-15	3.95	Medium	2024-10-18	3.98	66.57	f
1002	FORM-2025	2025-12-15	3.91	Medium	2024-10-18	4.11	72.46	f
1003	FORM-2022	2022-12-15	3.66	Medium	2019-09-28	3.82	73.33	f
1003	FORM-2023	2023-12-15	3.97	Medium	2019-09-28	4.13	89.09	f
1003	FORM-2024	2024-12-15	3.53	Medium	2019-09-28	3.79	69.74	f
1003	FORM-2025	2025-12-15	3.74	Medium	2019-09-28	3.83	77.45	f
1004	FORM-2022	2022-12-15	4.22	High	2026-01-08	4.14	82.47	f
1004	FORM-2023	2023-12-15	2.95	Medium	2026-01-08	3.01	51.96	f
1004	FORM-2024	2024-12-15	3.46	Medium	2026-01-08	3.36	73.13	f
1004	FORM-2025	2025-12-15	4.14	High	2026-01-08	4.26	81.72	f
1005	FORM-2022	2022-12-15	3.99	Medium	2026-01-08	3.77	89.03	f
1005	FORM-2023	2023-12-15	4.66	High	2026-01-08	4.51	85.75	t
1005	FORM-2024	2024-12-15	3.27	Medium	2026-01-08	3.04	59.81	f
1005	FORM-2025	2025-12-15	4.00	High	2026-01-08	4.05	85.09	f
1006	FORM-2022	2022-12-15	3.94	Medium	2022-08-05	3.99	77.00	f
1006	FORM-2023	2023-12-15	4.63	High	2022-08-05	5.00	87.85	t
1006	FORM-2024	2024-12-15	4.00	High	2022-08-05	3.94	78.42	f
1006	FORM-2025	2025-12-15	3.57	Medium	2022-08-05	3.28	69.76	f
1007	FORM-2022	2022-12-15	3.87	Medium	2026-01-08	4.21	83.07	f
1007	FORM-2023	2023-12-15	3.47	Medium	2026-01-08	3.81	68.93	f
1007	FORM-2024	2024-12-15	3.34	Medium	2026-01-08	3.01	73.92	f
1007	FORM-2025	2025-12-15	3.91	Medium	2026-01-08	3.67	70.66	f
1008	FORM-2022	2022-12-15	4.85	High	2024-05-20	4.91	90.54	t
1008	FORM-2023	2023-12-15	3.70	Medium	2024-05-20	3.84	80.45	f
1008	FORM-2024	2024-12-15	4.25	High	2024-05-20	4.65	89.36	f
1008	FORM-2025	2025-12-15	4.08	High	2024-05-20	4.39	78.60	f
1009	FORM-2022	2022-12-15	2.21	Low	\N	1.86	48.79	f
1009	FORM-2023	2023-12-15	2.15	Low	\N	2.21	43.62	f
1009	FORM-2024	2024-12-15	2.33	Low	\N	2.23	52.54	f
1009	FORM-2025	2025-12-15	3.31	Medium	\N	3.21	61.52	f
1012	FORM-2022	2022-12-15	4.81	High	2026-01-08	4.83	92.85	t
1012	FORM-2023	2023-12-15	3.68	Medium	2026-01-08	3.89	73.08	f
1012	FORM-2024	2024-12-15	3.90	Medium	2026-01-08	3.58	73.33	f
1012	FORM-2025	2025-12-15	4.41	High	2026-01-08	4.51	94.25	f
1013	FORM-2022	2022-12-15	2.55	Medium	2020-08-24	2.40	52.86	f
1013	FORM-2023	2023-12-15	3.74	Medium	2020-08-24	4.26	76.01	f
1013	FORM-2024	2024-12-15	2.95	Medium	2020-08-24	2.76	50.96	f
1013	FORM-2025	2025-12-15	4.07	High	2020-08-24	4.03	77.55	f
1014	FORM-2022	2022-12-15	3.07	Medium	\N	3.41	59.49	f
1014	FORM-2023	2023-12-15	2.24	Low	\N	2.31	34.65	f
1014	FORM-2024	2024-12-15	2.75	Medium	\N	2.92	56.11	f
1014	FORM-2025	2025-12-15	2.86	Medium	\N	2.86	58.24	f
1015	FORM-2022	2022-12-15	4.54	High	2026-01-08	4.57	100.00	t
1015	FORM-2023	2023-12-15	4.28	High	2026-01-08	4.21	85.35	f
1015	FORM-2024	2024-12-15	3.51	Medium	2026-01-08	3.81	86.86	f
1015	FORM-2025	2025-12-15	3.72	Medium	2026-01-08	3.79	77.32	f
1016	FORM-2022	2022-12-15	3.90	Medium	2026-01-08	3.86	81.82	f
1016	FORM-2023	2023-12-15	3.12	Medium	2026-01-08	2.90	63.82	f
1016	FORM-2024	2024-12-15	3.88	Medium	2026-01-08	3.93	81.11	f
1016	FORM-2025	2025-12-15	4.45	High	2026-01-08	4.19	84.92	f
1018	FORM-2022	2022-12-15	3.94	Medium	2025-10-25	3.96	79.93	f
1018	FORM-2023	2023-12-15	4.01	High	2025-10-25	3.55	89.15	f
1018	FORM-2024	2024-12-15	3.50	Medium	2025-10-25	3.18	77.28	f
1018	FORM-2025	2025-12-15	4.30	High	2025-10-25	4.68	84.49	f
1020	FORM-2022	2022-12-15	4.20	High	2025-12-26	4.33	75.79	f
1020	FORM-2023	2023-12-15	5.00	High	2025-12-26	4.75	100.00	t
1020	FORM-2024	2024-12-15	3.84	Medium	2025-12-26	3.91	75.27	f
1020	FORM-2025	2025-12-15	4.55	High	2025-12-26	5.00	92.09	t
1021	FORM-2022	2022-12-15	3.54	Medium	2026-01-08	3.37	74.82	f
1021	FORM-2023	2023-12-15	2.74	Medium	2026-01-08	2.34	54.86	f
1021	FORM-2024	2024-12-15	4.00	High	2026-01-08	3.88	77.41	f
1021	FORM-2025	2025-12-15	2.99	Medium	2026-01-08	2.89	58.87	f
1022	FORM-2024	2024-12-15	2.65	Medium	\N	2.79	41.31	f
1022	FORM-2025	2025-12-15	3.28	Medium	\N	2.75	68.70	f
1023	FORM-2023	2023-12-15	3.17	Medium	2026-01-08	3.42	66.71	f
1023	FORM-2024	2024-12-15	3.31	Medium	2026-01-08	3.23	56.21	f
1023	FORM-2025	2025-12-15	3.35	Medium	2026-01-08	3.17	61.34	f
1024	FORM-2022	2022-12-15	3.29	Medium	2025-12-03	3.29	63.27	f
1024	FORM-2023	2023-12-15	4.29	High	2025-12-03	4.15	76.86	f
1024	FORM-2024	2024-12-15	3.45	Medium	2025-12-03	3.46	58.01	f
1024	FORM-2025	2025-12-15	4.51	High	2025-12-03	4.45	89.37	t
1026	FORM-2022	2022-12-15	2.56	Medium	\N	2.73	55.13	f
1026	FORM-2023	2023-12-15	2.12	Low	\N	1.94	54.20	f
1026	FORM-2024	2024-12-15	1.45	Low	\N	1.20	23.66	f
1026	FORM-2025	2025-12-15	2.95	Medium	\N	3.02	60.88	f
1030	FORM-2022	2022-12-15	2.96	Medium	2026-01-08	3.04	53.40	f
1030	FORM-2023	2023-12-15	3.12	Medium	2026-01-08	2.93	58.04	f
1030	FORM-2024	2024-12-15	2.90	Medium	2026-01-08	2.95	59.76	f
1030	FORM-2025	2025-12-15	2.99	Medium	2026-01-08	2.87	62.34	f
1031	FORM-2022	2022-12-15	2.57	Medium	\N	2.93	49.82	f
1031	FORM-2023	2023-12-15	2.66	Medium	\N	2.82	47.19	f
1031	FORM-2024	2024-12-15	1.96	Low	\N	1.62	41.65	f
1031	FORM-2025	2025-12-15	2.40	Low	\N	2.46	48.73	f
1032	FORM-2022	2022-12-15	3.05	Medium	2022-11-12	3.21	58.57	f
1032	FORM-2023	2023-12-15	3.32	Medium	2022-11-12	3.47	58.06	f
1032	FORM-2024	2024-12-15	2.83	Medium	2022-11-12	3.22	78.13	f
1032	FORM-2025	2025-12-15	2.93	Medium	2022-11-12	2.94	48.76	f
1033	FORM-2023	2023-12-15	3.46	Medium	2026-01-08	3.44	65.79	f
1033	FORM-2024	2024-12-15	4.28	High	2026-01-08	4.33	79.63	f
1033	FORM-2025	2025-12-15	2.85	Medium	2026-01-08	3.03	53.20	f
1034	FORM-2024	2024-12-15	2.03	Low	\N	1.61	39.79	f
1034	FORM-2025	2025-12-15	2.80	Medium	\N	3.00	57.44	f
1035	FORM-2025	2025-12-15	4.22	High	2026-01-08	3.92	85.56	f
1037	FORM-2022	2022-12-15	3.59	Medium	2024-10-28	3.18	70.65	f
1037	FORM-2023	2023-12-15	2.85	Medium	2024-10-28	2.91	51.98	f
1037	FORM-2024	2024-12-15	3.73	Medium	2024-10-28	4.13	73.28	f
1037	FORM-2025	2025-12-15	3.08	Medium	2024-10-28	2.78	63.97	f
1038	FORM-2022	2022-12-15	3.39	Medium	2024-08-04	3.62	77.75	f
1038	FORM-2023	2023-12-15	4.71	High	2024-08-04	5.00	94.87	t
1038	FORM-2024	2024-12-15	4.08	High	2024-08-04	3.88	73.62	f
1038	FORM-2025	2025-12-15	4.22	High	2024-08-04	3.86	90.34	f
1039	FORM-2022	2022-12-15	3.42	Medium	2026-01-08	3.37	78.81	f
1039	FORM-2023	2023-12-15	3.98	Medium	2026-01-08	4.11	77.97	f
1039	FORM-2024	2024-12-15	4.28	High	2026-01-08	4.21	80.01	f
1039	FORM-2025	2025-12-15	3.36	Medium	2026-01-08	2.97	59.65	f
1042	FORM-2022	2022-12-15	4.19	High	2023-05-17	4.17	78.06	f
1042	FORM-2023	2023-12-15	4.24	High	2023-05-17	4.29	87.46	f
1042	FORM-2024	2024-12-15	3.35	Medium	2023-05-17	3.23	69.09	f
1042	FORM-2025	2025-12-15	3.71	Medium	2023-05-17	3.96	78.84	f
1043	FORM-2022	2022-12-15	4.60	High	2026-01-08	4.68	88.15	t
1043	FORM-2023	2023-12-15	3.87	Medium	2026-01-08	4.45	83.92	f
1043	FORM-2024	2024-12-15	3.77	Medium	2026-01-08	3.95	74.17	f
1043	FORM-2025	2025-12-15	3.69	Medium	2026-01-08	3.97	76.36	f
1044	FORM-2025	2025-12-15	3.42	Medium	2026-01-08	3.86	65.43	f
1046	FORM-2022	2022-12-15	4.01	High	2024-09-24	4.25	84.97	f
1046	FORM-2023	2023-12-15	3.66	Medium	2024-09-24	3.67	84.75	f
1046	FORM-2024	2024-12-15	3.57	Medium	2024-09-24	3.69	74.37	f
1046	FORM-2025	2025-12-15	3.13	Medium	2024-09-24	3.29	54.54	f
1047	FORM-2022	2022-12-15	3.06	Medium	2023-05-24	3.37	58.22	f
1047	FORM-2023	2023-12-15	2.19	Low	2023-05-24	2.18	43.68	f
1047	FORM-2024	2024-12-15	3.01	Medium	2023-05-24	3.07	61.90	f
1047	FORM-2025	2025-12-15	2.22	Low	2023-05-24	2.49	31.40	f
1048	FORM-2022	2022-12-15	3.22	Medium	2018-10-19	3.42	59.82	f
1048	FORM-2023	2023-12-15	2.67	Medium	2018-10-19	2.48	50.48	f
1048	FORM-2024	2024-12-15	4.40	High	2018-10-19	4.03	90.53	f
1048	FORM-2025	2025-12-15	3.30	Medium	2018-10-19	3.10	57.71	f
1049	FORM-2023	2023-12-15	2.36	Low	2025-09-03	2.45	51.25	f
1049	FORM-2024	2024-12-15	3.61	Medium	2025-09-03	3.37	59.47	f
1049	FORM-2025	2025-12-15	3.24	Medium	2025-09-03	3.37	71.91	f
1050	FORM-2022	2022-12-15	2.90	Medium	2026-01-08	3.27	58.78	f
1050	FORM-2023	2023-12-15	4.86	High	2026-01-08	4.81	100.00	t
1050	FORM-2024	2024-12-15	3.56	Medium	2026-01-08	4.10	68.12	f
1050	FORM-2025	2025-12-15	3.09	Medium	2026-01-08	3.15	68.65	f
1051	FORM-2022	2022-12-15	4.03	High	2024-07-18	4.01	82.99	f
1051	FORM-2023	2023-12-15	3.39	Medium	2024-07-18	3.73	74.08	f
1051	FORM-2024	2024-12-15	3.15	Medium	2024-07-18	3.39	62.88	f
1051	FORM-2025	2025-12-15	3.99	Medium	2024-07-18	3.90	80.35	f
1052	FORM-2022	2022-12-15	3.12	Medium	2025-12-18	2.73	55.11	f
1052	FORM-2023	2023-12-15	3.96	Medium	2025-12-18	4.11	74.45	f
1052	FORM-2024	2024-12-15	3.65	Medium	2025-12-18	3.66	77.63	f
1052	FORM-2025	2025-12-15	3.18	Medium	2025-12-18	3.18	56.69	f
1053	FORM-2022	2022-12-15	4.42	High	2021-03-12	4.55	89.11	f
1053	FORM-2023	2023-12-15	5.00	High	2021-03-12	5.00	100.00	t
1053	FORM-2024	2024-12-15	4.02	High	2021-03-12	3.89	83.14	f
1053	FORM-2025	2025-12-15	3.88	Medium	2021-03-12	3.80	84.74	f
1054	FORM-2022	2022-12-15	3.69	Medium	2022-12-12	3.75	74.57	f
1054	FORM-2023	2023-12-15	3.10	Medium	2022-12-12	3.23	66.64	f
1054	FORM-2024	2024-12-15	3.88	Medium	2022-12-12	3.94	75.70	f
1054	FORM-2025	2025-12-15	3.54	Medium	2022-12-12	3.38	60.01	f
1055	FORM-2023	2023-12-15	3.67	Medium	2026-01-08	3.34	70.72	f
1055	FORM-2024	2024-12-15	2.36	Low	2026-01-08	2.19	50.47	f
1055	FORM-2025	2025-12-15	3.45	Medium	2026-01-08	3.46	70.44	f
1056	FORM-2022	2022-12-15	2.55	Medium	2022-12-28	2.77	48.49	f
1056	FORM-2023	2023-12-15	3.42	Medium	2022-12-28	3.53	52.47	f
1056	FORM-2024	2024-12-15	4.11	High	2022-12-28	4.03	85.55	f
1056	FORM-2025	2025-12-15	3.23	Medium	2022-12-28	3.08	72.51	f
1057	FORM-2022	2022-12-15	2.35	Low	2022-09-20	2.42	43.82	f
1057	FORM-2023	2023-12-15	3.21	Medium	2022-09-20	3.43	68.36	f
1057	FORM-2024	2024-12-15	3.23	Medium	2022-09-20	3.08	63.12	f
1057	FORM-2025	2025-12-15	3.12	Medium	2022-09-20	3.42	65.22	f
1058	FORM-2024	2024-12-15	2.86	Medium	2026-01-08	2.91	62.69	f
1058	FORM-2025	2025-12-15	3.18	Medium	2026-01-08	3.40	61.19	f
1059	FORM-2025	2025-12-15	4.30	High	2026-01-08	4.21	86.57	f
1060	FORM-2022	2022-12-15	2.79	Medium	\N	2.46	54.28	f
1060	FORM-2023	2023-12-15	2.64	Medium	\N	2.68	57.78	f
1060	FORM-2024	2024-12-15	1.34	Low	\N	0.92	32.77	f
1060	FORM-2025	2025-12-15	2.87	Medium	\N	3.36	56.70	f
1061	FORM-2022	2022-12-15	4.45	High	2026-01-08	5.00	75.29	f
1061	FORM-2023	2023-12-15	3.02	Medium	2026-01-08	2.90	51.88	f
1061	FORM-2024	2024-12-15	4.61	High	2026-01-08	4.54	88.00	t
1061	FORM-2025	2025-12-15	4.47	High	2026-01-08	4.63	85.90	f
1062	FORM-2022	2022-12-15	3.29	Medium	2021-05-12	3.06	61.61	f
1062	FORM-2023	2023-12-15	3.54	Medium	2021-05-12	3.33	67.80	f
1062	FORM-2024	2024-12-15	2.72	Medium	2021-05-12	2.58	39.13	f
1062	FORM-2025	2025-12-15	2.17	Low	2021-05-12	2.21	51.66	f
1063	FORM-2025	2025-12-15	4.19	High	2026-01-08	4.06	83.03	f
1064	FORM-2022	2022-12-15	2.56	Medium	2023-07-07	2.50	49.76	f
1064	FORM-2023	2023-12-15	3.10	Medium	2023-07-07	3.25	64.35	f
1064	FORM-2024	2024-12-15	3.68	Medium	2023-07-07	4.23	76.81	f
1064	FORM-2025	2025-12-15	2.41	Low	2023-07-07	2.06	47.84	f
1065	FORM-2022	2022-12-15	3.40	Medium	2022-11-26	3.34	76.48	f
1065	FORM-2023	2023-12-15	3.89	Medium	2022-11-26	3.59	86.39	f
1065	FORM-2024	2024-12-15	3.75	Medium	2022-11-26	3.74	76.28	f
1065	FORM-2025	2025-12-15	4.11	High	2022-11-26	3.93	82.56	f
1066	FORM-2022	2022-12-15	4.47	High	2025-01-27	4.78	84.49	f
1066	FORM-2023	2023-12-15	3.86	Medium	2025-01-27	4.24	75.64	f
1066	FORM-2024	2024-12-15	3.18	Medium	2025-01-27	3.02	67.18	f
1066	FORM-2025	2025-12-15	3.80	Medium	2025-01-27	3.81	77.56	f
1067	FORM-2022	2022-12-15	3.26	Medium	2026-01-08	3.39	73.16	f
1067	FORM-2023	2023-12-15	3.61	Medium	2026-01-08	3.74	78.94	f
1067	FORM-2024	2024-12-15	3.77	Medium	2026-01-08	4.05	63.27	f
1067	FORM-2025	2025-12-15	3.42	Medium	2026-01-08	3.52	67.59	f
1068	FORM-2025	2025-12-15	2.52	Medium	2026-01-08	2.49	45.97	f
1069	FORM-2025	2025-12-15	2.67	Medium	\N	2.84	51.96	f
1070	FORM-2022	2022-12-15	3.48	Medium	2017-02-20	3.35	66.00	f
1070	FORM-2023	2023-12-15	2.99	Medium	2017-02-20	2.89	65.76	f
1070	FORM-2024	2024-12-15	2.86	Medium	2017-02-20	2.99	62.83	f
1070	FORM-2025	2025-12-15	2.14	Low	2017-02-20	2.13	43.52	f
1071	FORM-2022	2022-12-15	2.93	Medium	2026-01-08	2.94	57.44	f
1071	FORM-2023	2023-12-15	3.13	Medium	2026-01-08	3.46	63.35	f
1071	FORM-2024	2024-12-15	2.72	Medium	2026-01-08	2.60	52.45	f
1071	FORM-2025	2025-12-15	3.79	Medium	2026-01-08	3.60	69.37	f
1072	FORM-2022	2022-12-15	3.97	Medium	2025-07-05	3.73	85.19	f
1072	FORM-2023	2023-12-15	4.09	High	2025-07-05	4.15	78.39	f
1072	FORM-2024	2024-12-15	3.91	Medium	2025-07-05	3.92	79.10	f
1072	FORM-2025	2025-12-15	3.05	Medium	2025-07-05	3.05	47.34	f
1073	FORM-2022	2022-12-15	3.01	Medium	2022-03-14	3.63	54.36	f
1073	FORM-2023	2023-12-15	2.54	Medium	2022-03-14	2.75	45.75	f
1073	FORM-2024	2024-12-15	2.43	Low	2022-03-14	2.37	49.52	f
1073	FORM-2025	2025-12-15	3.38	Medium	2022-03-14	3.26	63.99	f
1074	FORM-2025	2025-12-15	2.37	Low	\N	2.19	49.19	f
1075	FORM-2022	2022-12-15	3.63	Medium	2020-04-20	3.42	65.66	f
1075	FORM-2023	2023-12-15	2.92	Medium	2020-04-20	2.77	49.82	f
1075	FORM-2024	2024-12-15	2.28	Low	2020-04-20	1.82	45.20	f
1075	FORM-2025	2025-12-15	2.58	Medium	2020-04-20	3.03	53.96	f
1076	FORM-2023	2023-12-15	2.44	Low	2026-01-21	2.16	46.00	f
1076	FORM-2024	2024-12-15	2.27	Low	2026-01-21	2.25	52.00	f
1076	FORM-2025	2025-12-15	2.79	Medium	2026-01-21	2.62	43.97	f
1077	FORM-2022	2022-12-15	3.11	Medium	2026-01-08	3.13	61.41	f
1077	FORM-2023	2023-12-15	3.94	Medium	2026-01-08	3.58	84.04	f
1077	FORM-2024	2024-12-15	3.60	Medium	2026-01-08	3.14	65.35	f
1077	FORM-2025	2025-12-15	3.53	Medium	2026-01-08	3.51	60.61	f
1078	FORM-2022	2022-12-15	4.29	High	2025-03-20	4.29	90.89	f
1078	FORM-2023	2023-12-15	4.57	High	2025-03-20	4.50	87.59	t
1078	FORM-2024	2024-12-15	4.14	High	2025-03-20	3.71	89.27	f
1078	FORM-2025	2025-12-15	3.82	Medium	2025-03-20	3.71	69.59	f
1079	FORM-2022	2022-12-15	3.20	Medium	2026-01-08	3.12	66.76	f
1079	FORM-2023	2023-12-15	3.84	Medium	2026-01-08	3.26	72.67	f
1079	FORM-2024	2024-12-15	4.11	High	2026-01-08	4.57	81.30	f
1079	FORM-2025	2025-12-15	4.04	High	2026-01-08	4.04	78.38	f
1080	FORM-2022	2022-12-15	2.37	Low	2024-06-03	2.14	39.35	f
1080	FORM-2023	2023-12-15	3.18	Medium	2024-06-03	3.39	62.47	f
1080	FORM-2024	2024-12-15	2.63	Medium	2024-06-03	2.88	65.90	f
1080	FORM-2025	2025-12-15	2.08	Low	2024-06-03	2.22	42.42	f
1081	FORM-2022	2022-12-15	4.01	High	2024-09-30	4.18	89.43	f
1081	FORM-2023	2023-12-15	3.79	Medium	2024-09-30	4.33	68.72	f
1081	FORM-2024	2024-12-15	4.23	High	2024-09-30	3.87	76.09	f
1081	FORM-2025	2025-12-15	4.06	High	2024-09-30	4.24	77.73	f
1082	FORM-2024	2024-12-15	3.23	Medium	2026-01-08	3.05	71.27	f
1082	FORM-2025	2025-12-15	2.21	Low	2026-01-08	2.26	45.92	f
1083	FORM-2022	2022-12-15	3.96	Medium	2022-02-22	3.96	78.48	f
1083	FORM-2023	2023-12-15	2.56	Medium	2022-02-22	2.19	57.18	f
1083	FORM-2024	2024-12-15	4.20	High	2022-02-22	4.54	84.37	f
1083	FORM-2025	2025-12-15	4.69	High	2022-02-22	4.66	99.99	t
1084	FORM-2022	2022-12-15	3.62	Medium	2022-03-16	3.48	77.83	f
1084	FORM-2023	2023-12-15	3.13	Medium	2022-03-16	3.51	73.66	f
1084	FORM-2024	2024-12-15	3.85	Medium	2022-03-16	4.19	73.78	f
1084	FORM-2025	2025-12-15	3.73	Medium	2022-03-16	3.79	71.28	f
1085	FORM-2022	2022-12-15	4.20	High	2025-09-26	4.42	87.90	f
1085	FORM-2023	2023-12-15	3.59	Medium	2025-09-26	3.21	74.30	f
1085	FORM-2024	2024-12-15	3.67	Medium	2025-09-26	3.27	66.17	f
1085	FORM-2025	2025-12-15	3.71	Medium	2025-09-26	4.09	76.49	f
1086	FORM-2022	2022-12-15	3.41	Medium	2026-01-08	3.14	62.24	f
1086	FORM-2023	2023-12-15	3.34	Medium	2026-01-08	3.38	73.47	f
1086	FORM-2024	2024-12-15	5.00	High	2026-01-08	5.00	97.11	t
1086	FORM-2025	2025-12-15	4.32	High	2026-01-08	4.34	96.85	f
1087	FORM-2022	2022-12-15	3.21	Medium	2024-09-18	3.09	69.99	f
1087	FORM-2023	2023-12-15	2.55	Medium	2024-09-18	2.39	49.12	f
1087	FORM-2024	2024-12-15	2.82	Medium	2024-09-18	2.30	62.48	f
1087	FORM-2025	2025-12-15	4.29	High	2024-09-18	3.98	93.92	f
1090	FORM-2023	2023-12-15	1.65	Low	\N	1.63	28.02	f
1090	FORM-2024	2024-12-15	2.59	Medium	\N	2.72	44.05	f
1090	FORM-2025	2025-12-15	2.42	Low	\N	2.60	42.83	f
1091	FORM-2022	2022-12-15	4.02	High	2025-03-17	4.34	77.56	f
1091	FORM-2023	2023-12-15	4.11	High	2025-03-17	3.62	78.51	f
1091	FORM-2024	2024-12-15	3.67	Medium	2025-03-17	3.91	80.01	f
1091	FORM-2025	2025-12-15	3.89	Medium	2025-03-17	3.90	81.93	f
1092	FORM-2024	2024-12-15	3.87	Medium	2026-01-08	3.50	82.82	f
1092	FORM-2025	2025-12-15	4.13	High	2026-01-08	4.10	79.14	f
1093	FORM-2023	2023-12-15	4.82	High	2026-01-08	4.59	96.83	t
1093	FORM-2024	2024-12-15	3.50	Medium	2026-01-08	3.49	76.82	f
1093	FORM-2025	2025-12-15	4.05	High	2026-01-08	3.97	85.88	f
1094	FORM-2022	2022-12-15	3.87	Medium	2019-01-11	3.85	74.82	f
1094	FORM-2023	2023-12-15	3.04	Medium	2019-01-11	2.57	70.11	f
1094	FORM-2024	2024-12-15	3.05	Medium	2019-01-11	2.76	55.90	f
1094	FORM-2025	2025-12-15	2.83	Medium	2019-01-11	3.11	56.08	f
1095	FORM-2022	2022-12-15	2.91	Medium	2023-10-09	2.71	52.20	f
1095	FORM-2023	2023-12-15	3.96	Medium	2023-10-09	3.60	79.69	f
1095	FORM-2024	2024-12-15	3.64	Medium	2023-10-09	3.73	74.16	f
1095	FORM-2025	2025-12-15	3.33	Medium	2023-10-09	2.74	66.50	f
1096	FORM-2022	2022-12-15	3.60	Medium	2024-04-05	3.27	80.68	f
1096	FORM-2023	2023-12-15	4.48	High	2024-04-05	4.39	91.74	f
1096	FORM-2024	2024-12-15	3.85	Medium	2024-04-05	3.38	74.42	f
1096	FORM-2025	2025-12-15	4.29	High	2024-04-05	4.26	79.81	f
1097	FORM-2022	2022-12-15	4.42	High	2026-01-08	4.51	81.44	f
1097	FORM-2023	2023-12-15	3.57	Medium	2026-01-08	3.46	65.50	f
1097	FORM-2024	2024-12-15	4.23	High	2026-01-08	4.09	85.42	f
1097	FORM-2025	2025-12-15	4.74	High	2026-01-08	4.57	88.18	t
1098	FORM-2022	2022-12-15	3.40	Medium	2021-02-14	3.29	65.99	f
1098	FORM-2023	2023-12-15	2.94	Medium	2021-02-14	2.55	56.44	f
1098	FORM-2024	2024-12-15	2.75	Medium	2021-02-14	2.47	72.04	f
1098	FORM-2025	2025-12-15	4.61	High	2021-02-14	5.00	90.35	t
1099	FORM-2022	2022-12-15	3.30	Medium	2025-04-01	3.44	59.83	f
1099	FORM-2023	2023-12-15	3.71	Medium	2025-04-01	3.48	79.56	f
1099	FORM-2024	2024-12-15	3.80	Medium	2025-04-01	3.88	72.36	f
1099	FORM-2025	2025-12-15	3.75	Medium	2025-04-01	3.30	74.40	f
1101	FORM-2022	2022-12-15	3.24	Medium	2018-11-10	3.34	61.98	f
1101	FORM-2023	2023-12-15	2.90	Medium	2018-11-10	2.92	66.76	f
1101	FORM-2024	2024-12-15	3.33	Medium	2018-11-10	3.78	51.59	f
1101	FORM-2025	2025-12-15	2.97	Medium	2018-11-10	2.90	51.40	f
1102	FORM-2022	2022-12-15	2.48	Low	2021-04-01	2.49	43.63	f
1102	FORM-2023	2023-12-15	3.45	Medium	2021-04-01	3.41	67.69	f
1102	FORM-2024	2024-12-15	3.54	Medium	2021-04-01	3.69	66.09	f
1102	FORM-2025	2025-12-15	4.42	High	2021-04-01	4.73	78.90	f
1103	FORM-2022	2022-12-15	3.41	Medium	2025-01-08	3.64	60.56	f
1103	FORM-2023	2023-12-15	3.56	Medium	2025-01-08	3.60	77.21	f
1103	FORM-2024	2024-12-15	4.44	High	2025-01-08	4.40	92.05	f
1103	FORM-2025	2025-12-15	4.02	High	2025-01-08	4.43	80.33	f
1104	FORM-2022	2022-12-15	2.43	Low	\N	2.38	40.83	f
1104	FORM-2023	2023-12-15	1.85	Low	\N	1.18	45.82	f
1104	FORM-2024	2024-12-15	3.48	Medium	\N	3.05	74.69	f
1104	FORM-2025	2025-12-15	2.70	Medium	\N	2.65	57.73	f
1105	FORM-2022	2022-12-15	3.35	Medium	2024-10-27	4.01	72.44	f
1105	FORM-2023	2023-12-15	3.01	Medium	2024-10-27	2.74	68.47	f
1105	FORM-2024	2024-12-15	3.27	Medium	2024-10-27	3.22	66.30	f
1105	FORM-2025	2025-12-15	3.43	Medium	2024-10-27	3.72	62.93	f
1106	FORM-2022	2022-12-15	2.25	Low	2024-06-12	2.11	40.23	f
1106	FORM-2023	2023-12-15	3.08	Medium	2024-06-12	2.66	55.94	f
1106	FORM-2024	2024-12-15	2.67	Medium	2024-06-12	2.91	46.87	f
1106	FORM-2025	2025-12-15	3.29	Medium	2024-06-12	3.65	63.76	f
1107	FORM-2022	2022-12-15	4.04	High	2025-07-05	4.29	84.25	f
1107	FORM-2023	2023-12-15	3.56	Medium	2025-07-05	3.30	78.95	f
1107	FORM-2024	2024-12-15	3.94	Medium	2025-07-05	3.76	76.69	f
1107	FORM-2025	2025-12-15	3.82	Medium	2025-07-05	3.38	79.30	f
1108	FORM-2022	2022-12-15	3.92	Medium	2025-03-13	3.76	73.35	f
1108	FORM-2023	2023-12-15	3.19	Medium	2025-03-13	3.14	75.90	f
1108	FORM-2024	2024-12-15	3.83	Medium	2025-03-13	3.87	72.92	f
1108	FORM-2025	2025-12-15	3.44	Medium	2025-03-13	3.39	61.82	f
1110	FORM-2022	2022-12-15	2.74	Medium	2018-03-25	2.85	48.38	f
1110	FORM-2023	2023-12-15	2.29	Low	2018-03-25	2.25	43.41	f
1110	FORM-2024	2024-12-15	2.09	Low	2018-03-25	2.39	48.85	f
1110	FORM-2025	2025-12-15	3.99	Medium	2018-03-25	3.88	83.22	f
1111	FORM-2022	2022-12-15	4.46	High	2021-12-29	4.60	96.10	f
1111	FORM-2023	2023-12-15	3.93	Medium	2021-12-29	3.81	81.41	f
1111	FORM-2024	2024-12-15	4.10	High	2021-12-29	4.27	88.55	f
1111	FORM-2025	2025-12-15	3.93	Medium	2021-12-29	3.88	85.67	f
1112	FORM-2022	2022-12-15	3.33	Medium	2023-05-02	3.12	72.29	f
1112	FORM-2023	2023-12-15	2.33	Low	2023-05-02	2.61	51.67	f
1112	FORM-2024	2024-12-15	3.40	Medium	2023-05-02	3.69	65.59	f
1112	FORM-2025	2025-12-15	3.55	Medium	2023-05-02	3.19	63.60	f
1114	FORM-2022	2022-12-15	2.72	Medium	\N	2.62	47.53	f
1114	FORM-2023	2023-12-15	2.96	Medium	\N	2.94	55.20	f
1114	FORM-2024	2024-12-15	2.42	Low	\N	2.80	54.87	f
1114	FORM-2025	2025-12-15	2.53	Medium	\N	2.69	47.11	f
1115	FORM-2022	2022-12-15	4.30	High	2026-01-08	4.63	83.85	f
1115	FORM-2023	2023-12-15	3.50	Medium	2026-01-08	3.73	75.79	f
1115	FORM-2024	2024-12-15	3.90	Medium	2026-01-08	4.07	80.07	f
1115	FORM-2025	2025-12-15	2.60	Medium	2026-01-08	2.97	49.98	f
1116	FORM-2022	2022-12-15	3.97	Medium	2022-03-01	3.96	85.71	f
1116	FORM-2023	2023-12-15	3.64	Medium	2022-03-01	3.35	81.60	f
1116	FORM-2024	2024-12-15	4.20	High	2022-03-01	4.59	83.73	f
1116	FORM-2025	2025-12-15	4.02	High	2022-03-01	4.25	74.28	f
1117	FORM-2024	2024-12-15	1.73	Low	\N	1.52	30.77	f
1117	FORM-2025	2025-12-15	3.39	Medium	\N	4.03	66.54	f
1118	FORM-2022	2022-12-15	3.90	Medium	2023-01-14	3.82	76.54	f
1118	FORM-2023	2023-12-15	4.02	High	2023-01-14	4.11	78.29	f
1118	FORM-2024	2024-12-15	3.79	Medium	2023-01-14	3.64	71.41	f
1118	FORM-2025	2025-12-15	3.65	Medium	2023-01-14	3.82	75.92	f
1119	FORM-2022	2022-12-15	3.59	Medium	2026-01-08	3.83	72.16	f
1119	FORM-2023	2023-12-15	4.33	High	2026-01-08	4.28	97.41	f
1119	FORM-2024	2024-12-15	4.55	High	2026-01-08	4.73	99.65	t
1119	FORM-2025	2025-12-15	3.53	Medium	2026-01-08	3.97	63.25	f
1120	FORM-2022	2022-12-15	2.99	Medium	2016-05-24	2.84	48.36	f
1120	FORM-2023	2023-12-15	2.30	Low	2016-05-24	2.19	48.92	f
1120	FORM-2024	2024-12-15	2.76	Medium	2016-05-24	2.99	53.23	f
1120	FORM-2025	2025-12-15	2.49	Low	2016-05-24	2.83	57.04	f
1121	FORM-2022	2022-12-15	3.28	Medium	2026-01-08	2.88	59.06	f
1121	FORM-2023	2023-12-15	3.14	Medium	2026-01-08	3.16	69.99	f
1121	FORM-2024	2024-12-15	3.44	Medium	2026-01-08	3.51	71.38	f
1121	FORM-2025	2025-12-15	2.81	Medium	2026-01-08	3.09	65.32	f
1122	FORM-2022	2022-12-15	4.11	High	2026-01-08	4.50	80.70	f
1122	FORM-2023	2023-12-15	3.85	Medium	2026-01-08	4.19	75.98	f
1122	FORM-2024	2024-12-15	3.54	Medium	2026-01-08	3.99	69.87	f
1122	FORM-2025	2025-12-15	3.45	Medium	2026-01-08	3.45	56.14	f
1123	FORM-2023	2023-12-15	3.02	Medium	\N	3.36	52.94	f
1123	FORM-2024	2024-12-15	2.16	Low	\N	2.62	49.00	f
1123	FORM-2025	2025-12-15	2.33	Low	\N	2.29	49.01	f
1124	FORM-2022	2022-12-15	4.56	High	2025-07-08	4.75	94.59	t
1124	FORM-2023	2023-12-15	3.75	Medium	2025-07-08	4.14	78.49	f
1124	FORM-2024	2024-12-15	3.30	Medium	2025-07-08	3.20	76.81	f
1124	FORM-2025	2025-12-15	2.94	Medium	2025-07-08	2.68	62.09	f
1125	FORM-2024	2024-12-15	2.43	Low	\N	2.15	27.58	f
1125	FORM-2025	2025-12-15	2.33	Low	\N	2.63	40.60	f
1126	FORM-2022	2022-12-15	1.93	Low	\N	2.12	47.02	f
1126	FORM-2023	2023-12-15	2.06	Low	\N	1.97	32.09	f
1126	FORM-2024	2024-12-15	2.50	Medium	\N	2.31	48.98	f
1126	FORM-2025	2025-12-15	1.28	Low	\N	1.51	14.53	f
1127	FORM-2022	2022-12-15	3.18	Medium	2022-03-26	3.12	51.49	f
1127	FORM-2023	2023-12-15	3.04	Medium	2022-03-26	2.80	49.77	f
1127	FORM-2024	2024-12-15	3.50	Medium	2022-03-26	3.47	80.22	f
1127	FORM-2025	2025-12-15	4.28	High	2022-03-26	3.67	84.33	f
1128	FORM-2023	2023-12-15	3.42	Medium	2026-01-08	3.53	66.34	f
1128	FORM-2024	2024-12-15	4.03	High	2026-01-08	4.19	78.26	f
1128	FORM-2025	2025-12-15	3.02	Medium	2026-01-08	2.92	64.13	f
1129	FORM-2022	2022-12-15	4.13	High	2022-03-31	4.08	86.60	f
1129	FORM-2023	2023-12-15	3.80	Medium	2022-03-31	3.48	77.04	f
1129	FORM-2024	2024-12-15	4.27	High	2022-03-31	4.60	81.89	f
1129	FORM-2025	2025-12-15	3.91	Medium	2022-03-31	3.85	70.10	f
1130	FORM-2022	2022-12-15	3.11	Medium	2023-08-09	2.88	62.61	f
1130	FORM-2023	2023-12-15	2.62	Medium	2023-08-09	2.47	52.03	f
1130	FORM-2024	2024-12-15	2.99	Medium	2023-08-09	3.11	57.35	f
1130	FORM-2025	2025-12-15	2.81	Medium	2023-08-09	2.90	53.68	f
1131	FORM-2022	2022-12-15	3.41	Medium	2023-12-08	3.27	67.89	f
1131	FORM-2023	2023-12-15	3.81	Medium	2023-12-08	4.01	81.10	f
1131	FORM-2024	2024-12-15	4.01	High	2023-12-08	4.05	86.15	f
1131	FORM-2025	2025-12-15	3.24	Medium	2023-12-08	3.49	69.33	f
1132	FORM-2022	2022-12-15	3.33	Medium	\N	3.54	70.67	f
1132	FORM-2023	2023-12-15	2.66	Medium	\N	2.53	49.32	f
1132	FORM-2024	2024-12-15	2.92	Medium	\N	2.60	67.78	f
1132	FORM-2025	2025-12-15	2.60	Medium	\N	2.75	57.82	f
1133	FORM-2022	2022-12-15	3.98	Medium	2026-01-08	3.96	66.71	f
1133	FORM-2023	2023-12-15	4.03	High	2026-01-08	4.17	71.80	f
1133	FORM-2024	2024-12-15	3.95	Medium	2026-01-08	3.92	85.24	f
1133	FORM-2025	2025-12-15	3.00	Medium	2026-01-08	2.86	58.82	f
1135	FORM-2022	2022-12-15	2.97	Medium	2018-02-18	3.02	47.05	f
1135	FORM-2023	2023-12-15	2.27	Low	2018-02-18	2.26	48.69	f
1135	FORM-2024	2024-12-15	2.99	Medium	2018-02-18	3.08	61.62	f
1135	FORM-2025	2025-12-15	3.69	Medium	2018-02-18	3.71	63.55	f
1136	FORM-2022	2022-12-15	3.40	Medium	2023-02-03	3.43	77.00	f
1136	FORM-2023	2023-12-15	2.65	Medium	2023-02-03	3.22	52.49	f
1136	FORM-2024	2024-12-15	2.87	Medium	2023-02-03	2.80	64.11	f
1136	FORM-2025	2025-12-15	3.43	Medium	2023-02-03	3.24	72.73	f
1137	FORM-2022	2022-12-15	4.34	High	2023-04-14	4.34	97.04	f
1137	FORM-2023	2023-12-15	4.91	High	2023-04-14	4.30	98.38	t
1137	FORM-2024	2024-12-15	4.78	High	2023-04-14	4.90	100.00	t
1137	FORM-2025	2025-12-15	4.14	High	2023-04-14	3.78	79.01	f
1138	FORM-2022	2022-12-15	3.40	Medium	2019-10-27	3.73	67.62	f
1138	FORM-2023	2023-12-15	3.16	Medium	2019-10-27	3.03	64.33	f
1138	FORM-2024	2024-12-15	3.50	Medium	2019-10-27	4.07	69.17	f
1138	FORM-2025	2025-12-15	2.78	Medium	2019-10-27	2.93	57.23	f
1139	FORM-2022	2022-12-15	3.94	Medium	2025-08-19	3.76	81.62	f
1139	FORM-2023	2023-12-15	3.61	Medium	2025-08-19	3.48	68.67	f
1139	FORM-2024	2024-12-15	4.34	High	2025-08-19	3.98	86.27	f
1139	FORM-2025	2025-12-15	3.72	Medium	2025-08-19	3.91	73.34	f
1140	FORM-2022	2022-12-15	4.31	High	2024-08-01	4.12	88.79	f
1140	FORM-2023	2023-12-15	3.99	Medium	2024-08-01	4.01	89.19	f
1140	FORM-2024	2024-12-15	4.12	High	2024-08-01	4.19	88.99	f
1140	FORM-2025	2025-12-15	4.04	High	2024-08-01	3.98	86.61	f
1141	FORM-2024	2024-12-15	3.62	Medium	\N	3.48	76.26	f
1141	FORM-2025	2025-12-15	2.57	Medium	\N	2.59	40.09	f
1142	FORM-2022	2022-12-15	3.53	Medium	2026-01-08	3.33	79.21	f
1142	FORM-2023	2023-12-15	3.29	Medium	2026-01-08	3.62	60.11	f
1142	FORM-2024	2024-12-15	3.76	Medium	2026-01-08	3.66	71.86	f
1142	FORM-2025	2025-12-15	3.07	Medium	2026-01-08	3.42	68.14	f
1143	FORM-2022	2022-12-15	4.45	High	2022-07-27	4.69	94.47	f
1143	FORM-2023	2023-12-15	4.47	High	2022-07-27	4.28	92.83	f
1143	FORM-2024	2024-12-15	4.58	High	2022-07-27	4.67	90.53	t
1143	FORM-2025	2025-12-15	3.41	Medium	2022-07-27	3.34	65.40	f
1144	FORM-2022	2022-12-15	1.91	Low	2022-09-15	2.03	47.35	f
1144	FORM-2023	2023-12-15	3.71	Medium	2022-09-15	3.75	69.85	f
1144	FORM-2024	2024-12-15	3.28	Medium	2022-09-15	3.63	57.39	f
1144	FORM-2025	2025-12-15	4.53	High	2022-09-15	4.15	95.77	t
1145	FORM-2022	2022-12-15	3.07	Medium	2023-09-03	2.96	48.48	f
1145	FORM-2023	2023-12-15	3.87	Medium	2023-09-03	3.98	83.85	f
1145	FORM-2024	2024-12-15	3.15	Medium	2023-09-03	3.48	64.11	f
1145	FORM-2025	2025-12-15	3.31	Medium	2023-09-03	3.19	73.64	f
1146	FORM-2022	2022-12-15	3.58	Medium	2022-06-15	3.69	62.73	f
1146	FORM-2023	2023-12-15	3.37	Medium	2022-06-15	3.12	62.56	f
1146	FORM-2024	2024-12-15	2.47	Low	2022-06-15	2.62	48.76	f
1146	FORM-2025	2025-12-15	3.40	Medium	2022-06-15	3.15	69.11	f
1147	FORM-2022	2022-12-15	3.35	Medium	2026-01-08	3.33	70.79	f
1147	FORM-2023	2023-12-15	4.04	High	2026-01-08	4.19	76.75	f
1147	FORM-2024	2024-12-15	2.88	Medium	2026-01-08	2.95	51.20	f
1147	FORM-2025	2025-12-15	3.69	Medium	2026-01-08	3.40	72.41	f
1148	FORM-2022	2022-12-15	4.18	High	2021-03-01	4.10	76.26	f
1148	FORM-2023	2023-12-15	3.92	Medium	2021-03-01	3.99	78.53	f
1148	FORM-2024	2024-12-15	3.99	Medium	2021-03-01	4.30	89.78	f
1148	FORM-2025	2025-12-15	4.21	High	2021-03-01	4.12	86.37	f
1149	FORM-2024	2024-12-15	1.81	Low	\N	1.81	47.37	f
1149	FORM-2025	2025-12-15	2.47	Low	\N	2.47	44.70	f
1150	FORM-2022	2022-12-15	3.96	Medium	2018-08-11	3.89	81.03	f
1150	FORM-2023	2023-12-15	3.23	Medium	2018-08-11	2.93	63.53	f
1150	FORM-2024	2024-12-15	2.90	Medium	2018-08-11	2.73	54.57	f
1150	FORM-2025	2025-12-15	4.26	High	2018-08-11	4.42	87.09	f
1151	FORM-2022	2022-12-15	3.09	Medium	2026-01-08	3.24	60.99	f
1151	FORM-2023	2023-12-15	4.01	High	2026-01-08	3.95	90.52	f
1151	FORM-2024	2024-12-15	3.28	Medium	2026-01-08	3.30	62.81	f
1151	FORM-2025	2025-12-15	3.39	Medium	2026-01-08	3.14	60.91	f
1152	FORM-2022	2022-12-15	3.02	Medium	2023-03-02	2.81	54.73	f
1152	FORM-2023	2023-12-15	3.99	Medium	2023-03-02	3.83	78.87	f
1152	FORM-2024	2024-12-15	4.51	High	2023-03-02	4.66	80.82	t
1152	FORM-2025	2025-12-15	4.05	High	2023-03-02	4.20	80.15	f
1153	FORM-2022	2022-12-15	2.93	Medium	2024-03-15	3.02	57.07	f
1153	FORM-2023	2023-12-15	3.53	Medium	2024-03-15	3.68	73.12	f
1153	FORM-2024	2024-12-15	3.15	Medium	2024-03-15	2.75	63.58	f
1153	FORM-2025	2025-12-15	3.34	Medium	2024-03-15	3.30	68.75	f
1154	FORM-2022	2022-12-15	4.12	High	2024-07-29	3.85	87.46	f
1154	FORM-2023	2023-12-15	4.03	High	2024-07-29	4.07	80.99	f
1154	FORM-2024	2024-12-15	4.94	High	2024-07-29	5.00	98.29	t
1154	FORM-2025	2025-12-15	3.06	Medium	2024-07-29	2.99	64.11	f
1155	FORM-2023	2023-12-15	2.76	Medium	2026-01-08	2.72	56.05	f
1155	FORM-2024	2024-12-15	3.79	Medium	2026-01-08	3.41	74.70	f
1155	FORM-2025	2025-12-15	3.28	Medium	2026-01-08	3.28	68.11	f
1156	FORM-2025	2025-12-15	2.94	Medium	\N	3.21	74.37	f
1157	FORM-2023	2023-12-15	3.96	Medium	2026-01-08	4.07	78.45	f
1157	FORM-2024	2024-12-15	3.81	Medium	2026-01-08	3.58	75.13	f
1157	FORM-2025	2025-12-15	3.53	Medium	2026-01-08	3.21	71.55	f
1158	FORM-2022	2022-12-15	3.12	Medium	2020-10-06	3.17	60.69	f
1158	FORM-2023	2023-12-15	3.65	Medium	2020-10-06	4.01	76.17	f
1158	FORM-2024	2024-12-15	3.22	Medium	2020-10-06	3.13	65.67	f
1158	FORM-2025	2025-12-15	3.19	Medium	2020-10-06	3.10	70.68	f
1160	FORM-2022	2022-12-15	3.09	Medium	2020-08-26	2.97	62.93	f
1160	FORM-2023	2023-12-15	2.89	Medium	2020-08-26	2.76	59.30	f
1160	FORM-2024	2024-12-15	2.75	Medium	2020-08-26	2.60	59.29	f
1160	FORM-2025	2025-12-15	2.61	Medium	2020-08-26	2.96	44.78	f
1161	FORM-2025	2025-12-15	3.63	Medium	2026-01-08	3.73	74.74	f
1162	FORM-2022	2022-12-15	4.00	High	2023-09-16	4.23	78.45	f
1162	FORM-2023	2023-12-15	3.66	Medium	2023-09-16	3.58	85.15	f
1162	FORM-2024	2024-12-15	3.33	Medium	2023-09-16	3.60	61.61	f
1162	FORM-2025	2025-12-15	4.12	High	2023-09-16	4.40	75.07	f
1163	FORM-2022	2022-12-15	2.51	Medium	2015-08-28	2.73	57.41	f
1163	FORM-2023	2023-12-15	2.66	Medium	2015-08-28	3.10	51.57	f
1163	FORM-2024	2024-12-15	3.14	Medium	2015-08-28	3.46	58.36	f
1163	FORM-2025	2025-12-15	3.78	Medium	2015-08-28	3.59	75.02	f
1165	FORM-2022	2022-12-15	3.66	Medium	2026-01-08	4.24	73.39	f
1165	FORM-2023	2023-12-15	4.28	High	2026-01-08	4.57	83.05	f
1165	FORM-2024	2024-12-15	4.30	High	2026-01-08	4.22	75.64	f
1165	FORM-2025	2025-12-15	3.67	Medium	2026-01-08	3.68	59.98	f
1166	FORM-2022	2022-12-15	2.35	Low	2015-05-27	2.33	49.57	f
1166	FORM-2023	2023-12-15	3.27	Medium	2015-05-27	3.26	61.45	f
1166	FORM-2024	2024-12-15	3.24	Medium	2015-05-27	2.90	69.05	f
1166	FORM-2025	2025-12-15	2.19	Low	2015-05-27	2.42	38.39	f
1167	FORM-2022	2022-12-15	4.63	High	2026-01-08	4.52	88.89	t
1167	FORM-2023	2023-12-15	3.34	Medium	2026-01-08	3.48	59.57	f
1167	FORM-2024	2024-12-15	3.72	Medium	2026-01-08	3.83	69.07	f
1167	FORM-2025	2025-12-15	3.39	Medium	2026-01-08	3.26	59.66	f
1168	FORM-2022	2022-12-15	3.49	Medium	2022-03-07	3.49	60.45	f
1168	FORM-2023	2023-12-15	3.85	Medium	2022-03-07	3.87	78.12	f
1168	FORM-2024	2024-12-15	3.85	Medium	2022-03-07	3.26	71.59	f
1168	FORM-2025	2025-12-15	4.00	High	2022-03-07	3.96	73.18	f
1169	FORM-2023	2023-12-15	3.29	Medium	\N	3.60	57.56	f
1169	FORM-2024	2024-12-15	2.42	Low	\N	2.55	58.09	f
1169	FORM-2025	2025-12-15	1.44	Low	\N	1.60	26.47	f
1170	FORM-2024	2024-12-15	3.03	Medium	2026-01-08	2.96	70.55	f
1170	FORM-2025	2025-12-15	3.92	Medium	2026-01-08	3.85	72.80	f
1171	FORM-2022	2022-12-15	5.00	High	2021-06-20	5.00	93.54	t
1171	FORM-2023	2023-12-15	4.41	High	2021-06-20	4.36	86.20	f
1171	FORM-2024	2024-12-15	4.38	High	2021-06-20	3.95	93.22	f
1171	FORM-2025	2025-12-15	3.94	Medium	2021-06-20	4.03	79.94	f
1172	FORM-2022	2022-12-15	3.02	Medium	2024-01-14	2.83	62.64	f
1172	FORM-2023	2023-12-15	4.11	High	2024-01-14	4.09	72.24	f
1172	FORM-2024	2024-12-15	3.72	Medium	2024-01-14	3.52	69.78	f
1172	FORM-2025	2025-12-15	4.09	High	2024-01-14	4.17	72.73	f
1173	FORM-2022	2022-12-15	3.33	Medium	2018-08-25	3.47	67.73	f
1173	FORM-2023	2023-12-15	3.31	Medium	2018-08-25	3.31	59.10	f
1173	FORM-2024	2024-12-15	4.34	High	2018-08-25	4.37	81.57	f
1173	FORM-2025	2025-12-15	2.48	Low	2018-08-25	2.04	45.83	f
1174	FORM-2022	2022-12-15	4.37	High	2026-01-08	4.23	85.81	f
1174	FORM-2023	2023-12-15	3.34	Medium	2026-01-08	3.71	80.25	f
1174	FORM-2024	2024-12-15	2.48	Low	2026-01-08	2.39	52.53	f
1174	FORM-2025	2025-12-15	4.09	High	2026-01-08	3.96	78.93	f
1175	FORM-2025	2025-12-15	3.28	Medium	2026-01-08	3.66	54.87	f
1176	FORM-2022	2022-12-15	3.50	Medium	2026-01-08	3.61	63.84	f
1176	FORM-2023	2023-12-15	3.57	Medium	2026-01-08	3.90	73.08	f
1176	FORM-2024	2024-12-15	3.58	Medium	2026-01-08	3.70	63.43	f
1176	FORM-2025	2025-12-15	3.93	Medium	2026-01-08	4.04	85.80	f
1178	FORM-2022	2022-12-15	4.17	High	2025-05-01	4.20	82.22	f
1178	FORM-2023	2023-12-15	3.72	Medium	2025-05-01	4.03	81.82	f
1178	FORM-2024	2024-12-15	4.12	High	2025-05-01	4.13	77.24	f
1178	FORM-2025	2025-12-15	3.17	Medium	2025-05-01	3.06	68.05	f
1179	FORM-2022	2022-12-15	3.48	Medium	2025-06-02	3.80	68.47	f
1179	FORM-2023	2023-12-15	2.59	Medium	2025-06-02	2.42	56.80	f
1179	FORM-2024	2024-12-15	3.52	Medium	2025-06-02	3.55	70.13	f
1179	FORM-2025	2025-12-15	3.15	Medium	2025-06-02	3.31	59.83	f
1181	FORM-2022	2022-12-15	3.60	Medium	2025-05-03	3.60	62.35	f
1181	FORM-2023	2023-12-15	4.17	High	2025-05-03	4.11	88.42	f
1181	FORM-2024	2024-12-15	3.69	Medium	2025-05-03	3.68	71.04	f
1181	FORM-2025	2025-12-15	3.50	Medium	2025-05-03	3.37	64.97	f
1182	FORM-2022	2022-12-15	3.14	Medium	2023-08-13	2.72	56.74	f
1182	FORM-2023	2023-12-15	3.33	Medium	2023-08-13	3.47	54.45	f
1182	FORM-2024	2024-12-15	3.64	Medium	2023-08-13	3.97	78.08	f
1182	FORM-2025	2025-12-15	4.08	High	2023-08-13	3.78	75.79	f
1183	FORM-2023	2023-12-15	2.24	Low	2026-01-08	2.58	57.90	f
1183	FORM-2024	2024-12-15	2.15	Low	2026-01-08	2.11	34.96	f
1183	FORM-2025	2025-12-15	2.01	Low	2026-01-08	1.77	49.04	f
1184	FORM-2022	2022-12-15	3.15	Medium	2023-02-09	3.35	66.93	f
1184	FORM-2023	2023-12-15	2.98	Medium	2023-02-09	3.31	53.04	f
1184	FORM-2024	2024-12-15	3.14	Medium	2023-02-09	3.25	60.98	f
1184	FORM-2025	2025-12-15	3.27	Medium	2023-02-09	3.47	72.30	f
1185	FORM-2023	2023-12-15	2.50	Medium	2026-01-08	2.51	57.58	f
1185	FORM-2024	2024-12-15	4.19	High	2026-01-08	3.56	79.19	f
1185	FORM-2025	2025-12-15	3.44	Medium	2026-01-08	3.34	73.12	f
1186	FORM-2022	2022-12-15	4.09	High	2026-01-08	4.23	80.37	f
1186	FORM-2023	2023-12-15	3.76	Medium	2026-01-08	3.99	78.39	f
1186	FORM-2024	2024-12-15	4.02	High	2026-01-08	4.05	75.81	f
1186	FORM-2025	2025-12-15	3.47	Medium	2026-01-08	3.50	75.61	f
1187	FORM-2022	2022-12-15	3.34	Medium	2023-03-01	3.42	69.18	f
1187	FORM-2023	2023-12-15	3.72	Medium	2023-03-01	3.69	78.24	f
1187	FORM-2024	2024-12-15	3.46	Medium	2023-03-01	3.81	58.72	f
1187	FORM-2025	2025-12-15	4.18	High	2023-03-01	4.35	91.90	f
1188	FORM-2023	2023-12-15	1.93	Low	2026-01-08	1.66	45.08	f
1188	FORM-2024	2024-12-15	2.56	Medium	2026-01-08	2.55	57.65	f
1188	FORM-2025	2025-12-15	2.42	Low	2026-01-08	2.16	42.47	f
1189	FORM-2025	2025-12-15	3.38	Medium	2026-01-08	3.19	67.93	f
1191	FORM-2022	2022-12-15	2.89	Medium	2024-04-27	3.01	53.83	f
1191	FORM-2023	2023-12-15	3.23	Medium	2024-04-27	3.44	69.93	f
1191	FORM-2024	2024-12-15	3.17	Medium	2024-04-27	3.06	64.02	f
1191	FORM-2025	2025-12-15	2.25	Low	2024-04-27	2.33	50.43	f
1192	FORM-2022	2022-12-15	3.07	Medium	2022-11-17	3.42	66.40	f
1192	FORM-2023	2023-12-15	4.38	High	2022-11-17	4.10	88.06	f
1192	FORM-2024	2024-12-15	3.07	Medium	2022-11-17	2.97	66.01	f
1192	FORM-2025	2025-12-15	3.98	Medium	2022-11-17	3.97	77.59	f
1193	FORM-2025	2025-12-15	1.96	Low	\N	1.95	40.85	f
1194	FORM-2023	2023-12-15	4.16	High	2026-01-08	4.39	79.85	f
1194	FORM-2024	2024-12-15	3.51	Medium	2026-01-08	3.84	71.79	f
1194	FORM-2025	2025-12-15	2.99	Medium	2026-01-08	3.39	55.70	f
1196	FORM-2022	2022-12-15	3.81	Medium	2021-08-20	3.73	76.53	f
1196	FORM-2023	2023-12-15	4.23	High	2021-08-20	3.77	82.67	f
1196	FORM-2024	2024-12-15	3.04	Medium	2021-08-20	2.97	58.91	f
1196	FORM-2025	2025-12-15	3.86	Medium	2021-08-20	3.97	74.37	f
1198	FORM-2022	2022-12-15	3.70	Medium	2016-06-10	3.91	68.71	f
1198	FORM-2023	2023-12-15	2.76	Medium	2016-06-10	2.59	56.48	f
1198	FORM-2024	2024-12-15	2.76	Medium	2016-06-10	2.95	52.02	f
1198	FORM-2025	2025-12-15	2.96	Medium	2016-06-10	2.81	55.55	f
1199	FORM-2023	2023-12-15	3.37	Medium	2026-01-08	2.99	68.81	f
1199	FORM-2024	2024-12-15	3.36	Medium	2026-01-08	3.69	61.56	f
1199	FORM-2025	2025-12-15	3.56	Medium	2026-01-08	3.53	71.74	f
1201	FORM-2022	2022-12-15	3.99	Medium	2026-01-08	3.66	87.67	f
1201	FORM-2023	2023-12-15	4.20	High	2026-01-08	4.04	80.45	f
1201	FORM-2024	2024-12-15	5.00	High	2026-01-08	4.95	99.56	t
1201	FORM-2025	2025-12-15	3.03	Medium	2026-01-08	2.97	63.73	f
1202	FORM-2022	2022-12-15	3.13	Medium	2020-07-04	3.17	64.54	f
1202	FORM-2023	2023-12-15	3.22	Medium	2020-07-04	3.47	63.25	f
1202	FORM-2024	2024-12-15	3.36	Medium	2020-07-04	3.36	56.40	f
1202	FORM-2025	2025-12-15	3.69	Medium	2020-07-04	3.88	78.46	f
1203	FORM-2022	2022-12-15	3.62	Medium	2022-03-01	3.60	75.67	f
1203	FORM-2023	2023-12-15	4.76	High	2022-03-01	4.48	98.83	t
1203	FORM-2024	2024-12-15	3.64	Medium	2022-03-01	3.85	64.24	f
1203	FORM-2025	2025-12-15	4.41	High	2022-03-01	4.73	86.81	f
1204	FORM-2025	2025-12-15	3.41	Medium	\N	3.45	80.92	f
1205	FORM-2022	2022-12-15	3.51	Medium	2025-01-19	3.01	70.04	f
1205	FORM-2023	2023-12-15	3.17	Medium	2025-01-19	2.83	57.47	f
1205	FORM-2024	2024-12-15	3.54	Medium	2025-01-19	3.35	76.81	f
1205	FORM-2025	2025-12-15	2.56	Medium	2025-01-19	2.50	54.02	f
1206	FORM-2024	2024-12-15	2.70	Medium	\N	2.56	55.63	f
1206	FORM-2025	2025-12-15	1.98	Low	\N	1.80	31.08	f
1207	FORM-2022	2022-12-15	3.60	Medium	2021-10-19	3.50	66.04	f
1207	FORM-2023	2023-12-15	2.81	Medium	2021-10-19	3.15	66.75	f
1207	FORM-2024	2024-12-15	2.50	Medium	2021-10-19	2.95	49.68	f
1207	FORM-2025	2025-12-15	3.53	Medium	2021-10-19	3.75	66.00	f
1208	FORM-2023	2023-12-15	2.16	Low	\N	1.74	43.43	f
1208	FORM-2024	2024-12-15	2.71	Medium	\N	2.66	46.77	f
1208	FORM-2025	2025-12-15	2.73	Medium	\N	2.93	55.61	f
1209	FORM-2025	2025-12-15	3.09	Medium	2026-01-08	3.17	56.16	f
1212	FORM-2022	2022-12-15	3.99	Medium	2021-11-08	4.08	86.17	f
1212	FORM-2023	2023-12-15	4.78	High	2021-11-08	5.00	100.00	t
1212	FORM-2024	2024-12-15	3.58	Medium	2021-11-08	3.75	63.14	f
1212	FORM-2025	2025-12-15	3.85	Medium	2021-11-08	3.82	73.99	f
1213	FORM-2022	2022-12-15	4.10	High	2026-01-08	3.99	94.07	f
1213	FORM-2023	2023-12-15	3.76	Medium	2026-01-08	4.24	76.94	f
1213	FORM-2024	2024-12-15	3.35	Medium	2026-01-08	3.38	79.86	f
1213	FORM-2025	2025-12-15	3.77	Medium	2026-01-08	3.79	78.72	f
1214	FORM-2023	2023-12-15	2.90	Medium	\N	3.09	47.85	f
1214	FORM-2024	2024-12-15	2.13	Low	\N	2.00	60.84	f
1214	FORM-2025	2025-12-15	2.10	Low	\N	2.13	58.15	f
1215	FORM-2022	2022-12-15	3.65	Medium	2025-07-13	3.99	78.11	f
1215	FORM-2023	2023-12-15	2.61	Medium	2025-07-13	2.49	50.72	f
1215	FORM-2024	2024-12-15	2.50	Medium	2025-07-13	1.98	55.99	f
1215	FORM-2025	2025-12-15	4.36	High	2025-07-13	4.09	86.50	f
1216	FORM-2022	2022-12-15	3.68	Medium	2024-04-27	3.94	65.13	f
1216	FORM-2023	2023-12-15	2.93	Medium	2024-04-27	3.03	47.32	f
1216	FORM-2024	2024-12-15	2.68	Medium	2024-04-27	2.54	39.78	f
1216	FORM-2025	2025-12-15	2.55	Medium	2024-04-27	2.58	53.54	f
1217	FORM-2025	2025-12-15	2.30	Low	2026-01-08	2.43	44.81	f
1218	FORM-2022	2022-12-15	3.78	Medium	2025-05-29	3.63	62.57	f
1218	FORM-2023	2023-12-15	4.28	High	2025-05-29	4.40	85.45	f
1218	FORM-2024	2024-12-15	3.59	Medium	2025-05-29	3.25	74.23	f
1218	FORM-2025	2025-12-15	3.62	Medium	2025-05-29	3.76	76.44	f
1219	FORM-2022	2022-12-15	3.60	Medium	2025-09-19	3.42	71.01	f
1219	FORM-2023	2023-12-15	4.01	High	2025-09-19	3.58	81.32	f
1219	FORM-2024	2024-12-15	3.12	Medium	2025-09-19	3.03	76.26	f
1219	FORM-2025	2025-12-15	3.35	Medium	2025-09-19	3.09	64.54	f
1220	FORM-2022	2022-12-15	3.29	Medium	2022-01-26	2.96	67.85	f
1220	FORM-2023	2023-12-15	3.72	Medium	2022-01-26	3.85	76.49	f
1220	FORM-2024	2024-12-15	3.26	Medium	2022-01-26	3.02	65.41	f
1220	FORM-2025	2025-12-15	3.66	Medium	2022-01-26	3.45	71.94	f
1221	FORM-2022	2022-12-15	3.41	Medium	2019-04-26	3.98	74.97	f
1221	FORM-2023	2023-12-15	4.08	High	2019-04-26	4.26	77.91	f
1221	FORM-2024	2024-12-15	3.71	Medium	2019-04-26	4.09	68.26	f
1221	FORM-2025	2025-12-15	3.43	Medium	2019-04-26	3.46	71.96	f
1222	FORM-2022	2022-12-15	4.43	High	2025-08-15	4.38	87.66	f
1222	FORM-2023	2023-12-15	5.00	High	2025-08-15	4.88	91.76	t
1222	FORM-2024	2024-12-15	3.92	Medium	2025-08-15	3.78	77.39	f
1222	FORM-2025	2025-12-15	3.79	Medium	2025-08-15	3.22	76.32	f
1223	FORM-2022	2022-12-15	3.06	Medium	2024-03-10	3.36	62.24	f
1223	FORM-2023	2023-12-15	3.53	Medium	2024-03-10	3.94	73.75	f
1223	FORM-2024	2024-12-15	3.18	Medium	2024-03-10	3.10	67.34	f
1223	FORM-2025	2025-12-15	2.78	Medium	2024-03-10	2.19	54.84	f
1224	FORM-2022	2022-12-15	4.42	High	2023-07-26	4.64	86.79	f
1224	FORM-2023	2023-12-15	3.45	Medium	2023-07-26	3.38	68.79	f
1224	FORM-2024	2024-12-15	3.27	Medium	2023-07-26	3.02	64.92	f
1224	FORM-2025	2025-12-15	3.96	Medium	2023-07-26	4.10	74.37	f
1225	FORM-2024	2024-12-15	2.44	Low	2026-01-08	2.39	54.68	f
1225	FORM-2025	2025-12-15	2.66	Medium	2026-01-08	2.45	49.17	f
1226	FORM-2022	2022-12-15	4.67	High	2024-08-22	4.95	91.41	t
1226	FORM-2023	2023-12-15	4.24	High	2024-08-22	4.06	84.60	f
1226	FORM-2024	2024-12-15	2.93	Medium	2024-08-22	2.69	52.88	f
1226	FORM-2025	2025-12-15	3.27	Medium	2024-08-22	3.41	59.43	f
1228	FORM-2022	2022-12-15	3.90	Medium	2025-12-05	4.04	79.43	f
1228	FORM-2023	2023-12-15	3.98	Medium	2025-12-05	4.04	75.33	f
1228	FORM-2024	2024-12-15	3.18	Medium	2025-12-05	3.35	55.95	f
1228	FORM-2025	2025-12-15	3.85	Medium	2025-12-05	3.80	80.71	f
1229	FORM-2022	2022-12-15	3.91	Medium	2024-07-09	3.71	87.73	f
1229	FORM-2023	2023-12-15	3.73	Medium	2024-07-09	3.81	71.41	f
1229	FORM-2024	2024-12-15	3.45	Medium	2024-07-09	3.47	65.99	f
1229	FORM-2025	2025-12-15	3.82	Medium	2024-07-09	3.85	73.21	f
1230	FORM-2025	2025-12-15	3.89	Medium	2026-01-08	4.04	65.47	f
1231	FORM-2022	2022-12-15	3.39	Medium	2021-05-01	3.30	61.91	f
1231	FORM-2023	2023-12-15	3.48	Medium	2021-05-01	3.64	72.52	f
1231	FORM-2024	2024-12-15	3.04	Medium	2021-05-01	2.71	62.31	f
1231	FORM-2025	2025-12-15	3.70	Medium	2021-05-01	3.90	70.08	f
1232	FORM-2022	2022-12-15	2.97	Medium	2015-02-06	2.75	57.70	f
1232	FORM-2023	2023-12-15	3.25	Medium	2015-02-06	3.35	58.33	f
1232	FORM-2024	2024-12-15	3.47	Medium	2015-02-06	3.45	72.01	f
1232	FORM-2025	2025-12-15	3.17	Medium	2015-02-06	3.06	68.62	f
1233	FORM-2025	2025-12-15	2.14	Low	\N	2.05	35.48	f
1234	FORM-2022	2022-12-15	2.18	Low	2024-02-26	2.73	42.60	f
1234	FORM-2023	2023-12-15	2.74	Medium	2024-02-26	3.21	44.35	f
1234	FORM-2024	2024-12-15	3.56	Medium	2024-02-26	3.62	70.37	f
1234	FORM-2025	2025-12-15	2.83	Medium	2024-02-26	2.76	65.53	f
1235	FORM-2022	2022-12-15	4.36	High	2024-09-25	4.33	82.46	f
1235	FORM-2023	2023-12-15	3.86	Medium	2024-09-25	3.61	72.32	f
1235	FORM-2024	2024-12-15	3.70	Medium	2024-09-25	3.51	70.11	f
1235	FORM-2025	2025-12-15	3.67	Medium	2024-09-25	3.41	82.51	f
1236	FORM-2022	2022-12-15	1.89	Low	2023-04-05	2.06	41.81	f
1236	FORM-2023	2023-12-15	2.86	Medium	2023-04-05	2.82	58.03	f
1236	FORM-2024	2024-12-15	2.97	Medium	2023-04-05	3.14	62.65	f
1236	FORM-2025	2025-12-15	2.75	Medium	2023-04-05	2.50	56.88	f
1237	FORM-2022	2022-12-15	3.69	Medium	2023-09-19	3.89	70.48	f
1237	FORM-2023	2023-12-15	4.64	High	2023-09-19	4.21	100.00	t
1237	FORM-2024	2024-12-15	3.00	Medium	2023-09-19	2.97	70.50	f
1237	FORM-2025	2025-12-15	4.33	High	2023-09-19	4.72	91.38	f
1238	FORM-2022	2022-12-15	4.05	High	2023-10-22	3.70	73.86	f
1238	FORM-2023	2023-12-15	3.81	Medium	2023-10-22	3.96	80.52	f
1238	FORM-2024	2024-12-15	4.27	High	2023-10-22	4.62	93.91	f
1238	FORM-2025	2025-12-15	3.87	Medium	2023-10-22	3.35	83.45	f
1239	FORM-2023	2023-12-15	2.84	Medium	2025-08-02	2.72	57.81	f
1239	FORM-2024	2024-12-15	2.30	Low	2025-08-02	2.24	37.31	f
1239	FORM-2025	2025-12-15	1.79	Low	2025-08-02	1.61	44.55	f
1240	FORM-2022	2022-12-15	3.46	Medium	2026-01-08	3.65	68.49	f
1240	FORM-2023	2023-12-15	3.60	Medium	2026-01-08	3.13	67.62	f
1240	FORM-2024	2024-12-15	2.96	Medium	2026-01-08	2.62	59.86	f
1240	FORM-2025	2025-12-15	3.59	Medium	2026-01-08	3.68	71.43	f
1241	FORM-2022	2022-12-15	3.30	Medium	2015-06-17	3.31	67.62	f
1241	FORM-2023	2023-12-15	2.66	Medium	2015-06-17	2.80	55.71	f
1241	FORM-2024	2024-12-15	2.43	Low	2015-06-17	2.27	54.99	f
1241	FORM-2025	2025-12-15	2.29	Low	2015-06-17	2.19	51.91	f
1242	FORM-2022	2022-12-15	4.19	High	2026-01-08	4.43	87.42	f
1242	FORM-2023	2023-12-15	3.67	Medium	2026-01-08	3.23	85.72	f
1242	FORM-2024	2024-12-15	4.25	High	2026-01-08	4.03	85.73	f
1242	FORM-2025	2025-12-15	3.53	Medium	2026-01-08	3.50	74.14	f
1243	FORM-2022	2022-12-15	3.50	Medium	2024-02-03	3.97	67.98	f
1243	FORM-2023	2023-12-15	3.62	Medium	2024-02-03	3.91	65.44	f
1243	FORM-2024	2024-12-15	3.91	Medium	2024-02-03	4.44	78.76	f
1243	FORM-2025	2025-12-15	3.96	Medium	2024-02-03	3.82	73.60	f
1244	FORM-2022	2022-12-15	3.29	Medium	2024-06-13	3.86	71.31	f
1244	FORM-2023	2023-12-15	3.67	Medium	2024-06-13	3.84	79.15	f
1244	FORM-2024	2024-12-15	3.23	Medium	2024-06-13	3.23	64.21	f
1244	FORM-2025	2025-12-15	3.62	Medium	2024-06-13	3.38	64.57	f
1245	FORM-2022	2022-12-15	3.03	Medium	2025-09-26	3.13	54.00	f
1245	FORM-2023	2023-12-15	3.79	Medium	2025-09-26	3.50	74.51	f
1245	FORM-2024	2024-12-15	2.71	Medium	2025-09-26	2.86	45.01	f
1245	FORM-2025	2025-12-15	2.40	Low	2025-09-26	2.42	49.95	f
1246	FORM-2025	2025-12-15	2.88	Medium	\N	2.92	60.14	f
1247	FORM-2025	2025-12-15	2.59	Medium	\N	2.64	60.06	f
1248	FORM-2022	2022-12-15	3.74	Medium	2022-05-23	3.50	82.65	f
1248	FORM-2023	2023-12-15	4.33	High	2022-05-23	4.47	83.34	f
1248	FORM-2024	2024-12-15	4.09	High	2022-05-23	4.51	78.95	f
1248	FORM-2025	2025-12-15	4.19	High	2022-05-23	3.86	78.25	f
1249	FORM-2025	2025-12-15	2.99	Medium	\N	3.16	57.71	f
\.


--
-- TOC entry 5126 (class 0 OID 19790)
-- Dependencies: 226
-- Data for Name: termination_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.termination_info (user_id, event_reason, company, oktorehire, lastdateworked, bonuspayexpirationdate, termination_detailed_reason, termination_attachment) FROM stdin;
1019	RESIGNATION	Novaryn Tech	t	2023-06-18	2023-08-07	Démission volontaire du salarié.	EXIT-1019-2023.pdf
1025	INVOLUNTARY	Novaryn Tech	f	2024-06-27	2024-09-23	Licenciement pour motif économique ou personnel.	EXIT-1025-2024.pdf
1027	RESIGNATION	Novaryn Tech	t	2025-05-14	2025-07-07	Démission volontaire du salarié.	EXIT-1027-2025.pdf
1028	NON_RENEWAL	Novaryn Tech	t	2024-07-24	2024-09-26	Non-renouvellement du CDD à son terme.	EXIT-1028-2024.pdf
1029	RESIGNATION	Novaryn Tech	t	2023-06-28	2023-09-08	Démission volontaire du salarié.	EXIT-1029-2023.pdf
1040	INVOLUNTARY	Novaryn Tech	f	2024-03-08	2024-05-28	Licenciement pour motif économique ou personnel.	EXIT-1040-2024.pdf
1041	NON_RENEWAL	Novaryn Tech	t	2025-06-10	2025-08-23	Non-renouvellement du CDD à son terme.	EXIT-1041-2025.pdf
1045	DEATH	Novaryn Tech	f	2023-12-18	2024-02-11	Décès du salarié — acte transmis au service RH.	EXIT-1045-2023.pdf
1088	INVOLUNTARY	Novaryn Tech	f	2024-10-28	2025-01-01	Licenciement pour motif économique ou personnel.	EXIT-1088-2024.pdf
1089	RESIGNATION	Novaryn Tech	t	2025-05-21	2025-08-18	Démission volontaire du salarié.	EXIT-1089-2025.pdf
1109	INVOLUNTARY	Novaryn Tech	f	2025-08-23	2025-10-28	Licenciement pour motif économique ou personnel.	EXIT-1109-2025.pdf
1113	RESIGNATION	Novaryn Tech	t	2025-08-11	2025-11-06	Démission volontaire du salarié.	EXIT-1113-2025.pdf
1159	NON_RENEWAL	Novaryn Tech	t	2025-11-14	2026-01-03	Non-renouvellement du CDD à son terme.	EXIT-1159-2025.pdf
1164	RESIGNATION	Novaryn Tech	t	2025-09-25	2025-11-10	Démission volontaire du salarié.	EXIT-1164-2025.pdf
1177	DEATH	Novaryn Tech	f	2025-05-14	2025-08-03	Décès du salarié — acte transmis au service RH.	EXIT-1177-2025.pdf
1190	INVOLUNTARY	Novaryn Tech	f	2023-02-10	2023-03-19	Licenciement pour motif économique ou personnel.	EXIT-1190-2023.pdf
1195	RESIGNATION	Novaryn Tech	t	2025-08-04	2025-09-11	Démission volontaire du salarié.	EXIT-1195-2025.pdf
1210	RETIREMENT	Novaryn Tech	t	2025-10-18	2025-12-30	Départ à la retraite — droits validés.	EXIT-1210-2025.pdf
1227	RESIGNATION	Novaryn Tech	t	2024-02-20	2024-05-14	Démission volontaire du salarié.	EXIT-1227-2024.pdf
1250	INVOLUNTARY	Novaryn Tech	f	2023-02-14	2023-04-15	Licenciement pour motif économique ou personnel.	EXIT-1250-2023.pdf
\.


--
-- TOC entry 4928 (class 2606 OID 19698)
-- Name: basic_user_info basic_user_info_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basic_user_info
    ADD CONSTRAINT basic_user_info_email_key UNIQUE (email);


--
-- TOC entry 4930 (class 2606 OID 19694)
-- Name: basic_user_info basic_user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basic_user_info
    ADD CONSTRAINT basic_user_info_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4932 (class 2606 OID 19696)
-- Name: basic_user_info basic_user_info_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basic_user_info
    ADD CONSTRAINT basic_user_info_username_key UNIQUE (username);


--
-- TOC entry 4938 (class 2606 OID 19730)
-- Name: compensation_info compensation_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_info
    ADD CONSTRAINT compensation_info_pkey PRIMARY KEY (user_id, start_date);


--
-- TOC entry 4934 (class 2606 OID 19718)
-- Name: job_info job_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_pkey PRIMARY KEY (user_id, start_date, seq_number);


--
-- TOC entry 4956 (class 2606 OID 19784)
-- Name: learning_management_system learning_management_system_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_management_system
    ADD CONSTRAINT learning_management_system_pkey PRIMARY KEY (user_id, courseid, completiondate);


--
-- TOC entry 4948 (class 2606 OID 19759)
-- Name: pay_component_non_recurring pay_component_non_recurring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_non_recurring
    ADD CONSTRAINT pay_component_non_recurring_pkey PRIMARY KEY (user_id, pay_date, pay_component);


--
-- TOC entry 4944 (class 2606 OID 19744)
-- Name: pay_component_recurring pay_component_recurring_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_recurring
    ADD CONSTRAINT pay_component_recurring_pkey PRIMARY KEY (user_id, start_date, pay_component, seq_number);


--
-- TOC entry 4952 (class 2606 OID 19771)
-- Name: performance_management performance_management_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.performance_management
    ADD CONSTRAINT performance_management_pkey PRIMARY KEY (user_id, reviewdate);


--
-- TOC entry 4960 (class 2606 OID 19797)
-- Name: termination_info termination_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termination_info
    ADD CONSTRAINT termination_info_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4940 (class 2606 OID 19836)
-- Name: compensation_info uq_comp_user_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_info
    ADD CONSTRAINT uq_comp_user_date UNIQUE (user_id, start_date);


--
-- TOC entry 4936 (class 2606 OID 19834)
-- Name: job_info uq_contract_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT uq_contract_id UNIQUE (contract_id);


--
-- TOC entry 4958 (class 2606 OID 19886)
-- Name: learning_management_system uq_lms_entry; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_management_system
    ADD CONSTRAINT uq_lms_entry UNIQUE (user_id, courseid, completiondate);


--
-- TOC entry 4950 (class 2606 OID 19858)
-- Name: pay_component_non_recurring uq_non_rec_entry; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_non_recurring
    ADD CONSTRAINT uq_non_rec_entry UNIQUE (user_id, pay_date, pay_component);


--
-- TOC entry 4946 (class 2606 OID 19845)
-- Name: pay_component_recurring uq_pay_comp_rec; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_recurring
    ADD CONSTRAINT uq_pay_comp_rec UNIQUE (user_id, start_date, pay_component, seq_number);


--
-- TOC entry 4942 (class 2606 OID 19843)
-- Name: compensation_info uq_payroll_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_info
    ADD CONSTRAINT uq_payroll_id UNIQUE (payrollid);


--
-- TOC entry 4954 (class 2606 OID 19868)
-- Name: performance_management uq_perf_form; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.performance_management
    ADD CONSTRAINT uq_perf_form UNIQUE (user_id, formcontentid);


--
-- TOC entry 4962 (class 2606 OID 19895)
-- Name: termination_info uq_term_user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termination_info
    ADD CONSTRAINT uq_term_user_unique UNIQUE (user_id);


--
-- TOC entry 4963 (class 2606 OID 19704)
-- Name: basic_user_info basic_user_info_hr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basic_user_info
    ADD CONSTRAINT basic_user_info_hr_fkey FOREIGN KEY (hr) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4964 (class 2606 OID 19699)
-- Name: basic_user_info basic_user_info_manager_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basic_user_info
    ADD CONSTRAINT basic_user_info_manager_fkey FOREIGN KEY (manager) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4966 (class 2606 OID 19731)
-- Name: compensation_info compensation_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_info
    ADD CONSTRAINT compensation_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4965 (class 2606 OID 19719)
-- Name: job_info job_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4970 (class 2606 OID 19785)
-- Name: learning_management_system learning_management_system_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_management_system
    ADD CONSTRAINT learning_management_system_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4968 (class 2606 OID 19760)
-- Name: pay_component_non_recurring pay_component_non_recurring_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_non_recurring
    ADD CONSTRAINT pay_component_non_recurring_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4967 (class 2606 OID 19745)
-- Name: pay_component_recurring pay_component_recurring_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pay_component_recurring
    ADD CONSTRAINT pay_component_recurring_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4969 (class 2606 OID 19772)
-- Name: performance_management performance_management_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.performance_management
    ADD CONSTRAINT performance_management_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


--
-- TOC entry 4971 (class 2606 OID 19798)
-- Name: termination_info termination_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.termination_info
    ADD CONSTRAINT termination_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.basic_user_info(user_id);


-- Completed on 2026-03-21 11:25:43

--
-- PostgreSQL database dump complete
--

\unrestrict 20KTx39SexughlKI5N1gHbRYZEdQpPZR79cOvw3sk52TiaPXy8exEZRgcRjuY8I

