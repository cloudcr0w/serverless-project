FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x entrypoint.sh


EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD curl --fail http://localhost:5000/health || exit 1
