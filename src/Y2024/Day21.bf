using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day21 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.Parse(scope (item) => lines.Add(item));

		Dictionary<char8, (int, int)> numpad = scope .()
			{
				('7', (0, 0)), ('8', (1, 0)), ('9', (2, 0)),
				('4', (0, 1)), ('5', (1, 1)), ('6', (2, 1)),
				('1', (0, 2)), ('2', (1, 2)), ('3', (2, 2)),
				('^', (1, 3)), ('0', (1, 3)), ('A', (2, 3)),
				('<', (0, 4)), ('v', (1, 4)), ('>', (2, 4))
			};
		Dictionary<int, int> cache = new .();
		defer delete cache;

		int Translate(StringView data, int chain) {
		    int moves = 0;
		    char8 last = 'A';
		    for (int i = 0; i < data.Length; i++) {
		        char8 next = data[i];
		        moves += Translate(last, next, chain);
		        last = next;
		    }
		    return moves * data.ToInt();
		}
		int Translate(char8 last, char8 next, int level) {
		    if (level == 0) { return 1; }
			int best;
			int key = ((int)last << 13) | ((int)next << 5) | level;
		    if (cache.TryGetValue(key, out best)) { return best; }

		    (int x0, int y0) = numpad[last];
		    (int x1, int y1) = numpad[next];
		    int dY = y1 - y0; int dX = x1 - x0;
		    best = int.MaxValue;

		    if (x0 != 0 || y1 != 3) {
		        best = 0; char8 lastPos = 'A';
		        while (dY < 0) { best += Translate(lastPos, '^', level - 1); lastPos = '^'; dY++; }
		        while (dY > 0) { best += Translate(lastPos, 'v', level - 1); lastPos = 'v'; dY--; }
		        while (dX < 0) { best += Translate(lastPos, '<', level - 1); lastPos = '<'; dX++; }
		        while (dX > 0) { best += Translate(lastPos, '>', level - 1); lastPos = '>'; dX--; }
		        best += Translate(lastPos, 'A', level - 1);
		    }

		    if (y0 != 3 || x1 != 0) {
		        dY = y1 - y0; dX = x1 - x0;
		        int moves = 0; char8 lastPos = 'A';
		        while (dX < 0) { moves += Translate(lastPos, '<', level - 1); lastPos = '<'; dX++; }
		        while (dX > 0) { moves += Translate(lastPos, '>', level - 1); lastPos = '>'; dX--; }
		        while (dY < 0) { moves += Translate(lastPos, '^', level - 1); lastPos = '^'; dY++; }
		        while (dY > 0) { moves += Translate(lastPos, 'v', level - 1); lastPos = 'v'; dY--; }
		        moves += Translate(lastPos, 'A', level - 1);
		        if (moves < best) { best = moves; }
		    }

		    cache.Add(key, best);
		    return best;
		}

		int total1 = 0, total2 = 0;
		for (StringView line in lines) {
		    total1 += Translate(line, 3);
			total2 += Translate(line, 26);
		}

		output.Append(scope $"{total1}\n{total2}");
	}
}