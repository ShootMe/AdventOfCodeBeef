using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day17 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> program = scope .(30);
		input.ExtractInts(program);

		int[20] outValues = default;
		for (int i = 0; i < 20; i++) { outValues[i] = -1; }

		bool RunProgram(int a, bool checkOut = false)
		{
			var a;
			int b = program[1], c = program[2];

			int index = 3;
			for (int i = 3; i < program.Count; i += 2)
			{
				int opcode = program[i];
				int valueLit = program[i + 1];
				int valueCombo = valueLit;
				switch (valueCombo) {
					case 4: valueCombo = a; break;
					case 5: valueCombo = b; break;
					case 6: valueCombo = c; break;
				}
				switch (opcode) {
					case 0: a >>= (int)valueCombo; break;
					case 1: b ^= valueLit; break;
					case 2: b = valueCombo & 7; break;
					case 3: i = a != 0 ? valueLit + 1 : i; break;
					case 4: b ^= c; break;
					case 5:
						outValues[index] = valueCombo & 7;
						if (checkOut && program[index] != (valueCombo & 7))
						{
							return false;
						}
						index++;
						break;
					case 6: b = a >> (int)valueCombo; break;
					case 7: c = a >> (int)valueCombo; break;
				}
			}
			return index == program.Count;
		}

		RunProgram(program[0]);
		for (int i = 3; i < 20 && outValues[i] >= 0; i++)
		{
			if (i != 3) { output.Append(','); }
			output.Append(outValues[i]);
		}

		int RunComp() {
		    int a = 0;
		    int start = 0;
		    int digit = program.Count - 1;
		    while (digit >= 3 && digit < program.Count) {
		        int index = 0;
		        for (int i = start; i < 8; i++) {
		            index = digit;
		            int tempA = a | i;
		            int b = 0;
		            while (index < program.Count) {
		                b = (tempA & 7) ^ 6; //2,4,1,6
		                b ^= (tempA >> b) ^ 7; //7,5,4,4,1,7
		                tempA >>= 3;   //0,3
		                if (program[index] != (b & 7)) { break; }//5,5,3,0
		                index++;
		            }
		            if (index == program.Count) {
		                a = (a | i) << 3;
		                digit--;
		                start = 0;
		                break;
		            }
		        }
		        if (index != program.Count) {
		            repeat {
		                a >>= 3;
		                start = (a & 7) + 1;
		                a &= ~0x7;
		                digit++;
		            } while (start == 8);
		        }
		    }
		    return a >> 3;
		}

		output.Append(scope $"\n{RunComp()}");
	}
}