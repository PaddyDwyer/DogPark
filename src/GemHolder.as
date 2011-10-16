package
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	
	public class GemHolder extends FlxGroup
	{
		public function GemHolder(MaxSize:uint=0)
		{
			super(MaxSize);
		}
		
		public function addWithIndex(Object:FlxBasic, Index:Number):FlxBasic {
			//Don't bother adding an object twice.
			if(members.indexOf(Object) >= 0)
				return Object;
			
			if(members[Index] == null)
			{
				members[Index] = Object;
				if(Index >= length)
					length = Index+1;
				return Object;
			}
			
			return Object;
		}
		
		public function removeWithIndex(Object:FlxBasic):Number {
			var index:int = members.indexOf(Object);
			members[index] = null;
			return index;
		}
	}
}