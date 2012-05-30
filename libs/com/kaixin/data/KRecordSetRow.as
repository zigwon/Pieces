package com.kaixin.data
{
	/**WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-7-3 ����12:51:37
	*/
	public class KRecordSetRow
	{
		public var Index:int=0;
		
		private var _data:Array		
		public function get Data():Array
		{
			return _data;
		}
		public function set Data(v:Array):void
		{
			_data = v;
			makeMapData();
		}
		private var _fieldData:Object
		public function get FieldData():Object
		{
			return this._fieldData;
		}
		/*private var _tableData:Object
		public function get TableData():Object
		{
			return this._tableData;
		}*/
		
		
		private var _headerMap:KRecordSetHeaderMap
		public function KRecordSetRow(headermap:KRecordSetHeaderMap,data:Array=null)
		{
			this._headerMap=headermap;
			_data=[];
			_fieldData={};
			//_tableData={};
			if(data!=null){this.Data=data;}
		}
		public function addRowData(newMaps:*,datas:*):void
		{
			this._data.push(datas);
			makeMapData(newMaps);
		}
		/*
		public function insert(value:*,index:int=-1):void
		{
			if(index==-1)
			{
				this._data.push(value);
			}else{
				this._data.splice(index,0,value);
			}
		}
		public function push(value:*):void
		{
			this._data.push(value);
		}
		public function clean(index:int):void
		{
			this._data[index]=null;
		}
		public function update(index:int,value:*):void
		{
			this._data[index]=value;
		}*/
		public function makeMapData(maps:*=null):void
		{
			if(maps==null)maps=this._headerMap;
			for(var mapname:* in maps)
			{
				var map:*=maps[mapname];
				this._fieldData[mapname]=this._data[map.tableIndex][map.columnIndex]
			}
			
		}
	}
}