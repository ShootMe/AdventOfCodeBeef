using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day23 : IDay
{
	private HashSet<Node> maxClique = new .() ~ delete _;
	private List<Node> nodes = new .() ~ DeleteContainerAndItems!(_);
	public void Solve(StringView input, String output)
	{
		ParseInput(input);

		int total = 0;
		for (int i = 0; i < nodes.Count; i++)
		{
			Node node1 = nodes[i];
			bool hasT1 = node1.Name[0] == 't';

			for (int j = 0; j < node1.Connections.Count; j++)
			{
				Node node2 = node1.Connections[j];
				bool hasT2 = node2.Name[0] == 't';

				for (int k = 0; k < node2.Connections.Count; k++)
				{
					Node node3 = node2.Connections[k];
					if (node3 == node1) { continue; }

					if (!hasT1 && !hasT2 && node3.Name[0] != 't') { continue; }

					for (int m = 0; m < node3.Connections.Count; m++)
					{
						Node node4 = node3.Connections[m];
						if (node4 == node1)
						{
							total++;
							break;
						}
					}
				}
			}
		}

		for (int i = 0; i < nodes.Count; i++)
		{
			Node node = nodes[i];
			Find(node, scope .(), scope .());
		}

		List<Node> list = scope .(maxClique.GetEnumerator());
		list.Sort();
		String sb = scope .();
		for (int i = 0; i < list.Count; i++)
		{
			sb.Append(list[i].Name);
			sb.Append(',');
		}
		sb.Length--;

		output.Append(scope $"{total / 6}\n{sb}");
	}
	private void Find(Node node, HashSet<Node> set, HashSet<Node> exc)
	{
		List<Node> connections = node.Connections;
		int count = 0;
		for (int i = 0; i < connections.Count && count < set.Count; i++)
		{
			Node connection = connections[i];
			if (set.Contains(connection)) { count++; }
		}

		if (count == set.Count)
		{
			set.Add(node);
			exc.Add(node);
			if (set.Count > maxClique.Count)
			{
				maxClique.Clear();
				for(Node item in set) {
					maxClique.Add(item);
				}
			}

			for (int i = 0; i < connections.Count; i++)
			{
				Node connection = connections[i];
				if (!exc.Contains(connection))
				{
					Find(connection, set, exc);
				}
			}
			set.Remove(node);
		}
	}
	private void ParseInput(StringView input)
	{
		Dictionary<StringView, Node> nodesByName = scope .();
		List<StringView> lines = scope .();
		input.Parse(scope (item) => lines.Add(item));

		for (StringView line in lines)
		{
			int index = line.IndexOf('-');
			StringView name = line.Substring(0, index);

			Node node;
			if (!nodesByName.TryGetValue(name, out node))
			{
				node = new Node(nodes.Count, name);
				nodesByName.Add(node.Name, node);
				nodes.Add(node);
			}

			StringView other = line.Substring(index + 1);
			Node otherNode;
			if (!nodesByName.TryGetValue(other, out otherNode))
			{
				otherNode = new Node(nodes.Count, other);
				nodesByName.Add(otherNode.Name, otherNode);
				nodes.Add(otherNode);
			}

			node.Connections.Add(otherNode);
			otherNode.Connections.Add(node);
		}
		nodes.Sort();
	}
	private class Node : IHashable
	{
		public int ID;
		public StringView Name;
		public List<Node> Connections = new .() ~ delete _;
		public this(int id, StringView name) { ID = id; Name = name; }
		public static int operator <=>(Node left, Node right) { int comp = left.Connections.Count <=> right.Connections.Count; if (comp != 0) { return comp; } return left.Name <=> right.Name; }
		public static bool operator ==(Node left, Node right) { return left.ID == right.ID; }
		public static bool operator !=(Node left, Node right) { return left.ID != right.ID; }
		public int GetHashCode() { return ID; }
	}
}