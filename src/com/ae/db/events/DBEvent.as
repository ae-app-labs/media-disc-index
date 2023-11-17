package com.ae.db.events
{
import flash.data.SQLResult;
import flash.events.Event;

public class DBEvent extends Event
{
	public static const RESULT:String = "result";
	public static const ERROR:String  = "error";
	public static const ROW_INSERTED:String = "rowInserted";
	public static const ROW_UPDATED:String = "rowUpdated";
	
	public var data:Object;
	public var result:SQLResult;
	
	public function DBEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
	override public function clone():Event
	{
		var event:DBEvent = new DBEvent(type);
		event.data = data;
		event.result = result;
		return event;
	}
	
}
}