@echo off
chcp 65001 >nul
echo ========================================
echo Восстановление базы данных sakila
echo ========================================
echo.

echo Проверка запуска контейнера...
docker ps | findstr mysql_homework >nul
if %errorlevel% neq 0 (
    echo Ошибка: Контейнер mysql_homework не запущен
    echo Сначала запустите init_db.bat или continue_db.bat
    pause
    exit /b 1
)

echo.
echo [1/3] Копирование файлов sakila в контейнер...
docker cp ./Resources/sakila-db/sakila-schema.sql mysql_homework:/tmp/
docker cp ./Resources/sakila-db/sakila-data.sql mysql_homework:/tmp/

echo.
echo [2/3] Восстановление схемы sakila...
docker exec mysql_homework mysql -u root -prootpassword -e "source /tmp/sakila-schema.sql"
if %errorlevel% neq 0 (
    echo Ошибка: Не удалось восстановить схему
    pause
    exit /b 1
)

echo.
echo [3/3] Восстановление данных sakila...
docker exec mysql_homework mysql -u root -prootpassword -e "source /tmp/sakila-data.sql"
if %errorlevel% neq 0 (
    echo Ошибка: Не удалось восстановить данные
    pause
    exit /b 1
)

echo.
echo ========================================
echo База данных sakila успешно восстановлена!
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
echo   Database: sakila
echo.
pause
