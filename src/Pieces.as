package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[SWF(width=1024, height=768, frameRate=30,backgroundColor="#321519")]
	public class Pieces extends MovieClip
	{
		private var icon:Loader
		
		
		public function Pieces()
		{
			trace("aaaaa");
			loadInit();
		}
		
		
		/**
		 *	初始化
		 */		
		private function loadInit(){
			var loader:Loader = new  Loader();
			var request:URLRequest = new URLRequest("loading_init.swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingInitComplete);
			var context:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain);
			loader.load(request, context);
		}
		
		
		/**
		 *	初始化完成监听
		 */		
		private function loadingInitComplete(event:Event):void{
			
			icon=LoaderInfo(event.target).loader
			
			icon.x=stage.stageWidth/2
			icon.y=stage.stageHeight/2
			
			addChild(icon)
			
		}
		
		
	}
}