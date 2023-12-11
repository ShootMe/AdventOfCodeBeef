using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day02 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total1 = 0;
		int total2 = 0;
		for (StringView line in input.Split('\n'))
		{
			Game game = .(line);
			if (game.IsValid(12, 13, 14))
			{
				total1 += game.ID;
			}
			total2 += game.Power();
		}

		output.Append(scope $"{total1}\n{total2}");
	}

	private struct Game
	{
		private static StringView[] splits = new StringView[](", ", "; ") ~ delete _;
		public int32 ID, Red, Green, Blue;

		public this(StringView game)
		{
			int idIndex = game.IndexOf(':');
			ID = (.)game[5... idIndex].ToInt();
			Red = 0;
			Green = 0;
			Blue = 0;
			for (StringView cube in game[idIndex + 2 ... ^1].Split(splits, StringSplitOptions.RemoveEmptyEntries))
			{
				int index = cube.IndexOf(' ');
				int32 amount = (.)cube[0 ... index].ToInt();
				StringView color = cube[index + 1 ... ^1];
				switch (color) {
					case "red": if (Red < amount) { Red = amount; } break;
					case "green": if (Green < amount) { Green = amount; } break;
					case "blue": if (Blue < amount) { Blue = amount; } break;
				}
			}
		}
		public bool IsValid(int32 redCount, int32 greenCount, int32 blueCount)
		{
			return Red <= redCount && Green <= greenCount && Blue <= blueCount;
		}
		public int32 Power()
		{
			return Red * Green * Blue;
		}
		public override void ToString(String buffer)
		{
			buffer.Append(scope $"{ID}={Red},{Green},{Blue}");
		}
	}
}