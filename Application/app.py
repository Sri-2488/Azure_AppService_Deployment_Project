import os
from flask import Flask, jsonify, render_template

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(__name__,  template_folder=os.path.join(BASE_DIR, "templates"),
    static_folder=os.path.join(BASE_DIR, "static"))

ENVIRONMENT = os.getenv('ENVIRONMENT','Development')
RELEASE_VERSION = os.getenv('RELEASE_VERSION','1.0.0')

@app.route('/')
def home():
    return render_template(
        "index.html",
        environment=ENVIRONMENT,
        release=RELEASE_VERSION
    )

@app.route('/health')
def health():
    return jsonify({
        "status": "Healthy",
        "environment": ENVIRONMENT,
        "release": RELEASE_VERSION
    }), 200

@app.route('/about')
def about():
    return jsonify({
        "company": " SriSolutions Australia",
        "application": " Cloud Hosted Web Application",
        "environment": ENVIRONMENT,
        "release": RELEASE_VERSION
    }), 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port)


print("Current working directory:", os.getcwd())
print("Template folder:", app.template_folder)
print("Template path:", app.jinja_loader.searchpath)
print("Templates directory exists:",
      os.path.exists(os.path.join(os.getcwd(), "templates")))