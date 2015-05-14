package expressionPackage {
	import flash.utils.Dictionary;
	
	public class Variable extends Expression {
		
		private var variable:String;

		public function Variable(variable:String) {
			this.variable = variable;
		}
		
		override public function evaluate(variables:Dictionary):Boolean {
			return (variables[variable] != undefined);
		}
		
		override public function toString():String {
			return "the " + variable;
		}
	}
}