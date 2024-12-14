using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day13 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> nums = scope .(2000);
		input.ExtractInts(nums);

		int total1 = 0, total2 = 0;
		for (int i = 0; i < nums.Count; i += 6)
		{
			int xA = nums[i]; int yA = nums[i + 1];
			int xB = nums[i + 2]; int yB = nums[i + 3];
			int pX = nums[i + 4]; int pY = nums[i + 5];

			int Solve(int additional = 0)
			{
				int denominator = xA * yB - yA * xB;
				if (denominator != 0)
				{
					int bA = yB * (pX + additional) - xB * (pY + additional);
					int bB = xA * (pY + additional) - yA * (pX + additional);
					if (bA % denominator == 0 && bB % denominator == 0)
					{
						return (bA * 3 + bB) / denominator;
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