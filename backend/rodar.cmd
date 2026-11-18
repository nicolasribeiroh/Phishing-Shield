@echo off
title Phishing Shield - Backend Spring Boot

REM ===== CAMINHOS EXATOS DA SUA MAQUINA =====
set "JAVA_HOME=C:\Users\NHOLANDA\java\jdk-11.0.32.1+1"
set "MAVEN_BIN=C:\Users\NHOLANDA\Downloads\Phishing\apache-maven-3.9.16-bin\apache-maven-3.9.16\bin\mvn.cmd"
REM ==========================================

REM ===== BANCO DE DADOS (PostgreSQL no Neon) =====
REM Os dados de acesso ficam em credenciais.cmd, que NAO vai para o GitHub.
REM Crie esse arquivo copiando o credenciais.exemplo.cmd.
if not exist "%~dp0credenciais.cmd" goto sem_credenciais
call "%~dp0credenciais.cmd"
goto credenciais_ok
:sem_credenciais
echo ERRO: arquivo credenciais.cmd nao encontrado na pasta backend.
echo Copie credenciais.exemplo.cmd para credenciais.cmd e preencha os dados do Neon.
pause
exit /b
:credenciais_ok
REM ===============================================

REM Limpa as variaveis de ambiente corporativas que causavam erro
set JAVA_TOOL_OPTIONS=
set _JAVA_OPTIONS=
set JDK_JAVA_OPTIONS=
set JAVA_OPTS=

REM Adiciona o JDK e ferramentas basicas do Windows no PATH
set "PATH=%JAVA_HOME%\bin;C:\Windows\System32;C:\Windows"

echo ==========================================
echo    PHISHING SHIELD A3 - INICIANDO API
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
call "%MAVEN_BIN%" spring-boot:run

pause
