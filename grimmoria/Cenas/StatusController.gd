extends HBoxContainer

const MAXHP: int = Globals.MAXVIDA
const MAXMP: int = Globals.MAXMANA

@onready var hpBar: TextureProgressBar = $HpBar
@onready var mpBar: TextureProgressBar = $MpBar

@onready var hp: int = MAXHP
@onready var mp: int = MAXMP

func _ready() -> void:
	hpBar.max_value = MAXHP
	mpBar.max_value = MAXMP
	hpBar.value = hp
	mpBar.value = mp

func take_damage(damage):
	hpBar.value -= damage
	hp -= damage
	clampi(hp, 0, MAXHP)
	Globals.hp = hp

func use_mana(mpUsada: int):
	mpBar.value -= mpUsada
	mp -= mpUsada
	clampi(mp, 0, MAXMP)
	Globals.mp = mp

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_0:
		take_damage(10)
	if event is InputEventKey and event.pressed and event.keycode == KEY_1:
		use_mana(10)
