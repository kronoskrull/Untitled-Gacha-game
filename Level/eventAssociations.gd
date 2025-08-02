extends Resource
class_name eventInfo


# Event effects appear in the array referencing the index of the effect. This index
# relates to both obtainables and space effects (Coinsurance, Double Negative, etc.).
# Because of this, all applicable effects are consolidated into one referencable list.
# The effects referenced by index are as follows beginning with 0:

# Leg Day, Lucky break, Negative Negation, Leg Day+, Bank Error, Leg Day++,
# Scot-Free, Coinsurance, Double Negative

var eventID: Dictionary = {
	"(0, 0)": [1, 4],
	"(0, 1)": [1, 4],
	"(0, 2)": [1, 4],
	"(0, 3)": [2, 6, 7, 4, 8],
	"(0, 4)": [2, 6, 7, 4, 8],
	"(0, 5)": [2, 6, 7, 4, 8],
	"(1, 0)": [],
	"(1, 1)": [1, 4],
	"(1, 2)": [],
	"(1, 3)": [2, 6],
	"(1, 4)": [2, 6, 7, 4, 8],
	"(1, 5)": [2],
	"(2, 0)": [1, 4],
	"(2, 1)": [1, 4],
	"(2, 2)": [],
	"(2, 3)": [2, 6, 7, 4, 8],
	"(2, 4)": [],
	"(2, 5)": [],
}
