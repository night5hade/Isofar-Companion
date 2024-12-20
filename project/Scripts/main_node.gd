extends Node2D

signal toggled

var touch_points = {}  # Stores active touch points
var initial_distance: float = 0.0  # Distance between two fingers at the start of a pinch
var initial_scale: Vector2  # Initial scale of the node
var last_pan_position: Vector2 = Vector2.ZERO  # Tracks the last pan position


var chapter_dropdown: OptionButton
var skulls_dropdown: OptionButton
var node_dropdown: OptionButton
var enemy_card_scene = preload("res://Scenes/enemy_details.tscn")

var enemy_data = {}

var enemy_card_positions = []  # Array to store the positions for up to 4 enemy locations

@onready var enemy_container_1 = $BigScroll/BigBoxVert/Row1/PanelIVBox/PanelI
@onready var enemy_container_2 = $BigScroll/BigBoxVert/Row1/PanelIIBox/PanelII
@onready var enemy_container_3 = $BigScroll/BigBoxVert/Row2/PanelIIIBox/PanelIII
@onready var enemy_container_4 = $BigScroll/BigBoxVert/Row2/PanelIVBox/PanelIV
@onready var auto_add_enemies_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/AutoSelectContainer/AutoPopulateEnemiesButton

@onready var settings_button = $SettingsButton
@onready var settings_container = $SettingsDialog


var enemy_for_i: String = ""
var enemy_for_ii: String = ""
var enemy_for_iii: String = ""
var enemy_for_iv: String = ""

# Variables to store the instantiated enemy scenes for each position
var enemy_scene_i: Node = null
var enemy_scene_ii: Node = null
var enemy_scene_iii: Node = null
var enemy_scene_iv: Node = null

var enemy_details_instance  # Holds the enemy details instance

@onready var dropdown_enemy_name = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ManualSelection/VBoxContainer/EnemySelection
@onready var dropdown_star_amount = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ManualSelection/VBoxContainer/StarSelection
@onready var dropdown_position = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ManualSelection/VBoxContainer/PositionSelection
@onready var manual_add_enemy_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ManualSelection/VBoxContainer/ManualPopulateEnemyButton

@onready var detail_label = $Detail
@onready var enemy_not_found = $EnemyNotFound


@onready var remove_enemy_i_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ResetBoxes/VBoxContainer2/HBoxContainer/RemoveI
@onready var remove_enemy_ii_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ResetBoxes/VBoxContainer2/HBoxContainer/RemoveII
@onready var remove_enemy_iii_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ResetBoxes/VBoxContainer2/HBoxContainer2/RemoveIII
@onready var remove_enemy_iv_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ResetBoxes/VBoxContainer2/HBoxContainer2/RemoveIV
@onready var remove_all_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ResetBoxes/Container3/RemoveAll



@onready var toggle_button = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/ChipToggle/HBoxContainer/Toggle  # Adjust path to the actual button node
var enemy_details_instances: Array = []  # Array to store references to `enemy_details` instances


# List of options for the manual dropdowns
var enemy_list = [
	"Enemy", "Armored Zhuk", "Brigand Archer", "Brigand Chief", "Brigand Marauder", "Broken Plough Soldier", "Cave Stalker", "Clayhorn", "Corrupted Brigand", "Corrupted Fylakes",
	"Corrupted Guard", "Corrupted Lobster", "Corrupted Priest", "Corrupted Soldier", "Disruptor", "Drakondor", "Dusk Stalker", "Eye of Uvidet", "Falmund Scout", "Flesh Eating Fish", 
	"Glacial Worm", "Golden Scythe Soldier", "Hand of Uvidet", "Kingsguard", "Metal Eater", "Mountain Bear", "Plains Strider", "Seer Acolyte", "Seer Zealot", "Seer's Assassin",
	"Stone Guardian", "Stonehunter", "Tenebris Clayhorn", "Tenebris Colossus", "Tenebris Drakondor", "Tenebris Guard", "Tenebris Hunter", "Tenebris Strider", "Tenebris Zhuk", 
	"Timber Wolf", "Tumani Hunter", "Tumani Mender", "Tumani Raider", "Volkrok", "Waste Nomad", "Waste Prowler", 
]

