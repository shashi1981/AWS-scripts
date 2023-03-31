#!/bin/bash

#Utility script establish ssh connections from a menu of hosts parsed from a ssh config
/opt/homebrew/bin/vault token-lookup >/dev/null 2>&1
#if [ $? -eq 1 ]; then
  echo "Authenticate with vault..."
     ~/vaultsign -i $HOME/.ssh/id_ed25519 <user>
 #    fi

     echo "Signing your ssh pub key..."

     hostlist=`cat ~/.ssh/config | grep "Host " | grep -v "^#" | grep -v "?" | grep -v "*" | grep -v "github" | awk '{print $2}'`

     options=($hostlist)

     echo "Please select a ssh destination. Enter q or e to exit."
     select opt in "${options[@]}"; do
     case $opt in
       '')
     case "$REPLY" in
       q|Q|e|E) echo "Logging off from shell ... Bye."; exit;;
        *) echo "Invalid choice: $REPLY. Please try again.";;
      esac
      ;;
      *)
      echo "Connecting to $opt..."
      ssh $opt
      ;;
    esac
done
