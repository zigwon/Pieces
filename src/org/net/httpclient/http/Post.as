package org.net.httpclient.http
{
	import org.net.httpclient.HttpRequest;

	public class Post extends HttpRequest
	{
		public function Post(params:Array = null)
		{
			super("POST");
			if (params) setFormData(params);
		}
	}
}