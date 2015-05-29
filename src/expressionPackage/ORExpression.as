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
		
		override public function toString(short:Boolean = false):String {
			var l:String = left.toString(short);
			var r:String = right.toString(short);
			
			if (l == "") {
				return r;
			} else if (r == "") {
				return l;
			} else {
				return l + " OR " + r;
			}
		}
	}
}