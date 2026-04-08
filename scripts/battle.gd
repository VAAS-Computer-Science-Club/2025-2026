extends Control
@onready var player : Node3D = $playerbattle
@onready var healthidentifier = $UI/SubViewport/TextureRect/HBoxContainer/RichTextLabel
@onready var spidentifier = $UI/SubViewport/TextureRect/HBoxContainer/RichTextLabel2
@onready var heads = $UI/SubViewport/TextureRect/heads
@onready var tails = $UI/SubViewport/TextureRect/tails
@onready var playercont = $UI/SubViewport/playercoins
@onready var enemycont = $UI/SubViewport/enemycoins
@onready var actioncontainer =$UI/SubViewport/TextureRect/VBoxContainer
@onready var skill1button = $UI/SubViewport/TextureRect/VBoxContainer/Button
@onready var skill2button = $UI/SubViewport/TextureRect/VBoxContainer/Button2
@onready var PlayerCoinValue = $UI/SubViewport/PlayerCoinValue
@onready var EnemyCoinValue = $UI/SubViewport/EnemyCoinValue
var playerbasefighter : baseFighter
var enemypreload = preload("res://scenes/Subsystems/Battle/enemybattle.tscn")
var enemy
var isPlayerturn = false
var mainscene
var thoughtenemyaction = false
var isactionhappening = false
var genskill = false
var enemyaction : Skill
var playeraction : Skill
var enemysubcoins = 0
var playersubcoins = 0
var tieamount = 0
var baseplayerLocation : Vector3
var baseenemyLocation : Vector3
var midpoint : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy = enemypreload.instantiate()
	self.add_child(enemy)
	playerbasefighter = player.base
	baseplayerLocation = player.global_position
	enemy.global_position = $"BattleVisuals/SubViewport/Level Node/Marker3D".global_position
	baseenemyLocation = enemy.global_position
	midpoint = Vector3(
		(baseplayerLocation.x+baseenemyLocation.x)/2,
		(baseplayerLocation.y+baseenemyLocation.y)/2,
		(baseplayerLocation.z+baseenemyLocation.z)/2
		)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthidentifier.clear()
	healthidentifier.add_text("Health: " + str(playerbasefighter.health) + "/" + str(playerbasefighter.maxhealth))
	spidentifier.clear()
	spidentifier.add_text("SP: " + str(playerbasefighter.sp) + "/" + str(playerbasefighter.maxsp))
	if (playeraction != null && enemyaction != null && thoughtenemyaction == false):
		$UI/SubViewport/TextureRect.visible = false
		thoughtenemyaction = true
		await get_tree().create_timer(1 - (tieamount/10)).timeout
		for child : Node in playercont.get_children():
			playercont.remove_child(child)
		for child : Node in enemycont.get_children():
			enemycont.remove_child(child)
		playercont.get_children()
		
		#play combat anim
		if (playeraction != null):
			if (playersubcoins == playeraction.coin_count):
				var enemyValue = enemyaction.roll_skill(enemy.base.sp,enemysubcoins)
				playerbasefighter.damage(enemyValue[0])
				playerbasefighter.damagesp(0.1)
				enemy.base.healSp(0.1)
				isPlayerturn = false
				playeraction = null
				enemyaction = null
				thoughtenemyaction = false
				enemysubcoins = 0
				playersubcoins = 0
				genskill = false
				skill1button.get_parent().visible = false
				return
				#enemy fully won
				pass
		if (enemyaction != null && playeraction != null):
			if (enemysubcoins == enemyaction.coin_count):
				#player fully won
				var playerValue = playeraction.roll_skill(playerbasefighter.sp,playersubcoins)
				enemy.base.damage(playerValue[0])
				enemy.base.damagesp(0.10)
				isPlayerturn = false
				playeraction = null
				enemyaction = null
				enemysubcoins = 0
				playersubcoins = 0
				thoughtenemyaction = false
				genskill = false
				skill1button.get_parent().visible = false
				return
		if (playeraction != null && enemyaction != null):
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
				tieamount += 1
			#displaycoins
			for x in playerValue[1]:
				var head = heads.duplicate()
				playercont.add_child(head)
				head.visible = true
				await get_tree().create_timer(0.1- (tieamount/100)).timeout
			PlayerCoinValue.clear()
			PlayerCoinValue.add_text("PLAYER COIN VALUE " + str(playerValue[0]))
			for x in enemyValue[1]:
				var head = heads.duplicate()
				enemycont.add_child(head)
				head.visible = true
				await get_tree().create_timer(0.1- (tieamount/100)).timeout
			EnemyCoinValue.clear()
			EnemyCoinValue.add_text("Enemy COIN VALUE " + str(enemyValue[0]))
			if (enemyaction != null):
				if (enemyValue[1] != enemyaction.coin_count-enemysubcoins):
					for x in (enemyaction.coin_count-enemysubcoins) - enemyValue[1]:
						await get_tree().create_timer(0.1- (tieamount/100)).timeout
						var tails = tails.duplicate()
						enemycont.add_child(tails)
						tails.visible = true
			if (playeraction != null):
				if (playerValue[1] != playeraction.coin_count-playersubcoins):
					for x in (playeraction.coin_count-playersubcoins) - enemyValue[1]:
						await get_tree().create_timer(0.1- (tieamount/100)).timeout
						var tails = tails.duplicate()
						playercont.add_child(tails)
						tails.visible = true
			player.anim.play("walk_side")
			player.anim.flip_h = true
			enemy.anim.play("walk_side")
			enemy.anim.flip_h = true
			var tween : Tween = get_tree().create_tween()
			var tweenb : Tween = get_tree().create_tween()
			tween.tween_property(
			player,"global_position",midpoint,0.5
			)
			tweenb.tween_property(
			enemy,"global_position",midpoint,0.5
			)
			player.anim.play("attack")
			player.anim.flip_h = true
			enemy.anim.play("attack")
			enemy.anim.flip_h = false
			await player.anim.animation_finished
			await get_tree().create_timer(0.6-(tieamount/10)).timeout
			player.anim.play("walk_side")
			player.anim.flip_h = false
			enemy.anim.play("walk_side")
			enemy.anim.flip_h = true
			tween = get_tree().create_tween()
			tweenb = get_tree().create_tween()
			tween.tween_property(
				player,"global_position",baseplayerLocation,0.2
				)
			tweenb.tween_property(
				enemy,"global_position",baseenemyLocation,0.2
				)
			await get_tree().create_timer(0.3-(tieamount/10)).timeout
			player.anim.play("idle_side")
			player.anim.flip_h = true
			enemy.anim.play("idle_side")
			enemy.anim.flip_h = false
			

		thoughtenemyaction = false
	await get_tree().create_timer(0.5 - (tieamount/10)).timeout
				
			
	if (isPlayerturn && playeraction == null):
		#accept input
		$UI/SubViewport/TextureRect.visible = true
		if (genskill == false):
			genskill = true
	else:
		#don't accept input
		##think
		if (thoughtenemyaction == false && enemyaction == null):
			enemyaction = enemy.action()
		isPlayerturn = true





func onskillbutton2Pressed() -> void:
	playeraction = skillb
	skill1button.get_parent().visible = false



func onskillbutton1_Pressed() -> void:
	playeraction = skilla
	skill1button.get_parent().visible = false

@onready var skilla : Skill
@onready var skillb : Skill
func attack_on_button_pressed() -> void:
	if (playeraction == null):
		genskill = true
		skilla = playerbasefighter.genskills()
		skillb = playerbasefighter.genskills()
		skill1button.text = "Skill " + str(dif_skills(skilla,playerbasefighter))
		skill2button.text = "Skill " + str(dif_skills(skillb,playerbasefighter))
		skill1button.get_parent().visible = true

func dif_skills(skill : Skill, basefighter : baseFighter):
	if (skill == basefighter.skill1):
		return 1
	elif (skill == basefighter.skill2):
		return 2
	else:
		return 3

func item_on_button_2_pressed() -> void:
	pass # Replace with function body.


func flee_on_button_3_pressed() -> void:
	pass # Replace with function body.
