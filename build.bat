@echo off
REM ==========================================================
REM   Build automatique des classes Java + generation du WAR
REM   Projet : MAHERY VAIKA (Windows / XAMPP)
REM ==========================================================

echo Nettoyage des anciennes classes...
rmdir /s /q WEB-INF\classes
mkdir WEB-INF\classes

echo Compilation des classes Java...
javac -d WEB-INF/classes -cp "lib/*;WEB-INF/classes" src/tools/*.java
if errorlevel 1 goto :error

javac -d WEB-INF/classes -cp "lib/*;WEB-INF/classes" src/backoffice/*.java
if errorlevel 1 goto :error

javac -d WEB-INF/classes -cp "lib/*;WEB-INF/classes" src/dashboard/*.java
if errorlevel 1 goto :error

javac -d WEB-INF/classes -cp "lib/*;WEB-INF/classes" src/gestion/*.java
if errorlevel 1 goto :error

echo Compilation terminee.

echo Generation du WAR (sans .git et sans build.bat)...
jar -cvf maheryvaika.war ^
  WEB-INF assets pages traitement models ^
  index.jsp base.sql

echo maheryvaika.war genere.

echo Nettoyage ancien deploiement Tomcat...
set TOMCAT_PATH=C:\xampp\tomcat\webapps
del /f /q "%TOMCAT_PATH%\maheryvaika.war"
rmdir /s /q "%TOMCAT_PATH%\maheryvaika"

echo Deploiement du nouveau WAR...
copy /y maheryvaika.war "%TOMCAT_PATH%\"

echo Deploiement termine avec succes.
goto :end

:error
echo ERREUR DE COMPILATION - arret du script.
exit /b 1

:end