import sqlite3

connection = sqlite3.connect('database.db')


with open('schema.sql') as f:
    connection.executescript(f.read())

cur = connection.cursor()

cur.execute("INSERT INTO groceryList (title, type) VALUES (?, ?)",
            ('Eggs', 'Dairy')
            )

cur.execute("INSERT INTO groceryList (title, type) VALUES (?, ?)",
            ('Apples', 'Fruit')
            )

connection.commit()
connection.close()