package test
{
	import com.adobe.net.URI;
	
	import org.net.httpclient.HttpRequest;
	import org.net.httpclient.HttpSocket;
	import org.net.httpclient.http.Post;

	public class TestCase
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testA():void
		{
			trace("asdf");
		}
		
		/**
		 * Test post using rails resource.
		 */
		public function testPost():void {
			//http://rrworldhd.renren.com/gamedata.py
			var uri:URI = new URI("http://sgtest.renren.com:8084/gamedata.py?appId=110215&t=1338802726491");
			var request:HttpRequest = new Post();
			var _socket:HttpSocket = new HttpSocket();
			
			_socket.request(uri, request);

		}
	}
}