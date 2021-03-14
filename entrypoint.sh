#!/usr/bin/env bash

./wait-for-it.sh -t 0 $DATABASE_HOST:$DATABASE_PORT -- echo "SQL Server is up"
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
