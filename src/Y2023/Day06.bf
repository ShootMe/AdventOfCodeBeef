using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day06 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.Parse(scope (item) => lines.Add(item));

		List<int> numbers = scope .();
		input.ExtractInts(numbers);
		int timeAll = lines[0].ToInt();
		int distanceAll = lines[1].ToInt();

		int total = 1;
		int split = numbers.Count / 2;
		for (int i = 0; i < split; i++)
		{
			total *= CalculateWins(numbers[i], numbers[i + split]);
		}

		output.Append(scope $"{total}\n{CalculateWins(timeAll, distanceAll)}");
	}
	private int CalculateWins(int time, int distance)
	{
		int maxVal = (int)Math.Ceiling((time + Math.Sqrt(time * time - 4 * distance)) / 2d);
		int minVal = (int)((time - Math.Sqrt(time * time - 4 * distance)) / 2d);
		return maxVal - minVal - 1;
	}
}