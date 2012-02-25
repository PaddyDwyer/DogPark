package
{
	import org.flixel.*;
	
	public class ScoreHolder extends FlxBasic
	{
		private var _scoreLabel:FlxText;
		private var _scoreValue:FlxText;
		
		private var _score:Number = 0;
		private var _combo:Number = -1;
		
		public function ScoreHolder()
		{
			super();
			
			_scoreLabel = new FlxText(20, 20, 200, "Score:");
			_scoreLabel.size = 12;
			_scoreLabel.alignment = "left";
			
			_scoreValue = new FlxText(20, 37, 200, _score.toString());
			_scoreValue.size = 12;
			_scoreValue.alignment = "left";
//			add(scoreText);
		}
		
		override public function draw():void {
			super.draw();
			
			_scoreLabel.draw();
			_scoreValue.draw();
		}
		
		public function addScore(ary:ScoreArray):void {
			_combo++;
//			_score += value;
//			_scoreValue.text = _score.toString();
			
			//				trace("size", size);
			//				if (size == 3) {
			//					scoreHolder.addScore(10);
			//				} else if (size == 4) {
			//					scoreHolder.addScore(20);
			//				} else if (size == 5) {
			//					scoreHolder.addScore(30);
			//				}
			var size:uint = ary.length;
			var value:uint = 0;
			if (ary.hasBall) {
			} else {
				if (size == 3) {
					value += 10;
				} else if (size == 4) {
					value += 20;
				} else if (size == 5) {
					value += 30;
				}
			}
			_score += value + (_combo * 10);  
			_scoreValue.text = _score.toString();
		}
		
		public function reset():void {
			_combo = -1;
		}
	}
}