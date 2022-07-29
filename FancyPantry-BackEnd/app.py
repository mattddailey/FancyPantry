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

@app.route("/groceryList", methods=["GET", "POST"])
def index():
    conn = get_db_connection()

    if request.method == "GET":
        cursor = conn.execute("SELECT * FROM groceryList")
        groceryList = [
            dict(id=row[0], title=row[1], active=row[2])
            for row in cursor.fetchall()
        ]
        conn.close()
        if groceryList is not None:
            return jsonify(groceryList)

    elif request.method == "POST":
        return 'Post not implemented...!'