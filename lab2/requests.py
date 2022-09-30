import psycopg2
import os


def execute_request(cursor):
    i = int(input("Введите № запроса: "))
    fname = "lab2/" + str(i) + ".sql"
    cursor.execute(open(fname, "r").read())


def main():

    conn = psycopg2.connect(database = "beer", user="postgres", password="postgres", host="localhost", port="5432")
    print("Databes opened")

    cursor = conn.cursor()
    execute_request(cursor)
    conn.commit()
    conn.close()

    print("ALL DONE")


if __name__ == "__main__":
    main()