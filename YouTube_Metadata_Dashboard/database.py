import sqlite3

DB_NAME = "youtube.db"

def get_connection():
    return sqlite3.connect(DB_NAME)

def create_table():
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_id TEXT UNIQUE,
        title TEXT NOT NULL,
        channel_name TEXT NOT NULL,
        category TEXT,
        views INTEGER,
        likes INTEGER,
        comments INTEGER,
        duration INTEGER,
        upload_date TEXT
    )
    """)
    
    conn.commit()
    conn.close()

def add_video(data):
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
    INSERT INTO videos (video_id, title, channel_name, category, views, likes, comments, duration, upload_date)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, data)
    
    conn.commit()
    conn.close()

def fetch_videos():
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM videos")
    rows = cursor.fetchall()
    
    conn.close()
    return rows

def delete_video(video_id):
    conn = get_connection()
    cursor = conn.cursor()
    
    cursor.execute("DELETE FROM videos WHERE video_id=?", (video_id,))
    
    conn.commit()
    conn.close()