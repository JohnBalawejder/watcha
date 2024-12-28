import requests
from flask import Blueprint, jsonify, request
from app import db, bcrypt
from app.models import User, WatchedMovie
from flask_jwt_extended import create_access_token


api_routes = Blueprint('api_routes', __name__)


@api_routes.route('/register', methods = ['POST'])
def register():
    """
    Register a new user.

    Request Body:
        {
            "username": "example_user",
            "password": "secure_password"
        }

    Returns:
        201: Success with message.
        400: If username already exists.
    """
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Check if username already exists
    if User.query.filter_by(username=username).first():
        return jsonify({"error": "Username already exists"}), 400
    
    # Hash the password
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

    # save user to database
    new_user = User(username=username, password_hash = hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201



@api_routes.route('/login', methods=['POST'])
def login():
    """
    Authenticate a user.

    Request Body:
        {
            "username": "example_user",
            "password": "secure_password"
        }

    Returns:
        200: JWT token for authentication.
        401: If credentials are invalid.
    """
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Find user by username
    user = User.query.filter_by(username=username).first()
    if not user or not bcrypt.check_password_hash(user.password_hash, password):
        return jsonify({"error": "Invalid username or password"})
    
    # Generate JWT token
    access_token = create_access_token(identity=str(user.id))
    return jsonify({"access_token": access_token}), 200


@api_routes.route('/thumbnails', methods=['GET'])
def get_movie_thumbnails():
    query = request.args.get('query', default='', type=str)
    if not query:
        return jsonify({"error": "Query parameter is required"}), 400

    omdb_api_key = "580183dc"
    omdb_url = f"http://www.omdbapi.com/?apikey={omdb_api_key}&s={query}"
    response = requests.get(omdb_url)

    if response.status_code != 200:
        return jsonify({"error": "Failed to fetch data from OMDb"}), 500

    movies = response.json().get('Search', [])
    results = []

    for movie in movies:
        # Fetch full details for each movie
        details_url = f"http://www.omdbapi.com/?apikey={omdb_api_key}&t={movie['Title']}"
        details_response = requests.get(details_url)
        details_data = details_response.json()

        # Append details including genre
        results.append({
            "title": details_data.get("Title", "Unknown"),
            "genre": details_data.get("Genre", "Unknown"),
            "poster": details_data.get("Poster", "N/A"),
            "release_year": details_data.get("Year", "N/A"),
        })

    return jsonify({"thumbnails": results})




from flask_jwt_extended import jwt_required, get_jwt_identity

@api_routes.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    """
    example protected route
    """

    user_id = int(get_jwt_identity())

    return jsonify({"message": "You have access to this protected route"}), 200



@api_routes.route('/watched', methods=['POST'])
@jwt_required()
def add_watched_movie():
    """
    Add a movie/show to the user's watched list.

    Request Body:
        {
            "title": "Inception",
            "type": "movie",  # or "tv"
            "ranking": 9
        }

    Returns:
        201: Success with movie details.
        400: If input validation fails.
    """

    user_id = int(get_jwt_identity())
    data = request.get_json()

    title = data.get('title')
    type_ = data.get('type')
    ranking = data.get('ranking')

    if not title or not type_ or not ranking:
        return jsonify({"error": "Title, type, and ranking are required"}), 400
    
    # Query OMDB API for metadata
    omdb_api_key = "580183dc"
    omdb_url = f"http://www.omdbapi.com/?apikey={omdb_api_key}&t={title}"
    omdb_response = requests.get(omdb_url).json()

    if omdb_response.get("Response") == "False":
        return jsonify({"error": "Movie not found"}), 404
    
    # Extract metadata
    genre = omdb_response.get("Genre", "Unknown")
    poster = omdb_response.get("Poster", "N/A")
    release_year = omdb_response.get("Year", "N/A")

    # Save to the database
    new_movie = WatchedMovie(
        user_id=user_id,
        title=title,
        type=type_,
        ranking=ranking,
        genre=genre,
        poster=poster,
        release_year=release_year

    )        
    db.session.add(new_movie)
    db.session.commit()

    return jsonify({
        "id": new_movie.id,
        "title": new_movie.title,
        "type": new_movie.type,
        "ranking": new_movie.ranking,
        "genre": new_movie.genre,
        "poster": new_movie.poster,
        "release_year": new_movie.release_year
    }), 201

@api_routes.route('/watched', methods=['GET'])
@jwt_required()
def get_watched_movies():
    """
    Retrieve the user's watched list.

    Returns:
        200: List of watched movies/shows.
    """
    user_id = int(get_jwt_identity())  # Get the authenticated user's ID

    # Query the database for the user's watched movies
    watched_movies = WatchedMovie.query.filter_by(user_id=user_id).all()

    # Serialize the results
    result = [
        {
            "id": movie.id,
            "title": movie.title,
            "type": movie.type,
            "ranking": movie.ranking,
            "genre": movie.genre,
            "poster": movie.poster,
            "release_year": movie.release_year
        }
        for movie in watched_movies
    ]

    return jsonify(result), 200



@api_routes.route('/watched/<int:movie_id>', methods=['DELETE'])
@jwt_required()
def delete_watched_movie(movie_id):
    user_id = int(get_jwt_identity())

    try:
        movie = WatchedMovie.query.filter_by(id=movie_id, user_id=user_id).first()
        if not movie:
            return jsonify({"error": "Movie not found in your watchlist"}), 404

        db.session.delete(movie)
        db.session.commit()
        return jsonify({"message": "Movie removed from your watchlist"}), 200
    except Exception as e:
        print("Error deleting movie:", str(e))
        return jsonify({"error": "Failed to delete movie"}), 500
