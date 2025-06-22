#!/bin/bash

# Vérifie si hyprsunset est déjà actif
if pgrep -x "hyprsunset" > /dev/null; then
    # Si oui, on le tue (désactivation)
    pkill hyprsunset
else
    # Sinon, on le lance avec une température de couleur
    hyprsunset --temperature 4600
fi
