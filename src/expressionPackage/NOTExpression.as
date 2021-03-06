﻿package expressionPackage {
	import flash.utils.Dictionary;
	
	public class NOTExpression extends Expression {
		
		private var expression:Expression;

		public function NOTExpression(expression:Expression) {
			id = Expression.NOTEXPRESSION;
			
			this.expression = expression;
		}
		
		override public function evaluate(variables:Dictionary):Boolean {
			return !expression.evaluate(variables);
		}
		
		override public function toString(short:Boolean = false):String {
			return "NOT " + expression.toString(short);
		}
	}
}