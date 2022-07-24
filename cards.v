module main

import arrays {sum}
import rand {shuffle}

enum Honor { jack king queen ace }
type Card = int | Honor

fn value(c Card) int {
	match c {
		int { return c }
		Honor { return c.value()}
	}
}

fn (h Honor) value() int {
	match h {
		.ace {return 11}
		else {return 10}
	}
}

fn count_aces(hand []Card) int {
	mut total := 0
	for c in hand {
		if c == Card(Honor.ace) {total += 1}
	}
	return total
}

fn (hand []Card) value() int {
	return sum(hand.map(value(it))) or {return 0}
}

fn (hand []Card) best_value() int {
	mut total := hand.value()
	naces := count_aces(hand)
	for _ in 1..naces {
		if total <= max_hand_value {return total}
		total -= value(Honor.ace) - 1
	}
	return total
}

fn is_bust(hand []Card) bool {
	return hand.best_value() > max_hand_value
}

fn make_deck() []Card {
	mut deck := []Card{}
	hs := [Honor.jack, Honor.queen, Honor.king, Honor.ace]

	for _ in 0..nsuites {
		for num in 2..11 {deck << num}
		for h in hs {deck << h}
	}
	return deck
}

fn (mut cs []Card) shuffle_cards() {
	shuffle(mut cs) or {panic(err)}
}
