package expressionPackage {
	
	import flash.display.*;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class ExpressionDisplay extends MovieClip {
		
		private var expression:Expression;
		
		private static const fontSize:uint = 30;
		private static const format:TextFormat = new TextFormat("a bug's life", fontSize);
		
		private var textField:TextField;
		private var checkbox;
		private var tick;

		public function ExpressionDisplay(expression:Expression) {
			this.expression = expression;
			
			textField = new TextField();
			textField.y -= fontSize / 2;
			textField.embedFonts = true;
			textField.defaultTextFormat = format;
            textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = expression.toString();
			
			addChild(textField);
			this.height = textField.height;
			this.width = textField.width;
			
			this.checkbox = new goalCheckbox;
			checkbox.x = textField.x + textField.width + 15;
			checkbox.y = 0;
			addChild(checkbox);
			
			this.tick = new goalCheckboxTick;
			tick.x = checkbox.x;
			tick.y = checkbox.y;
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
		
		public function getCheckboxX():uint {
			return checkbox.x;
		}
		
		public function setCheckboxX(x:uint):void {
			checkbox.x = x;
			tick.x = x;
		}
	}
}