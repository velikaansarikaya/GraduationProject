from crypt import methods
from flask import Flask, jsonify, request, make_response
from pymongo import MongoClient
import jwt, datetime
from functools import wraps

app=Flask(__name__)

app.config['SECRET_KEY'] = '8fba5720a03310313f823ba8'
app.config['DB_KEY'] = 'mongodb+srv://admin:root@cluster0.p1app.mongodb.net/myFirstDatabase?retryWrites=true&w=majority'
mongo = MongoClient(app.config['DB_KEY'], tls = True, tlsAllowInvalidCertificates = True)
db = mongo.testdb

#todo: token required func


@app.route('/login', methods = ['POST'])
def login():
    #using basic auth
    auth=request.authorization

    #check auth
    if not auth or not auth.username or not auth.password:
        return make_response('Could not verify!', 401, {'WWW-Authenticate' : 'Basic realm="Login Required"'})

    #check user exist in db
    user = db.users.find_one({"name" : auth.username})
    if not user:
        return make_response('Could not found user!', 401, {'WWW-Authenticate' : 'Basic realm="User Not Exist"'})

    #check user password match
    user = db.users.find_one({"name" : auth.username, "password" : auth.password})
    if not user:
        return make_response('Could not verify!', 401, {'WWW-Authenticate' : 'Basic realm="Wrong Password"'})  
    else:
        #yes matches create token
        token = jwt.encode({'user' : auth.username, 'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},app.config['SECRET_KEY'],algorithm="HS256")
        return jsonify({"token" : token})
             
if __name__ == '__main__':
    app.run(debug=True)