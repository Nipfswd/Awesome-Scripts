from flask import Flask, request, redirect, render_template_string, abort
import hashlib
import json
import os
import time

app = Flask(__name__)
DATA_FILE = 'links.json'

# Load data from JSON or create empty
if os.path.exists(DATA_FILE):
    with open(DATA_FILE, 'r') as f:
        data = json.load(f)
else:
    data = {}

def save_data():
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def generate_short_key(url):
    # Generate a short 6-char key based on url hash
    h = hashlib.md5(url.encode()).hexdigest()
    return h[:6]

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        url = request.form.get('url')
        if not url:
            return render_template_string(PAGE, error="Please enter a URL.")
        key = generate_short_key(url)
        if key not in data:
            data[key] = {
                'url': url,
                'created': time.time(),
                'clicks': 0,
                'click_log': []
            }
            save_data()
        short_url = request.host_url + key
        return render_template_string(PAGE, short_url=short_url)
    return render_template_string(PAGE)

@app.route('/<key>')
def redirect_link(key):
    entry = data.get(key)
    if not entry:
        abort(404)
    entry['clicks'] += 1
    entry['click_log'].append(time.time())
    save_data()
    return redirect(entry['url'])

@app.route('/analytics')
def analytics():
    return render_template_string(ANALYTICS_PAGE, data=data)

PAGE = """
<!doctype html>
<title>Mini Link Shortener</title>
<h2>Mini Link Shortener</h2>
<form method="post">
  <input type="text" name="url" placeholder="Enter a long URL" style="width:400px;" required>
  <input type="submit" value="Shorten">
</form>
{% if error %}
<p style="color:red;">{{ error }}</p>
{% endif %}
{% if short_url %}
<p>Short URL: <a href="{{ short_url }}">{{ short_url }}</a></p>
{% endif %}
<p><a href="/analytics">View Analytics</a></p>
"""

ANALYTICS_PAGE = """
<!doctype html>
<title>Analytics - Mini Link Shortener</title>
<h2>Link Analytics</h2>
<table border="1" cellpadding="5" cellspacing="0">
  <tr>
    <th>Short Key</th>
    <th>Original URL</th>
    <th>Clicks</th>
    <th>Created</th>
    <th>Last 5 Click Timestamps</th>
  </tr>
  {% for key, info in data.items() %}
  <tr>
    <td><a href="/{{ key }}">{{ key }}</a></td>
    <td><a href="{{ info.url }}">{{ info.url }}</a></td>
    <td>{{ info.clicks }}</td>
    <td>{{ info.created | timestamp_to_str }}</td>
    <td>
      {% for ts in info.click_log[-5:] %}
        {{ ts | timestamp_to_str }}<br>
      {% else %}
        No clicks yet
      {% endfor %}
    </td>
  </tr>
  {% endfor %}
</table>
<p><a href="/">Back to Shortener</a></p>
"""

@app.template_filter('timestamp_to_str')
def timestamp_to_str(ts):
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(ts))

if __name__ == '__main__':
    app.run(debug=True)
