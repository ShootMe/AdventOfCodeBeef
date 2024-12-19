using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day19 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> designs = scope .();
		input.Parse(scope (item) => designs.Add(item));

		List<StringView> patterns = scope .();
		designs[0].Parse(scope (item) => { var item; item.Trim(); patterns.Add(item); }, ',');

		patterns.Sort((left, right) =>
			{
				int comp = left.Length <=> right.Length;
				if (comp != 0) { return comp; }
				return left <=> right;
			});

		Dictionary<StringView, int> counts = new .(20000);
		defer delete counts;

		int IsPossible(StringView design)
		{
			if (design.Length == 0) { return 1; }
			int count;
			if (counts.TryGetValue(design, out count)) { return count; }
			count = 0;

			for (int i = 0; i < patterns.Count; i++)
			{
				StringView pattern = patterns[i];
				if (design.IndexOf(pattern) == 0)
				{
					count += IsPossible(design.Substring(pattern.Length));
				}
			}

			counts.Add(design, count);
			return count;
		}

		int total1 = 0, total2 = 0;
		for (int i = 2; i < designs.Count; i++)
		{
			int total = IsPossible(designs[i]);
			total1 += total > 0 ? 1 : 0;
			total2 += total;
		}
		output.Append(scope $"{total1}\n{total2}");
	}
}