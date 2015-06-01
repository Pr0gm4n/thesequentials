package {
	import gamePackage.*;
	import inputPackage.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.ColorTransform;
	
	import net.eriksjodin.arduino.Arduino;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class main extends MovieClip{
		
		public static const WIDTH = 1920;
		public static const HEIGHT = 1080;
		
		public static const EASY:uint = 1;
		public static const INTERMEDIATE:uint = 2;
		public static const ADVANCED:uint = 3;
		
		public static const NUMBER_OF_MAPS:uint = 4;
		public static const NUMBER_OF_LAYOUTS:uint = 1;
		
		public static const cubeColors:Array = [0xff0000, 0xffff00, 0x00ff00, 0x0000ff];
		public static const rgbLEDColors:Array = [0xff0000, 0xff6e00, 0x00ff00, 0x0000ff];
		public static const cubeColorStrings:Array = ["red", "yellow", "green", "blue"];
		public static const SOUNDPATH:String = "../Sounds/";
		public static const NEXTPLAYERSOUND_PREFIX:String = "next_";
		public static const NEXTPLAYERSOUND_FILEEXTENSION:String = ".mp3";
		
		public var nextPlayerSounds:Array;
		
		public var mode:uint;
		var block_newInput:Boolean;
		
		// maps keycodes to bug movements
		private var codeMap:Dictionary;
		
		// handles the input and calls
		public var input:Input;
		public var newInput:Function;
		private var newInputBackup:Function;
		private var redecide:Boolean;
		
		// handle connection to the arduino
		var arduino:Arduino;
		var block_goButton:Boolean;
		
		// basic display objects
		var mainMenu:menu;
		var game:Grid;
		var checkList;
		
		// intermediate/advanced mode
		var moves:Array;
		var moveDisplayArray:Array;
		var moveDisplayBackgrounds:Array;
		var moveList;
		var nextCubeColor;
		
		public var clickGoButton:Function;
		private var clickGoButtonBackup:Function;
		public var enableGoButton:Boolean;
		
		// delays movement of bug in intermediate/advanced mode
		var movementDelay:Timer;
		
		public function main() {
			codeMap = new Dictionary();
			codeMap[37] = Bug.TURNLEFT;
			codeMap[38] = Bug.FORWARD;
			codeMap[39] = Bug.TURNRIGHT;
			codeMap[40] = Bug.UNDO;
			
			//*
			input = new FiducialInput(this);
			/*/
			input = new KeyboardInput(this);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode in codeMap) {
					newInput(codeMap[e.keyCode]);
				}
			});
			// */
			
			mainMenu = new menu(this);
			
			arduino = new Arduino();
			arduino.addEventListener(Event.CONNECT, function(e:Event):void {
				trace("connected to Serproxy");
				arduino.requestFirmwareVersion();
			});
			arduino.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void {
				trace("connection to Serproxy failed");
			});
			arduino.addEventListener(ArduinoEvent.FIRMWARE_VERSION, function(e:ArduinoEvent):void {
				trace("connected to Arduino");
				arduino.setPinMode(2, Arduino.INPUT);
				arduino.setPinMode(3, Arduino.PWM); // blue
				arduino.setPinMode(5, Arduino.PWM); // red
				arduino.setPinMode(6, Arduino.PWM); // green
				arduino.setPinMode(9, Arduino.OUTPUT); // goButton
				
				arduino.enableDigitalPinReporting();
				
				setArduinoGoButton(true); // for the menu selection
			});
			arduino.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event = null):void {
				trace("IO_ERROR: " + e.toString());
			});
			
			setClickGoButton(function():void {});
			block_goButton = false;
			arduino.addEventListener(ArduinoEvent.DIGITAL_DATA, function(e:ArduinoEvent):void {
				if (!block_goButton && e.pin == 2 && e.value == 0) { // GO button is pressed
					block_goButton = true;
					clickGoButton();
					delayCallback(100, function():void {
						block_goButton = false;
					});
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == 32) { // <SPACE>
					clickGoButton();
				}
				if (e.keyCode == 116 || e.keyCode == 82) { // <F5> or <r>
					reset();
				}
			});
			
			nextPlayerSounds = new Array();
			for each (var color in cubeColorStrings) {
				nextPlayerSounds.push(new Sound(new URLRequest(SOUNDPATH + NEXTPLAYERSOUND_PREFIX + color + NEXTPLAYERSOUND_FILEEXTENSION)));
			}
			
			reset(false);
		}
		
		public function reset(removeChildren:Boolean = true):void {
			if (mainMenu.isLoaded) {
				mainMenu.select(0);
			} else {
				if (removeChildren) {
					this.removeChildren();
			
					mode = undefined;
					game.close();
					game = undefined;
					moves = undefined;
					moveDisplayArray = undefined;
					moveDisplayBackgrounds = undefined;
					moveList = undefined;
					enableGoButton = undefined;
					movementDelay = undefined;
				}
				
				input.reset();
				
				setNewInput(newInputDefault, this);
				block_newInput = true;
				
				setClickGoButton(function():void {});
				
				mainMenu.reset();
				addChild(mainMenu);
			}
		}
		
		private function setupEasyMode() {
			game = new Map(this, 300, 75, 8, 8, random(1, NUMBER_OF_MAPS), mode, random(1, NUMBER_OF_LAYOUTS));
			addChild(game);
			
			nextCubeColor = new ColorTransform();
			input.last = -1;
			input.next = 0;
			nextInput();
			
			moveDisplayBackgrounds = new Array();
			
			setClickGoButton(function():void {});
		}
		
		private function setupIntermediateMode() {
			setupAdvancedMode();
			
			game.setSpeed(1.0);
			movementDelay.delay = 1000;
			
			var ghostDelay:Timer = new Timer(8000);
			ghostDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent = null):void {
				if (moves.length > 0 && !block_newInput) {
					var tmpMoves:Array = moves.slice(); // shallow copy, works for non-object arrays
					
					var ghost:Bug = new Bug(game, game.getPosX(), game.getPosY(), game.getDirection(), 2, 0.5);
					ghost.gotoAndStop(1);
					game.addChild(ghost);
					
					var ghostTick = new Timer(500, 2 * tmpMoves.length + 2);
					ghostTick.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
						if (block_newInput) {
							ghostTick.stop();
							game.removeChild(ghost);
						}
						var count:int = ghostTick.currentCount - 1;
						if (count < tmpMoves.length) {
							ghost.move(tmpMoves[count]);
						}
					});
					ghostTick.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
						game.removeChild(ghost);
					});
					ghostTick.start();
				}
			});
			ghostDelay.start();
		}
		
		private function setupAdvancedMode() {
			setupEasyMode();
			
			game.setSpeed(1.2);
			
			moves = new Array();
			moveDisplayArray = new Array();
			
			moveList = new inputText;
			moveList.x = 150;
			moveList.y = 150;
			
			enableGoButton = false;
			redecide = false;
			
			addChild(moveList);
			
			updateGoButton();
			setClickGoButton(clickGoButtonDefault, this);
			
			movementDelay = new Timer(500, 4);
			movementDelay.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				if (moves.length > 0) {
					game.move(moves.shift());
					removeChild(moveDisplayArray.shift());
					removeChild(moveDisplayBackgrounds.shift());
				}
			});
			movementDelay.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				movementDelay.reset();
				allowInput();
				
				if (!game.isFinished) {
					nextPlayerSounds[input.next].play();
					updateGoButton();
				}
			});
		}
		
		/**
		 * Start the game in easy mode: bug moves in real time.
		 */
		public function startEasyMode() {
			mode = EASY;
			setupEasyMode();
		}
		
		/**
		 * Start the game in intermediate mode: bug moves every 4 inputs and has a ghost.
		 */
		public function startIntermediateMode() {
			mode = INTERMEDIATE;
			setupIntermediateMode();
		}
		
		/**
		 * Start the game in advanced mode: bug moves every 4 inputs.
		 */
		public function startAdvancedMode() {
			mode = ADVANCED;
			setupAdvancedMode();
		}
		
		/**
		 * Process input depending on the selected mode:
		 *  - EASY (real time)
		 *  - INTERMEDIATE / ADVANCED (work in moves array and show arrows in moveDisplayArray)
		 */
		private function newInputDefault(input:uint):void {
			if (block_newInput) return;
			if (mode == EASY) {
				game.move(input);
				if (input == Bug.UNDO) {
					lastInput();
				} else {
					nextInput();
					if (game.character.last != Bug.UNDO && !block_newInput) { // only play when not redeciding and level not finished yet
						nextPlayerSounds[this.input.next].play();
					}
				}
			} else { // intermediate/advanced mode
				if (input == Bug.UNDO) {
					if (moves.length > 0) {
						moves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
						tmp = moveDisplayBackgrounds.splice(-1, 1);
						removeChild(tmp[0]);
						
						lastInput();
						redecide = true;
					}
				} else if (moves.length < 4) {
					moves.push(input);
					
					var arrow;
					switch (input) {
						case Bug.FORWARD:
							arrow = new goForwardArrow();
							break;
						case Bug.TURNLEFT:
							arrow = new turnLeftArrow();
							break;
						case Bug.TURNRIGHT:
							arrow = new turnRightArrow();
							break;
					}
					arrow.x = 150;
					arrow.y = (300 + 130 * (moves.length - 1));
					moveDisplayArray.push(arrow);
					
					var background = new Token();
					background.x = arrow.x - 0.5 * background.width;
					background.y = arrow.y - 0.5 * background.height;
					background.transform.colorTransform = nextCubeColor;
					moveDisplayBackgrounds.push(background);
					addChild(background);
					addChild(arrow);
					
					nextInput();
					if (moves.length < 4 && !redecide) { // only play when moves list not full and not redeciding
						nextPlayerSounds[this.input.next].play();
					}
					redecide = false;
				}
				updateGoButton();
			}
		}
		
		public function setNewInput(callback:Function, context:Object = null, args:Array = null):void {
			if (args == null) {
				args = new Array();
			}
			this.newInputBackup = this.newInput;
			this.newInput = function(input:uint):void {
				args.unshift(input);
				callback.apply(context, args);
				args.shift();
			};
		}
		
		public function restoreNewInput():void {
			this.newInput = this.newInputBackup;
		}
		
		public function setNewInputOnce(callback:Function, context:Object = null, args:Array = null):void {
			var tmpNewInput:Function = this.newInput;
			if (args == null) {
				args = new Array();
			}
			this.newInput = function(input:uint):void {
				this.newInput = tmpNewInput;
				args.unshift(input);
				callback.apply(context, args);
				args.shift();
			};
		}
		
		public function blockInput():void {
			block_newInput = true;
		}
		
		public function allowInput():void {
			block_newInput = false;
		}
		
		private function nextInput():void {
			if (input.next != -1) {
				input.next = (input.last + 1) % cubeColors.length;
				
				nextCubeColor.color = cubeColors[input.next];
				updateArduino();
			}
		}
		
		private function lastInput():void {
			if (input.next != -1) {
				input.next = (input.last + cubeColors.length) % cubeColors.length;
				input.last = (input.last + cubeColors.length - 1) % cubeColors.length;
				
				nextCubeColor.color = cubeColors[input.next];
				updateArduino();
			}
		}
		
		private function clickGoButtonDefault():void {
			if (moves.length == 4 || enableGoButton) {
				movementDelay.start();
				blockInput();
				
				input.last = -1;
			}
		}
		
		public function setClickGoButton(callback:Function, context:Object = null, args:Array = null):void {
			this.clickGoButtonBackup = this.clickGoButton;
			this.clickGoButton = function(e:Object = null):void {
				callback.apply(context, args);
			};
		}
		
		public function restoreClickGoButton():void {
			this.clickGoButton = this.clickGoButtonBackup;
		}
		
		public function setClickGoButtonOnce(callback:Function, context:Object = null, args:Array = null):void {
			var tmpClickGoButton:Function = this.clickGoButton;
			this.clickGoButton = function(e:Object = null):void {
				this.clickGoButton = tmpClickGoButton;
				callback.apply(context, args);
			};
		}
		
		/**
		 * Toggles between grey/green GoButton.
		 */
		private function updateGoButton():void {
			if (moves.length < 4) {
				var ghost:Bug = new Bug(game, game.getPosX(), game.getPosY(), game.getDirection(), 10, 0);
				ghost.gotoAndStop(1);
				for (var i:Number = 0; i < moves.length; i++) {
					ghost.move(moves[i]);
				}
				enableGoButton = game.getGoal().isGoal(ghost.posX, ghost.posY, false);
			}
			setArduinoGoButton(enableGoButton || moves.length == 4);
		}
		
		public function setArduinoGoButton(value:Boolean):void {
			if (arduino.connected) {
				arduino.writeDigitalPin(9, (value ? 1 : 0));
				arduino.flush();
			}
		}
		
		private function updateArduino():void {
			if (arduino.connected) {
				var index:int = cubeColors.indexOf(nextCubeColor.color);
				if (0 <= index && index < rgbLEDColors.length) {
					var mask:uint = rgbLEDColors[index];
					arduino.writeAnalogPin(5, mask >>> 16); // R
					arduino.writeAnalogPin(6, (mask >>> 8) & 0xff); // G
					arduino.writeAnalogPin(3, mask & 0xff); // B
					arduino.flush();
				} else trace("main.updateArduino(): invalid index: " + index + " for rgbLEDColors (" + rgbLEDColors.length + " elements)");
			}
		}
		
		/**
		 * Generate a random number in the interval [min,max] (inclusive).
		 */
		public static function random(min:Number, max:Number):Number {
			return Math.floor(Math.random() * (max + 1 - min)) + min;
		}
		
		/**
		 * Delay the call to a function in milliseconds.
		 */
		public static function delayCallback(delay:uint, callback:Function, context:Object = null, args:Array = null):void {
			var t:Timer = new Timer(delay, 1);
			var onComplete:Function = function():void {
				// cleanup
				t.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				
				callback.apply(context, args);
			};
			t.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			t.start();
		}
	}
}
