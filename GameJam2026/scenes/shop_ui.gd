class_name ShopUI extends Control

@export var inventory: Inventory
@export var player: Player

@onready var coins_label: Label = %CoinsLabel

@onready var pumpkin_button: Button = %BuyPumpkin
@onready var corn_button: Button = %BuyCorn
@onready var eggplant_button: Button = %BuyEggplant

@onready var damage_upgrade_button: Button = %DamageUpgrade
@onready var health_upgrade_button: Button = %Health

@onready var pumpkin_price_label: Label = %PumpkinPrice
@onready var corn_price_label: Label = %CornPrice
@onready var eggplant_price_label: Label = %EggplantPrice

var coins_count: int

var seeds_prices: Dictionary = {
	"pumpkin_seed": 15,
	"corn_seed": 3,
	"eggplant_seed": 6
}

var crop_sell_prices: Dictionary = {
	"pumpkin": 20,
	"corn": 5,
	"eggplant": 12
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pumpkin_price_label.text = "Price: " + str(seeds_prices["pumpkin_seed"])
	corn_price_label.text = "Price: " + str(seeds_prices["corn_seed"])
	eggplant_price_label.text = "Price: " + str(seeds_prices["eggplant_seed"])
	update_upgrade_prices()
	inventory.inventory_changed.connect(update_upgrade_prices)

func _physics_process(delta: float) -> void:
	coins_count = inventory.get_count("coins")
	coins_label.text = "Coins: " + str(coins_count)
	
	if inventory.get_count("pumpkin_seed") >= 64:
		pumpkin_button.disabled = true
	else:
		pumpkin_button.disabled = false
		
	if inventory.get_count("corn_seed") >= 64:
		corn_button.disabled = true
	else:
		corn_button.disabled = false
		
	if inventory.get_count("eggplant_seed") >= 64:
		eggplant_button.disabled = true
	else:
		eggplant_button.disabled = false



func buy_seed(item: String) -> void:
	if inventory.get_count(item) <= 63 && inventory.get_count("coins") >= seeds_prices[item]:
		inventory.add(item, 1)
		inventory.remove("coins", seeds_prices[item])

func sell_all() -> void:
	var total_coins: int = 0

	total_coins += inventory.get_count("pumpkin") * crop_sell_prices["pumpkin"]
	total_coins += inventory.get_count("corn") * crop_sell_prices["corn"]
	total_coins += inventory.get_count("eggplant") * crop_sell_prices["eggplant"]

	inventory.remove("pumpkin", inventory.get_count("pumpkin"))
	inventory.remove("corn", inventory.get_count("corn"))
	inventory.remove("eggplant", inventory.get_count("eggplant"))

	inventory.add("coins", total_coins)
	

func _on_buy_pumpkin_pressed() -> void:
	buy_seed("pumpkin_seed")


func _on_buy_eggplant_pressed() -> void:
	buy_seed("eggplant_seed")


func _on_buy_corn_pressed() -> void:
	buy_seed("corn_seed")


func _on_sell_crops_pressed() -> void:
	sell_all()


func _on_speed_upgrade_child_entered_tree(node: Node) -> void:
	player.speed_multiplier += 0.10

func update_upgrade_prices() -> void:
	var damage_price: int = get_upgrade_price("damage")
	var health_price: int = get_upgrade_price("health")

	%DamagePrice.text = "Price: " + str(damage_price) if damage_price != -1 else "MAX"
	%HealthPrice.text = "Price: " + str(health_price) if health_price != -1 else "MAX"

	damage_upgrade_button.disabled = damage_price == -1 || inventory.get_count("coins") < damage_price
	health_upgrade_button.disabled = health_price == -1 || inventory.get_count("coins") < health_price

func _on_damage_upgrade_pressed() -> void:
	buy_upgrade("damage")


func _on_health_pressed() -> void:
	buy_upgrade("health")


func get_upgrade_price(upgrade_name: String) -> int:
	var upgrade: Dictionary = player.multiplier_dictionary[upgrade_name]
	var level: int = upgrade["level"]

	if level >= upgrade["max_level"]:
		return -1

	return upgrade["prices"][level]

func buy_upgrade(upgrade_name: String) -> void:
	var upgrade: Dictionary = player.multiplier_dictionary[upgrade_name]
	var level: int = upgrade["level"]

	if level >= upgrade["max_level"]:
		return

	var price: int = upgrade["prices"][level]

	if inventory.get_count("coins") < price:
		return

	inventory.remove("coins", price)
	upgrade["level"] += 1

	player.apply_upgrade(upgrade_name)
	update_upgrade_prices()
