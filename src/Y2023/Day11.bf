using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day11 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> space = scope .();
		input.Parse(scope (item) => space.Add(item));

		int height = space.Count;
		int width = space[0].Length;
		Galaxy[] galaxyCountsX = scope .[width];
		for (int x = 0; x < width; x++) { galaxyCountsX[x] = .() { Index = x }; }
		Galaxy[] galaxyCountsY = scope .[height];
		for (int y = 0; y < height; y++) { galaxyCountsY[y] = .() { Index = y }; }

		for (int y = 0; y < height; y++)
		{
			StringView line = space[y];
			for (int x = 0; x < width; x++)
			{
				char8 c = line[x];
				if (c != '#') { continue; }

				galaxyCountsY[y].Count++;
				galaxyCountsX[x].Count++;
			}
		}

		int expansions = 0;
		int galaxiesY = 0;
		for (int y = 0; y < height; y++)
		{
			if (galaxyCountsY[y].Count > 0)
			{
				galaxiesY += galaxyCountsY[y].Count;
				galaxyCountsY[y].Expansions = expansions;
				continue;
			}
			expansions++;
		}

		expansions = 0;
		int galaxiesX = 0;
		for (int x = 0; x < width; x++)
		{
			if (galaxyCountsX[x].Count > 0)
			{
				galaxiesX += galaxyCountsX[x].Count;
				galaxyCountsX[x].Expansions = expansions;
				continue;
			}
			expansions++;
		}

		int total1 = 0;
		int total2 = 0;
		for (int i = galaxyCountsX.Count - 1, j = galaxiesX - 1; i >= 0; i--)
		{
			Galaxy galaxy = galaxyCountsX[i];
			if (galaxy.Count == 0) { continue; }
			int modifier = galaxy.Count * (j - galaxy.Count + 1);
			total1 += galaxy.GetValue(2) * modifier;
			total2 += galaxy.GetValue(1000000) * modifier;
			j -= 2 * galaxy.Count;
		}

		for (int i = galaxyCountsY.Count - 1, j = galaxiesY - 1; i >= 0; i--)
		{
			Galaxy galaxy = galaxyCountsY[i];
			if (galaxy.Count == 0) { continue; }
			int modifier = galaxy.Count * (j - galaxy.Count + 1);
			total1 += galaxy.GetValue(2) * modifier;
			total2 += galaxy.GetValue(1000000) * modifier;
			j -= 2 * galaxy.Count;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private struct Galaxy
	{
		public int Index, Count, Expansions;
		public int GetValue(int expansions) { return Index + Expansions * (expansions - 1); }
	}
}