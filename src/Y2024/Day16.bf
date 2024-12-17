using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day16 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> map = scope .();
		input.Parse(scope (item) => map.Add(item));
		int height = map.Count, width = map[0].Length;

		int32[] seen = new .[height * width];
		defer delete seen;
		Internal.MemSet(&seen[0], 0xff, seen.Count * 4);

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

		Queue<(int, int, int8, int32)> open = scope .(256);
		open.Add((startX, startY, 0, 0));
		seen[startY * width + startX] = 0;

		void AddNext(int x, int y, int8 dir, int32 score)
		{
			var dir, x, y;
			if (dir < 0) { dir += 4; } else if (dir > 3) { dir -= 4; }
			switch (dir) {
				case 0: x++; break;
				case 1: y++; break;
				case 2: x--; break;
				case 3: y--; break;
			}
			if (map[y][x] == '#') { return; }

			int oldScore = seen[y * width + x];
			bool exists = oldScore >= 0;
			if (!exists || oldScore > score)
			{
				seen[y * width + x] = score;
				open.Add((x, y, dir, score));
			}
		}

		int32 minScore = int32.MaxValue;
		int8 minDir = 0;
		while (open.Count > 0)
		{
			(int x, int y, int8 dir, int32 score) = open.PopFront();

			if (map[y][x] == 'E')
			{
				if (score < minScore)
				{
					minScore = score;
					minDir = dir;
				}
				continue;
			}

			AddNext(x, y, dir, score + 1);
			AddNext(x, y, dir + 1, score + 1001);
			AddNext(x, y, dir - 1, score + 1001);
		}

		open.Add((endX, endY, minDir, minScore));

		int32[] bestPath = new .[height * width];
		defer delete bestPath;
		int bestPathCount = 0;

		void CheckPrevious(int x, int y, int8 dir, int32 score)
		{
			var dir, x, y;
			if (dir < 0) { dir += 4; } else if (dir > 3) { dir -= 4; }
			switch (dir) {
				case 0: x--; break;
				case 1: y--; break;
				case 2: x++; break;
				case 3: y++; break;
			}

			if (map[y][x] == '#') { return; }
			int oldScore = seen[y * width + x];
			bool exists = oldScore >= 0;
			if (!exists || oldScore > score) { return; }

			open.Add((x, y, dir, score));
		}

		while (open.Count > 0)
		{
			(int x, int y, int8 dir, int32 score) = open.PopFront();
			if (bestPath[y * width + x]++ > 0) { continue; }
			bestPathCount++;

			CheckPrevious(x, y, dir, score - 1);
			CheckPrevious(x, y, dir + 1, score - 1001);
			CheckPrevious(x, y, dir - 1, score - 1001);
		}

		output.Append(scope $"{minScore}\n{bestPathCount}");
	}
}