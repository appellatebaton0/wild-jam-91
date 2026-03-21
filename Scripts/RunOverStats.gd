class_name RunOverStats extends VBoxContainer

@export var anim_player:AnimationPlayer

@onready var total_income   := $HBoxContainer/TotalIncome
@onready var total_expenses := $HBoxContainer2/TotalExpenses
@onready var chips_used     := $HBoxContainer3/ChipsUsed
@onready var games_played   := $HBoxContainer4/GamesPlayed

func _on_current_animation_changed(anim_name: StringName) -> void:
	if anim_name == "RunEnded": _update()

func _update() -> void:
	total_income.text = "$" + str(Global.total_income)
	total_expenses.text = "$" + str(Global.total_expenses)
	chips_used.text = str(Global.chips_used)
	games_played.text = str(Global.round_count)
