package expressionPackage {
	
	import flash.display.*;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class ExpressionDisplay extends MovieClip {
		
		public static const SOUNDPATH:String = "../Sounds/";
		public static const SOUND_FILEEXTENSION:String = ".mp3";
		
		private var expression:Expression;
		
		private static const fontSize:uint = 30;
		private static const format:TextFormat = new TextFormat("a bug's life", fontSize);
		
		private var textField:TextField;
		public var checkbox;
		private var tick;
		
		private var achieveGoal:Sound;

		public function ExpressionDisplay(expression:Expression) {
			this.expression = expression;
			
			textField = new TextField();
			textField.y -= fontSize / 2;
			textField.embedFonts = true;
			textField.defaultTextFormat = format;
            textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = expression.toString(true);
			
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
			
			this.achieveGoal = new Sound(new URLRequest(SOUNDPATH + "goal_achieve" + SOUND_FILEEXTENSION));
		}
		
		/**
		 * Updates the display according to the state of passed variables.
		 * 
		 * @returns reachable:Boolean indicates whether the expression is still satisfiable
		 */
		public function update(variables:Dictionary, playSound:Boolean = true):Boolean {
			var checked:Boolean = expression.evaluate(variables);
			if (checked && !tick.stage) {
				addChild(tick);
				if (playSound) {
					achieveGoal.play();
				}
			}
			if (!checked) {
				if (tick.stage) {
					removeChild(tick);
				}
				if (expression.id == Expression.NOTEXPRESSION) {
					var tf:TextField = new TextField;
					tf.x = textField.x - 5;
					tf.y = textField.y - 10;
					tf.width = checkbox.x + checkbox.width - tf.x + 10;
					tf.height = textField.height + 10;
					tf.border = true;
					tf.background = true;
					tf.backgroundColor = 0xff0000;
					tf.alpha = 0.5;
					addChild(tf);
					return false;
				}
			}
			return true;
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