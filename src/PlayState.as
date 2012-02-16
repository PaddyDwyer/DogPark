package
{
	import idv.cjcat.fenofsm.*;
	import idv.cjcat.fenofsm.events.StateEvent;
	import idv.cjcat.fenofsm.events.TransitionEvent;
	
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
		private var moveCount:int = 0;
		private var destroyCount:int = 0;
		private var justMoved:Boolean;
		private var fsm:FSMachine;
		
		private static const FSM_SC_INITIALIZE:String = "initialize";
		private static const FSM_SC_CLICK:String = "click";
		private static const FSM_SC_END_OF_MOVE:String = "endOfMove";
		private static const FSM_SC_VALID:String = "valid";
		private static const FSM_SC_INVALID:String = "invalid";
		private static const FSM_SC_DROP:String = "drop";
		
		private var data:Array = new Array(
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
			3, 3, 3, 3, 3, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3,
			3, 3, 3, 3, 3, 7, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 8, 3,
			3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
		);

		private var gemTypes:Array;
		
		public function PlayState()
		{
			super();
		}
		
		override public function create():void {
			FlxG.globalSeed = 0.9490438620559871;
			FlxG.log("starting seed: " + FlxG.globalSeed);
			
			var background:FlxSprite = new FlxSprite(0, 0);
			background.makeGraphic(768, 640, 0xffffffff);
			add(background);
			
			var mapSprite:FlxSprite = new FlxSprite(0, 0, ImgMap);
			var csv:String = FlxTilemap.arrayToCSV(data, 24);
			map = new FlxTilemap().loadMap(csv, ImgTiles);
			map.setTileProperties(2, FlxObject.DOWN);
			map.setTileProperties(3, FlxObject.NONE);
			add(map);

			gems = new GemHolder();
			add(gems);
			
			moveCount = 0;
			
			selectBox = new FlxSprite(0, 0, ImgSelect);
			selectBox.kill();
			add(selectBox);
			
			gemTypes = [Gem.BOSTON, Gem.BULLTERRIER, Gem.BOXER, Gem.ENGLISH, Gem.FRENCHY, Gem.PUG, Gem.SHARPEI];
			
			setUpFSM();
			
			startLevel();
		}
		
		private function setUpFSM():void {
			fsm = new FSMachine("start");
			var start:State = fsm.initState;
			
			var ready:State = fsm.createState("ready");
			var moving:State = fsm.createState("moving");
			var checkValid:State = fsm.createState("checkValid");
			var destroyGems:State = fsm.createState("destroyGems");
			var dropGems:State = fsm.createState("dropGems");
			var dropCheckValid:State = fsm.createState("dropCheckValid");
			
			var initialize:Transition = fsm.createTransition(start, ready, FSM_SC_INITIALIZE, "start2ready");
			var click:Transition = fsm.createTransition(ready, moving, FSM_SC_CLICK, "ready2moving");
			var endOfMove:Transition = fsm.createTransition(moving, checkValid, FSM_SC_END_OF_MOVE, "moving2checkValid");
			var validMove:Transition = fsm.createTransition(checkValid, destroyGems, FSM_SC_VALID, "checkValid2destroyGems", 0.05);
			var invalidMove:Transition = fsm.createTransition(checkValid, ready, FSM_SC_INVALID, "checkValid2undoMove");
			var droppingGems:Transition = fsm.createTransition(destroyGems, dropGems, FSM_SC_DROP, "destroy2drop", 0.05);
			var dropEndOfMove:Transition = fsm.createTransition(dropGems, dropCheckValid, FSM_SC_END_OF_MOVE, "dropGems2checkValid");
			var dropValid:Transition = fsm.createTransition(dropCheckValid, destroyGems, FSM_SC_VALID, "dropCheckValid2destroyGems", 0.05);
			var dropInvalid:Transition = fsm.createTransition(dropCheckValid, ready, FSM_SC_INVALID, "dropInvalid2ready");
			
			checkValid.addEventListener(StateEvent.ENTER, checkValidCallback, false, 0, true);
			destroyGems.addEventListener(StateEvent.ENTER, destroyGemsCallback, false, 0, true);
			dropGems.addEventListener(StateEvent.ENTER, dropGemsCallback, false, 0, true);
			dropCheckValid.addEventListener(StateEvent.ENTER, checkValidCallback, false, 0, true);
			ready.addEventListener(StateEvent.ENTER, endOfMoveCallback, false, 0, true);
			destroyGems.addEventListener(StateEvent.EXIT, endOfMoveCallback, false, 0, true);
		}
				
		override public function update():void {
			if (fsm.currentState.name == "start" && FlxG.stage != null) {
				fsm.input(FSM_SC_INITIALIZE);
			}
			super.update();
			GemCollision.collide(gems, map);
			GemCollision.collide(gems, gems);
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
				trace(fsm.currentState);
				if (adjacent && fsm.currentState.name == "ready") {
					fsm.input(FSM_SC_CLICK);
					var path:FlxPath = new FlxPath();
					path.addPoint(target.getMidpoint());
					selectedGem.followPath(path, 100);
					selectedGem.justMoved = true;
					path = new FlxPath();
					path.addPoint(selectedGem.getMidpoint());
					target.followPath(path, 100);
					target.justMoved = true;
					moveCount = 2;
					deselectGem();
				} else {
					selectGem(Selected);
				}
			}
		}
		
		
		public function onGemFinishedMoving(gem:Gem):void
		{
			moveCount--;
			if (moveCount == 0) {
				fsm.input(FSM_SC_END_OF_MOVE);
			}
		}
		
		public function onGemDied(gem:Gem):void {
			destroyCount--;
			if (destroyCount == 0) {
				fsm.input(FSM_SC_DROP);
			}
		}
		
		public function checkValidCallback(event:StateEvent):void {
			trace("checkValid");
			var deleteArray:Array = [];
//				trace("Before sort");
//				for (var i:int = 0; i < 8; i++) {
//					var s:String = "";
//					for (var j:int = 0; j < 8; j++) {
//						s += gems.members[i + (j * 8)].type + " ";
//					}
//					trace(s);
//				}
			gems.removeSort();
			var moveArray:Array = [];
			gems.members.forEach(function(item:Gem, index:int, array:Array):void {
				if (item.justMoved) {
					moveArray.push(item);
				}
			});
			if (moveArray.length == 2 && (moveArray[0].type == Gem.BALL || moveArray[1].type == Gem.BALL)) {
				var tempArray:Array = []
				var type:Number = (moveArray[0].type + moveArray[1].type - Gem.BALL);
				trace("killtype", type);
				gems.members.forEach(function(item:Gem, index:int, array:Array):void {
					if (item.type == type || item.type == Gem.BALL) {
						tempArray.push(index);
					}
				});
				trace("deletes", tempArray);
				deleteArray.push(tempArray);
			} else {
//				trace("after sort");
//				for (var i:int = 0; i < 8; i++) {
//					var s:String = "";
//					for (var j:int = 0; j < 8; j++) {
//						s += gems.members[i + (j * 8)].type + " ";
//					}
//					trace(s);
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
						type = gems.members[index].type;
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
			}
			if (deleteArray.length == 0) {
				trace(FSM_SC_INVALID);
				fsm.input(FSM_SC_INVALID);
			} else {
				trace(FSM_SC_VALID);
				var t:Transition = fsm.input(FSM_SC_VALID);
				t.to.data = deleteArray;
			}
		}
		
		public function destroyGemsCallback(event:StateEvent):void {
//			justMoved = true;
			var deleteArray:Array = event.state.data;
			var indexArray:Array = [];
			while(deleteArray.length > 0) {
				var tempArray:Array = deleteArray.shift();
				var size:uint = tempArray.length;
				// The special boolean is used to determine if a special gem has been created yet. once a special gem is created, it's set to false
				var special:Boolean = true;
				while (tempArray.length > 0) {
					var index:uint = tempArray.shift();
					if (gems.members[index].bone) {
						var squareArray:Array = [];
						squareArray.push(index + 1);
						squareArray.push(index - 1);
						squareArray.push(index + 7);
						squareArray.push(index + 8);
						squareArray.push(index + 9);
						squareArray.push(index - 7);
						squareArray.push(index - 8);
						squareArray.push(index - 9);
						deleteArray.push(squareArray);
					}
					if (special && size == 4 && gems.members[index].justMoved == true){
						special = false;
						gems.members[index].bone = true;
					} else if (special && size == 5 && gems.members[index].justMoved == true){
						special = false;
						gems.members[index].setType(Gem.BALL);
					} else {
						destroyCount++;
						gems.members[index].kill();
					}
				}
			}
		}
		
		public function dropGemsCallback(event:StateEvent):void {
			var size:int = gems.members.length;
			var colCount:Object = {};
			var drop:Boolean = false;
			var tempArray:Array = [];
			var indexArray:Array = [];
			var dv:uint = 0;
			for (var i:int = size - 1, j:int = 0; i >= 0; i--, j++) {
				var gem:Gem = gems.members[i];
				if (!gem.alive) {
					drop = true;
					indexArray.push(gem.getMidpoint());
				} else if (drop && gem.alive) {
					indexArray.push(gem.getMidpoint());
					gem.followPath(new FlxPath([indexArray.shift()]), 400);
					gem.justMoved = true;
					moveCount++;
				}
				
				if (j == 7) {
					drop = false;
					j = -1;
					var indexLength:int = indexArray.length;
					
					for (var k:int = 0; k < indexLength; k++) {
						gem = gems.recycle() as Gem;
						var point:FlxPoint = indexArray.shift();
						var n:int  = k + 1;
						var c:int = 2 * indexLength + 3;
						var off:int = (c * n - n * n) / 2;
						gem.reset(point.x - 32, (point.y - 32) - (off * 64));
						gem.setType(FlxG.getRandom(gemTypes) as Number);
						gem.followPath(new FlxPath([point]), 400);
						gem.justMoved = true;
						moveCount++;
					}
				}
			}
		}
		
		public function endOfMoveCallback(event:StateEvent):void {
			gems.members.forEach(function(item:Gem, index:int, array:Array):void {
				item.justMoved = false;
			});
		}
	}
}