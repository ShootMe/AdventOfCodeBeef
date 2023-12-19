using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day19 : IDay
{
	private Dictionary<StringView, WorkFlow> flows = new .() ~ delete _;

	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		int i = 0;
		for (; i < lines.Count; i++)
		{
			StringView line = lines[i];
			if (line.Length <= 0) { break; }

			WorkFlow flow = .(line);
			flows.Add(flow.Name, flow);
		}

		List<StringView> splits = scope .();
		i++;
		int sum = 0;
		for (; i < lines.Count; i++)
		{
			StringView data = lines[i];
			data.SplitOn(splits, "{x=", ",m=", ",a=", ",s=", "}");
			int x = splits[0].ToInt(); int m = splits[1].ToInt(); int a = splits[2].ToInt(); int s = splits[3].ToInt();

			StringView result = "in";
			while (result != "A" && result != "R")
			{
				WorkFlow flow = flows[result];
				for (int j = 0; j < flow.Count; j++)
				{
					Condition condition = flow.Conditions[j];
					if (condition.Operator == .None) { result = condition.Result; break; }

					int value = x;
					switch (condition.Field) {
						case 'm': value = m;
						case 'a': value = a;
						case 's': value = s;
					}

					if (condition.Operator == .LessThan && value < condition.Amount) { result = condition.Result; break; }
					if (condition.Operator == .GreaterThan && value > condition.Amount) { result = condition.Result; break; }
				}
			}

			if (result == "A") { sum += x + m + a + s; }
		}

		output.Append(scope $"{sum}\n{CountAccepted()}");
	}

	private int CountAccepted()
	{
		List<(StringView, int, int, int, int, int, int, int, int)> open = scope .(50);
		open.Add(("in", 1, 4000, 1, 4000, 1, 4000, 1, 4000));
		int total = 0;
		while (open.Count > 0)
		{
			(StringView result, int x, int xe, int m, int me, int a, int ae, int s, int se) = open.PopBack();
			if (result == "A")
			{
				total += (xe - x + 1) * (me - m + 1) * (ae - a + 1) * (se - s + 1);
				continue;
			} else if (result == "R")
			{
				continue;
			}

			WorkFlow flow = flows[result];
			for (int j = 0; j < flow.Count; j++)
			{
				Condition condition = flow.Conditions[j];
				if (condition.Operator == .None)
				{
					open.Add((condition.Result, x, xe, m, me, a, ae, s, se));
					break;
				}

				int value = x;
				int valueE = xe;
				switch (condition.Field) {
					case 'm': value = m; valueE = me;
					case 'a': value = a; valueE = ae;
					case 's': value = s; valueE = se;
				}

				if (condition.Operator == .LessThan)
				{
					if (valueE < condition.Amount)
					{
						open.Add((condition.Result, x, xe, m, me, a, ae, s, se));
						break;
					}
					if (value < condition.Amount)
					{
						switch (condition.Field) {
							case 'x': open.Add((condition.Result, x, condition.Amount - 1, m, me, a, ae, s, se)); x = condition.Amount;
							case 'm': open.Add((condition.Result, x, xe, m, condition.Amount - 1, a, ae, s, se)); m = condition.Amount;
							case 'a': open.Add((condition.Result, x, xe, m, me, a, condition.Amount - 1, s, se)); a = condition.Amount;
							case 's': open.Add((condition.Result, x, xe, m, me, a, ae, s, condition.Amount - 1)); s = condition.Amount;
						}
					}
				} else if (condition.Operator == .GreaterThan)
				{
					if (value > condition.Amount)
					{
						open.Add((condition.Result, x, xe, m, me, a, ae, s, se));
						break;
					}
					if (valueE > condition.Amount)
					{
						switch (condition.Field) {
							case 'x': open.Add((condition.Result, condition.Amount + 1, xe, m, me, a, ae, s, se)); xe = condition.Amount;
							case 'm': open.Add((condition.Result, x, xe, condition.Amount + 1, me, a, ae, s, se)); me = condition.Amount;
							case 'a': open.Add((condition.Result, x, xe, m, me, condition.Amount + 1, ae, s, se)); ae = condition.Amount;
							case 's': open.Add((condition.Result, x, xe, m, me, a, ae, condition.Amount + 1, se)); se = condition.Amount;
						}
					}
				}
			}
		}
		return total;
	}

	private struct WorkFlow
	{
		public StringView Name;
		public Condition[4] Conditions;
		public int Count;

		public this(StringView line)
		{
			int index = line.IndexOf('{');
			Name = line.Substring(0, index);
			int lastIndex = index;
			Conditions = default;
			Count = 0;
			while ((index = line.IndexOf(',', index + 1)) > 0)
			{
				Conditions[Count++] = .(line.Substring(lastIndex + 1, index - lastIndex - 1));
				lastIndex = index;
			}
			Conditions[Count++] = .(line.Substring(lastIndex + 1, line.Length - lastIndex - 2));
		}
		public override void ToString(String output)
		{
			output.Append(Name);
			for (int i = 0; i < Count; i++)
			{
				output.Append(scope $"({Conditions[i]})");
			}
		}
	}
	private struct Condition
	{
		public char8 Field;
		public int Amount;
		public OpType Operator;
		public StringView Result;
		public this(StringView data)
		{
			Field = default;
			Amount = 0;
			Operator = OpType.None;
			Result = data;
			char8 op = data.Length > 1 ? data[1] : '\0';
			if (op == '>')
			{
				Operator = OpType.GreaterThan;
			} else if (op == '<')
			{
				Operator = OpType.LessThan;
			}

			if (Operator != OpType.None)
			{
				Field = data[0];
				int successIndex = data.IndexOf(':');
				Amount = data.Substring(2, successIndex - 2).ToInt();
				Result = data.Substring(successIndex + 1);
			}
		}
		public override void ToString(String output)
		{
			if (Operator == OpType.None)
			{
				output.Append(scope $"{Result}");
			} else if (Operator == OpType.GreaterThan)
			{
				output.Append(scope $"{Field} > {Amount} = {Result}");
			} else
			{
				output.Append(scope $"{Field} < {Amount} = {Result}");
			}
		}
	}
	private enum OpType
	{
		None,
		LessThan,
		GreaterThan
	}
}