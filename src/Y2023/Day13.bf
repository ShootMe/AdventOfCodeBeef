using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day13 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total1 = 0;
		int total2 = 0;
		List<StringView> rows = scope .();
		for (StringView line in input.Split('\n'))
		{
			if (line.Length == 0)
			{
				(int r1, int r2) = GetReflectionValues(rows);
				total1 += r1;
				total2 += r2;
				rows.Clear();
				continue;
			}
			rows.Add(line);
		}

		(int r1, int r2) = GetReflectionValues(rows);
		total1 += r1;
		total2 += r2;
		output.Append(scope $"{total1}\n{total2}");
	}
	private (int, int) GetReflectionValues(List<StringView> lines)
	{
		int[] rowValues = scope int[lines.Count];
		int[] colValues = scope int[lines[0].Length];

		for (int i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			int value = 0;
			for (int j = 0; j < line.Length; j++)
			{
				value <<= 1;
				int bit = line[j] == '#' ? 1 : 0;
				value |= bit;
				colValues[j] = (colValues[j] << 1) | bit;
			}
			rowValues[i] = value;
		}

		(int rx, int ry) = CheckReflection(colValues, rowValues);
		int r2 = Check2ndReflection(colValues, rowValues, rx - 1, ry - 1);
		return (rx > 0 ? rx : ry * 100, r2);
	}
	private (int, int) CheckReflection(int[] colValues, int[] rowValues)
	{
		int value = CheckReflection(colValues);
		if (value > 0) { return (value, 0); }

		value = CheckReflection(rowValues);
		if (value > 0) { return (0, value); }

		return (0, 0);
	}
	private int Check2ndReflection(int[] colValues, int[] rowValues, int rx, int ry)
	{
		int value = CheckReflection(colValues, rx, true);
		if (value > 0) { return value; }

		value = CheckReflection(rowValues, ry, true);
		if (value > 0) { return value * 100; }

		return 0;
	}
	private int CheckReflection(int[] values, int ignoreIndex = -1, bool check2nd = false)
	{
		int max = values.Count;
		for (int i = 0; i < max - 1; i++)
		{
			if (i == ignoreIndex) { continue; }

			bool found = true;
			bool firstDiff = !check2nd;
			int minIndex = i + i - max + 2;
			if (minIndex < 0) { minIndex = 0; }

			for (int k = i, j = i + 1; k >= minIndex; k--,j++)
			{
				int diff = values[k] ^ values[j];
				if (diff != 0)
				{
					if (!firstDiff && diff.PopCnt() == 1)
					{
						firstDiff = true;
						continue;
					}
					found = false;
					break;
				}
			}

			if (found) { return i + 1; }
		}

		return 0;
	}
}