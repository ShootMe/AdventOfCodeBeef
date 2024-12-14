using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day12 : IDay
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
		List<StringView> map = scope .();
		input.Parse(scope (item) => map.Add(item));
		int height = map.Count, width = map[0].Length;

		Queue<Vector2> open = new .();
		defer delete open;

		char8 NextPlant()
		{
			for (int y = 0; y < height; y++)
			{
				for (int x = 0; x < width; x++)
				{
					char8 value = map[y][x];
					if (value > 'Z') { continue; }
					open.Add(.(x, y));
					map[y][x] += 0x30;
					return value;
				}
			}
			return '.';
		}

		int total1 = 0, total2 = 0;
		char8 plant = '\0';
		while (plant != '.')
		{
			int AddNext(int x, int y)
			{
				if (x < 0 || x >= width || y < 0 || y >= height) { return 0; }
				char8 m = map[y][x];
				if (m != plant)
				{
					if (m == plant + 0x30) { return 1; }
					return 0;
				}
				open.Add(.(x, y));
				map[y][x] += 0x30;
				return 1;
			}
			bool GetValue(int x, int y)
			{
				if (x < 0 || x >= width || y < 0 || y >= height) { return false; }
				char8 m = map[y][x];
				return m == plant || m == plant + 0x30;
			}

			plant = NextPlant();
			int area = 0, perimeter = 0, sides = 0;
			while (open.Count > 0)
			{
				Vector2 pos = open.PopFront();

				int left = AddNext(pos.X - 1, pos.Y);
				int right = AddNext(pos.X + 1, pos.Y);
				int top = AddNext(pos.X, pos.Y - 1);
				int bottom = AddNext(pos.X, pos.Y + 1);

				bool addedLeft = left == 1;
				bool addedRight = right == 1;
				bool addedTop = top == 1;
				bool addedBottom = bottom == 1;

				bool leftTop = GetValue(pos.X - 1, pos.Y - 1);
				bool rightTop = GetValue(pos.X + 1, pos.Y - 1);
				bool leftBottom = GetValue(pos.X - 1, pos.Y + 1);
				bool rightBottom = GetValue(pos.X + 1, pos.Y + 1);

				area++;
				perimeter += 4 - left - right - top - bottom;
				if ((!addedLeft && !addedTop) || (addedLeft && addedTop && !leftTop)) { sides++; }
				if ((!addedTop && !addedRight) || (addedTop && addedRight && !rightTop)) { sides++; }
				if ((!addedRight && !addedBottom) || (addedRight && addedBottom && !rightBottom)) { sides++; }
				if ((!addedBottom && !addedLeft) || (addedBottom && addedLeft && !leftBottom)) { sides++; }
			}
			total1 += area * perimeter;
			total2 += area * sides;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}