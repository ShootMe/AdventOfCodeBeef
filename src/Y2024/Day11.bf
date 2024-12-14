using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day11 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> stones = scope .();
		input.Parse(scope (item) => stones.Add(item.ToInt()), ' ');

		int FindTotalStones(int blinks)
		{
			static void UpdateCounts(Dictionary<int, int> counts, int newStone, int amount)
			{
				if (!counts.TryAdd(newStone, amount)) { counts[newStone] += amount; }
			}

			Dictionary<int, int> counts = new .();
			defer delete counts;
			for (int j = 0; j < stones.Count; j++)
			{
				UpdateCounts(counts, stones[j], 1);
			}

			Dictionary<int, int> newCounts = new .();
			defer delete newCounts;
			String stoneString = scope .();

			void UpdateStone((int key, int value) stone)
			{
				if (stone.key == 0)
				{
					UpdateCounts(newCounts, 1, stone.value);
				} else if (stone.key == 1)
				{
					UpdateCounts(newCounts, 2024, stone.value);
				} else
				{
					stoneString.Clear();
					stone.key.ToString(stoneString);

					if ((stoneString.Length & 1) == 0)
					{
						int next = stoneString.Substring(0, stoneString.Length / 2).ToInt();
						UpdateCounts(newCounts, next, stone.value);
						next = stoneString.Substring(stoneString.Length / 2).ToInt();
						UpdateCounts(newCounts, next, stone.value);
					} else
					{
						UpdateCounts(newCounts, stone.key * 2024, stone.value);
					}
				}
			}

			for (int i = 0; i < blinks; i++)
			{
				newCounts.Clear();
				for (var stone in counts)
				{
					UpdateStone(stone);
				}
				Swap!(counts, newCounts);
			}

			int total = 0;
			for (int value in counts.Values)
			{
				total += value;
			}
			return total;
		}

		output.Append(scope $"{FindTotalStones(25)}\n{FindTotalStones(75)}");
	}
}