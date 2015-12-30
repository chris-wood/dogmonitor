import json
from flask import Flask, jsonify, Response
from functools import wraps
from flask import redirect, request, current_app
from flask import Flask, render_template, abort, request, redirect, url_for, session
from threading import Lock
app = Flask(__name__)

sounds = []
soundIndex = 0
soundSize = 10000

lock = Lock()

def getSoundValue():
    lock.acquire()
    val = sounds[soundIndex]
    soundIndex += 1
    lock.release()
    return val

def addSoundValue(val):
    lock.acquire()
    sounds[soundIndex] = val
    soundIndex = (soundIndex + 1) % soundSize
    lock.release()

def support_jsonp(f):
    """Wraps JSONified output for JSONP"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        callback = request.args.get('callback', False)
        if callback:
            content = str(callback) + '(' + str(f(*args,**kwargs).data) + ')'
            return current_app.response_class(content, mimetype='application/javascript')
        else:
            return f(*args, **kwargs)
    return decorated_function

@app.route("/volume", methods=['GET'])
@support_jsonp
def get_overall_interest():
    valueTuple = sounds[-1]
    data = [{"time": valueTuple[0], "y": float(valueTuple[1])}]
    result = Response(json.dumps(data),  mimetype='application/json')
    return result

@app.route("/data", methods=['POST'])
def post_data():
    if request.json:
        data = request.json
        time = data["time"]

        print "RECEIVED QUERY: %s" % (query)
        if "volume" in data:
            print "ADDING SOUND VALUE"
            val = data["volume"]
            addSoundValue((time, val))
    else:
        pass # do nothing...

    return jsonify(foo="bar")

@app.errorhandler(404)
def errorHandler(data):
    print data
    return data

if __name__ == "__main__":
    app.run(host="172.17.0.189", port=8080, debug=True)
