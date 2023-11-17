package com.ae.discindex.events
{
import flash.events.Event;
import flash.filesystem.File;

public class DataBaseEvent extends Event
{
	//-------------------------------------------------------------------------
	//
	//	Constants
	//
	//-------------------------------------------------------------------------
	
	public static const DB_OPENED:String = "dbOpened";
	public static const DB_CLOSED:String = "dbClosed";
	public static const EXPORT_DB_FILE:String = "exportDbFile";
	public static const IMPORT_DB_FILE:String = "importDbFile";
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	public var file:File;
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	
	public function DataBaseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}