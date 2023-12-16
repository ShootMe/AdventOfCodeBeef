using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day16 : IDay
{
	private uint8 width, height;
	private char8[] grid ~ delete _;
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		width = (.)lines[0].Length;
		height = (.)lines.Count;
		grid = new .[(int)height * (int)width];

		for (int y = 0, index = 0; y < height; y++)
		{
			StringView line = lines[y];
			for (int x = 0; x < width; x++)
			{
				grid[index++] = line[x];
			}
		}

		Queue<Beam> beams = scope .();
		HashSet<Beam> seen = scope .(height * width * 2);
		HashSet<Vector2> energized = scope .(height * width);
		int max1 = EnergizedTiles(.(255, 0, 1, 0), beams, seen, energized);
		int max2 = max1;
		for (uint8 y = 1; y < height; y++)
		{
			int tiles = EnergizedTiles(.(255, y, 1, 0), beams, seen, energized);
			if (tiles > max2) { max2 = tiles; }
			tiles = EnergizedTiles(.(width, y, 255, 0), beams, seen, energized);
			if (tiles > max2) { max2 = tiles; }
		}
		for (uint8 x = 0; x < width; x++)
		{
			int tiles = EnergizedTiles(.(x, 255, 0, 1), beams, seen, energized);
			if (tiles > max2) { max2 = tiles; }
			tiles = EnergizedTiles(.(x, height, 0, 255), beams, seen, energized);
			if (tiles > max2) { max2 = tiles; }
		}

		output.Append(scope $"{max1}\n{max2}");
	}
	private int EnergizedTiles(Beam start, Queue<Beam> beams, HashSet<Beam> seen, HashSet<Vector2> energized)
	{
		seen.Clear();
		energized.Clear();
		beams.Add(start);

		while (beams.Count > 0)
		{
			Beam current = beams.PopFront();
			energized.Add(current.Position);

			Beam next = current.GetNext();
			if (next.Position.X >= width || next.Position.Y >= height || !seen.Add(next)) { continue; }

			char8 position = grid[(int)next.Position.Y * width + (int)next.Position.X];
			if (position == '.' || (position == '-' && next.Direction.X != 0) || (position == '|' && next.Direction.Y != 0))
			{
				beams.Add(next);
			} else if (position == '\\')
			{
				beams.Add(.(next.Position.X, next.Position.Y, next.Direction.Y, next.Direction.X));
			} else if (position == '/')
			{
				beams.Add(.(next.Position.X, next.Position.Y, ~next.Direction.Y + 1, ~next.Direction.X + 1));
			} else if (position == '-')
			{
				beams.Add(.(next.Position.X, next.Position.Y, 255, 0));
				beams.Add(.(next.Position.X, next.Position.Y, 1, 0));
			} else if (position == '|')
			{
				beams.Add(.(next.Position.X, next.Position.Y, 0, 255));
				beams.Add(.(next.Position.X, next.Position.Y, 0, 1));
			}
		}

		return energized.Count - 1;
	}
	private struct Beam : IHashable
	{
		public Vector2 Position, Direction;
		public this(uint8 x, uint8 y, uint8 dx, uint8 dy)
		{
			Position = .(x, y);
			Direction = .(dx, dy);
		}
		public Beam GetNext() { return .(Position.X + Direction.X, Position.Y + Direction.Y, Direction.X, Direction.Y); }
		public int GetHashCode() { return (.)Position.X << 24 | (.)Position.Y << 16 | (.)Direction.X << 8 | (.)Direction.Y; }
	}
	private struct Vector2 : IHashable
	{
		public uint8 X, Y;
		public this(uint8 x, uint8 y) { X = x; Y = y; }
		public int GetHashCode() { return (.)X << 8 | (.)Y; }
	}
}