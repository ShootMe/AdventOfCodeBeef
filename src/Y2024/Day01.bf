using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day01 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		int32[] left = scope int32[lines.Count];
		int32[] right = scope int32[lines.Count];
		int32[] counts = new int32[100000];
		defer delete counts;

		for (int i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			int index = line.IndexOf(' ');
			left[i] = (.)line[0 ... index].ToInt();
			int32 rightNum = (.)line[index...].ToInt();
			right[i] = rightNum;
			counts[rightNum]++;
		}

		Array.Sort(left, scope (lt, rt) => lt <=> rt);
		Array.Sort(right, scope (lt, rt) => lt <=> rt);

		int32 total1 = 0, total2 = 0;
		for (int i = 0; i < lines.Count; i++)
		{
			total1 += Math.Abs(left[i] - right[i]);
			int32 count = counts[left[i]];
			total2 += left[i] * count;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}