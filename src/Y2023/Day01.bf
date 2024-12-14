using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day01 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> calibrations = scope .();
		input.Parse(scope (item) => calibrations.Add(item));

		int32 FindTotalDigitSum(bool includeLetters)
		{
			int32 total = 0;
			for (int i = 0; i < calibrations.Count; i++)
			{
				StringView calibration = calibrations[i];
				DigitWindow window = default;
				for (int j = 0; j < calibration.Length; j++)
				{
					char8 c = calibration[j];
					int32 value = window.FindStart(c, includeLetters);
					if (value >= 0) { total += value * 10; break; }
				}
				window = default;
				for (int j = calibration.Length - 1; j >= 0; j--)
				{
					char8 c = calibration[j];
					int32 value = window.FindEnd(c, includeLetters);
					if (value >= 0) { total += value; break; }
				}
			}
			return total;
		}

		output.Append(scope $"{FindTotalDigitSum(false)}\n{FindTotalDigitSum(true)}");
	}

	private struct DigitWindow
	{
		char8 D1, D2, D3, D4, D5;

		public int32 FindStart(char8 current, bool includeLetters = false) mut
		{
			D5 = D4;
			D4 = D3;
			D3 = D2;
			D2 = D1;
			D1 = current;

			if (IsDigit(D1)) { return (int32)D1 & 15; }

			if (!includeLetters) { return -1; }

			switch ((D1, D2, D3, D4, D5)) {
				case ('o', 'r', 'e', 'z', let d5): return 0;
				case ('e', 'n', 'o', let d4, let d5): return 1;
				case ('o', 'w', 't', let d4, let d5): return 2;
				case ('e', 'e', 'r', 'h', 't'): return 3;
				case ('r', 'u', 'o', 'f', let d5): return 4;
				case ('e', 'v', 'i', 'f', let d5): return 5;
				case ('x', 'i', 's', let d4, let d5): return 6;
				case ('n', 'e', 'v', 'e', 's'): return 7;
				case ('t', 'h', 'g', 'i', 'e'): return 8;
				case ('e', 'n', 'i', 'n', let d5): return 9;
			}

			return -1;
		}
		public int32 FindEnd(char8 current, bool includeLetters = false) mut
		{
			D5 = D4;
			D4 = D3;
			D3 = D2;
			D2 = D1;
			D1 = current;

			if (IsDigit(D1)) { return (int32)D1 & 15; }

			if (!includeLetters) { return -1; }

			switch ((D1, D2, D3, D4, D5)) {
				case ('z', 'e', 'r', 'o', let d5): return 0;
				case ('o', 'n', 'e', let d4, let d5): return 1;
				case ('t', 'w', 'o', let d4, let d5): return 2;
				case ('t', 'h', 'r', 'e', 'e'): return 3;
				case ('f', 'o', 'u', 'r', let d5): return 4;
				case ('f', 'i', 'v', 'e', let d5): return 5;
				case ('s', 'i', 'x', let d4, let d5): return 6;
				case ('s', 'e', 'v', 'e', 'n'): return 7;
				case ('e', 'i', 'g', 'h', 't'): return 8;
				case ('n', 'i', 'n', 'e', let d5): return 9;
			}

			return -1;
		}
		[Inline]
		private static bool IsDigit(char8 value) { return value >= '0' && value <= '9'; }
	}
}