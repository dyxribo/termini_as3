package net.blaxstar.termini.commands {

    import net.blaxstar.starlib.utils.Strings;
    import net.blaxstar.termini.Termini;

    public class PrintCommand extends TerminalCommand {

        public function PrintCommand() {
            super("print", print);
        }

        private function print(... args):String {
            var full_string:String = "";

            for each(var string:String in args) {
              if (Strings.trim(string) === "-v") {
                return Termini.VERSION_STRING;
              }
              full_string = full_string.concat(" " + string);
            }

            
            return full_string;
        }
    }
}
