using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day20 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> map = scope .();
		input.Parse(scope (item) => map.Add(item));
		int height = map.Count, width = map[0].Length;

		int startX = 0, startY = 0, endX = 0, endY = 0;
		for (int y = 0; y < height; y++)
		{
			StringView line = map[y];
			for (int x = 0; x < width; x++)
			{
				char8 c = line[x];
				if (c == 'S')
				{
					startX = x; startY = y;
				} else if (c == 'E')
				{
					endX = x; endY = y;
				}
			}
		}

		List<(int, int)> path = new .();
		defer delete path;
		(int x, int y) current = default;

		bool AddNext(int x, int y)
		{
			if (map[y][x] == '#') { return false; }
			current = (x, y);
			path.Add(current);
			map[y][x] = '#';
			return true;
		}

		AddNext(startX, startY);

		while (AddNext(current.x + 1, current.y) ||
			AddNext(current.x, current.y + 1) ||
			AddNext(current.x - 1, current.y) ||
			AddNext(current.x, current.y - 1))
		{
			if (current == (endX, endY)) { break; }
		}

		int CountWays(int cheatMax, int saved)
		{
			int total = 0;
			for (int p1 = 0; p1 < path.Count - saved; p1++)
			{
				(int x1, int y1) = path[p1];

				for (int p2 = p1 + saved; p2 < path.Count;)
				{
					(int x2, int y2) = path[p2];
					int distance = Math.Abs(x2 - x1) + Math.Abs(y2 - y1);

					if (distance > cheatMax)
					{
						p2 += distance - cheatMax;
						continue;
					}

					if ((p2 - p1 - distance) >= saved) { total++; }
					p2++;
				}
			}
			return total;
		}

		output.Append(scope $"{CountWays(2, path.Count > 100 ? 100 : 2)}\n{CountWays(20, path.Count > 100 ? 100 : 50)}");
	}
}