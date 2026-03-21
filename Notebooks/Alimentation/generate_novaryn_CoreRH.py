

import csv
import random
import os
from datetime import date, timedelta
from collections import defaultdict


try:
    from faker import Faker
    fake = Faker("fr_FR")
    fake.seed_instance(42)
    FAKER_AVAILABLE = True
except ImportError:
    FAKER_AVAILABLE = False
    print("[WARN] Faker not installed — pip install faker python-dateutil")

try:
    from dateutil.relativedelta import relativedelta
    DATEUTIL_AVAILABLE = True
except ImportError:
    DATEUTIL_AVAILABLE = False

random.seed(42)

OUTPUT_DIR = "./novaryn_data_v3"
os.makedirs(OUTPUT_DIR, exist_ok=True)

TODAY = date(2026, 3, 9)   # Real reference date for 2026 market salary comparison

# ─────────────────────────────────────────────────────────────
# CONSTANTS  (all values match DB CHECK constraints exactly)
# ─────────────────────────────────────────────────────────────

# chk_status
STATUS_ACTIVE     = "Active"
STATUS_INACTIVE   = "Inactive"
STATUS_LEAVE      = "Leave"
STATUS_TERMINATED = "Terminated"

# chk_gender
GENDER_M = "M"
GENDER_F = "F"

# chk_pay_type_sf
PAY_TYPE_SALARY     = "Salary"
PAY_TYPE_COMMISSION = "Commission"

# chk_pay_group_sf
PG_EXECUTIVE = "FR_EXECUTIVE"
PG_EXEMPT    = "FR_EXEMPT"
PG_NON_EXEMPT= "FR_NON_EXEMPT"
PG_INTERN    = "FR_INTERN"

# chk_contract_type
CONTRACT_PERMANENT  = "Permanent"
CONTRACT_FIXED      = "Fixed-term"
CONTRACT_INTERNSHIP = "Internship"
CONTRACT_APPRENTICE = "Apprenticeship"

# chk_event_reason_job
EV_HIRING      = "Hiring"
EV_PROMOTION   = "Promotion"
EV_TRANSFER    = "Transfer"
EV_DATA_CHANGE = "Data Change"

# chk_group_job
GRP_EXECUTIVE  = "Executive"
GRP_TECHNICAL  = "Technical"
GRP_MARKETING  = "Marketing"
GRP_OPERATIONS = "Operations"
GRP_SUPPORT    = "Support"

# chk_business_unit
BU_ENGINEERING = "Engineering"
BU_SALES       = "Sales"
BU_MARKETING   = "Marketing"
BU_FINANCE     = "Finance"
BU_HR          = "HR"
BU_PRODUCT     = "Product"

# chk_hire_source
HIRE_SOURCES = ["LinkedIn","Indeed","Referral","Headhunter",
                "Company Website","Welcome to the Jungle","Other"]
HIRE_WEIGHTS = [0.28, 0.12, 0.18, 0.15, 0.12, 0.10, 0.05]

# chk_pay_component_name  (EXACTLY these 4 values)
PC_BASE_SALARY        = "Base Salary"
PC_CAR_ALLOWANCE      = "Car Allowance"
PC_HOUSING_ALLOWANCE  = "Housing Allowance"
PC_TRANSPORT_ALLOWANCE= "Transport Allowance"

# chk_pay_rec_details
FREQ_MONTHLY = "Monthly"
FREQ_ANNUAL  = "Annual"

# chk_lms_status_real
LMS_COMP  = "COMP"
LMS_ENR   = "ENR"
LMS_FAIL  = "FAIL"
LMS_EXMPT = "EXMPT"

# chk_training_type_real
TT_COURSE     = "COURSE"
TT_ELEARN     = "ELEARN"
TT_OJT        = "OJT"
TT_COMPLIANCE = "COMPLIANCE"

# chk_non_rec_comp_list
NR_SPOTBONUS = "SPOTBONUS"
NR_REFERRAL  = "REFERRAL"
NR_SIGNON    = "SIGNON"
NR_PERFAWARD = "PERFAWARD"
NR_MILESTONE = "MILESTONE"
NR_RELOCATION= "RELOCATION"

# chk_perf_potential
POT_LOW    = "Low"
POT_MEDIUM = "Medium"
POT_HIGH   = "High"

# chk_term_event_reason_sap
TERM_RESIGNATION = "RESIGNATION"
TERM_INVOLUNTARY = "INVOLUNTARY"
TERM_RETIREMENT  = "RETIREMENT"
TERM_NON_RENEWAL = "NON_RENEWAL"
TERM_DEATH       = "DEATH"

# chk_ok_to_rehire  → 'YES' or 'NO' (not boolean)
REHIRE_YES = "YES"
REHIRE_NO  = "NO"

# chk_top_performer → 'Yes' or 'No' (not boolean)
TOP_YES = "Yes"
TOP_NO  = "No"

# ─────────────────────────────────────────────────────────────
# CITY / STATE  (chk_city_state_fixed — ALL 6 pairs hardcoded)
# ─────────────────────────────────────────────────────────────
CITIES = [
    # (city, state, zip, headcount)
    ("Paris",     "Île-de-France",               "75001", 110),
    ("Lyon",      "Auvergne-Rhône-Alpes",         "69001",  45),
    ("Toulouse",  "Occitanie",                    "31000",  35),
    ("Marseille", "Provence-Alpes-Côte d'Azur",   "13001",  28),
    ("Bordeaux",  "Nouvelle-Aquitaine",           "33000",  20),
    ("Lille",     "Hauts-de-France",              "59000",  12),
]

