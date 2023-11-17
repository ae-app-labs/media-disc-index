package com.ae.utils
{
	import mx.utils.StringUtil;
	
public class Utils
{
	private static var _levels:Array = 
	['bytes', 'Kb', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

	/**
	 * This method returns a string based on a file size passed as
	 * parameter to it.
	 */
	public static function bytesToString(bytes:Number):String
	{
	    var index:uint = Math.floor(Math.log(bytes)/Math.log(1024));
	    return (bytes/Math.pow(1024, index)).toFixed(2) + " " + _levels[index];
	}
	
	/**
	 * Replace a token in the source string with anorther.
	 */
	public static function replaceToken(source:String, oldToken:String, newToken:String):String
	{
		var re:RegExp = new RegExp(oldToken, "g");
		return source.replace(re, newToken);
	}
	
	/**
	 * Returns a formatted string with info about a search
	 */
	public static function searchResultInfo(resultCount:int, query:String, 
		filter:String, time:int):String
	{
		var str:String = "{0} result(s) for '{1}' with filter '{2}' in {3} ms!";
		return StringUtil.substitute(str, resultCount, query, filter, time);  
	}

}
}