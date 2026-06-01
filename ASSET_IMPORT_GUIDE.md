# 3D Pixel Miner ISO - Asset Import Guide

## 📥 Where to Download Free Assets

### Character Models
**Option 1: Sketchfab (Recommended)**
1. Go to https://sketchfab.com
2. Search: "low poly character"
3. Filter: CC-BY license
4. Download as GLTF/GLB
5. Extract to `res://assets/models/character.gltf`

**Option 2: Quaternius**
1. Visit https://quaternius.com
2. Download: "Free Character Pack"
3. Place in `res://assets/models/`

**Option 3: itch.io**
1. Go to https://itch.io/game-assets/free
2. Search: "3D character"
3. Download pack
4. Extract to `res://assets/models/`

### Equipment Models (13 Slots)

**Option 1: Create Yourself**
- Use Blender (free)
- Model each piece: pickaxe, sword, shield, helmet, chest armor, etc.
- Export as GLTF/GLB
- ~500-1000 triangles per piece

**Option 2: Download Pre-Made**
- Sketchfab: "Low poly sword", "Low poly helmet", etc.
- Search individually or as packs
- CC0 or CC-BY license

**Option 3: Use Procedural**
- Stay with placeholder meshes (they look fine in isometric)
- Create simple shapes in Godot CSG system

### Environment Assets

**Mountain Terrain**
1. Sketchfab: "Low poly mountain"
2. itch.io: "Isometric terrain"
3. OR create in Godot using CSGBox3D

**Water/Sea**
1. Sketchfab: "Low poly water"
2. OR use Godot's built-in water shader
3. Simple plane with blue material

## 📁 Folder Structure

Create this structure in your project:

```
res://assets/
├── models/
│   ├── character.gltf           # Main character
│   ├── pickaxe.gltf             # Tool 1
│   ├── fishing_rod.gltf         # Tool 2
│   ├── sword.gltf               # Weapon
│   ├── shield.gltf              # Offhand
│   ├── helmet.gltf              # Headgear
│   ├── armor_upper.gltf         # Upper armor
│   ├── armor_lower.gltf         # Lower armor
│   ├── gloves.gltf              # Hands
│   ├── boots.gltf               # Feet
│   ├── earring.gltf             # Accessories
│   ├── necklace.gltf
│   ├── ring.gltf
│   ├── bracelet.gltf
│   ├── mountain.gltf            # Environment
│   └── sea.gltf
├── textures/
│   ├── character/
│   ├── items/
│   └── environment/
└── animations/
    ├── mining_swing.tres
    ├── fishing_cast.tres
    └── idle.tres
```

## 🚀 Import Steps

### Step 1: Download Files
```bash
1. Download .gltf or .glb files
2. Save to res://assets/models/
3. Godot auto-imports (may take 5-10 sec)
```

### Step 2: Verify Import
```bash
1. In Godot, check FileSystem panel
2. Models should show with scene icon
3. Check for import errors in console
```

### Step 3: Configure Paths (Optional)
Edit `scripts/managers/asset_manager.gd`:

```gdscript
var asset_paths = {
    "character": "res://assets/models/character.gltf",
    "pickaxe": "res://assets/models/pickaxe.gltf",
    "fishing_rod": "res://assets/models/fishing_rod.gltf",
    "sword": "res://assets/models/sword.gltf",
    "shield": "res://assets/models/shield.gltf",
    "helmet": "res://assets/models/helmet.gltf",
    "armor_upper": "res://assets/models/armor_upper.gltf",
    "armor_lower": "res://assets/models/armor_lower.gltf",
    "gloves": "res://assets/models/gloves.gltf",
    "boots": "res://assets/models/boots.gltf",
    "mountain": "res://assets/models/mountain.gltf",
    "sea": "res://assets/models/sea.gltf"
}
```

## 🎬 Animation Setup

### Mining Animation
1. In Blender: Create pickaxe swing animation
2. Export as GLTF with animation
3. Godot auto-imports animation tracks
4. AnimationManager plays on schedule

### Fishing Animation
1. Model fishing rod with bend capability
2. Create cast/reel animation in Blender
3. Export to GLTF
4. AnimationManager interpolates

## 🛠️ Troubleshooting

| Problem | Solution |
|---|---|
| Model not appearing | Check path in `asset_manager.gd` |
| Wrong scale | Add scale property in import settings |
| Model flipped | Rotate 180° in Blender, re-export |
| Missing textures | Ensure .png files in same folder as .gltf |
| Animation not working | Verify animation exists in .gltf file |

## 💡 Tips

- **Start simple**: Use placeholder shapes while you find assets
- **Optimize**: Limit triangles to <1000 per piece
- **Consistent scale**: Make character ~2 units tall
- **Test early**: Import one asset, verify it works before others
- **Colors**: Use material override if textures look wrong

## 📦 Asset Packs (Ready-to-Use)

### Complete Character Packs
- Quaternius.com - Free low-poly packs
- Kenney.nl - Excellent free game assets
- OpenGameArt.org - 100+ character models

### Quick Setup (30 min)
1. Download Quaternius character pack
2. Extract to `res://assets/models/`
3. Run game
4. Assets load automatically

---

**Happy asset hunting! 🎨**