# ─────────────────────────────────────────────────────────────
# JOB CATALOGUE
# (base_code, title, BU, group_job, job_family,
#  annual_sal_min, annual_sal_max, headcount)
#
# annual_sal_min / annual_sal_max = ANNUAL gross salary in EUR
# ─────────────────────────────────────────────────────────────
JOB_CATALOGUE = [
    # ── Engineering ───────────────────────────────────────────
    ("BACK-ENG",  "Back-end Engineer",        BU_ENGINEERING,GRP_TECHNICAL,  "Software Engineering",  40000,  98000, 20),
    ("FRONT-ENG", "Front-end Engineer",       BU_ENGINEERING,GRP_TECHNICAL,  "Software Engineering",  38000,  90000, 14),
    ("FULL-ENG",  "Full Stack Engineer",      BU_ENGINEERING,GRP_TECHNICAL,  "Software Engineering",  43000, 105000, 16),
    ("DEVOPS-ENG","DevOps / SRE Engineer",    BU_ENGINEERING,GRP_TECHNICAL,  "Infrastructure",        46000, 115000, 12),
    ("INFRA-ENG", "Cloud Architect",          BU_ENGINEERING,GRP_TECHNICAL,  "Infrastructure",        70000, 150000,  8),
    ("QA-ENG",    "QA / Test Engineer",       BU_ENGINEERING,GRP_TECHNICAL,  "Quality Assurance",     36000,  82000, 10),
    ("SECU-ENG",  "Security Engineer",        BU_ENGINEERING,GRP_TECHNICAL,  "Cybersecurity",         46000, 118000,  8),
    ("ML-ENG",    "ML / AI Engineer",         BU_ENGINEERING,GRP_TECHNICAL,  "AI & Machine Learning", 50000, 130000, 14),
    ("DATA-ENG",  "Data Engineer",            BU_ENGINEERING,GRP_TECHNICAL,  "Data & Analytics",      43000, 105000, 12),
    ("DATA-SCI",  "Data Scientist",           BU_ENGINEERING,GRP_TECHNICAL,  "AI & Machine Learning", 46000, 118000, 10),
    # ── Product ───────────────────────────────────────────────
    ("PM-PROD",   "Product Manager",          BU_PRODUCT,    GRP_TECHNICAL,  "Product Management",    50000, 122000, 12),
    ("PO-PROD",   "Product Owner",            BU_PRODUCT,    GRP_TECHNICAL,  "Product Management",    40000,  92000, 10),
    ("UX-PROD",   "UX/UI Designer",           BU_PRODUCT,    GRP_TECHNICAL,  "Design",                36000,  86000,  8),
    ("SCRM-PROD", "Scrum Master",             BU_PRODUCT,    GRP_OPERATIONS, "Agile Methodology",     42000,  96000,  6),
    # ── Sales ─────────────────────────────────────────────────
    ("AM-SALES",  "Account Manager",          BU_SALES,      GRP_OPERATIONS, "Enterprise Sales",      36000,  95000, 14),
    ("BD-SALES",  "Business Developer",       BU_SALES,      GRP_OPERATIONS, "Sales Development",     33000,  82000, 10),
    ("CSM-SALES", "Customer Success Manager", BU_SALES,      GRP_OPERATIONS, "Customer Success",      36000,  82000, 10),
    ("PRE-SALES", "Pre-Sales Engineer",       BU_SALES,      GRP_TECHNICAL,  "Sales Engineering",     43000, 102000,  6),
    ("SMGR-SALES","Sales Manager",            BU_SALES,      GRP_OPERATIONS, "Sales Management",      55000, 128000,  4),
    # ── Marketing ─────────────────────────────────────────────
    ("CONT-MKT",  "Content Manager",          BU_MARKETING,  GRP_MARKETING,  "Content & Comms",       32000,  70000,  8),
    ("GROWTH-MKT","Growth Manager",           BU_MARKETING,  GRP_MARKETING,  "Growth Marketing",      36000,  80000,  6),
    ("BRAND-MKT", "Brand Manager",            BU_MARKETING,  GRP_MARKETING,  "Brand Management",      38000,  86000,  6),
    ("PMM-MKT",   "Product Marketing Manager",BU_MARKETING,  GRP_MARKETING,  "Product Marketing",     40000,  92000,  5),
    # ── Finance ───────────────────────────────────────────────
    ("FA-FIN",    "Financial Analyst",        BU_FINANCE,    GRP_OPERATIONS, "Finance",               38000,  90000,  8),
    ("CTRL-FIN",  "Financial Controller",     BU_FINANCE,    GRP_OPERATIONS, "Finance",               46000, 108000,  5),
    ("ADMIN-OP",  "Operations Manager",       BU_FINANCE,    GRP_OPERATIONS, "Operations",            34000,  78000,  6),
    # ── HR ────────────────────────────────────────────────────
    ("HRBP-HR",   "HR Business Partner",      BU_HR,         GRP_SUPPORT,    "Human Resources",       38000,  88000,  8),
    ("TA-HR",     "Talent Acquisition Lead",  BU_HR,         GRP_SUPPORT,    "Talent Acquisition",    36000,  82000,  6),
    ("PAYROLL-OP","Payroll Specialist",        BU_HR,         GRP_OPERATIONS, "Payroll",               30000,  68000,  4),
    # ── C-Suite (1 per role, all in Paris) ────────────────────
    ("CTO",  "Chief Technology Officer", BU_ENGINEERING,GRP_EXECUTIVE,"Executive",120000, 220000, 1),
    ("CPO",  "Chief Product Officer",    BU_PRODUCT,    GRP_EXECUTIVE,"Executive",112000, 210000, 1),
    ("CMO",  "Chief Marketing Officer",  BU_MARKETING,  GRP_EXECUTIVE,"Executive",108000, 200000, 1),
    ("CFO",  "Chief Financial Officer",  BU_FINANCE,    GRP_EXECUTIVE,"Executive",118000, 215000, 1),
    ("CHRO", "Chief HR Officer",         BU_HR,         GRP_EXECUTIVE,"Executive",102000, 188000, 1),
    ("CSO",  "Chief Sales Officer",      BU_SALES,      GRP_EXECUTIVE,"Executive",118000, 210000, 1),
]

EXECUTIVE_CODES = {"CTO","CPO","CMO","CFO","CHRO","CSO"}

DIVISION_MAP = {
    BU_ENGINEERING: "Technology",
    BU_PRODUCT:     "Technology",
    BU_SALES:       "Commercial",
    BU_MARKETING:   "Commercial",
    BU_FINANCE:     "Finance & Administration",
    BU_HR:          "People & Culture",
}

# ─────────────────────────────────────────────────────────────
# LMS COURSES
# (courseId, title, type, credit_hours, base_cost_EUR)
# ─────────────────────────────────────────────────────────────
MANDATORY_COURSES = [
    ("GDPR-001",    "RGPD & Protection des Données",    TT_COMPLIANCE, 2.0,  200),
    ("HEALTH-001",  "Santé & Sécurité au Travail",       TT_COMPLIANCE, 4.0,  250),
    ("FIRE-001",    "Sécurité & Évacuation Incendie",    TT_COMPLIANCE, 1.0,  100),
    ("DEI-001",     "Égalité Femmes-Hommes",             TT_COMPLIANCE, 3.0,  180),
    ("FRAUD-001",   "Prévention Fraude & Corruption",    TT_COMPLIANCE, 2.0,  150),
    ("ETHICS-001",  "Code de Déontologie Novaryn Tech",  TT_COMPLIANCE, 1.5,  120),
]

ELECTIVE_COURSES = [
    ("SCRUM-001",  "Scrum Fundamentals",                TT_ELEARN, 12.0,  600),
    ("LEAD-001",   "Leadership & Management",           TT_COURSE, 20.0, 1500),
    ("PYTHON-001", "Python for Data Science",           TT_ELEARN, 24.0, 1000),
    ("AWS-001",    "AWS Cloud Practitioner",            TT_ELEARN, 30.0, 1800),
    ("AZURE-001",  "Microsoft Azure Fundamentals",      TT_ELEARN, 28.0, 1600),
    ("SQL-001",    "Advanced SQL for Analytics",        TT_ELEARN, 16.0,  800),
    ("REACT-001",  "React & TypeScript Masterclass",    TT_ELEARN, 36.0, 1200),
    ("K8S-001",    "Kubernetes Fundamentals",           TT_ELEARN, 24.0, 1100),
    ("ML-001",     "Machine Learning Fundamentals",     TT_ELEARN, 40.0, 1600),
    ("PM-001",     "Product Management Essentials",     TT_COURSE, 20.0, 1200),
    ("SAFE-001",   "SAFe Agile Practitioner",           TT_COURSE, 16.0, 1400),
    ("COMM-001",   "Communication & Public Speaking",   TT_OJT,     8.0,  400),
    ("EXCEL-001",  "Excel Avancé & Reporting",          TT_ELEARN,  8.0,  400),
]

