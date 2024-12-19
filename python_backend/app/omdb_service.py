import requests

# OMDb API Key and Base URL (replace 'your_api_key_here' with your actual API key)
OMDB_API_KEY = '580183dc'
OMDB_BASE_URL = 'http://www.omdbapi.com/'

def fetch_movie_thumbnails(query):
    """
    Fetches movie posters (thumbnails) from the OMDb API based on a search query.

    Args:
        query (str): The movie title or search keyword.

    Returns:
        list: A list of movies with their titles, years, and poster URLs.
    """
    # Build the request URL
    url = f"{OMDB_BASE_URL}?apikey={OMDB_API_KEY}&s={query}"
    
    try:
        # Send GET request to OMDb API
        response = requests.get(url)
        response.raise_for_status()  # Raise exception for HTTP errors
        
        # Parse the response as JSON
        data = response.json()
        
        # Check if the API returned an error
        if data.get('Response') == 'False':
            return {"error": data.get("Error", "No results found")}

        # Extract movie titles, years, and poster URLs
        movie_thumbnails = [
            {"title": movie.get("Title"), 
             "year": movie.get("Year"), 
             "poster": movie.get("Poster")}
            for movie in data.get("Search", []) if movie.get("Poster") != "N/A"
        ]
        return movie_thumbnails

    except Exception as e:
        return {"error": str(e)}
