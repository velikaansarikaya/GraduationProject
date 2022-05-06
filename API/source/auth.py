from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import create_access_token,create_refresh_token
from flask_jwt_extended import get_jwt_identity, jwt_required
from flask_jwt_extended import verify_jwt_in_request, get_jwt, JWTManager
from werkzeug.security import check_password_hash, generate_password_hash
from functools import wraps
import validators

auth=Blueprint("auth", __name__, url_prefix='/api/v1/auth')


@auth.route('/register', methods=['POST'])
def register():
    username = request.json['username']
    password = request.json['password']
    email = request.json['email']

    if len(password) < 6:
        return jsonify({'error': "Password is too short"}), 400 

    if len(username) < 3:
        return jsonify({'error': "Username is too short"}), 400

    if not username.isalnum() or " " in username:
        return jsonify({'error': "Username should be alphanumeric, also no spaces"}), 400

    if not validators.email(email):
        return jsonify({'error': "Email is not valid"}), 400

    if current_app.db.users.find_one({'email': email}) is not None:
        return jsonify({'error': "Email is taken"}), 409

    if current_app.db.users.find_one({'username': username}) is not None:
        return jsonify({'error': "Username is taken"}), 409
    
    hashed_pwd = generate_password_hash(password)

    user = {"email": email,
        "username": username,
        "password": hashed_pwd,
        "isadmin": False}
    current_app.db.users.insert_one(user)

    return jsonify({
        'message': "User created",
        'user': {
            'username': username, "email": email
        }

    }), 201    

@auth.route('/login', methods=['POST'])
def login():
    return 'user login'    

@auth.route('/me', methods=['GET'])
def me():
    return 'hello its me'

@auth.route('/token/refresh', methods=['GET'])
def refresh():
    return 'token refreshed'