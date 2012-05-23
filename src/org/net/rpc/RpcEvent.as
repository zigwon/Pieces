package org.net.rpc
{
	import flash.events.Event;

	public class RpcEvent extends Event
	{	
		public static var REQUEST_COMPLETE:String="requestcomplete"
		public static var REQUEST_ERROR:String="requesterror"
			
			
		public function RpcEvent(type:String,data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}