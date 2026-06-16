# generate_levels.py — generates TSCN files for tutorial, level_2, level_3
# Run: python scripts/tools/generate_levels.py
# Output goes directly into scenes/levels/

import base64, struct, os, sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.normpath(os.path.join(SCRIPT_DIR, '..', '..'))
OUT_DIR = os.path.join(PROJECT_DIR, 'scenes', 'levels')

# ── Sub-resource definitions (shared by all levels) ─────────────────────

# These are the common sub-resource IDs that will be used in every level
# RectShape for ExitZone CollisionShape2D
RECT_SHAPE_TEMPLATE = '''
[sub_resource type="RectangleShape2D" id="RectShape_exit"]
size = Vector2(48, 64)
'''

# TileSetAtlasSource for CastleTiles (16x16) — source_id 0
# We only define tiles 0:0 to 15:11 with physics where applicable
CASTLE_ATLAS = '''
[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_castle"]
texture = ExtResource("tex_castle")
0:0/0 = 0
0:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:0/0 = 0
1:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:0/0 = 0
2:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:0/0 = 0
3:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
4:0/0 = 0
4:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
5:0/0 = 0
5:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
6:0/0 = 0
6:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
7:0/0 = 0
7:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
0:1/0 = 0
0:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:1/0 = 0
1:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:1/0 = 0
2:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:1/0 = 0
3:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
4:1/0 = 0
4:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
5:1/0 = 0
5:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
6:1/0 = 0
6:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
7:1/0 = 0
7:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
0:2/0 = 0
0:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:2/0 = 0
1:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:2/0 = 0
2:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:2/0 = 0
3:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
4:2/0 = 0
4:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
5:2/0 = 0
5:2/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
0:3/0 = 0
0:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:3/0 = 0
1:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:3/0 = 0
2:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:3/0 = 0
3:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
4:3/0 = 0
4:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
5:3/0 = 0
5:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
6:3/0 = 0
6:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
7:3/0 = 0
7:3/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
'''

TILESET_ATLAS_SOURCE_1 = '''
[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_extra"]
texture = ExtResource("tex_extra")
0:0/0 = 0
0:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:0/0 = 0
1:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:0/0 = 0
2:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:0/0 = 0
3:0/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
0:1/0 = 0
0:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
1:1/0 = 0
1:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
2:1/0 = 0
2:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
3:1/0 = 0
3:1/0/physics_layer_0/polygon_0/points = PackedVector2Array(-8, -8, 8, -8, 8, 8, -8, 8)
'''

GROUND_TILESET = '''
[sub_resource type="TileSet" id="TileSet_ground"]
physics_layer_0/collision_layer = 1
sources/0 = SubResource("TileSetAtlasSource_castle")
sources/1 = SubResource("TileSetAtlasSource_extra")
'''

# ── Helper: generate PackedByteArray ─────────────────────────────────────

def make_tile_data(tiles):
    """tiles: list of (x, y, source_id, atlas_x, atlas_y) tuples.
    Returns base64-encoded PackedByteArray string."""
    buf = bytearray()
    for x, y, sid, ax, ay in tiles:
        buf += struct.pack('<hhhhhh', x, y, sid, ax, ay, 0)
    b64 = base64.b64encode(bytes(buf)).decode('ascii')
    return b64


# ── Level definitions ─────────────────────────────────────────────────────

def ground_row(x_start, x_end, y, source_id=0, ax=0, ay=1):
    """Generate a row of ground surface tiles from x_start to x_end at height y."""
    tiles = []
    for x in range(x_start, x_end + 1):
        tiles.append((x, y, source_id, ax, ay))
    return tiles

def ground_below(x_start, x_end, y_top, y_bottom, source_id=0, ax=0, ay=2):
    """Generate underground fill tiles below a surface row."""
    tiles = []
    for y in range(y_top + 1, y_bottom + 1):
        for x in range(x_start, x_end + 1):
            tiles.append((x, y, source_id, ax, ay))
    return tiles

def platform(x_start, x_end, y, source_id=0, ax=0, ay=0):
    """Generate a platform at height y."""
    tiles = []
    for x in range(x_start, x_end + 1):
        tiles.append((x, y, source_id, ax, ay))
    return tiles

def wall(x, y_start, y_end, source_id=0, ax=2, ay=0):
    """Generate a wall at x from y_start to y_end."""
    tiles = []
    for y in range(y_start, y_end + 1):
        tiles.append((x, y, source_id, ax, ay))
    return tiles


# ── Level layouts ──────────────────────────────────────────────────────────

LEVELS = {}

