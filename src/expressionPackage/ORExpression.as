package expressionPackage {
	import flash.utils.Dictionary;
	
	public class ORExpression extends Expression {
		
		private var left:Expression;
		private var right:Expression;

		public function ORExpression(left:Expression, right:Expression) {
			this.left = left;
			this.right = right;
		}
		
		override public function evaluate(variables:Dictionary):Boolean {
			return (left.evaluate(variables) || right.evaluate(variables));
		}
		
		override public function toString():String {
			if (left.toString() == "") {
				return right.toString();
			} else if (right.toString() == "") {
				return left.toString();
			} else {
				return left.toString() + " <b>OR</b> " + right.toString();
			}
		}
	}
}