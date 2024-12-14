using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day10 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> grid = scope .();
		input.Parse(scope (item) => grid.Add(item));

		int width = grid[0].Length;
		int height = grid.Count;
		Node start = default;
		void FindStart()
		{
			for (int y = 0; y < height; y++)
			{
				StringView row = grid[y];
				for (int x = 0; x < width; x++)
				{
					char8 c = row[x];
					if (c == 'S')
					{
						start = .(x, y) { Value = 'S' };
						return;
					}
				}
			}
		}
		FindStart();

		Node[] positions = scope .[15000];
		HashSet<Node> seen = scope .(15000);
		int length = 0;
		positions[length] = start;

		while (true)
		{
			Node current = positions[length];
			Node next = .(current.X - 1, current.Y);
			if (next.X >= 0)
			{
				next.Value = grid[next.Y][next.X];
				if (ValidToW(current, next) && seen.Add(next)) { positions[++length] = next; continue; }
			}

			next = .(current.X + 1, current.Y);
			if (next.X < width)
			{
				next.Value = grid[next.Y][next.X];
				if (ValidToE(current, next) && seen.Add(next)) { positions[++length] = next; continue; }
			}

			next = .(current.X, current.Y - 1);
			if (next.Y >= 0)
			{
				next.Value = grid[next.Y][next.X];
				if (ValidToN(current, next) && seen.Add(next)) { positions[++length] = next; continue; }
			}

			next = .(current.X, current.Y + 1);
			if (next.Y < height)
			{
				next.Value = grid[next.Y][next.X];
				if (ValidToS(current, next) && seen.Add(next)) { positions[++length] = next; continue; }
			}

			break;
		}

		int sum = positions[length].X * positions[0].Y - positions[length].Y * positions[0].X;
		length++;
		for (int i = 1; i < length; i++)
		{
			sum += positions[i - 1].X * positions[i].Y - positions[i - 1].Y * positions[i].X;
		}

		output.Append(scope $"{(length + 1) / 2}\n{(Math.Abs(sum) - length) / 2 + 1}");
	}
	private bool ValidToW(Node current, Node next)
	{
		return (current.Value == 'J' || current.Value == '-' || current.Value == '7' || current.Value == 'S') && (next.Value == '-' || next.Value == 'L' || next.Value == 'F');
	}
	private bool ValidToE(Node current, Node next)
	{
		return (current.Value == 'F' || current.Value == '-' || current.Value == 'L' || current.Value == 'S') && (next.Value == '-' || next.Value == 'J' || next.Value == '7');
	}
	private bool ValidToN(Node current, Node next)
	{
		return (current.Value == 'J' || current.Value == '|' || current.Value == 'L' || current.Value == 'S') && (next.Value == '|' || next.Value == 'F' || next.Value == '7');
	}
	private bool ValidToS(Node current, Node next)
	{
		return (current.Value == 'F' || current.Value == '|' || current.Value == '7' || current.Value == 'S') && (next.Value == '|' || next.Value == 'J' || next.Value == 'L');
	}
	private struct Node : IHashable
	{
		public int X, Y;
		public char8 Value;
		public this(int x, int y)
		{
			X = x;
			Y = y;
			Value = default;
		}
		public static bool operator ==(Node left, Node right) { return left.X == right.X && left.Y == right.Y; }
		public override void ToString(String output) { output.Append(scope $"{X},{Y}"); }
		public int GetHashCode() { return X * 999 + Y; }
	}
}