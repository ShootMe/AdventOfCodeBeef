using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day03 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> grid = scope .();
		input.Parse(scope (item) => grid.Add(item));
		int height = grid.Count;
		int width = grid[0].Length;

		List<Part> parts = scope .();
		Dictionary<Gear, Gear> gears = scope .();

		bool HasSymbol(int startX, int endX, int y)
		{
			if (y < 0 || y >= height) { return false; }

			StringView line = grid[y];
			for (int i = startX >= 0 ? startX : 0; i < width && i <= endX; i++)
			{
				if (line[i] != '.' && (line[i] < '0' || line[i] > '9'))
				{
					return true;
				}
			}
			return false;
		}

		void UpdateGear(int startX, int endX, int y, Part part)
		{
			if (y < 0 || y >= height) { return; }

			StringView line = grid[y];
			Gear* tempValue = default;
			Gear* tempKey = default;
			for (int x = startX >= 0 ? startX : 0; x < width && x <= endX; x++)
			{
				if (line[x] != '*') { continue; }

				Gear gear = .() { X = x, Y = y };
				if (gears.TryGetRef(gear, out tempKey, out tempValue))
				{
					tempValue.AddPart(part);
				} else
				{
					gear.AddPart(part);
					gears.Add(gear, gear);
				}
			}
		}

		for (int i = 0; i < grid.Count; i++)
		{
			StringView line = grid[i];
			for (int j = 0; j < line.Length; j++)
			{
				char8 c = line[j];
				if (c >= '0' && c <= '9')
				{
					int endIndex = j + 1;
					while (endIndex < line.Length)
					{
						char8 n = line[endIndex];
						if (n < '0' || n > '9') { break; }
						endIndex++;
					}

					Part part = .();
					part.Value = line.Substring(j, endIndex - j).ToInt();
					part.Symbols = HasSymbol(j - 1, endIndex, i - 1) || HasSymbol(j - 1, endIndex, i) || HasSymbol(j - 1, endIndex, i + 1);
					UpdateGear(j - 1, endIndex, i - 1, part);
					UpdateGear(j - 1, endIndex, i, part);
					UpdateGear(j - 1, endIndex, i + 1, part);
					parts.Add(part);

					j = endIndex;
				}
			}
		}

		int total1 = 0;
		for (int i = 0; i < parts.Count; i++)
		{
			Part part = parts[i];
			if (part.Symbols)
			{
				total1 += part.Value;
			}
		}

		int total2 = 0;
		for (Gear gear in gears.Values)
		{
			if (gear.PartsCount == 2)
			{
				total2 += gear.Parts[0] * gear.Parts[1];
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private struct Part
	{
		public int Value;
		public bool Symbols = false;
		public override void ToString(String output)
		{
			output.Append(scope $"{Value}={Symbols}");
		}
	}
	private struct Gear : IHashable
	{
		public int X, Y;
		public int PartsCount;
		public int[2] Parts;
		public void AddPart(Part part) mut
		{
			if (PartsCount < 2)
			{
				Parts[PartsCount++] = part.Value;
			} else
			{
				PartsCount++;
			}
		}
		public override void ToString(String output)
		{
			output.Append(scope $"{X},{Y}");
		}
		public int GetHashCode()
		{
			return X * 9999 + Y;
		}
		public static bool operator ==(Gear left, Gear right)
		{
			return left.X == right.X && left.Y == right.Y;
		}
	}
}