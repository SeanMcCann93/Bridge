#!/bin/bash

echo "EXECUTING: GIT NOW!"
echo ""
echo "CHANGE: to Project root" 

homedir=false

while [ $homedir = false ]
do
    if [ -d '.git' ]
    then
        echo ""
        echo "Root found: $(pwd)"
        echo ""
        gp # Calls for the gp command ~ installed via startup.sh
        echo "EXECUTING: Pull"
        echo ""
        git pull
        $homedir = true   
        echo ""
        echo "GIT NOW! {successful}"
        echo ""
        break
    else
        cd ..
        if [ $PWD == $HOME ]
        then
            echo "Reached Home Directory. Unable to find root!"
            echo ""
            echo "gitmatch {unsuccessful}"
            echo ""
            break
        fi
    fi
done