from flask import Flask, jsonify
from prometheus_client import generate_latest, Counter, Summary

app = Flask(__name__)
REQS = Counter('http_requests_total', 'Total HTTP requests', ['endpoint'])
LAT  = Summary('http_request_seconds', 'Request latency')

@app.route('/')
@LAT.time()
def index():
    REQS.labels('/').inc()
    return jsonify({"message": "hello from AKS"})

@app.route('/health')
def health():
    REQS.labels('/health').inc()
    return "ok", 200

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain; charset=utf-8'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
