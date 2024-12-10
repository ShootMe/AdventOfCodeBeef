using System;
using System.Collections;
namespace AdventOfCode.Y2024;
[Reflect, AlwaysInclude(AssumeInstantiated = true)]
class Day09 : IDay
{
	public void Solve(StringView input, String output)
	{
		int total = 0;
		for (int i = 0; i < input.Length; i++)
		{
			int num = (.)input[i] - 0x30;
			total += num;
		}

		Block[] blocks = new .[total];
		defer delete blocks;

		void FillBlocks(int32 id, int32 start, int32 end)
		{
			Block block = .(id, start, end);
			blocks[start] = block;
			blocks[end] = block;
		}

		int32 id = 1;
		int32 index = 0;
		for (int i = 0; i < input.Length; i++)
		{
			int32 num = (.)input[i] - 0x30;
			if ((i & 1) == 0)
			{
				FillBlocks(id, index, index + num - 1);
				index += num;
				id++;
			} else if (num > 0)
			{
				FillBlocks(0, index, index + num - 1);
				index += num;
			}
		}

		int DefragByBits()
		{
			Block NextFree(ref int index)
			{
				while (index < blocks.Count)
				{
					Block freeBlock = blocks[index];
					index = freeBlock.End + 1;
					if (freeBlock.ID != 0) { continue; }
					return freeBlock;
				}
				return default;
			}

			int fileID = blocks[^1].ID;
			int j = blocks.Count - 1;
			int checkSum = 0;
			int lastFree = 0;
			Block freeBlock = default;
			int32 freeSize = 0;
			while (fileID > 1)
			{
				Block block = blocks[j];
				j = block.Start - 1;
				if (block.ID != fileID) { continue; }
				fileID--;

				int32 blockSize = block.Size;
				while (blockSize > 0 && lastFree <= block.Start)
				{
					if (freeSize == 0)
					{
						freeBlock = NextFree(ref lastFree);
						if (lastFree > block.Start) { break; }
						freeSize = freeBlock.Size;
					}

					if (blockSize >= freeSize)
					{
						checkSum += fileID * (freeSize * freeBlock.Start + freeSize * (freeSize - 1) / 2);
						blockSize -= freeSize;
						freeSize = 0;
					} else
					{
						checkSum += fileID * (blockSize * freeBlock.Start + blockSize * (blockSize - 1) / 2);
						freeBlock.Start += blockSize;
						freeSize -= blockSize;
						blockSize = 0;
					}
				}

				if (blockSize > 0)
				{
					checkSum += fileID * (blockSize * block.Start + blockSize * (blockSize - 1) / 2);
				}
			}

			return checkSum;
		}
		int DefragByBlocks()
		{
			int fileID = blocks[^1].ID;
			int[10] lastFree = default;
			int j = blocks.Count - 1;
			int checkSum = 0;
			while (fileID > 1)
			{
				Block block = blocks[j];
				j = block.Start - 1;
				if (block.ID != fileID) { continue; }
				fileID--;

				int32 blockSize = block.Size;
				int i = lastFree[blockSize];
				while (i < j)
				{
					Block freeBlock = blocks[i];
					i = freeBlock.End + 1;
					if (freeBlock.ID != 0 || blockSize > freeBlock.Size) { continue; }

					lastFree[blockSize] = freeBlock.Start + blockSize;

					block.Start = freeBlock.Start;
					block.End = block.Start + blockSize - 1;
					blocks[block.Start] = block;
					blocks[block.End] = block;

					if (blockSize < freeBlock.Size)
					{
						freeBlock.Start += blockSize;
						blocks[freeBlock.Start] = freeBlock;
						blocks[freeBlock.End] = freeBlock;
					}
					break;
				}

				checkSum += fileID * (blockSize * block.Start + blockSize * (blockSize - 1) / 2);
			}

			return checkSum;
		}

		output.Append(scope $"{DefragByBits()}\n{DefragByBlocks()}");
	}
	private struct Block
	{
		public int32 ID, Start, End;
		public int32 Size => End - Start + 1;
		public this(int32 id, int32 start, int32 end)
		{
			ID = id; Start = start; End = end;
		}
	}
}