package com.adobe.nativeExtensions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;
	
	public final class AppPurchase extends EventDispatcher
	{
		private static var ext:ExtensionContext = null;
		private static var checkSingleton:Boolean = false;
		private static var m_Manager:AppPurchase = null; 
		public function AppPurchase()
		{
			trace("AS - In Constructor"); 
			super();
			if(ext == null){
				trace("AS - Creating Context");
				try{
					ext = ExtensionContext.createExtensionContext("com.adobe.appPurchase","");
					if(ext!=null)
						ext.addEventListener(StatusEvent.STATUS,onStatus);
				}catch(e:Error){
					
				}
				debugLog("AS - Asked For products");
			}else{
				throw new Error("This is a singleton. Use instance property instead.",1000);
			}
		}
		
		public static function get manager():AppPurchase{
			if(m_Manager == null){
				m_Manager = new AppPurchase(); 
			} 
			return m_Manager;
		}
		
		public function getProducts(ids:Array):void{
			if(ext!=null)
				ext.call("getProducts",ids.join(","));
		}
		
		public function startPayment(pid:String,quantity:int = 1):void{
			if(ext!=null)
			 ext.call("startPayment",pid,quantity);
		} 
		
		public function finishTransaction(tid:String):Boolean{
			var ret:Object = ext.call("finish",tid);
			if(ret == null) return false else return ret; 
		}
		
		public function restoreTransactions():void{
			if(ext!=null)ext.call("restore");
		}
		
		public function alertMsg(title:String,mess:String,button:String):void{
			if(ext!=null)ext.call("alertMsg",title,mess,button);
		}
		
		public function debugLog(log:String):void{
			if(ext){
				ext.call("debugLog",log);
			}
		}
		
		public function getDeviceID():String{
			if(ext!=null){
				return ext.call("getDeviceID") as String;
			}else{
				return "null";
			}
		}
		
		public function getDeviceVersion():String{
			if(ext!=null){
				return ext.call("getDeviceVersion") as String;
			}else{
				return "null";
			}
		}
		
		public function getDeviceType():String{
			if(ext!=null){
				return ext.call("getDeviceType") as String;
			}else{
				return "null";
			}
		}
		
		
		public function get muted():Boolean{
			var ret:Object = ext.call("muted");
			if(ret == null) return true else return ret;
		}
		
		public function get transactions():Array{
			var o:Object = ext.call("trans");
			var xmlStr:String = o as String;
			var arr:Array = new Array();
			var txml:XML = new XML(xmlStr);
			debugLog("APP - In Transactions Prop...");
			debugLog(txml);
			for each(var t:* in txml.transaction){
				arr.push(getTransaction(t)); 
			}
			
			return arr;
		}
		
		public function onStatus(e:StatusEvent):void{ 
			debugLog("Status Event Fired...");
			var arr:Array = new Array(); 
			var arr2:Array = new Array();
			switch(e.code){
				case AppPurchaseEvent.PRODUCTS_RECEIVED:
					debugLog("Products Received");  
					arr = new Array();
					var xml:XML = new XML(e.level);
					for each(var p:* in xml.product){
						 arr.push(new Product(p.title.toString(),p.desc.toString(),p.id.toString(),p.locale.toString(),Number(p.price))); 
					}
					arr2 = new Array();
					if(xml.descendants("invalid").children() != null){
						for each(var s:* in xml.invalid.id){
							arr2.push(s);
							debugLog(s); 
						}
					}
					dispatchEvent(new AppPurchaseEvent(AppPurchaseEvent.PRODUCTS_RECEIVED,arr,arr2,null,null));
					break;
				case AppPurchaseEvent.UPDATED_TRANSACTIONS:
				case AppPurchaseEvent.REMOVED_TRANSACTIONS:
					arr = [];
					var txml:XML = new XML(e.level);
					debugLog(e.level);
					for each(var t:* in txml.transaction){ 
						arr.push(getTransaction(t)); 
					}
					dispatchEvent(new AppPurchaseEvent(e.code,null,null,arr,null)); 
					break;
				case AppPurchaseEvent.RESTORE_FAILED:
					dispatchEvent(new AppPurchaseEvent(e.code,null,null,null,e.level));
					break;
				case AppPurchaseEvent.RESTORE_COMPLETE:
					dispatchEvent(new AppPurchaseEvent(e.code,null,null,null,null));
					break;
			}
		} 
		
		private function getTransaction(t:Object):Transaction{
			var state:int = int(t.state.toString());
			var prodId:String =  t.pid.toString();
			var prodQ:int = int(t.q.toString());
			var timest:Number = Number( t.date.toString() ) ;
			var d:Date = ( timest == 0.0?null:new Date( timest ) );
			var id:String = (t.id.toString() == "(null)"?null:t.id.toString()); 
			var rec:String = Base64.Encode(t.receipt.toString()); 
			var error:String = "";
			var og:Transaction = null;
			if(state == Transaction.TRANSACTION_STATE_FAILED){
				error = t.error;
			}
			if(state == Transaction.TRANSACTION_STATE_RESTORED){
				og = getTransaction(t.og); 
			}
			return new Transaction(error,prodId,prodQ,d,id,rec,state,og);
		}
	}
}