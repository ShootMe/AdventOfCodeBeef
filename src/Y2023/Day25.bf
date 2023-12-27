using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day25 : IDay
{
	private List<Node> nodes = new .() ~ DeleteContainerAndItems!(_);
	public void Solve(StringView input, String output)
	{
		ParseInput(input);

		HashSet<Wire> used = scope .(nodes.Count);
		HashSet<Node> closed = scope .(nodes.Count);
		Queue<Node> open = scope .(nodes.Count);
		Dictionary<Node, (Node, Wire)> paths = scope .();
		Node node1 = nodes[^1];

		int FindPath(Node node2)
		{
			closed.Clear();
			open.Clear();
			paths.Clear();
			open.Add(node1);
			closed.Add(node1);

			while (open.Count > 0)
			{
				Node current = open.PopFront();
				if (current == node2)
				{
					while (current != node1)
					{
						(current, Wire last) = paths[current];
						used.Add(last);
					}
					return 0;
				}

				for (int i = 0; i < current.Wires.Count; i++)
				{
					Wire wire = current.Wires[i];
					if (used.Contains(wire)) { continue; }

					Node next = wire.Left;
					if (wire.Left == current) { next = wire.Right; }

					if (closed.Add(next))
					{
						open.Add(next);
						paths.Add(next, (current, wire));
					}
				}
			}

			return closed.Count;
		}

		for (int i = 0; i < nodes.Count; i++)
		{
			Node node2 = nodes[i];
			used.Clear();
			int size;
			if (FindPath(node2) == 0 &&
				FindPath(node2) == 0 &&
				FindPath(node2) == 0 &&
				(size = FindPath(node2)) > 0)
			{
				output.Append(scope $"{size * (nodes.Count - size)}");
				return;
			}
		}
	}
	private void ParseInput(StringView input)
	{
		Dictionary<StringView, Node> nodesByName = scope .();
		int count = 0;
		List<StringView> lines = scope .();
		input.ToLines(lines);

		for (StringView line in lines)
		{
			int index = line.IndexOf(':');
			StringView name = line.Substring(0, index);

			Node node;
			if (!nodesByName.TryGetValue(name, out node))
			{
				node = new Node(nodes.Count, name);
				nodesByName.Add(node.Name, node);
				nodes.Add(node);
			}

			int start = index + 2;
			while (start < line.Length)
			{
				index = line.IndexOf(' ', start);
				if (index < 0) { index = line.Length; }

				StringView other = line.Substring(start, index - start);
				start = index + 1;

				Node otherNode;
				if (!nodesByName.TryGetValue(other, out otherNode))
				{
					otherNode = new Node(nodes.Count, other);
					nodesByName.Add(otherNode.Name, otherNode);
					nodes.Add(otherNode);
				}

				Wire wire = .(count++, node, otherNode);
				node.Wires.Add(wire);
				otherNode.Wires.Add(wire);
			}
		}
		nodes.Sort();
	}
	private struct Wire : IHashable
	{
		public int ID;
		public Node Left, Right;
		public this(int id, Node left, Node right)
		{
			ID = id;
			int comp = left.Name.CompareTo(right.Name);
			Left = comp < 0 ? left : right;
			Right = comp < 0 ? right : left;
		}
		[Inline]
		public static int operator <=>(Wire left, Wire right) { return left.Left.Name.CompareTo(right.Left.Name); }
		[Inline]
		public static bool operator ==(Wire left, Wire right) { return left.ID == right.ID; }
		[Inline]
		public static bool operator !=(Wire left, Wire right) { return left.ID != right.ID; }
		[Inline]
		public int GetHashCode() { return ID; }
	}
	private class Node : IHashable
	{
		public int ID;
		public StringView Name;
		public List<Wire> Wires = new .() ~ delete _;
		public this(int id, StringView name) { ID = id; Name = name; }
		[Inline]
		public static int operator <=>(Node left, Node right) { return left.Wires.Count <=> right.Wires.Count; }
		[Inline]
		public static bool operator ==(Node left, Node right) { return left.ID == right.ID; }
		[Inline]
		public static bool operator !=(Node left, Node right) { return left.ID != right.ID; }
		[Inline]
		public int GetHashCode() { return ID; }
	}
}