import os
import sys
try:
    from subprocess import check_output
except ImportError:
    pass

from setuptools import setup, find_packages


here = os.path.abspath(os.path.dirname(__file__))

with open(os.path.join(here, 'README.txt')) as f:
    README = f.read()
with open(os.path.join(here, 'CHANGES.txt')) as f:
    CHANGES = f.read()

if 'sdist' in sys.argv or 'bdist' in sys.argv:
    with open(os.path.join(here, 'VERSION.txt'), 'w') as f:
        build = (
            check_output([
                "hg", "log", "-r", ".", "--template", "{branch} b.{node|short}"
            ])
        )
        f.write(build)


requires = [
    'setuptools',
    'pyramid',
    'pyramid_mako',
    'pyramid_debugtoolbar',
    'pyramid_tm',
    'SQLAlchemy>=1.1.0b3',
    'transaction',
    'zope.sqlalchemy',
    'waitress',
    'colander>=1.3.1',
    'wsgithumb',
    'alembic',
    'WebHelpers2',
    'pyramid_layout',
    'psycopg2',
    'pyramid_beaker',
    'Babel>=1.3',
    'phonenumbers>=7.0.2',
    'pyramid_storage>=0.0.5',
    'pyramid_mailer>=0.14',
    'Sphinx>=1.2.2',
    'apscheduler>=3.0.1',
    'bitmath>=1.0.2-3',
    'smpplib>=0.1',
    'Mock>=2.0.0',
    'python_dateutil>=2.4.0',
    'nose',
    'redis>=2.10.5',
]

setup(
    name='travelcrm',
    version='0.6.5-beta1',
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
    keywords='web wsgi bfg pylons pyramid travel crms',
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
    [pyramid.scaffold]
    travelcrm = scaffold:TravelcrmProjectTemplate
    """,
    message_extractors={
        'travelcrm': [
            ('**.py', 'python', None),
            ('templates/**.mako', 'mako', None),
            ('static/**', 'ignore', None)
        ]
    },
)
