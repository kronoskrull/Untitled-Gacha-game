
## Dictionary for obtainable items
const COMMON := [ #name, event text array, effect text, positive/negative
	[
		"Penny Pincher",
		[
			"You find a lonesome coin in the desolate maze. Better than nothing, right?",
			"A corpse lies here, with a single shining coin in its rotting hand. You take it anyway, better yours than his.",
			"You find a suitcase full of money! Suddenly, an IRS agent rounds the corner and takes away taxes, leaving only a single shining coin. Bummer."
		],
		"Gain 1 coin",
		"positive"
	],
	
	[
		"Cash Bonus",
		[
			"A few coins are strewn on the ground here. A nice haul in such an empty place.",
			"An owl flies in from above, dropping an envelope with your name on it - it's your royalties for your mixtape!",
			"While digging through your pockets, you find some coins mixed with a wad of old gum. You've won, but at what cost?"
		],
		"Gain 2 Coins",
		"positive"
	],
	
	[
		"Extra Credit",
		[
			"An albatross swoops through and drops a letter from grandma - it's a birthday card! If only it wasn't 6 months late...",
			"You stumble across a skeleton clutching a gold necklace. Were you above grave robbing, it might have stayed that way...",
			"You found a suitcase full of money! Suddenly, an IRS agent rounds the corner to take away taxes. You beat him to death before he can. Take that, taxes!"
		],
		"Gain 3 coins",
		"positive"
	],
	
	[
		"A Minor Inconvenience",
		[
			"While admiring your coinage, you fumble your bag and drop one into the conveniently placed sewer grate. Way to go.",
			"Digging through your pockets, you find a hole through which a coin falls into a conveniently placed vat of acid you didn't realize was there. Nice job.",
			"Trumpets bellow from above - The Rapture has come!... for your wallet. Even God needs a buck sometimes."
		],
		"Lose 1 coin",
		"negative"
	],
	
	[
		"Taxes and.. What Else?",
		[
			"A pelican flies through, dropping your credit card bill. Even here, there is no escape.",
			"An emu accosts you. You throw a handful of your shiniest coins to distract it and make your escape.",
			"A passing seagull shits on your nicest shirt. Luckily, the dry cleaners is just ahead."
		],
		"Lose 2 coins",
		"negative"
	],
	
	[
		"Defecit Spending",
		[
			"You discover crypto currency. Surely this will turn out well!",
			"Passing by an arcade, you discover the hard way how bad you are at claw machines.",
			"A brand new [insert fad here] is your new favorite thing! You waste a shit ton of money on it and never touch it again."
		],
		"Lose 3 coins",
		"negative"
	],
	
]

const RARE := [
	[
		"Coinsurance",
		[
			"Who said wallet chains are out of style?",
			"That quarter of your paycheck is finally paying off!",
			"Nothing protects your personal space (and your wallet) better than a gun!"
		],
		"Can't lose coins the next time you would",
		"positive"
	],
	
	[
		"Investment Opportunity: Positive",
		[
			"You check your $HITCOIN wallet...",
			"You invested in an indie gacha game for a game jam, and somehow it wasn't half bad.",
			"You bought 10 shares in 'Bubba's Bathtub Moonshine'."
		],
		"Gain 6 coins",
		"positive"
	],
	
	#[ Saving Account NOTE needs to be disabled until it plays nice with the new system - 12/10
		#"Savings Account I",
		#[
			#"Investing in victory...",
			#"A shady banker, a cardboard desk, and a painted sign... surely this pays off!",
			#"Now, I know it sounds crazy, but i swear leaving your money under this conspicuously placed rock makes it magically double!"
		#],
		#"Lose up to 5 coins now, for a positive bonus later...",
		#"unique"
	#],
	#
	#[
		#"Savings Accout II",
		#[
			#"... means playing the long game!",
			#"Who said banks couldn't be trusted?",
			#"Surely you'll put this money to good use, right?"
		#],
		#"Gain double the coins you saved before!",
		#"positive"
	#],
	
	[
		"Delayed Detriment",
		[
			"Unbeknownst to you, a hole magically appears in your wallet...",
			"Maybe Flex Seal isn't all it's cracked up to be...",
			"Well if you don't like it, maybe you shouldn't have picked a road with so many tolls!"
		],
		"Lose a coin for every other space you move on the next spin",
		"negative"
	],
	
	[
		"Investment Opportunity: Negative",
		[
			"You check your $HITCOIN wallet...",
			"Seems like your scam call center was more work than that Nigerian prince made it out to be...",
			"You invested in a pyramid scheme. How could you have known they were actually building a pyramid?"
		],
		"Lose 6 Coins",
		"negative"
	],
	
	[
		"Double Negative",
		[
			"A black cat under a ladder and a broken mirror... SURELY that can only mean good things.",
			"You step on a crack. It's in God's hands now.",
			"You felt your sins crawling on your back."
		],
		"1 in 3 chance to double the next negative effect",
		"negative"
	]
	
]

const ULTRA := [
	[
		"Sellout",
		[
			"You give in to temptation and start promoting dropshipping outlets. Shame on you.",
			"Who knew being a corporate yes-man could be so fulfilling?",
			"You start working for EA. There is no redeeming factor to this."
		],
		"Duplicate your coins, at the cost of your dignity",
		"positive"
	],
	
	[
		"Winfall",
		[
			"Stairs: 1, Grandma: 0. At least you're in the will.",
			"Insurance fraud never felt so good.",
			"In retrospect, we've always been friends, right?"
		],
		"Gain 10 coins",
		"positive"
	],
	
	[
		"Money Trail",
		[
			"A trail of gold coins NEVER leads anywhere bad, right?",
			"Ooh, piece of candy... ooh, piece of candy...",
			"If I told you where leprachauns got their gold from, you'd never want it again."
		],
		"Gain a coin for every space you move on the next spin",
		"positive"
	],
	
	[
		"Art Of The Deal",
		[
			"This is why I signed a prenup.",
			"Nobody escapes the IRS.",
			"Investing in NFT's REALLY didn't pay off."
		],
		"Lose half your coins",
		"negative"
	],
	
	[
		"Highway Robbery",
		[
			"Go this way, you said. There's less tolls here, you said. This is what you get for using Mapquest.",
			"A blue-footed booby flies through and drops an envelope with an extensive record of your search history. You agree to his blackmail immediately.",
			"When I said that they'd 'garnish your bread', I wasn't talking about food."
		],
		"Lose a coin for every space you move on your next spin",
		"negative"
	],
	
	[
		"ENRICHMENT MODULE",
		[
			"Please enjoy the ENRICHMENT MODULE!",
			"Thank you for your voluntary participation in the human trials of the ENRICHMENT MODULE!",
			"ENRICHMENT MODULE!"
		],
		"100% chance of increased enrichment! (not a peer reviewed statistic)",
		"unique"
	]
	
]
