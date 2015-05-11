package {
	import flash.display.MovieClip;
	
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
		
		protected var goalX:uint;
		protected var goalY:uint;
		
		protected var block:Vector.<Vector.<Boolean>>;
		
		public function Grid(document:main, rows, cols, addCharacter:Boolean = true, goalX = 7, goalY = 7) {
			this.document = document;
			
			this.goalX = goalX;
			this.goalY = goalY;
			this.rows = rows;
			this.cols = cols;
			
			character = new Bug(document, this);
			character.gotoAndStop(1);
			if (addCharacter) {
				addChild(character);
			}
			
			block = new Vector.<Vector.<Boolean>>(rows, true);
			for (var i:Number = 0; i < rows; i++) {
				block[i] = new Vector.<Boolean>(cols, true);
			}
		}
		
		public function isAccessible(posX:uint, posY:uint):Boolean {
			return (0 <= posX && posX < this.cols && 0 <= posY && posY < this.rows && !block[posY][posX]);
		}
		
		public function isGoal(posX:uint, posY:uint):Boolean {
			return (posX == goalX && posY == goalY);
		}
		
		public function move(action:uint):void {
			character.move(action);
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