module display;

import std::io;

const char CHUNK_SIZE @private = 16;
const char MIN_PRINTABLE_ASCII @private = 32;
const char MAX_PRINTABLE_ASCII @private = 126;

const String COLOR_RED @private = "\e[31m";
const String COLOR_GREEN @private = "\e[32m";
const String COLOR_BLUE @private = "\e[34m";
const String COLOR_GREY @private = "\e[90m";

fn void? print_file(File file)
{
	char[CHUNK_SIZE] buffer;
	uint row = 0;

	while (usz bytes_read = file.read(&buffer)!)
	{
		if (bytes_read == 0)
		{
			break;
		}

		print_line(&buffer, (char)bytes_read, row++);
	}
}

fn void print_hex_row(uint row) @private
{
	usz offset = (usz)row * CHUNK_SIZE;
	io::printf("%s%08x: ", COLOR_BLUE, offset);
}

fn void print_space(char index) @private
{
	if (index % 2 == 1)
	{
		io::print(" ");
	}
}

fn void print_bytes(char[] chunk, char length) @private
{
	for (char i = 0; i < length; i++)
	{
		char c = chunk[i];
		String color;

		if (c >= MIN_PRINTABLE_ASCII && c <= MAX_PRINTABLE_ASCII)
		{
			color = COLOR_GREEN;
		}
		else
		{
			color = COLOR_GREY;
		}

		io::printf("%s%02x", color, c);
		print_space(i);
	}
}

fn void print_padding(char length) @private
{
	char difference = CHUNK_SIZE - length;

	if (difference > 0)
	{
		for (char i = difference; i > 0; i--)
		{
			io::print("  ");
			print_space(i);
		}
	}
}

fn void print_ascii(char[] chunk, char length) @private
{
	for (char i = 0; i < length; i++)
	{
		char c = chunk[i];

		if (c >= MIN_PRINTABLE_ASCII && c <= MAX_PRINTABLE_ASCII)
		{
			io::printf("%s%c", COLOR_GREEN, c);
		}
		else
		{
			io::printf("%s.", COLOR_RED);
		}
	}
}

fn void print_line(char[] chunk, char length, uint row) @private
{
	print_hex_row(row);
	print_bytes(chunk, length);
	print_padding(length);
	print_ascii(chunk, length);

	io::printn();
}