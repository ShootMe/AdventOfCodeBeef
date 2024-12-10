using System;
using System.Collections;
namespace AdventOfCode.Y2023;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day08 : IDay
{
	private StringView directions;

	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		List<StringView> startNodes = scope .();
		directions = lines[0];
		Dictionary<StringView, Node> allNodes = scope .();
		for (int i = 2; i < lines.Count; i++)
		{
			StringView line = lines[i];
			int index = line.IndexOf(' ');
			StringView name = line[0 ... index - 1];
			Node node = .(name);
			if (node.Type == NodeType.Start)
			{
				if (node.Name == "AAA")
				{
					startNodes.Insert(0, name);
				} else
				{
					startNodes.Add(name);
				}
			}
			allNodes.Add(name, node);
		}

		List<StringView> splits = scope .();
		for (int i = 2; i < lines.Count; i++)
		{
			StringView line = lines[i];
			line.SplitOn(splits, " = (", ", ", ")");
			ref Node node = ref allNodes[splits[0]];
			node.Left = &allNodes[splits[1]];
			node.Right = &allNodes[splits[2]];
		}

		int total = 1;
		for (int i = 0; i < startNodes.Count; i++) {
		    Node node = allNodes[startNodes[i]];
		    int steps = GetStepCount(node, true);
		    total *= steps / total.GCD(steps);
		}

		output.Append(scope $"{GetStepCount(allNodes[startNodes[0]])}\n{total}");
	}
	private int GetStepCount(Node node, bool endsInZ = false)
	{
		var node;
		int total = 0;
		int index = 0;
		while (true)
		{
			char8 c = directions[index++];
			total++;
			switch (c) {
				case 'R': node = *node.Right; break;
				case 'L': node = *node.Left; break;
			}
			if ((!endsInZ && node.Name == "ZZZ") || (endsInZ && node.Type == NodeType.End)) { break; }
			if (index >= directions.Length) { index = 0; }
		}
		return total;
	}
	private struct Node
	{
		public StringView Name;
		public Node* Left, Right;
		public NodeType Type;

		public this(StringView name)
		{
			Name = name;
			Left = null;
			Right = null;
			Type = name.EndsWith('A') ? NodeType.Start : name.EndsWith('Z') ? NodeType.End : NodeType.Normal;
		}
	}
	private enum NodeType
	{
		Start,
		Normal,
		End
	}
}