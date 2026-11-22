import os
from flask import Flask, jsonify, render_template

app = Flask(__name__)

ENVIRONMENT = os.getenv('ENVIRONMENT','Development')
RELEASE_VERSION = os.getenv('RELEASE_VERSION','1.0.0')

@app.route('/')
def HOME():
    return render_template(
        "index.html",
        environment=ENVIRONMENT,
        release=RELEASE_VERSION
    )

@app.route('/health')
def HEALTH():
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
