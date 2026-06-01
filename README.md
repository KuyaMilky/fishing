# Godot 4 RPG Foundation

A complete single-player RPG foundation built in Godot 4 featuring:

## Features

### Core Systems
- ✅ **Isometric Pixel Art View** - Tilemap-based isometric perspective with proper layering
- ✅ **Character System** - Name, stats (HP, ATK, DEF, AGI), equipment slots (10 slots)
- ✅ **Sprite Layering** - Dynamic equipment display on character
- ✅ **Save/Load System** - Per-character save files with JSON persistence

### Gameplay
- ✅ **Mining Minigame** - Click-based mining with animations, ore drops, and currency
- ✅ **Fishing Minigame** - Timed mini-event with ~50 species, rarity tiers, collectible bonuses
- ✅ **Item Database** - Curated ores, fish species, and gear with rarity tiers (Common → Mythic)
- ✅ **Inventory System** - Bag management, item stacking, filtering
- ✅ **Equipment Management** - 10 visible slots with stat bonuses

### Progression
- ✅ **Level-Up Screen** - Stat point allocation (AGI, HP, DEF, ATK)
- ✅ **Item Appraisal** - Identify items and apply stat boosts
- ✅ **Fish Collection Bonuses** - Stacking ladder rewards for collecting species
- ✅ **Skill Book System** - Elemental skills with cooldowns
- ✅ **Currency System** - Gold, Silver, Copper from mining/fishing

### Quality of Life
- ✅ **Responsive Layout** - Scales to different screen sizes
- ✅ **Modular Architecture** - Organized scenes, scripts, and resources
- ✅ **Professional Structure** - Production-ready code patterns

## Project Structure

```
.
├── project.godot              # Project configuration
├── scenes/                    # All scene files
│   ├── main/                  # Main game scene
│   ├── character/             # Character and UI
│   ├── minigames/             # Mining and fishing
│   ├── ui/                    # UI screens
│   └── world/                 # Tilemap and world
├── scripts/                   # GDScript files
│   ├── core/                  # Core systems
│   ├── gameplay/              # Game mechanics
│   ├── ui/                    # UI controllers
│   └── utils/                 # Utilities
├── resources/                 # Godot resources
│   ├── items/                 # Item definitions
│   ├── skills/                # Skill definitions
│   └── characters/            # Character saves
├── assets/                    # Art and audio
│   ├── sprites/               # Character and item sprites
│   ├── tilesets/              # Isometric tileset
│   └── audio/                 # Sound effects
└── data/                      # JSON data files
    ├── items.json             # Item database
    ├── fish_species.json      # Fish species (~50)
    └── fish_bonuses.json      # Collection bonuses
```

## Getting Started

1. **Open in Godot 4** - Load `project.godot`
2. **Run the Project** - Press F5 or click Run
3. **Create Character** - Name your character at startup
4. **Explore** - Mine, fish, level up, collect items

## Data Structure

### Item Database
Items are defined in `data/items.json` with properties:
- `id`, `name`, `type` (ore, fish, gear, skill book)
- `rarity` (common, uncommon, rare, epic, legendary, mythic)
- `stats` (hp, atk, def, agi bonuses)
- `value` (gold cost)

### Fish Species
~50 curated fish species in `data/fish_species.json` with:
- Rarity tier
- Habitat type
- Base value
- Special effects

### Collection Bonuses
Stacking ladder in `data/fish_bonuses.json`:
- 5 species collected → +1 HP
- 10 species → +2 ATK
- 20 species → +3 DEF
- 50+ species → Legendary Set Bonus

## Controls

- **WASD/Arrow Keys** - Move character
- **E** - Interact (Mine/Fish)
- **I** - Open inventory
- **L** - Open level-up screen
- **S** - Open skills
- **ESC** - Save and quit

## Development

- All code uses GDScript 2.0
- Modular scene structure for easy extension
- Resource-based item definitions for quick balancing
- JSON save files for debugging and persistence

## Future Enhancements

- [ ] Multiplayer support
- [ ] More minigames
- [ ] Boss battles
- [ ] Dungeons
- [ ] Trading system
- [ ] Achievements
