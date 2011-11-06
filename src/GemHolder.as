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
		
		override public function recycle(ObjectClass:Class=null):FlxBasic {
			
			var basic:FlxBasic;
			if(_maxSize > 0)
			{
				if(length < _maxSize)
				{
					if(ObjectClass == null)
						return null;
					return add(new ObjectClass() as FlxBasic);
				}
				else
				{
					basic = members[_marker++];
					if(_marker >= _maxSize)
						_marker = 0;
					return basic;
				}
			}
			else
			{
				basic = getLastAvailable(ObjectClass);
				if(basic != null)
					return basic;
				if(ObjectClass == null)
					return null;
				return add(new ObjectClass() as FlxBasic);
			}
		}
		
		/**
		 * Call this function to retrieve the first object with exists == false in the group.
		 * This is handy for recycling in general, e.g. respawning enemies.
		 * 
		 * @param	ObjectClass		An optional parameter that lets you narrow the results to instances of this particular class.
		 * 
		 * @return	A <code>FlxBasic</code> currently flagged as not existing.
		 */
		public function getLastAvailable(ObjectClass:Class=null):FlxBasic
		{
			var basic:FlxBasic;
			var i:uint = length - 1;
			while(i >= 0)
			{
				basic = members[i--] as FlxBasic;
				if((basic != null) && !basic.exists && ((ObjectClass == null) || (basic is ObjectClass)))
					return basic;
			}
			return null;
		}
		
		public function removeSort():void {
			members.sortOn(["x", "y"], Array.NUMERIC);
		}
	}
}