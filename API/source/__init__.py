from flask import Flask
from source.auth import auth
from source.todos import todos

def create_app(test_config:None):
    app = Flask(__name__, instance_relative_config=True)

    if test_config is None:
        app.config.from_mapping(
            SECRET_KEY = "",
            # =
            # =
            # =

        )
    else:
        app.config.from_mapping(test_config)

    app.register_blueprint(auth)
    app.register_blueprint(todos)
    return app    