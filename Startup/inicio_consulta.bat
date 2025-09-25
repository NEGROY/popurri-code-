@echo off
cd C:\negroy\LARAGOON\masivas
call venv\Scripts\activate.bat
uvicorn main:app --host 172.20.97.102 --port 8000 --workers 2
