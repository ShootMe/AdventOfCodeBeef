using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day06 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		List<int> times = scope .();
		lines[0].Substring(5).ToInts(times, ' ');
		List<int> distances = scope .();
		lines[1].Substring(9).ToInts(distances, ' ');
		int timeAll = lines[0].ToInt();
		int distanceAll = lines[1].ToInt();

		int total = 1;
		for (int i = 0; i < times.Count; i++) {
		    total *= CalculateWins(times[i], distances[i]);
		}

		output.Append(scope $"{total}\n{CalculateWins(timeAll, distanceAll)}");
	}
	private int CalculateWins(int time, int distance) {
	    int maxVal = (int)Math.Ceiling((time + Math.Sqrt(time * time - 4 * distance)) / 2d);
	    int minVal = (int)((time - Math.Sqrt(time * time - 4 * distance)) / 2d);
	    return maxVal - minVal - 1;
	}
}