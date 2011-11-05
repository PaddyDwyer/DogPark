package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source="data/boston.png")] protected var ImgBoston:Class;
		[Embed(source="data/auto_tile.png")] protected var ImgTiles:Class;
		[Embed(source="data/map.png")] protected var ImgMap:Class;
		[Embed(source="data/select.png")] protected var ImgSelect:Class;
		
		public var map:FlxTilemap;
		public var gems:GemHolder;
		public var selectBox:FlxSprite;
		
		public var delay:FlxTimer;
		
		private var selectedGem:Gem;
		private var movingGems:FlxGroup;
		private var justMoved:Boolean;
		
		private var data:Array = new Array(
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,
			0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		);

		private var gemTypes:Array;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void {
//			FlxG.globalSeed = 0.7796059045940638;
			FlxG.globalSeed = 0.1358598880469799;
//			FlxG.log("starting seed: " + FlxG.globalSeed);
			
			var background:FlxSprite = new FlxSprite(0, 0);
			background.makeGraphic(768, 640, 0xffffffff);
			add(background);
			
			var mapSprite:FlxSprite = new FlxSprite(0, 0, ImgMap);
			var csv:String = FlxTilemap.arrayToCSV(data, 24);
			map = new FlxTilemap().loadMap(csv, ImgTiles);
			map.setTileProperties(2, FlxObject.DOWN);
//			FlxG.log(map.getTile(6, 1));
			add(map);

			gems = new GemHolder();
			add(gems);
			
			movingGems = new FlxGroup();
			add(movingGems);
			
			selectBox = new FlxSprite(0, 0, ImgSelect);
			selectBox.kill();
			add(selectBox);
			
			gemTypes = [Gem.BOSTON, Gem.BULLTERRIER, Gem.BOXER, Gem.ENGLISH, Gem.FRENCHY, Gem.PUG];
			
			startLevel();
		}
		
		override public function update():void {
			super.update();
			PlayState.collide(gems, map);
			PlayState.collide(gems, gems);
//			PlayState.collide(movingGems, map);
//			PlayState.collide(movingGems, gems);
			
			if (justMoved && movingGems.length == 0) {
				justMoved = false;
				var deleteArray:Array = [];
//				FlxG.log("Before check");
//				for (var i:int = 0; i < 8; i++) {
//					var s:String = "";
//					for (var j:int = 0; j < 8; j++) {
//						s += gems.members[i + (j * 8)].type + " ";
//					}
//					FlxG.log(s);
//				}
				for (var i:int = 0; i < 8; i++) {
					var xLast:Number = -1;
					var xCount:Number = 1;
					var xTempArray:Array = [];
					
					var yLast:Number = -1;
					var yCount:Number = 1;
					var yTempArray:Array = [];
					
					for (var j:int = 0; j < 8; j++) {
						// Check Columns
						var index:uint = (i * 8) + j;
						var type:Number = gems.members[index].type;
						if (type == xLast) {
							xCount += 1;
						} else {
							if (xCount >= 3) {
								deleteArray.push(xTempArray);
							}
							xLast = type;
							xCount = 1;
							xTempArray = [];
						}
						xTempArray.push(index);
						
						// Check Rows
						index = i + (j * 8);
						type = gems.members[index].type;
						if (type == yLast) {
							yCount += 1;
						} else {
							if (yCount >= 3) {
								deleteArray.push(yTempArray);
							}
							yLast = type;
							yCount  = 1;
							yTempArray = [];
						}
						yTempArray.push(index);
					}
					
					if (xCount >= 3) {
						deleteArray.push(xTempArray);
					}
					
					if (yCount >= 3) {
						deleteArray.push(yTempArray);
					}
				}
				
				if (deleteArray.length == 0) {
					FlxG.log("invalid move");
				} else {
					justMoved = true;
					while(deleteArray.length > 0) {
						var tempArray:Array = deleteArray.shift();
						var size:uint = tempArray.length;
						var special:Boolean = true;
						while (tempArray.length > 0) {
							index = tempArray.shift();
							if (gems.members[index].bone) {
								xTempArray = [];
								xTempArray.push(index + 1);
								xTempArray.push(index - 1);
								xTempArray.push(index + 7);
								xTempArray.push(index + 8);
								xTempArray.push(index + 9);
								xTempArray.push(index - 7);
								xTempArray.push(index - 8);
								xTempArray.push(index - 9);
								deleteArray.push(xTempArray);
							}
							if (special && size == 4 && gems.members[index].justMoved){ //&& (index == moveObject.selectedIndex || index == moveObject.targetIndex)) {
								special = false;
								gems.members[index].bone = true;
							} else if (special && size == 5 && gems.members[index].justMoved){ //&& (index == moveObject.selectedIndex || index == moveObject.targetIndex)) {
								special = false;
								gems.members[index].cookie = true;
							} else {
								gems.members[index].kill();
							}
						}
					}
					
					gems.members.forEach(function(item:Gem, index:int, array:Array):void {
						item.justMoved = false;
					});
					
					size = gems.members.length;
					var colCount:Object = {};
					var drop:Boolean = false;
					tempArray = [];
					var indexArray:Array = [];
					var dv:uint = 0;
					for (i = size - 1, j = 0; i >= 0; i--, j++) {
//						FlxG.log("start loop, i: " + i + ", j: " + j);
						if (drop && gems.members[i].alive) {
//							FlxG.log("dropping " + i);
//							gems.members[i].velocity.y = 400 - dv;
							gems.members[i].justMoved = true;
							dv += 30;
							gems.members[i].targetIdx = indexArray.shift();
							movingGems.add(gems.members[i]);
							gems.members[i] = null;
						}
						if (!gems.members[i]) {
							indexArray.push(i);
						} else if (!gems.members[i].alive) {
//							FlxG.log("found dead " + i);
							indexArray.push(i);
							tempArray.push(gems.members[i]);
							gems.members[i] = null;
							drop = true;
						}
						if (j == 7) {
//							FlxG.log("end of col");
							drop = false;
							j = -1;
//							var debug:int = 0;
							var indexLength:int = indexArray.length;
							while (tempArray.length > 0) {
								var gem:Gem = tempArray.pop();
								var idx:uint = indexArray.shift();
								gem.targetIdx = idx;
								var x:uint = (idx - (idx % 8)) / 8;
								var y:uint = (idx % 8);
								gem.reset(192 + ( x * 64), (-96 * indexLength) + (y * 80));
								gem.setType(FlxG.getRandom(gemTypes) as Number);
//								gem.setType(debug++);
//								gem.velocity.y = 400 - dv;
								dv += 30;
								gem.justMoved = true;
								FlxG.log("target: " + gem.targetIdx + ", t: " + gem.type + ", x: " + x + ", y: " + y);
								movingGems.add(gem);
							}
							dv = 0;
						}
					}
				}
			}
		}
		
		private function startLevel():void {
			for (var x:int = 0; x < 8; x++) {
				for (var y:int = 0; y < 8; y++) {
					gems.add(new Gem(192 + ( x * 64), -800 + (y * 80), FlxG.getRandom(gemTypes) as Number, this, (x * 8) + j));
				}
			}
			for (var i:int = 0; i < 8; i++) {
				var xLast:Number = -1;
				var xCount:Number = 0;
				var yLast:Number = -1;
				var yCount:Number = 0;
				for (var j:int = 0; j < 8; j++) {
					// Check Columns
					var type:Number = gems.members[(i * 8) + j].type;
					if (type == xLast) {
						xCount += 1;
						if (xCount == 3) {
//							FlxG.log("replace " + ((i * 8) + j));
							gems.members[(i * 8) + j] = new Gem(192 + ( i * 64), -800 + (j * 80), FlxG.getRandom(gemTypes) as Number, this, (i * 8) + j);
							i = 0;
							j = 0;
						}
					} else {
						xLast = type;
						xCount = 1;
					}
					
					// Check Rows
					type = gems.members[i + (j * 8)].type;
					if (type == yLast) {
						yCount += 1;
						if (yCount == 3) {
//							FlxG.log("replace " + (i + (j * 8)));
							gems.members[i + (j * 8)] = new Gem(192 + (j * 64), -800 + (i * 80), FlxG.getRandom(gemTypes) as Number, this, i + (j * 8));
							i = 0;
							j = 0;
						}
					} else {
						yLast = type;
						yCount  = 1;
					}
				}
			}
		}
		
		private function selectGem(gem:Gem):void {
			selectedGem = gem;
			selectBox.x = gem.x;
			selectBox.y = gem.y;
			selectBox.revive();
		}
		
		private function deselectGem():void {
			selectedGem = null;
			selectBox.kill();
		}
		
		public function onSelectGem(Selected:Gem):void {
			if (selectedGem == null) {
				selectGem(Selected);
			} else {
				var target:Gem = Selected;
				var adjacent:Boolean = false;
				// Check to see if same line
				if (selectedGem.top == target.top) {
					if (selectedGem.left == target.right || selectedGem.right == target.left) {
						adjacent = true;
					}
				} else if (selectedGem.left == target.left) {
					if (selectedGem.top == target.bottom || selectedGem.bottom == target.top) {
						adjacent = true;
					}
				}
				
				if (adjacent) {
					var path:FlxPath = new FlxPath();
					path.addPoint(target.getMidpoint());
					selectedGem.followPath(path, 100);
					selectedGem.justMoved = true;
					path = new FlxPath();
					path.addPoint(selectedGem.getMidpoint());
					target.followPath(path, 100);
					target.justMoved = true;
//					moveObject.selected = selectedGem;
					target.targetIdx = gems.removeWithIndex(selectedGem);
//					moveObject.target = target;
					selectedGem.targetIdx = gems.removeWithIndex(target);
					movingGems.add(target);
					movingGems.add(selectedGem);
					deselectGem();
					justMoved = true;
				} else {
					selectGem(Selected);
				}
			}
		}
		
		
		public function onGemFinishedMoving(gem:Gem):void
		{
//			FlxG.log("finished moving");
			movingGems.remove(gem, true);
			gems.addWithIndex(gem, gem.targetIdx);
		}
		
		static public function collide(ObjectOrGroup1:FlxBasic=null, ObjectOrGroup2:FlxBasic=null, NotifyCallback:Function=null):Boolean {
			return FlxG.overlap(ObjectOrGroup1,ObjectOrGroup2,NotifyCallback,PlayState.separate);
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