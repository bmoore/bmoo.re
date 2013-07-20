import unittest
from models.post import Post

class TestPostModel(unittest.TestCase):
    def setUp(self):
        self.post = Post(title='The Best Blog', body='This is the best blog, where we talk about money and fun.')

    def test_title(self):
        self.assertEqual(self.post.title, 'The Best Blog', 'Incorrect Title')

    def test_body(self):
        self.assertEqual(self.post.body, 'This is the best blog, where we talk about money and fun.', 'Wrong post body')


    def test_as_dict(self):
        self.assertEqual(self.post.as_dict(), {
            'id': None, 
            'title': 'The Best Blog', 
            'body': 'This is the best blog, where we talk about money and fun.',
        }, 'Wrong Dict')

    def tearDown(self):
        self.post = None
