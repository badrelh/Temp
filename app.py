from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from flask_wtf.csrf import CSRFProtect
from config import Config
from models import db, User, Movie

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)
csrf = CSRFProtect(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Create tables
with app.app_context():
    db.create_all()

@app.route('/')
def index():
    if current_user.is_authenticated:
        return redirect(url_for('movies'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('movies'))
    
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        
        if not username or not password:
            flash('Username and password are required', 'error')
            return render_template('login.html')
        
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password):
            login_user(user)
            return redirect(url_for('movies'))
        flash('Invalid username or password', 'error')
    
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('movies'))
    
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        display_name = request.form.get('display_name', '').strip()
        password = request.form.get('password', '')
        
        if not username or not display_name or not password:
            flash('All fields are required', 'error')
            return render_template('register.html')
        
        if len(username) < 3:
            flash('Username must be at least 3 characters', 'error')
            return render_template('register.html')
        
        if len(password) < 6:
            flash('Password must be at least 6 characters', 'error')
            return render_template('register.html')
        
        if User.query.filter_by(username=username).first():
            flash('Username already exists', 'error')
            return render_template('register.html')
        
        user = User(username=username, display_name=display_name)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()
        
        flash('Registration successful! Please login.', 'success')
        return redirect(url_for('login'))
    
    return render_template('register.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/movies')
@login_required
def movies():
    user_movies = Movie.query.filter_by(user_id=current_user.id).all()
    return render_template('movies.html', movies=user_movies)

@app.route('/movies/add', methods=['GET', 'POST'])
@login_required
def add_movie():
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        year_str = request.form.get('year', '')
        genre = request.form.get('genre', '').strip()
        director = request.form.get('director', '').strip()
        rating_str = request.form.get('rating', '')
        review = request.form.get('review', '').strip()
        imdb_link = request.form.get('imdb_link', '').strip()
        poster_url = request.form.get('poster_url', '').strip()
        
        # Validate required fields
        if not title or not genre or not director:
            flash('Title, genre, and director are required', 'error')
            return render_template('add_movie.html')
        
        # Validate year
        try:
            year = int(year_str)
            if year < 1900 or year > 2030:
                raise ValueError
        except (ValueError, TypeError):
            flash('Please enter a valid year (1900-2030)', 'error')
            return render_template('add_movie.html')
        
        # Validate rating
        try:
            rating = int(rating_str)
            if rating < 1 or rating > 5:
                raise ValueError
        except (ValueError, TypeError):
            flash('Please select a valid rating (1-5)', 'error')
            return render_template('add_movie.html')
        
        movie = Movie(
            title=title,
            year=year,
            genre=genre,
            director=director,
            rating=rating,
            review=review if review else None,
            imdb_link=imdb_link if imdb_link else None,
            poster_url=poster_url if poster_url else None,
            user_id=current_user.id
        )
        db.session.add(movie)
        db.session.commit()
        flash('Movie added successfully!', 'success')
        return redirect(url_for('movies'))
    
    return render_template('add_movie.html')

@app.route('/movies/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_movie(id):
    movie = Movie.query.get_or_404(id)
    
    if movie.user_id != current_user.id:
        flash('Access denied', 'error')
        return redirect(url_for('movies'))
    
    if request.method == 'POST':
        title = request.form.get('title', '').strip()
        year_str = request.form.get('year', '')
        genre = request.form.get('genre', '').strip()
        director = request.form.get('director', '').strip()
        rating_str = request.form.get('rating', '')
        review = request.form.get('review', '').strip()
        imdb_link = request.form.get('imdb_link', '').strip()
        poster_url = request.form.get('poster_url', '').strip()
        
        # Validate required fields
        if not title or not genre or not director:
            flash('Title, genre, and director are required', 'error')
            return render_template('edit_movie.html', movie=movie)
        
        # Validate year
        try:
            year = int(year_str)
            if year < 1900 or year > 2030:
                raise ValueError
        except (ValueError, TypeError):
            flash('Please enter a valid year (1900-2030)', 'error')
            return render_template('edit_movie.html', movie=movie)
        
        # Validate rating
        try:
            rating = int(rating_str)
            if rating < 1 or rating > 5:
                raise ValueError
        except (ValueError, TypeError):
            flash('Please select a valid rating (1-5)', 'error')
            return render_template('edit_movie.html', movie=movie)
        
        movie.title = title
        movie.year = year
        movie.genre = genre
        movie.director = director
        movie.rating = rating
        movie.review = review if review else None
        movie.imdb_link = imdb_link if imdb_link else None
        movie.poster_url = poster_url if poster_url else None
        db.session.commit()
        flash('Movie updated successfully!', 'success')
        return redirect(url_for('movies'))
    
    return render_template('edit_movie.html', movie=movie)

@app.route('/movies/delete/<int:id>', methods=['POST'])
@login_required
def delete_movie(id):
    movie = Movie.query.get_or_404(id)
    
    if movie.user_id != current_user.id:
        flash('Access denied', 'error')
        return redirect(url_for('movies'))
    
    db.session.delete(movie)
    db.session.commit()
    flash('Movie deleted successfully!', 'success')
    return redirect(url_for('movies'))

if __name__ == '__main__':
    import os
    debug_mode = os.environ.get('FLASK_DEBUG', 'false').lower() == 'true'
    # app.run(debug=debug_mode)
    app.run(host='0.0.0.0', port=5000, debug=debug_mode)

