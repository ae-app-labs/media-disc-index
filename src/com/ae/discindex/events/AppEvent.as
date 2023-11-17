package com.ae.discindex.events
{
import flash.events.Event;

/**
 * Application Event
 */
public class AppEvent extends Event
{
	public static const VIEW_CHANGED:String = "viewChanged";
	
	public var viewIndex:int;
	
	public function AppEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}