using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day10 : IDay
{
	private struct Vector2 : IHashable
	{
		public int X, Y;
		public int GetHashCode() => HashCode.Generate(this);
		public this(int x, int y)
		{
			X = x; Y = y;
		}
	}
	public void Solve(StringView input, String output)
	{
		List<StringView> grid = scope .();
		input.ToLines(grid);
		int height = grid.Count, width = grid[0].Length;

		HashSet<Vector2> seen = new .();
		defer delete seen;
		Queue<Vector2> open = new .();
		defer delete open;

		int FindTrailHeadScore(int x, int y, bool allowAll = false)
		{
			seen.Clear();
			open.Add(.(x, y));

			void AddNext(int x, int y, char8 next)
			{
				if (x < 0 || x >= width || y < 0 || y >= height || grid[y][x] != next || (!allowAll && !seen.Add(.(x, y)))) { return; }
				open.Add(.(x, y));
			}

			int total = 0;
			while (open.Count > 0)
			{
				Vector2 current = open.PopFront();
				char8 value = grid[current.Y][current.X] + 1;
				if (value == ':')
				{
					total++;
					continue;
				}

				AddNext(current.X - 1, current.Y, value);
				AddNext(current.X + 1, current.Y, value);
				AddNext(current.X, current.Y - 1, value);
				AddNext(current.X, current.Y + 1, value);
			}
			return total;
		}

		int total1 = 0, total2 = 0;
		for (int y = 0; y < height; y++)
		{
			StringView line = grid[y];
			for (int x = 0; x < width; x++)
			{
				char8 c = line[x];
				if (c != '0') { continue; }
				total1 += FindTrailHeadScore(x, y);
				total2 += FindTrailHeadScore(x, y, true);
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}