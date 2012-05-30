package com.kaixin.net.rpc
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*JIAN.WU@OPI-CORP.COM
	*2009-6-9 ����05:52:50
	*/
	
	public class KRPCError extends Error
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
			return "Error ID:"+errorID+"    "+"Message:"+message;
		}
	}
}