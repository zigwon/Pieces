package org.net.httpclient
{
	public class HttpRequestObject
	{
		private var _funcName:String;
		private var _vars:Array;
		
		
		public function RpcRequestObject(func:String,vars:Array,callbacks:Array,errorHandles:Array=null)
		{
			this._funcName=func
			this._vars=vars;
		}
		
		public function get vars():Array
		{
			return _vars;
		}
		
		public function set vars(value:Array):void
		{
			_vars = value;
		}
		
		public function get funcName():String
		{
			return _funcName;
		}
		
		public function set funcName(value:String):void
		{
			_funcName = value;
		}
		
		public function toString():String
		{
			return "request method:"+this._funcName;
		}
	}
}