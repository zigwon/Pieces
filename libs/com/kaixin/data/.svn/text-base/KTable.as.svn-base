package com.kaixin.data
{
	import com.kaixin.utils.KOperator;

	/**WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-7-2 ����11:27:25
	*/
	public class KTable extends KDataGrid
	{
		
		
		
		protected var tableName:String
		public function get TableName():String
		{
			return this.tableName;
		} 
		public function KTable(tableName:String="",header:KDataGridHeader=null)
		{
			super(header);
			this.name=tableName;
			this.tableName=tableName;			
		}
		
		
		
		public function clone(fullHeaderName:Boolean=false):KTable
		{
			var kt:KTable=new KTable(this.tableName);		
			kt.Header=this._header.clone(KDataGrid(kt),fullHeaderName);
			kt.Data=this._data.slice();
			return kt;
		} 
		
	}
}