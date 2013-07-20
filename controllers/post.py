from flask.ext import restful
from flask.ext.restful import reqparse
from models import session
from models.post import Post

parser = reqparse.RequestParser()
parser.add_argument('title', type=str, required=True, help='Title Required')
parser.add_argument('body', type=str, required=True, help='Body Required')

class PostController(restful.Resource):
    def get(self, id):
        p = session.query(Post).get(id)
        if p is None:
            return {'error': 'Post not found'}, 404
        return p.as_dict()

    def post(self):
        args = parser.parse_args()
        p = Post(title=args['title'], body=args['body'])

        try:
            session.add(p)
            session.commit()
        except IntegrityError, exc:
            return {'error': exc.message}, 500

        return p.as_dict(), 201
