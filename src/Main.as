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
	import flash.events.TimerEvent;
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
		public var Cells:Vector.<Vector.<Boolean>>;
		public var _Cells:Vector.<Vector.<Boolean>>;
		
		public var vCells:uint = 80;
		public var hCells:uint = 50;
		public var cellW:Number = 0;
		public var cellH:Number = 0;
		
		public var nCells:uint = 0;
		
		public const sizeH:uint = 500;
		public const sizeW:uint = 800;
		
		public var reset:Timer = new Timer(20, 1);
		
		public function Main()
		{
			trace("Life Game by Juan Calle");
			reset.addEventListener(TimerEvent.TIMER_COMPLETE, onResetTimerComplete);
			initCells();
		}
		
		private function onResetTimerComplete(e:TimerEvent):void 
		{
			graphics.clear();
			graphics.lineStyle(1, 0xffffff);
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
			reset.start();
		}
		
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
			
			//Sample case
			Cells[10][10] = true;
			Cells[10][11] = true;
			Cells[11][11] = true;
			Cells[11][12] = true;
			Cells[12][11] = true;
			
			graphics.lineStyle(1, 0xffffff);
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