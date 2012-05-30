package org.superkaka.kakalib.optimization
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.superkaka.kakalib.struct.TextFiledInfo;

	public class NewTextFiled extends Sprite
	{
		private var container:Bitmap
		
		/**
		 *文本宽高 
		 */		
		public var _width:Number
		public var _height:Number
		/**
		 *单个文字的宽高尺寸
		 */		
		private var gridw:Number=18
		private var gridh:Number=17
		
		/**
		 *按一行排列的位图文本 
		 * @param str 字符串内容
		 * @param sty 文本资源类型
		 * 
		 */		
		public function NewTextFiled(str:String="",w:Number=25,h:Number=25,sty:String="Numera")
		{
			gridw=w
			gridh=h	
			
			
			_width=str.length*gridw
			_height=gridh			
				
			//画出宽width高height的位图
				
			container=creatBitmap(str,sty)					
				
			this.addChild(container)				
				
		}
		
		public function creatBitmap(str:String,sty:String):Bitmap{
			
			var bitmap:Bitmap=new Bitmap()			
			var bitmapData:BitmapData=new BitmapData(_width,_height,true,0x00000000)	
				
			var currX:Number=0
			for(var i:int=0;i<str.length;i++){
				//根据当前字符取得位图数据
				var bitData:BitmapData=TextFiledInfo.getBitDataByStr(str.slice(i,i+1),sty)
					
				var realRect:Rectangle =new Rectangle(0,0,bitData.width,bitData.height)	
				var realRect:Rectangle =new Rectangle(0,0,gridw,gridh) //bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);	
								
				bitmapData.copyPixels(bitData,realRect,new Point(currX,(gridh-bitData.height)/2))	
				currX+=bitData.width
					
			}
			
			bitmap.bitmapData=bitmapData				
			return bitmap
			
		}
		
		
		
		
		
		
		
	}
}