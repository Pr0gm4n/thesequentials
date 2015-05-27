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
		var advnacedLevelButton;
		var backgroundPicture;
		
		protected var music:Sound;
		protected var channel:SoundChannel;

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
			
			advnacedLevelButton = new advancedText;
			advnacedLevelButton.x = 940;
			advnacedLevelButton.y = 800;
			advnacedLevelButton.addEventListener(MouseEvent.CLICK, advancedButtonClick);
			
			music = new Sound(new URLRequest("../Music/menu.mp3"));
			
			document.setNewInputOnce(function(input:uint):void {
				switch (document.input.last) {
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
			}, this);
			
			loadMenu();
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
			addChild(advnacedLevelButton);
			
			channel = music.play(0, 1000);
		}
		
		private function removeMenu() {
			removeChild(backgroundPicture);
			removeChild(beginnerLevelButton);
			removeChild(intermediateLevelButton);
			removeChild(advnacedLevelButton);
			
			channel.stop();
		}
	}
}