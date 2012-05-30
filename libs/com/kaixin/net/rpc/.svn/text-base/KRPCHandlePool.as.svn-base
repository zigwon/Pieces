package com.kaixin.net.rpc
{
	import flash.utils.Dictionary;
	
	/**
	 * WWW.OPI-CORP.COM
	 * AS FLEET
	 * @author JIAN.WU
	 * JIAN.WU@OPI-CORP.COM
	 * Nov 11, 2009 10:04:45 AM
	 */
	
	public class KRPCHandlePool
	{
		private static var instance:KRPCHandlePool;
		internal var pool:Dictionary=new Dictionary(true);
		public function KRPCHandlePool(s:singleton)
		{
		}
		public static function connect():KRPCHandlePool
		{
			if(instance==null)instance=new KRPCHandlePool(new singleton());
			if(KRPCHandleObject.defaultCallBack==null)KRPCHandleObject.defaultCallBack=handleDefaultCallBack;
			return instance;
		}
		
		public function newHandle(func:String,callbacks:Array):void
		{
			newHandleObject(new KRPCHandleObject(func,callbacks))
		}
		public function newHandleObject(handle:KRPCHandleObject):void
		{
			if(pool[handle.funcName]==null)
			{
				pool[handle.funcName]=handle;
			}else{
			
				removeHandle(handle.funcName,handle.callBacks);	
				//pool[handle.funcName].push(handle);
				KRPCHandleObject(pool[handle.funcName]).callBacks=KRPCHandleObject(pool[handle.funcName]).callBacks.concat(handle.callBacks);
				
			}
		}
		public function removeHandle(func:String,callBacks:Array=null):void
		{
			if(pool[func]!=null)
			{
				if(callBacks==null)
				{
					KRPCHandleObject(pool[func]).callBacks=[];
				}else{
					for each(var f:Function in callBacks)
					{
						for(var i:int=0;i<KRPCHandleObject(pool[func]).callBacks.length;i++)
						{
							var of:Function=KRPCHandleObject(pool[func]).callBacks[i];
							if(f==of)
							{
								KRPCHandleObject(pool[func]).callBacks.splice(i,1);
								i--;
							}
						}
					}
				}
			}			
		}
		public function call(func:String,args:Array):void
		{
			if(pool[func]!=null)
			{
				for each(var f:Function in KRPCHandleObject(pool[func]).callBacks)
				{
					f.apply(null,args);
				}
			}
		}
		public static function handleDefaultCallBack(...res):void
		{
			//override by child;
		}
	}
}
class singleton{}