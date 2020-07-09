# Base Image from Python Alpine ~95.1MB
FROM python:3.6.4-alpine3.7

# Running image python gunicorn app! 
# Environment Mapping
WORKDIR /app
ADD     ./app /app
COPY    ./app/requirements.txt /etc

# Deployment App!
RUN     pip install -r /etc/requirements.txt
EXPOSE  8000:8000
CMD     ["gunicorn" , "-b", "0.0.0.0:8000", "--log-level", "debug", "api:app"]