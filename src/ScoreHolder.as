package
{
	import org.flixel.*;
	
	public class ScoreHolder extends FlxBasic
	{
		private var _scoreLabel:FlxText;
		private var _scoreValue:FlxText;
		
		private var _score:Number = 0;
		
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
		
		public function addScore(value:Number):void {
			_score += value;
			_scoreValue.text = _score.toString();
		}
	}
}