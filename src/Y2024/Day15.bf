using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day15 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> map = scope .();
		String sequence = scope .();
		bool addMap = true;
		input.Parse(scope [&] (item) =>
			{
				if (item.Length == 0)
				{
					addMap = false;
					return;
				}
				if (addMap)
				{
					map.Add(item);
					return;
				}
				sequence.Append(item);
			});

		int height = map.Count, width = map[0].Length;
		int widthWide = width * 2;
		char8[] mapWide = new .[height * widthWide];
		defer delete mapWide;

		int startX = 0, startY = 0, index = 0;
		for (int y = 0; y < height; y++)
		{
			for (int x = 0; x < width; x++)
			{
				char8 c = map[y][x];
				if (c == '@')
				{
					startX = x;
					startY = y;
					mapWide[index++] = c;
					mapWide[index++] = '.';
				} else if (c == 'O')
				{
					mapWide[index++] = '[';
					mapWide[index++] = ']';
				} else
				{
					mapWide[index++] = c;
					mapWide[index++] = c;
				}
			}
		}

		void Update(ref int x, ref int y, int dirX, int dirY)
		{
			x += dirX; y += dirY;
			if (map[y][x] == '#')
			{
				x -= dirX; y -= dirY;
				return;
			}

			if (map[y][x] != 'O')
			{
				map[y - dirY][x - dirX] = '.';
				map[y][x] = '@';
				return;
			}

			int boxX = x, boxY = y;
			repeat
			{
				boxX += dirX; boxY += dirY;
			} while (map[boxY][boxX] == 'O');

			if (map[boxY][boxX] == '.')
			{
				map[boxY][boxX] = 'O';
				map[y][x] = '@';
				map[y - dirY][x - dirX] = '.';
			} else
			{
				x -= dirX; y -= dirY;
			}
		}

		int x = startX, y = startY;
		for (int i = 0; i < sequence.Length; i++)
		{
			char8 c = sequence[i];
			switch (c) {
				case '>': Update(ref x, ref y, 1, 0); break;
				case '<': Update(ref x, ref y, -1, 0); break;
				case '^': Update(ref x, ref y, 0, -1); break;
				case 'v': Update(ref x, ref y, 0, 1); break;
			}
		}

		int total1 = 0;
		for (y = 0; y < height; y++)
		{
			for (x = 0; x < width; x++)
			{
				char8 c = map[y][x];
				if (c == 'O' || c == '[') { total1 += y * 100 + x; }
			}
		}

		List<(int, int)> boxes = new .();
		defer delete boxes;

		void UpdateWide(ref int x, ref int y, int dirX, int dirY)
		{
			bool CheckBox(int boxX, int boxY, int dirY)
			{
				var boxY;
				boxY += dirY;
				ref char8 left = ref mapWide[boxY * widthWide + boxX];
				ref char8 right = ref mapWide[boxY * widthWide + boxX + 1];
				if (left == '.' && right == '.')
				{
					boxes.Add((boxX, boxY - dirY));
					return true;
				}
				if (left == '#' || right == '#')
				{
					return false;
				}
				bool good = true;
				if (left == '[' || left == ']')
				{
					good = CheckBox(left == '[' ? boxX : boxX - 1, boxY, dirY);
				}
				if (right == '[' && good)
				{
					good = CheckBox(boxX + 1, boxY, dirY);
				}
				if (good) { boxes.Add((boxX, boxY - dirY)); }
				return good;
			}

			x += dirX; y += dirY;
			if (mapWide[y * widthWide + x] == '#')
			{
				x -= dirX; y -= dirY;
				return;
			}

			char8 boxB = mapWide[y * widthWide + x];
			if (boxB != '[' && boxB != ']')
			{
				mapWide[(y - dirY) * widthWide + x - dirX] = '.';
				mapWide[y * widthWide + x] = '@';
				return;
			}

			if (dirY == 0)
			{
				int boxX = x, boxY = y;
				repeat
				{
					boxX += dirX; boxY += dirY;
				} while (mapWide[boxY * widthWide + boxX] == '[' || mapWide[boxY * widthWide + boxX] == ']');

				if (mapWide[boxY * widthWide + boxX] != '.')
				{
					x -= dirX; y -= dirY;
					return;
				}

				while (boxX != x || boxY != y)
				{
					boxX -= dirX; boxY -= dirY;
					mapWide[(boxY + dirY) * widthWide + boxX + dirX] = mapWide[boxY * widthWide + boxX];
				}
				mapWide[y * widthWide + x] = '@';
				mapWide[(y - dirY) * widthWide + x - dirX] = '.';
			} else
			{
				boxes.Clear();
				bool good = CheckBox(boxB == '[' ? x : x - 1, y, dirY);
				if (!good)
				{
					x -= dirX; y -= dirY;
					return;
				}

				boxes.Sort(scope (left, right) =>
					{
						if (dirY < 0) { return right.1 <=> left.1; }
						return left.1 <=> right.1;
					});

				for (int i = boxes.Count - 1; i >= 0; i--)
				{
					(int boxX, int boxY) = boxes[i];
					mapWide[(boxY + dirY) * widthWide + boxX] = '[';
					mapWide[(boxY + dirY) * widthWide + boxX + 1] = ']';
					mapWide[boxY * widthWide + boxX] = '.';
					mapWide[boxY * widthWide + boxX + 1] = '.';
				}
				mapWide[y * widthWide + x] = '@';
				mapWide[(y - dirY) * widthWide + x - dirX] = '.';
			}
		}

		x = startX * 2; y = startY;
		for (int i = 0; i < sequence.Length; i++)
		{
			char8 c = sequence[i];
			switch (c) {
				case '>': UpdateWide(ref x, ref y, 1, 0); break;
				case '<': UpdateWide(ref x, ref y, -1, 0); break;
				case '^': UpdateWide(ref x, ref y, 0, -1); break;
				case 'v': UpdateWide(ref x, ref y, 0, 1); break;
			}
		}

		int total2 = 0; index = 0;
		for (y = 0; y < height; y++)
		{
			for (x = 0; x < widthWide; x++)
			{
				char8 c = mapWide[index++];
				if (c == 'O' || c == '[') { total2 += y * 100 + x; }
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}