
from flask import Flask, json, request
from pymongo import MongoClient


USER = "grupo24"
PASS = "grupo24"
DATABASE = "grupo24"

URL = f"mongodb://{USER}:{PASS}@gray.ing.puc.cl/{DATABASE}?authSource=admin"
client = MongoClient(URL)

MESSAGE_KEYS = ['message', 'sender', 'receptant', 'lat', 'long', 'date']

db = client["grupo24"]

usuarios = db.usuarios
mensajes = db.mensajes
test_search = db.text_search

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
        messages = list(mensajes.find({'$or': [{'$and': [{"receptant": int(x)}, {"sender": int(y)}]}, {'$and': [{"receptant": int(y)}, {"sender": int(x)}]}]}, {"_id": 0}))
        if len(messages) == 0:
            messages = {"Error": "no hay mensajes entre estos ids"}
        if len(list(usuarios.find({"uid": int(x)}, {"_id": 0}))) == 0 and len(list(usuarios.find({"uid": int(y)}, {"_id": 0}))) == 0:
            messages = {"Error": "Los ids ingresados no existen"}
        elif len(list(usuarios.find({"uid": int(x)}, {"_id": 0}))) == 0:
            messages = {"Error": "El id1 ingresado no existe"}
        elif len(list(usuarios.find({"uid": int(y)}, {"_id": 0}))) == 0:
            messages = {"Error": "El id2 ingresado no existe"}
    elif x is None and y is not None:
        messages = {"Error": "no haz definido un id1 valido"}
    elif x is not None and y is None:
        messages = {"Error": "no haz definido un id2 valido"}
    else:
        messages = list(mensajes.find({}, {"_id": 0}))

    return json.jsonify(messages)

@app.route("/users/<int:uid>")
@app.route("/users/<int:uid>")
def get_user(uid):
    '''
    Obtiene el usuario de id entregada
    '''
    user = list(usuarios.find({"uid": uid}, {"_id": 0}))
    if len(user) == 0:
        user = {"Error": "El uid ingresado no existe"}

    return json.jsonify(user)

@app.route("/messages/<int:mid>")
def get_message(mid):
    '''
    Obtiene el mensaje de id entregada
    '''
    message = list(mensajes.find({"mid": mid}, {"_id": 0}))
    if len(message) == 0:
        message = {"Error": "El mid ingresado no existe"}

    return json.jsonify(message)

@app.route('/messages', methods=['POST'])
def new_message():
    '''
    Crea un mensaje recibiendo sus atributos
    '''
    json_data = request.get_json(force=True)
    allmessages = list(db.mensajes.find().sort("mid"))
    idmax = allmessages[-1]['mid']
    newid = idmax + 1
    a = True
    for key in MESSAGE_KEYS:
        if key not in json_data:
            a = False
            mensaje_error = 'No hay '+key+' ingresado'
            return json.jsonify({'error': mensaje_error})
    if a:
        id = db.mensajes.insert(
            {'date': json_data['date'],
            'lat': json_data['lat'],
            'long': json_data['long'],
            'message': json_data['message'],
            'mid': newid,
            'receptant': json_data['receptant'],
            'sender': json_data['sender']})
        return json.jsonify({'success': True})

@app.route('/message/<int:mid>', methods=['DELETE'])
def delete_message(mid):
    '''
    Elimina un mensaje, recibiendo un id
    '''
    allmessages = list(db.mensajes.find().sort("mid"))
    a = True
    for i in allmessages:
        if i['mid'] == mid:
            a = False
            mensajes.remove({"mid": mid})
            return json.jsonify({'success': True})
    if a:
        return json.jsonify({'success': False})


@app.route("/text-search")
def text_searching():
    contador = 0
    try:
        mensaje = request.get_json()
    except Exception:
        resultado = list(mensajes.find({}, {"_id": 0}))
        return json.jsonify(resultado)

    mensaje = request.get_json()
    desired_legible = ""
    required_arreglado = ""
    forbidden_legible = ""

    bool_f = False
    bool_r = False
    bool_d = False
    bool_i = False

    if mensaje is None:
        resultado = list(mensajes.find({}, {"_id": 0}))
        return json.jsonify(resultado)

    if len(mensaje) == 0:
        resultado = list(mensajes.find({}, {"_id": 0}))
        return json.jsonify(resultado)


        
    if "userId" in mensaje:
        bool_i = True
        id_usuario = mensaje["userId"]
        usuario = list(usuarios.find({"uid": id_usuario}, {"_id": 0}))
        if len(usuario) == 0:
            return "<h1> No existe un usuario con ese ID </h1>"
    

    if "desired" in mensaje:
        bool_d = True
        contador += 1
        desired = mensaje["desired"]
        desired_legible = " ".join(desired)
        #if bool_i:
            #mensajes_desired = list(mensajes.find({"$text": {"$search": desired_legible}, "sender": id_usuario}, {"_id": 0}))
        #else:
            #mensajes_desired = list(mensajes.find({"$text": {"$search": desired_legible}}, {"_id": 0}))


    if "required" in mensaje:
        bool_r = True
        contador +=1
        required = mensaje["required"]
        required_arreglado = " "
        for x in required:
            required_arreglado += f'\"{x}\" '
        #if bool_i:
            #mensajes_required = list(mensajes.find({"$text": {"$search": required_arreglado}, "sender": id_usuario}, {"_id": 0}))
        #else:
            #mensajes_required = list(mensajes.find({"$text": {"$search": required_arreglado}}, {"_id": 0}))

    if "forbidden" in mensaje:
        bool_f = True
        contador +=1
        forbidden_lista = []
        forbidden = mensaje['forbidden']
        for x in forbidden:
            forbidden_lista.append(f"-{x}")

        forbidden_legible = " ".join(forbidden_lista)


    if contador == 1:
        if bool_f is True:
            forbidden_arreglado = " ".join(forbidden)
            if bool_i:
                mensajes_usuario = list(mensajes.find({"sender": id_usuario}, {"_id": 0}))
            else:
                mensajes_usuario = list(mensajes.find({}, {"_id": 0}))
                
            mensajes_con_forbidden = list(mensajes.find({"$text": {"$search": forbidden_arreglado}},{"_id": 0}))
            mensajes_forbidden = []
            for mensaje in mensajes_usuario:
                con = 1
                for mensajes_malos in mensajes_con_forbidden:
                    if mensaje["mid"] == mensajes_malos["mid"]:
                        con = 0
                
                if con == 1:
                    mensajes_forbidden.append(mensaje)

            return json.jsonify(mensajes_con_forbidden)

        else:
            text_search = desired_legible + required_arreglado

    else:
        text_search = desired_legible + required_arreglado + forbidden_legible

    if bool_i:
        print("Con usuario")
        if text_search == "":
            resultado = list(mensajes.find({ "sender": id_usuario}, {"_id": 0}))
        else:
            resultado = list(mensajes.find({"$text": {"$search": text_search}, "sender": id_usuario}, {"_id": 0}))
    else:
        print("Sin usuario")
        if text_search == "":
            resultado = list(mensajes.find({}, {"_id": 0}))
        else:
            resultado = list(mensajes.find({"$text": {"$search": text_search}}, {"_id": 0}))
    print(text_search)
    return json.jsonify({"messages":resultado})
        




    
    



if __name__ == "__main__":
    app.run()
    app.run(debug=True)

#python3 Entrega4/main.py