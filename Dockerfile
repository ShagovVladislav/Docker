# --- build stage: готовим колёса для быстрых повторных сборок ---
FROM python:3.12-slim AS build
WORKDIR /app

# Устанавливаем системные зависимости при необходимости (оставил минимально)
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

COPY src/ /app

# --- runtime stage: чистый рантайм ---
FROM python:3.12-slim
WORKDIR /app

# Без кэшей pip
ENV PIP_NO_CACHE_DIR=1 PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# Ставим зависимости из колёс
COPY --from=build /wheels /wheels
RUN pip install /wheels/* && useradd -m -u 10001 appuser

# Копируем код приложения
COPY --from=build /app /app

# Здоровье и безопасный пользователь
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -fsS http://localhost:5000/health || exit 1
USER appuser

EXPOSE 6000
CMD ["python", "app.py"]
