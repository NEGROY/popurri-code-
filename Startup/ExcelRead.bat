@echo off
cd C:\xampp\htdocs\excelread
python -m uvicorn main:app --host 172.20.97.102 --port 8080 --workers 2
