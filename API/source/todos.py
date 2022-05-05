from flask import Blueprint


todos=Blueprint("todos", __name__, url_prefix='/api/v1/todos')

@todos.route('/add', methods=['POST'])
def register():
    return 'add todo'

@todos.route('/update/<oid>', methods=['POST'])
def register():
    return 'update selected todo'    

@todos.route('/delete/<oid>', methods=['DELETE'])
def register():
    return 'delete selected todo'

@todos.route('/delete_completed', methods=['DELETE'])
def register():
    return 'delete completed todos'


@todos.route('/', methods=['GET'])
def register():
    return 'get all'
    
@todos.route('/<oid>', methods=['GET'])
def register():
    return 'get todo'
    