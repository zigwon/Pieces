package com.kaixin.net.rpc
{
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 11, 2009 10:13:51 AM
	 */
	
	public class KRPCHandleObject
	{
		public var funcName:String;
		public var callBacks:Array=[];
		public static var defaultCallBack:Function
		public function KRPCHandleObject(func:String,callBacks:Array)	{
			this.funcName=func;
			if(callBacks!=null)this.callBacks=callBacks;
			this.callBacks.unshift(defaultCallBack);
		}
		public function toString():String
		{
			return "request method:"+this.funcName;
		}
	}
}