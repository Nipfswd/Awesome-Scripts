# Mini Link Shortener

A simple Flask-based URL shortener with basic analytics.

---

## Features

- Shortens long URLs into short 6-character keys  
- Redirects short URLs to original URLs  
- Tracks total clicks and timestamps of the last clicks  
- Provides an analytics page with URL, clicks, creation date, and recent click times  
- Stores data persistently in a JSON file (`links.json`)

---

## Requirements

- Python 3.x  
- Flask  
- No external database needed (uses JSON file)

Install Flask if you don't have it:

```bash
pip install Flask
```
## Usage

Run the app:

```bash
python link_shortener.py
```

Open your browser and go to:
```bash
http://127.0.0.1:5000/
```
