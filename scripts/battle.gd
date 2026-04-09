extends Control
@onready var healthidentifier = $UI/SubViewport/TextureRect/RichTextLabel
@onready var spidentifier = $UI/SubViewport/TextureRect/TextureProgressBar
@onready var heads = $UI/SubViewport/TextureRect/heads
@onready var tails = $UI/SubViewport/TextureRect/tails
@onready var playercont = $UI/SubViewport/playercoins
@onready var enemycont = $UI/SubViewport/enemycoins
@onready var actioncontainer =$UI/SubViewport/TextureRect/VBoxContainer
@onready var skill1button = $UI/SubViewport/TextureRect/VBoxContainer/Button
@onready var skill2button = $UI/SubViewport/TextureRect/VBoxContainer/Button2
@onready var PlayerCoinValue = $UI/SubViewport/PlayerCoinValue
@onready var EnemyCoinValue = $UI/SubViewport/EnemyCoinValue
@onready var player : CharacterBody3D
var playerbasefighter : baseFighter
var enemypreload = preload("res://scenes/Entities/2.5D/enemy.tscn")
var enemy
var enemymain
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
var wasenemynull = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var marker
	if (enemymain == null):
		enemymain = enemypreload.instantiate()
		self.add_child(enemymain)
		marker = Marker3D.new()
		add_child(marker)
		marker.global_position = player.global_position + Vector3(4,0,0)
		wasenemynull = true
	enemy = enemymain.battler
	enemymain.isbattling = true
	playerbasefighter = player.base
	player.isbattling = true
	baseplayerLocation = player.global_position
	if (wasenemynull || player.global_position.distance_to(enemymain.global_position) < 5):
		marker = Marker3D.new()
		add_child(marker)
		marker.global_position = player.global_position + Vector3(4,0,0)
		enemymain.global_position = marker.global_position
	baseenemyLocation = enemy.global_position
	midpoint = Vector3(
		(baseplayerLocation.x+baseenemyLocation.x)/2,
		(baseplayerLocation.y+baseenemyLocation.y)/2,
		(baseplayerLocation.z+baseenemyLocation.z)/2
		)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthidentifier.value = global.health
	healthidentifier.max_value = global.maxhealth
	spidentifier.value = playerbasefighter.sp
	global.health = playerbasefighter.health
	if (playeraction != null && enemyaction != null && thoughtenemyaction == false):
		midpoint = Vector3(midpoint.x + randf_range(-1,1),midpoint.y,midpoint.z + randf_range(-1,1))
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
				var tween : Tween = get_tree().create_tween()
				var tweenb : Tween = get_tree().create_tween()
				$Running.play()
				tweenb.tween_property(
			enemy,"global_position",Vector3(baseplayerLocation.x + 1, baseplayerLocation.y, baseplayerLocation.z),0.5
			)
				await get_tree().create_timer(0.5).timeout
				$Running.stop()
				enemy.anim.play("attack")
				$Stab.pitch_scale = randf_range(1,1.5)
				$Stab.play()
				await get_tree().create_timer(0.5).timeout
				tween = get_tree().create_tween()
				tween.tween_property(
					enemy,"global_position",Vector3(baseenemyLocation),0.2
				)
				enemy.anim.play("idle_side")
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
				var tween : Tween = get_tree().create_tween()
				var tweenb : Tween = get_tree().create_tween()
				tweenb.tween_property(
			player,"global_position",Vector3(baseenemyLocation.x - 2, baseenemyLocation.y, baseenemyLocation.z),0.5
			)
				$Running.play()
				await get_tree().create_timer(0.5).timeout
				$Running.stop()
				player.anim.play("attack")
				$Stab.pitch_scale = randf_range(1,1.5)
				$Stab.play()
				await get_tree().create_timer(0.5).timeout
				tween = get_tree().create_tween()
				tween.tween_property(
					player,"global_position",Vector3(baseplayerLocation),0.2
				)
				player.anim.play("idle_side")
				print("player fully won!")
				print(enemy.base.health)
				var playerValue = playeraction.roll_skill(playerbasefighter.sp,playersubcoins)
				enemy.base.damage(playerValue[0])
				enemy.base.damagesp(0.10)
				playerbasefighter.healSp(0.1)
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
			PlayerCoinValue.add_text(str(playerValue[0]))
			for x in enemyValue[1]:
				var head = heads.duplicate()
				enemycont.add_child(head)
				head.visible = true
				await get_tree().create_timer(0.1- (tieamount/100)).timeout
			EnemyCoinValue.clear()
			EnemyCoinValue.add_text(str(enemyValue[0]))
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
			$Running.play()
			await get_tree().create_timer(0.5).timeout
			$Running.stop()
			player.anim.play("attack")
			player.anim.flip_h = true
			enemy.anim.play("attack")
			enemy.anim.flip_h = false
			$GPUParticles3D.global_position = midpoint
			$GPUParticles3D.emitting = true
			$Clash.pitch_scale = randf_range(0.5,1.5)
			$Clash.play()
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
	if (global.health == 0):
		pass #gameover
	if (enemy.base.health <= 0):
		global.combat = 1
		global.isbattling = false
		player.isbattling = false
		enemymain.die()
		await get_tree().create_timer(0.5)
		self.queue_free()





func onskillbutton2Pressed() -> void:
	playeraction = skillb
	skill1button.get_parent().visible = false
	$Button.pitch_scale = 1.2
	$Button.play()



func onskillbutton1_Pressed() -> void:
	playeraction = skilla
	skill1button.get_parent().visible = false
	$Button.pitch_scale = 1.5
	$Button.play()

@onready var skilla : Skill
@onready var skillb : Skill
func attack_on_button_pressed() -> void:
	if (playeraction == null):
		print("attackbutton")
		$Button.pitch_scale = 1
		$Button.play()
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



func flee_on_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_fight_pressed() -> void:
	if (playeraction == null):
		playeraction = playerbasefighter.skill1
		skill1button.get_parent().visible = false
		$Button.pitch_scale = 1.2
		$Button.play()


func _on_item_pressed() -> void:
	$Button.pitch_scale = -0.3
	$Button.play()


func _on_flee_pressed() -> void:
	$Button.pitch_scale = -0.3
	$Button.play()
