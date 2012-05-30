package com.kaixin.data
{
	

	/**WWW.LUNASTUDIO.CN
	*KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-6-19 ����11:46:20
	*/
	public class KRecordSet
	{
		private var sortTableIndex:int=0;
		private var sortColumnIndex:int=0;
		/**set or get the memochache
		 */ 
		protected var _memoCache:*={}; 
		public function set MemoCache(m:*):void
		{
			this._memoCache=m;	
		}
		public function get MemoCache():*
		{
			return this._memoCache;
		}
		
		/**set or get the absolutePage of data
		 * @default 1
		 */ 
		private var _absolutePage:int=1;
		public function set AbsolutePage(p:int):void 
		{
			if(p>this.PageCount)
			{
				p=this.PageCount;					
			}
			if(p<=0)p=1;
			this._absolutePage=p;
		}
		public function get AbsolutePage():int 
		{
			return this._absolutePage;
		}
		/**get the page count of all data*/
		public function get PageCount():int 
		{
			return int(Math.ceil(this.RecordCount/this.PageSize));
		}
		
		/**get the total count of all data*/		
		public function get RecordCount():int 
		{
			return this.Data.length;
		}
		/**set or get the count of records per page*/
		private var _pageSize:int=10;
		public function set PageSize(p:int):void 
		{
			this._pageSize=p;
		}
		public function get PageSize():int 
		{
			return this._pageSize;
		}
		/**get data in the current page*/
		public function get PageRecord():Array
		{
			if(this.AbsolutePage>this.PageCount){
				this.AbsolutePage=this.PageCount;
			}
			return this.Data.slice((this.AbsolutePage-1)*this.PageSize,this.AbsolutePage*this.PageSize);
		}
		public function get BOF():Boolean
		{
			return this.AbsolutePage<=1;
		}
		public function get EOF():Boolean
		{
			return this.AbsolutePage>=this.PageCount
		}
		
		
		private var currentIndex:int=0;
		
		private var _data:Array		
		public function set Data(d:Array):void
		{
			currentIndex=0;
			for each(var item:Array in d)
			{
				var row:KRecordSetRow=new KRecordSetRow(this._headMap,[item])
				row.Index=currentIndex++
				this._data.push(row)
			}
			initMemoCache();
		}
		public function get Data():Array
		{
			return this._data;
		}
		public function set RowData(rows:Array):void
		{
			currentIndex=0;
			for each(var row:KRecordSetRow in rows)
			{
				row.Index=currentIndex++
			}
			this._data=rows;
			initMemoCache();
		}
		public function get RowData():Array
		{
			return this._data;
		}
		
		private var _headMap:KRecordSetHeaderMap;
		
		public function get HeadMap():KRecordSetHeaderMap
		{
			return _headMap;
		}

		public function set HeadMap(v:KRecordSetHeaderMap):void
		{
			_headMap = v;
		}

		private var _headers:Array

		public function get Headers():Array
		{
			return _headers;
		}

		public function set Headers(v:Array):void
		{
			_headers = v;
		}

		public function KRecordSet():void
		{
			//super(header,data);
			_data=[];
			_headers=[];
			_headMap=new KRecordSetHeaderMap();
		}
		public function addGrid(dg:KDataGrid):void
		{
			
			addHeader(dg.Header);			
			var len:int=this.Data.length;
			if(len==0){
				this.Data=dg.Data;
			}else if(len==dg.Data.length)
			{
				var newMap:*={}
			
				for each(var col:KDataGridColumn in dg.Header.Columns)
				{
					createMaps(newMap,col.name,this._headers.length-1,col.index,col.isPrimary);
				}
				
				for (var i:int=0;i<this.Data.length;i++)
				{
					var row:KRecordSetRow=this.Data[i];
					row.addRowData(newMap,dg.Data[i]);
				}
			}else {
				throw new Error("row count is not accord")
			}
		}
		
		public function addHeader(header:KDataGridHeader):void
		{		
			
			for each(var col:KDataGridColumn in header.Columns)
			{
				//addMap(col.name,this._headers.length,col.index)
				createMaps(this._headMap,col.name,this._headers.length,col.index,col.isPrimary);
			}
			this._headers.push(header);	
			
		}
		public function cloneStructure():KRecordSet
		{
			var rs:KRecordSet=new KRecordSet();
			rs.Headers=this.Headers;
			rs.HeadMap=this.HeadMap
			return rs;
		}
		private function createMaps(map:Object,name:String,tableIndex:int,columnIndex:int,isKey:Boolean=false):void
		{
			map[name]={"isKey":isKey,"tableIndex":tableIndex,"columnIndex":columnIndex};
		}
		private function addMap(name:String,tableIndex:int,columnIndex:int,isKey:Boolean=false):void
		{
			this._headMap[name]={"isKey":isKey,"tableIndex":tableIndex,"columnIndex":columnIndex};
		}
		
		
		public function initMemoCache():void
		{
			this._memoCache={};
			if(this._headers.length==0 || this._data.length==0)return;
			for(var i:int=0;i<this._data.length;i++)
			{
				for (var mapname:* in this._headMap)
				{
					
					var map:*=this._headMap[mapname]
					if(!map["isKey"])continue
					var key:*=mapname+"="+KRecordSetRow(this.Data[i]).Data[map.tableIndex][map.columnIndex];
					if(this._memoCache[key]==null){
						this._memoCache[key]=[]
					}
					this._memoCache[key].push(this.Data[i])	;
				}				
			}		
		}
		
		public function sortData(key:String,type:*="ASC"):void
		{
			/*var col:KDataGridColumn;
			if(key is String)
			{
				col=this._header.Keys[key];
				key= col==null?-1:col.index			
				if(key==-1){throw new Error("can't find the key")}				
			}else if(key>=this._header.length)
			{
					throw new Error("beyond the keys' range")
			}else{
				col=this._header.Columns[key];
			}*/
			var keymap:*;
			for (var mapname:* in this._headMap)
			{
				if(mapname==key)
				{
					keymap=this._headMap[mapname];
				}
			}
			if(keymap==null)throw new Error("can't find the key");
			
			
			
			
			
			this.sortTableIndex=keymap["tableIndex"];
			this.sortColumnIndex=keymap["columnIndex"];
			var col:KDataGridColumn=KDataGridHeader(this._headers[this.sortTableIndex]).Columns[this.sortColumnIndex];
			
			switch(col.dataType)
			{
				case KDataFormat.TYPE_STRING:
					if(type=="ASC"){
						this.Data.sort(sortStringASC);
					}else{this.Data.sort(sortStringDESC);}
					break;
				case KDataFormat.TYPE_INT:
				case KDataFormat.TYPE_UINT:
				case KDataFormat.TYPE_NUMBER:
					if(type=="ASC"){
						this.Data.sort(sortNumberASC);
					}else{this.Data.sort(sortNumberDESC);}
					break;
			}
			this.currentIndex=0
			for each(var row:KRecordSetRow in this.Data)
			{
					row.Index=this.currentIndex++;
			}
						
		}
		private function sortStringASC(a:KRecordSetRow,b:KRecordSetRow):int
		{			
			var aa:String=String(a.Data[this.sortTableIndex][this.sortColumnIndex]).toUpperCase();
			var bb:String=String(b.Data[this.sortTableIndex][this.sortColumnIndex]).toUpperCase();
			if(aa>bb){return 1}
			else if(aa<bb){return -1}
			else{return 0}			
		}
		private function sortStringDESC(a:KRecordSetRow,b:KRecordSetRow):int
		{
			var aa:String=String(a.Data[this.sortTableIndex][this.sortColumnIndex]).toUpperCase();
			var bb:String=String(b.Data[this.sortTableIndex][this.sortColumnIndex]).toUpperCase();
			if(aa>bb){return -1}
			else if(aa<bb){return 1}
			else{return 0}
		}
		private function sortNumberASC(a:KRecordSetRow,b:KRecordSetRow):int
		{			
			var aa:Number=a.Data[this.sortTableIndex][this.sortColumnIndex];
			var bb:Number=b.Data[this.sortTableIndex][this.sortColumnIndex];
			if(aa>bb){return 1}
			else if(aa<bb){return -1}
			else{return 0}			
		}
		private function sortNumberDESC(a:KRecordSetRow,b:KRecordSetRow):int
		{			
			var aa:Number=a.Data[this.sortTableIndex][this.sortColumnIndex];
			var bb:Number=b.Data[this.sortTableIndex][this.sortColumnIndex];
			if(aa>bb){return -1}
			else if(aa<bb){return 1}
			else{return 0}			
		}
		
	}
}




























