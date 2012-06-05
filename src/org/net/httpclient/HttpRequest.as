package org.net.httpclient
{	
	import com.adobe.net.URI;
	
	import flash.errors.IllegalOperationError;
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
		
		
		public function get header():HttpHeader { return _header; }
		public function get method():String { return _method; }
		public function get body():* { return _body; }
		
		/**
		 * Add a header.
		 * @param value
		 */
		public function addHeader(value:String):void {
			_header.add(value);
		}
		
		/**
		 * Get header.
		 */
		public function getHeader():ByteArray {
			var headData:ByteArray = new ByteArray();
			headData.writeInt(0xA1B2);
			headData.writeByte(0x10);
			headData.writeByte(0xC);
			
			for each(var prop:String in _header.headers)
				headData.writeUTF(prop);
				
			return headData;
		}
		
		/**
		 * put request body
		 *  
		 * @param requestObj 
		 */
		public function putRequestBody(requestObj:HttpRequestObject):void {
			if (_body)
				_body = [];
			
			_body.push(requestObj);
		}
		
	}
}