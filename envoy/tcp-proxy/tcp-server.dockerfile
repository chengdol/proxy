FROM python:3.9.0-alpine3.12
LABEL maintainer="hhgjlcd@gmail.com"

WORKDIR /usr/src/app

EXPOSE 8000/tcp

COPY server.py ./
CMD ["python", "./server.py"]
