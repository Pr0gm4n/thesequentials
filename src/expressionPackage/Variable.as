package expressionPackage {
	import flash.utils.Dictionary;
	
	public class Variable extends Expression {
		
		private var variable:String;
		private var variableName:String;

		public function Variable(variable:String, variableName:String = "") {
			this.variable = variable;
			this.variableName = variableName;
		}
		
		override public function evaluate(variables:Dictionary):Boolean {
			return (variables[variable] != undefined);
		}
		
		override public function toString(short:Boolean = false):String {
			return (short ? variableName : "the " + variableName);
		}
	}
}