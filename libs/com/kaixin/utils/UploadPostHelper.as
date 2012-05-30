package com.kaixin.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class UploadPostHelper
	{

		public static var FileFieldName:String="file";
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * Boundary used to break up different parts of the http POST body
		 */
		private static var _boundary:String = "";

		/**
		 * Get the boundary for the post.
		 * Must be passed as part of the contentType of the UrlRequest
		 */
		public static function getBoundary():String {

			if(_boundary.length == 0) {
				for (var i:int = 0; i < 0x20; i++ ) {
					_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
				}
			} 
			//_boundary="7d8222b601ea"
			return _boundary;
		}

		/**
		 * Create post data to send in a UrlRequest
		 */
		 
		public static function singleFileData(fileName:String,byteArray:ByteArray):ByteArray
		{
			var i:int;
			var bytes:String;
			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;
			//add Filedata to postData
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="'+FileFieldName+'"; filename="';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData.writeUTFBytes(fileName);
			postData = QUOTATIONMARK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Type: application/octet-stream';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			postData.writeBytes(byteArray, 0, byteArray.length);
			postData = LINEBREAK(postData);
			return postData;
		}
		 
		public static function getSinglePostData(fileName:String, byteArray:ByteArray, parameters:Object = null):ByteArray {

			var i:int;
			var bytes:String;

			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			//add Filename to parameters
			if(parameters == null) {
				parameters = new Object();
			}
			//parameters.Filename = fileName;

			//add parameters to postData
			for(var name:String in parameters) {
				postData = BOUNDARY(postData);
				postData = LINEBREAK(postData);
				bytes = 'Content-Disposition: form-data; name="' + name + '"';
				for ( i = 0; i < bytes.length; i++ ) {
					postData.writeByte( bytes.charCodeAt(i) );
				}
				postData = LINEBREAK(postData);
				postData = LINEBREAK(postData);
				postData.writeUTFBytes(parameters[name]);
				postData = LINEBREAK(postData);
			}

			postData.writeBytes(singleFileData(fileName,byteArray));

			//add upload filed to postData
			postData = LINEBREAK(postData);
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Upload"';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Submit Query';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);

			//closing boundary
			postData = BOUNDARY(postData);
			postData = DOUBLEDASH(postData);

			return postData;
		}

		
public static function getMultiplePostData(fileNames:Array, byteArrays:Array, parameters:Object = null):ByteArray {

if(fileNames.length!=byteArrays.length)
{
throw new Error("fileNames' length is not equal the byteArrays' length");
}

			var i:int;
			var bytes:String;

			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			//add Filename to parameters
			if(parameters == null) {
				parameters = new Object();
			}
			//parameters.Filename = fileName;

			//add parameters to postData
			for(var name:String in parameters) {
				postData = BOUNDARY(postData);
				postData = LINEBREAK(postData);
				bytes = 'Content-Disposition: form-data; name="' + name + '"';
				for ( i = 0; i < bytes.length; i++ ) {
					postData.writeByte( bytes.charCodeAt(i) );
				}
				postData = LINEBREAK(postData);
				postData = LINEBREAK(postData);
				postData.writeUTFBytes(parameters[name]);
				postData = LINEBREAK(postData);
			}
			for(var fileindex:int=0;fileindex<fileNames.length;fileindex++)
			{
				postData.writeBytes(singleFileData(fileNames[fileindex],byteArrays[fileindex]));
			}
			

			//add upload filed to postData
			postData = LINEBREAK(postData);
			postData = BOUNDARY(postData);
			postData = LINEBREAK(postData);
			bytes = 'Content-Disposition: form-data; name="Upload"';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);
			postData = LINEBREAK(postData);
			bytes = 'Submit Query';
			for ( i = 0; i < bytes.length; i++ ) {
				postData.writeByte( bytes.charCodeAt(i) );
			}
			postData = LINEBREAK(postData);

			//closing boundary
			postData = BOUNDARY(postData);
			postData = DOUBLEDASH(postData);

			return postData;
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Add a boundary to the PostData with leading doubledash
		 */
		private static function BOUNDARY(p:ByteArray):ByteArray {
			var l:int = UploadPostHelper.getBoundary().length;

			p = DOUBLEDASH(p);
			for (var i:int = 0; i < l; i++ ) {
				p.writeByte( _boundary.charCodeAt( i ) );
			}
			return p;
		}

		/**
		 * Add one linebreak
		 */
		private static function LINEBREAK(p:ByteArray):ByteArray {
			p.writeShort(0x0d0a);
			return p;
		}

		/**
		 * Add quotation mark
		 */
		private static function QUOTATIONMARK(p:ByteArray):ByteArray {
			p.writeByte(0x22);
			return p;
		}

		/**
		 * Add Double Dash
		 */
		private static function DOUBLEDASH(p:ByteArray):ByteArray {
			p.writeShort(0x2d2d);
			return p;
		}
	}
}