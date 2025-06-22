#!/usr/bin/env python3
"""
Stopwatch pour Waybar avec persistance
Usage: python3 waybar_stopwatch.py [start|pause|reset|status]
"""

import json
import time
import sys
import os
from pathlib import Path

# Fichier de sauvegarde dans le répertoire utilisateur
STATE_FILE = Path.home() / '.waybar_stopwatch_state.json'

def load_state():
    """Charge l'état du stopwatch depuis le fichier"""
    if not STATE_FILE.exists():
        return {
            'start_time': None,
            'accumulated_time': 0,
            'is_running': False
        }
    
    try:
        with open(STATE_FILE, 'r') as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        return {
            'start_time': None,
            'accumulated_time': 0,
            'is_running': False
        }

def save_state(state):
    """Sauvegarde l'état du stopwatch dans le fichier"""
    try:
        with open(STATE_FILE, 'w') as f:
            json.dump(state, f)
    except IOError:
        pass

def get_current_time():
    """Calcule le temps actuel du stopwatch"""
    state = load_state()
    
    if not state['is_running']:
        return state['accumulated_time']
    
    if state['start_time'] is None:
        return state['accumulated_time']
    
    current_elapsed = time.time() - state['start_time']
    return state['accumulated_time'] + current_elapsed

def format_time(seconds):
    """Formate le temps en HH:MM:SS"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    
    if hours > 0:
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"
    else:
        return f"{minutes:02d}:{secs:02d}"

def start_pause():
    """Lance ou met en pause le stopwatch"""
    state = load_state()
    current_time = time.time()
    
    if state['is_running']:
        # Pause: sauvegarder le temps accumulé
        if state['start_time'] is not None:
            state['accumulated_time'] += current_time - state['start_time']
        state['is_running'] = False
        state['start_time'] = None
    else:
        # Start: démarrer le chronométrage
        state['is_running'] = True
        state['start_time'] = current_time
    
    save_state(state)

def reset():
    """Remet le stopwatch à zéro"""
    state = {
        'start_time': None,
        'accumulated_time': 0,
        'is_running': False
    }
    save_state(state)

def get_status():
    """Retourne le statut actuel pour Waybar"""
    current_time = get_current_time()
    state = load_state()
    
    status = {
        "text": format_time(current_time),
        "tooltip": "Stopwatch",
        "class": "running" if state['is_running'] else "paused"
    }
    
    return json.dumps(status)

def main():
    if len(sys.argv) < 2:
        # Mode par défaut: afficher le statut
        print(get_status())
        return
    
    command = sys.argv[1]
    
    if command == "start" or command == "pause":
        start_pause()
    elif command == "reset":
        reset()
    elif command == "status":
        print(get_status())
    else:
        print(f"Usage: {sys.argv[0]} [start|pause|reset|status]")
        sys.exit(1)

if __name__ == "__main__":
    main()