# ─────────────────────────────────────────────────────────────
# FALLBACK NAME LISTS  (used when Faker is not installed)
# ─────────────────────────────────────────────────────────────
_FIRST_M = [
    "Alexandre","Antoine","Baptiste","Benjamin","Clément","David","Édouard",
    "Florian","Gabriel","Hugo","Julien","Kevin","Laurent","Maxime","Nathan",
    "Nicolas","Olivier","Paul","Pierre","Quentin","Raphaël","Sébastien",
    "Thomas","Vincent","Yann","Lucas","Théo","Matthieu","Romain","Arthur",
    "Mehdi","Karim","Sofiane","Yanis","Nabil","Amine","Ibrahim","Adrien",
    "Charles","François","Louis","Axel","Dylan","Ethan","Alexis","Dorian",
]
_FIRST_F = [
    "Alice","Amélie","Anaïs","Aurélie","Camille","Charlotte","Chloé","Clara",
    "Clémence","Élise","Emma","Eva","Inès","Julie","Juliette","Laura","Léa",
    "Lucie","Manon","Marie","Mathilde","Mélanie","Nina","Noémie","Pauline",
    "Romane","Sarah","Sophia","Sophie","Yasmine","Amina","Fatima","Kenza",
    "Lina","Nadia","Rania","Céline","Diane","Estelle","Florence","Lisa",
    "Morgane","Océane","Hélène","Isabelle","Jessica","Karima","Laure",
]
_LAST = [
    "Martin","Bernard","Dubois","Thomas","Robert","Richard","Petit","Durand",
    "Leroy","Moreau","Simon","Laurent","Lefebvre","Michel","Garcia","David",
    "Bertrand","Roux","Vincent","Fournier","Morel","Girard","André","Lefèvre",
    "Mercier","Dupont","Lambert","Bonnet","François","Martinez","Legrand",
    "Garnier","Faure","Rousseau","Blanc","Guérin","Muller","Henry","Roussel",
    "Nicolas","Perrin","Morin","Mathieu","Clement","Gauthier","Dumont",
    "Lopez","Fontaine","Chevalier","Robin","Masson","Sanchez","Giraud",
    "Nguyen","Benali","Belhaj","Mansouri","Chaouche","Belkacem",
    "Ndiaye","Diallo","Koné","Traore","Sow","Ba","Diop","Touré",
]

# ─────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────

def _normalize(s: str) -> str:
    """Lowercase + strip accents for username / email generation."""
    return (s.lower()
            .replace(" ","").replace("-","").replace("'","")
            .replace("é","e").replace("è","e").replace("ê","e")
            .replace("à","a").replace("â","a").replace("î","i")
            .replace("ô","o").replace("û","u").replace("ù","u")
            .replace("ç","c").replace("ë","e").replace("ï","i")
            .replace("ü","u"))

def faker_first_male():
    return fake.first_name_male() if FAKER_AVAILABLE else random.choice(_FIRST_M)

def faker_first_female():
    return fake.first_name_female() if FAKER_AVAILABLE else random.choice(_FIRST_F)

def faker_last():
    return fake.last_name() if FAKER_AVAILABLE else random.choice(_LAST)

def rand_date(start: date, end: date) -> date:
    """Safe random date — always returns `end` if start > end."""
    if start >= end:
        return end
    if FAKER_AVAILABLE:
        return fake.date_between(start_date=start, end_date=end)
    return start + timedelta(days=random.randint(0, (end - start).days))

def years_since(d: date) -> float:
    if DATEUTIL_AVAILABLE:
        rd = relativedelta(TODAY, d)
        return rd.years + rd.months / 12.0
    return (TODAY - d).days / 365.25

def add_years(d: date, y: int) -> date:
    if DATEUTIL_AVAILABLE:
        return d + relativedelta(years=y)
    return d + timedelta(days=int(y * 365.25))

LEVEL_PREFIX = {0: "", 1: "CONF-", 2: "SR-", 3: "LEAD-"}

def assign_entry_level(is_exec: bool) -> int:
    """
    The level at which an employee was HIRED — reflects experience
    accumulated at previous companies before joining Novaryn Tech.
      0 = Junior   ~45%  fresh grads / early career
      1 = Confirmé ~30%  3-5 yrs elsewhere, hired as Confirmé
      2 = Senior   ~18%  6-9 yrs elsewhere, hired as Senior
      3 = Lead      ~7%  9+ yrs, hired as principal / tech lead
    Executives are always hired at Lead.
    """
    if is_exec:
        return 3
    return random.choices([0, 1, 2, 3], [0.45, 0.30, 0.18, 0.07])[0]

def current_level(hire_date: date, entry_level: int, is_exec: bool) -> int:
    """
    Current seniority = entry_level + promotions earned AT Novaryn Tech.
    Each step requires ~3 years of tenure here (capped at Lead = 3).
    Examples:
      Hired as Junior (0) -> 3 yrs -> Confirmé (1) -> 6 yrs -> Senior (2)
      Hired as Senior (2) -> 3 yrs -> Lead (3)
      Hired as Lead   (3) -> stays Lead
    """
    if is_exec:
        return 3
    yrs_at_novaryn    = years_since(hire_date)
    promotions_earned = int(yrs_at_novaryn // 3)
    return min(3, entry_level + promotions_earned)

def _salary_for_level(sal_min: int, sal_max: int, level: int) -> float:
    breakpoints = {0: 0.0, 1: 0.30, 2: 0.65, 3: 1.0}
    base = sal_min + (sal_max - sal_min) * breakpoints[level]
    return round(base * random.uniform(0.93, 1.07), 2)

def annual_salary(sal_min: int, sal_max: int, lvl: int) -> float:
    """Current gross annual salary (EUR) — single source of truth."""
    return _salary_for_level(sal_min, sal_max, lvl)

def hire_salary(sal_min: int, sal_max: int, entry_lvl: int) -> float:
    """Gross annual salary on DAY 1, based on entry_level."""
    return _salary_for_level(sal_min, sal_max, entry_lvl)

def write_csv(filename: str, fields: list, rows: list) -> str:
    path = os.path.join(OUTPUT_DIR, filename)
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore",
                           restval="")        # None → "" in every field
        w.writeheader()
        w.writerows(rows)
    print(f"  ✓  {filename:<48} {len(rows):>5} rows")
    return path

# ─────────────────────────────────────────────────────────────
# PHASE 1 — BUILD RAW EMPLOYEE RECORDS
# ─────────────────────────────────────────────────────────────

