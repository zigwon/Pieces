package test
{
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
		
		[Test]
		public function testB():void
		{
			trace("bbb");
		}
	}
}