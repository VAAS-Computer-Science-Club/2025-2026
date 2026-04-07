extends Control
@onready var player = $playerbattle
@onready var healthidentifier = $TextureRect/HBoxContainer/RichTextLabel
@onready var spidentifier = $TextureRect/HBoxContainer/RichTextLabel2
@onready var heads = $TextureRect/heads
@onready var tails = $TextureRect/tails
@onready var playercont = $playercoins
@onready var enemycont = $enemycoins
var playerbasefighter : baseFighter
var enemypreload = preload("res://scenes/Subsystems/Battle/enemybattle.tscn")
var enemy
var isPlayerturn = false
var mainscene
var thoughtenemyaction = false
var isactionhappening = false
var enemyaction : Skill
var playeraction : Skill
var enemysubcoins = 0
var playersubcoins = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy = enemypreload.instantiate()
	self.add_child(enemy)
	playerbasefighter = player.base



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthidentifier.clear()
	healthidentifier.add_text("Health: " + str(playerbasefighter.health) + "/" + str(playerbasefighter.maxhealth))
	spidentifier.clear()
	spidentifier.add_text("Health: " + str(playerbasefighter.sp) + "/" + str(playerbasefighter.maxsp))
	if (playeraction != null && enemyaction != null && thoughtenemyaction == false):
		for child : Node in playercont:
			playercont.remove_child(child)
		for child : Node in enemycont:
			enemycont.remove_child(child)
		playercont.get_children()
		thoughtenemyaction == true
		#play combat anim
		if (playersubcoins == playeraction.coin_count):
			var enemyValue = enemyaction.roll_skill(enemy.base.sp,enemysubcoins)
			playerbasefighter.damage(enemyValue)
			playeraction = null
			enemyaction = null
			thoughtenemyaction = false
			return
			#enemy fully won
			pass
		if (enemysubcoins == enemyaction.coin_count):
			#player fully won
			var playerValue = playeraction.roll_skill(playerbasefighter.sp,playersubcoins)
			enemy.base.damage(playerValue)
			playeraction = null
			enemyaction = null
			thoughtenemyaction = false
			return
		var playerValue = playeraction.roll_skill(playerbasefighter.sp,playersubcoins)
		var enemyValue = enemyaction.roll_skill(enemy.base.sp,playersubcoins)
		
		if (playerValue[0] > enemyValue[0]):
			print("player won")
			enemysubcoins += 1
		elif (playerValue[0] < enemyValue[0]):
			print("enemy won")
			playersubcoins += 1
		else:
			print("tie")
		#displaycoins
		for x in playerValue[1]:
			var head = heads.duplicate()
			playercont.add_child(head)
		for x in enemyValue[1]:
			var head = heads.duplicate()
			enemycont.add_child(head)
		if (enemyValue[1] != enemyaction.coin_count):
			for x in enemyaction.coin_count - enemyValue[1]:
				var tails = tails.duplicate()
				enemycont.add_child(tails)
				await get_tree().create_timer(0.1).timeout
		if (playerValue != playeraction.coin_count):
			for x in playeraction.coin_count - enemyValue[1]:
				var tails = tails.duplicate()
				playercont.add_child(tails)
				await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(0.5).timeout
			
			
	if (isPlayerturn && playeraction == null):
		#accept input
		pass
	else:
		#don't accept input
		##think
		if (thoughtenemyaction == false && enemyaction == null):
			enemyaction = enemy.action()
		isPlayerturn = true


