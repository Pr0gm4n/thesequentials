package goalPackage {
	
	import expressionPackage.*;
	
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	
	public class LogicGoal extends MovieClip implements Goal {
		
		private var rows;
		private var cols;
		
		public var input:Array;
		public var goalNames:Array;
		
		private var targets:Vector.<Vector.<String>>;
		private var targetReached:Dictionary;
		
		private var goals:Array;

		public function LogicGoal(rows:uint, cols:uint) {
			this.rows = rows;
			this.cols = cols;
			
			this.input = new Array();
			this.goalNames = new Array();
			
			this.targets = new Vector.<Vector.<String>>(cols, true);
			for (var i:Number = 0; i < rows; i++) {
				targets[i] = new Vector.<String>(rows, true);
			}
			this.targetReached = new Dictionary();
			
			this.goals = new Array();
		}
		
		public function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean {
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
		
		public function parse():void {
			for each (var line in input) {
				if (line.length > 1) {
					var variables = line.replace("!", "").slice(0, -1).split(",");
					var expression:Expression = new Expression();
					for each (var variable in variables) {
						var goalName = variable;
						for (var name in goalNames) {
							goalName = goalName.replace(name + 1, goalNames[name].slice(0, -1));
						}
						expression = new ORExpression(expression, new Variable(variable, goalName));
					}
					if (line.charAt(0) == "!") {
						expression = new NOTExpression(expression);
					}
					goals.push(expression);
				}
			}
		}
		
		override public function toString():String {
			var task = "";
			if (goals.length > 0) {
				task = "Get " + goals.slice(0, -1).join(", ");
				if (goals.length > 1) {
					task +=  " AND ";
				}
				task += goals[goals.length - 1] + ".";
			};
			return task;
		}
	}
}