@echo off
cd /d "%~dp0"
title Phishing Shield - Backend (modo local)

REM ===== CAMINHOS EXATOS DA SUA MAQUINA =====
set "JAVA_HOME=C:\Users\NHOLANDA\java\jdk-11.0.32.1+1"
set "MAVEN_BIN=C:\Users\NHOLANDA\Downloads\Phishing\apache-maven-3.9.16-bin\apache-maven-3.9.16\bin\mvn.cmd"
REM ==========================================

REM ===== MODO LOCAL =====
REM Usa o banco H2 em memoria (sem internet, sem instalar nada).
REM Para usar o banco do Neon, execute o rodar-neon.cmd.
set "SPRING_PROFILES_ACTIVE=local"

REM Garante que nenhuma configuracao do Neon interfira no modo local
set DB_URL=
set DB_USER=
set DB_PASSWORD=
set SPRING_DATASOURCE_URL=
set SPRING_DATASOURCE_USERNAME=
set SPRING_DATASOURCE_PASSWORD=
set SPRING_DATASOURCE_DRIVER_CLASS_NAME=
set SPRING_JPA_HIBERNATE_DDL_AUTO=
REM ======================

REM Limpa as variaveis de ambiente corporativas que causavam erro
set JAVA_TOOL_OPTIONS=
set _JAVA_OPTIONS=
set JDK_JAVA_OPTIONS=
set JAVA_OPTS=

REM Adiciona o JDK e ferramentas basicas do Windows no PATH
set "PATH=%JAVA_HOME%\bin;C:\Windows\System32;C:\Windows"

echo ==========================================
echo    PHISHING SHIELD A3 - API EM MODO LOCAL
echo ==========================================
echo.
echo [1/2] Verificando Compilador Java:
"%JAVA_HOME%\bin\javac.exe" -version
if errorlevel 1 (
    echo ERRO: Nao foi possivel executar o javac.exe
    pause
    exit /b
)

echo.
echo [2/2] Subindo a aplicacao com Maven...
echo.
echo API:        http://localhost:9090/api/analise/health
echo Console H2: http://localhost:9090/h2-console
echo   JDBC URL: jdbc:h2:mem:phishing_shield   Usuario: sa   Senha: vazia
echo.
call "%MAVEN_BIN%" spring-boot:run

pause
