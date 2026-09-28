# agent.py
# AI Agent for Final Fantasy VI - Menu Navigation & "Fight" Selection

import json
import time
import os

STATE_FILE = "game_state.json"
INPUT_FILE = "game_input.json"

def get_state():
    if not os.path.exists(STATE_FILE): return None
    try:
        with open(STATE_FILE, "r") as f: return json.load(f)
    except: return None

def send_input(buttons):
    with open(INPUT_FILE, "w") as f: json.dump(buttons, f)

def run_agent():
    print("AI Agent Started. Navigation and Battle Logic enabled.")
    
    while True:
        state = get_state()
        if not state:
            time.sleep(0.1)
            continue

        frame = state.get("frame", 0)
        map_id = state.get("map_id", 0)
        in_battle = state.get("in_battle", False)
        sub_menu = state.get("sub_menu", 0)
        cursor = state.get("battle_cursor", 0)
        window_open = state.get("window_open", False)

        buttons = { "A": False, "B": False, "X": False, "Y": False, "Up": False, "Down": False, "Left": False, "Right": False, "Start": False, "Select": False, "L": False, "R": False }
        action = "IDLE"

        if map_id == 0:
            action = "START (TITLE)"
            buttons["Start"] = (frame % 60 < 10)
        
                if state.get("in_battle"):
                    action = "BATTLE: Mashing A"
                    # In battle, we primarily want to attack.
                    # We mash A periodically to confirm actions.
                    if frame % 15 < 5:
                        buttons["A"] = True
                    
                    # If sub-menu is open, try to go back or confirm
                    if state.get("sub_menu", 255) != 255:
                        buttons["B"] = (frame % 30 < 5)
                elif state.get("window_open"):        
        else:
            # Movement Heuristic for Narshe Intro
            # Wiggle slightly if frame is even to avoid getting caught on corners
            action = "MOVE UP (+Wiggle)"
            buttons["Up"] = True
            if (frame // 30) % 2 == 0:
                buttons["Left"] = True
            else:
                buttons["Right"] = (frame % 60 < 5) # Periodic right tap

        send_input(buttons)
        print(f"F:{frame:6} | Map:{map_id:2} | Bat:{int(in_battle)} | Sub:{sub_menu} | Cur:{cursor} | Act:{action}")
        time.sleep(0.01)

if __name__ == "__main__":
    run_agent()