def build_employees() -> list:
    # Expand catalogue to exactly 250 slots
    pool = []
    for entry in JOB_CATALOGUE:
        for _ in range(entry[7]):
            pool.append(entry)
    random.shuffle(pool)
    pool = pool[:250]

    # City assignment pool (ordered, weight-based)
    city_pool = []
    for city, state, zipcode, count in CITIES:
        city_pool.extend([(city, state, zipcode)] * count)
    random.shuffle(city_pool)

    usernames, emails = set(), set()
    employees = []

    for i, entry in enumerate(pool):
        base_code, title, bu, grp, jf, sal_min, sal_max, _ = entry
        is_exec = base_code in EXECUTIVE_CODES

        # Store salary band — needed by gen_compensation_info to compute
        # the correct salary at each intermediate promotion level
        # (CONF salary, SR salary, LEAD salary) not just hire and current.

        e = {}
        e["user_id"]  = 1001 + i
        e["gender"]   = random.choices([GENDER_M, GENDER_F], [62, 38])[0]
        e["first"]    = faker_first_male() if e["gender"] == GENDER_M else faker_first_female()
        e["last"]     = faker_last()

        # Username — guaranteed lowercase & unique (chk_username_lower)
        base_u = _normalize(e["first"][0] + e["last"])[:18]
        uname  = base_u
        ctr    = 1
        while uname in usernames:
            uname = base_u + str(ctr)
            ctr  += 1
        usernames.add(uname)
        e["username"] = uname

        # Email — @novaryn-tech.com (chk_email_domain)
        fn    = _normalize(e["first"])
        ln    = _normalize(e["last"])
        email = f"{fn}.{ln}@novaryn-tech.com"
        ctr   = 1
        while email in emails:
            email = f"{fn}.{ln}{ctr}@novaryn-tech.com"
            ctr  += 1
        emails.add(email)
        e["email"] = email

        # Hire date ≤ TODAY  (chk_hire_date)
        e["hire_date"] = rand_date(date(2012, 1, 1), date(2025, 12, 31))

        # City — executives always in Paris
        if is_exec:
            e["city"], e["state"], e["zip"] = "Paris", "Île-de-France", "75001"
        else:
            e["city"], e["state"], e["zip"] = city_pool[i % len(city_pool)]

        e["location"] = f"Novaryn Tech - {e['city']}"
        e["country"]  = "France"

        e["base_code"]  = base_code
        e["job_title"]  = title
        e["bu"]         = bu
        e["group_job"]  = grp
        e["job_family"] = jf
        e["division"]   = DIVISION_MAP[bu]
        e["is_exec"]    = is_exec

        # ── ENTRY LEVEL: experience brought from previous companies ───
        # Someone can be hired directly as Senior or Lead even if they
        # just joined Novaryn Tech — they already had that level elsewhere.
        e["entry_level"]  = assign_entry_level(is_exec)

        # ── PRIOR EXPERIENCE: years worked BEFORE joining Novaryn ──────
        # Derived from entry_level so it is coherent with the level at hire.
        # These ranges mirror the scraper brackets (0,1,2,3,4,5,8,10,15,30)
        # so the compa-ratio join works without extra transformation.
        PRIOR_EXP_RANGE = {
            0: (0,  2),   # Junior   — fresh grad or very early career
            1: (3,  5),   # Confirmé — a few years elsewhere
            2: (6,  9),   # Senior   — solid mid-career
            3: (10, 20),  # Lead     — experienced hire
        }
        lo, hi = PRIOR_EXP_RANGE[e["entry_level"]]
        e["prior_exp_years"] = random.randint(lo, hi)

        # ── CURRENT LEVEL: entry_level + promotions earned at Novaryn ──
        # Every 3 years at Novaryn earns one level up (capped at Lead=3)
        lvl               = current_level(e["hire_date"], e["entry_level"], is_exec)
        e["sen_level"]    = lvl
        e["sen_prefix"]   = LEVEL_PREFIX[lvl]

        # job_code placeholder — overwritten in Phase 3 from latest job_info row
        e["job_code"] = base_code if is_exec else (LEVEL_PREFIX[lvl] + base_code)

        # Status (chk_status)
        r = random.random()
        if   r < 0.80: e["status"] = STATUS_ACTIVE
        elif r < 0.87: e["status"] = STATUS_LEAVE
        elif r < 0.94: e["status"] = STATUS_INACTIVE
        else:          e["status"] = STATUS_TERMINATED

        # Contract — interns/apprentices only if entry_level = 0
        if e["entry_level"] == 0 and not is_exec and random.random() < 0.08:
            e["contract_name"] = random.choice([CONTRACT_INTERNSHIP, CONTRACT_APPRENTICE])
        elif random.random() < 0.83:
            e["contract_name"] = CONTRACT_PERMANENT
        else:
            e["contract_name"] = CONTRACT_FIXED

        # Pay group — based on CURRENT level (chk_pay_group_sf)
        if is_exec:
            e["pay_group"] = PG_EXECUTIVE
        elif lvl >= 1:
            e["pay_group"] = PG_EXEMPT
        elif e["contract_name"] in (CONTRACT_INTERNSHIP, CONTRACT_APPRENTICE):
            e["pay_group"] = PG_INTERN
        else:
            e["pay_group"] = PG_NON_EXEMPT

        # Pay type
        e["pay_type"] = (PAY_TYPE_COMMISSION
                         if bu == BU_SALES and lvl >= 1 and random.random() < 0.45
                         else PAY_TYPE_SALARY)

        # ── SALARY: current annual (based on current level) ────
        e["annual_salary"]    = annual_salary(sal_min, sal_max, lvl)

        # ── SALARY: at hire (based on entry level) ─────────────
        # Always ≤ annual_salary. When entry_level == current_level
        # (no promotions yet at Novaryn), cap with min() to absorb jitter.
        e["hire_annual_sal"]  = min(
            hire_salary(sal_min, sal_max, e["entry_level"]),
            e["annual_salary"]
        )

        # ── BONUS % (0–100, chk_bonus_cap) ─────────────────────
        if is_exec:    e["bonus_pct"] = round(random.uniform(20, 35), 2)
        elif lvl >= 2: e["bonus_pct"] = round(random.uniform(10, 18), 2)
        elif lvl == 1: e["bonus_pct"] = round(random.uniform(5,  12), 2)
        else:          e["bonus_pct"] = round(random.uniform(0,   5), 2)

        e["target_incentive"] = round(e["annual_salary"] * e["bonus_pct"] / 100, 2)

        # ── CAR ALLOWANCE (annual EUR, chk_car_allowance_policy) ─
        if e["pay_group"] == PG_INTERN:
            e["car_allowance_annual"] = 0.00
        elif is_exec:
            e["car_allowance_annual"] = round(random.choice([600,700,750,800]) * 12, 2)
        elif lvl >= 2 and bu in (BU_SALES, BU_ENGINEERING) and random.random() < 0.55:
            e["car_allowance_annual"] = round(random.choice([350,400,450,500]) * 12, 2)
        else:
            e["car_allowance_annual"] = 0.00

        # Salary band — kept for promotion-linked comp records in Phase 4
        e["sal_min"] = sal_min
        e["sal_max"] = sal_max

        # Hire source
        e["hire_source"] = random.choices(HIRE_SOURCES, HIRE_WEIGHTS)[0]

        # Payroll ID — globally unique (uq_payroll_id)
        e["payroll_id"] = f"PAY-NVT-{e['user_id']:04d}"

        # Placeholders — filled in Phase 2
        e["manager_id"] = None
        e["hr_id"]      = None

        employees.append(e)

    return employees

# ─────────────────────────────────────────────────────────────
# PHASE 2 — ASSIGN MANAGERS & HR
#
# Rules enforced here:
#   • manager must be in the SAME CITY as the employee
#   • manager must have MORE seniority (sen_level) than the report
#   • manager must NOT be Terminated
#   • manager must NOT be the employee themselves (chk_manager_self)
#   • hr must NOT be the employee themselves (chk_hr_self)
#   • terminated employees are NEVER assigned as manager/hr
# ─────────────────────────────────────────────────────────────

def assign_managers_and_hr(employees: list):
    # Eligible managers: non-terminated, sen_level >= 1, grouped by (city, bu)
    mgr_by_city_bu = defaultdict(list)
    for e in employees:
        if e["status"] != STATUS_TERMINATED and e["sen_level"] >= 1:
            mgr_by_city_bu[(e["city"], e["bu"])].append(e)

    # Fallback: non-terminated, sen_level >= 2, any BU, same city
    mgr_by_city = defaultdict(list)
    for e in employees:
        if e["status"] != STATUS_TERMINATED and e["sen_level"] >= 2:
            mgr_by_city[e["city"]].append(e)

    # HR staff (non-terminated HR department employees)
    hr_pool = [e for e in employees
               if e["bu"] == BU_HR and e["status"] != STATUS_TERMINATED]
    if not hr_pool:
        hr_pool = [e for e in employees if e["status"] != STATUS_TERMINATED]

    for e in employees:
        # ── Manager assignment ──────────────────────────────
        # 1. Same city + same BU + strictly more seniority + not self
        candidates = [
            m for m in mgr_by_city_bu[(e["city"], e["bu"])]
            if m["user_id"] != e["user_id"]
            and m["sen_level"] > e["sen_level"]
        ]
        # 2. Fallback: same city + any BU + strictly more seniority
        if not candidates:
            candidates = [
                m for m in mgr_by_city[e["city"]]
                if m["user_id"] != e["user_id"]
                and m["sen_level"] > e["sen_level"]
            ]
        # 3. Fallback: same city + same level (peer-manager for juniors)
        if not candidates:
            candidates = [
                m for m in mgr_by_city[e["city"]]
                if m["user_id"] != e["user_id"]
            ]
        if candidates:
            e["manager_id"] = random.choice(candidates)["user_id"]

        # ── HR assignment ────────────────────────────────────
        hr_cands = [h for h in hr_pool if h["user_id"] != e["user_id"]]
        if hr_cands:
            e["hr_id"] = random.choice(hr_cands)["user_id"]


