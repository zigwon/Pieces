package org.net.httpclient.http
{
	import org.net.httpclient.HttpRequest;
	import org.net.httpclient.HttpRequestObject;

	public class Post extends HttpRequest
	{
		public function Post(reqObj:HttpRequestObject = null)
		{
			super("POST");
			if (reqObj) putRequestBody(reqObj);
		}
	}
}