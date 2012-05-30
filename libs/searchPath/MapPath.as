package searchPath
{
	import flash.utils.*;
		public class MapPath 
		{
			//开放列表
			private var openlist:Array=[null]
				
			//开放列表长度---------------优化点,效果较明显--------------------
			private var openLen:int=1
			
			//关闭列表
			private var closelist:Array = []
			
			//起始点
			private var initPoint:MapPoint
			
			//结束点
			private var endPoint:MapPoint
			
			//结束点是否为障碍
			private var endPointisBlock:Boolean=false
			
			//当前操作的节点--------------优化点，效果一般--------------------
			private var currentP:MapPoint

			//地图包含行列号的二维数组
			private var data:Array = []
			
			//地图行数
			private var rows:int=0
			
			//地图列数
			private var cols:int=0
			
			//记录终点行列号--------------优化点,效果一般--------------------
			private var dx:int=0
			private var dy:int=0
			
			//超时处理
			private var timer:int=0
				
			//方向
			private var rotate:int

            //二维数组方式记录寻路点以便查找
            private var rememberPoints:Array=[]
			/**
			 * 寻路 
			 * @param data 地图数据[[0,1,0],[0,1,0]]
			 * @param cols 地图列
			 * @param rows 地图行
			 * @param rotate 4方向还是8方向寻路，默认为8方向寻路
			 * 
			 */
			public function MapPath(data:Array,cols:int,rows:int,rotate:int=8) 
			{
				this.data = data
				
				this.cols=cols
					
				this.rows=rows
					
				this.rotate=rotate


						
			}
			
			//起始行列号，终点行列号
			public function search(stx:int, sty:int, edx:int, edy:int):Array
			{
                rememberPoints=[]
                
				var initArr:Array=data[stx][sty].split(",")
				var endArr:Array=data[edx][edy].split(",")
				
				initPoint = new MapPoint(initArr[0],initArr[1],initArr[2]) 
				endPoint  = new MapPoint(endArr[0],endArr[1],endArr[2]) 
					
				dx=edx
				dy=edy
					
				//如果终点为障碍，则临时改变属性为可通行，完成寻径后删除终点
				if(endPoint.k==1){
					endPointisBlock=true
					endPoint.k=0	
				}
				
				//设置起点的root属性指向
				initPoint.root = initPoint
				
				//记时器
				timer=getTimer()
					
				var roads:*=initPoint
					
				count=0
				
				while(roads is MapPoint){
					
					roads=polling(roads)
					
				}
					
				reset()
					
				return roads
				
			}
			
			//递归进行路径搜索
			private var count:int=0
			private function polling(point:MapPoint):*
			{
               //加入关闭列表
				closelist.push(point)
				point.isCloseList=true
				
				//处理当前节点周围八个节点
				currentP=point
				
				findEightPoints()

				//有路径
				if (point.x == dx&&point.y==dy){ 
					
					return gobackPath();
					
				}
				
				//无路径
				if(openLen==1){

					return null
				
				}
				
				//超时处理
				if(getTimer()-timer>50){

				   //return null
				
				}
				
				//如果没有找到终点，就从二叉堆数组中提出F值最小的点继续递归
				
				var mp:MapPoint=shift()
					
				count++
					
				if(count>1000){
					
					count=0
					
					return mp
					
				}

				return polling(mp)
				
			}	
			
			//找出相邻8个顶点(带条件)
			private function findEightPoints():void
			{
				
				//----------------------优化点,效果一般--------------------------
				var cx:int=currentP.x
				var cy:int=currentP.y
					
				var isup:Boolean=false;
				var isdown:Boolean=false;
				var isleft:Boolean=false;
				var isright:Boolean=false
				
				var up:int=cy-1
				var down:int=cy+1
				var left:int=cx-1
				var right:int=cx+1		
				//---------------------------------------------------------------
					
				
				//左
				if(left>=0){
					
					isleft=setItem(left, cy,10)
					
				}
				
				//右
				if(right<cols){
					
					isright=setItem(right,cy,10)
					
				}
				
				//上
				if(up>=0){
					
					isup=setItem(cx, up,10)
				}
				
				//下
				
				if(down<rows){
					
					isdown=setItem(cx, down,10)
					
				}
				
				if(rotate!=8){return;}
				
				
				//左上
				if(isleft&&isup){
					
					setItem(left, up,14)
				}
				
				//右上
				if(isup&&isright){
					setItem(right, up,14)
				}
				
				
				//右下
				if(isright&&isdown){
					
					setItem(right, down,14)
				}
				
				//左下
				if(isleft&&isdown){
					setItem(left, down,14)
				}
				
				
			}
			
			//处理每个节点----------------------------优化点，大循环中函数参数个数越少越好-----------------------------------------
			private function setItem(col:int,rows:int, num:int):Boolean {
				
				if(data[col]==null||data[col][rows]==null){return false}
                
                //2011-9-29优化，储存寻路数据从mapPoint修改成字符串形式,在实际寻路中动态转换成MapPoint
                var item:MapPoint

                if( rememberPoints[col]&&rememberPoints[col][rows] ){

                   item =  rememberPoints[col][rows]

                 }else{
				
				   var itemArr:Array=data[col][rows].split(",")
				   item = new MapPoint(itemArr[0],itemArr[1],itemArr[2]) 

                   rememberPoints[col]=rememberPoints[col]||[]
                   rememberPoints[col][rows]=item

                 }
					
				//障碍
				if(item.k==1){return false;}
				
				//已加入关闭列表
				if(item.isCloseList){return true;}
				
				//如果没有父节点则添加，有则比较G值
				if(item.root==null){
					
					item.G = currentP.G + num
					
					//-------------------------------重要优化点，可提高n倍的寻路速度---------------------------------------------
					var cx:int=dx - item.x
					var cy:int=dy - item.y
					
					cx < 0 && (cx = -cx);
					cy < 0 && (cy = -cy);
					
					item.H =(cx+cy)*10
					
					//item.H =( Math.abs(dy - item.x) + Math.abs(dx - item.y))*10
					
					item.F = item.G + item.H
					item.root=currentP

					push(item)

				}else{
				
					//如果有更好的路径
					var pG:int=currentP.G+num
					
					if(pG<item.G){
						
						item.G = pG
						item.F = pG + item.H
						item.root=currentP
						
						modify(item)
						
					}
					
				}

				return true;
				
			}

			//回溯路径
			private function gobackPath():Array
			{
				var path:Array =[closelist[closelist.length-1]]

				while(path[path.length-1].root!==initPoint){
					
					path.push(path[path.length-1].root)
						
				}
				
				//path.push(initPoint)
				
				path.reverse()
					
				//处理障碍
				if(endPointisBlock){endPointisBlock=false;endPoint.k=1;path.pop()}
				
				return path
				
			}

			//复原被改变节点的状态
			private function reset():void{
				
				/*for(var i:int=0;i<cols;i++){
					
					for(var j:int=0;j<rows;j++){
				
					    data[i][j].reset()
						
					}
				
				}*/
				
				openlist = [null];
				closelist=[]
				
				openLen=1

			}
			
//====================================================二叉堆优化======================================================================
			/**
			 * 新增节点 
			 * @param o
			 * 
			 */			
			public function push(o:MapPoint):void
			{
				openlist.push(o)
				openLen++
				var s:int =openLen-1//s 当前节点

				var t:MapPoint
				var p:int

				while (s > 1)
				{
					p = int(s/2);//p 父节点
					if (openlist[s].F < openlist[p].F)
					{
						t = openlist[s];
						openlist[s] = openlist[p];
						openlist[p] = t;
					}
					else
						break;
					
					s = p;
				} 
			}
			
			/**
			 * 修改节点后重排顺序 
			 * @param o
			 * 
			 */
			public function modify(o:MapPoint):void
			{
				
				var s:int=openlist.indexOf(o)

				var t:MapPoint
				var p:int
				while (s > 1)
					{
						p = int(s/2);//p 父节点
						if (openlist[s].F < openlist[p].F)
						{
							t = openlist[s];
							openlist[s] = openlist[p];
							openlist[p] = t;
						}
						else
							break;
						
						s = p;
					} 
				
			}
			
			/**
			 * 从数组中取出首节点（最小值）
			 * @param index
			 * 
			 */		
			public function shift():MapPoint
			{
				var v:MapPoint = openlist[1];
				var s:int = 1;//s 当前节点
				
				openLen<=2?openlist.pop():openlist[1] = openlist.pop();//将末节点移动到队首
				openLen--
				
				var os:int = 0;//os s的旧值
				var p:int = 0;//p 子节点
				var pp:int=0
				var t:MapPoint
				
				while (true)
				{
					os = s;//os s的旧值
					p = s * 2;//p 子节点
					pp=p+1

					//如果另一个子节点更小
						
					if (p < openLen){
						
						if(openlist[p].F<openlist[s].F){s = p};
						
						if (pp < openLen&&openlist[pp].F<openlist[s].F){
							
							s = pp;
							
						}
						
				    }
					
					
					if (s != os)
					{
						t = openlist[s];
						openlist[s] = openlist[os];
						openlist[os] = t;
					}	
					else
						break;
			    }
				 
				return v;
				
			}
         
			
			
		}
		
}