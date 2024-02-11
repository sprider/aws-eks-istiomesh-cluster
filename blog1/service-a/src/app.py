from flask import Flask
import requests

app = Flask(__name__)


@app.route("/")
def hello():
    response = requests.get("http://blog1-service-b:5001")
    return "Service A calling Service B: " + response.text