package com.kaixin.utils
{
	import com.kaixin.base.ICloneAbleObject;
	import com.kaixin.base.ILooperObject;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import tween.TweenLite;

	/** WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-6-24 ????01:50:42
	*/
	
	public class KLooper extends EventDispatcher
	{
		public static var FROM_LEFT_TO_RIGHT:uint=1;
		public static var FROM_RIGHT_TO_LEFT:uint=2;
		public static var FROM_TOP_TO_BOTTOM:uint=4;
		public static var FROM_BOTTOM_TO_TOP:uint=8;
		
		
		/** the loop area*/
		private var orginArea:Rectangle
		private var area:Rectangle
		public function set Area(a:Rectangle):void
		{
			this.area=a;
			this.orginArea=this.Area.clone();
			fullArea=this.Area.clone();
			fullArea.x-=this.preCheckLength;
			fullArea.y-=this.preCheckLength;
			fullArea.width+=this.preCheckLength;
			fullArea.height+=this.preCheckLength;
			//this.StartPosition=new Point(a.x,a.y);
		}
		public function get Area():Rectangle
		{
			return this.area;
		}
		private var fixedArea:Rectangle

		public function get FixedArea():Rectangle
		{
			return fixedArea;
		}

		public function set FixedArea(v:Rectangle):void
		{
			fixedArea = v;
		}
		private var fixStartPosH:Boolean=false

		public function get FixStartPosH():Boolean
		{
			return fixStartPosH;
		}

		public function set FixStartPosH(v:Boolean):void
		{
			fixStartPosH = v;
		}
		
		private var fixStartPosV:Boolean=false

		public function get FixStartPosV():Boolean
		{
			return fixStartPosV;
		}

		public function set FixStartPosV(v:Boolean):void
		{
			fixStartPosV = v;
		}
		
		private var fixPos:Point;
		
		
		private var fullArea:Rectangle
		
		/** the loop direction*/
		private var direction:uint=FROM_LEFT_TO_RIGHT;
		public function set Direction(d:uint):void
		{
			this.direction=d;
			
			//if(d==FROM_LEFT_TO_RIGHT || d==FROM_RIGHT_TO_LFFT){d=d|FROM_TOP_TO_BOTTOM}
			//if(d==FROM_TOP_TO_BOTTOM || d==FROM_BOTTOM_TO_TOP){d=d|FROM_LEFT_TO_RIGHT}
			
			
			if((d|FROM_LEFT_TO_RIGHT)==d || (d|FROM_RIGHT_TO_LEFT)==d)this.loopAbleH=true;else this.loopAbleH=false;
			if((d|FROM_TOP_TO_BOTTOM)==d || (d|FROM_BOTTOM_TO_TOP)==d)this.loopAbleV=true;else this.loopAbleV=false;					
		}
		public function get Direction():uint
		{
			return this.direction;
		}		
		private var loopList:Array
		public function set LoopList(ll:Array):void
		{					
			this.loopList=ll;
		}
		public function get LoopList():Array
		{
			return this.loopList;
		}		
		private var orgStartPosition:Point=new Point;
		private var startPosition:Point;
		public function set StartPosition(sp:Point):void
		{
			this.startPosition=sp;
			this.orgStartPosition=sp.clone();
		}
		public function get StartPosition():Point
		{
			if(startPosition==null){
				StartPosition=new Point(this.area.x,this.area.y)
			}
			return this.startPosition;
		}
		private var startIndex:uint		
		public function get StartIndex():uint
		{
			return this.startIndex;
		}
		public function set StartIndex(v:uint):void
		{
			this.startIndex = v;
		}
		private var position:Point;
		public function set Position(p:Point):void
		{
			this.position=p;
		}
		public function get Position():Point
		{
			return this.position;
		}
		private var gapH:Number=0
		public function set GapH(hg:Number):void
		{
			this.gapH=hg;
		}
		public function get GapH():Number
		{
			return this.gapH
		}
		private var gapV:Number=0
		public function set GapV(vg:Number):void
		{
			this.gapV=vg;
		}
		public function get GapV():Number
		{
			return this.gapV
		}
		private var loop:Boolean=true				
		public function get Loop():Boolean
		{
			return loop;
		}
		public function set Loop(v:Boolean):void
		{
			loop = v;
		}

		private var loopAbleH:Boolean=true;
		public function set LoopAbleH(hl:Boolean):void
		{
			this.loopAbleH=hl;
		}
		public function get LoopAbleH():Boolean
		{
			return this.loopAbleH;
		}
		private var loopAbleV:Boolean=false;
		public function set LoopAbleV(vl:Boolean):void
		{
			this.loopAbleV=vl;
		}
		public function get LoopAbleV():Boolean
		{
			return this.loopAbleV;
		}
		
		private var maxscrollH:Number=0
		public function get MaxScrollH():Number
		{
			return this.maxscrollH
		}
		private var maxscrollV:Number=0
		public function get MaxScrollV():Number
		{
			return this.maxscrollV
		}
		/**serarchFunction is a function used to search the objects in the logic the function defined
		 * */ 
		private var searchFunction:Function
		public function get SearchFunction():Function
		{
			return searchFunction;
		}	
		public function set SearchFunction(f:Function):void
		{
			this.searchFunction=f;
		}
		/** scrollrect is used to defined the scrollrect of the display holder
		 */ 
		private var scrollRect:Rectangle
		public function get ScrollRect():Rectangle
		{
			return scrollRect;
		}
		public function set ScrollRect(v:Rectangle):void
		{
			scrollRect = v;
			this.holder.scrollRect=scrollRect
		}
		
		/*
		 *unitMove is used to defined as if the move action is a unitmove
		 * if this value is true,it means the min-distance of each move step is the base on the displayobject's size
		 * if the value is false,it means move unit is free  
		 */		
		/*private var unitMove:Boolean
		public function get UnitMove():Boolean
		{
			return unitMove;
		}
		public function set UnitMove(v:Boolean):void
		{
			unitMove = v;
		}*/
		/**
		 *speed is used to defined the move speed 
		 */		
		private var speed:Number=100;
		public function get Speed():Number
		{
			return speed;
		}
		public function set Speed(v:Number):void
		{
			if(v==0){
				v=1;
			}
			speed = v;
		}
		 
		
		
		
		private var totalWidth:Number=0
		private var totalHeight:Number=0
		
		private var columns:Array;
		public function get Columns():Array
		{
			return this.columns;
		}
		private var rows:Array;
		public function get Rows():Array
		{
			return this.rows;
		}
		private var preCheckLength:Number=10;
		
		private var reachedLeft:Boolean=false;
		public function get ReachedLeft():Boolean
		{
			return this.reachedLeft;
		}
		private var reachedRight:Boolean=false;
		public function get ReachedRight():Boolean
		{
			return this.reachedRight;
		}
		private var reachedTop:Boolean=false;
		public function get ReachedTop():Boolean
		{
			return this.reachedTop;
		}
		private var reachedBottom:Boolean=false;
		public function get ReachedBottom():Boolean
		{
			return this.reachedBottom;
		}
		
		private var isEmpty:Boolean=true;
		
		private var Vstart:*
		private var Vend:*
		private var Vinc:*
		private var Hstart:*
		private var Hend:*
		private var Hinc:*
		
		private var holder:Sprite;
		public function KLooper(holder:Sprite,loopList:Array=null,area:Rectangle=null)
		{
			this.holder=holder;
			if(loopList!=null)this.LoopList=loopList;
			if(area!=null)this.Area=area;
			this.Direction=this.direction;
		}
		private function initLooper():void
		{
			var spH:Number=this.area.x;
			var spV:Number=this.area.y;
			
			if(this.loopList.length==0){
				this.isEmpty=true;
				return;			
			}	
			this.isEmpty=false;
			
			////trace(this.area,"111222")
			for (var i:int=0;i<this.loopList.length;i++)
			{
				
				var t:*=this.loopList[i]
				if(t is DisplayObject)
				{
					if(this.LoopAbleH){
						if(this.fixedArea!=null){
							totalWidth+=this.fixedArea.width;
						}else{
							totalWidth+=t.width+this.gapH;}
					}else{totalWidth=this.fixedArea!=null?this.fixedArea.width:Math.max(totalWidth,t.width+this.gapH);}
					if(this.LoopAbleV){
						if(this.fixedArea!=null){
							totalHeight+=this.fixedArea.height
						}else{
							totalHeight+=t.height+this.gapV;			
						}				
					}else{totalHeight=this.fixedArea!=null?this.fixedArea.height:Math.max(totalHeight,t.height+this.gapV);}
					if(i<this.startIndex)
					{
						if(this.LoopAbleH)spH+=this.fixedArea!=null?this.fixedArea.width:(t.width+this.gapH);
						if(this.LoopAbleV)spV+=this.fixedArea!=null?this.fixedArea.height:(t.height+this.gapV);	
					}
				}
			}
			if(totalWidth>this.area.width){this.maxscrollH=totalWidth-this.area.width}
			if(totalHeight>this.area.height){this.maxscrollV=totalHeight-this.area.height}
			if(this.startPosition==null){
				
				/*spV=(spV+this.area.y)%this.totalHeight-this.area.y
				if(spV<this.area.y)spV+=this.totalHeight
				
				spH=(spH+this.area.x)%this.totalWidth-this.area.x
				if(spH<this.area.x)spH+=this.totalWidth
				*/
				
				this.startPosition=new Point(spH,spV);
			}
			this.startPosition.x-=Math.floor((this.startPosition.x-this.area.x)/totalWidth)*totalWidth;
			this.startPosition.y-=Math.floor((this.startPosition.y-this.area.y)/totalHeight)*totalHeight;
			
			
			////trace(this.startPosition,"222")
			
			var cNum:Number=Math.ceil((this.area.width+2*this.preCheckLength)/this.totalWidth);
			var rNum:Number=Math.ceil((this.area.height+2*this.preCheckLength)/this.totalHeight);
			if(!this.LoopAbleV){rNum=1;}else{if(!Loop){rNum=1;}else if(rNum<3){rNum=3};rNum=rNum*this.loopList.length;}
			if(!this.LoopAbleH){cNum=1;}else{if(!Loop){cNum=1;}else if(cNum<3){cNum=3};cNum=cNum*this.loopList.length;}
			
			this.columns=new Array(cNum);
			this.rows=new Array(rNum);
			for(var c:int=0;c<this.columns.length;c++)
			{
				this.columns[c]=new Array(this.rows.length+1)
			}
			for(var r:int=0;r<this.rows.length;r++)
			{
				this.rows[r]=new Array(this.columns.length+1)
			}
		}
		
		public function resetAll():void
		{
			while(this.holder.numChildren!=0){
				var target:*=	this.holder.removeChildAt(0)
				if(target is ILooperObject){
					ILooperObject(target).loopOut()
				}
			}
			totalWidth=0;
			totalHeight=0;
			this.position=new Point;
			this.StartPosition=this.orgStartPosition;
			this.Area=this.orginArea;
			
		}
		public function createLooper():void
		{
			
			initLooper();
			if(isEmpty)return;
			if(this.position==null)this.position=this.startPosition;
			////trace(this.position,"3333")			
			this.totalWidth*=Math.ceil(this.columns.length/this.LoopList.length);
			this.totalHeight*=Math.ceil(this.rows.length/this.LoopList.length);							
			Hstart=0;Hend=this.columns.length;Hinc=1;
			Vstart=0;Vend=this.rows.length;Vinc=1;
			//if((this.direction|KLooper.FROM_LEFT_TO_RIGHT)==this.direction){}
			if((this.direction|KLooper.FROM_RIGHT_TO_LEFT)==this.direction){Hstart=this.columns.length-1;Hend=-1;Hinc=-1;this.position.offset(this.area.width-this.loopList[0].width-this.gapH,0)}
			//if((this.direction|KLooper.FROM_TOP_TO_BOTTOM)==this.direction){}
			if((this.direction|KLooper.FROM_BOTTOM_TO_TOP)==this.direction){Vstart=this.rows.length-1;Vend=-1;Vinc=-1;this.position.offset(0,this.area.height-this.loopList[0].height-this.gapV)}
						
			fixPos=new Point();
			
			var rect:Rectangle=this.loopList[0].getRect(this.loopList[0]);
			if(FixStartPosH){if(Hinc==1){fixPos.x=-rect.x}else{fixPos.x=-(rect.width+rect.x)}}
			if(FixStartPosV){if(Vinc==1){fixPos.y=-rect.y}else{fixPos.y=-(rect.height+rect.y)}}
			this.position.offset(fixPos.x,fixPos.y);
			this.area.offset(fixPos.x,fixPos.y);//区域整体偏移			
			////trace(this.position,"1111")
			var r:int
			var c:int
			var sx:Number=	this.position.x
			var sy:Number=	this.position.y
			/*if(this.fixedArea!=null){
			
				for(r=Vstart;r!=Vend;r+=Vinc)
				{					
					this.rows[r][0]=[sy,this.fixedArea.height];
					sy+=this.fixedArea.height;
				}
				for(c=Hstart;c!=Hend;c+=Hinc)
				{
					this.columns[c][0]=[sx,this.fixedArea.width];
					sx+=this.fixedArea.width;
				}
			}*/
			
			
			
			for(r=Vstart;r!=Vend;r+=Vinc)
			{		
				sx=	this.position.x
				for(c=Hstart;c!=Hend;c+=Hinc)
				{				
					var index:*=(r-Vstart)*Vinc*this.columns.length+(c-Hstart)*Hinc;
					var nObj:*
					var obj:*=this.loopList[index%this.loopList.length]
					if(this.Loop){
						if(obj is ICloneAbleObject){
							nObj=obj.clone();
						}else{
							nObj=KCloner.DOclone(obj);
						}
					}else{
						if(index>=this.loopList.length)break;
						nObj=obj;
					}
					this.holder.addChild(nObj);					
					
					var sw:Number=this.fixedArea!=null?this.fixedArea.width:(nObj.width+this.gapH);
					var sh:Number=this.fixedArea!=null?this.fixedArea.height:(nObj.height+this.gapV);
					
					
					this.columns[c][0]=[int(sx),int(sw)];
					this.rows[r][0]=[int(sy),int(sh)];
					this.columns[c][r+1]=[nObj,0]; 
					this.rows[r][c+1]=[nObj,0];
					sx+=sw
				}
				sy+=sh
			}
			move(new Point(1,1));					
		}
		
		public function finedPositionBySearchFunction(...args):Point
		{
			/*var out:*=this.searchFunction.apply(null,args);
			if(out is DisplayObject){
				return findPosition(out)
			}else if(out is Number){
				return findPositionByIndex(out)
			}
			return null*/
			
			for (var i:int=0;i<this.loopList.length;i++)
			{
				var item:*=this.loopList[i];
				var pars:Array=[item]
				pars=pars.concat(args)
				if(this.searchFunction.apply(null,pars))
				{
					return findPositionByIndex(i);
				}
			}
			return null;
			
		}
		
		public function findPositionByIndex(index:int):Point
		{
			var ph:Number=this.position.x
			var pv:Number=this.position.y
			if(this.LoopAbleH)
			{
				for(var c:int=0;c<index;c++)
				{
					ph+=this.columns[c][0][1]*Hinc;
				}
			}
			if(this.LoopAbleV)
			{
				for(var r:int=0;r<index;r++)
				{
					pv+=this.rows[r][0][1]*Vinc;
				}
			}
			return new Point(ph,pv);
			
		}		
		public function findPosition(obj:DisplayObject):Point
		{
			for (var i:int=0;i<this.loopList.length;i++)
			{
				var item:*=this.loopList[i];
				if(item == obj)
				{
					return findPositionByIndex(i);
				}
			}
			return null;
		}
		
		
		
		public function directMoveTo(newPos:Point=null):void
		{
			var nowPos:Point=this.position.clone();
			var movePos:Point=nowPos.subtract(newPos);
			move(movePos)
		}
		
		
		private var prevMovePos:Point
		private var currrentMovePos:Point
		
		public function moveTo(newPos:Point=null):void
		{
			var distance:Number=Point.distance(newPos,this.position)
			var time:Number=distance/speed;
			prevMovePos=this.position.clone();
			currrentMovePos=this.position.clone();
			TweenLite.to(currrentMovePos,time,{x:newPos.x,y:newPos.y,onUpdate:moving})
		}
		public function unitMove(newUnitPos:Point=null):void
		{
			var ux:int=int(newUnitPos.x)
			var uy:int=int(newUnitPos.y)	
			
			var dx:Number=this.position.x
			var dy:Number=this.position.y
			
			var xx:int
			var yy:int
			
			if(ux>0){				
				for(xx=0;xx<ux;xx++){
					dx+=this.columns[xx][0][1]
				}			
			}else if(ux<0)
			{
				for(xx=-1;xx>=ux;xx--){
					dx-=this.columns[this.columns.length+xx][0][1]
				}	
			}
			
			if(uy>0){				
				for(yy=0;yy<uy;yy++){
					dy+=this.rows[yy][0][1]
				}			
			}else if(ux<0)
			{
				for(yy=-1;yy>=uy;yy--){
					dy-=this.rows[this.rows.length+yy][0][1]
				}	
			}
			
			moveTo(new Point(dx,dy))
			
		}
		
		private function moving():void
		{
			var movePos:Point=currrentMovePos.subtract(prevMovePos)
			move(movePos);
			prevMovePos=currrentMovePos.clone()			
		}
		
		
		public function move(movePos:Point=null):void
		{
			////trace("moving")
			if(isEmpty)return;
			if(movePos==null){movePos=new Point();}else if(movePos.x==0 && movePos.y==0)return;
		
			var orgPoint:Point=this.position.clone();
			this.position.offset(movePos.x,movePos.y);
			
			this.position.x=this.position.x%this.totalWidth
			this.position.y=this.position.y%this.totalHeight
						
			////trace(this.position)
			if(Hinc==-1){
				if(!this.loop){
					if((this.position.x-this.totalWidth+this.columns[0][0][1])>=this.area.x){
						this.dispatchEvent(new Event("reachRight"));this.reachedRight=true;						
					}else if(this.reachedRight){this.dispatchEvent(new Event("unreachRight"));this.reachedRight=false;}
					if((this.position.x+this.columns[0][0][1])<=(this.area.x+this.area.width)){
						this.dispatchEvent(new Event("reachLeft"));this.reachedLeft=true;
					}else if(this.reachedLeft){this.dispatchEvent(new Event("unreachLeft"));this.reachedLeft=false;}
				}else{ 
					if((this.position.x+this.columns[0][0][1]+this.preCheckLength)<=(this.area.x)){this.position.x+=this.totalWidth;}
					else if((this.position.x+this.preCheckLength)>=(this.area.width+this.area.x)){this.position.x-=this.totalWidth;}
				}
			}else if(Hinc==1){
				if(!this.loop){
					if((this.position.x+this.totalWidth)<=(this.area.width+this.area.x)){
						//433 433 (x=73, y=200) 360 (x=33, y=0) (x=233, y=200, w=200, h=200)
						////trace((this.position.x+this.totalWidth),(this.area.width+this.area.x),position,totalWidth,fixPos,this.area)
						this.dispatchEvent(new Event("reachLeft"));this.reachedLeft=true;
					}else if(this.reachedLeft){this.dispatchEvent(new Event("unreachLeft"));this.reachedLeft=false;}
					if(this.position.x>=this.area.x){
						this.dispatchEvent(new Event("reachRight"));this.reachedRight=true;
					}else if(this.reachedRight){this.dispatchEvent(new Event("unreachRight"));this.reachedRight=false;}
				}else{ 
					if((this.position.x+this.columns[0][0][1]+this.preCheckLength)<=this.area.x){this.position.x+=this.totalWidth;}
					else if((this.position.x+this.preCheckLength)>=this.area.width+this.area.x){this.position.x-=this.totalWidth;}
				}
			} 			
			if(Vinc==-1){
				if(!this.loop){
					if((this.position.y-this.totalHeight+this.rows[0][0][1])>=this.area.y){
						this.dispatchEvent(new Event("reachBottom"));this.reachedBottom=true;
					}else if(this.reachedBottom){this.dispatchEvent(new Event("unreachBottom"));this.reachedBottom=false;}
					if((this.position.y+this.rows[0][0][1])<=(this.area.y+this.area.height)){
						this.dispatchEvent(new Event("reachTop"));this.reachedTop=true;
					}else if(this.reachedTop){this.dispatchEvent(new Event("unreachTop"));this.reachedTop=false;}
				}else{
					if((this.position.y+this.rows[0][0][1]+this.preCheckLength)<=this.area.x){this.position.y+=this.totalHeight;}
					else if((this.position.y+this.preCheckLength)>=(this.area.height+this.area.y)){this.position.y-=this.totalHeight;}
				}
			}else if(Vinc==1){
				if(!this.loop){
					if((this.position.y+this.totalHeight)<=(this.area.height+this.area.y)){
						this.dispatchEvent(new Event("reachTop"));this.reachedTop=true;
					}else if(this.reachedTop){this.dispatchEvent(new Event("unreachTop"));this.reachedTop=false;}
					if(this.position.y>=this.area.y){
						this.dispatchEvent(new Event("reachBottom"));this.reachedBottom=true;
					}else if(this.reachedBottom){this.dispatchEvent(new Event("unreachBottom"));this.reachedBottom=false;}
				}else{
					//////trace(this.position)
					if((this.position.y+this.rows[0][0][1]+this.preCheckLength)<=this.area.x){this.position.y+=this.totalHeight;}
					else if((this.position.y+this.preCheckLength)>=(this.area.height+this.area.y)){this.position.y-=this.totalHeight;}
					//////trace(this.position)
				}
			} 			
			
			if(this.reachedLeft && movePos.x<0)
			{
				if(MaxScrollH<=0)
				{
					//如果不能横向移动的话...啥也别做
				}else if(Hinc==1){this.position=new Point(this.area.x+this.area.width-this.totalWidth,this.area.y)}
				else if(Hinc==-1){this.position=new Point(this.area.x+this.area.width-this.columns[0][0][1],this.area.y)}
			}
			if(this.reachedRight && movePos.x>0){
				if(MaxScrollH<=0)
				{
					//如果不能横向移动的话...啥也别做
				}else if(Hinc==1){this.position=new Point(this.area.x,this.area.y)}
				else if(Hinc==-1){this.position=new Point(this.area.x+this.area.width-this.columns[0][0][1],this.area.y)}
				//this.position.x=orgPoint.x;
			}
			
			if(this.reachedTop && movePos.y<0)
			{
				if(MaxScrollV<=0)
				{
					//如果不能横向移动的话...啥也别做
				}else if(Vinc==1){this.position=new Point(this.area.x,this.area.y+this.area.height-this.totalHeight)}
				else if(Vinc==-1){this.position=new Point(this.area.x,this.area.y+this.area.height-this.rows[0][0][1])}
			}
			if(this.reachedBottom && movePos.y>0){
				if(MaxScrollV<=0)
				{
					//如果不能横向移动的话...啥也别做
				}else if(Vinc==1){this.position=new Point(this.area.x,this.area.y)}
				else if(Vinc==-1){this.position=new Point(this.area.x,this.area.y+this.area.height-this.rows[0][0][1])}
				//this.position.x=orgPoint.x;
			}
			
			
			//if((this.reachedTop && movePos.y<0)||(this.reachedBottom && movePos.y>0)){this.position.y=orgPoint.y;}
					//////trace(this.position)
			
			//更新横纵集合各对象的位置信息
			var py:Number=this.position.y;		
			for(var r:int=Vstart;r!=Vend;r+=Vinc)
			{
				if(loop)
				{
					if(py>(this.fullArea.y+this.fullArea.height))py-=this.totalHeight
					if(py<(this.fullArea.y-this.rows[r][0][1]))py+=this.totalHeight
					
					//////trace(py,(this.fullArea.y+this.fullArea.height),(this.fullArea.y-this.rows[r][0][1]))
				}
				/*for(var ro:int=1;ro<this.rows[r].length;ro++)
				{
					this.rows[r][ro].y=py
				}*/
				this.rows[r][0][0]=int(py)
				if(this.Vinc==1){
					py+=this.rows[r][0][1];
				}else if(this.Vinc==-1)
				{
					if((r+Vinc)!=Vend){
						py-=this.rows[r+Vinc][0][1];
					}
				}	
			}
			var px:Number=this.position.x;
			for(var c:int=Hstart;c!=Hend;c+=Hinc)
			{
				if(loop)
				{
					if(px>(this.fullArea.x+this.fullArea.width))px-=this.totalWidth
					if(px<(this.fullArea.x-this.columns[c][0][1]))px+=this.totalWidth
				}
				/*for(var co:int=1;co<this.columns[c].length;co++)
				{
					this.columns[c][co].x=px;
					
					/*var coo:*=this.columns[c][co]
					coo.x=px
					if(coo is ILooperObject){
						
						if()
						
						
					}
					coo.visible=this.fullArea.intersects(coo.getRect(this.holder))
<<<<<<< .mine
					*/
					////////trace(coo.getRect(this.holder))
					/*if(!this.fullArea.intersects(coo.getRect(this.holder))){
						if(coo.parent==this.holder){
							this.holder.removeChild(coo)
						}
					
					}else{
						if(coo.parent==null){
							this.holder.addChild(coo)
						}
					}//									
				}*/
				
				this.columns[c][0][0]=int(px);
				
				if(this.Hinc==1){
					px+=this.columns[c][0][1];
				}else if(this.Hinc==-1)
				{
					if((c+Hinc)!=Hend){
						px-=this.columns[c+Hinc][0][1];
					}
				}
			}
			
			//判断超出范围并进行处理
			for(r=Vstart;r!=Vend;r+=Vinc)
			{
				for(c=Hstart;c!=Hend;c+=Hinc)
				{
					var x:Number=this.columns[c][0][0];
					var y:Number=this.rows[r][0][0];
					var width:Number=this.columns[c][0][1];
					var height:Number=this.rows[r][0][1];
					
					var target:*=this.columns[c][r+1][0]					
					
					var targetRect:Rectangle=new Rectangle(x,y,width,height)
					var isLoopOut:Boolean=!this.fullArea.intersects(targetRect)
					//if(!isLoopOut){
						target.x=x
						target.y=y
					//}
					////trace(c,r,x,y)
					if(target is ILooperObject)
					{
						if(isLoopOut && ILooperObject(target).isLoopIned){ILooperObject(target).loopOut()}
						else if(!isLoopOut && ILooperObject(target).isLoopOuted){ILooperObject(target).loopIn()}
					}else{					
						//target.visible=!isLoopOut
					}				
				}
			}
			
					
		}
	}
}