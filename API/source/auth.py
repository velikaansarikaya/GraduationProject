from flask import Blueprint


auth=Blueprint("auth", __name__, url_prefix='/api/v1/auth')

@auth.route('/register', methods=['POST'])
def register():
    return 'user created'

@auth.route('/login', methods=['POST'])
def register():
    return 'user login'    

@auth.route('/me', methods=['GET'])
def register():
    return 'hello its me'

@auth.route('/token/refresh', methods=['GET'])
def register():
    return 'token refreshed'