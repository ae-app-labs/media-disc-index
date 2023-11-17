package com.ae.discindex.business
{
import com.ae.discindex.events.DataBaseEvent;
import com.ae.discindex.utils.DbFiles;
import com.ae.logger.DiskLogManager;
import com.ae.logger.ILogManager;
import com.ae.logger.LogLevel;

import flash.data.SQLConnection;
import flash.data.SQLMode;
import flash.events.EventDispatcher;
import flash.filesystem.File;

/**
 * This class manages the Database file and connection to it.
 */
public class DatabaseManager extends EventDispatcher
{
	//-------------------------------------------------------------------------
	//
	//	Constants
	//
	//-------------------------------------------------------------------------
	
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var _dbFile:File;
	private var _defaultDbFile:File;
	private var logger:ILogManager;
	private var connection:SQLConnection;
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function DatabaseManager()
	{
		_defaultDbFile = 
			File.applicationStorageDirectory.resolvePath(DbFiles.DB_FILENAME);
		logger = DiskLogManager.getInstance();
		
		connection = new SQLConnection();
	}
	
	/**
	 * Opens a connection to the database
	 */
	public function connect(dbFile:File = null):SQLConnection
	{
		if(dbFile == null)
		{
			dbFile = _defaultDbFile;
		}
		_dbFile = dbFile;
		if(connection && connection.connected)
		{
			connection.close();
		}
		logger.writeLog(LogLevel.INFO, "Connected to " + _dbFile.nativePath);
		connection.open(_dbFile, SQLMode.CREATE);
		
		return connection;
	}
	
	/**
	 * Closes the Database
	 */
	public function disconnect():void
	{
		logger.writeLog(LogLevel.INFO, "Disconnecting " + _dbFile.nativePath);
		connection.close();
	}
	
	/**
	 * Returns the current connection.
	 */
	public function getConnection():SQLConnection
	{
		return connection;
	}
	
	/**
	 * Copies the database to some other location
	 */
	public function copyDatabase(destination:File):void
	{
		var destinationDb:File = destination.resolvePath(DbFiles.DB_FILENAME);
		_dbFile.copyTo(destinationDb, true);
		logger.writeLog(LogLevel.INFO, "DB Copied to " + destinationDb.nativePath);
	}
	
	/**
	 * This method replaces the current database with a new db file
	 * and creates a backup of the old file.
	 */
	public function replaceDatabase(newDbFile:File):void
	{
		disconnect();
		// Create backup
		var dbBackup:File = 
			_dbFile.parent.resolvePath( DbFiles.DB_FILENAME + ".old" );
		_dbFile.copyTo(dbBackup, true);
		
		logger.writeLog(LogLevel.DEBUG, "Old Db " + _dbFile.nativePath);
		logger.writeLog(LogLevel.DEBUG, "Old Db backup " + dbBackup.nativePath);
		logger.writeLog(LogLevel.DEBUG, "New Db " + newDbFile.nativePath);
		
		// Copy the new file
		newDbFile.copyTo(_dbFile, true);
		
		logger.writeLog(LogLevel.INFO, "Access new database.");
		
		// Open connection to the new file
		connect(_dbFile);
		
		var dbOpenedEvent:DataBaseEvent = 
			new DataBaseEvent(DataBaseEvent.DB_OPENED);
		dispatchEvent( dbOpenedEvent);
	}

}
}