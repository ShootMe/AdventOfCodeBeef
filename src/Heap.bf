using System;
namespace System.Collections;
class Heap<T> where int : operator T <=> T
{
	private int size;
	private T[] nodes ~ delete _;

	public this() : this(1000) { }
	public this(int maxNodes)
	{
		size = 0;
		nodes = new T[maxNodes];
	}
	public int Count { [Inline] get { return size; } }
	[Inline]
	public void Clear() { size = 0; }
	[Optimize]
	public void Add(T node)
	{
		if (size == nodes.Count) { Resize(); }

		int current = size++;
		while (current > 0)
		{
			int child = current;
			current = (current - 1) >> 1;
			T value = nodes[current];
			if ((node <=> value) >= 0)
			{
				current = child;
				break;
			}

			nodes[child] = value;
		}

		nodes[current] = node;
	}
	[Optimize]
	public T Pop()
	{
		T result = nodes[0];
		int current = 0;
		T end = nodes[--size];

		repeat
		{
			int last = current;
			int child = (current << 1) + 1;

			if (size > child && (end <=> nodes[child]) > 0)
			{
				current = child;

				if (size > ++child && (nodes[current] <=> nodes[child]) > 0)
				{
					current = child;
				}
			} else if (size > ++child && (end <=> nodes[child]) > 0)
			{
				current = child;
			} else
			{
				break;
			}

			nodes[last] = nodes[current];
		} while (true);

		nodes[current] = end;

		return result;
	}
	private void Resize()
	{
		T[] newNodes = new T[(int)(nodes.Count * 1.5)];
		Array.Copy(nodes, newNodes, nodes.Count);
		delete nodes;
		nodes = newNodes;
	}
}