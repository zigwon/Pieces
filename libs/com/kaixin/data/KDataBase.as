package com.kaixin.data
{
	import flash.utils.Dictionary;

	/**WWW.LUNASTUDIO.CN
	*KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-7-2 ����23:24:11
	*/
	public class KDataBase
	{
		public var tables:Dictionary;
		
		public function KDataBase(focer:ForceSingleton)
		{
			this.tables=new Dictionary();
		}
		
		private static var database:KDataBase;
		
		public static function connect():KDataBase
		{
			if(database==null)
			{
				database=new KDataBase(new ForceSingleton());
			}
			return database;
		}
		
				
		public function createTable(tableName:String):KTable
		{
			if(this.tables[tableName]!=null){throw new Error("table exist")}
			this.tables[tableName]=new KTable(tableName);
			return this.tables[tableName];
		}
		public function deleteTable(tableName:String):void
		{
			this.tables[tableName]=null;
		}
	}
}
class ForceSingleton{}