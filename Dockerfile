# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy application files to the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port (e.g., Flask app uses port 5000)
EXPOSE 5000

# Run the application
CMD ["python", "application.py"]


