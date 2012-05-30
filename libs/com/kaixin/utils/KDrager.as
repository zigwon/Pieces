package com.kaixin.utils
{
	/** WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*Jun 16, 2009 4:01:35 PM
	*/
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class KDrager extends EventDispatcher
	{
		private var _centerDrag:Boolean=false;
		private var _dragPoint:Point;
		private var _offsetPoint:Point;
		private var _area:Rectangle;
		
		public var dropTarget:DisplayObject;
		
		public function set Area(r:Rectangle):void
		{
			this._area=r;
		}
		private var _content:DisplayObject;
		public function set Content(c:DisplayObject):void
		{
			this._content=c;
		}
		public function get Content():DisplayObject
		{
			return this._content;
		}
		public function KDrager(c:DisplayObject=null,a:Rectangle=null)
		{
			super();
			if(c!=null)this._content=c;
			if(a!=null)this._area=a;
		}
		public function startDrag(center:Boolean=false,a:Rectangle=null):void
		{
			_centerDrag=center;
			if(a!=null)this._area=a;
			if(this._content==null || this._content.parent==null)return
			if(_centerDrag){
				_dragPoint=new Point(0,0)
			}else{
				_dragPoint=new Point(this._content.mouseX,this._content.mouseY)
				}
			_dragPoint=this._content.parent.globalToLocal(this._content.localToGlobal(_dragPoint));
			_offsetPoint=new Point(this._content.x-_dragPoint.x,this._content.y-_dragPoint.y);
			//this.addEventListener(Event.ENTER_FRAME,draging);
			this._content.stage.addEventListener(MouseEvent.MOUSE_MOVE,draging);
		}
		public function stopDrag():void
		{			
			try{
				//this.removeEventListener(Event.ENTER_FRAME,draging);
			this._content.stage.removeEventListener(MouseEvent.MOUSE_MOVE,draging);
			}catch(e:Error){}
		}
		private function draging(evt:MouseEvent):void
		{
			dropTarget = evt.target as DisplayObject;
			var p:Point=new Point(this._content.parent.mouseX,this._content.parent.mouseY);
			p.offset(_offsetPoint.x,_offsetPoint.y)
			if(this._area==null){
				this._content.x=p.x;
				this._content.y=p.y;
			}else{
				if(this._area.x<=p.x && p.x<=this._area.x+this._area.width){this._content.x=p.x};
				if(this._area.y<=p.y && p.y<=this._area.y+this._area.height){this._content.y=p.y};
			}
		}
		
	}
}