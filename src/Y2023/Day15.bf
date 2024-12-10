using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day15 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> sequenceValues = scope .();
		input.ToLines(sequenceValues, ',');
		Label[] sequences = scope .[sequenceValues.Count];
		for (int i = 0; i < sequences.Count; i++)
		{
			StringView value = sequenceValues[i];
			sequences[i] = .(value);
		}

		List<Label>[] maps = scope .[256];
		for (int i = 0; i < 256; i++)
		{
			maps[i] = new List<Label>();
		}

		int total1 = 0;
		for (int i = 0; i < sequences.Count; i++)
		{
			Label value = sequences[i];
			total1 += value.FullHash;

			List<Label> map = maps[value.NameHash];
			if (value.Add)
			{
				int index = map.IndexOf(value);
				if (index >= 0)
				{
					map[index] = value;
				} else
				{
					map.Add(value);
				}
			} else
			{
				map.Remove(value);
			}
		}

		int total2 = 0;
		for (int i = 0; i < 256; i++)
		{
			List<Label> map = maps[i];
			for (int j = 0; j < map.Count; j++)
			{
				Label value = map[j];
				total2 += (i + 1) * (j + 1) * value.Lens;
			}
			delete map;
		}

		output.Append(scope $"{total1}\n{total2}");
	}
	private struct Label
	{
		public StringView Name;
		public uint8 NameHash;
		public uint8 FullHash;
		public uint8 Lens;
		public bool Add;
		public this(StringView sequence)
		{
			int index = sequence.IndexOf('=');
			Add = index > 0;
			Lens = 0;
			if (Add)
			{
				Lens = (.)sequence.Substring(index + 1).ToInt();
			} else
			{
				index = sequence.Length - 1;
			}
			Name = sequence.Substring(0, index);
			NameHash = CalculateHash(Name);
			FullHash = CalculateHash(sequence);
		}
		public static bool operator ==(Label left, Label right)
		{
			return left.Name == right.Name;
		}
		private uint8 CalculateHash(StringView value)
		{
			uint8 result = 0;
			for (int i = 0; i < value.Length; i++)
			{
				result += (.)value[i];
				result *= 17;
			}
			return result;
		}
		public override void ToString(String output)
		{
			output.Append(scope $"{Name}({Lens}) = {NameHash}");
		}
	}
}