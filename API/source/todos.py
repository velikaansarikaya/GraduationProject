from flask import Blueprint


todos=Blueprint("todos", __name__, url_prefix='/api/v1/todos')

@todos.route('/add', methods=['POST'])
def add():
    return 'add todo'

@todos.route('/update/<oid>', methods=['PUT'])
def update():
    return 'update selected todo'    

@todos.route('/delete/<oid>', methods=['DELETE'])
def delete():
    return 'delete selected todo'

@todos.route('/delete_completed', methods=['DELETE'])
def delete_completed():
    return 'delete completed todos'


@todos.route('/', methods=['GET'])
def get_all():
    return 'get all'
    
@todos.route('/<oid>', methods=['GET'])
def get():
    return 'get todo'
    