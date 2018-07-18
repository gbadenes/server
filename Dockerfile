# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory (server.py) contents into the container at /app
ADD . /app

# Make port 12345 available outside this container
EXPOSE 12345

# Run server.py when the container launches
CMD ["python", "server.py"]
