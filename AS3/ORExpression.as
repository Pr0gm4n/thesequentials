package {
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
	}
}