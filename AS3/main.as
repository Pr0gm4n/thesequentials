﻿package {
	import gamePackage.*;
	import inputPackage.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.geom.ColorTransform;
	
	import net.eriksjodin.arduino.Arduino;
	
	public class main extends MovieClip{
		
		static const EASY:uint = 0;
		static const INTERMEDIATE:uint = 1;
		static const ADVANCED:uint = 2;
		
		static const cubeColor:Array = [0xff0000, 0xffdab9, 0x007f00];
		
		var mode:uint;
		var block_newInput:Boolean;
		
		// maps keycodes to bug movements
		private var codeMap:Dictionary;
		
		// handles the input and calls
		var input:Input;
		
		// handle connection to the arduino
		var arduino:Arduino;
		
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
		var goButton;
		var goButtonGreen;
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
			// */
			
			mainMenu = new menu(this);
			addChild(mainMenu);
			
			game = new Map(this, 400, 50, 8, 8, 2, 3);
			
			checkList = new mockList;
			checkList.x = 1350;
			checkList.y = 50;
			
			nextCubeColor = new ColorTransform();
			arduino = new Arduino();
			
			mode = EASY;
		}
		
		private function setupEasyMode() {
			addChild(game);
			addChild(checkList);
			nextInput();
			
			block_newInput = false;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode in codeMap) {
					newInput(codeMap[e.keyCode]);
				}
			});
			
			mode = EASY;
		}
		
		private function setupIntermediateMode() {
			setupAdvancedMode();
			
			game.setSpeed(1);
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
			
			mode = INTERMEDIATE;
		}
		
		private function setupAdvancedMode() {
			setupEasyMode();
			
			game.setSpeed(2);
			
			moves = [];
			moveDisplayArray = [];
			moveDisplayBackgrounds = [];
			addMoveDisplayBackground(200, 300);
			
			moveList = new inputText;
			moveList.x = 200;
			moveList.y = 150;
			
			goButton = new goText;
			goButton.x = 200;
			goButton.y = 900;
			
			goButtonGreen = new goTextGreen;
			goButtonGreen.x = goButton.x;
			goButtonGreen.y = goButton.y;
			
			enableGoButton = false;
			
			addChild(moveList);
			
			updateGoButton();
			
			movementDelay = new Timer(500, 4);
			
			goButtonGreen.addEventListener(MouseEvent.CLICK, clickGoButton);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == 32) { // spacebar
					clickGoButton();
				}
			});
			
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
				updateGoButton();
				
				addMoveDisplayBackground(200, 300);
			});
			
			mode = ADVANCED;
		}
		
		/**
		 * Start the game in easy mode: bug moves in real time.
		 */
		public function startEasyMode() {
			setupEasyMode();
		}
		
		/**
		 * Start the game in intermediate mode: bug moves every 4 inputs and has a ghost.
		 */
		public function startIntermediateMode() {
			setupIntermediateMode();
		}
		
		/**
		 * Start the game in advanced mode: bug moves every 4 inputs.
		 */
		public function startAdvancedMode() {
			setupAdvancedMode();
		}
		
		/**
		 * Process input depending on the selected mode:
		 *  - EASY (real time)
		 *  - INTERMEDIATE / ADVANCED (work in moves array and show arrows in moveDisplayArray)
		 */
		public function newInput(input:uint):void {
			if (block_newInput) return;
			if (mode == EASY) {
				game.move(input);
				nextInput();
			} else { // intermediate/advanced mode
				if (input == Bug.UNDO) {
					if (moves.length > 0) {
						moves.splice(-1, 1);
						var tmp = moveDisplayArray.splice(-1, 1);
						removeChild(tmp[0]);
						tmp = moveDisplayBackgrounds.splice(-1, 1);
						removeChild(tmp[0]);
						
						lastInput();
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
					arrow.x = 200;
					arrow.y = (300 + 130 * (moves.length - 1));
					moveDisplayArray.push(arrow);
					addChild(arrow);
				
					nextInput();
					
					if (moveDisplayBackgrounds.length < 4) {
						addMoveDisplayBackground(arrow.x, arrow.y + 130);
					}
				}
				updateGoButton();
			}
		}
		
		public function blockInput():void {
			block_newInput = true;
		}
		
		public function allowInput():void {
			block_newInput = false;
		}
		
		private function nextInput():void {
			if (input.next != -1) {
				input.next = (input.last + 1) % cubeColor.length;
				
				nextCubeColor.color = cubeColor[input.next];
				updateArduino();
			}
		}
		
		private function lastInput():void {
			if (input.next != -1) {
				input.next = (input.last + cubeColor.length) % cubeColor.length;
				input.last = (input.last + cubeColor.length - 1) % cubeColor.length;
				
				nextCubeColor.color = cubeColor[input.next];
				updateArduino();
			}
		}
		
		private function clickGoButton(e:MouseEvent = null):void {
			if (moves.length == 4 || enableGoButton) {
				movementDelay.start();
				blockInput();
				
				input.last = -1;
			}
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
			if (moves.length == 4 || enableGoButton) {
				if (goButton.stage) {
					removeChild(goButton);
				}
				addChild(goButtonGreen);
			} else {
				if (goButtonGreen.stage) {
					removeChild(goButtonGreen);
				}
				addChild(goButton);
			}
		}
		
		private function addMoveDisplayBackground(x:uint, y:uint):void {
			var background = new Token();
			background.x = x - 0.5 * background.width;
			background.y = y - 0.5 * background.height;
			background.transform.colorTransform = nextCubeColor;
			moveDisplayBackgrounds.push(background);
			addChild(background);
		}
		
		private function updateArduino():void {
			if (arduino.connected) {
				switch(nextCubeColor.color) {
					case cubeColor[0]:
						trace("10: 0, 11: 1");
						arduino.writeDigitalPin(10, 0);
						arduino.writeDigitalPin(11, 1);
						break;
					case cubeColor[1]:
						trace("10: 1, 11: 0");
						arduino.writeDigitalPin(10, 1);
						arduino.writeDigitalPin(11, 0);
						break;
					default:
						trace("10: 1, 11: 1");
						arduino.writeDigitalPin(10, 1);
						arduino.writeDigitalPin(11, 1);
				}
			}
		}
	}
}