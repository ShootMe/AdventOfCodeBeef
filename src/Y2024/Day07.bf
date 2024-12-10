using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day07 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total1 = 0, total2 = 0;
		List<int> operands = scope .();
		for (StringView formula in input.Split('\n'))
		{
			int index = formula.IndexOf(':');
			int value = formula[0 ... index].ToInt();

			operands.Clear();
			for (StringView operand in formula[(index + 1)...].Split(' ', StringSplitOptions.RemoveEmptyEntries))
			{
				operands.Add(operand.ToInt());
			}

			bool HasValidOperators(bool use3 = false)
			{
				return TryNext(1, operands[0], use3) == value;
			}
			int TryNext(int index, int current, bool use3)
			{
				if (index < operands.Count)
				{
					int operand = operands[index];
					if (TryNext(index + 1, current + operand, use3) == value || TryNext(index + 1, current * operand, use3) == value)
					{
						return value;
					}
					if (use3)
					{
						if (TryNext(index + 1, current * GetBase10(operand) + operand, use3) == value)
						{
							return value;
						}
					}
				} else
				{
					return current;
				}
				return -current;
			}

			total1 += HasValidOperators() ? value : 0;
			total2 += HasValidOperators(true) ? value : 0;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private static int GetBase10(int num)
	{
		int i = 1;
		while (i <= num)
		{
			i *= 10;
		}
		return i;
	}
}