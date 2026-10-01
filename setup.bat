@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
echo === Computer Programming Project : setup ===
set "PYTHON_CMD="
set "USE_UV=0"
set "UV_CMD=uv"
where python >nul 2>nul
if not errorlevel 1 (
  python -c "import sys; sys.exit(0 if sys.version_info >= (3,11) else 1)" >nul 2>nul
  if not errorlevel 1 set "PYTHON_CMD=python"
)
if not defined PYTHON_CMD (
  where uv >nul 2>nul
  if not errorlevel 1 (
    set "USE_UV=1"
  ) else if exist "%USERPROFILE%\.local\bin\uv.exe" (
    set "USE_UV=1"
    set "UV_CMD=%USERPROFILE%\.local\bin\uv.exe"
  )
)
if not defined PYTHON_CMD if "%USE_UV%"=="0" (
  echo [!] Python 3.11+ or uv was not found. Install Python or uv, then try again.
  pause
  exit /b 1
)
if not exist .venv\Scripts\python.exe (
  echo [1/2] creating .venv ...
  if "%USE_UV%"=="1" (
    %UV_CMD% venv --python 3.12 .venv || (echo [!] could not create .venv with uv & pause & exit /b 1)
  ) else (
    %PYTHON_CMD% -m venv .venv || (echo [!] could not create .venv & pause & exit /b 1)
  )
) else (
  echo [1/2] .venv already exists
)
echo [2/2] installing flask + pytest ...
if "%USE_UV%"=="1" (
  %UV_CMD% pip install --python ".venv\Scripts\python.exe" --quiet --no-index --find-links wheels -r requirements.txt >nul 2>nul
  if errorlevel 1 (
    echo     offline wheels did not match this Python - trying online ...
    %UV_CMD% pip install --python ".venv\Scripts\python.exe" --quiet -r requirements.txt || (echo [!] install failed - check your internet connection & pause & exit /b 1)
  )
) else (
  ".venv\Scripts\python.exe" -m pip install --quiet --no-index --find-links wheels -r requirements.txt 2>nul
  if errorlevel 1 (
    echo     offline wheels did not match this Python - trying online ...
    ".venv\Scripts\python.exe" -m pip install --quiet -r requirements.txt || (echo [!] install failed - check your internet connection & pause & exit /b 1)
  )
)
".venv\Scripts\python.exe" -c "import flask, pytest; print('    flask', flask.__version__ if hasattr(flask,'__version__') else 'ok', '/ pytest', pytest.__version__)"
echo.
echo Done. Next:  run.bat   (opens the site)    check.bat   (score + tests)
pause
