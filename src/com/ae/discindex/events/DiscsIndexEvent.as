package com.ae.discindex.events
{
import com.ae.discindex.vo.DiscVo;
import com.ae.discindex.vo.MediaVo;

import flash.events.Event;
import flash.filesystem.File;

public class DiscsIndexEvent extends Event
{
	//-------------------------------------------------------------------------
	//
	//	Constants
	//
	//-------------------------------------------------------------------------
	
	public static const ADD_DISC:String 	= "addDisc";
	public static const ADD_DISCS:String 	= "addDiscs";
	public static const CREATE_DB:String 	= "createDb";
	public static const PROGRESS:String 	= "progress";
	public static const UPDATE_DISC:String 	= "updateDisc";
	public static const DISC_UPDATED:String= "discUpdated";
	public static const FETCH_ALL_DISCS:String = "fetchAllDiscs";
	public static const FETCH_MEDIA_FOR_DISC:String = "fetchMediaForDisc";
	public static const SEARCH_INDEX:String = "searchIndex";
	public static const SEARCH_RESULT:String = "searchResult";
	
	public static const FILE_SELECTED:String= "fileSelected";	
	public static const IMPORT_FROM_CSV:String = "importFromCsv";
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	public var file:File;
	public var discVo:DiscVo;
	public var mediaVo:MediaVo;
	public var dataColl:Array;
	
	public var query:String;
	public var filterType:String;
	public var info:String;
	public var totalItems:int;
	public var itemsCompleted:int;
	public var processTime:int;
	
	//-------------------------------------------------------------------------
	//
	//	Constructor
	//
	//-------------------------------------------------------------------------
	
	public function DiscsIndexEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}