var node_options = [
	"Node", "1", "5", "6", "7", "8", "10", "11", "12", "13", "14", "18", "19", "21", 
		"23", "26", "27", "28", "30", "31", "35", "36", "37", "38", "39", "40", 
		"42", "44", "46", "47", "50", "52", "53", "57", "58", "61", "62", "63", 
		"64", "65", "66", "67", "68", "72", "73", "76", "77", "80", "82", "83", 
		"84", "85", "87", "89", "90", "91", "92", "93", "97", "99", "103", "104", 
		"105", "Ice Fields", "Mount Nebesa", "Reka Glacier", "Room of Columns", 
		"Skryvat Temple", "The Broken Lands", "Uchitel Span", "Urok Span", "Vniz Path", 
		"Abandoned Quarters", "Frozen Lake", "Glacial Worm Bones", "Hall of Ice", 
		"Old Armoury", "Ossuary"
]

func _ready():
	
	initial_scale = self.scale  # Store the initial scale of the node


	var display_server = DisplayServer
	var screen_size = display_server.screen_get_size(0)
	var screen_width = screen_size.x
	var screen_height = screen_size.y
	var window_size = display_server.window_get_size()
	var center_x = (screen_width - window_size.x) / 2
	var center_y = (screen_height - window_size.y) / 2
	display_server.window_set_position(Vector2(center_x, center_y))


	
	
	
	
	
	enemy_card_scene = preload("res://Scenes/enemy_details.tscn")
	
	
	# Connect dropdowns and initialize them
	chapter_dropdown = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/AutoSelectContainer/ChapterMenu
	skulls_dropdown = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/AutoSelectContainer/SkullsMenu
	node_dropdown = $SettingsDialog/SettingsContainer/Panel/MarginContainer/VBoxContainer/AutoSelectContainer/NodeMenu

	# Connect the signals for the option buttons
	skulls_dropdown.connect("item_selected", Callable(self, "_on_skulls_selected"))
	chapter_dropdown.connect("item_selected", Callable(self, "_on_chapter_selected"))
	node_dropdown.connect("item_selected", Callable(self, "_on_node_selected"))
	
	skulls_dropdown.connect("focus_entered", Callable(self, "_on_skulls_dropdown_focus_entered"))
	skulls_dropdown.connect("focus_exited", Callable(self, "_on_skulls_dropdown_focus_exited"))

	auto_add_enemies_button.connect("pressed", Callable(self, "_on_auto_add_enemies_button_pressed"))

	enemy_card_positions = [Vector2(100, 100), Vector2(400, 100), Vector2(100, 400), Vector2(400, 400)]

	# Connect button signals
	manual_add_enemy_button.connect("pressed", Callable(self, "_on_manual_add_enemy_button_pressed"))
	remove_enemy_i_button.connect("pressed", Callable(self, "_on_remove_enemy_i_button_pressed"))
	remove_enemy_ii_button.connect("pressed", Callable(self, "_on_remove_enemy_ii_button_pressed"))
	remove_enemy_iii_button.connect("pressed", Callable(self, "_on_remove_enemy_iii_button_pressed"))
	remove_enemy_iv_button.connect("pressed", Callable(self, "_on_remove_enemy_iv_button_pressed"))
	remove_all_button.connect("pressed", Callable(self, "_on_remove_all_button_pressed"))
	
	settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))

	

	# Load enemy data from JSON
	enemy_data = getdata.enemydata  # Ensure enemydata.json is properly loaded in the autoload

	detail_label.visible = false

	toggle_button.connect("toggled", Callable(self, "_on_toggle_button_toggled"))

	# Add options to SkullsOption, ChapterOption, and NodeOption
	populate_options()

# Function to populate dropdowns with items

func _input(event):
	# Handle touch events
	if event is InputEventScreenTouch:
		if event.pressed:
			# Add touch point
			touch_points[event.index] = event.position
		else:
			# Remove touch point
			touch_points.erase(event.index)
			
	elif event is InputEventScreenDrag:
		# Update touch point position
		if event.index in touch_points:
			touch_points[event.index] = event.position
		
				# Handle single-finger drag for panning
		if touch_points.size() == 1:
			var drag_position = event.position
			if last_pan_position != Vector2.ZERO:
				var pan_delta = drag_position - last_pan_position
				self.position += pan_delta  # Adjust the node's position based on drag
			last_pan_position = drag_position
		
	# Handle pinch zoom when two fingers are active
	if touch_points.size() == 2:
		var keys = touch_points.keys()
		var pos1 = touch_points[keys[0]]
		var pos2 = touch_points[keys[1]]
		
		if initial_distance == 0.0:
			# Set the initial distance when the pinch starts
			initial_distance = pos1.distance_to(pos2)
		else:
			# Calculate the current distance and the scale factor
			var current_distance = pos1.distance_to(pos2)
			var scale_factor = current_distance / initial_distance
			
			# Apply the scale factor
			self.scale = initial_scale * scale_factor
	
	# Reset zoom and pan state when touch points reduce
	if touch_points.size() < 2:
		if initial_distance != 0.0:
			initial_scale = self.scale
			initial_distance = 0.0
		last_pan_position = Vector2.ZERO




