package
{
	import org.flixel.*;
	
	public class GemCollision
	{
		public function GemCollision()
		{
		}
		
		static public function collide(ObjectOrGroup1:FlxBasic=null, ObjectOrGroup2:FlxBasic=null, NotifyCallback:Function=null):Boolean {
			return FlxG.overlap(ObjectOrGroup1,ObjectOrGroup2,NotifyCallback,GemCollision.separate);
		}
		
		/**
		 * The main collision resolution function in flixel.
		 * 
		 * @param	Object1 	Any <code>FlxObject</code>.
		 * @param	Object2		Any other <code>FlxObject</code>.
		 * 
		 * @return	Whether the objects in fact touched and were separated.
		 */
		static public function separate(Object1:FlxObject, Object2:FlxObject):Boolean
		{
			var separatedX:Boolean = separateX(Object1,Object2);
			var separatedY:Boolean = separateY(Object1,Object2);
			return separatedX || separatedY;
		}
		
		private static function separateX(Object1:FlxObject, Object2:FlxObject):Boolean
		{
			//can't separate two immovable objects
			var obj1immovable:Boolean = Object1.immovable;
			var obj2immovable:Boolean = Object2.immovable;
			if(obj1immovable && obj2immovable)
				return false;
			
			//If one of the objects is a tilemap, just pass it off.
			if(Object1 is FlxTilemap)
				return (Object1 as FlxTilemap).overlapsWithCallback(Object2,separateX);
			if(Object2 is FlxTilemap)
				return (Object2 as FlxTilemap).overlapsWithCallback(Object1,separateX,true);
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.x - Object1.last.x;
			var obj2delta:Number = Object2.x - Object2.last.x;
			if(obj1delta != obj2delta)
			{
				//Check if the X hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:FlxRect = new FlxRect(Object1.x-((obj1delta > 0)?obj1delta:0),Object1.last.y,Object1.width+((obj1delta > 0)?obj1delta:-obj1delta),Object1.height);
				var obj2rect:FlxRect = new FlxRect(Object2.x-((obj2delta > 0)?obj2delta:0),Object2.last.y,Object2.width+((obj2delta > 0)?obj2delta:-obj2delta),Object2.height);
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + FlxObject.OVERLAP_BIAS;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta)
					{
						overlap = Object1.x + Object1.width - Object2.x;
						if((overlap > maxOverlap) || !(Object1.allowCollisions & FlxObject.RIGHT) || !(Object2.allowCollisions & FlxObject.LEFT))
							overlap = 0;
						else
						{
							Object1.touching |= FlxObject.RIGHT;
							Object2.touching |= FlxObject.LEFT;
						}
					}
					else if(obj1delta < obj2delta)
					{
						overlap = Object1.x - Object2.width - Object2.x;
						if((-overlap > maxOverlap) || !(Object1.allowCollisions & FlxObject.LEFT) || !(Object2.allowCollisions & FlxObject.RIGHT))
							overlap = 0;
						else
						{
							Object1.touching |= FlxObject.LEFT;
							Object2.touching |= FlxObject.RIGHT;
						}
					}
				}
			}
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap != 0)
			{
				var obj1v:Number = Object1.velocity.x;
				var obj2v:Number = Object2.velocity.x;
				
				if(!obj1immovable && !obj2immovable)
				{
					Object1.x = Object1.x - overlap;
					
					Object1.velocity.x = 0;
					Object2.velocity.x = 0;
				}
				else if(!obj1immovable)
				{
					Object1.x = Object1.x - overlap;
					Object1.velocity.x = obj2v - obj1v*Object1.elasticity;
				}
				else if(!obj2immovable)
				{
					Object2.x += overlap;
					Object2.velocity.x = obj1v - obj2v*Object2.elasticity;
				}
				return true;
			}
			else
				return false;
		}
		
		private static function separateY(Object1:FlxObject, Object2:FlxObject):Boolean
		{
			//can't separate two immovable objects
			var obj1immovable:Boolean = Object1.immovable;
			var obj2immovable:Boolean = Object2.immovable;
			if(obj1immovable && obj2immovable)
				return false;
			
			//If one of the objects is a tilemap, just pass it off.
			if(Object1 is FlxTilemap)
				return (Object1 as FlxTilemap).overlapsWithCallback(Object2,separateY);
			if(Object2 is FlxTilemap)
				return (Object2 as FlxTilemap).overlapsWithCallback(Object1,separateY,true);
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.y - Object1.last.y;
			var obj2delta:Number = Object2.y - Object2.last.y;
			if(obj1delta != obj2delta)
			{
				//Check if the Y hulls actually overlap
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:FlxRect = new FlxRect(Object1.x,Object1.y-((obj1delta > 0)?obj1delta:0),Object1.width,Object1.height+obj1deltaAbs);
				var obj2rect:FlxRect = new FlxRect(Object2.x,Object2.y-((obj2delta > 0)?obj2delta:0),Object2.width,Object2.height+obj2deltaAbs);
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + FlxObject.OVERLAP_BIAS;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta)
					{
						overlap = Object1.y + Object1.height - Object2.y;
						if((overlap > maxOverlap) || !(Object1.allowCollisions & FlxObject.DOWN) || !(Object2.allowCollisions & FlxObject.UP))
							overlap = 0;
						else
						{
							Object1.touching |= FlxObject.DOWN;
							Object2.touching |= FlxObject.UP;
						}
					}
					else if(obj1delta < obj2delta)
					{
						overlap = Object1.y - Object2.height - Object2.y;
						if((-overlap > maxOverlap) || !(Object1.allowCollisions & FlxObject.UP) || !(Object2.allowCollisions & FlxObject.DOWN))
							overlap = 0;
						else
						{
							Object1.touching |= FlxObject.UP;
							Object2.touching |= FlxObject.DOWN;
						}
					}
				}
			}
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap != 0)
			{
				var obj1v:Number = Object1.velocity.y;
				var obj2v:Number = Object2.velocity.y;
				
				if(!obj1immovable && !obj2immovable)
				{
					if (Object1.velocity.y == 0 || Object2.velocity.y == 0) {
						Object1.y = Math.floor(Object1.y) - Math.floor(overlap);
						Object1.velocity.y = 0;
						Object2.velocity.y = 0;	
					} else {
						Object1.velocity.y -= 1;
						Object1.y = Object1.y - overlap * 0.5;
						Object2.y = Object2.y + overlap * 0.5;
					}
				}
				else if(!obj1immovable)
				{
					Object1.y = Object1.y - overlap;
					Object1.velocity.y = obj2v - obj1v*Object1.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object2.active && Object2.moves && (obj1delta > obj2delta))
						Object1.x += Object2.x - Object2.last.x;
				}
				else if(!obj2immovable)
				{
					Object2.y += overlap;
					Object2.velocity.y = obj1v - obj2v*Object2.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object1.active && Object1.moves && (obj1delta < obj2delta))
						Object2.x += Object1.x - Object1.last.x;
				}
				return true;
			}
			else
				return false;
		}
	}
}