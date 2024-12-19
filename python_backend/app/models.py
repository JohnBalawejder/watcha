from . import db

# User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)  # Unique user ID
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)  # Store hashed passwords
    watched_movies = db.relationship('WatchedMovie', backref='user', lazy=True)  # Relationship to watched movies

# WatchedMovie model
class WatchedMovie(db.Model):
    id = db.Column(db.Integer, primary_key=True)  # Unique ID for each movie/show
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)  # Link to the user
    title = db.Column(db.String(255), nullable=False)  # Movie/show title
    type = db.Column(db.String(50))  # "movie" or "tv"
    ranking = db.Column(db.Integer)  # User ranking (1-10)
    genre = db.Column(db.String(255))  # Genre from OMDB API
    poster = db.Column(db.String(255))  # Poster URL from OMDB API
    release_year = db.Column(db.String(4))  # Release year from OMDB API

# Swipe model
class Swipe(db.Model):
    id = db.Column(db.Integer, primary_key=True)  # Unique ID for each swipe entry
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)  # Link to the user
    title = db.Column(db.String(255), nullable=False)
    swipe = db.Column(db.String(10))  # "left" or "right"
