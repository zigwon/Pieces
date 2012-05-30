package com.kaixin.data
{
	/**WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-7-3 ����01:00:35
	*/
	public class KDataGridColumn
	{
		public var header:KDataGridHeader
		private var colName:String;
		public var name:String;
		public var dataType:int
		private var _defaultValue:*;
		public function get defaultValue():*
		{
			if(isIncrese)
			{	
				this.currentIncrement+=this.increment
				return this.currentIncrement
			}
			return _defaultValue;
		}
		public var isPrimary:Boolean=false;
		public var index:int=0;
		private var _isFullName:Boolean=false;
		private var _isIncrese:Boolean=false;
		public function set isIncrese(inc:Boolean):void
		{
			if(!inc)return;
			if(dataType!=KDataFormat.TYPE_INT && dataType!=KDataFormat.TYPE_UINT)
			{
				throw new Error("column is not the int type")
			}
			this._isIncrese=inc;
		}
		public function get isIncrese():Boolean
		{
			return this._isIncrese;
		}
		public var increment:int=1; 
		public var currentIncrement:int=0;
		
		public function set isFullName(c:Boolean):void
		{
			_isFullName=c;
			if(_isFullName && header.dataGrid.name!=""){
				this.name=header.dataGrid.name+"."+colName;
			}else{
				this.name=colName;
			}
		}
		public function get isFullName():Boolean
		{
			return this._isFullName;	
		}
		
		public function KDataGridColumn(name:String,dataType:int,isPrimary:Boolean=false,defaultValue:*=null,isIncrese:Boolean=false,increment:int=1):void
		{
			this.colName=this.name=name;
			this.dataType=dataType;
			this._defaultValue=defaultValue;
			this.isPrimary=isPrimary;
			this.isIncrese=isIncrese;
			this.increment=increment;
		}
		public function clone(head:KDataGridHeader):KDataGridColumn
		{
			var col:KDataGridColumn=new KDataGridColumn(this.colName,this.dataType,this.isPrimary,this.defaultValue,this.isIncrese,this.increment);
			col.header=head;
			return col;
		}
	}
}