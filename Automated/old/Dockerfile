FROM python:3.4

# Creating Application Source Code Directory
RUN mkdir -p /usr/src/app

# Setting Home Directory for containers
WORKDIR /usr/src/app

# Installing python dependencies
COPY requirements.txt /usr/src/app/
RUN pip install -r requirements.txt

# Copying src code to Container
COPY ./ /usr/src/app

# Application Environment variables
# ENV APP_ENV development

# Exposing Ports
EXPOSE 80

ENTRYPOINT ["python3"]

# Setting Persistent data
VOLUME ["/app-data"]

# Running Python Application
CMD ["_main_.py"]
