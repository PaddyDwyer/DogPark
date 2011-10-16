package
{
	import flash.events.MouseEvent;
	
	import org.flixel.*;
	
	public class Gem extends FlxSprite
	{
		[Embed(source="data/boston.png")] private var ImgBoston:Class;
		[Embed(source="data/bostonbone.png")] private var ImgBostonBone:Class;
		[Embed(source="data/bostoncookie.png")] private var ImgBostonCookie:Class;
		[Embed(source="data/bernard.png")] private var ImgBernard:Class;
		[Embed(source="data/bernardbone.png")] private var ImgBernardBone:Class;
		[Embed(source="data/bernardcookie.png")] private var ImgBernardCookie:Class;
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
		
		public var type:Number;
		public var status:uint;
		public var idx:uint;
		public var targetIdx:Number;
		public var justMoved:Boolean = true;
		
		public static const BOSTON:Number = 0;
		public static const BERNARD:Number = 1;
		public static const BOXER:Number = 2;
		public static const ENGLISH:Number = 3;
		public static const FRENCHY:Number = 4;
		public static const PUG:Number = 5;
		
		public static const NORMAL:uint = 0;
		public static const PRESSED:uint = 1;
		
		private var initialized:Boolean;
		private var state:PlayState;
		private var _bone:Boolean;
		private var _cookie:Boolean;
		
		public function Gem(X:Number, Y:Number, Type:Number, State:PlayState, Index:uint)
		{
			var img:Class = null;
			if (Type == BOSTON) {
				img = ImgBoston;
			} else if (Type == BERNARD) {
				img = ImgBernard;
			} else if (Type == BOXER) {
				img = ImgBoxer;
			} else if (Type == ENGLISH) {
				img = ImgEnglish;
			} else if (Type == FRENCHY) {
				img = ImgFrenchy;
			} else if (Type == PUG) {
				img = ImgPug;
			}
			super(X, Y, img);

			type = Type;
			velocity.y = 400;
			initialized = false;
			state = State;
			targetIdx = Index;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			
			if (!initialized) {
				if(FlxG.stage != null)
				{
					FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
		}
		
		override public function update():void {
			if (justTouched(UP | RIGHT | DOWN | LEFT)) {
				state.onGemFinishedMoving(this);
//				immovable = true;
			}
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
		
		protected function onMouseUp(event:MouseEvent):void {
			if (status == PRESSED) {
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
		
		public function set bone(bone:Boolean):void {
			var img:Class = null;
			if (bone) {
				if (type == BOSTON) {
					img = ImgBostonBone;
				} else if (type == BERNARD) {
					img = ImgBernardBone;
				} else if (type == BOXER) {
					img = ImgBoxerBone;
				} else if (type == ENGLISH) {
					img = ImgEnglishBone;
				} else if (type == FRENCHY) {
					img = ImgFrenchyBone;
				} else if (type == PUG) {
					img = ImgPugBone;
				}
				loadGraphic(img);
			}
			_bone= bone
		}
		
		public function set cookie(cookie:Boolean):void {
			var img:Class = null;
			if (cookie) {
				if (type == BOSTON) {
					img = ImgBostonCookie;
				} else if (type == BERNARD) {
					img = ImgBernardCookie;
				} else if (type == BOXER) {
					img = ImgBoxerCookie;
				} else if (type == ENGLISH) {
					img = ImgEnglishCookie;
				} else if (type == FRENCHY) {
					img = ImgFrenchyCookie;
				} else if (type == PUG) {
					img = ImgPugCookie;
				}
				loadGraphic(img);
			}
			_cookie = cookie;
		}
		
		override public function toString():String {
//			return "Gem - Left: " + left + ", Top: " + top + ", Right: " + right + ", Bottom: " + bottom;
			return type.toString();
		}
		
		override public function revive():void {
			super.revive();
			_cookie = false;
			_bone = false;
		}
		
		public function setType(Type:Number):void
		{
			type = Type;
			var img:Class = null;
			if (Type == BOSTON) {
				img = ImgBoston;
			} else if (Type == BERNARD) {
				img = ImgBernard;
			} else if (Type == BOXER) {
				img = ImgBoxer;
			} else if (Type == ENGLISH) {
				img = ImgEnglish;
			} else if (Type == FRENCHY) {
				img = ImgFrenchy;
			} else if (Type == PUG) {
				img = ImgPug;
			}
			loadGraphic(img);
		}
	}
}