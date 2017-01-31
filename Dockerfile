FROM python:3.5.1-onbuild
WORKDIR /code
ADD . /code
CMD python app.py
