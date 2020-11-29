# app.py
from flask import Flask, request, jsonify
from flask_cors import CORS
from vote import Vote

app = Flask(__name__)
CORS(app)

vote = Vote({
    "options": [],
    "voters": [],
    "missing": [],
    "complete": [],
})

@app.route('/getVote/', methods=['GET'])
def getConfigurations():
    return jsonify(vote.toJson())

@app.route('/getVote/', methods=['POST'])
def getConfigurations():
    return jsonify(vote.toJson())




if __name__ == '__main__':
    # Threaded option to enable multiple instances for multiple user access support
    app.run(host="192.168.1.9", threaded=True, port=5050)
