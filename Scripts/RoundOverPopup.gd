class_name RoundOverPopup extends Control

@onready var income_box := %IncomeBox
@onready var expense_box := %ExpenseBox

@onready var total_income_lab := %TotalIncome
@onready var total_expenses_lab := %TotalExpenses

@onready var heading := $Panel/MarginContainer/VBoxContainer/Label

var total_income:int = 0
var total_expenses:int = 0

func round_ended(players:Array[Player], winners:Array, draws:Array, naturals:Array):
	clear_boxes()
	
	for player in players:
		if naturals.has(player):
			add_expense(player.player_name + " Won", floori(float(player.bet) * 1.5))
		elif winners.has(player):
			add_expense(player.player_name + " Won", player.bet)
		elif draws.has(player):
			pass
		else:
			add_income(player.player_name + " Lost", player.bet)
	
	commit_payout()
	
	if len(winners): heading.text = "LOSE"
	elif len(draws): heading.text = "DRAW"
	else:            heading.text = "WIN" 


func clear_boxes():
	for child in income_box.get_children(): child.queue_free()
	for child in expense_box.get_children(): child.queue_free()
	
	total_expenses = 0
	total_income = 0

func add_income(label:String, amount:int):
	
	var new := RichTextLabel.new()
	new.bbcode_enabled = true
	new.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new.fit_content = true
	new.text = "[color=#5a9634]" + label + " - $" + str(amount)
	
	income_box.add_child(new)
	total_income += amount

func add_expense(label:String, amount:int):
	
	var new := RichTextLabel.new()
	new.bbcode_enabled = true
	new.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new.fit_content = true
	new.text = "[color=#e93816]" + label + " - -$" + str(amount)
	
	expense_box.add_child(new)
	total_expenses += amount

func commit_payout() -> void:
	
	## Display the totals.
	
	total_expenses_lab.text = "TOTAL EXPENSES: " + str(total_expenses)
	total_income_lab.text   = "TOTAL INCOME: " + str(total_income)
	
	## Commit the actual incomes.
	
	Global.bank -= total_expenses
	Global.money += total_income
	
	if total_expenses > total_income:
		$Lose.play()
	elif not total_expenses == total_income:
		$Win.play()
