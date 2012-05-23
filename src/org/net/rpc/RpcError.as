package org.net.rpc
{
	public class RpcError extends Error
	{
		public function RpcError()
		{
			public static var PARAMETERS_ARE_UNCONFORMITY:String="parameters are unconformity";
			public static var REQUESTER_IS_NULL:String="requester is null";
			public static var URI_IS_NULL:String="uri is empty";
			public static var TIME_OUT:String="request time out";
			public static var UNKNOWN_ERROR:String="unknow error"
				
			public function get id():int
			{
				return this.errorID;
			}
			public function get msg():String
			{
				return this.message;
			}
			public function KRPCError(id:int=0,msg:String="")
			{
				super(msg,id);
			}
			public function toString():String
			{
				return "Error ID:"+this.id+"    "+"Message:"+this.msg;
			}
		}
	}
}