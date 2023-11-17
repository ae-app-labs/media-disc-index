package com.ae.discindex.utils
{
	import com.ae.utils.Utils;
	
public class DbSchemas
{
	public static const DISC_TABLE_NAME:String = "disc";
	
	public static const MEDIA_TABLE_NAME:String = "media";
	/**
	 * Specifies the Schema for Discs Table.
	 */
	public static const CREATE_DISC_TABLE:String = 
		"CREATE TABLE IF NOT EXISTS " + DISC_TABLE_NAME + " (" + 
		"id INTEGER PRIMARY KEY AUTOINCREMENT," + 
		"name TEXT," + 
		"date TEXT" + 
		")";
		
	/**
	 * Specifies the Schema for Media Table.
	 */
	public static const CREATE_MEDIA_TABLE:String = 
		"CREATE TABLE IF NOT EXISTS " + MEDIA_TABLE_NAME + " (" + 
		"id INTEGER PRIMARY KEY AUTOINCREMENT," +
		"discId INTEGER," +  
		"title TEXT," + 
		"language TEXT," + 
		"genre TEXT," + 
		"releaseYear TEXT," + 
		"cast TEXT," + 
		"director TEXT," + 
		"imdbLink TEXT" + 
		")";
	
	public static const FETCH_ALL_DISC_QUERY:String =
		"SELECT * FROM " + DISC_TABLE_NAME;
	
	public static const FETCH_MEDIA_FOR_DISC_QUERY:String = 
		"SELECT * FROM " + MEDIA_TABLE_NAME + " WHERE discId = ";
		
	public static function buildSearchQuery(query:String, filter:String):String
	{
		// select d.name, d.date, m.title, m.cast, m.director, m.releaseYear, m.genre, m.language from disc d inner join media m where (m.discid = d.id) AND ( m.title LIKE "%da%");
		var searchString:String = "SELECT d.name, d.date, m.title, m.cast, m.director, m.releaseYear, m.genre, m.language " + 
				" FROM " + DISC_TABLE_NAME + " d " + 
				" INNER JOIN " + MEDIA_TABLE_NAME + " m " + 
				" WHERE (m.discId = d.id)" + 
				" AND" + 
				"(";
		
		// Santitize the query  
		query = Utils.replaceToken(query, "\"", " ");
		
		// Build filterString
		var filterString:String = "";
		if(filter == SearchFilters.ALL || filter == SearchFilters.TITLE)
		{
			filterString += " m.title LIKE \"%" + query + "%\" OR";
		}
		if(filter == SearchFilters.ALL || filter == SearchFilters.CAST)
		{
			filterString += " m.cast LIKE \"%" + query + "%\" OR";
		}
		if(filter == SearchFilters.ALL || filter == SearchFilters.DIRECTOR)
		{
			filterString += " m.director LIKE \"%" + query + "%\" OR";
		}
		if(filter == SearchFilters.ALL || filter == SearchFilters.GENRE)
		{
			filterString += " m.genre LIKE \"%" + query + "%\" OR";
		}
		filterString = filterString.substr(0, filterString.length - 2);
		
		searchString += filterString + ") "
		
		return searchString;
	}
}
}