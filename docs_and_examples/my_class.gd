# This file is mainly inspired of the following Godot tutorial:
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html
# and this StayAtHomeDev Youtube video:
# https://www.youtube.com/watch?v=Ez6BEiGOMCc

## This is a documentation comment.
# This is a regular comment
#This is a commented line of code. Note that we can use ctrl+k inside the
#editor for comment/uncomment a bloc of code

#region example
# Write here the code we want wrap into a region
#endregion

# Use @tool keyword if it's a script which can be execute inside the editor
@tool
# This file should be saved as `my_class.gd`.
class_name MyClass
extends Node3D
# Doctstring
## A brief description of the class's role and functionality.
##
## The description of the script, what it can do,
## and any further detail.

# SIGNALS
# Use the past tense to name signals
signal player_spawned(position: Vector2)

# ENUMS
# Use PascalCase for enum names and CONSTANT_CASE for their members, as they are constants
enum Jobs {KNIGHT, WIZARD, ROGUE, HEALER, SHAMAN}
# Another way to write an enum
enum Weapons {
	SWORD,
	SPEAR,
	AXE,
	DAGGER, # Please note this final comma
}

# CONSTANTS
# Write constants with CONSTANT_CASE, that is to say in all caps with an underscore (_) to separate words
const MAX_LIVES = 3
# It's strongly recommanded to type is variables, the language being statically typed.
# We can use `:=` to automatically infer the type, or directly use `var my_var: int = 10`

# EXPORT VARIABLES
@export_category("Player Character") # Rename the export category inside the editor
@export_group("Information") # Create a group of variable inside the category
@export var player_name: String = "Gandalf"
@export var job: Jobs = Jobs.WIZARD
@export var max_health: int = 500 
@export_subgroup("Modifiers") # Create a subgroup inside the current group
@export var weakness: Weapons = Weapons.AXE
@export_group("Status")
@export_range(0, 100, 1) var HP := 10 # The value can evoluate between 0 and 100 with a step of 1
@export var MP := 10
@export var EXP := 0
@export_group("Combat")
@export_range(0.0, 100.0, 0.1) var attack: float = 5.0
@export var defense := 0

# PUBLIC VARIABLES
var health := max_health
var damage_taken := 0
var level := 5
var location := "City"

# PRIVATE VARIABLES
var _speed := 300.0

# ONREADY VARIABLES
@onready var staff: Object = get_node("entities/item/Staff") # This path doesn't really exist, don't look after it


# OPTIONAL BUILT-IN VIRTUAL _init METHOD
func _init() -> void:
	pass

# OPTIONAL BUILT-IN VIRTUAL _enter_tree() METHOD
func _enter_tree() -> void:
	pass

# BUILT-IN VIRTUAL _ready METHOD
func _ready() -> void:
	pass

# REMAINING BUILT-IN VIRTUAL METHODS

func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

# PUBLIC METHODS
func digit_example() -> int:
	#region digit advices
	# Take advantage of GDScript's underscores in literals to make large numbers more readable.
	# And use lower case for hex and binary digits, it's more readable
	var large_number := 1_234_567_890
	var large_hex_number := 0xffff_f8f8_0000
	var large_bin_number := 0b1101_0010_1010
	# Numbers lower than 1000000 generally don't need separators.
	var small_number := 12345
	#endregion
	
	return small_number

# PRIVATE METHODS
func _on_player_spawned(position: Vector2) -> void:
	print("Player spawned")
	player_spawned.emit(position)

# SUBCLASSES
class SubClass:
	var foo := 0

	func _init() -> void:
		print("Hello!")
