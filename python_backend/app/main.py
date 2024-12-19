from app import create_app, db
from app.models import User, WatchedMovie, Swipe

# Initialize the app
app = create_app()

# CLI commands for Database setup
@app.cli.command('create-db')
def create_db():
    """Create the database tables"""
    db.create_all()
    print("Database tables created!")

@app.cli.command('drop-db')
def drop_db():
    """Drop all database tables"""
    db.drop_all()
    print("Database tables dropped!")




if __name__ == '__main__':
    app.run(debug=True, port=5000)
