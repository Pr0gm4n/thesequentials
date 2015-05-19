package goalPackage {
	
	public interface Goal {
		function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean;
		function toString():String;
	}
}