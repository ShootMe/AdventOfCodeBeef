using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day08 : IDay
{
	private struct Vector2 : IHashable
	{
		public int X, Y;
		public int GetHashCode() => HashCode.Generate(this);
		public this(int x, int y)
		{
			X = x; Y = y;
		}
	}
	public void Solve(StringView input, String output)
	{
		Dictionary<char8, List<(int, int)>> nodes = new .();
		defer { DeleteDictionaryAndValues!(nodes); }

		int height = 0, width = 0;
		input.Parse(scope [&] (line) =>
			{
				for (width = 0; width < line.Length; width++)
				{
					char8 c = line[width];
					if (c != '.')
					{
						List<(int, int)> list;
						if (!nodes.TryGetValue(c, out list))
						{
							list = new .();
							nodes.Add(c, list);
						}
						list.Add((width, height));
					}
				}
				height++;
			});


		HashSet<Vector2> antiNodes = scope .();
		int CountAntiNodes(bool addResonant)
		{
			void MarkUnique(int x, int diffX, int y, int diffY)
			{
				var x, y;
				while (x >= 0 && x < width && y >= 0 && y < height)
				{
					antiNodes.Add(.(x, y));
					x -= diffX; y -= diffY;
				}
			}
			for (var pair in nodes)
			{
				List<(int, int)> node = pair.value;
				for (int i = 0; i < node.Count; i++)
				{
					(int x1, int y1) = node[i];
					for (int j = i + 1; j < node.Count; j++)
					{
						(int x2, int y2) = node[j];
						if (addResonant)
						{
							MarkUnique(x1, x2 - x1, y1, y2 - y1);
							MarkUnique(x2, x1 - x2, y2, y1 - y2);
						} else
						{
							MarkUnique(x1 - (x2 - x1), width, y1 - (y2 - y1), height);
							MarkUnique(x2 - (x1 - x2), width, y2 - (y1 - y2), height);
						}
					}
				}
			}
			return antiNodes.Count;
		}

		output.Append(scope $"{CountAntiNodes(false)}\n{CountAntiNodes(true)}");
	}
}