package searchPath
{
	import flash.display.Sprite;
	
	public class MapTile extends Sprite
	{
		//行列
		public var row:int=0
		public var column:int=0
		public function MapTile(p_color : uint = 0xCCCCCC, p_w : int = 10, p_h : int = 10)
		{
			redraw(p_color, p_w , p_h)
		}
		
		public function redraw(p_color : uint = 0xCCCCCC, p_w : int = 10, p_h : int = 10):void{
		
			with (this.graphics)
			{
				lineStyle(1, 0x666666);
				beginFill(p_color);
				//drawRect(0, 0, p_w, p_h);
				
				moveTo(-p_w/2,0)
				lineTo(0,-p_h/2)
				lineTo(p_w/2,0)
				lineTo(0,p_h/2)
				lineTo(-p_w/2,0)
				
				endFill();
			}
		
		}
		
		
	}
}