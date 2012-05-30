package searchPath
{
	public class MapPoint
	{
		public var F:Number=0
		public var G:Number=0
		public var H:Number=0
		
		//1代表不可通行区块,0为可通行区块
		public var k:Number=0
		
		//是否已经在关闭列表中
		public var isCloseList:Boolean=false
			
		public var x:Number=0
		public var y:Number=0
			
		public var root:MapPoint

		
		public function MapPoint(k:int,x:int,y:int) 
		{
			this.k=k
			this.x=x
			this.y=y

		}
		//清空
		public function reset():void{
		
			F=0
			G=0
			H=0
			isCloseList=false
			root=null
		
		}
		
		public function toString():String{
		
		    return "["+k+","+x+","+y+"]"
			
		}
		
	}
	
}