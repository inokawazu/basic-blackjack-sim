struct Player {
	mut:
		hand []Card
}

fn (pl Player) is_bust() bool {
	return is_bust(pl.hand)
}

fn (pl Player) value() int {
	return pl.hand.best_value()
}

fn (mut pl Player) discard_cards() {
	for _ in 0..pl.hand.len {
		pl.hand.delete_last()
	}
}

fn round_result(dl Player, pl Player) Result {
	if pl.is_bust() { return .lose }
	if dl.is_bust() { return .win }

	if dl.value() > pl.value() {
		return .lose
	} else if dl.value() < pl.value() {
		return .win
	} else {
		return .tie
	}
}

fn deal_card(mut deck []Card, mut p Player) ? {
	if deck.len == 0 {return error("Cannot deal another card.")}
	p.hand << deck.pop()
}

fn dealer_play(mut deck []Card, mut hand []Card, mut dl Player) ? {
	for !(dl.is_bust()) && dl.value() < deal_minimum_value {
		deal_card(mut deck, mut dl) or {return err}
	}
}
