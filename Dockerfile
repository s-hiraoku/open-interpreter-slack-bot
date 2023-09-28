FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libgl1-mesa-dev ffmpeg fonts-ipaexfont libtesseract-dev tesseract-ocr tesseract-ocr-jpn curl && \
    rm -rf /var/lib/apt/lists/*

# install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# install python packages
COPY requirements.txt .
RUN pip install -r requirements.txt

# install npm packages
COPY package*.json ./
RUN npm install

# Set japanese font for matplotlib
RUN sed -i "s/^#font\.family.*/font.family:  IPAexGothic/g" /usr/local/lib/python3.10/site-packages/matplotlib/mpl-data/matplotlibrc

COPY . .

CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]
