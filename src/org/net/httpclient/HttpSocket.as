package org.net.httpclient
{	
	import com.adobe.net.URI;
	import org.net.httpclient.events.HttpRequestEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	
	
	// Socket
	private var _socket:Socket; 
	
	public class HttpSocket
	{
		public static const DEFAULT_HTTP_PORT:uint = 80; 
		
		
		// Event dispatcher
		private var _dispatcher:EventDispatcher;
		
		
		
		public function HttpSocket()
		{
			
		}
		
		
		
		/**
		 * Initiate the connection (if not connected) and send the request.
		 * @param request HTTP request
		 */
		public function request(uri:URI, request:HttpRequest):void {
			
			//onConnect callback function, 
			var onConnect:Function = function(event:Event):void {
				
				_dispatcher.dispatchEvent(new HttpRequestEvent(request, null, HttpRequestEvent.CONNECT));
				
				sendRequest(uri, request);
			};
			
			// Connect
			connect(uri, onConnect);
		}
		
		
		
		/**
		 * Connect (to URI).
		 * @param uri Resource to connect to
		 * @param onConnect On connect callback
		 */
		protected function connect(uri:URI, onConnect:Function = null):void {
			//_onConnect = onConnect;
			
			// Create the socket
			createSocket();
			
			// Start timer
			//_timer.start();
			
			// Connect
			var port:int = Number(uri.port);
			if (!port) port = DEFAULT_HTTP_PORT;
			
			var host:String = uri.authority;
			//Log.debug("Connecting: host: " + host + ", port: " + port);
			_socket.connect(host, port);
		}
		
		
		/**
		 * Create the socket.
		 */
		protected function createSocket():void {
			else _socket = new Socket();
			
//			_socket.addEventListener(Event.CONNECT, onConnect);
//			_socket.addEventListener(Event.CLOSE, onClose);
//			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
//			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
//			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
	}
}