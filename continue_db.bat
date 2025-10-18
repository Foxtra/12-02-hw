@echo off
chcp 65001 >nul
echo ========================================
echo Запуск MySQL базы данных
echo ========================================
echo.

echo Запуск контейнера...
docker-compose up -d
if %errorlevel% neq 0 (
    echo Ошибка: Не удалось запустить контейнер
    pause
    exit /b 1
)

echo.
echo Ожидание готовности MySQL (10 секунд)...
timeout /t 10 /nobreak >nul

echo.
echo Проверка статуса контейнера...
docker ps | findstr mysql_homework >nul
if %errorlevel% neq 0 (
    echo Ошибка: Контейнер mysql_homework не запущен
    pause
    exit /b 1
) else (
    echo Контейнер mysql_homework успешно запущен
)

echo.
echo ========================================
echo База данных запущена!
echo ========================================
echo.
echo Для подключения используйте:
echo   Host: localhost
echo   Port: 3306
echo   User: root
echo   Password: rootpassword
echo   Database: sakila
echo.
echo Или для пользователя sys_temp:
echo   User: sys_temp
echo   Password: temp_password
echo.
echo Для повторного развёртывания используйте: init_db.bat
echo Для остановки используйте: stop_db.bat
echo.
pause
