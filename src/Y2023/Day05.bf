using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day05 : IDay
{
	private List<Seed> seeds1, seeds2;
	public void Solve(StringView input, String output)
	{
		List<StringView> mappings = scope .();
		input.ToLines(mappings);

		List<int> numbers = scope .();
		mappings[0].Substring(7).ToInts(numbers, ' ');

		seeds1 = new .(numbers.Count);
		for (int i = 0; i < numbers.Count; i++)
		{
			seeds1.Add(.(0, numbers[i], 1));
		}

		seeds2 = new .(numbers.Count * 4);
		for (int i = 0; i < numbers.Count; i += 2)
		{
			seeds2.Add(.(0, numbers[i], numbers[i + 1]));
		}

		int lineIndex = 3;
		for (int level = 0; level < 7; level++)
		{
			MapDetails(mappings, ref lineIndex, level);
		}

		int minLocation = int.MaxValue;
		for (int i = 0; i < seeds1.Count; i++)
		{
			Seed seed = seeds1[i];
			if (seed.Value < minLocation)
			{
				minLocation = seed.Value;
			}
		}

		int minLocation2 = int.MaxValue;
		for (int i = 0; i < seeds2.Count; i++)
		{
			Seed seed = seeds2[i];
			if (seed.Value < minLocation2)
			{
				minLocation2 = seed.Value;
			}
		}

		output.Append(scope $"{minLocation}\n{minLocation2}");

		delete seeds1;
		delete seeds2;
	}
	private void MapDetails(List<StringView> mappings, ref int lineIndex, int level)
	{
		List<int> mapping = scope .();
		for (; lineIndex < mappings.Count; lineIndex++)
		{
			StringView line = mappings[lineIndex];
			if (line.Length <= 0) { lineIndex += 2; break; }

			line.ToInts(mapping, ' ');

			MapSeedDetails(seeds1, level, mapping[0], mapping[1], mapping[2]);
			MapSeedDetails(seeds2, level, mapping[0], mapping[1], mapping[2]);
		}
	}
	private void MapSeedDetails(List<Seed> seedsToMap, int level, int destStart, int sourceStart, int length)
	{
		for (int i = 0; i < seedsToMap.Count; i++)
		{
			ref Seed seed = ref seedsToMap[i];
			//Check intersection
			if (seed.Level > level || seed.Value >= sourceStart + length || seed.Value + seed.Length <= sourceStart) { continue; }

			//If seed range extends beyond mapping range
			if (seed.Value + seed.Length > sourceStart + length)
			{
				int newLength = seed.Value + seed.Length - sourceStart - length;
				Seed newSeed = .(level, sourceStart + length, newLength);
				seedsToMap.Add(newSeed);
				seed.Length -= newLength;
			}

			//If seed range extends before mapping range
			if (seed.Value < sourceStart)
			{
				int newLength = sourceStart - seed.Value;
				Seed newSeed = .(level, seed.Value, newLength);
				seedsToMap.Add(newSeed);
				seed.Value += newLength;
				seed.Length -= newLength;
			}

			//Change seeds value to new mapping value
			seed.Value += destStart - sourceStart;
			seed.Level = level + 1;
		}
	}
	private struct Seed
	{
		public int Level;
		public int Value;
		public int Length;
		public this(int level, int id, int length)
		{
			Level = level;
			Value = id;
			Length = length;
		}
		public override void ToString(String output)
		{
			output.Append(scope $"{Value}->{Value - 1 + Length}");
		}
	}
}