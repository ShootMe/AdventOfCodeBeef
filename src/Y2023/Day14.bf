using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day14 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		int width = lines[0].Length;
		int height = lines.Count;
		char8[] grid = scope .[height * width];
		int load = 0;

		for (int y = 0, index = 0; y < height; y++)
		{
			StringView line = lines[y];
			for (int x = 0; x < width; x++)
			{
				grid[index++] = line[x];
				if (line[x] == 'O')
				{
					load += height - y;
				}
			}
		}

		void TiltNorth()
		{
			for (int x = 0; x < width; x++)
			{
				int minIndex = x;
				for (int y = x; y < grid.Count; y += width)
				{
					char8 c = grid[y];
					if (c != 'O')
					{
						if (c == '#') { minIndex = y + width; }
						continue;
					}

					if (y > minIndex)
					{
						grid[minIndex] = 'O';
						grid[y] = '.';
						load += (y - minIndex) / width;
					}
					minIndex += width;
				}
			}
		}
		void TiltWest()
		{
			for (int index = 0; index < grid.Count;)
			{
				int minIndex = index;
				for (int maxIndex = index + width; index < maxIndex; index++)
				{
					char8 c = grid[index];
					if (c != 'O')
					{
						if (c == '#') { minIndex = index + 1; }
						continue;
					}

					if (index > minIndex)
					{
						grid[minIndex] = 'O';
						grid[index] = '.';
					}
					minIndex++;
				}
			}
		}
		void TiltSouth()
		{
			for (int x = 0; x < width; x++)
			{
				int maxIndex = grid.Count - width + x;
				for (int y = maxIndex; y >= 0; y -= width)
				{
					char8 c = grid[y];
					if (c != 'O')
					{
						if (c == '#') { maxIndex = y - width; }
						continue;
					}

					if (y < maxIndex)
					{
						grid[maxIndex] = 'O';
						grid[y] = '.';
						load += (y - maxIndex) / width;
					}
					maxIndex -= width;
				}
			}
		}
		void TiltEast()
		{
			for (int index = grid.Count - 1; index >= 0;)
			{
				int maxIndex = index;
				for (int minIndex = index - width; index > minIndex; index--)
				{
					char8 c = grid[index];
					if (c != 'O')
					{
						if (c == '#') { maxIndex = index - 1; }
						continue;
					}

					if (index < maxIndex)
					{
						grid[maxIndex] = 'O';
						grid[index] = '.';
					}
					maxIndex--;
				}
			}
		}

		TiltNorth();
		int load1 = load;

		TiltWest();
		TiltSouth();
		TiltEast();

		List<int> loads = scope .();
		loads.Add(load);
		for (int i = 1; i < 1000000000; i++)
		{
			TiltNorth();
			TiltWest();
			TiltSouth();
			TiltEast();
			loads.Add(load);

			(int position, int length) = FindSequence(loads);
			if (position >= 0)
			{
				int leftOver = (1000000000 - position) % length;
				output.Append(scope $"{load1}\n{loads[position + leftOver - 1]}");
				return;
			}
		}
	}
	private (int index, int length) FindSequence(List<int> loads)
	{
		int lastIndex = loads.Count - 1;
		int minIndex = loads.Count / 2 - 1;
		for (int i = lastIndex - 5; i >= minIndex; i--)
		{
			int index = lastIndex;
			int newIndex = i;
			while (index > i && loads[index--] == loads[newIndex--]) { }
			if (index == i) { return (i, lastIndex - index); }
		}

		return (-1, 0);
	}
}