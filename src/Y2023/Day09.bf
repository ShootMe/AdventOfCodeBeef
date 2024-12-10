using System;
using System.Collections;
using AdventOfCode;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day09 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total1 = 0;
		int total2 = 0;
		List<int> values = scope .();
		for (StringView line in input.Split('\n'))
		{
			line.ToInts(values, ' ');
			int length = values.Count;
			int zeroCount;
			repeat
			{
				zeroCount = 0;
				for (int j = 1; j < length; j++)
				{
					int newValue = values[j] - values[j - 1];
					values[j - 1] = newValue;
					zeroCount = newValue != 0 ? 0 : 1;
				}
				length--;
			} while (zeroCount < length);

			for (int j = length + 1; j < values.Count; j++)
			{
				values[j] += values[j - 1];
			}
			total1 += values[^1];

			for (int j = 0; j <= values.Count; j++)
			{
				for (int k = values.Count - 1; k > 0; k--)
				{
					values[k] -= values[k - 1];
				}
			}
			total2 += values[^1];
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}