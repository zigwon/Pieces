package com.kaixin.utils
{
	import com.kaixin.base.IBindAbleObject;
	/** WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*Jun 16, 2009 4:01:35 PM
	*/
	/** this class is use to create dynamic bind between class and non-action movieclip
	 */ 
	public class KBinder
	{		
		static public function Bind(instance:*,asset:*):void
		{
			
			var o:Object=KTraversal.traver(instance,KTraversal.ALL_READABLE_VARIABLES);
			for(var n:* in o)
			{				
				if(n.slice(-3)!="_EB")
				{
					continue
				}				
				try{
					if(instance[n] is IBindAbleObject)
					{
						IBindAbleObject(instance[n]).Source=asset[n.slice(0,-3)];
						//Bind(instance[n],asset[n.slice(0,-3)])
					}else{					
						instance[n]=asset[n.slice(0,-3)];
					}
				}catch(e:Error){}
			}
		}
		
		static public function Unbind(instance:*):void
		{
			
			var o:Object=KTraversal.traver(instance,KTraversal.ALL_READABLE_VARIABLES);
			for(var n:* in o)
			{				
				if(n.slice(-3)!="_EB")
				{
					continue
				}				
				try{
					if(instance[n] is IBindAbleObject)
					{
						IBindAbleObject(instance[n]).unbind();
						//Bind(instance[n],asset[n.slice(0,-3)])
					}
				}catch(e:Error){}
			}			
		}
		
	}
}