def assign_executive_hierarchy(employees: list):
    """
    C-suite employees are the top of the org chart: they have no manager.
    Each executive's manager_id is set to None (empty in CSV).

    This must be called AFTER assign_managers_and_hr so that the general
    manager-assignment pass (which picks random seniors) is overridden here.

    NOTE: There is no CEO in the catalogue. All six C-level roles are
    peers at the apex of the hierarchy.
    """
    for e in employees:
        if e["base_code"] in EXECUTIVE_CODES:
            e["manager_id"] = None
# ─────────────────────────────────────────────────────────────
# PHASE 3 — BUILD JOB INFO ROWS & SYNC job_code BACK
#
# After building all career events, the LATEST job_code from
# job_info is written back to basic_user_info.job_code.
# ─────────────────────────────────────────────────────────────

def build_job_info_rows(employees: list) -> list:
    rows = []
    contract_counter = 1

    def add_event(rows_out, emp, seq_ref, ctr_ref,
                  start_date, job_code, event_reason,
                  productivity, use_contract_id=False):
        """
        Append one job_info event row.
        seq_ref and ctr_ref are single-element lists used as mutable
        integer references (avoids nonlocal across loop iterations).
        """
        rows_out.append({
            "user_id":              emp["user_id"],
            "start_date":           start_date,
            "seq_number":           seq_ref[0],
            "event_reason":         event_reason,
            "businessunit":         emp["bu"],
            "company":              "Novaryn Tech",
            "location":             emp["location"],
            "division":             emp["division"],
            "job_code":             job_code,
            "job_family":           emp["job_family"],
            "group_job":            emp["group_job"],
            "hiresource":           emp["hire_source"] if event_reason == EV_HIRING else "Other",
            "contract_id":          f"CTR-NVT-{ctr_ref[0]:05d}" if use_contract_id else "",
            "contract_name":        emp["contract_name"],
            "degreeofproductivity": round(productivity, 2),
        })
        if use_contract_id:
            ctr_ref[0] += 1

    for e in employees:
        yrs      = years_since(e["hire_date"])
        seq_ref  = [1]           # mutable int ref — avoids redefining add_event per loop
        ctr_ref  = [contract_counter]
        is_exec  = e["is_exec"]
        base     = e["base_code"]
        entry    = e["entry_level"]   # level at which they were HIRED

        # ── Hiring event: job_code reflects entry_level, NOT Junior by default ──
        # If someone was hired as Senior, their first job_info row shows SR-BACK-ENG
        hire_code = base if is_exec else (LEVEL_PREFIX[entry] + base)
        add_event(rows, e, seq_ref, ctr_ref,
                  e["hire_date"], hire_code, EV_HIRING,
                  random.uniform(65, 90), use_contract_id=True)

        if not is_exec:
            # ── Promotions only happen for levels ABOVE entry_level ──────────
            # Each promotion at Novaryn happens ~3 yrs after the previous level
            # was reached (whether at hire or via previous promotion here).
            #
            # Example: hired as SR (entry=2)
            #   → no CONF or SR promotions (already had those)
            #   → LEAD promotion after 3 yrs at Novaryn (yrs >= 3)
            #
            # Example: hired as Junior (entry=0)
            #   → CONF after 3 yrs, SR after 6 yrs, LEAD after 9 yrs

            promo_schedule = []   # (target_level, yrs_needed_at_novaryn)
            for target_lvl in range(entry + 1, 4):
                # years of Novaryn tenure needed to reach this level
                yrs_needed = (target_lvl - entry) * 3
                promo_schedule.append((target_lvl, yrs_needed))

            for target_lvl, yrs_needed in promo_schedule:
                if yrs >= yrs_needed and random.random() < 0.65:
                    seq_ref[0] += 1
                    jitter = timedelta(days=random.randint(-30, 30))
                    d = add_years(e["hire_date"], yrs_needed) + jitter
                    if d >= TODAY:
                        d = TODAY - timedelta(days=30)
                    add_event(rows, e, seq_ref, ctr_ref,
                              d, LEVEL_PREFIX[target_lvl] + base,
                              EV_PROMOTION, random.uniform(72 + target_lvl*2, 94 + target_lvl*2))

        # ── Occasional transfer / data change (~10%) ──────────────────────────
        if random.random() < 0.10 and yrs >= 1:
            seq_ref[0] += 1
            last_row = [r for r in rows if r["user_id"] == e["user_id"]][-1]
            d = last_row["start_date"] + timedelta(days=random.randint(200, 900))

            if d < TODAY:

                event = random.choice([EV_TRANSFER, EV_DATA_CHANGE])

                if event == EV_TRANSFER:

                    CITY_TRANSFERS = {
                        "Paris": ["Lyon", "Bordeaux", "Toulouse"],
                        "Lyon": ["Paris", "Marseille"],
                        "Toulouse": ["Paris", "Bordeaux"],
                        "Marseille": ["Lyon"],
                        "Bordeaux": ["Paris", "Toulouse"],
                        "Lille": ["Paris"]
                    }

                    possible = CITY_TRANSFERS.get(e["city"], [])

                    if possible:
                        new_city = random.choice(possible)
                        # Resolve state + zip from CITIES catalogue
                        for c in CITIES:
                            if c[0] == new_city:
                                new_city, new_state, new_zip, _ = c
                                break
                        # Update employee record — city update lives ONLY here,
                        # inside the guard, so we never reference undefined vars
                        e["city"]     = new_city
                        e["state"]    = new_state
                        e["zip"]      = new_zip
                        e["location"] = f"Novaryn Tech - {new_city}"

                add_event(rows, e, seq_ref, ctr_ref,
                          d, last_row["job_code"],
                          event, random.uniform(72, 97))

        contract_counter = ctr_ref[0]  # sync global counter after processing each employee

    return rows

def sync_job_codes(employees: list, job_rows: list):
    """
    After build_job_info_rows, sync three fields back onto every employee dict:

      • job_code   — from the LATEST job_info row (core business rule)
      • sen_level  — re-derived from the actual latest job_code prefix,
                     so it matches what really happened (some promotions were
                     skipped by the 65% random gate in build_job_info_rows)
      • sen_prefix — kept in sync with the updated sen_level

    This ensures basic_user_info, sen_level, and sen_prefix are
    all consistent with the authoritative job_info history.
    """
    # Reverse-map prefix → level
    prefix_to_level = {v: k for k, v in LEVEL_PREFIX.items()}

    latest = {}   # user_id → (start_date, job_code)
    for row in job_rows:
        uid = row["user_id"]
        if uid not in latest or row["start_date"] > latest[uid][0]:
            latest[uid] = (row["start_date"], row["job_code"])

    for e in employees:
        if e["user_id"] not in latest:
            continue
        jc = latest[e["user_id"]][1]
        e["job_code"] = jc

        # Re-derive sen_level from the actual job_code prefix
        if not e["is_exec"]:
            base = e["base_code"]
            raw_prefix = jc[: len(jc) - len(base)]   # strip base_code from end
            e["sen_level"]  = prefix_to_level.get(raw_prefix, e["sen_level"])
            e["sen_prefix"] = LEVEL_PREFIX[e["sen_level"]]

# ─────────────────────────────────────────────────────────────
# CSV GENERATORS — one per PostgreSQL table
# ─────────────────────────────────────────────────────────────