func populate_options() -> void:
	skulls_dropdown.clear()
	chapter_dropdown.clear()
	node_dropdown.clear()

	skulls_dropdown.add_item("Skulls")
	skulls_dropdown.set_item_disabled(0, true)
	skulls_dropdown.add_item("1 Skull")
	skulls_dropdown.add_item("2 Skulls")
	skulls_dropdown.add_item("3 Skulls")
	skulls_dropdown.select(0)

	chapter_dropdown.add_item("Chapter")
	chapter_dropdown.set_item_disabled(0, true)
	chapter_dropdown.add_item("Chapter 1")
	chapter_dropdown.add_item("Chapter 2")
	chapter_dropdown.add_item("Chapter 3")
	chapter_dropdown.add_item("Chapter 4")
	chapter_dropdown.select(0)

	for option in node_options:
		node_dropdown.add_item(option)
	node_dropdown.set_item_disabled(0, true)
	node_dropdown.select(0)
	
	
	
	for option in enemy_list:
		dropdown_enemy_name.add_item(option)
	dropdown_enemy_name.set_item_disabled(0, true)
	dropdown_enemy_name.select(0)

	dropdown_star_amount.add_item("Star Value")
	dropdown_star_amount.set_item_disabled(0, true)
	dropdown_star_amount.add_item("1")
	dropdown_star_amount.add_item("2")
	dropdown_star_amount.add_item("3")
	dropdown_star_amount.add_item("4")
	dropdown_star_amount.select(0)

	dropdown_position.add_item("Position")
	dropdown_position.set_item_disabled(0, true)
	dropdown_position.add_item("Position I")
	dropdown_position.add_item("Position II")
	#dropdown_position.add_separator()
	dropdown_position.add_item("Position III")
	dropdown_position.add_item("Position IV")
	dropdown_position.select(0)


# Settings button toggles visibility of dropdowns container
func _on_settings_button_pressed():
	settings_container.popup()


func instantiate_enemy_cards(enemy_locations: Array):
	var containers = [enemy_container_1, enemy_container_2, enemy_container_3, enemy_container_4]
	var placeholder_scene = preload("res://Scenes/placeholder.tscn")  # Load the placeholder scene

	for i in range(enemy_locations.size()):
		var enemy_name = enemy_locations[i]
		print(enemy_name)
		# Determine if we need to instantiate an enemy or a placeholder
		var instance = null
		if enemy_name != "" and enemy_name != null:
			instance = enemy_card_scene.instantiate()  # Instantiate enemy scene
		
			match i:
				0: enemy_scene_i = instance
				1: enemy_scene_ii = instance
				2: enemy_scene_iii = instance
				3: enemy_scene_iv = instance
		
		
		
		
		else:
			pass
			#instance = placeholder_scene.instantiate()  # Instantiate placeholder scene
		
		# Ensure the container exists and is valid
		if i < containers.size() and containers[i] != null:
			var container = containers[i]
			
			# Check if the container is empty before adding the instance
			if container.get_child_count() == 0:
				container.add_child(instance)
				
				# Set enemy data only if it's an enemy instance
				if enemy_name != "" and enemy_name != null:
					instance.set_enemy_data(enemy_name)
					instance._on_enemy_selected(enemy_name)
					print("Instantiated enemy: ", enemy_name, " in container ", i + 1)
					

				else:
					pass
					#print("Instantiated placeholder in container ", i + 1)
			else:
				#print("Error: Container ", i + 1, " is already occupied.")
				container.add_child(instance)
				
				# Set enemy data only if it's an enemy instance
				if enemy_name != "" and enemy_name != null:
					instance.set_enemy_data(enemy_name)
					instance._on_enemy_selected(enemy_name)
					print("Instantiated enemy: ", enemy_name, " in container ", i + 1)
		else:
			print("Error: No valid container found for index ", i)





# Dropdown change handler
func _on_skulls_selected(_index: int) -> void:
	_on_dropdown_changed()

func _on_chapter_selected(_index: int) -> void:
	_on_dropdown_changed()

func _on_node_selected(_index: int) -> void:
	_on_dropdown_changed()


