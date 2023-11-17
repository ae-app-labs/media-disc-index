package com.ae.discindex.business
{
import com.ae.discindex.windows.ImportPreviewWindow;
import com.ae.discindex.windows.MediaInfoWindow;

import flash.display.DisplayObject;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.core.Application;
import mx.managers.PopUpManager;
	
/**
 * This class is used to managed to display PopUp Windows on this 
 * application. 
 */
public class WindowManager
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	/**
	 * Reference to the parent object
	 */
	private var _parentWindow:DisplayObject;
	
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	/**
	 * Constructor
	 */
	public function WindowManager()
	{
		_parentWindow = Application.application as DisplayObject;
	}
	
	public function showImportWindow(data:Object):void
	{
		if(data)
		{
			// Show a window with stuff
			var importPreview:ImportPreviewWindow = new ImportPreviewWindow();
			importPreview.data = data;
			
			PopUpManager.addPopUp(importPreview, _parentWindow, true);
			PopUpManager.centerPopUp(importPreview);
		}
	}
	
	public function showMediaInfo():void
	{
		// wait for some time to load the data
		var timer:Timer = new Timer(200, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		timer.start();
	}
	
	private function onTimerComplete(event:TimerEvent):void
	{
		Timer(event.target).removeEventListener(
			TimerEvent.TIMER_COMPLETE, onTimerComplete);
		
		var mediaInfo:MediaInfoWindow = new MediaInfoWindow();
		PopUpManager.addPopUp(mediaInfo, _parentWindow, true);
		PopUpManager.centerPopUp(mediaInfo);
	}
	
}
}