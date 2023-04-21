#!/bin/bash

classpath="./../libs/antlr-4.12.0-complete.jar;./../libs/jackson-annotations-2.15.0-rc3.jar;./../libs/jackson-core-2.15.0-rc3.jar;./../libs/jackson-databind-2.15.0-rc3.jar;./../libs/jackson-module-parameter-names-2.15.0-rc3.jar"
javac -classpath $classpath -sourcepath ./../src/main/java/ -d out ./../src/main/java/org/example/Main.java
for folder in tests/*
do
    rm -rf "$folder"/*.json
    rm -rf "$folder"/*.out
    for file in "$folder"/*.alf
    do
        echo $file
        java -cp ./../libs/*.jar:./out org.example.Main $file "$file".json
    done
done

