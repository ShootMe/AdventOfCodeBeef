using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day07 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<Hand> hands = scope .();
		input.Parse(scope (item) => hands.Add(.(item)));

		int SortAndRankHands(bool useJokers)
		{
			Hand.UseJokers = useJokers;
			for (int i = 0; i < hands.Count; i++)
			{
				hands[i].DetermineType();
			}
			hands.Sort();

			int total = 0;
			for (int i = 0; i < hands.Count; i++)
			{
				total += hands[i].Amount * (i + 1);
			}
			return total;
		}

		output.Append(scope $"{SortAndRankHands(false)}\n{SortAndRankHands(true)}");
	}

	private struct Hand
	{
		public static bool UseJokers = false;
		public Card[5] Cards;
		public int Amount;
		public HandType Type;

		public this(StringView hand)
		{
			Cards = default;
			for (int i = 0; i < 5; i++)
			{
				Cards[i] = CharToCard(hand[i]);
			}

			Amount = hand.Substring(6).ToInt();
			Type = .HighCard;
		}
		private Card CharToCard(char8 c)
		{
			switch (c)
			{
				case '2': return Card.Two;
				case '3': return Card.Three;
				case '4': return Card.Four;
				case '5': return Card.Five;
				case '6': return Card.Six;
				case '7': return Card.Seven;
				case '8': return Card.Eight;
				case '9': return Card.Nine;
				case 'T': return Card.Ten;
				case 'J': return Card.Jack;
				case 'Q': return Card.Queen;
				case 'K': return Card.King;
				case 'A': return Card.Ace;
				default: return .Joker;
			}
		}

		public static int operator <=>(Hand left, Hand right)
		{
			int comp = left.Type <=> right.Type;
			if (comp != 0) { return comp; }

			for (int i = 0; i < 5; i++)
			{
				Card leftCard = UseJokers && left.Cards[i] == Card.Jack ? Card.Joker : left.Cards[i];
				Card rightCard = UseJokers && right.Cards[i] == Card.Jack ? Card.Joker : right.Cards[i];
				comp = leftCard <=> rightCard;
				if (comp != 0) { return comp; }
			}
			return 0;
		}
		public void DetermineType() mut
		{
			uint8[] counts = scope uint8[14];
			Card[] cards = scope Card[14];
			for (int i = 0; i < 5; i++)
			{
				counts[(int)Cards[i]]++;
				cards[(int)Cards[i]] = Cards[i];
			}

			int jokerCount = UseJokers ? counts[(int)Card.Jack] : 0;
			if (jokerCount >= 4) { Type = HandType.FiveOfAKind; return; }
			if (UseJokers) { Array.Sort(counts, cards, scope (left, right) => left <=> right); }

			bool hasPair = false;
			bool hasThree = false;
			for (int i = 13; i >= 0; i--)
			{
				if (counts[i] == 0 || (UseJokers && cards[i] == Card.Jack)) { continue; }

				switch (counts[i] + jokerCount) {
					case 5: Type = HandType.FiveOfAKind; return;
					case 4: Type = HandType.FourOfAKind; return;
					case 3:
						if (hasPair) { Type = HandType.FullHouse; return; }
						hasThree = true;
						jokerCount = 0;
						break;
					case 2:
						if (hasThree) { Type = HandType.FullHouse; return; }
						if (hasPair) { Type = HandType.TwoPair; return; }
						hasPair = true;
						jokerCount = 0;
						break;
				}
			}

			if (hasPair) { Type = HandType.Pair; return; }
			if (hasThree) { Type = HandType.ThreeOfAKind; return; }
			Type = HandType.HighCard;
		}
		public override void ToString(String output)
		{
			output.Append(scope $"{Cards[0]} {Cards[1]} {Cards[2]} {Cards[3]} {Cards[4]} = {Type}");
		}
	}
	private enum HandType : uint8
	{
		HighCard,
		Pair,
		TwoPair,
		ThreeOfAKind,
		FullHouse,
		FourOfAKind,
		FiveOfAKind
	}
	private enum Card : uint8
	{
		Joker,
		Two,
		Three,
		Four,
		Five,
		Six,
		Seven,
		Eight,
		Nine,
		Ten,
		Jack,
		Queen,
		King,
		Ace
	}
}