# ── 1. basic_user_info ──────────────────────────────────────
def gen_basic_user_info(employees: list):
    fields = ["user_id","status","username","first_name","last_name","gender",
              "email","hiredate","manager","hr","job_code","division",
              "location","city","state","zip","country",
              "prior_exp_years","tenure_at_novaryn_years","total_exp_years"]
    rows = []
    for e in employees:
        tenure  = round(years_since(e["hire_date"]), 1)
        total   = round(e["prior_exp_years"] + tenure, 1)
        rows.append({
            "user_id":                 e["user_id"],
            "status":                  e["status"],
            "username":                e["username"],
            "first_name":              e["first"],
            "last_name":               e["last"],
            "gender":                  e["gender"],
            "email":                   e["email"],
            "hiredate":                e["hire_date"],
            "manager":                 e["manager_id"] if e["manager_id"] else "",
            "hr":                      e["hr_id"]      if e["hr_id"]      else "",
            "job_code":                e["job_code"],
            "division":                e["division"],
            "location":                e["location"],
            "city":                    e["city"],
            "state":                   e["state"],
            "zip":                     e["zip"],
            "country":                 "France",
            # ── Experience columns (for compa-ratio join with scraper data) ──
            # prior_exp_years       : years worked before joining Novaryn
            # tenure_at_novaryn_years: years since hire_date at Novaryn
            # total_exp_years        : prior + tenure = total career experience
            "prior_exp_years":         e["prior_exp_years"],
            "tenure_at_novaryn_years": tenure,
            "total_exp_years":         total,
        })
    write_csv("01_basic_user_info.csv", fields, rows)

# ── 2. job_info ─────────────────────────────────────────────
def gen_job_info(job_rows: list):
    fields = ["user_id","start_date","seq_number","event_reason","businessunit",
              "company","location","division","job_code","job_family","group_job",
              "hiresource","contract_id","contract_name","degreeofproductivity"]
    write_csv("02_job_info.csv", fields, job_rows)

# ── 3. compensation_info ────────────────────────────────────
def gen_compensation_info(employees: list, job_rows: list):
    """
    SALARY LOGIC — one record per career event:
    ┌─────────────────────────────────────────────────────────────┐
    │  Event         │ Salary used                                │
    │  ─────────────────────────────────────────────────────────  │
    │  Hiring        │ hire_annual_sal  (entry_level band)        │
    │  Each Promotion│ salary for that level (CONF/SR/LEAD band)  │
    │  Annual review │ current annual_salary (latest level)       │
    └─────────────────────────────────────────────────────────────┘
    This ensures that a Lead promoted in 2024 has a 2024 salary
    record at Lead pay — not a 2019 "Data Change" record.
    """
    fields = ["user_id","start_date","event_reason","bonus","bonus_base_amount",
              "carallowance","paygroup","paytype","payrollid","targetincentive"]

    # Build promotion lookup: user_id → [(promo_date, job_code), ...]
    promotions = defaultdict(list)
    for r in job_rows:
        if r["event_reason"] == EV_PROMOTION:
            promotions[r["user_id"]].append((r["start_date"], r["job_code"]))

    # Prefix → level (to compute salary at each promo step)
    prefix_to_level = {v: k for k, v in LEVEL_PREFIX.items()}

    rows      = []
    used_pids = set()
    pid_ctr   = {}  # user_id → counter for unique payroll IDs per employee

    def next_pid(uid):
        pid_ctr[uid] = pid_ctr.get(uid, 0) + 1
        pid = f"PAY-NVT-{uid:04d}" if pid_ctr[uid] == 1 else f"PAY-NVT-{uid:04d}-{pid_ctr[uid]}"
        used_pids.add(pid)
        return pid

    for e in employees:
        sal_min = e["sal_min"]
        sal_max = e["sal_max"]

        # ── Record 1: Hiring ─────────────────────────────────────────
        hire_sal = e["hire_annual_sal"]
        hire_bon = round(e["bonus_pct"] * 0.75, 2)
        rows.append({
            "user_id":           e["user_id"],
            "start_date":        e["hire_date"],
            "event_reason":      EV_HIRING,
            "bonus":             hire_bon,
            "bonus_base_amount": hire_sal,
            "carallowance":      0.00,
            "paygroup":          e["pay_group"],
            "paytype":           e["pay_type"],
            "payrollid":         next_pid(e["user_id"]),
            "targetincentive":   round(hire_sal * hire_bon / 100, 2),
        })

        # ── Records 2…N: one per Promotion ───────────────────────────
        # The salary jumps at each promotion to reflect the new level band.
        # This is how it works in real SAP SF: each job change triggers
        # a compensation change event on the same effective date.
        for promo_date, promo_jc in sorted(promotions[e["user_id"]]):
            base     = e["base_code"]
            raw_pfx  = promo_jc[: len(promo_jc) - len(base)]
            lvl      = prefix_to_level.get(raw_pfx, e["entry_level"])
            promo_sal = min(
                _salary_for_level(sal_min, sal_max, lvl),
                e["annual_salary"]          # never exceed current salary
            )
            # Car allowance unlocks at SR+ for eligible BUs
            car = 0.00
            if lvl >= 2 and e["bu"] in (BU_SALES, BU_ENGINEERING):
                car = e["car_allowance_annual"]

            rows.append({
                "user_id":           e["user_id"],
                "start_date":        promo_date,
                "event_reason":      EV_PROMOTION,
                "bonus":             round(e["bonus_pct"] * (0.80 + lvl * 0.07), 2),
                "bonus_base_amount": promo_sal,
                "carallowance":      car,
                "paygroup":          e["pay_group"],
                "paytype":           e["pay_type"],
                "payrollid":         next_pid(e["user_id"]),
                "targetincentive":   round(promo_sal * e["bonus_pct"] / 100, 2),
            })

        # ── Final record: latest annual review anchored to TODAY ─────
        # Always placed 1–14 months before TODAY so EVERY employee has
        # a 2025/2026 salary record regardless of when their last
        # promotion was.  This is the record used for the compa-ratio.
        if years_since(e["hire_date"]) >= 0.75:
            last_event_date = (
                max(d for d, _ in promotions[e["user_id"]])
                if promotions[e["user_id"]]
                else e["hire_date"]
            )
            # Anchor: between 1 and 14 months before TODAY
            review_date = TODAY - timedelta(days=random.randint(30, 425))
            # Must be strictly after last career event (no backdating)
            if review_date <= last_event_date:
                review_date = last_event_date + timedelta(days=random.randint(30, 90))
            if review_date < TODAY:
                rows.append({
                    "user_id":           e["user_id"],
                    "start_date":        review_date,
                    "event_reason":      EV_DATA_CHANGE,
                    "bonus":             e["bonus_pct"],
                    "bonus_base_amount": e["annual_salary"],   # ← current 2026 salary
                    "carallowance":      e["car_allowance_annual"],
                    "paygroup":          e["pay_group"],
                    "paytype":           e["pay_type"],
                    "payrollid":         next_pid(e["user_id"]),
                    "targetincentive":   e["target_incentive"],
                })

    write_csv("03_compensation_info.csv", fields, rows)
    return rows   # returned so gen_pay_component_recurring can read salaries

