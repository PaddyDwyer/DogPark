package
{
	public class ScoreArray
	{
		private var ary:Array;
		private var _hasBone:Boolean;
		private var _hasBall:Boolean;
		private var _length:uint;
		
		public function ScoreArray()
		{
			ary = [];
			_length = 0;
		}
		
		public function add(index:uint, gem:Gem):void {
			if (gem.bone) {
				_hasBone = true;
			} else if (gem.ball) {
				_hasBall = true;
			}
			ary.push(index);
			_length++;
		}
		
		public function get array():Array {
			return ary;
		}
		
		public function get length():uint {
			return _length;
		}
		
		public function get hasBall():Boolean {
			return _hasBall;
		}
		
		public function get hasBone():Boolean {
			return _hasBone;
		}
	}
}