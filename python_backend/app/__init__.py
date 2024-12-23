from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt
from flask_cors import CORS

# DB initalization
db = SQLAlchemy()

# JWT and bcrypt (password hashing)
jwt = JWTManager()
bcrypt = Bcrypt()

def create_app():
    app = Flask(__name__)

    CORS(app)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///watcha.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    app.config['JWT_SECRET_KEY'] = '6039f176552f4cbef087602ff347e035c93d14531dd3e14f993d55b21acb276d'

    db.init_app(app)
    jwt.init_app(app)
    bcrypt.init_app(app)

    # Example route for testing
    @app.route("/")
    def hello():
        return "Hello, Watcha!"
    
    from .routes import api_routes
    app.register_blueprint(api_routes)

    return app
