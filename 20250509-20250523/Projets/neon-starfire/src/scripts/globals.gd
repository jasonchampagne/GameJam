extends Node

enum TypeCase { CASEMUR, CASELIBRE }

enum TypeCaseDetails {
	CASEMUR,
	CASEMUR_DROIT,
	CASEMUR_GAUCHE,
	CASEMUR_BAS,
	CASEMUR_HAUT,
	CASEMUR_DROIT_HAUT,
	CASEMUR_DROIT_BAS,
	CASEMUR_GAUCHE_HAUT,
	CASEMUR_GAUCHE_BAS,
	CASEMUR_DROIT_GAUCHE,
	CASEMUR_HAUT_BAS,
	CASEMUR_DROIT_HAUT_BAS,
	CASEMUR_GAUCHE_HAUT_BAS,
	CASEMUR_DROIT_GAUCHE_HAUT,
	CASEMUR_DROIT_GAUCHE_BAS,
	CASEMUR_HAUT_BAS_GAUCHE,
	CASEMUR_HAUT_BAS_DROIT,
	CASELIBRE,
	CASEEXPLOSED,
	CASEGATLINGED,
	CASEENCHANCED,
	CASESOLUTION
}

enum TypeCard { MOVE, AMPLIFICATEUR, MAZE, SCORE, PLAYER }

#const INITIAL_WIDTH: int = 6
#const INITIAL_HEIGHT: int = 6

const INITIAL_WIDTH: int = 8
const INITIAL_HEIGHT: int = 8

const TILE_SIZE: int = 16

# const CARD_WIDH: int = 666
# const CARD_HEIGHT: int = 913
const CARD_WIDH: int = 168
const CARD_HEIGHT: int = 240
const CARD_SIZE: Vector2 = Vector2(CARD_WIDH, CARD_HEIGHT)
# TODO All this params can be modify by card or bonus
const HAND_SIZE: int = 8
const DECK_SIZE: int = 24
const SHOP_SIZE: int = 6
const DROP_SIZE: int = 6
const DISCARD_SIZE: int = 8
const POURCENTAGE_CASEDOUBLE: float = 0.1
const POURCENTAGE_BACKTRACK: float = 0.1
const ANOMATION_SPEED: int = 4
const TIME_ANOMATION_SPEED: float = 1.0 / ANOMATION_SPEED

# Depends of theme tileset
const CELL_CASEMUR: Vector2i = Vector2i(10, 0)
const CELL_CASETRACE: Vector2i = Vector2i(6, 6)
const CELL_CASEEND: Vector2i = Vector2i(6, 3)
const CELL_CASETRACE_START: Vector2i = Vector2i(6, 5)
const CELL_CASETRACE_TURN: Vector2i = Vector2i(19, 6)
const CELL_CASEEMPTY: Vector2i = Vector2i(7, 0)
const CELL_CASEEXPLOSE: Vector2i = Vector2i(6, 1)
const CELL_CASESOLUTION: Vector2i = Vector2i(9, 4)

const DISPLAY_CASE = {
	TypeCaseDetails.CASEMUR: CELL_CASEMUR,
	TypeCaseDetails.CASELIBRE: CELL_CASEEMPTY,
	TypeCaseDetails.CASEEXPLOSED: CELL_CASEEXPLOSE,
	TypeCaseDetails.CASEGATLINGED: CELL_CASEEXPLOSE,
	TypeCaseDetails.CASEENCHANCED: CELL_CASEEXPLOSE,
	TypeCaseDetails.CASESOLUTION: CELL_CASESOLUTION
}