func get_enemies_for_selection(chapter: String, skulls: String, node: String) -> Dictionary:
	var enemy_map = {
		"I": "",
		"II": "",
		"III": "",
		"IV": ""
	}
	
	if not getdata.nodedata:
		return enemy_map
	
	for key in getdata.nodedata.keys():
		var entry = getdata.nodedata[key]
		
		# Check if the chapter, skulls, and node match
		if entry["Chapter"] == chapter and entry["Skulls"] == skulls and entry["Node"] == node:
			# Loop through I, II, III, IV and map the corresponding enemies
			for col in ["I", "II", "III", "IV"]:
				if entry.has(col) and entry[col] != null:
					enemy_map[col] = entry[col]
			
			_show_detail(entry)

	return enemy_map
# Function to check and show the detail content
func _show_detail(entry: Dictionary) -> void:
	
	if entry.has("Detail") and entry["Detail"] != null and entry["Detail"] != "":
		# Print and display the detail on the label
		print("Detail:", entry["Detail"])
		detail_label.text = entry["Detail"]
		
	else:
		detail_label.text = ""  # Clear the label if no detail exists


# Updating enemies upon dropdown selection
func _on_dropdown_changed():
	if chapter_dropdown.selected == -1 or skulls_dropdown.selected == -1 or node_dropdown.selected == -1:
		return

	var chapter = chapter_dropdown.get_item_text(chapter_dropdown.selected)
	var skulls = skulls_dropdown.get_item_text(skulls_dropdown.selected)
	var node = node_dropdown.get_item_text(node_dropdown.selected)

	var selected_enemies = get_enemies_for_selection(chapter, skulls, node)

	enemy_for_i = selected_enemies["I"]
	enemy_for_ii = selected_enemies["II"]
	enemy_for_iii = selected_enemies["III"]
	enemy_for_iv = selected_enemies["IV"]

	print("Selected enemies for Chapter: ", chapter, " Skulls: ", skulls, " Node: ", node, " => ", selected_enemies)
	#display_message("Selected enemies for Chapter: " + chapter + " Skulls: " + skulls + " Node: " + node + " => " + selected_enemies)


# Instantiation button pressed event
func _on_auto_add_enemies_button_pressed():
	
	settings_container.hide()
	var enemy_locations = [enemy_for_i, enemy_for_ii, enemy_for_iii, enemy_for_iv]
	remove_scene_i()
	remove_scene_ii()
	remove_scene_iii()
	remove_scene_iv()
	instantiate_enemy_cards(enemy_locations)
	detail_label.visible = true
	# Add each instantiated scene to the enemy_details_instances list
	for instance in [enemy_scene_i, enemy_scene_ii, enemy_scene_iii, enemy_scene_iv]:
		if instance != null and not enemy_details_instances.has(instance):
			enemy_details_instances.append(instance)
			

	

# Manual enemy placement functions
func _on_manual_add_enemy_button_pressed():
	settings_container.hide()
	# Get the selected enemy name and star amount from the dropdowns
	var selected_enemy_name = dropdown_enemy_name.get_item_text(dropdown_enemy_name.get_selected_id())  # Get selected enemy name
	var selected_star_amount = dropdown_star_amount.get_selected_id() + 0  # Assuming dropdown indices start from 0

	

	# Create the star key based on the selected star amount
	var star_key = ""
	if selected_star_amount == 1:
		star_key = "⭐"
	elif selected_star_amount == 2:
		star_key = "⭐⭐"
	elif selected_star_amount == 3:
		star_key = "⭐⭐⭐"
	elif selected_star_amount == 4:
		star_key = "⭐⭐⭐⭐"
	
	# Construct the complete enemy key
	var complete_enemy_key = star_key + " " + selected_enemy_name

	# Find the enemy name from enemy_data based on the complete_enemy_key
	var enemy_name = ""
	if enemy_data.has(complete_enemy_key):
		enemy_name = enemy_data[complete_enemy_key]["FullName"]  # or any other field you need

	# Get the selected position from the position dropdown
	var selected_position_index = dropdown_position.get_selected_id()  # Assuming this returns an index for I, II, III, IV
	var position_key = ""
	match selected_position_index:
		1: position_key = "I"
		2: position_key = "II"
		3: position_key = "III"
		4: position_key = "IV"
		_:
			print("Error: Invalid position selected.")
			return  # Exit if position is invalid

	# Proceed to add the enemy based on enemy_name and position
	if enemy_name != "":
		print("Adding enemy:", enemy_name, "at position:", position_key)
		# Call the function to instantiate and display the enemy
		instantiate_and_display_enemy(enemy_name, position_key)

		# After instantiating, call the load_enemy_cards function on the enemy_details_instance
		if enemy_details_instance:
			enemy_details_instance.load_enemy_cards(enemy_name)  # Call the method with the enemy name
	else:
		print("Enemy not found for:", complete_enemy_key)
		enemy_not_found.get_node("MessageLabel").text = "Enemy configuration not found"  # Set the label text
		enemy_not_found.popup()  # Show the dialog when enemy is not found

