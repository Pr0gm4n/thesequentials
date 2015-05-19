package expressionPackage {
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class ExpressionDisplay extends MovieClip {
		
		private var expression:Expression;

		public function ExpressionDisplay(expression:Expression) {
			this.expression = expression;
		}
		
		public function update(variables:Dictionary):void {
			var tick:Boolean = expression.evaluate(variables);
			trace(expression.toString() + ": " + tick);
		}
	}
}