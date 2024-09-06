# Use an official Python runtime as a parent image
FROM python:3.9-alpine3.13

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory to /app
WORKDIR /app

# Copy the requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Create a virtual environment and install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Copy the project files to /app
COPY ./app /app

# Add the virtual environment to the PATH
ENV PATH="/py/bin:$PATH"

# Expose the port the app runs on
EXPOSE 8000

# Switch to the non-root user
USER django-user

# Command to run the application (adjust as needed)
# CMD ["gunicorn", "myapp.wsgi:application", "--bind", "0.0.0.0:8000"]
