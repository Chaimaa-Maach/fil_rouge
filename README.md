# Smart-Retention SuccessFactors

Projet de fin de formation Data Analyst — Simplon Maghreb 2026  
**Chaimaa MAACH** | Superviseur : Yassine Ammami
<img width="335" height="217" alt="image" src="https://github.com/user-attachments/assets/8b4239c0-2c7e-42a5-8025-915ab8a095fa" />



---

## C'est quoi ?

Une solution analytique pour analyser, mesurer et anticiper le turnover RH d'une entreprise DeepTech française fictive — **Novaryn Tech** (250 collaborateurs, 6 villes).

Le projet couvre tout le cycle de la donnée : modélisation SQL → génération des données → scraping salaires marché → calcul des KPIs → dashboards Power BI.

---

## Ce qui a été fait

- **Base de données PostgreSQL** — 8 tables, 44 contraintes métier, inspirée de SAP SuccessFactors
- **Générateur Python** (`generate_novaryn_v6.py`) — 250 collaborateurs simulés, 8 CSV, 18/18 vérifications
- **Web scraping** (`scraper_salaires_v2.py`) — salaires du marché depuis datarecrutement.fr
- **Calcul des KPIs** (`mesures & colonnes calculés`) — compa-ratio, score de risque de départ, coût turnover
- **Dashboard Power BI** — 5 pages, 4 User Stories (DRH, RH, Manager, Direction)

---



## Stack

Python · PostgreSQL · Power BI · Selenium · pandas

---



*Les données sont entièrement simulées. Novaryn Tech est une entreprise fictive.*
