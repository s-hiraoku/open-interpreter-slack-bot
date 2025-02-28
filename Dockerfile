# Set the base image
FROM python:3.10

# Set the working directory
WORKDIR /app

# Update and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libgl1-mesa-dev ffmpeg fonts-ipaexfont libtesseract-dev tesseract-ocr tesseract-ocr-jpn curl && \
    rm -rf /var/lib/apt/lists/*

# Install python packages
COPY requirements.txt .
RUN pip install -r requirements.txt

# Set japanese font for matplotlib
RUN sed -i "s/^#font\.family.*/font.family:  IPAexGothic/g" /usr/local/lib/python3.10/site-packages/matplotlib/mpl-data/matplotlibrc

# Copy the rest of the application
COPY . .

# Start the application
CMD ["gunicorn", "-b", "0.0.0.0:8080", "main:app"]
