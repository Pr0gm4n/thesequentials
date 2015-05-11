package {
	
	public class SimpleGoal extends Goal {
		
		private var goalX:uint;
		private var goalY:uint;

		public function SimpleGoal(goalX:uint, goalY:uint) {
			this.goalX = goalX;
			this.goalY = goalY;
		}
		
		override public function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean {
			return (posX == goalX && posY == goalY);
		}
	}
}