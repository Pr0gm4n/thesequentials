package expressionPackage {
	import flash.utils.Dictionary;
	
	public class Expression {
		
		public static const EXPRESSION:uint = 0;
		public static const NOTEXPRESSION:uint = 1;
		public static const OREXPRESSION:uint = 2;
		public static const VARIABLE:uint = 3;
		
		public var id:uint;

		public function Expression() {
			id = EXPRESSION;
		}
		
		public function evaluate(variables:Dictionary):Boolean {
			return false;
		}
		
		public function toString(short:Boolean = false):String {
			return "";
		}
	}
}