# Depends of theme tileset
const CELL_NEON_CASELIBRE: Vector2i = Vector2i(1, 1)
const CELL_NEON_CASEMUR_HAUT: Vector2i = Vector2i(1, 0)  # Bord haut
const CELL_NEON_CASEMUR_BAS: Vector2i = Vector2i(1, 2)  # Bord bas
const CELL_NEON_CASEMUR_HAUT_BAS: Vector2i = Vector2i(1, 3)  # Bord haut et bas
const CELL_NEON_CASEMUR_GAUCHE: Vector2i = Vector2i(0, 1)  # Bord gauche
const CELL_NEON_CASEMUR_GAUCHE_HAUT: Vector2i = Vector2i(5, 0)  #Vector2i(0, 0)
const CELL_NEON_CASEMUR_GAUCHE_BAS: Vector2i = Vector2i(4, 3)  #Vector2i(0, 2)  # Bord gauche et bas
const CELL_NEON_CASEMUR_HAUT_BAS_GAUCHE: Vector2i = Vector2i(0, 3)  # Bord haut, bas et gauche
const CELL_NEON_CASEMUR_DROIT: Vector2i = Vector2i(2, 1)  # Bord droit
const CELL_NEON_CASEMUR_DROIT_HAUT: Vector2i = Vector2i(7, 0)  #Vector2i(2, 0)  # Bord droit et haut
const CELL_NEON_CASEMUR_DROIT_BAS: Vector2i = Vector2i(8, 3)  #Vector2i(2, 2)  # Bord droit et bas
const CELL_NEON_CASEMUR_HAUT_BAS_DROIT: Vector2i = Vector2i(2, 3)  # Bord haut, bas et droit
const CELL_NEON_CASEMUR_DROIT_GAUCHE: Vector2i = Vector2i(3, 3)  # Bord droit et gauche
const CELL_NEON_CASEMUR_DROIT_GAUCHE_HAUT: Vector2i = Vector2i(3, 2)  # Bord droit, gauche et haut
const CELL_NEON_CASEMUR_DROIT_GAUCHE_BAS: Vector2i = Vector2i(3, 4)  # Bord droit, gauche et bas
const CELL_NEON_CASEMUR_HAUT_BAS_DROIT_GAUCHE: Vector2i = Vector2i(1, 1)
# Bord droit, gauche et bas

const TILE_MAPPING_OLD = {
	0: CELL_NEON_CASELIBRE,  # Aucun bord (mur complet)
	1: CELL_NEON_CASEMUR_HAUT,  # Bord haut
	2: CELL_NEON_CASEMUR_BAS,  # Bord bas
	3: CELL_NEON_CASEMUR_HAUT_BAS,  # Bord haut et bas
	4: CELL_NEON_CASEMUR_GAUCHE,  # Bord gauche
	5: CELL_NEON_CASEMUR_GAUCHE_HAUT,  # Bord gauche et haut
	6: CELL_NEON_CASEMUR_GAUCHE_BAS,  # Bord gauche et bas
	7: CELL_NEON_CASEMUR_HAUT_BAS_GAUCHE,  # Bord haut, bas et gauche
	8: CELL_NEON_CASEMUR_DROIT,  # Bord droit
	9: CELL_NEON_CASEMUR_DROIT_HAUT,  # Bord droit et haut
	10: CELL_NEON_CASEMUR_DROIT_BAS,  # Bord droit et bas
	11: CELL_NEON_CASEMUR_HAUT_BAS_DROIT,  # Bord haut, bas et droit
	12: CELL_NEON_CASEMUR_DROIT_GAUCHE,  # Bord droit et gauche
	13: CELL_NEON_CASEMUR_DROIT_GAUCHE_HAUT,  # Bord droit, gauche et haut
	14: CELL_NEON_CASEMUR_DROIT_GAUCHE_BAS,  # Bord droit, gauche et bas
	15: CELL_NEON_CASEMUR_HAUT_BAS_DROIT_GAUCHE  # Tous les bords
}

const TILE_MAPPING = {
	0: CELL_NEON_CASELIBRE,  # Aucun bord (mur complet)
	1: CELL_NEON_CASEMUR_GAUCHE,  # Bord gauche
	2: CELL_NEON_CASEMUR_DROIT,  # Bord droit
	3: CELL_NEON_CASEMUR_DROIT_GAUCHE,  # Bord droit et gauche
	4: CELL_NEON_CASEMUR_HAUT,  # Bord haut
	5: CELL_NEON_CASEMUR_GAUCHE_HAUT,  # Bord gauche et haut
	6: CELL_NEON_CASEMUR_DROIT_HAUT,  # Bord droit et haut
	7: CELL_NEON_CASEMUR_DROIT_GAUCHE_HAUT,  # Bord droit, gauche et haut
	8: CELL_NEON_CASEMUR_BAS,  # Bord bas
	9: CELL_NEON_CASEMUR_GAUCHE_BAS,  # Bord gauche et bas
	10: CELL_NEON_CASEMUR_DROIT_BAS,  # Bord droit et bas
	11: CELL_NEON_CASEMUR_DROIT_GAUCHE_BAS,  # Bord droit, gauche et bas
	12: CELL_NEON_CASEMUR_HAUT_BAS,  # Bord haut et bas
	13: CELL_NEON_CASEMUR_HAUT_BAS_GAUCHE,  # Bord haut, bas et gauche
	14: CELL_NEON_CASEMUR_HAUT_BAS_DROIT,  # Bord haut, bas et droit
	15: CELL_NEON_CASEMUR_HAUT_BAS_DROIT_GAUCHE  # Tous les bords
}