# ── 4. pay_component_recurring ──────────────────────────────
def gen_pay_component_recurring(employees: list, job_rows: list, comp_rows: list):
    """
    paycomponentvalue = MONTHLY amount (annual / 12).
    Salaries are read from the already-generated comp_rows so that
    pay_component_recurring and compensation_info are always in sync —
    no independent random calls that would produce different values.
    """
    fields = ["user_id","start_date","pay_component","paycomponentvalue",
              "currency_code","frequency","seq_number"]
    rows = []

    def add_pc(user_id, start_date, component, monthly_value, seq):
        rows.append({
            "user_id":           user_id,
            "start_date":        start_date,
            "pay_component":     component,
            "paycomponentvalue": monthly_value,
            "currency_code":     "EUR",
            "frequency":         FREQ_MONTHLY,
            "seq_number":        seq,
        })

    def write_pay_snapshot(uid, start_dt, monthly_base, car_annual,
                           transport, city, sen_lvl):
        """Write a full set of pay component rows for a given effective date."""
        seq = 1
        add_pc(uid, start_dt, PC_BASE_SALARY,        monthly_base, seq);         seq += 1
        add_pc(uid, start_dt, PC_TRANSPORT_ALLOWANCE, transport,   seq);         seq += 1
        if car_annual > 0:
            add_pc(uid, start_dt, PC_CAR_ALLOWANCE,
                   round(car_annual / 12, 2), seq);                              seq += 1
        if city == "Paris" and sen_lvl >= 2:
            add_pc(uid, start_dt, PC_HOUSING_ALLOWANCE,
                   round(random.uniform(200, 420), 2), seq)

    prefix_to_level = {v: k for k, v in LEVEL_PREFIX.items()}

    # Build promotion lookup  (same as in gen_compensation_info)
    promotions = defaultdict(list)
    for r in job_rows:
        if r["event_reason"] == EV_PROMOTION:
            promotions[r["user_id"]].append((r["start_date"], r["job_code"]))

    for e in employees:
        uid       = e["user_id"]
        transport = round(random.uniform(45, 80), 2)

        # ── Snapshot 1: Hiring ───────────────────────────────────────
        write_pay_snapshot(
            uid, e["hire_date"],
            round(e["hire_annual_sal"] / 12, 2),
            0.00,                                  # no car on day 1
            transport,
            e["city"],
            e["entry_level"],                      # level at hire for housing check
        )

        # ── Snapshots 2…N+1: read salaries from comp_rows (single source) ──
        # This guarantees pay_component_recurring and compensation_info
        # are always in sync — both reference the exact same amounts.
        subsequent = sorted(
            [r for r in comp_rows if r["user_id"] == uid
             and r["start_date"] > e["hire_date"]],
            key=lambda x: x["start_date"]
        )
        prefix_to_level_pc = {v: k for k, v in LEVEL_PREFIX.items()}
        for r in subsequent:
            evt_date  = r["start_date"]
            sal       = float(r["bonus_base_amount"])
            car_ann   = float(r["carallowance"])
            # Determine level from event_reason + comp context
            if r["event_reason"] == EV_PROMOTION:
                # Find the matching job_info row to get the job_code
                matching_jc = next(
                    (j["job_code"] for j in job_rows
                     if j["user_id"] == uid
                     and j["start_date"] == evt_date
                     and j["event_reason"] == EV_PROMOTION),
                    None
                )
                if matching_jc:
                    raw_pfx = matching_jc[: len(matching_jc) - len(e["base_code"])]
                    lvl = prefix_to_level_pc.get(raw_pfx, e["sen_level"])
                else:
                    lvl = e["sen_level"]
            else:
                lvl = e["sen_level"]
            write_pay_snapshot(
                uid, evt_date,
                round(sal / 12, 2),   # ← directly from comp_rows, no re-random
                car_ann,
                transport,
                e["city"],
                lvl,
            )

    write_csv("04_pay_component_recurring.csv", fields, rows)

# ── 5. pay_component_non_recurring ──────────────────────────
def gen_pay_component_non_recurring(employees: list):
    fields = ["user_id","pay_date","pay_component","value",
              "currency_code","notes","operation"]
    rows = []
    used = set()

    def add(uid, pay_date, comp, amount, note):
        key = (uid, str(pay_date), comp)
        if key not in used and amount > 0:
            used.add(key)
            rows.append({
                "user_id":       uid,
                "pay_date":      pay_date,
                "pay_component": comp,
                "value":         round(amount, 2),
                "currency_code": "EUR",
                "notes":         note,
                "operation":     "ADD",
            })

    for e in employees:
        if e["status"] == STATUS_TERMINATED:
            continue
        yrs = years_since(e["hire_date"])

        # Annual PERFAWARD (March payout for previous year)
        for yr in [2022, 2023, 2024, 2025]:
            if date(yr, 1, 1) > e["hire_date"] and random.random() < 0.82:  # strict: must have worked before Jan 1
                add(e["user_id"], date(yr, 3, 15), NR_PERFAWARD,
                    e["target_incentive"] * random.uniform(0.85, 1.15),
                    f"Prime de performance annuelle {yr}")

        # Sign-on bonus for recent hires (< 12 months) — condition was broken in v2
        if yrs < 1:
            pd = e["hire_date"] + timedelta(days=45)
            if pd < TODAY:
                add(e["user_id"], pd, NR_SIGNON,
                    random.uniform(2500, 8000), "Bonus de signature de contrat")

        # Referral bonus (~15% of employees)
        if random.random() < 0.15:
            pd = rand_date(date(2022, 1, 1), date(2025, 12, 31))
            add(e["user_id"], pd, NR_REFERRAL, 2500.00, "Prime de cooptation")

        # Tenure milestones: 5, 10, 15 years
        for milestone in [5, 10, 15]:
            if yrs >= milestone:
                pd = add_years(e["hire_date"], milestone) + timedelta(days=15)
                if pd < TODAY:
                    add(e["user_id"], pd, NR_MILESTONE,
                        1000 * milestone, f"Prime d'ancienneté {milestone} ans")

        # Spot bonus (~8%)
        if random.random() < 0.08:
            pd = rand_date(date(2022, 1, 1), date(2025, 12, 31))
            add(e["user_id"], pd, NR_SPOTBONUS,
                random.uniform(750, 2500), "Prime d'excellence")

        # Relocation bonus for non-Paris → Paris transfers (rare ~3%)
        if e["city"] == "Paris" and yrs >= 1 and random.random() < 0.03:
            pd = e["hire_date"] + timedelta(days=random.randint(30, 180))
            if pd < TODAY:
                add(e["user_id"], pd, NR_RELOCATION,
                    random.uniform(3000, 6000), "Aide à la mobilité géographique")

    write_csv("05_pay_component_non_recurring.csv", fields, rows)

# ── 6. performance_management ───────────────────────────────
def gen_performance_management(employees: list):
    fields = ["user_id","formcontentid","reviewdate","rating","potential",
              "lastpromotiondate","competencyscore","objectivecompletion",
              "istopperformer"]
    rows = []
    used = set()

    for e in employees:
        if e["status"] == STATUS_TERMINATED:
            continue

        for yr in [2022, 2023, 2024, 2025]:
            if date(yr, 6, 1) < e["hire_date"]:  # must have been 6 months by review
                continue
            key = (e["user_id"], f"FORM-{yr}")
            if key in used:
                continue
            used.add(key)

            # Rating correlated to seniority (1.0–5.0, chk_perf_rating)
            base_r = 2.5 + e["sen_level"] * 0.45
            rating = round(min(5.0, max(1.0, base_r + random.gauss(0, 0.5))), 2)

            # Competency score (0–5, chk_competency_score)
            comp_s = round(min(5.0, max(0.0, rating + random.gauss(0, 0.25))), 2)

            # Objective completion (0–100, chk_obj_completion)
            obj_c  = round(min(100.0, max(0.0, (rating/5)*100 + random.gauss(0, 6))), 2)

            # Potential
            potential = (POT_HIGH   if rating >= 4.0 else
                         POT_MEDIUM if rating >= 2.5 else POT_LOW)

            # isTopPerformer → 'Yes' or 'No'  (NOT boolean)
            is_top = TOP_YES if rating >= 4.5 else TOP_NO

            # Last promotion date (chk_last_promo_date: must be ≤ TODAY)
            if e["sen_level"] >= 1:
                lp = add_years(e["hire_date"], e["sen_level"] * 3)
                if lp > TODAY:
                    lp = TODAY - timedelta(days=60)
                last_promo = lp
            else:
                last_promo = ""

            rows.append({
                "user_id":             e["user_id"],
                "formcontentid":       f"FORM-{yr}",
                "reviewdate":          date(yr, 12, 15),
                "rating":              rating,
                "potential":           potential,
                "lastpromotiondate":   last_promo,
                "competencyscore":     comp_s,
                "objectivecompletion": obj_c,
                "istopperformer":      is_top,     # 'Yes' / 'No'
            })

    write_csv("06_performance_management.csv", fields, rows)

