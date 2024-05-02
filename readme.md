# Termini
### *miniature debugging terminal for AS3/AIR*


Termini is a slim debugging terminal that appears at the top of a display object (seperate container at stage index numChildren-1 recommended). it has support for custom commands through an extendable `TerminalCommand` class. it also supports piping values from multiple commands together.

# USAGE
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

now start your application and press your trigger key-- termini will appear at the top your your display object! test it out by printing the version you have:

![image](https://github.com/dyxribo/termini_as3/assets/6477128/e7da59bd-e100-4bd8-85f9-2821e8d99b1a)


# FEATURES

Termini has some cool features (if i do say so myself):

## EXTENDABLE `TerminalCommand` CLASS 
create your own custom commands, only limited by imagination (see `src/net/blaxstar/termini/commands` folder for examples)


## PIPE SUPPORT FOR CHAINING COMMAND OUTPUTS

![image](https://github.com/dyxribo/termini_as3/assets/6477128/ec1b476e-7433-469b-b6e5-9a65cfcfdeef)

## DEFAULT COMMANDS + MANUALS
the tool implements a mini command + manual framework; use the `man` command for fullscreen descriptions of commands ex: `man grep` will display the following (semi-transparent):

![image](https://github.com/dyxribo/termini_as3/assets/6477128/9cf6a374-000a-436f-a59b-3a1fe1bb50f8)

**NOTE**: Manuals and commands can be edited/added in `src/net/blaxstar/termini/commands/Manuals.as`.

## BUILT-IN GREP
- as seen above, built in `grep` command for looging for patterns in text and files; also supports recursive file pattern searching! for example:

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
## BUILT-IN EVAL COMMAND
register objects to the `eval` command in order to access their properties at runtime! this is great for game development:

```
EvalObjectCommand.register_object("main_character", main_character_sprite);

// in termini:

eval main_character.x
// prints the main_character_sprite's x position
```

it supports nested properties as well:

![image](https://github.com/dyxribo/termini_as3/assets/6477128/01e3c39c-64ca-49c5-aa1e-fc769ef7b057)


this command doesnt yet support setting values at runtime just yet (just haven't gotten around to implementing the command yet), but it is on the list!

