# syntax=docker/dockerfile:1
FROM python:3.10-alpine

WORKDIR /app

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5001

RUN apk add --no-cache gcc musl-dev linux-headers curl

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

EXPOSE 5001

COPY ./src /app

CMD ["flask", "run"]
