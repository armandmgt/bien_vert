# syntax=docker/dockerfile:1
# check=error=true

FROM python:3.12-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git pkg-config sentencepiece && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

CMD [ "python", "-m", "flask", "--app", "app.main:main", "run" ]
