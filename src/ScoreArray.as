package
{
	import org.flixel.FlxGroup;
	
	public class ScoreArray extends FlxGroup
	{
		private var ary:Array;
		private var hasBone:Boolean;
		private var hasBall:Boolean;
		
		public function ScoreArray(MaxSize:uint=0)
		{
			super(MaxSize);
			ary = [];
		}
		
		public function add(gem:Gem):void {
			if (gem.bone) {
				hasBone = true;
			} else if (gem.ball) {
				hasBall = true;
			}
			ary.push(gem);
		}
	}
}