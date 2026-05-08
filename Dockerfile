FROM python:3.10-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERDE=1
WORKDIR /app
COPY requirements.txt .
RUN apt-get update \
&& apt-get install -y --on-install-recommends gcc libc-dev \
&& pip install -no-cache-dir -r requirements.txt \
&& apt-get remove -y gcc libc-dev \
&& apt-get autoremove -y \
&& rm -rvf /var/lib/apt/lists/*
COPY . .
RUN python3 model/train.py 
EXPOSE 6000
CMD ["gunicorn","--workers","4","--bind","0.0.0.0:6000","app:app"]
