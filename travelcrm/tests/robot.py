#-*-coding:utf-8-*-

import os
import unittest
from webtest import http
from robotsuite import RobotTestSuite
from paste.deploy import loadapp
from pyramid_robot.layer import Layer, layered


class myPyramidLayer(Layer):
 
    defaultBases = ()
 
    def setUp(self):
        conf_dir = os.path.dirname(__file__)
        app = loadapp('config:test.ini', relative_to=conf_dir)
        self.server = http.StopableWSGIServer.create(app, port=8080)
 
    def tearDown(self):
        self.server.shutdown()
 
PYRAMIDROBOTLAYER = myPyramidLayer()
 
 
def test_suite():
    suite = unittest.TestSuite()
    current_dir = os.path.abspath(os.path.dirname(__file__))
    robot_dir = os.path.join(current_dir, 'robot')
    robot_tests = [
        os.path.join('robot', doc) for doc in
        os.listdir(robot_dir) if doc.endswith('.robot') and
        doc.startswith('test_')
    ]
    for test in robot_tests:
        suite.addTests([
            layered(RobotTestSuite(test),
            layer=PYRAMIDROBOTLAYER),
        ])
 
    return suite

if __name__ == '__main__':
    unittest.main(defaultTest='test_suite')