# level_tutorial:
# Simple flat ground with a gap, 2 platforms, 1 skeleton, 2 cheese, trigger zones
LEVELS['level_tutorial'] = {
    'name': 'LevelTutorial',
    'tiles': (
        # Main ground surface (y=3) with gap between x=16 and x=18
        ground_row(0, 15, 3) +
        ground_row(18, 35, 3) +
        # Below ground (y=4 to y=6)
        ground_below(0, 15, 3, 6) +
        ground_below(18, 35, 3, 6) +
        # Low platform on left (y=1)
        platform(5, 7, 1) +
        # High platform on right (y=-1)
        platform(24, 26, -1) +
        # Small step near spawn
        platform(3, 3, 2)
    ),
    'spawn': (48, -48),
    'exit': (520, -55),
    'cheese': [
        (80, -28),   # on ground path
        (96, -60),   # on low platform
    ],
    'skeletons': [
        (180, -16),  # stationary, past the gap
    ],
    'triggers': [
        # (collision_x, collision_y, message_key) — fixed RectShape(48, 64)
        (48, 50, 'tutorial_move'),     # right after spawn, ground level
        (128, 50, 'tutorial_jump'),    # before gap
        (208, 50, 'tutorial_slide'),   # near gap
        (288, 50, 'tutorial_dash'),    # after gap
        (368, 50, 'tutorial_attack'),  # further along
        (448, 50, 'tutorial_cheese'),  # near cheese
    ],
    'ground_pos': (0, 1),
}

# level_2:
# More platforming, floating islands, 3 skeletons, 6 cheese
LEVELS['level_2'] = {
    'name': 'Level2',
    'tiles': (
        ground_row(-2, 15, 3) +
        ground_row(18, 30, 3) +
        ground_row(35, 50, 3) +
        ground_below(-2, 15, 3, 6) +
        ground_below(18, 30, 3, 6) +
        ground_below(35, 50, 3, 6) +
        # Elevated platforms
        platform(8, 10, 0) +
        platform(15, 17, 0) +
        platform(22, 24, -1) +
        platform(30, 32, 0) +
        platform(38, 40, 0) +
        platform(44, 46, -1) +
        # Stair steps up
        platform(12, 12, 2) +
        platform(13, 13, 1) +
        # Stair steps down at gap 2
        platform(33, 33, 2) +
        platform(34, 34, 1) +
        # Small platforms
        platform(19, 19, 2) +
        platform(27, 27, 2) +
        platform(42, 42, 2) +
        # Walls
        wall(-2, -2, 2) +
        wall(50, -2, 2)
    ),
    'spawn': (48, -48),
    'exit': (780, -55),
    'cheese': [
        (64, -28),   # on ground
        (144, -28),  # near first gap
        (160, -56),  # on platform 8-10
        (280, -56),  # on platform 15-17
        (400, -68),  # on platform 22-24
        (600, -28),  # on ground
    ],
    'skeletons': [
        (100, -16),  # patrol area 1
        (450, -16),  # patrol area 2
        (700, -16),  # patrol area 3
    ],
    'ground_pos': (0, 1),
}

# level_3:
# Complex layout with pits, multiple levels, 4 skeletons, 8 cheese
LEVELS['level_3'] = {
    'name': 'Level3',
    'tiles': (
        # Ground with pits
        ground_row(0, 10, 3) +
        ground_row(15, 22, 3) +
        ground_row(27, 40, 3) +
        ground_row(44, 55, 3) +
        ground_below(0, 10, 3, 6) +
        ground_below(15, 22, 3, 6) +
        ground_below(27, 40, 3, 6) +
        ground_below(44, 55, 3, 6) +
        # Mid-level platforms
        platform(4, 6, 0) +
        platform(16, 18, 0) +
        platform(20, 21, 0) +
        platform(28, 30, -1) +
        platform(34, 36, 0) +
        platform(46, 48, -1) +
        # High platforms
        platform(8, 9, -2) +
        platform(32, 33, -3) +
        platform(50, 51, -2) +
        # Stair sections
        platform(11, 11, 2) +
        platform(12, 12, 1) +
        platform(13, 13, 0) +
        # Steps down after pit
        platform(23, 23, 2) +
        platform(24, 24, 1) +
        platform(25, 25, 0) +
        # Steps up to end
        platform(41, 41, 2) +
        platform(42, 42, 1) +
        platform(43, 43, 0) +
        # Walls
        wall(0, -2, 2) +
        wall(55, -2, 2) +
        # Small stepping stones
        platform(11, 11, 1) +
        platform(23, 23, 1) +
        platform(38, 38, 2) +
        platform(48, 48, 2)
    ),
    'spawn': (48, -48),
    'exit': (860, -55),
    'cheese': [
        (32, -28),    # start area
        (80, -56),    # on mid platform 4-6
        (160, -28),   # near first pit
        (280, -56),   # on mid platform 16-18
        (336, -28),   # ground between pits
        (480, -68),   # on high platform 28-30
        (560, -56),   # on mid platform 34-36
        (760, -68),   # on high platform 46-48
    ],
    'skeletons': [
        (100, -16),
        (280, -16),
        (500, -16),
        (720, -16),
    ],
    'ground_pos': (0, 1),
}


