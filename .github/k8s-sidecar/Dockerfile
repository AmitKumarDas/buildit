# REFER:
# - https://pythonspeed.com/articles/multi-stage-docker-python/
# - https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
FROM python:3.11.0-alpine3.17 AS base

FROM base as builder

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apk add --no-cache gcc

COPY  src/requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir -r requirements.txt

COPY  src/logger.py /app/logger.py
COPY  src/sidecar.py /app/sidecar.py
COPY  src/helpers.py /app/helpers.py
COPY  src/resources.py /app/resources.py

#RUN rm find /app/.venv \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' \+

FROM base
ENV PYTHONUNBUFFERED=1
WORKDIR /app

COPY    --from=builder /app /app
ENV VIRTUAL_ENV=/app/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Use the nobody user's numeric UID/GID to satisfy MustRunAsNonRoot PodSecurityPolicies
# https://kubernetes.io/docs/concepts/policy/pod-security-policy/#users-and-groups
USER    65534:65534
CMD [ "python", "-u", "/app/sidecar.py" ]
