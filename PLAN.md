# Plan: FFVI AI Player with BizHawk

This plan outlines the steps to create an AI agent capable of playing Final Fantasy VI (SNES) using the BizHawk emulator.

## Phase 1: Environment Setup
1.  **BizHawk Configuration:**
    *   Load `Final Fantasy 3 (V1.1) (U) [!].smc`.
    *   Configure controller inputs.
2.  **Communication Bridge:**
    *   Develop a Lua script (`bridge.lua`) to run inside BizHawk.
    *   This script will:
        *   Read game memory (HP, MP, Battle State, Map ID).
        *   Send this data to a Python server.
        *   Receive input commands from Python and inject them into the emulator.
3.  **Python Interface:**
    *   Create a Python script (`agent.py`) that acts as a socket server.
    *   Process incoming game state data.

## Phase 2: Game State Mapping
1.  **Memory Address Identification:**
    *   Locate key memory addresses for FFVI (e.g., character HP, ATB bars, menu positions).
2.  **State Representation:**
    *   Define a structured format for the AI to "understand" the game (e.g., `{"in_battle": true, "party": [{"hp": 100, "atb": 255}]}`).

## Phase 3: AI Development (Incremental)
1.  **Heuristic Agent (Baseline):**
    *   Script simple rules: "If in battle and ATB is full, press 'A' to attack."
    *   Simple navigation: "Hold 'Right' until Map ID changes."
2.  **Computer Vision Integration (Optional):**
    *   If memory reading is insufficient, use screenshots to detect menu items using template matching.
3.  **Reinforcement Learning (Future):**
    *   Implement a DQN or PPO agent using `Gym` if we want the AI to learn optimal strategies.

## Phase 4: Verification & Testing
1.  Test automated combat in the opening Narshe sequence.
2.  Test world map navigation from Narshe to Figaro.

## Clarifying Questions for User:
*   Do you have preferred memory addresses for FFVI already, or should I research them?
*   Should the Python agent use a specific library like `PyTorch` or `TensorFlow`?