def make_nodes(level_data):
    """Build TSCN node block for a level."""
    tiles = level_data['tiles']
    spawn = level_data['spawn']
    exit_pos = level_data['exit']
    cheese_list = level_data['cheese']
    skeletons = level_data['skeletons']
    triggers = level_data.get('triggers', [])
    level_name = level_data['name']
    ground_pos = level_data['ground_pos']

    tile_b64 = make_tile_data(tiles)

    lines = []
    lines.append(f'[node name="{level_name}" type="Node2D"]')
    lines.append('')

    # PlayerSpawn
    lines.append(f'[node name="PlayerSpawn" type="Marker2D" parent="."]')
    lines.append(f'position = Vector2{spawn}')
    lines.append('')

    # ExitZone
    lines.append(f'[node name="ExitZone" type="Area2D" parent="."]')
    lines.append(f'collision_mask = 4')
    lines.append('')
    lines.append(f'[node name="CollisionShape2D" type="CollisionShape2D" parent="ExitZone"]')
    lines.append(f'position = Vector2{exit_pos}')
    lines.append(f'shape = SubResource("RectShape_exit")')
    lines.append('')

    # Trigger zones (tutorial only)
    for i, (cx, cy, msg_key) in enumerate(triggers):
        lines.append(f'[node name="TriggerZone{i+1}" type="Area2D" parent="." groups=["tutorial_trigger"]]')
        lines.append(f'collision_mask = 4')
        lines.append(f'metadata/message_key = "{msg_key}"')
        lines.append('')
        lines.append(f'[node name="CollisionShape2D" type="CollisionShape2D" parent="TriggerZone{i+1}"]')
        lines.append(f'position = Vector2({cx}, {cy})')
        lines.append(f'shape = SubResource("RectShape_exit")')
        lines.append('')

    # Cheese
    for i, (cx, cy) in enumerate(cheese_list):
        lines.append(f'[node name="Cheese{i+1}" parent="." instance=ExtResource("res_cheese")]')
        lines.append(f'position = Vector2({cx}, {cy})')
        lines.append('')

    # Skeletons
    for i, (sx, sy) in enumerate(skeletons):
        lines.append(f'[node name="Skeleton{i+1}" parent="." instance=ExtResource("res_skeleton")]')
        lines.append(f'position = Vector2({sx}, {sy})')
        lines.append('')

    # Ground TileMapLayer
    lines.append(f'[node name="ground" type="TileMapLayer" parent="."]')
    lines.append(f'position = Vector2{ground_pos}')
    lines.append(f'tile_map_data = PackedByteArray("{tile_b64}")')
    lines.append(f'tile_set = SubResource("TileSet_ground")')
    lines.append('')

    return '\n'.join(lines)


def generate_level(level_id, level_data):
    """Generate a full TSCN file for a level."""
    ext_resources = []
    
    # CastleTiles
    ext_resources.append('[ext_resource type="Texture2D" path="res://assets/sprites/world/CastleTiles.png" id="tex_castle"]')
    # Extra tiles (tileset_.png)
    ext_resources.append('[ext_resource type="Texture2D" path="res://assets/sprites/world/tileset_.png" id="tex_extra"]')
    # Skeleton scene
    ext_resources.append('[ext_resource type="PackedScene" path="res://scenes/entities/skeleton/skeleton.tscn" id="res_skeleton"]')
    # Cheese scene
    ext_resources.append('[ext_resource type="PackedScene" path="res://scenes/entities/cheese/cheese.tscn" id="res_cheese"]')

    ext_block = '\n'.join(ext_resources)

    sub_resources = RECT_SHAPE_TEMPLATE + CASTLE_ATLAS + TILESET_ATLAS_SOURCE_1 + GROUND_TILESET

    nodes = make_nodes(level_data)

    tscn = f'''[gd_scene format=4]

{ext_block}

{sub_resources}
{nodes}
'''
    return tscn


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    os.makedirs(OUT_DIR, exist_ok=True)

    for level_id, level_data in LEVELS.items():
        tscn = generate_level(level_id, level_data)
        fname = f'{level_id}.tscn'
        fpath = os.path.join(OUT_DIR, fname)
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write(tscn)
        print(f'Generated {fpath}')

if __name__ == '__main__':
    main()
