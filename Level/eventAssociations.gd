extends Resource
class_name eventUtils


# Event effects appear in the array referencing the index of the effect. This index
# relates to both obtainables and space effects (Coinsurance, Double Negative, etc.).
# Because of this, all applicable effects are consolidated into one referencable list.
# The effects referenced by index are as follows beginning with 0:

# Lucky break, Negative Negation, Bank Error, Scot-Free, Coinsurance, Double Negative

@export var eventID: Dictionary = {
	"(0, 0)": [0, 999, 2],
	"(0, 1)": [0, 999, 2],
	"(0, 2)": [0, 999, 2],
	"(0, 3)": [1, 4, 3, 999, 2, 5],
	"(0, 4)": [1, 4, 3, 999, 2, 5],
	"(0, 5)": [1, 4, 3, 999, 2, 5],
	"(1, 0)": [999],
	"(1, 1)": [0, 999, 2],
	"(1, 2)": [999],
	"(1, 3)": [1, 3, 999],
	"(1, 4)": [1, 4, 3, 999, 2, 5],
	"(1, 5)": [1, 999],
	"(2, 0)": [0, 999, 2],
	"(2, 1)": [0, 999, 2],
	"(2, 2)": [999],
	"(2, 3)": [1, 4, 3, 999, 2, 5],
	"(2, 4)": [1, 3, 999],
	"(2, 5)": [],
}
