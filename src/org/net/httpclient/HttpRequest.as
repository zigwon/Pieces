package org.net.httpclient
{	
	import com.adobe.net.URI;
	
	import flash.utils.ByteArray;
	
	
	public class HttpRequest
	{
		// Request method. For example, "GET", "POST"...
		protected var _method:String;
		
		// Request header
		protected var _header:HttpHeader;
		
		// Request body
		protected var _body:*;
		
		
		
		/**
		 * Create request.
		 *  
		 * @param method
		 * @param header
		 * @param body 
		 */
		public function HttpRequest(method:String, header:HttpHeader = null, body:* = null)
		{
			_method = method;
			_body = body;
			_header = header;
			
			// Create default header, an empty header
			if (!_header) _header = new HttpHeader();
			
		}
		
		
		/**
		 * Get header.
		 */
		public function getHeader(value:String):ByteArray {
			var headData:ByteArray = new ByteArray();
			headData=new ByteArray();
			headData.writeInt(0xA1B2);
			headData.writeByte(0x10);
			headData.writeByte(0xC);
			
			headData.writeUTF(value);
			return headData;
		}
	}
}