# Base image
FROM python:3.11

# Set working directory inside container
WORKDIR /app

# Copy files from local machine to container
COPY . .

# Install dependencies
RUN pip install flask

# Expose application port
EXPOSE 5000

# Command to run application
CMD ["python", "app.py"]