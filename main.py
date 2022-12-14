import psycopg2
import os

POSGRES_PWD = os.getenv('POSGRES_PASSWORD')


def create_databases(cursor):
    cursor.execute(open("script.sql", "r").read())

def copy_to_database(cursor):
    if not(os.path.exists("/home/zorox/postgres/postgres/pgdata/csv_tables/tables")):
        os.system("sudo cp -r ./tables/ /home/zorox/postgres/postgres/pgdata/csv_tables/")
    cursor.execute(open("copy_from_csv.sql", "r").read())

def main():
    
    
    conn = psycopg2.connect(database = "beer", user="postgres", password="postgres", host="localhost", port="5432")
    print("Databes opened")

    cursor = conn.cursor()

    create_databases(cursor)

    conn.commit()

    copy_to_database(cursor)
    conn.commit()

    conn.close()

    print("ALL DONE")


if __name__ == "__main__":
    main()