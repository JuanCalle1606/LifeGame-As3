/*
 * Copyright (C) 2020 Juan Pablo Calle
 *
 * Este software se proporciona 'tal cual', sin ninguna garantía expresa o implícita.
 * En ningún caso, los autores serán responsables de los daños que se deriven del
 * uso de este software.
 *
 * Se concede permiso a cualquier persona para utilizar este software para
 * cualquier propósito, incluidas las aplicaciones comerciales, y para modificarlo y
 * redistribuirlo libremente, sujeto a las siguientes restricciones:
 *
 * 1. El origen de este software no debe ser tergiversado; No debes reclamar
 *    que escribiste el software original. Si utiliza este software en un producto,
 *    se agradecería un reconocimiento en la documentación del producto, pero no
 *    es obligatorio.
 * 2. Las versiones fuente modificadas deben estar claramente marcadas como
 *     tales y no deben tergiversarse como si fueran el software original.
 * 3. Este aviso no puede ser eliminado ni alterado de ninguna distribución.
 */
 
package 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	
	//--------------------------------------
	//  Descripcion de la clase
	//--------------------------------------
	/**
	 * The Main class is the base class of the game and in which all the logic occurs
	 *
	 * @langversion 3.0
	 *
	 * @playerversion Flash 12
	 *  @playerversion AIR 32
	 *
	 * @productversion Flash CS6
	 * @productversion Animate CC 2020
	 *
	 * @author Juan Pablo Calle
	 */
	public class Main extends Sprite 
	{
		///Save the state of each cell
		public var Cells:Vector.<Vector.<Boolean>>;
		///Save a copy of the state of the cells to be able to perform the calculations correctly
		public var _Cells:Vector.<Vector.<Boolean>>;
		
		///Indicates the number of cells that will be placed vertically
		public var vCells:uint = 80;
		///Indicates the number of cells that will be placed horizontally
		public var hCells:uint = 50;
		///Indicates the width of each cell
		public var cellW:Number = 0;
		///Indicate the height of each cell
		public var cellH:Number = 0;
		
		public var curI:int = 0;
		public var curJ:int = 0;
		
		///Indicates the number of neighboring cells, it is updated in each iteration for each cell
		public var nCells:uint = 0;
		
		///Constant that indicates the size in pixels that all cells occupy vertically
		public const sizeH:uint = 500;
		///Constant that indicates the size in pixels that all cells occupy horizontally
		public const sizeW:uint = 800;
		
		///Indicates if the game is in pause or no
		public var pause:Boolean = false;
		public var isClicked:Boolean = false;
		public var lastClick:String = "";
		
		///Stopwatch that indicates how often the screen should be redrawn
		public var reset:Timer = new Timer(20, 1);
		
		/**
		 * Start of the program, here we call to initialize the vector of the cells and add the EventListeners
		 */
		public function Main()
		{
			reset.addEventListener(TimerEvent.TIMER_COMPLETE, reDraw);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, onClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseChange);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseChange);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseChange);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseChange);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			initCells();
		}
		
		private function onMouseChange(e:MouseEvent):void 
		{
			if (e.type==MouseEvent.MOUSE_DOWN||e.type==MouseEvent.RIGHT_MOUSE_DOWN) 
			{
				isClicked = true;
			}
			else if (e.type==MouseEvent.MOUSE_UP||e.type==MouseEvent.RIGHT_MOUSE_UP) 
			{
				isClicked = false;
			}
			lastClick = e.type;
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (isClicked) 
			{
				draw(e, lastClick == MouseEvent.RIGHT_MOUSE_DOWN?false:true);
			}
		}
		
		/**
		 * Executed when spa
		 */
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode==Keyboard.SPACE) 
			{
				pause = pause?false:true;
				if(!pause) 
				{
					reDraw(null);
				}
			}
		}
		
		/**
		 * Executed wneh click or right click is pressed and generate o destroy cells
		 */
		private function onClick(e:MouseEvent):void 
		{
			draw(e, e.type == MouseEvent.RIGHT_CLICK?false:true);
		}
		
		private function draw(e:MouseEvent,isClick:Boolean):void 
		{
			curI = e.localY / cellH;
			curJ = e.localX / cellW;
			Cells[curI][curJ] = _Cells[curI][curJ] = isClick?true:false;
			graphics.beginFill(isClick?0xeeffee:0x332222);
			graphics.drawRect(curJ * cellW, curI * cellH, cellW, cellH);
			graphics.endFill();
		}
		
		/**
		 * Redraw all cells on the screen, this is done by calculating all neighboring cells and applying the life or death conditions
		 */
		private function reDraw(e:TimerEvent):void 
		{
			graphics.clear();
			graphics.lineStyle(1, 0x333333);
			copy(false);
			for (var i:int = 0; i < hCells; i++) 
			{
				for (var j:int = 0; j < vCells; j++) 
				{					
					nCells = 0 +
					(Cells[mod(i + 1, hCells)][mod(j - 1, vCells)]?1:0) +
					(Cells[mod(i + 1, hCells)][mod(j    , vCells)]?1:0) +
					(Cells[mod(i + 1, hCells)][mod(j + 1, vCells)]?1:0) +
					(Cells[mod(i    , hCells)][mod(j - 1, vCells)]?1:0) +
					(Cells[mod(i    , hCells)][mod(j + 1, vCells)]?1:0) +
					(Cells[mod(i - 1, hCells)][mod(j - 1, vCells)]?1:0) +
					(Cells[mod(i - 1, hCells)][mod(j    , vCells)]?1:0) +
					(Cells[mod(i - 1, hCells)][mod(j + 1, vCells)]?1:0);
					
					if (!Cells[i][j] && nCells == 3)
					{
						_Cells[i][j] = true;
					}
					else if(Cells[i][j]&&(nCells<2||nCells>3)) 
					{
						_Cells[i][j] = false;
					}
					
					graphics.beginFill(Cells[i][j]?0xffffff:0x222222);
					graphics.drawRect(j * cellW, i * cellH, cellW, cellH);
					graphics.endFill();
				}
			}
			copy(true);
			if (!pause) 
			{
				reset.start();
			}
		}
		/**
		 * Copies the values from the state vector to the backup one and vice versa
		 */
		private function copy(revert:Boolean):void 
		{
			for (var i:int = 0; i < hCells; i++) 
			{
				for (var j:int = 0; j < vCells; j++)
				{
					if (revert) 
					{
						Cells[i][j] = _Cells[i][j];
					}
					else 
					{
						_Cells[i][j] = Cells[i][j];
					}
				}
			}
		}
		
		/**
		 * Initialize the status and backup vectors, draw the first screen, and start the timer
		 */
		private function initCells():void 
		{
			cellW = sizeW / vCells;
			cellH = sizeH / hCells;
			Cells = new Vector.<Vector.<Boolean>>(hCells, true);
			_Cells = new Vector.<Vector.<Boolean>>(hCells, true);
			for(var i:int=0;i<hCells;i++) 
			{
				Cells[i] = new Vector.<Boolean>(vCells, true);
				_Cells[i] = new Vector.<Boolean>(vCells, true);
				for (var j:int = 0; j < vCells; j++) 
				{
					Cells[i][j] = false;
				}
			}
			
			graphics.lineStyle(1, 0x333333);
			for (var k:int = 0; k < hCells; k++) 
			{
				for (var l:int = 0; l < vCells; l++) 
				{
					graphics.beginFill(0x222222);
					graphics.drawRect(l * cellW, k * cellH, cellW, cellH);
					graphics.endFill();
				}
			}
			reset.start();
		}
		/**
		 * This function does the same job as the modulo operator, except that the actionscript modulo operator is poorly implemented because it does not distinguish between positive and negative to generate the result value.
		 * That is why this function if the two numbers passed are positive it will use the common and current module of actionsript, but if the first one is negative then what it will do is subtract the module between the first and the second from the second parameter.
		 */
		private function mod(num1:Number,num2:Number):int
		{
			if (num1 >= 0) 
			{
				return num1 % num2;
			}
			else 
			{
				return num2 + (num1 % num2);
			}
			return 0;
		}
	}
}