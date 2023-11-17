package com.ae.discindex.events
{
import flash.events.Event;

public class ShowWindowEvent extends Event
{
	//-------------------------------------------------------------------------
	//
	//	Constants
	//
	//-------------------------------------------------------------------------
	
	public static const SHOW_IMPORT_PREVIEW:String 	= "showImportPreview";
	public static const SHOW_MEDIA_INFO:String		= "showMediaInfo";
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	public var data:Object;
	
	public function ShowWindowEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}