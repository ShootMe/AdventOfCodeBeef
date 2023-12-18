using System.Diagnostics;
using System;
using System.Threading;
using System.IO;
using System.Collections;
namespace AdventOfCode;
class Program
{
	public static void Main()
	{
		Runtime.SetCrashReportKind(Runtime.RtCrashReportKind.None);
		Stopwatch dayTimer = scope .();
		TimeSpan allTimer = default;

		WritePadded("File", 50);
		Write(" | ", ConsoleColor.Blue);
		WritePadded("Results", 40);
		Write(" | ", ConsoleColor.Blue);
		WriteLine("Took");
		WritePadded(String.Empty, 112, '-', ConsoleColor.Blue);
		WriteLine();

		for (var file in Directory.EnumerateFiles("2023 Inputs/", "puzzle*.txt"))
		{
			String fileName = scope .();
			file.GetFilePath(fileName);
			//if (fileName.IndexOf("Example", true) >= 0) { continue; }

			IDay day = GetDay(fileName);
			if (day == null) { continue; }

			String inputData = new .();
			File.ReadAllText(fileName, inputData);

			dayTimer.Restart();

			String results = scope .();
			day.Solve(inputData, results);
			delete day;

			dayTimer.Stop();
			allTimer += dayTimer.Elapsed;

			fileName.Clear();
			file.GetFileName(fileName);

			List<StringView> answers = scope .();
			fileName.Substring(0, fileName.Length - 4).ToLines(answers, '~');

			List<StringView> answersToCheck = scope .();
			((StringView)results).ToLines(answersToCheck, '\n');
			if (answersToCheck.Count < 2) { answersToCheck.Add("n/a"); answersToCheck.Add("n/a"); }

			WritePadded(scope $"{fileName}", 50, ' ', ConsoleColor.Yellow);
			Write(" | ", ConsoleColor.Blue);
			Write(scope $"{answersToCheck[0]} ", answersToCheck[0] == answers[1] ? ConsoleColor.Green : ConsoleColor.Red);
			WritePadded(scope $"{answersToCheck[1]}", 39 - answersToCheck[0].Length, ' ', answersToCheck[1] == answers[2] ? ConsoleColor.Green : ConsoleColor.Red);
			Write(" | ", ConsoleColor.Blue);
			WriteLine(scope $"{dayTimer.Elapsed.TotalSeconds:0.000000}", ConsoleColor.Gray);

			delete inputData;
		}

		WritePadded(String.Empty, 112, '-', ConsoleColor.Blue);
		WriteLine();

		WritePadded(scope $"Total:", 96);
		WriteLine(scope $"{allTimer.TotalSeconds:0.000000}", ConsoleColor.Gray);
		Console.ReadLine(scope .());
	}
	private static IDay GetDay(StringView name)
	{
		int index = name.IndexOf("puzzle", true);
		int num = name[index + 6 ... index + 8].ToInt();
		switch (num) {
			case 1: return new AdventOfCode.Y2023.Day01();
			case 2: return new AdventOfCode.Y2023.Day02();
			case 3: return new AdventOfCode.Y2023.Day03();
			case 4: return new AdventOfCode.Y2023.Day04();
			case 5: return new AdventOfCode.Y2023.Day05();
			case 6: return new AdventOfCode.Y2023.Day06();
			case 7: return new AdventOfCode.Y2023.Day07();
			case 8: return new AdventOfCode.Y2023.Day08();
			case 9: return new AdventOfCode.Y2023.Day09();
			case 10: return new AdventOfCode.Y2023.Day10();
			case 11: return new AdventOfCode.Y2023.Day11();
			case 12: return new AdventOfCode.Y2023.Day12();
			case 13: return new AdventOfCode.Y2023.Day13();
			case 14: return new AdventOfCode.Y2023.Day14();
			case 15: return new AdventOfCode.Y2023.Day15();
			case 16: return new AdventOfCode.Y2023.Day16();
			case 17: return new AdventOfCode.Y2023.Day17();
			case 18: return new AdventOfCode.Y2023.Day18();
			default: return null;
		}
	}
	public static void Write(StringView text, ConsoleColor foreColor = ConsoleColor.White, ConsoleColor backColor = ConsoleColor.Black)
	{
		ConsoleColor currentFore = Console.ForegroundColor;
		ConsoleColor currentBack = Console.BackgroundColor;
		Console.ForegroundColor = foreColor;
		Console.BackgroundColor = backColor;
		Console.Write(text);
		Console.ForegroundColor = currentFore;
		Console.BackgroundColor = currentBack;
	}
	public static void WriteLine(StringView text = null, ConsoleColor foreColor = ConsoleColor.White, ConsoleColor backColor = ConsoleColor.Black)
	{
		ConsoleColor currentFore = Console.ForegroundColor;
		ConsoleColor currentBack = Console.BackgroundColor;
		Console.ForegroundColor = foreColor;
		Console.BackgroundColor = backColor;
		Console.WriteLine(text);
		Console.ForegroundColor = currentFore;
		Console.BackgroundColor = currentBack;
	}
	public static void WritePadded(StringView text, int padding = 0, char8 paddingChar = ' ', ConsoleColor foreColor = ConsoleColor.White, ConsoleColor backColor = ConsoleColor.Black)
	{
		ConsoleColor currentFore = Console.ForegroundColor;
		ConsoleColor currentBack = Console.BackgroundColor;
		Console.ForegroundColor = foreColor;
		Console.BackgroundColor = backColor;
		Console.Write(text);
		if (text.Length < padding)
		{
			String temp = scope .();
			temp.PadRight(padding - text.Length, paddingChar);
			Console.Write(temp);
		}
		Console.ForegroundColor = currentFore;
		Console.BackgroundColor = currentBack;
	}
}