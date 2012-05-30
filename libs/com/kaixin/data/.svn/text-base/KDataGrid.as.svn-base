package com.kaixin.data
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-3 ����12:03:03
	*/
	
	public class KDataGrid
	{
	
		
		
		protected var _name:String
		public function get name():String
		{
			return this._name;
		} 
		public function set name(n:String):void
		{
			this._name=n;
		} 
		
		
		/**set or get the data
		 */ 	
		protected var _data:Array=[];
		public function set Data(d:Array):void
		{
			
			if(this._header.length==0){throw new Error("header isn't defined")}
			//if(d.length==0){throw new Error("data empty")}
			if(d.length!=0 && d[0].length>this._header.length){throw new Error("data beyond header number")}
			this._data=d;
			
			for (var c:* in this._header.Columns)
			{
				var col:KDataGridColumn=this._header.Columns[c];
				col.currentIncrement=0;
				for each(var row:Array in this._data)
				{
					if(row[col.index]==null){
						row[col.index]=col.defaultValue;
					}
				}
				/*if(col.isIncrese){
					col.currentIncrement=0;
					for each(var row:Array in this._data)
					{	col.currentIncrement+=col.increment;
						row[col.index]=col.currentIncrement;						
					}
				}*/
			}
			
		}
		public function get Data():Array
		{
			return this._data;
		}
		
		protected var _header:KDataGridHeader;

		public function get Header():KDataGridHeader
		{
			return _header;
		}

		public function set Header(v:KDataGridHeader):void
		{
			_header = v;
		}	
	
		public function KDataGrid(header:KDataGridHeader=null,data:Array=null)
		{
			if(header!=null)
			{
				_header=header;
			}else{
				_header=new KDataGridHeader(this);
			}
			if(data!=null)this.Data=data;
		}
		public function createFromDataGrid(dg:KDataGrid):void
		{
			this.Header=dg.Header;
			this.Data=dg.Data;
		}
		
		public function addColumn(col:KDataGridColumn):void
		{
			_header.addColumn(col);
			col.header=_header;		
			for each(var row:Array in this._data)
			{
				row.push(col.defaultValue)
			}
		}
		/*public function findIncreseColumn()
		{
			for (var c in this._header.Columns)
			{
				var col:KDataGridColumn=this._header.Columns[c];
				if(col.isIncrese){
					col.currentIncrement=0;
					for each(var row:Array in this._data)
					{
						row[col.index]=col.currentIncrement;
						col.currentIncrement+=col.increment;
					}
				}
			}
		}*/
		public function addRows(data:Array):void
		{
			for each(var r:* in data)
			{
				this.addRow(r);
			}
		}
		public function addRow(data:Array):void
		{
			if(data.length>this.Header.Columns.length) throw new Error("data beyond header number")			
			this._data.push(data)
			for (var c:* in this._header.Columns)
			{
				var col:KDataGridColumn=this._header.Columns[c];
				if(data[col.index]==null){data[col.index]=col.defaultValue;}
				/*if(col.isIncrese){
					col.currentIncrement+=col.increment;
					data[col.index]=col.currentIncrement;
				}*/
			}
		}
		public function findKey(key:String):int
		{			
			var col:KDataGridColumn=this._header.Keys[key];
			return col==null?-1:col.index
		}
		public function fixMapKey(arr:Array=null,keyindex:int=0):void
		{
			if(arr==null)return;
			var cond:*
			for each(cond in arr)
			{
				var key:*=cond[keyindex]
				if(!isNaN(key)){key=Number(key)}
				if(key is String)
				{
					key=findKey(key);
					if(key==-1){throw new Error("can't find the key")}				
				}else if(key>=this.Header.length)
				{
						throw new Error("beyond the keys' range")
				}
				cond[keyindex]=key
			}
		}		
		
	}
}