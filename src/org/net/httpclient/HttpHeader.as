package org.net.httpclient
{
	public class HttpHeader
	{
		private var _headers:Array;

		
		public function HttpHeader(headers:Array = null)
		{
			_headers = headers;
			if (!_headers) _headers = [];
		}
		
		
		/**
		 * Get the header content for HTTP request.
		 */
		public function get headers():Array {
			return _headers;
		}
	}
}