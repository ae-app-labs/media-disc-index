package com.ae.discindex.business
{
	import com.ae.discindex.vo.SettingsVo;
	import com.ae.logger.DiskLogManager;
	import com.ae.logger.ILogManager;
	import com.ae.logger.LogLevel;
	import com.ae.utils.FileReadWrite;
	
	import flash.filesystem.File;
	
	import mx.core.Application;
	
/**
 * This class manages the settings for the application.
 */
public class SettingsManager
{
	//-------------------------------------------------------------------------
	//
	//	Constants
	//
	//-------------------------------------------------------------------------
	
	private static const SETTINGS_FILE:String = "discsIndex.settings"; 
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var settingsFile:File;
	private var logger:ILogManager;
	private var settingsVo:SettingsVo;
	
	//-------------------------------------------------------------------------
	//
	//	Methods
	//
	//-------------------------------------------------------------------------
	
	public function SettingsManager()
	{
		logger = DiskLogManager.getInstance();
		settingsFile = 
			File.applicationStorageDirectory.resolvePath(SETTINGS_FILE);
	}
	
	public function readSettings():void
	{
		logger.writeLog(LogLevel.INFO, "readSettings")
		settingsVo = FileReadWrite.readObject( settingsFile ) as SettingsVo;
		if(settingsVo == null)
		{
			settingsVo = new SettingsVo();
			settingsVo.viewIndex = 0;
			logger.writeLog(LogLevel.DEBUG, "settings empty. First run!")
		}
		else
		{
			Application.application.height = settingsVo.height;
			Application.application.width = settingsVo.width;
		}
	}
	
	public function saveSettings():void
	{
		logger.writeLog(LogLevel.INFO, "saveSettings")
		settingsVo.height = Application.application.height;
		settingsVo.width  = Application.application.width;
		FileReadWrite.writeObject(settingsFile, settingsVo);
	}
	
	public function getSettings():SettingsVo
	{
		return settingsVo;
	}
	
	public function get lastBrowsedPath():String
	{
		return settingsVo.lastBrowsedPath;
	}
	
	public function setLastBrowsedPath(value:File):void
	{
		settingsVo.lastBrowsedPath = value.nativePath;
	}
	
	public function get viewIndex():int
	{
		return settingsVo.viewIndex;
	}
	
	public function setViewIndex(value:int):void
	{
		settingsVo.viewIndex = value;
	}

}
}