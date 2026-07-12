#!/bin/bash

# ==========================================================
#   Build automatique des classes Java + génération du WAR
#   Projet : MAHERY VAIKA
#   Auteur : Script généré par ChatGPT
# ==========================================================

echo "🔧 Compilation des classes Java..."

# Compilation des classes tools (si tu en as)
# javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/tools/*.java
javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/tools/*.java                           


# Compilation des classes LOCATION
# javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/backoffice/*.java
 javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/backoffice/*.java                      
                       
# javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/gestion/*.java
 javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/gestion/*.java                         

 javac -d WEB-INF/classes -cp "lib/*:WEB-INF/classes" src/dashboard/*.java                         

echo "✔ Compilation terminée."

# Création du fichier WAR
jar -cvf maheryvaika.war *
    
echo "✔ maheryvaika.war généré avec succès."

# Déploiement automatique dans Tomcat
echo "🚀 Déploiement du WAR dans Tomcat..."

TOMCAT_PATH="/xampp/tomcat/webapps"

cp maheryvaika.war "$TOMCAT_PATH"

echo "✔ Déployé dans : $TOMCAT_PATH/maheryvaika.war"

echo "🎉 Build & déploiement terminés avec succès."
