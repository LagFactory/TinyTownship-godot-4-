# TinyTownship

A 3D town-building game made with Godot 4.

## About

TinyTownship is a first-person 3D game where you explore a world, gather resources from the environment, and use them to construct buildings. The world is procedurally populated with trees and rocks that the player can harvest.

## Features

- **First-person movement** — WASD to move, mouse to look, Space to jump
- **Resource gathering** — interact with trees and rocks to collect materials
- **Building system** — spend resources to place buildings in the world
- **Inventory** — tracks collected resources
- **Dynamic world** — trees and rocks are spawned at startup with spacing rules to avoid overlap
- **Building manager** — automatically scans for and loads unlocked building types

## Controls

| Key | Action |
|-----|--------|
| W / A / S / D | Move |
| Mouse | Look |
| Space | Jump |
| E | Interact / Harvest |
| B | Place building |
| T | Cycle building type |
| I | Open inventory |
| Escape | Pause menu |

## Getting Started

1. Install [Godot 4.7](https://godotengine.org/) or later.
2. Clone this repository.
3. Open Godot and import the `project.godot` file.
4. Press **F5** (or the Play button) to run the game.

## Project Structure

```
TinyTownship-godot-4-/
├── BuildingStuff/          # Building data, models, and manager
│   ├── buildingClasses/    # BuildingData resources (.tres)
│   ├── buildingModels/     # 3D scenes for buildings
│   ├── building_data.gd    # BuildingData resource class
│   └── building_manager.gd # Autoload: scans and manages available buildings
├── PlayerStuff/            # Player character and UI
│   ├── player.gd           # Player movement, interaction, and building placement
│   ├── inventory.gd        # Autoload: resource inventory
│   └── ui_manager.gd       # HUD and UI logic
├── worldObjects/           # Harvestable world objects (trees, rocks)
├── tiny_township.gd        # Main scene: procedural world object spawning
└── Tiny_township.tscn      # Main scene
```

## Requirements

- Godot 4.7+
- Jolt Physics (bundled with Godot 4.x)
