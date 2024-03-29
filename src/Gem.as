package
{
	import flash.events.MouseEvent;
	import flash.net.drm.VoucherAccessInfo;
	
	import org.flixel.*;
	
	public class Gem extends FlxSprite
	{
		[Embed(source="data/boston.png")] private var ImgBoston:Class;
		[Embed(source="data/bostonbone.png")] private var ImgBostonBone:Class;
		[Embed(source="data/bostoncookie.png")] private var ImgBostonCookie:Class;
		[Embed(source="data/bullterrier.png")] private var ImgBullTerrier:Class;
		[Embed(source="data/bullterrierbone.png")] private var ImgBullTerrierBone:Class;
		[Embed(source="data/bullterriercookie.png")] private var ImgBullTerrierCookie:Class;
		[Embed(source="data/boxer.png")] private var ImgBoxer:Class;
		[Embed(source="data/boxerbone.png")] private var ImgBoxerBone:Class;
		[Embed(source="data/boxercookie.png")] private var ImgBoxerCookie:Class;
		[Embed(source="data/english.png")] private var ImgEnglish:Class;
		[Embed(source="data/englishbone.png")] private var ImgEnglishBone:Class;
		[Embed(source="data/englishcookie.png")] private var ImgEnglishCookie:Class;
		[Embed(source="data/frenchy.png")] private var ImgFrenchy:Class;
		[Embed(source="data/frenchybone.png")] private var ImgFrenchyBone:Class;
		[Embed(source="data/frenchycookie.png")] private var ImgFrenchyCookie:Class;
		[Embed(source="data/pug.png")] private var ImgPug:Class;
		[Embed(source="data/pugbone.png")] private var ImgPugBone:Class;
		[Embed(source="data/pugcookie.png")] private var ImgPugCookie:Class;
		[Embed(source="data/sharpei.png")] private var ImgSharpei:Class;
		[Embed(source="data/sharpeibone.png")] private var ImgSharpeiBone:Class;
		[Embed(source="data/ball.png")] private var ImgBall:Class;
		
		// Source http://www.pacdv.com/sounds/fart-sounds.html
		[Embed(source="data/fart.mp3")] private var SndFart:Class;
		
		public var type:Number;
		public var status:uint;
		public var idx:uint;
		public var targetIdx:Number;
		public var justMoved:Boolean = false;
		
		public static const BOSTON:Number = 0;
		public static const BULLTERRIER:Number = 1;
		public static const BOXER:Number = 2;
		public static const ENGLISH:Number = 3;
		public static const FRENCHY:Number = 4;
		public static const PUG:Number = 5;
		public static const SHARPEI:Number = 6;
		public static const BALL:Number = 7;
		
		public static const NORMAL:uint = 0;
		public static const PRESSED:uint = 1;
		
		private var initialized:Boolean;
		private var state:PlayState;
		private var _bone:Boolean;
		private var _ball:Boolean;
		private var _fart:FlxSound;
		private var _dying:Boolean;
		
		public function Gem(X:Number, Y:Number, Type:Number, State:PlayState, Index:uint)
		{
			super(X, Y);
			var img:Class = null;
			if (Type == BOSTON) {
				img = ImgBoston;
			} else if (Type == BULLTERRIER) {
				img = ImgBullTerrier;
			} else if (Type == BOXER) {
				img = ImgBoxer;
			} else if (Type == ENGLISH) {
				img = ImgEnglish;
			} else if (Type == FRENCHY) {
				img = ImgFrenchy;
			} else if (Type == PUG) {
				img = ImgPug;
			} else if (Type == SHARPEI) {
				img = ImgSharpei;
			}
			
			loadGraphic(img, true, false, 64, 64);
			frame = 0;
			
//			if (Type == BOSTON) {
				addAnimation("farty", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 15);
				addAnimationCallback(endFart);
//			}

			_fart = FlxG.loadSound(SndFart);
			type = Type;
			velocity.y = 400;
			initialized = false;
			state = State;
			targetIdx = Index;
			_dying = false;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			if (pathSpeed == 0 && path != null) {
				stopFollowingPath(true);
				velocity.x = 0;
				velocity.y = 0;
				state.onGemFinishedMoving(this);
			}
			
			if (!initialized) {
				if(FlxG.stage != null)
				{
					FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
		}
		
		public function initialize():void {
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		override public function update():void {
//			if (justTouched(UP | RIGHT | DOWN | LEFT)) {
//				state.onGemFinishedMoving(this);
//				immovable = true;
//			}
			var offAll:Boolean = true;
			if (overlapsPoint(FlxG.mouse.getWorldPosition())) {
				offAll = false;
				if (FlxG.mouse.justPressed()) {
					status = PRESSED;
				}
			}
			if (offAll) {
				status = NORMAL;
			}
			
			
			super.update();
		}
		
		override public function kill():void {
			play("farty");
			_fart.play();
			_dying = true;
//			state.onGemDied(this);
//			super.kill();
		}
		
		private function endFart(name:String, frameNo:uint, frameIdx:uint):void {
			if (name == "farty" && frameIdx == 10) {
				state.onGemDied(this);
				_dying = false;
				super.kill();
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void {
			if (status == PRESSED) {
				trace(event.stageX, event.stageY);
				state.onSelectGem(this);
			}
		}
		
		public function get left():Number {
			return x;
		}
		
		public function get right():Number {
			return x + width;
		}
		
		public function get top():Number {
			return y;
		}
		
		public function get bottom():Number {
			return y + height;
		}
		
		public function get dying():Boolean {
			return _dying;
		}
		
		public function set bone(bone:Boolean):void {
			var img:Class = null;
			if (bone) {
				if (type == BOSTON) {
					img = ImgBostonBone;
				} else if (type == BULLTERRIER) {
					img = ImgBullTerrierBone;
				} else if (type == BOXER) {
					img = ImgBoxerBone;
				} else if (type == ENGLISH) {
					img = ImgEnglishBone;
				} else if (type == FRENCHY) {
					img = ImgFrenchyBone;
				} else if (type == PUG) {
					img = ImgPugBone;
				} else if (type == SHARPEI) {
					img = ImgSharpeiBone;
				}
				loadGraphic(img, true, false, 64, 64);
				frame = 0;
			}
			_bone= bone
		}
		
		public function get bone():Boolean {
			return _bone;
		}
		
		public function get ball():Boolean {
			return _ball;
		}
		
		override public function toString():String {
//			return "Gem - Left: " + left + ", Top: " + top + ", Right: " + right + ", Bottom: " + bottom;
			return type.toString();
		}
		
		override public function revive():void {
			super.revive();
			_bone = false;
		}
		
		public function setType(Type:Number):void
		{
			type = Type;
			var img:Class = null;
			if (Type == BOSTON) {
				img = ImgBoston;
			} else if (Type == BULLTERRIER) {
				img = ImgBullTerrier;
			} else if (Type == BOXER) {
				img = ImgBoxer;
			} else if (Type == ENGLISH) {
				img = ImgEnglish;
			} else if (Type == FRENCHY) {
				img = ImgFrenchy;
			} else if (Type == PUG) {
				img = ImgPug;
			} else if (Type == SHARPEI) {
				img = ImgSharpei;
			} else if (Type == BALL) {
				img = ImgBall;
				_ball = true;
			}
			loadGraphic(img, true, false, 64, 64);
			frame = 0;
		}
	}
}