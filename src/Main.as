package
{
	import flash.display.Sprite;

	import net.blaxstar.termini.Termini;

	public class Main extends Sprite
	{
		public function Main()
		{
			var t:Termini = new Termini();
      addChild(t);
      t.open_key = t.keys.F1;
		}
	}
}
