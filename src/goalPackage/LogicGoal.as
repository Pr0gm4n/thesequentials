package goalPackage {
	
	import expressionPackage.*;
	
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	public class LogicGoal extends MovieClip implements Goal {
		
		private var rows;
		private var cols;
		
		public var input:Array;
		public var goalNames:Array;
		
		private var targets:Vector.<Vector.<String>>;
		private var targetReached:Dictionary;
		
		private var goals:Array;
		private var goalDisplays:Array;

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
			this.goalDisplays = new Array();
		}
		
		public function isGoal(posX:uint, posY:uint, keep:Boolean = true):Boolean {
			var target = targets[posX][posY];
			if (target != null && targetReached[target] == undefined) {
				targetReached[target] = true;
				
				var result = goals.every(function(expression:Expression, index:int = 0, array:Array = null):Boolean {
					return expression.evaluate(targetReached);
				});
				
				var reachable:Boolean;
				if (keep) {
					for each (var goalDisplay in goalDisplays) {
						reachable = goalDisplay.update(targetReached);
						if (!reachable) {
							trace("END");
						}
					}
				} else {
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
			var xMax:uint = 0;
			var header = new Bitmap(new goalsText);
			var goalDisplay:ExpressionDisplay;
			for (var goal in goals) {
				goalDisplay = new ExpressionDisplay(goals[goal]);
				xMax = Math.max(xMax, goalDisplay.getCheckboxX());
				goalDisplay.x = header.width;
				goalDisplay.y = (header.height / 2) + (goal - goals.length / 2.0) * (goalDisplay.height + 10);
				goalDisplay.update(targetReached, false);
				goalDisplays.push(goalDisplay);
				addChild(goalDisplay);
			}
			for each (goalDisplay in goalDisplays) {
				goalDisplay.setCheckboxX(xMax);
			}
			
			header.y = -1 * (header.height + (goals.length * (goalDisplay.height + 10) / 2));
			addChild(header);
			
			if (goalDisplays.length > 1) {
				var element:Bitmap = new Bitmap(new andBracket);
				element.x = header.width / 2;
				element.y = goalDisplays[0].y;
				element.height = goalDisplay.y - element.y;
				addChild(element);
				element = new Bitmap(new andText);
				element.x = header.width / 2 - element.width - 10;
				element.y = (goalDisplays[0].y + goalDisplay.y - element.height) / 2;
				addChild(element);
			}
			
			var bracket:Bitmap = new Bitmap(new leftBracket);
			bracket.x = -20 - bracket.width;
			bracket.y = header.y - 10;
			bracket.height = goalDisplay.y + goalDisplay.height / 2 - header.y + 10;
			addChild(bracket);
			bracket = new Bitmap(new rightBracket);
			bracket.x = goalDisplay.x + xMax + goalDisplay.checkbox.width + 20;
			bracket.y = header.y - 10;
			bracket.height = goalDisplay.y + goalDisplay.height / 2 - header.y + 10;
			addChild(bracket);
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