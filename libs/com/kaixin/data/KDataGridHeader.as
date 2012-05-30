package com.kaixin.data
{
	

	/**WWW.OPI-CORP.COM
	*AS FLEET
	*@author JIAN.WU
	*JIAN.WU@OPI-CORP.COM
	*2009-7-2 ����12:22:16
	*/
	
	public class KDataGridHeader
	{
		private var keys:Object
		
		public function get Keys():Object
		{
			return keys;
		}
		
		
		
		
		/** headr is used to descrite the data columns name and data type
		* @example the fomart like this...  
		* <listing version="3.0"> 
				Columns=[new KColumn("id",KDataFormart.VAR_TYPE_INT),new KColumn("name",KDataFormart.VAR_TYPE_STRING)]				
				</listing>
		*@see com.kaixin.data.KColumn
		*@see com.kaixin.data.KDataFormart
		*/ 
		private var columns:Array
		
		public function get Columns():Array
		{
			return columns;
		}

		public function set Columns(arr:Array):void
		{
			for each(var col:* in arr)
			{
				var nCol:KDataGridColumn;
				if(col is KDataGridColumn)
				{
					
					nCol=KDataGridColumn(col);					
				}else if(col is String){
					
					nCol=new KDataGridColumn(col,KDataFormat.TYPE_STRING);													
				}else{
					throw new Error("wrong column format")
				}
				
				nCol.header=this;
				newColumn=nCol
			}
			
		}
		
		private var primaryColumn:KDataGridColumn		
		public function get PrimaryColumn():KDataGridColumn
		{
			return this.primaryColumn;
		}
		public function set PrimaryIndex(index:int):void
		{
			var kc:KDataGridColumn=KDataGridColumn(this.columns[index])
			kc.isPrimary=true;
			this.primaryColumn=kc;
		}
		
		protected function set newColumn(col:KDataGridColumn):void
		{
			if(this.keys[col.name]==null){
				this.keys[col.name]=col;
			}else{
				throw new Error("repeated column")
			}
			
			col.index=this.columns.length;
			this.columns.push(col)
		}
		
		public function get length():int
		{
			return this.columns.length;
		}

		
		
		private var _dataGrid:KDataGrid;
		
		public function get dataGrid():KDataGrid
		{
			return this._dataGrid;
		}
		public function KDataGridHeader(dataGrid:KDataGrid)
		{
			this._dataGrid=dataGrid;
			this.columns=[];
			this.keys={};
			
		}
		
		public function addColumn(col:KDataGridColumn):void
		{
			newColumn=col;
		}
		public function clone(dataGrid:KDataGrid,isFullName:Boolean=false):KDataGridHeader
		{
			var hd:KDataGridHeader=new KDataGridHeader(dataGrid);
			for each(var col:KDataGridColumn in this.Columns){
				var nCol:KDataGridColumn=col.clone(hd);
				nCol.isFullName=isFullName;
				hd.addColumn(nCol);
			}
			return hd;
		}
	}
}