#!/bin/sh
echo "Starting SSH..."
/usr/sbin/sshd

echo "Template Setup"
yarn install
python --version

echo "Venv Setup"
pipenv install --dev --skip-lock
pipenv --venv
. $(pipenv --venv)/bin/activate
python manage.py migrate

echo "Starting Dev Server + Gunicorn..."
yarn build
gunicorn --bind=0.0.0.0 --timeout 600 --log-level debug --access-logfile /django_vue/gunicorn-access.log --error-logfile /django_vue/gunicorn-error.log  backend.wsgi:application


