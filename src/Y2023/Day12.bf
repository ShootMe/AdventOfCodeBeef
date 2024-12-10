using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day12 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total1 = 0;
		int total2 = 0;
		for (StringView line in input.Split('\n'))
		{
			SpringRecord record = scope .(line);
			total1 += record.Arrangements();
			String newRecord = scope $"{record.Springs}?{record.Springs}?{record.Springs}?{record.Springs}?{record.Springs} {record.GroupCounts},{record.GroupCounts},{record.GroupCounts},{record.GroupCounts},{record.GroupCounts}";
			record = scope .(newRecord);
			total2 += record.Arrangements();
		}

		output.Append(scope $"{total1}\n{total2}");
	}

	private class SpringRecord
	{
		public StringView Springs, GroupCounts;
		public int TotalCount;
		public List<int> Groups ~ delete _;
		public this(StringView data)
		{
			int index = data.IndexOf(' ');
			Springs = data.Substring(0, index);
			GroupCounts = data.Substring(index + 1);
			Groups = new List<int>();
			GroupCounts.ToInts(Groups, ',');
			TotalCount = -1;
			for (int i = 0; i < Groups.Count; i++)
			{
				TotalCount += Groups[i] + 1;
			}
		}
		public int Arrangements()
		{
			int[] memory = scope int[Groups.Count * Springs.Length];
			return Arrangements(0, 0, TotalCount, memory);
		}
		private int Arrangements(int index, int groupIndex, int remainingCount, int[] memory)
		{
			var index;
			int memoryIndex = groupIndex * Springs.Length + index;
			int memoryValue = memory[memoryIndex] - 1;
			if (memoryValue >= 0) { return memoryValue; }

			int groupCount = Groups[groupIndex];
			int extraCount = groupCount == remainingCount ? 0 : 1;

			int count = 0;
			int[] counts = scope .[Springs.Length - index];
			int start = 0;
			while (index + remainingCount <= Springs.Length)
			{
				int number = 0;
				if (IsValid(index, groupCount, extraCount))
				{
					number = extraCount == 0 ? 1 : Arrangements(index + groupCount + 1, groupIndex + 1, remainingCount - groupCount - 1, memory);
					count += number;
				}
				counts[start++] = number;

				if (Springs[index] == '#') { break; }
				index++;
			}

			int result = count;
			for (int i = 0; i < start; i++)
			{
				memory[memoryIndex++] = count + 1;
				count -= counts[i];
			}

			return result;
		}
		private bool IsValid(int index, int size, int pad)
		{
			if (index + size + pad > Springs.Length) { return false; }

			int end = index + size;
			for (int i = index; i < end; i++)
			{
				char8 current = Springs[i];
				if (current == '.') { return false; }
			}

			int maxCheck = pad == 0 ? Springs.Length - 1 : end;
			for (int i = end; i <= maxCheck; i++)
			{
				if (Springs[i] == '#') { return false; }
			}
			return true;
		}
	}
}