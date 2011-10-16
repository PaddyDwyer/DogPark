package
{
	import flash.display.Sprite;
	
	import org.flixel.*;
	import org.flixel.system.input.Mouse;
	
	public class MenuState extends FlxState
	{
		public function MenuState()
		{
			super();
		}
		
		override public function create():void {
			var startText:FlxText = new FlxText((FlxG.width / 2) - 100, 280, 200, "Click to Start Game");
			startText.size = 12;
			startText.alignment = "center";
			add(startText);
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new PlayState());
			}
		}
	}
}