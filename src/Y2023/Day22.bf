using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day22 : IDay
{
	private List<Brick> bricks = new .() ~ DeleteContainerAndItems!(_);

	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		List<StringView> values = scope .();
		for (int i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			line.SplitOn(values, ",", ",", "~", ",", ",");
			bricks.Add(new .(values, i));
		}

		bricks.Sort();
		Brick[,] zMax = scope .[10, 10];
		for (int i = 0; i < bricks.Count; i++)
		{
			MoveBrickDown(zMax, bricks[i]);
		}
		bricks.Sort();

		int total1 = 0;
		int total2 = 0;
		for (int i = 0; i < bricks.Count; i++)
		{
			int bricksMoved = BricksToFallWhenRemoved(bricks[i]);
			if (bricksMoved == 0) { total1++; }
			total2 += bricksMoved;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private void MoveBrickDown(Brick[,] zMax, Brick brick)
	{
		int maxZ = 0;
		for (int y = brick.End1.y; y <= brick.End2.y; y++)
		{
			for (int x = brick.End1.x; x <= brick.End2.x; x++)
			{
				Brick max = zMax[y, x];
				if (max != null && max.End2.z > maxZ) { maxZ = max.End2.z; }
			}
		}

		for (int y = brick.End1.y; y <= brick.End2.y; y++)
		{
			for (int x = brick.End1.x; x <= brick.End2.x; x++)
			{
				Brick max = zMax[y, x];
				zMax[y, x] = brick;
				if (max != null && max.End2.z == maxZ)
				{
					brick.Below.Add(max);
					max.Above.Add(brick);
				}
			}
		}

		int diff = brick.End1.z - maxZ - 1;
		brick.End1.z -= diff;
		brick.End2.z -= diff;
	}
	private int BricksToFallWhenRemoved(Brick brick)
	{
		if (brick.Above.Count == 0) { return 0; }

		Queue<Brick> bricksLeft = scope .();
		bricksLeft.Add(brick);
		int total = 0;
		bool[] removed = scope .[bricks.Count];
		removed[brick.ID] = true;

		while (bricksLeft.Count > 0)
		{
			Brick current = bricksLeft.PopFront();
			for (Brick above in current.Above)
			{
				if (removed[above.ID]) { continue; }

				bool willFall = true;
				for (Brick below in above.Below)
				{
					if (!removed[below.ID])
					{
						willFall = false;
						break;
					}
				}

				if (willFall)
				{
					removed[above.ID] = true;
					bricksLeft.Add(above);
					total++;
				}
			}
		}

		return total;
	}
	private class Brick : IHashable
	{
		public int ID;
		public (int x, int y, int z) End1, End2;
		public HashSet<Brick> Below = new .() ~ delete _;
		public HashSet<Brick> Above = new .() ~ delete _;

		public this(List<StringView> values, int id)
		{
			ID = id;
			End1 = (values[0].ToInt(), values[1].ToInt(), values[2].ToInt());
			End2 = (values[3].ToInt(), values[4].ToInt(), values[5].ToInt());
		}
		public static int operator <=>(Brick left, Brick right)
		{
			int comp = left.End1.z <=> right.End1.z;
			if (comp != 0) { return comp; }
			comp = left.End1.x <=> right.End1.x;
			if (comp != 0) { return comp; }
			return left.End1.y <=> right.End1.y;
		}
		public bool Equals(Brick other) { return ID == other.ID; }
		public int GetHashCode() { return ID; }
	}
}