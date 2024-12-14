using System.Collections;
namespace System;
extension Int
{
	public int GCD(int b)
	{
		var b;
		int a = (int)this;
		while (b != 0)
		{
			int r = a % b;
			a = b;
			b = r;
		}
		return a;
	}
	public int PopCnt()
	{
		const uint c1 = 0x55555555'55555555;
		const uint c2 = 0x33333333'33333333;
		const uint c3 = 0x0F0F0F0F'0F0F0F0F;
		const uint c4 = 0x01010101'01010101;

		uint value = (uint)this;
		value -= (value >> 1) & c1;
		value = (value & c2) + ((value >> 2) & c2);
		value = (((value + (value >> 4)) & c3) * c4) >> 56;

		return (int)value;
	}
}
extension StringView
{
	public delegate void Parser(StringView data);
	public void Parse(Parser parser, char8 splitChar = '\n', bool keepEmpty = true)
	{
		int start = 0;
		for (int end = 0; end < this.Length; end++)
		{
			char8 c = this[end];
			if (c == splitChar)
			{
				if (start < end || keepEmpty)
				{
					parser(this.Substring(start, end - start));
				}
				start = end + 1;
			}
		}
		parser(this[start...]);
	}
	public void SplitOn(List<StringView> output, params StringView[] splits)
	{
		output.Clear();
		int index = 0;
		for (int i = 0; i < splits.Count; i++)
		{
			StringView split = splits[i];
			int newIndex = this.IndexOf(split, index);
			if (newIndex > index)
			{
				output.Add(this[index ... newIndex - 1]);
			}
			index = newIndex + split.Length;
		}
		if (index < this.Length)
		{
			output.Add(this[index...]);
		}
	}
	public void ExtractInts(List<int> numbers)
	{
		int index = 0;
		while (index < this.Length)
		{
			int num = (.)this[index++] - 0x30;
			if (num < 0 || num > 9) { continue; }
			bool isNegative = index - 2 >= 0 && this[index - 2] == '-';
			char8 c;
			while (index < this.Length && (c = this[index++]) >= '0' && c <= '9')
			{
				num = num * 10 + (.)c - 0x30;
			}
			numbers.Add(isNegative ? -num : num);
		}
	}
	public void ToInts(List<int> numbers, char8 splitChar = '\n')
	{
		numbers.Clear();
		this.Parse(scope (item) => numbers.Add(item.ToInt()), splitChar, false);
	}
	public int ToInt()
	{
		int length = this.Length;
		bool isNegative = false;
		int result = 0;
		for (int i = 0; i < length; i++)
		{
			char8 c = this[i];
			if (c >= '0' && c <= '9')
			{
				result = result * 10 + (int)(c - '0');
			} else if (c == '-' && result == 0)
			{
				isNegative = !isNegative;
			}
		}
		return isNegative ? -result : result;
	}
}