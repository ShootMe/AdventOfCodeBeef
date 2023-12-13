using System.Collections;
namespace System;
extension Int
{
	public int GCD(int b)
	{
		var b;
		int a = (int)this;
		if (this == 0 && b == 0) { return 1; }
		a = a < 0 ? -a : a;
		b = b < 0 ? -b : b;
		if (a == 0) { return b; }
		if (b == 0) { return a; }

		int r;
		if (b > a)
		{
			r = b % a;
			if (r == 0) { return a; }
			if (r == 1) { return 1; }
			b = r;
		}
		while (true)
		{
			r = a % b;
			if (r == 0) { return b; }
			if (r == 1) { return 1; }
			a = b;
			b = r;
		}
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
	public delegate T Parser<T>(StringView data);
	public void ToLines(List<StringView> lines, char8 splitChar = '\n')
	{
		for (StringView line in this.Split(splitChar))
		{
			lines.Add(line);
		}
	}
	public void Parse<T>(List<T> splits, Parser<T> parser, char8 splitChar = '\n')
	{
		splits.Clear();
		int start = 0;
		char8 last = splitChar;
		for (int end = 0; end < this.Length; end++)
		{
			char8 c = this[end];
			if (c == splitChar)
			{
				if (last != c)
				{
					splits.Add(parser(this[start ... end - 1]));
				}
				start = end + 1;
			}
			last = c;
		}
		splits.Add(parser(this[start...]));
	}
	public void SplitOn(List<StringView> output, params StringView[] splits)
	{
		output.Clear();
		int index = 0;
		for (int i = 0; i < splits.Count; i++)
		{
			StringView split = splits[i];
			int newIndex = this.IndexOf(split, index);
			if (newIndex >= 0)
			{
				output.Add(this[index ... newIndex - 1]);
				index = newIndex + split.Length;
			} else
			{
				output.Add(String.Empty);
			}
		}
		if (index < this.Length)
		{
			output.Add(this[index...]);
		} else
		{
			output.Add(String.Empty);
		}
	}
	public void ToInts(List<int> numbers, char8 splitChar = '\n')
	{
		int Parse(StringView data) { return data.ToInt(); }
		this.Parse(numbers, scope => Parse, splitChar);
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