using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day05 : IDay
{
	public void Solve(StringView input, String output)
	{
		Dictionary<int, HashSet<int>> rules = new .();
		defer { DeleteDictionaryAndValues!(rules); }

		int total1 = 0, total2 = 0;
		for (StringView line in input.Split('\n'))
		{
			int index = line.IndexOf('|');
			if (index < 0)
			{
				if (line.IsNull) { continue; }

				List<int> updateOrig = scope .();
				List<int> update = scope .();
				for (StringView page in line.Split(','))
				{
					int num = page.ToInt();
					updateOrig.Add(num);
					update.Add(num);
				}

				update.Sort(scope (left, right) =>
					{
						HashSet<int> beforeLeft, beforeRight;
						if (rules.TryGetValue(left, out beforeLeft))
						{
							if (beforeLeft.Contains(right))
							{
								return -1;
							}
						} else if (!rules.TryGetValue(right, out beforeRight))
						{
							return 0;
						}
						return 1;
					});

				bool isGood = true;
				for (int j = 0; j < update.Count; j++)
				{
					if (update[j] != updateOrig[j])
					{
						isGood = false;
						break;
					}
				}

				if (isGood)
				{
					total1 += updateOrig[update.Count / 2];
				} else
				{
					total2 += update[update.Count / 2];
				}
			} else
			{
				int page1 = line[0 ... index].ToInt();
				int page2 = line[index...].ToInt();
				HashSet<int> before;
				if (!rules.TryGetValue(page1, out before))
				{
					before = new .();
					rules[page1] = before;
				}
				before.Add(page2);
			}
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}