# ---------- Builder ----------
FROM python:3.10-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt --target /app

COPY app.py .

# ---------- Runtime (DISTROLESS) ----------
FROM gcr.io/distroless/python3-debian11

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 8501

CMD ["app.py"]
