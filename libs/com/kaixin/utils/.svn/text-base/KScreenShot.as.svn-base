package com.kaixin.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class KScreenShot
	{
		public function KScreenShot()
		{			
		}
		static public function capture(screen:DisplayObject,allstage:Boolean=true,rect:Rectangle=null):Bitmap
		{
			var canv:Bitmap;
			var bmp:BitmapData
			var finalbmp:BitmapData=null
			if(allstage){
				bmp=new BitmapData(screen.stage.stageWidth,screen.stage.stageHeight);
				screen=screen.stage;	
				rect=null				
				bmp.draw(screen,null,null,null,null,true);	
				finalbmp=new BitmapData(rect.width,rect.height,true,0);
				finalbmp.copyPixels(bmp,rect,new Point(0,0))
			}else if(rect!=null){
				bmp=new BitmapData(rect.width,rect.height,true,0);
				
				bmp.draw(screen,new Matrix(1,0,0,1,rect.x,rect.y),null,null,null,true);
				
				
													
			}else{
				bmp=new BitmapData(screen.width,screen.height,true,0);				
				bmp.draw(screen,null,null,null,null,true);
				
			}
			
			
			
				
			canv=new Bitmap(finalbmp!=null?finalbmp:bmp);
			canv.smoothing=true;
			return canv;
		}
		
		public static function advancedCapture(screen:DisplayObject,mt:Matrix,area:Rectangle):Bitmap
		{
			var canv:Bitmap;
			var bmp:BitmapData;
			//var finalbmp:BitmapData=null
			
			bmp=new BitmapData(area.width,area.height,true,0)
			bmp.draw(screen,mt,null,null,null,true)
			
			return new Bitmap(bmp)
			
		}
		
	}
}