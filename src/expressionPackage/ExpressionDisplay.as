package expressionPackage {
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class ExpressionDisplay extends MovieClip {
		
		private var expression:Expression;
		
		private static const format = new TextFormat("a bug's life", 30);
		
		private var textField:TextField;
		private var tick:MovieClip;

		public function ExpressionDisplay(expression:Expression) {
			this.expression = expression;
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = format;
            textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = expression.toString();
			
			addChild(textField);
			this.height = textField.height;
			this.width = textField.width;
			
			this.tick = new MovieClip(); // TODO: show a tick
		}
		
		public function update(variables:Dictionary):void {
			var checked:Boolean = expression.evaluate(variables);
			if (checked && !tick.stage) {
				addChild(tick);
			}
			if (!checked && tick.stage) {
				removeChild(tick);
			}
		}
	}
}