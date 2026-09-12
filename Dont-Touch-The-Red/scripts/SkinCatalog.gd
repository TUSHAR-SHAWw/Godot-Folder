extends RefCounted

const SKINS := [
	{"name": "EMBER", "cost": 0, "texture": "res://assets/skins/skin_01_ember.svg", "body": Color("#e02323"), "highlight": Color("#ffb3a7")},
	{"name": "OCEAN", "cost": 25, "texture": "res://assets/skins/skin_02_ocean.svg", "body": Color("#147d92"), "highlight": Color("#8eeaf5")},
	{"name": "VIOLET", "cost": 50, "texture": "res://assets/skins/skin_03_violet.svg", "body": Color("#6d3bb5"), "highlight": Color("#d2b4ff")},
	{"name": "GOLD", "cost": 75, "texture": "res://assets/skins/skin_04_gold.svg", "body": Color("#c27b16"), "highlight": Color("#ffe39a")},
	{"name": "MINT", "cost": 100, "texture": "res://assets/skins/skin_05_mint.svg", "body": Color("#2e8b57"), "highlight": Color("#a5f3c5")},
	{"name": "PINK", "cost": 150, "texture": "res://assets/skins/skin_06_pink.svg", "body": Color("#be185d"), "highlight": Color("#ffacd0")},
	{"name": "SLATE", "cost": 200, "texture": "res://assets/skins/skin_07_slate.svg", "body": Color("#334155"), "highlight": Color("#cbd5e1")},
	{"name": "SUN", "cost": 300, "texture": "res://assets/skins/skin_08_sun.svg", "body": Color("#f59e0b"), "highlight": Color("#fff0a6")}
]

static func count() -> int:
	return SKINS.size()

static func get_skin(index: int) -> Dictionary:
	return SKINS[clampi(index, 0, SKINS.size() - 1)]

static func get_texture(index: int) -> Texture2D:
	return load(get_skin(index).texture) as Texture2D
