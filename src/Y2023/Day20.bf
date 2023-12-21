using System;
using System.Collections;
namespace AdventOfCode.Y2023;

class Day20 : IDay
{
	private	Dictionary<StringView, Module> modules = new .() ~ DeleteDictionaryAndValues!(_);
	public void Solve(StringView input, String output)
	{
		List<StringView> lines = scope .();
		input.ToLines(lines);

		for (StringView line in lines)
		{
			ParseLine(line);
		}
		for (StringView line in lines)
		{
			ParseLine(line);
		}

		for (Module module in modules.Values)
		{
			module.Reset();
		}

		int totalHigh = 0; int totalLow = 0;
		Queue<(Module, Module)> pulses = scope .();
		Module broadcaster = modules["broadcaster"];
		for (int i = 0; i < 1000; i++)
		{
			pulses.Add((broadcaster, broadcaster));
			while (pulses.Count > 0)
			{
				(Module sender, Module current) = pulses.PopFront();
				if (sender.LastOutput) { totalHigh++; } else { totalLow++; }
				current.Pulse(pulses, sender);
			}
		}

		for (Module module in modules.Values)
		{
			module.Reset();
		}

		Module rxIns = modules["rx"].Inputs[0];
		Dictionary<int, int> states = scope .();
		for (int i = 0; i < rxIns.Inputs.Count; i++)
		{
			states[rxIns.Inputs[i].ID] = 0;
		}

		int presses = 0;
		while (true)
		{
			presses++;
			pulses.Add((broadcaster, broadcaster));
			while (pulses.Count > 0)
			{
				(Module sender, Module current) = pulses.PopFront();
				int lastPresses;
				if (sender.LastOutput && states.TryGetValue(sender.ID, out lastPresses) && presses > lastPresses)
				{
					states[sender.ID] = presses - lastPresses;

					int total = 1;
					for (int value in states.Values)
					{
						if (value == 0) { total = 0; break; }
						total *= value / value.GCD(total);
					}

					if (total > 0)
					{
						output.Append(scope $"{totalHigh*totalLow}\n{total}");
						return;
					}
				}
				current.Pulse(pulses, sender);
			}
		}
	}
	private void ParseLine(StringView line)
	{
		int type = line[0] == '%' ? 1 : line[0] == '&' ? 2 : 0;
		int start = type > 0 ? 1 : 0;
		int index = line.IndexOf(" -> ");
		StringView name = line.Substring(start, index - start);

		Module module;
		if (modules.TryGetValue(name, out module))
		{
			StringView outputs = line.Substring(index + 4);
			start = 0;
			while ((index = outputs.IndexOf(", ", start)) > 0)
			{
				name = outputs.Substring(start, index - start);
				AddOutput(module, name);
				start = index + 2;
			}
			name = outputs.Substring(start, outputs.Length - start);
			AddOutput(module, name);
		} else
		{
			if (type == 0)
			{
				module = new Module(name);
			} else if (type == 1)
			{
				module = new FlipFlop(name);
			} else
			{
				module = new Conjunction(name);
			}
			modules.Add(name, module);
		}
	}
	private void AddOutput(Module module, StringView name)
	{
		Module output;
		if (!modules.TryGetValue(name, out output))
		{
			output = new Module(name);
			modules.Add(name, output);
		}
		output.Inputs.Add(module);
		module.Outputs.Add(output);
	}
	private class Module
	{
		private static int idCounter = 0;
		public int ID;
		public StringView Name;
		public bool LastOutput;
		public List<Module> Inputs = new .() ~ delete _;
		public List<Module> Outputs = new .() ~ delete _;
		public this(StringView name) { Name = name; ID = ++idCounter; }
		public virtual void Pulse(Queue<(Module, Module)> pulses, Module sender)
		{
			for (int i = 0; i < Outputs.Count; i++)
			{
				pulses.Add((this, Outputs[i]));
			}
		}
		public virtual void Reset() { LastOutput = false; }
	}
	private class FlipFlop : Module
	{
		public this(StringView name) : base(name) { }
		public override void Pulse(Queue<(Module, Module)> pulses, Module sender)
		{
			if (sender.LastOutput) { return; }

			for (int i = 0; i < Outputs.Count; i++)
			{
				pulses.Add((this, Outputs[i]));
			}
			LastOutput = !LastOutput;
		}
	}
	private class Conjunction : Module
	{
		public this(StringView name) : base(name) { }
		public override void Pulse(Queue<(Module, Module)> pulses, Module sender)
		{
			bool state = true;
			for (int i = 0; i < Inputs.Count && state; i++)
			{
				state &= Inputs[i].LastOutput;
			}

			for (int i = 0; i < Outputs.Count; i++)
			{
				pulses.Add((this, Outputs[i]));
			}
			LastOutput = !state;
		}
	}
}