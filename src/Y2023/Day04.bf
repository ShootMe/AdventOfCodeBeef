using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day04 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> cards = scope .();
		input.ToLines(cards);

		int total = 0;
		int[] scorecardCounts = scope .[cards.Count];
		for (int j = 0; j < cards.Count; j++)
		{
			StringView card = cards[j];
			int winners = CountOfWinningNumbers(card);

			int current = scorecardCounts[j] + 1;
			if (winners > 0)
			{
				for (int i = 0; i < winners; i++)
				{
					scorecardCounts[i + j + 1] += current;
				}
				total += 1 << (winners - 1);
			}
		}

		int total2 = 0;
		for (int j = 0; j < scorecardCounts.Count; j++)
		{
			total2 += scorecardCounts[j] + 1;
		}

		output.Append(scope $"{total}\n{total2}");
	}
	private int CountOfWinningNumbers(StringView card)
	{
		int start = card.IndexOf(':');
		int separator = card.IndexOf('|');

		bool[] winningSet = scope .[100];
		for (StringView winner in card.Substring(start + 2, separator - start - 3).Split(' ', StringSplitOptions.RemoveEmptyEntries))
		{
			winningSet[winner.ToInt()] = true;
		}

		int match = 0;
		for (StringView winner in card.Substring(separator + 2).Split(' ', StringSplitOptions.RemoveEmptyEntries))
		{
			if (winningSet[winner.ToInt()])
			{
				match++;
			}
		}

		return match;
	}
}