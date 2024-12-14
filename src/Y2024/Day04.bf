using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day04 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> xmas = scope .();
		input.Parse(scope (item) => xmas.Add(item));
		int height = xmas.Count, width = xmas[0].Length;

		int CountXMAS(int x, int y)
		{
			return IsXMAS(x, y, -1, -1) + IsXMAS(x, y, 0, -1) + IsXMAS(x, y, 1, -1) +
				IsXMAS(x, y, -1, 0) + IsXMAS(x, y, 1, 0) +
				IsXMAS(x, y, -1, 1) + IsXMAS(x, y, 0, 1) + IsXMAS(x, y, 1, 1);
		}
		int IsXMAS(int x, int y, int xd, int yd)
		{
			if (y + 3 * yd < 0 || y + 3 * yd >= height) { return 0; }
			if (x + 3 * xd < 0 || x + 3 * xd >= width) { return 0; }

			return xmas[y + yd][x + xd] == 'M' && xmas[y + 2 * yd][x + 2 * xd] == 'A' && xmas[y + 3 * yd][x + 3 * xd] == 'S' ? 1 : 0;
		}
		int CountX_MAS(int x, int y)
		{
			if (y - 1 < 0 || y + 1 >= height) { return 0; }
			if (x - 1 < 0 || x + 1 >= width) { return 0; }

			return ((xmas[y - 1][x - 1] == 'M' && xmas[y + 1][x + 1] == 'S') || (xmas[y - 1][x - 1] == 'S' && xmas[y + 1][x + 1] == 'M')) &&
				((xmas[y - 1][x + 1] == 'M' && xmas[y + 1][x - 1] == 'S') || (xmas[y - 1][x + 1] == 'S' && xmas[y + 1][x - 1] == 'M')) ? 1 : 0;
		}

		int total1 = 0, total2 = 0;
		for (int y = 0; y < height; y++)
		{
			StringView line = xmas[y];
			for (int x = 0; x < width; x++)
			{
				char8 c = line[x];
				if (c == 'X')
				{
					total1 += CountXMAS(x, y);
				} else if (c == 'A')
				{
					total2 += CountX_MAS(x, y);
				}
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}