package com.ae.utils
{
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/**
 * FileReadWrite is a utility class for performing read and write
 * to and from DiskFiles
 * Version 1.3
 */
public class FileReadWrite
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static const xmlHeader:String = 
		"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	
	/**
     * This function can be used to write to an external file, optionally with 
     * XML header prepended
     * @params
     * 	file:File object with the path to write
     * 	fileContents : The contents to be written
     * 	includeXmlHeader : Specify whether the function should add XML Header 
     * 		while writing the file.
     * @returns true or false based on whether file write was successful or not
     */		
	public static function writeToFile(file:File, fileContents:String,
		includeXmlHeader:Boolean=false):Boolean
	{
		try
		{
			if(includeXmlHeader)
				fileContents = xmlHeader + fileContents;
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(fileContents);
		}
		catch(error:Error)
		{
			trace(" writeToFile():Error " + error.message);
			return false;
		}
		finally
		{
			fileStream.close();
		}
		return true;
	}
	
	/**
	 * This function writes data to a bindary file.
	 * @params
	 * 	file: File object to write to
	 * 	fileContents: A byte array of data to be written
	 * 
	 * @returns: Boolean value indicating success or failure
	 */
	public static function writeToBinaryFile(file:File, fileContents:ByteArray):Boolean
	{
		try
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(fileContents);
		}
		catch(error:Error)
		{
			trace(" writeToFile():Error " + error.message);
			return false;
		}
		finally
		{
			fileStream.close();
		}
		return true;
	}
	
	/**
	 * Reads the data from the file as a ByteArray.
	 * @param offset specifies the position at which data read should begin
	 * @param length specifies the number of bytes to read.
	 * 		value of 0 reads all available data to be read.
	 */
	public static function readAsByteArray(file:File, offset:uint = 0, length:uint = 0):ByteArray
	{
		var bytes:ByteArray = new ByteArray();
		try
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(bytes, offset, length);
		}
		catch(error:Error)
		{
			trace(" readAsByteArray():Error " + error.message);
			return null;
		}
		finally
		{
			fileStream.close();
		}
		return bytes;
	}
	
	/**
	 * Write an Object to the file
	 */
	public static function writeObject(file:File, object:Object):Boolean
	{
		try
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(object);
		}
		catch(error:Error)
		{
			trace(" writeObject():Error " + error.message);
			return false;
		}
		finally
		{
			fileStream.close();
		}
		return true;
	}
	
	/**
	 * Read an Object from the file
	 */
	public static function readObject(file:File):Object
	{
		var object:Object;
		try
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.READ);
			object = fileStream.readObject();
		}
		catch(error:Error)
		{
			trace(" readObject():Error " + error.message);
		}
		finally
		{
			
			fileStream.close();
		}
		return object;
	}
	
	public static function readFile(file:File):String
	{
		var readData:String = "";
		if(file.exists)
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.READ);
			
			readData = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
		}
		return readData;
	}
	
	
	/**
	 * readXMLFile function can be used to read an XML file
	 * @file : File object of the file file to be read
	 */
	public static function readXMLFile(file:File):XML
	{
		var xmlFile:XML = null;
		if(file.exists)
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fault, false, 0, true);
			fileStream.open(file, FileMode.READ);
			
			xmlFile = 
				new XML(fileStream.readUTFBytes( fileStream.bytesAvailable ) );
			fileStream.close();
		}
		return xmlFile;
	}
    
    /**
     * Function that is invoked on an IO Error that may occur on 
     * a FileStream object
     */      
	private static function fault(error:IOErrorEvent):void
	{
       	trace("FileReadWrite.fault : " + error.toString());
	}

}
}