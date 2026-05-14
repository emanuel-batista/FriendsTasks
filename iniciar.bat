@echo off
setlocal

set ROOT=%~dp0
set API_JAR=%ROOT%api-escola-conectada\target\api-escola-conectada-0.0.1-SNAPSHOT.jar
set FLUTTER_DIR=%ROOT%friends_tasks

echo ============================================
echo  Friends Tasks - Iniciador
echo ============================================

:: Verifica se o JAR existe
if not exist "%API_JAR%" (
    echo [ERRO] JAR da API nao encontrado: %API_JAR%
    echo Execute o build da API antes: mvn clean package -f api-escola-conectada/pom.xml
    pause
    exit /b 1
)

:: Inicia a API em uma nova janela
echo [1/2] Iniciando API Spring Boot...
start "API - Escola Conectada" java -jar "%API_JAR%"

:: Aguarda a API subir
echo [2/2] Aguardando API inicializar (10s)...
timeout /t 10 /nobreak >nul

:: Roda o Flutter Web
echo Iniciando Flutter Web...
cd /d "%FLUTTER_DIR%"
flutter run -d chrome

endlocal
