import os
from flask import Flask
from flask.ext import restful
from controllers.post import PostController

app = Flask(__name__)
api = restful.Api(app)
app.debug = True

api.add_resource(PostController, '/post', '/post/<string:id>')

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)
