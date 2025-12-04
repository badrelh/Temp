import os
import secrets

class Config:
    # In production, always set SECRET_KEY environment variable
    SECRET_KEY = os.environ.get('SECRET_KEY') or secrets.token_hex(32)
    # Use MySQL in production, SQLite for local testing if DATABASE_URL not set
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'mysql+pymysql://root:password@localhost/movies_db'
    # For quick local testing without MySQL, uncomment the line below:
    # SQLALCHEMY_DATABASE_URI = 'sqlite:///movies.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False

