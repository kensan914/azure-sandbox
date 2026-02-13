FROM ghcr.io/astral-sh/uv:python3.14-bookworm-slim

WORKDIR /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

# Install dependencies
COPY pyproject.toml ./
RUN uv sync --no-install-project

# Copy application code
COPY main.py ./

# Expose port
EXPOSE 8000

# Run the application
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
