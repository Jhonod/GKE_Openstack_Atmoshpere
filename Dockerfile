# Gunakan Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements (jika ada)
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy semua source code
COPY . .

# Expose port (misalnya 8080)
EXPOSE 8080

# Command untuk menjalankan aplikasi
CMD ["python", "main.py"]