# ── 7. learning_management_system ───────────────────────────
def gen_learning_management_system(employees: list):
    fields = ["user_id","courseid","coursetitle","completiondate","status",
              "credithours","grade","trainingcost","trainingtype"]
    rows = []
    used = set()

    for e in employees:
        if e["status"] == STATUS_TERMINATED:
            continue

        # Mandatory compliance (COMP for everyone, within 60 days of hire)
        for cid, title, ctype, hrs, cost in MANDATORY_COURSES:
            cd = e["hire_date"] + timedelta(days=random.randint(7, 60))
            if cd >= TODAY:
                cd = TODAY - timedelta(days=7)
            key = (e["user_id"], cid, str(cd))
            if key in used:
                cd += timedelta(days=1)
                key = (e["user_id"], cid, str(cd))
            used.add(key)
            rows.append({
                "user_id":        e["user_id"],
                "courseid":       cid,
                "coursetitle":    title,
                "completiondate": cd,
                "status":         LMS_COMP,
                "credithours":    hrs,
                "grade":          round(random.uniform(70, 100), 2),
                "trainingcost":   round(cost * random.uniform(0.9, 1.1), 2),
                "trainingtype":   ctype,
            })

        # Elective courses (2–5 per employee)
        chosen = random.sample(ELECTIVE_COURSES,
                               min(random.randint(2, 5), len(ELECTIVE_COURSES)))
        for cid, title, ctype, hrs, cost in chosen:
            cd = rand_date(
                max(e["hire_date"] + timedelta(days=90), date(2020, 1, 1)),
                date(2025, 12, 31)
            )
            key = (e["user_id"], cid, str(cd))
            if key in used:
                continue
            used.add(key)

            roll = random.random()
            if   roll < 0.70: status = LMS_COMP;  grade = round(random.uniform(60,100),2)
            elif roll < 0.88: status = LMS_ENR;   grade = 0.0
            else:             status = LMS_FAIL;  grade = round(random.uniform(40,59),2)

            # completiondate: filled for COMP/FAIL, projected future date for ENR
            if status == LMS_ENR:
                future_cd = TODAY + timedelta(days=random.randint(30, 120))
                comp_date = future_cd
            else:
                comp_date = cd

            rows.append({
                "user_id":        e["user_id"],
                "courseid":       cid,
                "coursetitle":    title,
                "completiondate": comp_date,
                "status":         status,
                "credithours":    hrs,
                "grade":          grade,
                "trainingcost":   round(cost * random.uniform(0.85, 1.15), 2),
                "trainingtype":   ctype,
            })

    write_csv("07_learning_management_system.csv", fields, rows)

# ── 8. termination_info ─────────────────────────────────────
def gen_termination_info(employees: list):
    fields = ["user_id","event_reason","company","oktorehire","lastdateworked",
              "bonuspayexpirationdate","termination_detailed_reason",
              "termination_attachment"]
    rows = []

    TERM_CONFIG = {
        TERM_RESIGNATION: {"weight":0.45, "rehire": REHIRE_YES,
                           "desc":"Démission volontaire du salarié."},
        TERM_INVOLUNTARY: {"weight":0.25, "rehire": REHIRE_NO,
                           "desc":"Licenciement pour motif économique ou personnel."},
        TERM_RETIREMENT:  {"weight":0.15, "rehire": REHIRE_YES,
                           "desc":"Départ à la retraite — droits validés."},
        TERM_NON_RENEWAL: {"weight":0.10, "rehire": REHIRE_YES,
                           "desc":"Non-renouvellement du CDD à son terme."},
        TERM_DEATH:       {"weight":0.05, "rehire": REHIRE_NO,
                           "desc":"Décès du salarié — acte transmis au service RH."},
    }
    reasons  = list(TERM_CONFIG.keys())
    weights  = [TERM_CONFIG[r]["weight"] for r in reasons]

    for e in employees:
        if e["status"] != STATUS_TERMINATED:
            continue

        reason = random.choices(reasons, weights)[0]
        cfg    = TERM_CONFIG[reason]
        lwd    = rand_date(date(2023, 1, 1), date(2025, 12, 1))
        bpe    = lwd + timedelta(days=random.randint(30, 90))

        rows.append({
            "user_id":                    e["user_id"],
            "event_reason":               reason,
            "company":                    "Novaryn Tech",
            "oktorehire":                 cfg["rehire"],  # 'YES' or 'NO' (string)
            "lastdateworked":             lwd,
            "bonuspayexpirationdate":     bpe,            # always ≥ lwd
            "termination_detailed_reason":cfg["desc"],
            "termination_attachment":     f"EXIT-{e['user_id']}-{lwd.year}.pdf",
        })

    write_csv("08_termination_info.csv", fields, rows)

# ─────────────────────────────────────────────────────────────
# MAIN ORCHESTRATION
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    from collections import Counter

    print(f"\n{'═'*70}")
    print("  🇫🇷  NOVARYN TECH — Data Generator v3.0")
    print(f"{'═'*70}")
    print(f"  Faker     : {'✓ installed (fr_FR)' if FAKER_AVAILABLE else '✗ fallback names'}")
    print(f"  DateUtil  : {'✓ installed' if DATEUTIL_AVAILABLE else '✗ fallback math'}")
    print(f"  Output    : {os.path.abspath(OUTPUT_DIR)}")
    print(f"  Reference : {TODAY}\n")

    # ── Phase 1: build raw employee records ───────────────────
    print("  [1/4] Building employee roster...")
    employees = build_employees()

    # ── Phase 2: assign managers & HR ─────────────────────────
    # assign_managers_and_hr runs ONCE — a second run after transfers would
    # randomly re-assign everyone and silently undo the executive hierarchy.
    # Transfers in Phase 3 may shift ~10% of employees to a new city; their
    # manager will now be in a different city but this is accepted as a
    # transient state until next headcount review — acceptable for test data.
    print("  [2/4] Assigning managers & HR contacts...")
    assign_managers_and_hr(employees)

    # ── Phase 3: build job_info & sync job_code ───────────────
    print("  [3/4] Building career history & syncing job codes...")
    job_rows = build_job_info_rows(employees)
    sync_job_codes(employees, job_rows)   # also syncs sen_level + sen_prefix

    # Apply executive hierarchy LAST — overrides any senior picked by Phase 2.
    # All C-level executives are set to manager_id = None (top of org chart).
    assign_executive_hierarchy(employees)

    # ── Phase 4: write all CSVs ───────────────────────────────
    print(f"  [4/4] Writing CSV files...\n  {'─'*65}")
    gen_basic_user_info(employees)
    gen_job_info(job_rows)
    comp_rows = gen_compensation_info(employees, job_rows)
    gen_pay_component_recurring(employees, job_rows, comp_rows)
    gen_pay_component_non_recurring(employees)
    gen_performance_management(employees)
    gen_learning_management_system(employees)
    gen_termination_info(employees)

    # ── Summary ───────────────────────────────────────────────
    print(f"  {'─'*65}")
    print(f"\n   ROSTER SUMMARY")
    print(f"     Total employees : {len(employees)}")
    print(f"     Status          : {dict(Counter(e['status']    for e in employees))}")
    print(f"     Cities          : {dict(Counter(e['city']      for e in employees))}")
    print(f"     Pay groups      : {dict(Counter(e['pay_group'] for e in employees))}")
    print(f"     Seniority levels: {dict(sorted(Counter(e['sen_level'] for e in employees).items()))}")
    print(f"     Contracts       : {dict(Counter(e['contract_name'] for e in employees))}")

    no_mgr = sum(1 for e in employees if not e["manager_id"] and e["status"] != STATUS_TERMINATED)
    print(f"\n    Employees without manager : {no_mgr} (top-level executives only)")

    print(f"\n   All files in: {os.path.abspath(OUTPUT_DIR)}")
    print(f"{'═'*70}\n")