package org.net
{
	import flash.utils.ByteArray;
	
	import org.net.rpc.RpcClient;

	public class AbcRpcClient extends RpcClient
	{
		private var headData:ByteArray;
		
		public function AbcRpcClient(code:String)
		{
			super();
			this.code = code;
		}
		
		
		public function set code(value:String):void{
			headData=new ByteArray();
			headData.writeInt(0xA1B2);
			headData.writeByte(0x10);
			headData.writeByte(0xC);
			//b.writeUTF(this.sessionId);
			headData.writeUTF(value);
			//b.writeUTF(this.userId);
		}
		
		
		override public function readyRequest(completeHandle:Function=null,errorHandle:Function=null):void
		{
			super.readyRequest(completeHandle,errorHandle);
			this.requester.headData=headData;
		}
	}
}