from flask import Flask, json, request
from pymongo import MongoClient


USER = "grupo24"
PASS = "grupo24"
DATABASE = "grupo24"

URL = f"mongodb://{USER}:{PASS}@gray.ing.puc.cl/{DATABASE}?authSource=admin"
client = MongoClient(URL)

db = client["grupo24"]

usuarios = db.usuarios
mensajes = db.mensajes

app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False

@app.route("/")
def home():
    '''
    Página de inicio
    '''
    return "<h1>¡Hola!</h1>"

@app.route("/users")
def get_users():
    '''
    Obtiene todos los usuarios
    '''
    users = list(usuarios.find({}, {"_id": 0}))

    return json.jsonify(users)

@app.route("/messages")
def get_messages():
    '''
    Obtiene todos los mensajes
    '''
    x = request.args.get("id1")
    y = request.args.get("id2")
    if x is not None and y is not None:
        messages = list(mensajes.find({ '$and' :[{"receptant": x}, {"receptant": y}]}, {"_id": 0}))
    else:
        messages = list(mensajes.find({}, {"_id": 0}))

    return json.jsonify(messages)

@app.route("/users/<int:uid>")
def get_user(uid):
    '''
    Obtiene el usuario de id entregada
    '''
    user = list(usuarios.find({"uid": uid}, {"_id": 0}))

    return json.jsonify(user)

@app.route("/messages/<int:mid>")
def get_message(mid):
    '''
    Obtiene el mensaje de id entregada
    '''
    message = list(mensajes.find({"mid": mid}, {"_id": 0}))

    return json.jsonify(message)


if __name__ == "__main__":
    app.run()
    app.run(debug=True)