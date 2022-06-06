from bson import ObjectId
from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity


todos=Blueprint("todos", __name__, url_prefix='/api/v1/todos')

@todos.route('/add', methods=['POST'])
@jwt_required()
def add():
    user_obj_id = get_jwt_identity()
    header = request.json['header']
    detail = request.json['detail']
    
    current_app.db.todos.insert_one({
        'header': header,
        'detail': detail,
        'iscompleted': False,
        'userid': user_obj_id
    })
    return jsonify({'message': "Todo is added"}), 200


@todos.route('/update/<oid>', methods=['PUT'])
@jwt_required()
def update(oid):

    header = request.json['header']
    detail = request.json['detail']
    iscompleted = request.json['iscompleted']

    try:
        todo = current_app.db.todos.update_one({'_id': ObjectId(oid)}, {'$set': {'header': header, 'detail': detail, 'iscompleted': iscompleted}})
    
    except :
        return jsonify({'message': "Item not found"}), 404 

    return jsonify({
            'id': oid,
            'message': str(todo.modified_count) + " todo is modified"
        }), 200
   

@todos.route('/delete/<oid>', methods=['DELETE'])
@jwt_required()
def delete(oid):

    todo = current_app.db.todos.delete_one({'_id': ObjectId(oid)})

    if todo.deleted_count == 0:
        return jsonify({'message': "Item not found"}), 404 
    else:
        return jsonify({
            'id': oid,
            'message': str(todo.deleted_count) + " todo is deleted"
        }), 200


@todos.route('/delete_completed', methods=['DELETE'])
@jwt_required()
def delete_completed():

    todo = current_app.db.todos.delete_many({'iscompleted': True})

    if todo.deleted_count == 0:
        return jsonify({'message': "Completed todos are not found"}), 404 
    else:
        return jsonify({
            'message': str(todo.deleted_count) + " todos are deleted"
        }), 200


@todos.route('/', methods=['GET'])
@jwt_required()
def get_all():
    user_obj_id = get_jwt_identity()
    
    todos = current_app.db.todos.find({'userid': user_obj_id})
    
    todo_list=[]
    
    for todo in todos:
        
        new_todo = {
            '_id': str(todo['_id']),
            'header': todo['header'],
            'detail': todo['detail'],
            'iscompleted': todo['iscompleted'],
            'userid': todo['userid']
        }
        
        todo_list.append(new_todo)
    
    return jsonify({'todo_list':todo_list}), 200

@todos.route('/<oid>', methods=['GET'])
@jwt_required()
def get(oid):
    todo = current_app.db.todos.find_one({'_id': ObjectId(oid)})

    if not todo:
        return jsonify({'message': "Item not found"}), 404

    return jsonify({
            '_id': str(todo['_id']),
            'header': todo['header'],
            'detail': todo['detail'],
            'iscompleted': todo['iscompleted'],
            'userid': todo['userid']
        }), 200
    