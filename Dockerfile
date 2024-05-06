# 1. docker build -t lululau/ocrs-cache:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from lululau/ocrs-cache:latest --target resolver .
# 2. docker build -t lululau/ocrs:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from lululau/ocrs-cache:latest --target app .

LABEL MAINTAINER="liuxiang921@gmail.com"

FROM lululau/poetry-python39:latest as resolver

WORKDIR /ocrs/
ADD pyproject.toml poetry.lock /ocrs/
ENV POETRY_CACHE_DIR=/ocrs/.poetry_cache
RUN poetry install


FROM lululau/poetry-python39:latest as app
ADD . /ocrs
WORKDIR /ocrs
ENV POETRY_CACHE_DIR=/ocrs/.poetry_cache
COPY --from=resolver /ocrs/.poetry_cache /ocrs/.poetry_cache

EXPOSE 5000

CMD ["poetry", "run", "flask", "--app", "ocrs.app", "run", "--host", "0.0.0.0"]
