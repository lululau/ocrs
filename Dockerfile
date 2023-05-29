# 1. docker build -t reg.ktjr.com/utils/ocrs-cache:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from reg.ktjr.com/utils/ocrs-cache:latest --target resolver .
# 2. docker build -t reg.ktjr.com/utils/ocrs:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from reg.ktjr.com/utils/ocrs-cache:latest --target app .

MAINTAINER liuxiang@ktjr.com

FROM reg.ktjr.com/sre/poetry-python39:latest as resolver

WORKDIR /ocrs/
ADD pyproject.toml poetry.lock /ocrs/
ENV POETRY_CACHE_DIR=/ocrs/.poetry_cache
RUN poetry install


FROM reg.ktjr.com/sre/poetry-python39:latest as app
ADD . /ocrs
WORKDIR /ocrs
ENV POETRY_CACHE_DIR=/ocrs/.poetry_cache
COPY --from=resolver /ocrs/.poetry_cache /ocrs/.poetry_cache

EXPOSE 5000

CMD ["poetry", "run", "flask", "--app", "ocrs.app", "run", "--host", "0.0.0.0"]
