package com.kaixin.net.rpc
{
	/**WWW.OPI-CORP.COM
	*AS FLEET
	*JIAN.WU@OPI-CORP.COM
	*2009-6-8 ����02:33:15
	*/
	
 
	
	public class KRPCRequestObject 
	{
		
		public var funcName:String;
		public var vars:Array;
		public var callBacks:Array;
		public var errorHandles:Array=[]	
		public static var defaultCallBack:Function
		public static var defaultErrorHandle:Function
		public function KRPCRequestObject(func:String,vars:Array,callbacks:Array,errorHandles:Array=null)	{
			this.funcName=func
			this.vars=vars;
			this.callBacks=callbacks;		
			if(errorHandles!=null)this.errorHandles=errorHandles;	
			
			this.callBacks.unshift(defaultCallBack);
			this.errorHandles.unshift(defaultErrorHandle);
		}
		public function toString():String
		{
			return "request method:"+this.funcName;
		}
	}
}