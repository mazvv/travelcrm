#! /bin/bash

../bin/python setup.py extract_messages
../bin/python setup.py update_catalog
../bin/python setup.py compile_catalog

