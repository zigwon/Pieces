package com.kaixin.data
{
	import com.kaixin.net.rpc.KRPCError;
	import com.kaixin.utils.KCloner;
	
	import flash.utils.ByteArray;
	
	/**WWW.LUNASTUDIO.CN
	*KAN
	*MINZOJIAN@HOTMAIL.COM
	*2009-6-8 ����03:54:29
	*/
	
	public class KDataPackager
	{
		private var _data:ByteArray
		public var prevPosition:uint=0;
		public var recordPrevPos:Boolean=false;
		public static var BINARY_COMPRESS:Boolean=true;
		
		public function KDataPackager(data:ByteArray=null)
		{
			if(data!=null)this._data=data;
			this.prevPosition=0;
		}
		public function set Data(d:ByteArray):void
		{
			this._data=d;
			reset();
		}
		public function reset():void
		{
			this.prevPosition=this._data.position=0;
		}
		
		/**write int*/
		public function writeInt(n:int=0):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			this._data.writeByte(KDataFormat.TYPE_INT);
			this._data.writeInt(n);
		}
		/**read int*/
		public function readInt():int
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			return this._data.readInt();
		}
		/**write uint*/
		public function writeUint(n:uint=0):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			this._data.writeByte(KDataFormat.TYPE_UINT);
			this._data.writeUnsignedInt(n);
		}
		/**read uint*/
		public function readUint():uint
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			return this._data.readUnsignedInt();
		}		
		/**write double*/
		public function writeNumber(n:Number=0):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			this._data.writeByte(KDataFormat.TYPE_NUMBER);
			this._data.writeDouble(n);
		}
		/**read double*/
		public function readNumber():Number
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			return this._data.readDouble();
		}
		/**write string*/
		public function writeString(str:String=""):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			var tmparray:ByteArray=new ByteArray();
			tmparray.writeUTFBytes(str);
			this._data.writeByte(KDataFormat.TYPE_STRING);this._data.writeUnsignedInt(tmparray.length);this._data.writeUTFBytes(str);		
		}
		/**read string*/
		public function readString(withTag:Boolean=false):String
		{			
			if(recordPrevPos)this.prevPosition=this._data.position;
			if(withTag){this._data.readByte();}
			var l:uint=this._data.readUnsignedInt();
			return this._data.readUTFBytes(l);
		}
		/**write utf string*/
		public function writeUTFString(str:String=""):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			this._data.writeByte(KDataFormat.TYPE_STRING);			
			this._data.writeUTF(str);			
		}
		/**read utf string*/
		public function readUTFString(withTag:Boolean=false):String
		{
			if(recordPrevPos)this.prevPosition=this._data.position;	
			if(withTag){this._data.readByte();}		
			return this._data.readUTF();
		}
		/**write binary*/
		public function writeBinary(b:ByteArray):void
		{
			b=KCloner.clone(b);
			if(recordPrevPos)this.prevPosition=this._data.position;
			b.position=0;	
			if(BINARY_COMPRESS)b.compress();
			this._data.writeByte(KDataFormat.TYPE_BINARY);
			this._data.writeUnsignedInt(b.length);
			this._data.writeBytes(b);	
		}
		/**read binary*/
		public function readBinary(withTag:Boolean=false):ByteArray
		{	if(recordPrevPos)this.prevPosition=this._data.position;
			if(withTag){this._data.readByte();}
			var rb:ByteArray=new ByteArray();			
			var l:uint=this._data.readUnsignedInt();	
			if(l!=0) this._data.readBytes(rb,0,l);		
			rb.position=0;
			if(BINARY_COMPRESS)rb.uncompress();
			return rb;
		}
		
		
		public function writeArray(a:*):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			this._data.writeByte(KDataFormat.TYPE_ARRAY);this._data.writeUnsignedInt(a.length);
			for(var i:uint=0;i<a.length;i++)
			{
				writeVars(a[i]);
			}
		}
		public function readArray(withTag:Boolean=false):Array
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			if(withTag){this._data.readByte();}
			var temparray2:Array=[];
			var l:uint=this._data.readUnsignedInt();
			for(var i:int=0;i<l;i++)
			{
				temparray2.push(readVars());
			}
			return temparray2;
		}
		
		public function writeObject(obj:Object):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			var n:uint=0 
			for(var o:* in obj)n++;
			this._data.writeByte(KDataFormat.TYPE_OBJECT);
			this._data.writeUnsignedInt(n);
			for(o in obj)
			{
				writeString(o);
				writeVars(obj[o]);
			}
		}
		public function readObject(withTag:Boolean=false):Object
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			if(withTag){this._data.readByte();}
			var tempobj:Object={};
			var l:uint=this._data.readUnsignedInt();
			for(var i:int=0;i<l;i++)
			{
				tempobj[readString()]=readVars();						
			}
			return tempobj;
		}
		public function writeError(errObj:KRPCError):void
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			var n:uint=0 
			//for(var o:* in errObj)n++;
			this._data.writeByte(KDataFormat.TYPE_ERROR);
			//this._data.writeUnsignedInt(n);
			//for(o in errObj)
			//{
			//	writeString(o);
			//	writeVars(errObj[o]);
			//}
			writeInt(errObj.errorID)
			writeUTFString(errObj.message)
			
		}
		public function readError(withTag:Boolean=false):KRPCError
		{
			if(recordPrevPos)this.prevPosition=this._data.position;
			if(withTag){this._data.readByte();}
			var tempobj:KRPCError=new KRPCError(readInt(),readUTFString());
			//var l:uint=this._data.readUnsignedInt();
			//for(var i:int=0;i<l;i++)
			//{
				//tempobj.errorID=readInt();						
				//tempobj.message=readUTFString();
			//}
			return tempobj;
		}
		
		/**process by function
		 * use function to preocess(change) the _data
		 * */
		public function processByFunction(func:Function):void
		{			
			if(recordPrevPos)this.prevPosition=this._data.position;
			func.apply(null,[this]);			
		}
		public function writeVars(v:*):void
		{
			var tmpRPP:Boolean=recordPrevPos;
			if(recordPrevPos)this.prevPosition=this._data.position;
			recordPrevPos=false;
			if(v is KTypeData)
			{
				var td:KTypeData = v as KTypeData;
				switch(td.Type)
				{
					case KDataFormat.TYPE_UINT:					
						return this.writeUint(uint(td.Value));					
					case KDataFormat.TYPE_INT:					
						return this.writeInt(int(td.Value)); 					
					case KDataFormat.TYPE_NUMBER:					
						return this.writeNumber(Number(td.Value)); 					
					case KDataFormat.TYPE_STRING:					
						return this.writeUTFString(String(td.Value));					
					case KDataFormat.TYPE_BINARY:					
						return this.writeBinary(ByteArray(td.Value));					
					case KDataFormat.TYPE_ARRAY:
						return this.writeArray(td.Value);
					case KDataFormat.TYPE_OBJECT:
						return this.writeObject(Object(td.Value));			
				}
			}
			else
			{
				if(v is uint){this.writeUint(uint(v));}
				else if(v is int){this.writeInt(int(v));}
				else if(v is Number){this.writeNumber(Number(v));}
				else if(v is String){this.writeUTFString(String(v));}
				else if(v is ByteArray){this.writeBinary(ByteArray(v));}
				else if(v is Array){this.writeArray(v);}
				else if(v is Object){this.writeObject(Object(v));}
			}
			recordPrevPos=tmpRPP;
		}
		public function readVars():*
		{
			var tmpRPP:Boolean=recordPrevPos;
			if(recordPrevPos)this.prevPosition=this._data.position;
			recordPrevPos=false;
			var type:int=this._data.readByte()
			switch(type)
			{
				case KDataFormat.TYPE_UINT:					
					return this.readUint();					
				case KDataFormat.TYPE_INT:					
					return this.readInt(); 					
				case KDataFormat.TYPE_NUMBER:					
					return this.readNumber(); 					
				case KDataFormat.TYPE_STRING:					
					return this.readUTFString();					
				case KDataFormat.TYPE_BINARY:					
					return this.readBinary();					
				case KDataFormat.TYPE_ARRAY:
					return this.readArray();
				case KDataFormat.TYPE_OBJECT:
					return this.readObject();
				case KDataFormat.TYPE_ERROR:
					return this.readError();			
			}
			recordPrevPos=tmpRPP;			
		}
		
		
	}
}