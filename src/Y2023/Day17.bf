using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day17 : IDay
{
	private int width, height;
	private uint8[,] grid ~ delete _;
	public void Solve(StringView input, String output)
	{
		ParseInput(input);
		output.Append(scope $"{FindLowestHeatLoss(false)}\n{FindLowestHeatLoss(true)}");
	}
	private void ParseInput(StringView input)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		width = (.)lines[0].Length;
		height = (.)lines.Count;
		grid = new .[(int)height, (int)width];

		for (int y = 0; y < height; y++)
		{
			StringView line = lines[y];
			for (int x = 0; x < width; x++)
			{
				grid[y, x] = (.)(line[x] - '0');
			}
		}
	}
	private int FindLowestHeatLoss(bool ultra)
	{
		Heap<Crucible> open = scope .(width * height);
		HashSet<Crucible> closed = scope .(width * height * 50);

		void TryAdd(Crucible next)
		{
			var next;
			if (next.X < 0 || next.Y < 0 || next.X >= width || next.Y >= height) { return; }

			next.Loss += grid[next.Y, next.X];
			if (closed.Add(next))
			{
				open.Add(next);
			}
		}

		open.Add(.() { X = 0, Y = 0, Dir = 0, Count = 0, Loss = 0 });
		open.Add(.() { X = 0, Y = 0, Dir = 1, Count = 0, Loss = 0 });

		while (open.Count > 0)
		{
			Crucible current = open.Pop();
			if (current.X == width - 1 && current.Y == height - 1)
			{
				return current.Loss;
			}

			if (current.Count < 3 || (ultra && current.Count < 10))
			{
				Crucible next = current.NextStraight();
				TryAdd(next);
			}

			if (!ultra || current.Count >= 4)
			{
				Crucible nextRight = current.NextRight();
				TryAdd(nextRight);

				Crucible nextLeft = current.NextLeft();
				TryAdd(nextLeft);
			}
		}
		return 0;
	}
	private struct Crucible : IHashable
	{
		private const int16[4] DirX = .(1, 0, -1, 0);
		private const int16[4] DirY = .(0, 1, 0, -1);

		public int16 X, Y, Dir, Count, Loss;
		public Crucible NextStraight()
		{
			Crucible next = this;
			next.X += DirX[Dir];
			next.Y += DirY[Dir];
			next.Count++;
			return next;
		}
		public Crucible NextRight()
		{
			Crucible next = this;
			next.Dir = (next.Dir + 1) & 3;
			next.X += DirX[next.Dir];
			next.Y += DirY[next.Dir];
			next.Count = 1;
			return next;
		}
		public Crucible NextLeft()
		{
			Crucible next = this;
			next.Dir = (next.Dir - 1) & 3;
			next.X += DirX[next.Dir];
			next.Y += DirY[next.Dir];
			next.Count = 1;
			return next;
		}
		public static int operator <=>(Crucible left, Crucible right)
		{
			return left.Loss <=> right.Loss;
		}
		public static bool operator ==(Crucible left, Crucible right)
		{
			return left.X == right.X && left.Y == right.Y && left.Dir == right.Dir && left.Count == right.Count;
		}
		public int GetHashCode() { return ((int)X << 14) | ((int)Y << 6) | ((int)Dir << 4) | (int)Count; }
	}
}