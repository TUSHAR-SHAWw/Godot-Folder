extends RefCounted

const SKIN_PATH := "res://assets/f_skins/"

const DEFAULT_SKIN := {
	"name": "Red",
	"cost": 0,
	"texture": "res://assets/f_skins/red.svg",
	"body": Color("#e02323"),
	"highlight": Color("#ffb3a7"),
}

# Costs are kept separately.
# The index must match the skin index.
const COSTS := [
	0,
	25,
	60,
	100,
	200,
]

# Skin names.
# The index must match COSTS.
const SKIN_NAMES := [
	"red",
	"puple",
	"GEAR",
	"Plasma",
	"Rune",
]

# Colors.
const BODIES := [
	Color("#ffd900"),
	Color("#ee00ff"),
	Color("#ffd900"),
	Color("#ee00ff"),
	Color("#0796a3"),
	
]

const HIGHLIGHTS := [
	Color("#ffd900"),
	Color("#ee00ff"),
	Color("#f6ff00"),
	Color("#ff00dd"),
	Color("#05e1f5"),
	]

# This is what your UIManager uses.
# It contains DICTIONARIES, not strings.
static var SKINS: Array[Dictionary] = []

static func _static_init() -> void:
	_build_skins()

static func _build_skins() -> void:
	SKINS.clear()

	var skin_count := SKIN_NAMES.size()

	for i in range(skin_count):
		var skin_name := str(SKIN_NAMES[i]).strip_edges()

		if skin_name.is_empty():
			push_warning("SkinCatalog: Empty skin name at index %d." % i)
			continue

		var cost := 0
		if i < COSTS.size():
			cost = maxi(0, int(COSTS[i]))

		var body := Color.WHITE
		if i < BODIES.size():
			body = BODIES[i]

		var highlight := Color.WHITE
		if i < HIGHLIGHTS.size():
			highlight = HIGHLIGHTS[i]

		# Convert display name to filename.
		# "GEAR" -> "gear.png"
		# "Plasma" -> "plasma.png"
		var file_name := skin_name.to_lower() + ".png"
		var texture_path := SKIN_PATH + file_name

		SKINS.append({
			"name": skin_name,
			"cost": cost,
			"texture": texture_path,
			"body": body,
			"highlight": highlight,
		})

	_validate_catalog()

static func _validate_catalog() -> void:
	if SKINS.is_empty():
		push_warning("SkinCatalog: No skins loaded.")
		return

	for i in range(SKINS.size()):
		var skin: Dictionary = SKINS[i]

		if not skin.has("name"):
			push_error("SkinCatalog: Skin %d has no name." % i)

		if not skin.has("cost"):
			push_error("SkinCatalog: Skin %d has no cost." % i)

		if not skin.has("texture"):
			push_error("SkinCatalog: Skin %d has no texture." % i)

		var texture_path := str(skin.get("texture", ""))

		if not texture_path.is_empty():
			if not ResourceLoader.exists(texture_path):
				push_warning(
					"SkinCatalog: Missing texture: %s"
					% texture_path
				)

static func count() -> int:
	return SKINS.size()

static func get_skin(index: int) -> Dictionary:
	if SKINS.is_empty():
		return DEFAULT_SKIN.duplicate()

	index = clampi(index, 0, SKINS.size() - 1)

	return SKINS[index].duplicate()

static func get_texture(index: int) -> Texture2D:
	var skin := get_skin(index)

	var texture_path := str(
		skin.get("texture", DEFAULT_SKIN["texture"])
	)

	if texture_path.is_empty():
		texture_path = DEFAULT_SKIN["texture"]

	if not ResourceLoader.exists(texture_path):
		push_warning(
			"SkinCatalog: Texture missing: %s. Using default."
			% texture_path
		)

		texture_path = DEFAULT_SKIN["texture"]

	var texture := load(texture_path) as Texture2D

	if texture == null:
		push_warning(
			"SkinCatalog: Failed to load texture: %s. Using default."
			% texture_path
		)

		if texture_path != DEFAULT_SKIN["texture"]:
			return load(DEFAULT_SKIN["texture"]) as Texture2D

	return texture

static func get_cost(index: int) -> int:
	var skin := get_skin(index)

	return maxi(
		0,
		int(skin.get("cost", 0))
	)

static func get_name(index: int) -> String:
	var skin := get_skin(index)

	return str(
		skin.get("name", DEFAULT_SKIN["name"])
	)

static func get_body_color(index: int) -> Color:
	var skin := get_skin(index)

	return skin.get(
		"body",
		DEFAULT_SKIN["body"]
	)

static func get_highlight_color(index: int) -> Color:
	var skin := get_skin(index)

	return skin.get(
		"highlight",
		DEFAULT_SKIN["highlight"]
	)

static func is_free(index: int) -> bool:
	return get_cost(index) <= 0
