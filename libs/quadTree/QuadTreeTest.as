package quadTree  
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	

	[SWF(backgroundColor="0x000000")]
	public class QuadTreeTest extends Sprite
	{
		private var _modelContainer:Sprite  = new Sprite();
		private var _selectContainer:Sprite =new Sprite();
		private var _selectModels:Vector.<DisplayObject> ;
		private var _tree:QuadTree;
		private var _downLoc:Point  = new Point();;

		public function QuadTreeTest()
		{
			addChild(_modelContainer);
			addChild(_selectContainer);
			
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE , init );
		}
		
		private function init( e:Event = null ):void
		{
			stage.scaleMode="noScale";
			stage.align="TL";
			removeEventListener(Event.ADDED_TO_STAGE , init );
			stage.addEventListener(MouseEvent.MOUSE_DOWN , onDown );
			stage.addEventListener(MouseEvent.MOUSE_MOVE , onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP , onUp);
			
			_tree = new QuadTree( 4 , new Rectangle(0,0,1200,750));
			var model:QuadModel ;
			for( var i:int = 0 ; i<40 ; i++)
			{
				for(var j:int = 0 ; j<25 ; j++)
				{
					model = new QuadModel();
					model.x = i*model.width + i*10 ;
					model.y = j*model.height + j*10 ;
					_modelContainer.addChild( model );
					_tree.insertObj( model );
				}
			}
		}
		

		
		private function onDown(e:MouseEvent):void 
		{
			_downLoc.x = mouseX;
			_downLoc.y = mouseY;

			//Clear the last selected
			if(_selectModels)
			{
				for each( var obj:DisplayObject in _selectModels)
				{
					obj.alpha =1 ;
				}
			}
		}
		
		private function onMove(e:MouseEvent):void
		{
			if(e.buttonDown)
			{
				_selectContainer.graphics.clear();
				_selectContainer.graphics.beginFill(0x000000,.5);
				_selectContainer.graphics.lineStyle(1,0xCCCCCC,.5);
				_selectContainer.graphics.drawRect( _downLoc.x,_downLoc.y,mouseX-_downLoc.x,mouseY-_downLoc.y);
				_selectContainer.graphics.endFill();
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			var time:int = getTimer();
			_selectModels = _tree.searchByRect( new Rectangle( _downLoc.x,_downLoc.y,mouseX-_downLoc.x,mouseY-_downLoc.y ),true);
			trace( getTimer()-time);  //ms
			for each( var obj:DisplayObject in _selectModels)
			{
				obj.alpha = 0.5 ;
			}
			_selectContainer.graphics.clear();
		}
	}
}