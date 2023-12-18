using System;
using System.Collections;
using System.Globalization;
namespace AdventOfCode.Y2023;

class Day18 : IDay
{
	private const int[4] DirX = .(1, 0, -1, 0);
	private const int[4] DirY = .(0, 1, 0, -1);

	public void Solve(StringView input, String output)
	{
		int sum1 = 0, sum2 = 0;
		int perimeter1 = 0, perimeter2 = 0;
		int x1 = 0, y1 = 0;
		int x2 = 0, y2 = 0;
		for (StringView line in input.Split('\n'))
		{
			Direction direction = .(line);

			int nx = x1 + DirX[direction.Dir] * direction.Length;
			int ny = y1 + DirY[direction.Dir] * direction.Length;
			sum1 += x1 * ny - y1 * nx;
			perimeter1 += direction.Length;
			x1 = nx; y1 = ny;

			nx = x2 + DirX[direction.TrueDir] * direction.TrueLength;
			ny = y2 + DirY[direction.TrueDir] * direction.TrueLength;
			sum2 += x2 * ny - y2 * nx;
			perimeter2 += direction.TrueLength;
			x2 = nx; y2 = ny;
		}

		sum1 = (Math.Abs(sum1) - perimeter1) / 2 + 1 + perimeter1;
		sum2 = (Math.Abs(sum2) - perimeter2) / 2 + 1 + perimeter2;
		output.Append(scope $"{sum1}\n{sum2}");
	}
	private struct Direction
	{
		public int Dir, Length, TrueDir, TrueLength;
		public this(StringView data)
		{
			Dir = 3;
			switch (data[0]) {
				case 'R': Dir = 0;
				case 'D': Dir = 1;
				case 'L': Dir = 2;
			}
			int index = data.IndexOf(' ', 2);
			Length = data.Substring(2, index - 2).ToInt();
			TrueDir = data[data.Length - 2] - '0';
			TrueLength = int64.Parse(data.Substring(index + 3, data.Length - 5 - index), NumberStyles.HexNumber);
		}
		public override void ToString(String output)
		{
			output.Append(scope $"{Dir},{Length},{TrueDir},{TrueLength}");
		}
	}
}