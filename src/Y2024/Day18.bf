using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day18 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> bytes = scope .(30);
		input.ExtractInts(bytes);

		char8[73][73] grid = default;
		for (int i = 0; i < 73; i++)
		{
			grid[0][i] = '#';
			grid[72][i] = '#';
			grid[i][0] = '#';
			grid[i][72] = '#';
		}

		for (int i = 0; i < 2048; i += 2)
		{
			grid[bytes[i + 1] + 1][bytes[i] + 1] = '#';
		}

		HashSet<int> seen = scope .();
		Queue<(int, int, int)> open = scope .();

		int Solve()
		{
			seen.Clear();
			open.Clear();

			void AddNext(int x, int y, int steps)
			{
				char8 m = grid[y][x];
				if (m == '#' || !seen.Add(y * 127 + x)) { return; }
				open.Add((x, y, steps));
			}

			open.Add((1, 1, 0));
			while (open.Count > 0)
			{
				(int x, int y, int steps) = open.PopFront();
				if (x == 71 && y == 71)
				{
					return steps;
				}

				AddNext(x + 1, y, steps + 1);
				AddNext(x - 1, y, steps + 1);
				AddNext(x, y + 1, steps + 1);
				AddNext(x, y - 1, steps + 1);
			}
			return 0;
		}

		int Search(int start, int end)
		{
			if (start == end) { return start; }
			int mid = (start + end) / 2;
			mid += mid & 1;
			for (int i = mid; i <= end; i += 2)
			{
				grid[bytes[i + 1] + 1][bytes[i] + 1] = '\0';
			}
			for (int i = start; i < mid; i += 2)
			{
				grid[bytes[i + 1] + 1][bytes[i] + 1] = '#';
			}
			if (Solve() == 0)
			{
				return Search(start, mid - 2);
			}
			return Search(mid, end);
		}

		int steps = Solve();
		int index = Search(2048, bytes.Count - 2);
		output.Append(scope $"{steps}\n{bytes[index]},{bytes[index + 1]}");
	}
}