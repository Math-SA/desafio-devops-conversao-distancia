FROM python:3.13.1-slim-bookworm
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . /app/
EXPOSE 5000
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000","app:app"]