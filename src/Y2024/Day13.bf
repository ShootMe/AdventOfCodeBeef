using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day13 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		int total1 = 0, total2 = 0;
		List<StringView> splits = scope .();

		for (int i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i++];
			line.SplitOn(splits, "X+", ", Y+");
			int xA = splits[1].ToInt(); int yA = splits[2].ToInt();

			line = lines[i++];
			line.SplitOn(splits, "X+", ", Y+");
			int xB = splits[1].ToInt(); int yB = splits[2].ToInt();

			line = lines[i++];
			line.SplitOn(splits, "X=", ", Y=");
			int pX = splits[1].ToInt(); int pY = splits[2].ToInt();

			int Solve(int additional = 0)
			{
				int denominator = xA * yB - yA * xB;
				if (denominator != 0)
				{
					int bB = (xA * (pY + additional) - yA * (pX + additional)) / denominator;
					int bA = (yB * (pX + additional) - xB * (pY + additional)) / denominator;
					if (xA * bA + xB * bB == pX + additional)
					{
						return bA * 3 + bB;
					}
				}
				return 0;
			}
			total1 += Solve();
			total2 += Solve(10000000000000);
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}