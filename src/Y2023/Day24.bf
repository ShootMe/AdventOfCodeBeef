using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day24 : IDay
{
	private List<Snowball> snowballs = new .() ~ delete _;
	public void Solve(StringView input, String output)
	{
		ParseInput(input);

		int total = 0;
		int min = snowballs.Count > 10 ? 200000000000000 : 7;
		int max = snowballs.Count > 10 ? 400000000000000 : 27;
		for (int i = 0; i < snowballs.Count; i++)
		{
			Snowball snowball1 = snowballs[i];

			for (int j = i + 1; j < snowballs.Count; j++)
			{
				var sx = snowball1.IntersectsXY(snowballs[j]);
				if (!sx.Intersects || sx.Position.X < min || sx.Position.X > max || sx.Position.Y < min || sx.Position.Y > max || sx.Time1 < 0 || sx.Time2 < 0) { continue; }

				total++;
			}
		}

		const int vRange = 350;
		Snowball s1 = snowballs[0]; s1.Velocity.x -= vRange;
		Snowball s2 = snowballs[1]; s2.Velocity.x -= vRange;
		Snowball s3 = snowballs[2]; s3.Velocity.x -= vRange;
		Snowball s4 = snowballs[3]; s4.Velocity.x -= vRange;
		int y1 = s1.Velocity.y - vRange; int y2 = s2.Velocity.y - vRange; int y3 = s3.Velocity.y - vRange; int y4 = s4.Velocity.y - vRange;

		for (int x = -vRange; x <= vRange; x++,s1.Velocity.x++,s2.Velocity.x++,s3.Velocity.x++,s4.Velocity.x++)
		{
			s1.Velocity.y = y1; s2.Velocity.y = y2; s3.Velocity.y = y3; s4.Velocity.y = y4;

			for (int y = -vRange; y <= vRange; y++,s1.Velocity.y++,s2.Velocity.y++,s3.Velocity.y++,s4.Velocity.y++)
			{
				Intersection i1 = s1.IntersectsXY(s2);
				if (!i1.Intersects) { continue; }
				Intersection i2 = s2.IntersectsXY(s3);
				if (i1.Position != i2.Position) { continue; }
				Intersection i3 = s3.IntersectsXY(s4);
				if (i1.Position != i3.Position) { continue; }

				for (int z = -vRange; z <= vRange; z++)
				{
					int z1 = s1.ZAt(i1.Time1, z);
					int z2 = s2.ZAt(i2.Time1, z);
					if (z1 != z2) { continue; }
					int z3 = s3.ZAt(i3.Time1, z);
					if (z1 != z3) { continue; }

					output.Append(scope $"{total}\n{i1.Position.X + i1.Position.Y + z1}");
					return;
				}
			}
		}

		output.Append(scope $"{total}");
	}
	private void ParseInput(StringView input)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		List<StringView> splits = scope .();
		for (StringView line in lines)
		{
			line.SplitOn(splits, ", ", ", ", " @ ", ", ", ", ");
			snowballs.Add(.(snowballs.Count, (splits[0].ToInt(), splits[1].ToInt(), splits[2].ToInt()), (splits[3].ToInt(), splits[4].ToInt(), splits[5].ToInt())));
		}
	}
	private struct Snowball
	{
		public int ID;
		public (int x, int y, int z) Position, Velocity;

		public this(int id, (int, int, int) position, (int, int, int) velocity)
		{
			ID = id;
			Position = position;
			Velocity = velocity;
		}
		public Intersection IntersectsXY(Snowball s2)
		{
			double d = (double)Velocity.y * s2.Velocity.x - Velocity.x * s2.Velocity.y;
			if (d == 0 || Velocity.x == 0 || s2.Velocity.x == 0) { return .(false, (0, 0), 0, 0); }

			double m1 = (double)Velocity.y / Velocity.x;
			double m2 = (double)s2.Velocity.y / s2.Velocity.x;
			double x = ((Position.y - m1 * Position.x) - (s2.Position.y - m2 * s2.Position.x)) / (m2 - m1);
			double y = (Position.y - m1 * Position.x) + m1 * x;

			return .(true, ((int)x, (int)y), (int)((x - Position.x) / Velocity.x), (int)((x - s2.Position.x) / s2.Velocity.x));
		}
		public int ZAt(double time, int offset)
		{
			return (int)(Position.z + (Velocity.z + offset) * time);
		}
	}
	private struct Intersection
	{
		public bool Intersects;
		public (int X, int Y) Position;
		public int Time1, Time2;
		public this(bool intersects, (int, int) position, int time1, int time2)
		{
			Intersects = intersects;
			Position = position;
			Time1 = time1;
			Time2 = time2;
		}
	}
}