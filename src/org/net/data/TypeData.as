package org.net.data
{
	/**
	 * 带类型的数据 
	 * @author cx
	 * 
	 */
	public class TypeData
	{
		private var _v:Object;
		private var _t:int;
		/**
		 * 
		 * @param value 数据
		 * @param type  类型
		 * 
		 */
		public function TypeData(type:int,value:Object)
		{
			_t = type;
			_v = value;
		}
		
		public function get Value():Object
		{
			return _v;
		}		
		public function set Value(value:Object):void
		{
			_v = value;
		}
		
		public function get Type():int
		{
			return _t;
		}
		public function toString():String
		{
			return String(Value);
		}
	}
}