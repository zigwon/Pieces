package com.kaixin.utils
{
	/** WWW.LUNASTUDIO.CN
	*@author KAN
	*MINZOJIAN@HOTMAIL.COM
	*Jun 16, 2009 4:01:35 PM
	*/
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class KCloner
	{
		public static function clone(source:*):*
		{
		    var myBA:ByteArray = new ByteArray();
		    myBA.writeObject(source);
		    myBA.position = 0;
		    return(myBA.readObject());
		}
		public static function DOclone(source:DisplayObject):DisplayObject
		{
			var cn:String=flash.utils.getQualifiedClassName(source);			
			var c:*
			if(source.loaderInfo==null){
				c=flash.utils.getDefinitionByName(cn)
			}else{
				c=source.loaderInfo.applicationDomain.getDefinition(cn);
			}
			return new c() as DisplayObject;
		}
	}
}