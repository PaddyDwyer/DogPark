package
{
	public class ScoreArray
	{
		private var ary:Array;
		private var hasBone:Boolean;
		private var hasBall:Boolean;
		
		public function ScoreArray()
		{
			ary = [];
		}
		
		public function add(index:uint, gem:Gem):void {
			if (gem.bone) {
				hasBone = true;
			} else if (gem.ball) {
				hasBall = true;
			}
			ary.push(index);
		}
		
		public function get array():Array {
			return ary;
		}
	}
}