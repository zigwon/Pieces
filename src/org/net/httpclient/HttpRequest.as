package org.net.httpclient
{	
	import com.adobe.net.URI;
	import com.adobe.net.URIEncodingBitmap;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	public class HttpRequest
	{	
		public static const kUriPathEscapeBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %?#");
		public static const kUriQueryEscapeBitmap:URIEncodingBitmap = new URIEncodingBitmap(" %=|:?#/@+\\"); // Probably don't need to escape all these
		
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
			
			loadDefaultHeaders();
		}
		
		/**
		 * Include headers here that are global to every request.
		 */
		protected function loadDefaultHeaders():void {
			addHeader("Connection", "keep-alive");
			//addHeader("Content-Length", "16");
			//addHeader("Accept-Encoding", "gzip, deflate");
			//addHeader("Accept-Language", "en-us");            
			//addHeader("User-Agent", "as3httpclientlib 0.1");
			//addHeader("Accept", "*/*");
		}
		
		
		public function get header():HttpHeader { return _header; }
		public function get method():String { return _method; }
		public function get body():* { return _body; }
		
		/**
		 * Add a header.
		 * @param name
		 * @param value
		 */
		public function addHeader(name:String, value:String):void {
			_header.add(name, value);
		}
		
		/**
		 * Get HttpHeader.
		 */
		public function getHeader(uri:URI):ByteArray {
			var bytes:ByteArray = new ByteArray();
			
			var path:String = uri.path;
			if (!path) path = "/";
			else path = URI.fastEscapeChars(path, kUriPathEscapeBitmap);
			
			// Escape params manually; and escape alot
			var query:Object = uri.getQueryByMap();
			var params:Array = [];
			for(var key:String in query) {
				var escapedKey:String = URI.fastEscapeChars(key, kUriQueryEscapeBitmap);
				var escapedValue:String = URI.fastEscapeChars(query[key], kUriQueryEscapeBitmap);
				params.push(escapedKey + "=" + escapedValue);
			}
			if (params.length > 0) path += "?" + params.join("&");      
			
			var host:String = uri.authority;
			if (uri.port) host += ":" + uri.port;
			
			var version:String = "1.1";
			
			bytes.writeUTFBytes(method + " " + path + " HTTP/" + version + "\r\n");
			bytes.writeUTFBytes("Host: " + host + "\r\n");
			
			if (!header.isEmpty)
				bytes.writeUTFBytes(header.content);
			
			bytes.writeUTFBytes("\r\n");
			
			bytes.position = 0;
			return bytes;
		}
		
		/**
		 * put request body
		 *  
		 * @param requestObj 
		 */
		public function putRequestBody(requestObj:HttpRequestObject):void {
			if (!_body)
				_body = new Array();
			
			_body.push(requestObj);
		}
		
	}
}