from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import csv

# ============================
# DRIVER
# ============================
driver = webdriver.Firefox()
driver.get("https://datarecrutement.fr/etude-salaire/")
time.sleep(6)

results = []

# ============================
# Sélection JS (SANS CLIC)
# ============================
def js_select(select_id, value, sleep=1):
    script = """
    let select = document.getElementById(arguments[0]);
    if (!select) return false;
    let values = Array.from(select.options).map(o => o.value);
    if (!values.includes(arguments[1])) return false;
    select.value = arguments[1];
    select.dispatchEvent(new Event('change', { bubbles: true }));
    return true;
    """
    ok = driver.execute_script(script, select_id, value)
    time.sleep(sleep)
    return ok

# ============================
# Attente que le salaire change
# ============================
def wait_for_salary_change(element_id, old_value="", timeout=5):
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            current_value = driver.find_element(By.ID, element_id).text.strip()
            if current_value != "" and current_value != old_value:
                return current_value
        except:
            pass
        time.sleep(0.5)
    try:
        return driver.find_element(By.ID, element_id).text.strip()
    except:
        return ""

# ============================
# Fonctions disponibles
# ============================
functions = driver.execute_script("""
let select = document.getElementById('function');
return Array.from(select.options)
    .filter(o =>
        o.value &&
        !o.disabled &&
        !o.text.includes('Sélectionnez') &&
        !o.text.includes('Toutes')
    )
    .map(o => ({value: o.value, text: o.text}));
""")
print(f"Fonctions valides détectées : {len(functions)}")

# ============================
# Localisations disponibles  ← NOUVEAU : on lit toutes les options
# ============================
locations = driver.execute_script("""
let select = document.getElementById('lieux');
return Array.from(select.options)
    .filter(o => o.value && !o.disabled)
    .map(o => ({value: o.value, text: o.text}));
""")
print(f"Localisations détectées : {[l['text'] for l in locations]}")

# ============================
# Expériences cibles
# ============================
target_years = ["0", "1", "2", "3", "4", "5", "8", "10", "15", "30"]

# ============================
# Boucle principale  ← NOUVEAU : boucle externe sur les localisations
# ============================
for loc in locations:
    print(f"\n{'='*50}")
    print(f" Localisation : {loc['text']}")
    print(f"{'='*50}")

    for func in functions:
        print(f"\n🔹 Fonction : {func['text']}")
        if not js_select("function", func["value"], sleep=2):
            print(f"    Impossible de sélectionner {func['text']}")
            continue

        previous_salary = None

        # Lire options exp avec retry — le dropdown peut être None si la
        # page n'a pas encore réagi au changement de fonction (Chief Product
        # Officer et autres fonctions lentes déclenchent ce bug)
        options_exp = None
        for attempt in range(3):
            options_exp = driver.execute_script("""
            let select = document.getElementById('exp');
            if (!select) return null;
            let opts = Array.from(select.options)
                .filter(o => o.value && !o.disabled)
                .map(o => ({value: o.value, text: o.text}));
            return opts.length > 0 ? opts : null;
            """)
            if options_exp:
                break
            print(f"    exp dropdown vide, tentative {attempt + 1}/3...")
            time.sleep(2)

        if not options_exp:
            print(f"    Aucune option exp pour {func['text']}, on passe.")
            continue

        # Boucle sur exp filtrées
        for opt in options_exp:
            years = ''.join([c for c in opt["text"] if c.isdigit()])
            if years not in target_years:
                continue

            # Appliquer exp et filtres fixes
            js_select("exp",     opt["value"])
            js_select("mana",    "0")          # Pas de management
            js_select("lieux",   loc["value"]) # ← NOUVEAU : dynamique
            js_select("diplome", "0")          # Bac +5
            js_select("secteur", "12")         # DeepTech

            # Récupération des salaires
            try:
                salaire_min    = wait_for_salary_change("min")
                salaire_moyen  = wait_for_salary_change("base")
                salaire_max    = wait_for_salary_change("max")

                if salaire_moyen == "":
                    print(f"    Pas de données pour {years} ans")
                    continue

                note = "effectif" if salaire_moyen != previous_salary else "par défaut"
                previous_salary = salaire_moyen

                results.append({
                    "fonction":        func["text"],
                    "localisation":    loc["text"],   # ← NOUVEAU : label réel du site
                    "experience":      years + " ans",
                    "management":      "Pas de management",
                    "diplome":         "Bac +5",
                    "secteur":         "DeepTech",
                    "salaire_min_k":   salaire_min,
                    "salaire_moyen_k": salaire_moyen,
                    "salaire_max_k":   salaire_max,
                    "note":            note,
                    "source":          "DataRecrutement"
                })

                print(f"    {years} ans → {salaire_moyen} ({note})")

            except Exception as e:
                print(f"   Erreur {years} ans: {e}")

driver.quit()

# ============================
# Export CSV
# ============================
if results:
    with open("salaires_datarecrutement.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=results[0].keys())
        writer.writeheader()
        writer.writerows(results)
    print(f"\n CSV généré avec {len(results)} lignes")
    # Résumé par localisation
    from collections import Counter
    locs = Counter(r["localisation"] for r in results)
    for l, count in locs.items():
        print(f"    {l} : {count} lignes")
else:
    print("\n Aucune donnée collectée")