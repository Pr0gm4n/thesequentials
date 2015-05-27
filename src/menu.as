package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	
	public class menu extends MovieClip {
		
		public var document:main;
		
		var titleText;
		var beginnerLevelButton;
		var intermediateLevelButton;
		var advancedLevelButton;
		var backgroundPicture;
		
		protected var music:Sound;
		protected var channel:SoundChannel;
		
		protected var selection:uint;
		protected var selectionBackgrounds:Array;

		public function menu(d:main) {
			this.document = d;
			
			backgroundPicture = new backgroundImage;
			
			beginnerLevelButton = new beginnerText;
			beginnerLevelButton.x = 940;
			beginnerLevelButton.y = 600;
			beginnerLevelButton.addEventListener(MouseEvent.CLICK, beginnerButtonClick);
			
			intermediateLevelButton = new intermediateText;
			intermediateLevelButton.x = 940;
			intermediateLevelButton.y = 700;
			intermediateLevelButton.addEventListener(MouseEvent.CLICK, intermediateButtonClick);
			
			advancedLevelButton = new advancedText;
			advancedLevelButton.x = 940;
			advancedLevelButton.y = 800;
			advancedLevelButton.addEventListener(MouseEvent.CLICK, advancedButtonClick);
			
			music = new Sound(new URLRequest("../Music/menu.mp3"));
			
			this.selectionBackgrounds = [
				new selectionBackground,
				new selectionBackground,
				new selectionBackground
			];
			for (var sbg in selectionBackgrounds) {
				selectionBackgrounds[sbg].x = 940;
				selectionBackgrounds[sbg].y = 600 + sbg * 100;
			}
			this.selection = 0;
			
			document.setClickGoButton(function():void {
				switch (selection) {
					case 0:
						beginnerButtonClick();
						break;
					case 1:
						intermediateButtonClick();
						break;
					case 2:
						advancedButtonClick();
						break;
				}
				document.restoreNewInput();
			}, this);
			
			document.setNewInput(function(input:uint):void {
				select(document.input.last);
			}, this);
			
			loadMenu();
		}
		
		private function select(sel:uint):void {
			if (selectionBackgrounds[selection].stage) {
				removeChild(selectionBackgrounds[selection]);
			}
			selection = sel % 3;
			addChild(selectionBackgrounds[selection]);
		}
		
		function beginnerButtonClick(e:MouseEvent = null):void {
			removeMenu();
			document.startEasyMode();
		}
		
		function intermediateButtonClick(e:MouseEvent = null):void {
			removeMenu();
			document.startIntermediateMode();
		}
		
		function advancedButtonClick(e:MouseEvent = null):void {
			removeMenu();
			document.startAdvancedMode();
		}
		
		private function loadMenu(){
			addChild(backgroundPicture);
			addChild(beginnerLevelButton);
			addChild(intermediateLevelButton);
			addChild(advancedLevelButton);
			select(selection);
			
			channel = music.play(0, 1000);
		}
		
		private function removeMenu() {
			removeChild(backgroundPicture);
			removeChild(beginnerLevelButton);
			removeChild(intermediateLevelButton);
			removeChild(advancedLevelButton);
			if (selectionBackgrounds[selection].stage) {
				removeChild(selectionBackgrounds[selection]);
			}
			
			channel.stop();
		}
	}
}