func instantiate_and_display_enemy(enemy_name: String, position: String) -> void:
	# Load the enemy_details scene
	var enemy_details_scene = load("res://Scenes/enemy_details.tscn")
	if enemy_details_scene == null:
		print("Error: Failed to load enemy_details.tscn scene.")
		return

	# Instantiate the scene
	enemy_details_instance = enemy_details_scene.instantiate()
	if enemy_details_instance == null:
		print("Error: Failed to instantiate enemy_details instance.")
		return

	# Set enemy data
	enemy_details_instance.set_enemy_data(enemy_name)
	print(enemy_name)

	# Display the instantiated enemy based on the position
	match position:
		"I":
			if enemy_scene_i != null:
				enemy_scene_i.queue_free()  # Clear previous instance if any
			enemy_container_1.add_child(enemy_details_instance)
			enemy_scene_i = enemy_details_instance  # Store instance in global variable
		"II":
			if enemy_scene_ii != null:
				enemy_scene_ii.queue_free()
			enemy_container_2.add_child(enemy_details_instance)
			enemy_scene_ii = enemy_details_instance
		"III":
			if enemy_scene_iii != null:
				enemy_scene_iii.queue_free()
			enemy_container_3.add_child(enemy_details_instance)
			enemy_scene_iii = enemy_details_instance
		"IV":
			if enemy_scene_iv != null:
				enemy_scene_iv.queue_free()
			enemy_container_4.add_child(enemy_details_instance)
			enemy_scene_iv = enemy_details_instance
		_:
			print("Error: Invalid position specified -", position)
			
	print("Instantiated enemy:", enemy_name, "at position:", position)
	# Add the instance to the list if not already present
	if not enemy_details_instances.has(enemy_details_instance):
		enemy_details_instances.append(enemy_details_instance)
	print("Instantiated enemy:", enemy_name, "at position:", position)
	print("Enemy details instance:", enemy_details_instance)

func _on_remove_enemy_i_button_pressed():
	remove_scene_i()

func remove_scene_i():
	if enemy_scene_i:
		enemy_scene_i.queue_free()  # Remove the scene from position I
		enemy_scene_i = null
	enemy_for_i = ""
	print("Removed enemy from position I")

func _on_remove_enemy_ii_button_pressed():
	remove_scene_ii()

func remove_scene_ii():
	if enemy_scene_ii:
		enemy_scene_ii.queue_free()  # Remove the scene from position II
		enemy_scene_ii = null
	enemy_for_ii = ""
	print("Removed enemy from position II")

func _on_remove_enemy_iii_button_pressed():
	remove_scene_iii()

func remove_scene_iii():
	if enemy_scene_iii:
		enemy_scene_iii.queue_free()  # Remove the scene from position III
		enemy_scene_iii = null
	enemy_for_iii = ""
	print("Removed enemy from position III")

func _on_remove_enemy_iv_button_pressed():
	remove_scene_iv()


func remove_scene_iv():
	if enemy_scene_iv:
		enemy_scene_iv.queue_free()  # Remove the scene from position IV
		enemy_scene_iv = null
	enemy_for_iv = ""
	print("Removed enemy from position IV")

func _on_remove_all_button_pressed():
	remove_all_scenes()

func remove_all_scenes() -> void:
	#get_tree().unload_current_scene()
	get_tree().change_scene_to_file("res://Scenes/main_node.tscn")





func display_message(text: String, duration: float = 3.0):
	# Assuming `MessageDisplay` is a RichTextLabel in the main node
	var message_display = get_node("MessageDisplay")

	# Append the message to show in the display
	message_display.add_text(text + "\n")

	# Optional: clear message after a set time
	#if duration > 0:
		#yield(get_tree().create_timer(duration), "timeout")
		# Clear only the added text after the duration
		#message_display.clear()



func _on_toggle_toggled(toggled_on: bool) -> void:
	print("Toggled")
	Global.toggle_visibility(toggled_on)
