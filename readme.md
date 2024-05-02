# Termini
### miniature debugging terminal for AS3/AIR

Termini is a slim debugging terminal that appears at the top of a display object (seperate container at stage index numChildren-1 recommended). it has support for custom commands through an extendable `TerminalCommand` class. it also supports piping values from multiple commands together.

## USAGE
To use termini, simply create an instance of the `Termini` class and add it to your display object container:

```
var mini_terminal:Termini = new Termini();
stage.addChild(mini_terminal);
```

You can also set a trigger key that allows you to open and close your Termini instance at will using the `open_key` and `keys` property:

```
// sets the trigger key to F1
mini_terminal.open_key = mini_terminal.keys.F1;
```

now start your application and press your trigger key-- termini will appear at the top your your display object!

## FEATURES

Termini has some cool features (if i do say so myself):

- Extendable `TerminalCommand` class for creating your own custom commands, only limited by imagination (see `src/net/blaxstar/termini/commands` folder for examples)


- Pipe support for chaining command outputs ex:
`add 5 5 | print five plus five equals` prints `"five plus five equals 10"`
- default commands and a mini command `manual` framework; use the `man` command for fullscreen descriptions of commands ex: `man grep` will display the following:

```
NAME:

	grep - print lines that match patterns

SYNOPSIS:

	grep PATTERN ... [FILE]

DESCRIPTION:

	grep searches for PATTERNS in each FILE.  PATTERN is a single pattern, and grep prints each line (seperated by pipes) that matches that pattern. pattern should not be quoted. if a file is provided, it will search the file. if the file contains a URL to another file that is on the system, it will search recursively for the matching pattern through each file and concatenate all the results from all files.
	the following are examples of usage:

	grep b apple bottom jeans boots with the fur
	// bottom | boots

	grep b c:\file.txt
	// returns every line in c:\file.txt containing `b`

	// in c:\file.txt:  d:\other_file.txt <newline> e:\other_file.txt
	grep a c:\file.txt
	// returns every line in c:\file.txt, d:\other_file.txt, and e:\other_file.txt containing `a`

press the toggle key or type any other non-man command to revert back to normal size.
```

- built in `grep` command for looging for patterns in text and files; also supports recursive file pattern searching! for example:

```
// text file in c:\test.txt:

C:\test0.txt
C:\test1.txt
C:\test2.txt
hello from pattern in root text file!

// C:\test0.txt:

hello from pattern in test0.txt!

// C:\test1.txt

hello from pattern in test1.txt!

// C:\test2.txt

hello from pattern in test2.txt!

// in termini (supports linux and mac paths too!):

grep pattern c:\test.txt | print this is a printed string before the pipe.

// outputs the value of the grep command piped into the print command

this is a printed string before the pipe. hello from pattern in root text file! | hello from pattern in test0.txt! | hello from pattern in test1.txt! | hello from pattern in test2.txt!
```
- register objects to the `eval` command in order to access their properties at runtime! this is great for game development:

```
EvalObjectCommand.register_object("main_character", main_character_sprite);

// in termini:

eval main_character.x
// prints the main_character_sprite's x position
```

this command doesnt yet support setting values at runtime just yet (just haven't gotten around to implementing the command yet), but it is on the list!

