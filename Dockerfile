# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy application code
COPY . .

# Install dependencies
RUN pip install -r requirements.txt

# Expose the application port
EXPOSE 5000

# Command to run the application
CMD ["python", "application.py"]

