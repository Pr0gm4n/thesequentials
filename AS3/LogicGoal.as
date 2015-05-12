package {
	import flash.utils.Dictionary;
	
	public class LogicGoal extends Goal {
		
		private var rows;
		private var cols;
		
		private var targets:Vector.<Vector.<String>>;
		private var targetReached:Dictionary;
		
		private var goals:Array;

		public function LogicGoal(rows:uint, cols:uint) {
			this.rows = rows;
			this.cols = cols;
			
			this.targets = new Vector.<Vector.<String>>(cols, true);
			for (var i:Number = 0; i < rows; i++) {
				targets[i] = new Vector.<String>(rows, true);
			}
			this.targetReached = new Dictionary();
			
			this.goals = new Array();
		}
		
		override public function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean {
			var target = targets[posX][posY];
			if (target != null && targetReached[target] == undefined) {
				targetReached[target] = true;
				
				var result = goals.every(function(expression:Expression, index:int = 0, array:Array = null):Boolean {
					return expression.evaluate(targetReached);
				});
				
				if (!keep) {
					delete targetReached[target];
				}
				return result;
			} else return false;
		}
		
		public function setPos(x:uint, y:uint, target:String):void {
			targets[x][y] = target;
		}
		
		public function parse(input:Array):void {
			goals.push(new ORExpression(new Variable("1"), new Variable("2")));
			goals.push(new Variable("3"));
			trace("parsing: " + input);
		}
	}
}