module main;

import std::io;
import display;

const String FILE_READ_MODE = "r";

faultdef INCORRECT_ARGS;

fn void main(String[] args) => process_file(args);

fn void process_file(String[] args)
{
	String? file_path = get_file_path(args);
	if (catch excuse = file_path)
	{
		io::printn("File path is required.");
		return;
	}

	File? file = file::open(file_path, FILE_READ_MODE);
	if (catch excuse = file)
	{
		io::printn("File not found.");
		return;
	}

	if (catch excuse = display::print_file(file))
	{
		io::printn("Failed to print the file.");
		return;
	}

	if (catch excuse = file.close())
	{
		io::printn("Failed to close the file.");
	}
}

fn String? get_file_path(String[] args)
{
	if (args.len < 2)
	{
		return INCORRECT_ARGS~;
	}

	return args[1];
}