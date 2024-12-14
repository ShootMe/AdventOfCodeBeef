using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day06 : IDay
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
	private struct Vector4 : IHashable
	{
		public int X, Y, DX, DY;
		public int GetHashCode() => HashCode.Generate(this);
		public this(int x, int y, int dx, int dy)
		{
			X = x; Y = y; DX = dx; DY = dy;
		}
	}
	public void Solve(StringView input, String output)
	{
		List<StringView> grid = scope .();
		input.Parse(scope (item) => grid.Add(item));

		int height = grid.Count, width = grid[0].Length;
		int startX = -1, startY = -1;
		for (int y = 0; y < height; y++)
		{
			StringView line = grid[y];
			for (int x = 0; x < width; x++)
			{
				char8 c = line[x];
				if (c == '^')
				{
					startX = x;
					startY = y;
				}
			}
		}

		HashSet<Vector4> seenDir = scope .();
		Dictionary<Vector2, Vector2> seenArea = scope .();

		seenArea.Add(.(startX, startY), .(0, -1));

		bool PatrolArea(int sX, int sY, int dirX, int dirY, int nX, int nY, bool addNew)
		{
			var dirX, dirY;
			int x = sX, y = sY;
			seenDir.Clear();
			while (true)
			{
				int newX = x + dirX;
				int newY = y + dirY;
				if (newX < 0 || newX >= width || newY < 0 || newY >= height)
				{
					return false;
				} else if (grid[newY][newX] == '#' || (newX == nX && newY == nY))
				{
					if (!seenDir.Add(.(x, y, dirX, dirY)))
					{
						return true;
					}
					int tempDir = dirX;
					dirX = -dirY;
					dirY = tempDir;
					continue;
				}

				x = newX; y = newY;
				if (addNew) { seenArea.TryAdd(.(x, y), .(dirX, dirY)); }
			}
		}

		PatrolArea(startX, startY, 0, -1, -1, -1, true);

		int total1 = seenArea.Count, total2 = 0;

		seenArea.Remove(Vector2(startX, startY));
		for (var pair in seenArea)
		{
			int x = pair.key.X - pair.value.X;
			int y = pair.key.Y - pair.value.Y;
			bool isLoop = PatrolArea(x, y, -pair.value.Y, pair.value.X, pair.key.X, pair.key.Y, false);
			if (isLoop)
			{
				total2++;
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}