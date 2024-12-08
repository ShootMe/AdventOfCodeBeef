using System;
using System.Collections;
namespace AdventOfCode.Y2024;

class Day03 : IDay
{
	public void Solve(StringView input, String output)
	{
		int ParseMul(ref int index)
		{
			int ParseNum(char8 endChar, ref int index)
			{
				int num = 0;
				while (index < input.Length)
				{
					char8 c = input[index++];
					if (c >= '0' && c <= '9')
					{
						num = num * 10 + ((int)c - 0x30);
						continue;
					} else if (c != endChar)
					{
						return -1;
					}
					break;
				}
				return num;
			}

			int num1 = ParseNum(',', ref index);
			if (num1 < 0) { return 0; }

			int num2 = ParseNum(')', ref index);
			return num2 >= 0 ? num1 * num2 : 0;
		}

		int total1 = 0, total2 = 0;
		int index = 0;
		bool enabled = true;
		while ((index = input.IndexOf("mul(", index)) >= 0)
		{
			int dIndex = index;
			while ((dIndex = input.LastIndexOf('d', dIndex - 1)) >= 0)
			{
				if (input[dIndex ... (dIndex + 3)] == "do()")
				{
					enabled = true;
					break;
				} else if (input[dIndex ... (dIndex + 6)] == "don't()")
				{
					enabled = false;
					break;
				}
			}

			index += 4;
			int amount = ParseMul(ref index);
			total1 += amount;
			if (enabled) { total2 += amount; }
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}