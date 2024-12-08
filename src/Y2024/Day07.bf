using System;
using System.Collections;
namespace AdventOfCode.Y2024;

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
						int mult = (int)Math.Pow(10, (int)Math.Log10(operand) + 1);
						if (TryNext(index + 1, current * mult + operand, use3) == value)
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
}