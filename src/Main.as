package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.data.model.global.GlobalModel;
	import org.interfaces.ILoader;
	import org.manager.LoaderManager;
	import org.net.AbcLoaderText;
	import org.manager.GlobalManager;
	import org.manager.ServerManager;
	
	[SWF(width=1024, height=768, frameRate=30,backgroundColor="#321519")]
	public class Main extends MovieClip
	{
		private var icon:Loader
		
		
		public function Main()
		{
			trace("bbb");
			this.addEventListener(Event.ADDED_TO_STAGE,loadID);
		}
		
		/**
		 * 1001:加载初始化 
		 * 1002:加载字典文件结束
		 * 1003:加载结束
		 * @param e
		 * 
		 */		
		private function loadID(e:Event):void{
			LoaderManager.instance.registerLoadHandler(AbcLoaderText,"../asset/id.txt",initialize)
		}
		
		private function initialize(e:ILoader):void{
			//当前用户赋值
			GlobalModel.userId = e.data;
			trace("userId:" + GlobalModel.userId);
			//全局变量
			GlobalManager.instance.initialize(stage);
				
			ServerManager.instance.callServer(["getUserPets", [224049118], ["test"]]);
		}
		
	}
}