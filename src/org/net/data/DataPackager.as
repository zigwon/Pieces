package org.net.data
{
	import flash.utils.ByteArray;
	import org.net.data.TypeData;
	import org.net.rpc.RpcError;
	
	public class DataPackager
	{
		private var _data:ByteArray
		
		public function DataPackager(data:ByteArray=null)
		{
			if(data!=null)this._data=data;
		}
		
		
		public function set Data(d:ByteArray):void
		{
			this._data=d;
		}
		
		/**write utf string*/
		public function writeUTFString(str:String=""):void
		{
			this._data.writeByte(DataFormat.TYPE_STRING);			
			this._data.writeUTF(str);			
		}
		
		
		/**read utf string*/
		public function readUTFString(withTag:Boolean=false):String
		{
			if(withTag){this._data.readByte();}	
			return this._data.readUTF();
		}
		
		
		public function writeArray(a:*):void
		{
			this._data.writeByte(DataFormat.TYPE_ARRAY);
			this._data.writeUnsignedInt(a.length);
			for(var i:uint=0;i<a.length;i++)
			{
				writeVars(a[i]);
			}
		}
		public function readArray(withTag:Boolean=false):Array
		{
			if(withTag){this._data.readByte();}
			var temparray2:Array=[];
			var l:uint=this._data.readUnsignedInt();
			for(var i:int=0;i<l;i++)
			{
				temparray2.push(readVars());
			}
			return temparray2;
		}
		/**write uint*/
		public function writeUint(n:uint=0):void
		{
			this._data.writeByte(DataFormat.TYPE_UINT);
			this._data.writeUnsignedInt(n);
		}
		
		/**read uint*/
		public function readUint():uint
		{
			return this._data.readUnsignedInt();
		}	
		
		/**write int*/
		public function writeInt(n:int=0):void
		{
			this._data.writeByte(DataFormat.TYPE_INT);
			this._data.writeInt(n);
		}
		
		/**read int*/
		public function readInt():int
		{
			return this._data.readInt();
		}
		
		/**write double*/
		public function writeNumber(n:Number=0):void
		{
			this._data.writeByte(DataFormat.TYPE_NUMBER);
			this._data.writeDouble(n);
		}
		/**read double*/
		public function readNumber():Number
		{
			return this._data.readDouble();
		}
		
		/**write binary*/
		public function writeBinary(b:ByteArray):void
		{
			b.position=0;
			b.compress();
			this._data.writeByte(DataFormat.TYPE_BINARY);
			this._data.writeUnsignedInt(b.length);
			this._data.writeBytes(b);	
		}
		/**read binary*/
		public function readBinary(withTag:Boolean=false):ByteArray
		{	
			if(withTag){this._data.readByte();}
			var rb:ByteArray=new ByteArray();			
			var l:uint=this._data.readUnsignedInt();	
			if(l!=0) this._data.readBytes(rb,0,l);		
			rb.position=0;
			rb.uncompress();
			return rb;
		}
		public function writeObject(obj:Object):void
		{
			var n:uint=0 
			for(var o:* in obj)n++;
			this._data.writeByte(DataFormat.TYPE_OBJECT);
			this._data.writeUnsignedInt(n);
			for(o in obj)
			{
				writeString(o);
				writeVars(obj[o]);
			}
		}
		public function readObject(withTag:Boolean=false):Object
		{
			if(withTag){this._data.readByte();}
			var tempobj:Object={};
			var l:uint=this._data.readUnsignedInt();
			for(var i:int=0;i<l;i++)
			{
				tempobj[readString()]=readVars();						
			}
			return tempobj;
		}
		
		/**write string*/
		public function writeString(str:String=""):void
		{
			var tmparray:ByteArray=new ByteArray();
			tmparray.writeUTFBytes(str);
			this._data.writeByte(DataFormat.TYPE_STRING);this._data.writeUnsignedInt(tmparray.length);this._data.writeUTFBytes(str);		
		}
		/**read string*/
		public function readString(withTag:Boolean=false):String
		{			
			if(withTag){this._data.readByte();}
			var l:uint=this._data.readUnsignedInt();
			return this._data.readUTFBytes(l);
		}
		
		public function writeError(errObj:RpcError):void
		{
			var n:uint=0 
			//for(var o:* in errObj)n++;
			this._data.writeByte(DataFormat.TYPE_ERROR);
			//this._data.writeUnsignedInt(n);
			//for(o in errObj)
			//{
			//	writeString(o);
			//	writeVars(errObj[o]);
			//}
			writeInt(errObj.errorID)
			writeUTFString(errObj.message)
		}
		
		public function readError(withTag:Boolean=false):RpcError
		{
			if(withTag){this._data.readByte();}
			var tempobj:RpcError=new RpcError(readInt(),readUTFString());
			//var l:uint=this._data.readUnsignedInt();
			//for(var i:int=0;i<l;i++)
			//{
			//tempobj.errorID=readInt();						
			//tempobj.message=readUTFString();
			//}
			return tempobj;
		}
		
		public function writeVars(v:*):void
		{
			if(v is TypeData)
			{
				var td:TypeData = v as TypeData;
				switch(td.Type)
				{
					case DataFormat.TYPE_UINT:					
						return this.writeUint(uint(td.Value));					
					case DataFormat.TYPE_INT:					
						return this.writeInt(int(td.Value)); 					
					case DataFormat.TYPE_NUMBER:					
						return this.writeNumber(Number(td.Value));			
					case DataFormat.TYPE_STRING:					
						return this.writeUTFString(String(td.Value));					
					case DataFormat.TYPE_BINARY:					
						return this.writeBinary(ByteArray(td.Value));					
					case DataFormat.TYPE_ARRAY:
						return this.writeArray(td.Value);
					case DataFormat.TYPE_OBJECT:
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
		}
		
		
		public function readVars():*
		{
			var type:int=this._data.readByte()
			switch(type)
			{
				case DataFormat.TYPE_UINT:					
					return this.readUint();					
				case DataFormat.TYPE_INT:					
					return this.readInt(); 					
				case DataFormat.TYPE_NUMBER:					
					return this.readNumber(); 					
				case DataFormat.TYPE_STRING:					
					return this.readUTFString();					
				case DataFormat.TYPE_BINARY:					
					return this.readBinary();					
				case DataFormat.TYPE_ARRAY:
					return this.readArray();
				case DataFormat.TYPE_OBJECT:
					return this.readObject();
				case DataFormat.TYPE_ERROR:
					return this.readError();			
			}
		}
	}
}