# Sprite managemnt
const TEXTURE_SIZE: Vector2 = Vector2(64, 51)
# equal to TILE_SIZE
const SPRITE_SIZE: Vector2 = Vector2(16, 17)
const SPRITE_SHEET_MAPING = {0: "ui_down", 1: "ui_right", 2: "ui_up", 3: "ui_left"}

const DIRECTIONS_I = [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN]

const EXPLOSE = {
	"right": Vector2i.RIGHT,
	"left": Vector2i.LEFT,
	"up": Vector2i.UP,
	"down": Vector2i.DOWN,
	"down_right": Vector2i(1, 1),  # Diagonale bas-droite
	"up_left": Vector2i(-1, -1),  # Diagonale haut-gauche
	"down_left": Vector2i(-1, 1),  # Diagonale bas-gauche
	"up_right": Vector2i(1, -1)  # Diagonale haut-droite
}

# Interface

const INPUTS = {
	"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN
}

const INPUTS_I = {
	"ui_right": Vector2i.RIGHT,
	"ui_left": Vector2i.LEFT,
	"ui_up": Vector2i.UP,
	"ui_down": Vector2i.DOWN
}

const OPPOSITE_DIR = {
	"ui_right": "ui_left", "ui_left": "ui_right", "ui_up": "ui_down", "ui_down": "ui_up"
}

const ROLLBACK_BUTTON = "ui_accept"
const PATH_CARD_SOUND_EFFETS = "res://assets/sounds/card_effects/"
# "card_database_test_display.json"
const JSON_CARD_DATABASE_PATH = "res://scripts/cards/data/card_database_release.json"
const DEFAULT_BACK_CARD_PATH = "res://assets/cards/neon/card_dice.png"

const NAME_CHARS_F = {
	"F_01.png": "Heather",
	"F_02.png": "Melissa",
}

const NAME_CHARS_M = {
	"M_01.png": "Jason",
	"M_02.png": "Michael",
}

const NAME_CHARS = {
	"F_01.png": "Heather",
	"F_02.png": "Melissa",
	"F_03.png": "Kimberly",
	"F_04.png": "Angela",
	"F_05.png": "Rachel",
	"F_06.png": "Lindsay",
	"F_07.png": "Kelly",
	"F_08.png": "Stacy",
	"F_09.png": "Crystal",
	"F_10.png": "Tara",
	"F_11.png": "Stephanie",
	"F_12.png": "Christy",
	"M_01.png": "Jason",
	"M_02.png": "Michael",
	"M_03.png": "Brandon",
	"M_04.png": "Kevin",
	"M_05.png": "Brian",
	"M_06.png": "Joshua",
	"M_07.png": "Justin",
	"M_08.png": "Zack",
	"M_09.png": "Travis",
	"M_10.png": "Scott",
	"M_11.png": "Corey",
	"M_12.png": "Ryan"
}

var color_type_card = {
	Globals.TypeCard.MOVE: Color.html("#29FFFF"),  # Electric Blue
	Globals.TypeCard.AMPLIFICATEUR: Color.html("#FFE600"),  # Acid Yellow
	Globals.TypeCard.MAZE: Color.html("#FF2EEC"),  # Neon Pink
	Globals.TypeCard.SCORE: Color.html("#A100FF"),  # Purple Pulse
	Globals.TypeCard.PLAYER: Color.html("#00FF9F")  # Grid Green
}
# Parameter can be set by user
var screen_effect: bool = false

var core_deck: CoreDeck = CoreDeck.new(JSON_CARD_DATABASE_PATH)
var core_player: CorePlayer = CorePlayer.new("F_06.png", core_deck.create_fake_deck())
#var core_player: CorePlayer = CorePlayer.new("F_06.png", core_deck.create_deck())

var current_maze_width: int = INITIAL_WIDTH
var current_maze_height: int = INITIAL_HEIGHT
