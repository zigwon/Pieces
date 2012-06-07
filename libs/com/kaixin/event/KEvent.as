package com.kaixin.event
{
	/** WWW.KAIXIN.COM
	*@author JIAN.WU
	*MINZOJIAN@HOTMAIL.COM
	*Jun 17, 2009 5:03:25 PM
	*/
	
	import flash.events.Event;
	
	public class KEvent extends Event
	{
		public var data:*
		public function KEvent(type:String, data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
	}
}