using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day11 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> space = scope .();
		input.ToLines(space);

		List<Galaxy> galaxies = scope .();
		int height = space.Count;
		int width = space[0].Length;
		{
			HashSet<int> rowsFilled = scope .();
			HashSet<int> colsFilled = scope .();
			for (int j = 0; j < height; j++)
			{
				StringView line = space[j];
				for (int i = 0; i < width; i++)
				{
					char8 c = line[i];
					if (c == '#')
					{
						rowsFilled.Add(j);
						colsFilled.Add(i);
						galaxies.Add(.() { ID = galaxies.Count + 1, X = i, Y = j });
					}
				}
			}

			for (int j = height - 1; j >= 0; j--)
			{
				if (rowsFilled.Contains(j)) { continue; }
				for (int i = 0; i < galaxies.Count; i++)
				{
					ref Galaxy galaxy = ref galaxies[i];
					if (galaxy.Y > j)
					{
						galaxy.EY++;
					}
				}
			}

			for (int j = width - 1; j >= 0; j--)
			{
				if (colsFilled.Contains(j)) { continue; }
				for (int i = 0; i < galaxies.Count; i++)
				{
					ref Galaxy galaxy = ref galaxies[i];
					if (galaxy.X > j)
					{
						galaxy.EX++;
					}
				}
			}
		}

		int total1 = 0;
		int total2 = 0;
		for (int i = 0; i < galaxies.Count; i++)
		{
			Galaxy galaxy1 = galaxies[i];
			for (int j = i + 1; j < galaxies.Count; j++)
			{
				Galaxy galaxy2 = galaxies[j];
				total1 += Math.Abs(galaxy1.GetX() - galaxy2.GetX()) + Math.Abs(galaxy1.GetY() - galaxy2.GetY());
				total2 += Math.Abs(galaxy1.GetX(1000000) - galaxy2.GetX(1000000)) + Math.Abs(galaxy1.GetY(1000000) - galaxy2.GetY(1000000));
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private struct Galaxy
	{
		public int ID, X, Y, EX, EY;
		public int GetX(int expansions = 2) { return X + EX * (expansions - 1); }
		public int GetY(int expansions = 2) { return Y + EY * (expansions - 1); }
	}
}