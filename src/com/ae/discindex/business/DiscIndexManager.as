package com.ae.discindex.business
{
import com.ae.db.events.DBEvent;
import com.ae.db.utils.DBUtils;
import com.ae.discindex.events.DiscsIndexEvent;
import com.ae.discindex.utils.DbSchemas;
import com.ae.discindex.vo.DiscVo;
import com.ae.discindex.vo.MediaVo;
import com.ae.logger.DiskLogManager;
import com.ae.logger.ILogManager;
import com.ae.logger.LogLevel;
import com.ae.utils.Utils;

import flash.data.SQLConnection;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

import mx.collections.ArrayCollection;
	
public class DiscIndexManager extends EventDispatcher
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	[Bindable]
	public var discsColl:Array;
	[Bindable]
	public var mediaColl:Array;
	
	private var timestamp:int;
	private var dbUtils:DBUtils;
	private var logger:ILogManager;
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	
	public function DiscIndexManager(connection:SQLConnection)
	{
		discsColl = new Array();
		searchResult = new ArrayCollection();
		logger = DiskLogManager.getInstance();
		
		setConnection(connection);
		
		if(dbUtils)
		{
			dbUtils.executeQuery(DbSchemas.CREATE_DISC_TABLE);
			dbUtils.executeQuery(DbSchemas.CREATE_MEDIA_TABLE);
		}
	}
	
	public function setConnection(connection:SQLConnection):void
	{
		dbUtils = new DBUtils(connection);
	}
	
	/**
	 * Add Disc Functions :
	 */
	
	private var _discsColl:Array;
	private var _currentDiscIndex:Number;
	public function addDiscs(discsColl:Array):void
	{
		if(discsColl && discsColl is Array)
		{
			_discsColl = discsColl;
			_currentDiscIndex = 0;
		}
		
		addEventListener( "discAdded", onDiscAdded);
		addDisc( _discsColl[0] );
	}
	
	private function onDiscAdded(event:Event):void
	{
		if(++_currentDiscIndex < _discsColl.length)
		{
			addDisc( _discsColl[ _currentDiscIndex ] );
		}
		var progressEvent:DiscsIndexEvent = 
			new DiscsIndexEvent(DiscsIndexEvent.PROGRESS);
		progressEvent.totalItems 		= _discsColl.length;
		progressEvent.itemsCompleted 	= _currentDiscIndex;
		
		dispatchEvent( progressEvent );
	}
	 
	private var _discVo:DiscVo;
	private var _mediaAddedCount:Number;
	
	public function addDisc(discVo:DiscVo):void
	{
		_discVo = discVo;
		_mediaAddedCount = 0;
		
		// Convert vo into object
		var data:Object = new Object();
		data["date"] = discVo.date;
		data["name"] = discVo.name;
		
		dbUtils.addEventListener(DBEvent.ROW_INSERTED, onDiscRowAdded);
		dbUtils.insert(DbSchemas.DISC_TABLE_NAME, data);
	}
	
	/**
	 * When a disc is added, use the discId to add all the medias
	 * under that disc.
	 */
	private function onDiscRowAdded(event:DBEvent):void
	{
		dbUtils.removeEventListener(DBEvent.ROW_INSERTED, onDiscRowAdded);
		dbUtils.addEventListener(DBEvent.ROW_INSERTED, onMediaAdded);
		var lastInsertedId:Number = event.result.lastInsertRowID;
		// Add the films in the disc to the next table
		for each(var media:MediaVo in _discVo.medias)
		{
			media.discId = lastInsertedId.toString();
			var data:Object = getMediaAsObject( media); 
			dbUtils.insert(DbSchemas.MEDIA_TABLE_NAME, data);
		}
	}
	
	/**
	 * Keep Track of how many discs are added.
	 */
	private function onMediaAdded(event:DBEvent):void
	{
		if(++_mediaAddedCount == _discVo.medias.length)
		{
			dbUtils.removeEventListener(DBEvent.ROW_INSERTED, onMediaAdded);
			var message:String = 
				_discVo.medias.length + " Media added to " + _discVo.name;
			trace(message);
			logger.writeLog(LogLevel.DEBUG, message)
			
			var discAddedEvent:Event = new Event("discAdded");
			dispatchEvent( discAddedEvent);
		}
	}
	
	//---------------------------------
	// Fetch all discs
	//---------------------------------
	public function fetchAllDiscs():void
	{
		dbUtils.addEventListener(DBEvent.RESULT, onFetchAllDiscs);
		dbUtils.executeQuery( DbSchemas.FETCH_ALL_DISC_QUERY );
	}
	
	public function onFetchAllDiscs(event:DBEvent):void
	{
		dbUtils.removeEventListener(DBEvent.RESULT, onFetchAllDiscs);
		discsColl = event.result.data as Array;
	}
	
	//---------------------------------
	// Fetch Media for Disc
	//---------------------------------
	public function fetchMediaForDisc(discVo:DiscVo):void
	{
		dbUtils.addEventListener(DBEvent.RESULT, onFetchMedia);
		var query:String = DbSchemas.FETCH_MEDIA_FOR_DISC_QUERY + discVo.id;
		dbUtils.executeQuery( query);
	}
	
	public function onFetchMedia(event:DBEvent):void
	{
		dbUtils.removeEventListener(DBEvent.RESULT, onFetchMedia);
		mediaColl = event.result.data as Array;
	}
	
	//---------------------------------
	// Update a Disc
	//---------------------------------
	
	private var _mediaUpdatedCount:int;
	
	public function updateDisc(discVo:DiscVo):void
	{
		dbUtils.addEventListener(DBEvent.ROW_UPDATED, onUpdateDisc);
		_mediaUpdatedCount = 0;
		_discVo = discVo;
		timestamp = getTimer();
		
		var data:Object = getMediaAsObject(discVo.medias[0]);
		dbUtils.update(DbSchemas.MEDIA_TABLE_NAME, data);
	}
	
	public function onUpdateDisc(event:DBEvent):void
	{
		_mediaUpdatedCount++;
		if(_mediaUpdatedCount == _discVo.medias.length)
		{
			dbUtils.removeEventListener(DBEvent.ROW_UPDATED, onUpdateDisc);
			
			// Dispatch the Disc Updated Event
			var diff:int = getTimer() - timestamp;
			var message:String = "Disc Updated in " + diff + " ms! " + 
					"(" + _mediaUpdatedCount + ") items";
			trace(message);
			logger.writeLog(LogLevel.INFO, message)
			var updatedEvent:DiscsIndexEvent = 
				new DiscsIndexEvent( DiscsIndexEvent.DISC_UPDATED);
			updatedEvent.processTime = diff;
			dispatchEvent( updatedEvent );
		}
		else
		{
			var mediaVo:MediaVo = _discVo.medias[_mediaUpdatedCount];
			var data:Object = getMediaAsObject(mediaVo);
			dbUtils.update(DbSchemas.MEDIA_TABLE_NAME, data);
		}
	}
	
	//---------------------------------
	// Search the Index
	//---------------------------------
	[Bindable]
	public var searchResult:ArrayCollection;
	[Bindable]
	public var searchInfo:String;
	private var _isSearching:Boolean;
	private var _query:String;
	private var _filter:String;
	public function searchIndex(query:String, filter:String):void
	{
		if(_isSearching == false)
		{
			_isSearching = true;
			_query = query;
			_filter = filter;
			dbUtils.addEventListener(DBEvent.RESULT, onSearchResult);
			timestamp = getTimer();
			var sql:String = DbSchemas.buildSearchQuery(query, filter);
			trace(sql);
			dbUtils.executeQuery( sql );
		}
	}
	
	/**
	 * Handler function invoked when a search query turns successful.
	 */
	public function onSearchResult(event:DBEvent):void
	{
		var diff:int = getTimer() - timestamp;
		var message:String;
		
		searchResult = new ArrayCollection( event.result.data as Array );
		
		// Create a detailed info string about the search
		message = Utils.searchResultInfo( searchResult.length, _query, 
			_filter, diff);
		trace(message);
		logger.writeLog(LogLevel.INFO, message)
		dbUtils.removeEventListener(DBEvent.RESULT, onSearchResult);
		
		_isSearching = false;
		
		searchInfo = message;
	}
	
	//---------------------------------
	// Other
	//---------------------------------
	
	public function getDiscsCount():void
	{
		dbUtils.addEventListener(DBEvent.RESULT, onGetCountResult);
		dbUtils.executeQuery("SELECT * FROM " + DbSchemas.DISC_TABLE_NAME);
	}
	
	public function onGetCountResult(event:DBEvent):void
	{
		dbUtils.removeEventListener(DBEvent.RESULT, onGetCountResult);
		event.result;
	}
	
	private function getMediaAsObject(media:MediaVo):Object
	{
		var data:Object 	= new Object();
		data["id"] 			= media.id;
		data["discId"] 		= media.discId;
		data["cast"] 		= media.cast;
		data["director"] 	= media.director;
		data["genre"] 		= media.genre;
		data["imdbLink"] 	= media.imdbLink;
		data["language"] 	= media.language;
		data["releaseYear"] = media.releaseYear;
		data["title"] 		= media.title;
		return data;
	}
}
}