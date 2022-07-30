import sqlite3
from flask import Flask, jsonify, request

app = Flask(__name__)

def get_db_connection():
    conn = None
    try:
        conn = sqlite3.connect("database.db")
    except sqlite3.error as e:
        print(e)
    return conn

@app.route("/groceryList", methods=["GET"])
def fetchGroceries():
    conn = get_db_connection()

    cursor = conn.execute("SELECT * FROM groceryList")
    groceryList = [
        dict(id=row[0], title=row[1], active=row[2])
        for row in cursor.fetchall()
    ]
    conn.close()
    if groceryList is not None:
        return jsonify(groceryList)

@app.route("/groceryList/<id>", methods=["PUT"])
def updateGrocery(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    grocery = request.get_json()

    try:
        sql_query = """UPDATE groceryList
                        SET title=?,
                            active=?
                        WHERE id=?"""
        cursor.execute(sql_query, (grocery["title"], grocery["active"], id))
        conn.commit()
        cursor.close()

    except sqlite3.Error as error:
        print("Failed to update sqlite table", error)

    return fetchGroceries()
