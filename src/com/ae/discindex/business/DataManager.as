package com.ae.discindex.business
{
import com.ae.discindex.utils.DbFiles;
import com.ae.discindex.vo.DiscVo;
import com.ae.discindex.vo.MediaVo;
import com.ae.logger.DiskLogManager;
import com.ae.logger.ILogManager;
import com.ae.logger.LogLevel;
import com.ae.utils.FileReadWrite;
import com.ae.utils.Utils;

import flash.filesystem.File;
import flash.utils.getTimer;
	
public class DataManager
{
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
	
	public function DataManager()
	{
		logger = DiskLogManager.getInstance();
	}
	
	/**
	 * Imports the data from version-1's exported csv files to
	 * a collection of Media Files.
	 */
	public function importFromCsv(sourceDir:File):Array
	{
		var timestamp:Number = getTimer();
		var file:File;
		var array:Array;
		var lastIndex:int;
		var fileData:String;
		var cleanLine:String;
		
		var discsColl:Array = new Array();
		
		logger.writeLog(LogLevel.INFO, "ImportFromCsv")
		
		// Parsing Discs
		file = sourceDir.resolvePath(DbFiles.DISCS_CSV);
		if(file.exists)
		{
			fileData = FileReadWrite.readFile(file);
			array = fileData.split("\n");
			
			// Remove the last line if it is a blank line.
			lastIndex = array.length - 1;
			if(array[lastIndex] == "")
			{
				array.pop();
			}
			
			for each(var line2:String in array)
			{
				cleanLine = Utils.replaceToken( line2, '\"', "");
				var discsInfo:Array = cleanLine.split(",");
				
				// Create a DiscVo
				var discVo:DiscVo 	= new DiscVo();
				discVo.id 			= discsInfo[0];
				discVo.name 		= Utils.replaceToken(discsInfo[1], "\\$", ",");
				discVo.date 		= discsInfo[2];
				discVo.field1		= true;
				discsColl.push( discVo );
			}
			logger.writeLog(LogLevel.INFO, discsColl.length + " Discs Found.");
		}
		else
		{
			logger.writeLog(LogLevel.ERROR, file.nativePath + " doesn't exist");
		}
		
		// Parsing Films
		file = sourceDir.resolvePath(DbFiles.MEDIA_CSV);
		if(file.exists)
		{
			// id,DiscId,Title,Language,Actors,Genre,Year
			fileData = FileReadWrite.readFile(file);
			array = fileData.split("\n");
			
			// Remove the last line if it is a blank line.
			lastIndex = array.length - 1;
			if(array[lastIndex] == "")
			{
				array.pop();
			}
			
			for each(var line:String in array)
			{
				cleanLine = Utils.replaceToken( line, '\"', "");
				var filmInfo:Array 	= cleanLine.split(","); 
				var mediaVo:MediaVo = new MediaVo();
				mediaVo.title 		= filmInfo[2];
				mediaVo.language 	= filmInfo[3];
				mediaVo.cast 		= Utils.replaceToken(String(filmInfo[5]), "\\$", ",");
				mediaVo.genre 		= Utils.replaceToken(String(filmInfo[4]), "\\$", ", ");
				mediaVo.releaseYear = filmInfo[6];
				mediaVo.director 	= "";
				
				addMediaToDisc( discsColl, mediaVo, filmInfo[1]);
			}
		}
		else 
		{
			logger.writeLog(LogLevel.ERROR, file.nativePath + " doesn't exist");
		}
		logger.writeLog(LogLevel.INFO, discsColl.length + " Discs Found.")
		var diff:int = getTimer() - timestamp;
		logger.writeLog(LogLevel.INFO, "ImportFromCsv in " + diff + " ms.");
		return discsColl;
	}
	
	private function addMediaToDisc( discsColl:Array, mediaVo:MediaVo, discId:Number):void
	{
		for each(var disc:DiscVo in discsColl)
		{
			if(disc.id == discId)
			{
				disc.medias.push( mediaVo );
				break;
			}
		}
	}

}
}