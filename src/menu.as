package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	
	public class menu extends MovieClip {
		
		public var document:main;
		
		var titleText;
		var buttons:Array;
		var glowButtons:Array;
		var backgroundPicture;
		
		protected var music:Sound;
		protected var channel:SoundChannel;
		
		protected var selection:int;
		
		public var isLoaded:Boolean;

		public function menu(d:main) {
			this.document = d;
			
			backgroundPicture = new backgroundImage;
			
			buttons = new Array();
			glowButtons = new Array();
			
			buttons.push(new advancedText);
			buttons[0].x = 940;
			buttons[0].y = 800;
			buttons[0].addEventListener(MouseEvent.CLICK, advancedButtonClick);
			glowButtons.push(new advancedTextGlow);
			glowButtons[0].x = 940;
			glowButtons[0].y = 800;
			glowButtons[0].addEventListener(MouseEvent.CLICK, advancedButtonClick);
			
			buttons.push(new intermediateText);
			buttons[1].x = 940;
			buttons[1].y = 700;
			buttons[1].addEventListener(MouseEvent.CLICK, intermediateButtonClick);
			glowButtons.push(new intermediateTextGlow);
			glowButtons[1].x = 940;
			glowButtons[1].y = 700;
			glowButtons[1].addEventListener(MouseEvent.CLICK, intermediateButtonClick);
			
			buttons.push(new beginnerText);
			buttons[2].x = 940;
			buttons[2].y = 600;
			buttons[2].addEventListener(MouseEvent.CLICK, beginnerButtonClick);
			glowButtons.push(new beginnerTextGlow);
			glowButtons[2].x = 940;
			glowButtons[2].y = 600;
			glowButtons[2].addEventListener(MouseEvent.CLICK, beginnerButtonClick);
			
			music = new Sound(new URLRequest("../Music/menu.mp3"));
			
			isLoaded = false;
		}
		
		public function reset():void {
			this.selection = 2; // easy mode
			
			document.setArduinoGoButton(true);
			document.setClickGoButton(function():void {
				document.setArduinoGoButton(false);
				switch (selection) {
					case 0: // red
						advancedButtonClick();
						break;
					case 1: // yellow
						intermediateButtonClick();
						break;
					case 2: // green
						beginnerButtonClick();
						break;
				}
			}, this);
			
			document.setNewInput(function(input:uint):void {
				select(document.input.last);
			}, this);
			
			loadMenu();
		}
		
		public function select(sel:int):void {
			if (selection != -1) {
				if (glowButtons[selection].stage) {
					removeChild(glowButtons[selection]);
				}
				addChild(buttons[selection]);
			}
			
			selection = ((sel % 3) + 3) % 3; // map negative values correctly
			
			if (buttons[selection].stage) {
				removeChild(buttons[selection]);
			}
			addChild(glowButtons[selection]);
		}
		
		private function buttonClick():void {
			document.restoreNewInput();
			removeMenu();
		}
		
		function beginnerButtonClick(e:MouseEvent = null):void {
			buttonClick();
			document.startEasyMode();
		}
		
		function intermediateButtonClick(e:MouseEvent = null):void {
			buttonClick();
			document.startIntermediateMode();
		}
		
		function advancedButtonClick(e:MouseEvent = null):void {
			buttonClick();
			document.startAdvancedMode();
		}
		
		private function loadMenu(){
			addChild(backgroundPicture);
			for (var i in buttons) {
				addChild(buttons[i]);
			}
			removeChild(buttons[selection]);
			addChild(glowButtons[selection]);
			
			channel = music.play(0, 1000);
			
			isLoaded = true;
		}
		
		private function removeMenu() {
			removeChild(backgroundPicture);
			for (var i in buttons) {
				if (buttons[i].stage) {
					removeChild(buttons[i]);
				}
				if (glowButtons[i].stage) {
					removeChild(glowButtons[i]);
				}
			}
			
			channel.stop();
			
			isLoaded = false;
		}
	}
}