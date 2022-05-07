from flask import Flask
from datetime import timedelta
from flask_jwt_extended import JWTManager
from flask_pymongo import PyMongo
from source.auth import auth
from source.todos import todos
from pymongo import MongoClient

def create_app():
    app = Flask(__name__, instance_relative_config=True)

    
    app.config.from_mapping(
        SECRET_KEY = 'b652046ce2de4dd2be393742d0a99225',
        DB_KEY = 'mongodb+srv://admin:root@cluster0.p1app.mongodb.net/myFirstDatabase?retryWrites=true&w=majority',
        JWT_SECRET_KEY = '9babc24a96064baa8a13ca33c20e3268',
        JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=15),
        JWT_REFRESH_TOKEN_EXPIRES = timedelta(hours=2)
    )
    
    app.mongo=MongoClient(app.config['DB_KEY'],tls=True, tlsAllowInvalidCertificates=True)
    app.db=app.mongo.todoappdb

    JWTManager(app)

    app.register_blueprint(auth)
    app.register_blueprint(todos)
    return app  