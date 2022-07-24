module main

import arrays {sum}
import os

const (
	max_hand_value = 21
	deal_minimum_value = 17
	nsuites = 4
	nthreads = 4
)

fn main() {
	if os.args.len != 2 {
		println("Usage: ${os.base(os.args[0])} <number of rounds>")
		exit(0)
	}
	
	nrounds := os.args[1].int()
	mut threads := []thread SimResult{}
	for _ in 0..nthreads {
		threads << go simulate(nrounds/nthreads)
	}
	r := sum(threads.wait()) or {panic(err)}
	println(r)
}

enum Result { win lose tie }

struct SimResult {
	wins int 
	loses int
	ties int
}

fn (a SimResult) + (b SimResult) SimResult {
	return SimResult{a.wins + b.wins, a.loses + b.loses, a.ties + b.ties}
}

fn simulate(rounds int) SimResult {
	mut deck := make_deck()
	deck.shuffle_cards()
	mut pl   := Player{}
	mut dl   := Player{}

	mut wins  := 0
	mut loses := 0
	mut ties  := 0

	deal_card(mut deck, mut pl) or {panic(err)}
	deal_card(mut deck, mut dl) or {panic(err)}
	
	deal_card(mut deck, mut pl) or {panic(err)}
	deal_card(mut deck, mut dl) or {panic(err)}
	
	for _ in 1..rounds+1 {
		if deck.len == 0 {
			// println("Reshuffling deck...")
			deck = make_deck()
			deck.shuffle_cards()
		}
		// println("Round: $round")
		dealer_play(mut deck, mut deck, mut pl) or {continue}
		dealer_play(mut deck, mut deck, mut dl) or {continue}

		r := round_result(dl, pl)
		match r {
			.tie  {ties += 1}
			.win  {wins += 1}
			.lose {loses += 1}
		}
		
		// println("Player got a score of ${pl.value()}")
		// println("Dealer got a score of ${dl.value()}")
		
		pl.discard_cards()
		dl.discard_cards()
	}
	return SimResult{wins, loses, ties}
}
