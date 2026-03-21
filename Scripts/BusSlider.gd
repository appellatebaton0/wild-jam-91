class_name BusSlider extends HBoxContainer
## Allows for using a slider to change the volume of an AudioBus

@onready var slider := $Slider
@onready var value :=  $Value

@export var bus_name := &"Master"
@onready var bus_index := AudioServer.get_bus_index(bus_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider.value_changed.connect(_on_slider_changed)
	
	_on_slider_changed(slider.value)

func _on_slider_changed(to:float):
	
	AudioServer.set_bus_volume_db(bus_index, to)
	
	value.text = str(round(to * 10) / 10)
