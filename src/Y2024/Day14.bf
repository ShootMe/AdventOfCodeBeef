using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day14 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> robots = scope .(2000);
		input.ExtractInts(robots);

		for (int j = 0; j < 100; j++)
		{
			for (int i = 0; i < robots.Count; i += 4)
			{
				robots[i] += robots[i + 2]; robots[i + 1] += robots[i + 3];
			}
		}

		int maxX = robots.Count < 80 ? 11 : 101, maxY = robots.Count < 80 ? 7 : 103;
		int total1 = 0, total2 = 0, total3 = 0, total4 = 0;
		for (int i = 0; i < robots.Count; i += 4)
		{
			ref int x = ref robots[i]; ref int y = ref robots[i + 1];
			x %= maxX; y %= maxY;
			if (x < 0) { x += maxX; } if (y < 0) { y += maxY; }

			if (x > maxX / 2 && y < maxY / 2) { total1++; }
			if (x > maxX / 2 && y > maxY / 2) { total2++; }
			if (x < maxX / 2 && y < maxY / 2) { total4++; }
			if (x < maxX / 2 && y > maxY / 2) { total3++; }
		}

		HashSet<int> pos = new .(robots.Count);
		defer delete pos;

		int seconds = 100;
		while (true)
		{
			pos.Clear();
			seconds++;
			for (int i = 0; i < robots.Count; i += 4)
			{
				ref int x = ref robots[i]; ref int y = ref robots[i + 1];
				x += robots[i + 2]; y += robots[i + 3];
				if (x < 0) { x += maxX; } else if (x >= maxX) { x -= maxX; }
				if (y < 0) { y += maxY; } else if (y >= maxY) { y -= maxY; }
				pos.Add((x << 32) | y);
			}

			if (pos.Count == robots.Count / 4)
			{
				output.Append(scope $"{total1 * total2 * total3 * total4}\n{seconds}");
				break;
			}
		}
	}
}