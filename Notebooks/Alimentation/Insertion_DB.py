import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
"postgresql+psycopg2://postgres:Chaimaa2000@localhost:5432/CoreRH"
)

files = {
"01_basic_user_info.csv": "basic_user_info",
"02_job_info.csv": "job_info",
"03_compensation_info.csv": "compensation_info",
"04_pay_component_recurring.csv": "pay_component_recurring",
"05_pay_component_non_recurring.csv": "pay_component_non_recurring",
"06_performance_management.csv": "performance_management",
"07_learning_management_system.csv": "learning_management_system",
"08_termination_info.csv": "termination_info"
}

base_path = "novaryn_data_v3"

for file, table in files.items():

    path = f"{base_path}/{file}"

    df = pd.read_csv(path, encoding="utf-8-sig")


    df.rename(columns={
        "course_id": "courseid"
    }, inplace=True)

    df.to_sql(
        table,
        engine,
        if_exists="append",
        index=False
    )

    print(f"{table} inserted")