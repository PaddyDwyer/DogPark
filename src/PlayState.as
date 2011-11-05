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
			GemCollision.collide(gems, map);
			GemCollision.collide(gems, gems);
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
	}
}