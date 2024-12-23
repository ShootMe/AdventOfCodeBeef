using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day22 : IDay
{
	public void Solve(StringView input, String output)
	{
		List<int> secrets = scope .();
		input.ExtractInts(secrets);

		static int Generate(int secret) {
			var secret;
		    secret = (secret ^ (secret << 6)) & 0xffffff;
		    secret = (secret ^ (secret >> 5)) & 0xffffff;
		    return (secret ^ (secret << 11)) & 0xffffff;
		}

		bool[] sets = new bool[1 << 20]; defer delete sets;
		int[] totals = new int[1 << 20]; defer delete totals;
		List<int> seen = scope .();

		int total = 0;
		for (int i = 0; i < secrets.Count; i++) {
		    int secret = secrets[i];
		    int sequence = 0;
		    for (int j = 0; j < 2000; j++) {
		        int newSecret = Generate(secret);
		        int price = newSecret % 10;
		        sequence = ((sequence << 5) | (price - (secret % 10) + 9)) & 0xfffff;
		        secret = newSecret;
		        if (j >= 3 && !sets[sequence]) {
		            seen.Add(sequence);
		            sets[sequence] = true;
		            totals[sequence] += price;
		        }
		    }

		    for (int j = 0; j < seen.Count; j++) {
		        sets[seen[j]] = false;
		    }
		    seen.Clear();

		    total += secret;
		}

		int best = 0;
		for (int i = 0; i < totals.Count; i++) {
		    if (totals[i] > best) {
		        best = totals[i];
		    }
		}

		output.Append(scope $"{total}\n{best}");
	}
}