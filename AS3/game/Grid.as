package game {
		
	import goal.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Grid extends MovieClip {

		public static const EAST:uint = 0;
		public static const SOUTH:uint = 1;
		public static const WEST:uint = 2;
		public static const NORTH:uint = 3;

		public static const DX:uint = 112;
		public static const DY:uint = 112;
		
		private var document:main;
		
		public var rows;
		public var cols;
		
		protected var character:Bug;
		
		protected var goal:Goal;
		
		protected var block:Vector.<Vector.<Boolean>>;
		
		private var message;
		
		public function Grid(document:main, rows, cols, addCharacter:Boolean = true, goalX = 7, goalY = 7) {
			this.document = document;
			
			this.goal = new SimpleGoal(goalX, goalY);
			
			this.rows = rows;
			this.cols = cols;
			
			character = new Bug(this);
			character.gotoAndStop(1);
			if (addCharacter) {
				addChild(character);
			}
			
			block = new Vector.<Vector.<Boolean>>(cols, true);
			for (var i:Number = 0; i < cols; i++) {
				block[i] = new Vector.<Boolean>(rows, true);
			}
			
			this.message = new dialog;
			message.x = 940;
			message.y = 500;
			message.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				document.allowInput();
				document.removeChild(message);
			});
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
				document.addChild(message);
				document.blockInput();
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
	}
}