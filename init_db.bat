@echo off
chcp 65001 >nul
echo ========================================
echo Первоначальная настройка MySQL БД
echo ========================================
echo.

echo [1/4] Остановка и удаление существующих контейнеров...
docker-compose down -v
if %errorlevel% neq 0 (
    echo Предупреждение: Не удалось остановить контейнеры (возможно, они не запущены)
)

echo.
echo [2/4] Удаление volumes для полной очистки БД...
docker volume prune -f
if %errorlevel% neq 0 (
    echo Предупреждение: Не удалось очистить volumes
)

echo.
echo [3/4] Запуск MySQL контейнера...
docker-compose up -d
if %errorlevel% neq 0 (
    echo Ошибка: Не удалось запустить контейнер
    pause
    exit /b 1
)

echo.
echo [4/5] Ожидание готовности MySQL (30 секунд)...
timeout /t 30 /nobreak >nul

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
echo [5/5] Создание базы данных sakila...
docker exec mysql_homework mysql -u root -prootpassword -e "CREATE DATABASE IF NOT EXISTS sakila;"
if %errorlevel% neq 0 (
    echo Ошибка: Не удалось создать базу данных sakila
    pause
    exit /b 1
) else (
    echo База данных sakila создана
)

echo.
echo ========================================
echo База данных готова!
echo ========================================
echo.
echo Для подключения используйте:
echo   Host: localhost
echo   Port: 3306
echo   User: root
echo   Password: rootpassword
echo   Database: sakila
echo.
echo Теперь можно выполнять задания по созданию пользователей.
echo Для восстановления БД sakila используйте: restore_sakila.bat
echo Для остановки используйте: stop_db.bat
echo.
pause
