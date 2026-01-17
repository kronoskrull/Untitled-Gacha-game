extends Resource
class_name eventUtils


# Event effects appear in the array referencing the index of the effect. This index
# relates to both obtainables and space effects (Coinsurance, Double Negative, etc.).
# Because of this, all applicable effects are consolidated into one referencable list.
# The effects referenced by index are in order as follows beginning with 0:

# Lucky Break, Negative Negation, Bank Error, Scot-Free, Coinsurance, Double Negative

# CRITICAL: Because of the various space effects, there needs to be a priority when
# determining the order of effects if many are stacked, such as Lucky Breaj and Bank
# Error giving differing amounts of coins depending on the order. In this way, conditions
# should be applied according to this priority:

# 0 if the effect gains coins
# 1 if the space is negative
# 4 if the space is negative and loses you coins
# 3 if the space is negative
#----------------
# 999 for the effect
#----------------
# 2 if the effects gains/loses coins
# 5 if the effect is negative

# Obviously as new effects are added this priority will need to be adjusted to accommodate.

## Applies event effects with a specific priority
@export var eventID: Dictionary = {
	"Penny Pincher": [0, 999, 2],
	"Cash Bonus": [0, 999, 2],
	"Extra Credit": [0, 999, 2],
	"A Minor Inconvenience": [1, 4, 3, 999, 2, 5],
	"Taxes and.. What Else?": [1, 4, 3, 999, 2, 5],
	"Defecit Spending": [1, 4, 3, 999, 2, 5],
	"Coinsurance": [999],
	"Investment Opportunity: Positive": [0, 999, 2],
	"Savings Account I": [999],
	"Savings Account II": [999],
	"Delayed Detriment": [1, 3, 999],
	"Investment Opportunity: Negative": [1, 4, 3, 999, 2, 5],
	"Double Negative": [1, 999],
	"Sellout": [0, 999, 2],
	"Winfall": [0, 999, 2],
	"Money Trail": [999],
	"Art Of The Deal": [1, 4, 3, 999, 2, 5],
	"Highway Robbery": [1, 3, 999],
	"ENRICHMENT MODULE": [],
}
