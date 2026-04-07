class_name Skill


var coin_count = 4
var coin_value = 2
var base = 3
enum effects {
	Crit,
	Bleed,
	None
}

func _init(givenCoinCount,givenCointValue,givenBaseValue,givenCoins) -> void:
	coin_count = givenCoinCount
	coin_value = givenCointValue
	base = givenBaseValue
	coins = givenCoins


var coins = {
	0 : Coin.new(effects.Bleed,1),
	1 : Coin.new(effects.Crit, 1),
	2 : Coin.new(effects.Crit,1),
	3 : Coin.new(effects.Crit, 1)
}

## SANITY IS 0.45-0
func roll_skill(sanity,coinsub):
	var value = 0;
	var heads = 0;
	print(coin_count - coinsub)
	for coin in coin_count - coinsub:
		var flip = randf_range(0,1)
		print("flip " + str(coin))
		if (flip + sanity >=  0.5):
			value += coin_value
			heads += 1
	return [value,heads]
