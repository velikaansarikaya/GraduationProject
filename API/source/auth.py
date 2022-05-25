from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import create_access_token,create_refresh_token
from flask_jwt_extended import get_jwt_identity, jwt_required
from flask_jwt_extended import verify_jwt_in_request, get_jwt
from werkzeug.security import check_password_hash, generate_password_hash
from bson.objectid import ObjectId
from functools import wraps
import validators

auth=Blueprint("auth", __name__, url_prefix='/api/v1/auth')


@auth.route('/register', methods=['POST'])
def register():
    username = request.json['username']
    password = request.json['password']
    email = request.json['email']

    if len(password) < 6:
        return jsonify({'message': "Password is too short"}), 400 

    if len(username) < 3:
        return jsonify({'message': "Username is too short"}), 400

    if not username.isalnum() or " " in username:
        return jsonify({'message': "Username should be alphanumeric, also no spaces"}), 400

    if not validators.email(email):
        return jsonify({'message': "Email is not valid"}), 400

    if current_app.db.users.find_one({'email': email}) is not None:
        return jsonify({'message': "Email is taken"}), 409

    if current_app.db.users.find_one({'username': username}) is not None:
        return jsonify({'message': "Username is taken"}), 409
    
    hashed_pwd = generate_password_hash(password)

    user = {'email': email,
        'username': username,
        'password': hashed_pwd,
        'isadmin': False}
    current_app.db.users.insert_one(user)

    return jsonify({
        'message': "User created",
        'user': {
            'username': username, 'email': email
        }

    }), 201    

@auth.route('/login', methods=['POST'])
def login():
    username = request.json['username']
    password = request.json['password']
    
    user = current_app.db.users.find_one({'username': username})
    
    if user:
        is_pass_correct = check_password_hash(user['password'], password)

        if is_pass_correct:
            user_obj_id = str(user['_id'])
            refresh = create_refresh_token(identity=user_obj_id)
            access = create_access_token(identity=user_obj_id)

            return jsonify({
                'user': {
                    'refresh': refresh,
                    'access': access,
                    'username': user['username'],
                    'email': user['email']
                }
            }), 200    

    return jsonify({'message': 'Wrong credentials'}), 401

@auth.route('/me', methods=['GET'])
@jwt_required()
def me():
    user_obj_id = get_jwt_identity()
    user = current_app.db.users.find_one({'_id': ObjectId(user_obj_id)})
    return jsonify({
        'username': user['username'],
        'email': user['email']
    }), 200

    
@auth.route('/token/refresh', methods=['GET'])
@jwt_required(refresh=True)
def refresh():
    user_obj_id = get_jwt_identity()
    access = create_access_token(identity=user_obj_id)

    return jsonify({
        'access': access
    }), 200