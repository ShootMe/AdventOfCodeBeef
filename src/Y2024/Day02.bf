using System;
using System.Collections;
namespace AdventOfCode.Y2024;

class Day02 : IDay
{
	public void Solve(StringView input, String output)
	{
		int[] levels = scope int[50];
		int[] levelsSub = scope int[50];
		int length = 0;

		bool IsSafe(int[] levelsToCheck, int size)
		{
			int way = levelsToCheck[0] - levelsToCheck[1];
			bool isSafe = Math.Abs(way) <= 3 && Math.Abs(way) > 0;
			for (int i = 2; i < size; i++)
			{
				int next = levelsToCheck[i - 1] - levelsToCheck[i];
				if (Math.Sign(next) != Math.Sign(way) || (Math.Abs(next) > 3 && Math.Abs(next) > 0))
				{
					return false;
				}
			}
			return isSafe;
		}
		bool IsTolerate()
		{
			bool HelpSetTolerate(int ignore)
			{
				int index = 0;
				for (int i = 0; i < length; i++)
				{
					if (i == ignore) { continue; }

					levelsSub[index++] = levels[i];
				}
				return IsSafe(levelsSub, length - 1);
			}

			for (int i = 0; i < length; i++)
			{
				if (HelpSetTolerate(i))
				{
					return true;
				}
			}
			return false;
		}

		int total1 = 0, total2 = 0;
		for (StringView line in input.Split('\n'))
		{
			length = 0;
			for (StringView num in line.Split(' '))
			{
				levels[length++] = num.ToInt();
			}

			bool isSafe = IsSafe(levels, length);
			total1 += isSafe ? 1 : 0;
			total2 += isSafe || IsTolerate() ? 1 : 0;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}