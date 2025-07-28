extends Node2D
class_name spinTables

var commonObMaxIndex: int = 2
var rareObMaxIndex: int = 5
var ultraObMaxIndex: int = 8

var spinOpTable: Array = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
]

var masterObtainableTable: Array = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8
]

var masterObtainablesList: Dictionary = {
	0: "got +1 to each roll!",
	1: "1 in 10 chance to move an extra space when rolling!",
	2: "reroll every other rolled 0!",
	3: "+2 to every roll!",
	4: "corners don't count as a movement!",
	5: "1 in 25 chance to negate a negative space effect!",
	6: "got +3 to every roll!",
	7: "1 in 20 chance for spin being free or double price!",
	8: "pay 10 coins to negate a negative space effect",
}
