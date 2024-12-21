extends Control

var pickups : Array[int]
var timer : float = 0
var running : bool = false
var super_credits : int = 0
@export_group("Node References")

@export var timer_label : Label
@export var play_button : Button
@export var pause_button : Button
@export var reset_button : Button
@export var add10_button : Button
@export var add100_button : Button
@export var undo_button : Button
@export var credits_label : Label
@export var pickups_label : Label
@export var warbond_label : Label
@export var current_sc_label : Label
@export var sc_entry : LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		timer += delta
	
	play_button.disabled = running
	pause_button.disabled = !running 
	add10_button.disabled = !running 
	add100_button.disabled = !running 
	reset_button.disabled = not timer > 0
	undo_button.disabled = not pickups.size() > 0
	
	current_sc_label.text = str(super_credits)
	timer_label.text = get_time()
	pickups_label.text = str(pickups.size()) + " Pickups - " + str(round(pickups.size()*(3600/timer))) + " /h (" + str(round((pickups.size()*10)*(3600/timer))) + " SC/hr)"
	credits_label.text = str(get_total_credits()) + " Super Credits - " + str(round(get_total_credits()*(3600/timer))) + " /h"
	warbond_label.text = "Next warbond in: " + str(get_next_warbond()) + "m"

#returns the amount of minutes until 1000 sc reached 
func get_next_warbond() -> int:
	var next_warbond_needed : float = 1000 - wrap(super_credits,0, 1000)
	
	if next_warbond_needed <= 0:
		return 0
	var sc_per_hour_min : float = round((pickups.size()*10)*(3600/timer))
	return (next_warbond_needed/sc_per_hour_min)*60

func get_total_credits() -> int:
	var total : int
	for pickup in pickups:
		total += pickup
	return total

func get_time() -> String:
	var hours : int = floori(timer/3600)
	var minutes : int = floori(timer/60) - hours*60
	var seconds : int = roundi(timer) - minutes*60 - hours*3600
	return str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	

func _on_play_button_pressed():
	running = true


func _on_pause_button_pressed():
	running = false


func _on_reset_button_pressed():
	pickups.clear()
	running = false
	timer = 0


func _on_add_10_pressed():
	pickups.append(10)
	super_credits += 10


func _on_add_100_pressed():
	pickups.append(100)
	super_credits += 100


func _on_undo_pressed():
	super_credits -= pickups.pop_back()


func _on_set_sc_button_pressed():
	super_credits = sc_entry.text.to_int()
	sc_entry.clear()
