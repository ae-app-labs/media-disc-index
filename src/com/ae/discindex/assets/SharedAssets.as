package com.ae.discindex.assets
{
public class SharedAssets
{
	
	/**
	 * Icon / image paths
	 */
	 
	public static const acceptImage:String = "/assets/images/accept_16.png";
	public static const deleteImage:String = "/assets/images/delete_16.png";
	public static const searchIcon:String = "/assets/images/search.png";
	public static const importIcon:String = "/assets/images/import.png";
	public static const infoIcon:String = "/assets/images/info.png";
	public static const settingsIcon:String = "/assets/images/settings.png";
	public static const editIcon:String = "/assets/images/edit.png";
	public static const addIcon:String = "/assets/images/add.png";
	public static const closeIcon:String = "/assets/images/close_24.png";
	
	/**
	 * Embeds
	 */
	 
	[Embed(source="/assets/images/select_all.png")]
	public static const selectAllIcon:Class;
	[Embed(source="/assets/images/select_none.png")]
	public static const selectNoneIcon:Class;
	[Embed(source="/assets/images/refresh_icon.png")]
	public static const refreshIcon:Class;

}
}