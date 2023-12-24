using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day23 : IDay
{
	private int width, height;
	private char8[,] grid ~ delete _;
	private HashSet<Node> nodes = new .() ~ DeleteContainerAndItems!(_);
	private Node startNode;

	public void Solve(StringView input, String output)
	{
		ParseInput(input);
		output.Append(scope $"{FindLongestPath(true)}\n{FindLongestPath(false)}");
	}
	private void ParseInput(StringView input)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		width = (.)lines[0].Length;
		height = (.)lines.Count;
		grid = new .[height, width];

		for (int y = 0; y < height; y++)
		{
			StringView line = lines[y];
			for (int x = 0; x < width; x++)
			{
				grid[y, x] = line[x];
			}
		}
		GenerateGraph();
	}
	private int FindLongestPath(bool original)
	{
		bool[] used = scope .[nodes.Count + 1];
		used[startNode.ID] = true;

		const int[5] dirD = .(0, 1, 0, -1, 0);
		const char8[4] dirC = .('>', 'v', '<', '^');
		List<(Node, int)> open = scope .();

		for (int i = 0; i < 4; i++)
		{
			(Node node, int length) = startNode.Connections[i];
			if (node == null) { continue; }
			open.Add((node, length));
		}

		int max = 0;
		while (open.Count > 0)
		{
			(Node node, int total) = open.PopBack();

			if (total >= 0)
			{
				used[node.ID] = true;
				open.Add((node, -1));

				for (int i = 0; i < 4; i++)
				{
					if (original)
					{
						char8 c = grid[node.Y - dirD[i], node.X - dirD[i + 1]];
						if (c == dirC[i]) { continue; }
					}

					(Node next, int length) = node.Connections[i];
					if (next == null || used[next.ID]) { continue; }
					if (next.Y == height - 1)
					{
						if (total + length > max) { max = total + length; }
						continue;
					}
					open.Add((next, total + length));
				}
			} else
			{
				used[node.ID] = false;
			}
		}
		return max;
	}
	private void GenerateGraph()
	{
		int[,] gridMoves = scope .[height, width];
		Queue<(Node, int)> open = scope .();
		startNode = new Node(1, 1, 0);
		open.Add((startNode, 1));
		List<(int, int, int)> adjacent = scope .();
		nodes.Add(startNode);

		void AddAdjacent(int dir, int x, int y, Node node)
		{
			if (x < 0 || y < 0 || x >= width || y >= height || grid[y, x] == '#' || gridMoves[y, x] == node.ID) { return; }
			adjacent.Add((x, y, dir));
			gridMoves[y, x] = node.ID;
		}

		const int[5] dirD = .(0, 1, 0, -1, 0);
		int nextNode = 2;
		while (open.Count > 0)
		{
			(Node node, int dir) = open.PopFront();
			if (node.Connections[(dir + 2) & 3].Length > 0) { continue; }

			gridMoves[node.Y, node.X] = node.ID;

			int x = node.X + dirD[dir + 1];
			int y = node.Y + dirD[dir];
			gridMoves[y, x] = node.ID;
			int length = 1; int dirS = dir;

			while (true)
			{
				adjacent.Clear();
				AddAdjacent(0, x + 1, y, node);
				AddAdjacent(1, x, y + 1, node);
				AddAdjacent(2, x - 1, y, node);
				AddAdjacent(3, x, y - 1, node);
				if (adjacent.Count == 1)
				{
					(x, y, dir) = adjacent[0];
					length++;
					continue;
				}
				break;
			}

			if (adjacent.Count > 0)
			{
				Node newNode = new Node(nextNode, x, y);
				Node* outNode;
				bool addMore = true;
				if (nodes.Add(newNode, out outNode))
				{
					node.Connections[(dirS + 2) & 3] = (newNode, length);
					newNode.Connections[dir] = (node, length);
					nextNode++;
				} else
				{
					delete newNode;
					newNode = *outNode;
					newNode.Connections[dir] = (node, length);
					node.Connections[(dirS + 2) & 3] = (newNode, length);
					addMore = false;
				}

				for (int i = adjacent.Count - 1; i >= 0; i--)
				{
					(x, y, dir) = adjacent[i];
					gridMoves[y, x] = 0;
					if (addMore) { open.Add((newNode, dir)); }
				}
			} else if (y == height - 1)
			{
				Node end = new Node(nextNode, x, y);
				nodes.Add(end);
				end.Connections[dir] = (node, length);
				node.Connections[(dirS + 2) & 3] = (end, length);
				continue;
			}
		}
	}
	private class Node : IHashable
	{
		public int ID, X, Y;
		public (Node Node, int Length)[4] Connections;
		public this(int id, int x, int y) { ID = id; X = x; Y = y; Connections = default; }
		public int GetHashCode() { return X * 999 + Y; }
		public static bool operator ==(Node left, Node right) { return left.X == right.X && left.Y == right.Y; }
	}
}