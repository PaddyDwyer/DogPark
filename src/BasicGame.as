package
{
	import org.flixel.*;
	
	[SWF(width="768", height="640", backgroundColor="#aaaaaa")]
	public class BasicGame extends FlxGame
	{
		public function BasicGame()
		{
			super(768, 640, MenuState, 1);
			forceDebugger = true;
			
			FlxG.mouse.show();
 		}
	}
}