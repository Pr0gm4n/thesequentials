package goalPackage {
	
	public class SimpleGoal implements Goal {
		
		private var goalX:uint;
		private var goalY:uint;
		private var type:uint;

		public function SimpleGoal(goalX:uint = 7, goalY:uint = 7, type:uint = 1) {
			this.goalX = goalX;
			this.goalY = goalY;
			this.type = type;
		}
		
		public function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean {
			return (posX == goalX && posY == goalY);
		}
		
		public function toString():String {
			return "Get " + type + ".";
		}
	}
}