import sqlite3

connection = sqlite3.connect('database.db')


with open('schema.sql') as f:
    connection.executescript(f.read())

cur = connection.cursor()

cur.execute("INSERT INTO groceryList (title, active) VALUES (?, ?)",
            ('Eggs', True)
            )

cur.execute("INSERT INTO groceryList (title, active) VALUES (?, ?)",
            ('Apples', False)
            )

connection.commit()
connection.close()