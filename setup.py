import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(here, 'README.txt')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.txt')) as f:
    CHANGES = f.read()

requires = [
    'pyramid',
    'pyramid_mako',
    'pyramid_debugtoolbar',
    'pyramid_tm',
    'SQLAlchemy',
    'transaction',
    'zope.sqlalchemy',
    'waitress',
    'colander',
    'wsgithumb',
    'alembic',
    'webhelpers',
    'pyramid_layout',
    'psycopg2',
    'pyramid_beaker',
    'whoosh>=2.5.6',
    'Babel>=0.9.6',
    'phonenumbers>=6.0.0',
    'pyramid_storage>=0.0.5',
    'Sphinx>=1.2.2',
    'sphinx-bootstrap-theme>=0.4.0',
]

setup(
    name='travelcrm',
    version='0.6.1-dev',
    description='travelcrm',
    long_description=README + '\n\n' + CHANGES,
    classifiers=[
      "Programming Language :: Python",
      "Framework :: Pyramid",
      "Topic :: Internet :: WWW/HTTP",
      "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
      ],
    author='Vitalii Mazur',
    author_email='vitalii.mazur@gmail.com',
    url='http://www.travelcrm.org.ua',
    keywords='web wsgi bfg pylons pyramid',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    test_suite='travelcrm',
    install_requires=requires,
    entry_points="""\
    [paste.app_factory]
    main = travelcrm:main
    [console_scripts]
    initialize_travelcrm_db = travelcrm.scripts.initializedb:main
    """,
)
