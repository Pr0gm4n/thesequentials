﻿package gamePackage {
		
	import goalPackage.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class Grid extends MovieClip {
		
		public static const SOUNDPATH:String = "../Sounds/";
		public static const SOUND_FILEEXTENSION:String = ".mp3";

		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;

		public static const DX:uint = 112;
		public static const DY:uint = 112;
		
		public var document:main;
		
		public var rows:uint;
		public var cols:uint;
		public var isFinished:Boolean;
		
		public var character:Bug;
		
		protected var goal:Goal;
		
		protected var block:Vector.<Vector.<Boolean>>;
		
		protected var welldone:Sound;
		
		public function Grid(document:main, rows, cols, restartGame:Boolean = true) {
			this.document = document;
			
			this.rows = rows;
			this.cols = cols;
			
			block = new Vector.<Vector.<Boolean>>(cols, true);
			for (var i:Number = 0; i < cols; i++) {
				block[i] = new Vector.<Boolean>(rows, true);
			}
			this.welldone = new Sound(new URLRequest(SOUNDPATH + "welldone" + SOUND_FILEEXTENSION));
			
			if (restartGame) {
				restart(false);
			}
		}
		
		public function close():void {
			removeChildren();
		}
		
		public function restart(removeChildren:Boolean = true):void {
			if (removeChildren) {
				this.removeChildren();
			}
			this.goal = new SimpleGoal();
			this.isFinished = false;
			
			character = new Bug(this);
			character.gotoAndStop(1);
			addChild(character);
		}
		
		public function isAccessible(posX:uint, posY:uint):Boolean {
			return (0 <= posX && posX < this.cols && 0 <= posY && posY < this.rows && !block[posX][posY]);
		}
		
		public function getGoal():Goal {
			return goal;
		}
		
		public function move(action:uint):void {
			character.move(action);
			if (goal.isGoal(character.posX, character.posY)) {
				isFinished = true;
				document.blockInput();
				addMessage("Well done!", 100, function():void {
					document.reset();
				});
				welldone.play();
			}
		}
		
		public function getPosX():uint {
			return character.posX;
		}
		
		public function getPosY():uint {
			return character.posY;
		}
		
		public function getDirection():int {
			return character.direction;
		}
		
		public function setSpeed(speed:Number):void {
			character.speed = speed;
		}
		
		public function addMessage(message:String, fontSize:Number = 30, callback:Function = null, context:Object = null, args:Array = null):void {
			var box = new dialog;
			box.x = main.WIDTH / 2 - this.x;
			box.y = rows * DY / 2;
			
			var textField:TextField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = new TextFormat("a bug's life", fontSize);
            textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = box.x;
			textField.y = box.y - fontSize / 2;
			textField.htmlText = message;
			
			box.width = Math.max(textField.width + 150, 1100);
			box.height = Math.max(textField.height + 30, 450);
			
			addChild(box);
			addChild(textField);
			
			document.setArduinoGoButton(true);
			document.setClickGoButtonOnce(function():void {
				removeChild(textField);
				removeChild(box);
				document.setArduinoGoButton(false);
				if (callback != null) {
					callback.apply(context, args);
				}
			}, this);
		}
	}
}