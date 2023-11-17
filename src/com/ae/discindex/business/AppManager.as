package com.ae.discindex.business
{
import com.ae.discindex.utils.DbFiles;
import com.ae.logger.DiskLogManager;
import com.ae.logger.ILogManager;
import com.ae.logger.LogLevel;
import com.ae.logger.LogModes;

import flash.events.EventDispatcher;
import flash.filesystem.File;
	
public class AppManager extends EventDispatcher
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
	
	private var logger:ILogManager;
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	public function AppManager()
	{
		
	}
	
	public function init():void
	{
		// initialize the logger
		logger = DiskLogManager.getInstance();
		logger.loggingMode 	= LogModes.OVERWRITE;
		logger.loggingLevel = LogLevel.INFO;
		logger.bufferSize	= 32;
		
		// Check if the db file is present in the system
		var systemDbFile:File = File.applicationStorageDirectory.resolvePath( 
			DbFiles.DB_FILENAME);
		var installDbFile:File = File.applicationDirectory.resolvePath(
			"assets/data/" + DbFiles.DB_FILENAME);
			
		if(systemDbFile.exists == false)
		{
			// Need to copy or create the db file
			if(installDbFile.exists)
			{
				installDbFile.copyTo(systemDbFile);
			}
		}
	}
	
	public function exit():void
	{
		logger.writeLog(LogLevel.INFO, "Exiting");
		logger.flush();
	}

}
}