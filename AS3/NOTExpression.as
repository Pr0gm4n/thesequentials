package {
	import flash.utils.Dictionary;
	
	public class NOTExpression extends Expression {
		
		private var expression:Expression;

		public function NOTExpression(expression:Expression) {
			this.expression = expression;
		}
		
		override public function evaluate(variables:Dictionary):Boolean {
			return !expression.evaluate(variables);
		}
	}
}