import json
import time
import urllib.parse
import sqlite3

from sanic import Sanic
from sanic.response import text

app = Sanic("MyHelloWorldApp")

connection = sqlite3.connect("giftmap-halloween.db")
c = connection.cursor()

c.execute('''CREATE TABLE IF NOT EXISTS "log" (
	"id"	INTEGER,
	"timestamp"	INTEGER,
	"ip"	TEXT,
	"gift_string" TEXT,
	"x"	REAL,
	"y"	REAL,
	"z"	REAL,
	PRIMARY KEY("id" AUTOINCREMENT)
);''')
connection.commit()

def ctime():
    return int(time.time())

@app.get("/")
async def hello_world(request):
    info = json.loads(urllib.parse.unquote(request.path).replace("/", ""))

    c.executemany("INSERT INTO log('timestamp','ip', 'gift_string', 'x','y','z') VALUES (?,?,?,?,?,?)", (ctime(), request.ip, info["gift_string"], info["x"], info['y'], info['z']))
    connection.commit()
    return text("Hello, world.")

app.run(host="0.0.0.0", port=1662)
