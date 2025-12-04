# Movies-Interface

A simple, modern Flask + MySQL application to track your favorite movies with user session management.

## Features

- 🔐 User authentication (login/register/logout)
- 🎬 Personal movie collection per user
- ⭐ Rate movies (1-5 stars)
- 📝 Add reviews
- 🔗 Link to IMDb pages
- 🖼️ Movie poster display
- 🎨 Modern dark theme interface

## Requirements

- Python 3.8+
- MySQL 5.7+ or MariaDB 10.3+

## Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/Movies-Interface.git
cd Movies-Interface
```

2. **Create a virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Set up MySQL database**
```bash
mysql -u root -p < init.sql
```

5. **Configure environment variables** (optional)
```bash
export SECRET_KEY='your-secret-key'
export DATABASE_URL='mysql+pymysql://user:password@localhost/movies_db'
export FLASK_DEBUG='true'  # Enable debug mode for development
```

Or edit `config.py` directly.

6. **Run the application**
```bash
python app.py
```

7. **Open in browser**
```
http://localhost:5000
```

## Database Schema

### Users Table
| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| username | VARCHAR(80) | Unique username |
| display_name | VARCHAR(120) | Display name |
| password_hash | VARCHAR(256) | Hashed password |

### Movies Table
| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| title | VARCHAR(200) | Movie title |
| year | INT | Release year |
| genre | VARCHAR(100) | Movie genre |
| director | VARCHAR(150) | Director name |
| rating | INT | Rating (1-5) |
| review | TEXT | User review |
| imdb_link | VARCHAR(300) | Link to IMDb |
| poster_url | VARCHAR(500) | Poster image URL |
| user_id | INT | Foreign key to users |

## Sample Data

The `init.sql` file includes sample data:
- **User**: badr (Badr)
- **Movies**: Inception, The Dark Knight, Interstellar, Pulp Fiction, The Shawshank Redemption

## Project Structure

```
Movies-Interface/
├── app.py              # Main Flask application
├── config.py           # Configuration settings
├── models.py           # Database models
├── requirements.txt    # Python dependencies
├── init.sql           # Database initialization script
├── templates/          # HTML templates
│   ├── base.html
│   ├── login.html
│   ├── register.html
│   ├── movies.html
│   ├── add_movie.html
│   └── edit_movie.html
└── static/
    └── css/
        └── style.css   # Styles
```

## Screenshots

### Login Page
Clean login interface with dark theme.

### Movie Collection
Grid view of your movie collection with posters, ratings, and quick actions.

### Add/Edit Movie
Simple form to add or edit movie details.

## License

MIT License