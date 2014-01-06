#! /bin/bash
../bin/alembic revision --autogenerate -m "alter db"
../bin/alembic upgrade head

