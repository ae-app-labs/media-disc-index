package com.ae.db.utils
{

import com.ae.db.events.DBEvent;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.events.EventDispatcher;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;

public class DBUtils extends EventDispatcher
{
	private var _connection:SQLConnection;
	
	public function DBUtils(connection:SQLConnection = null)
	{
		_connection = connection;
	}
	
	public function insert(tableName:String, data:Object):void
	{
		var fields:Array = new Array();
		var statement:SQLStatement = getStatement();
		statement.addEventListener(SQLEvent.RESULT, onInsertResult);
		statement.addEventListener(SQLErrorEvent.ERROR, onQueryError);
		
		for(var field:String in data)
		{
			fields.push(field);
			statement.parameters[":" + field] = data[field];
		}
		
		var sqlFields:String = fields.join(", ");
		var sqlValues:String = ":" + fields.join(", :");
		
		statement.text = "INSERT INTO " + tableName + " ( " + sqlFields + " ) "
			+ " VALUES (" + sqlValues + " )";
		statement.execute();
	}
	
	private function onInsertResult(event:SQLEvent):void
	{
		var result:SQLResult = event.currentTarget.getResult();
		var resultEvent:DBEvent = new DBEvent(DBEvent.ROW_INSERTED);
		resultEvent.result = result;
		
		dispatchEvent(resultEvent);
	}
	
	public function update(tableName:String, data:Object, idColumn:String = "id"):void
	{
		var updateCommand:String = "";
		var idCommand:String = "";
		var statement:SQLStatement = getStatement();
		statement.addEventListener(SQLEvent.RESULT, onUpdateResult);
		statement.addEventListener(SQLErrorEvent.ERROR, onQueryError);
		
		for(var field:String in data)
		{
			if(field != idColumn)
			{
				updateCommand += field + " = " + ":" + field + ", ";
			}
			else
			{
				idCommand = field + " = " + ":" + field;
			}
			statement.parameters[":" + field] = data[field];
		}
		updateCommand = updateCommand.substr(0, updateCommand.length - 2);
		statement.text = "UPDATE " + tableName + " SET " + updateCommand + 
			" WHERE " + idCommand ;
		
		statement.execute();
	}
	
	private function onUpdateResult(event:SQLEvent):void
	{
		var result:SQLResult = event.currentTarget.getResult();
		var resultEvent:DBEvent = new DBEvent(DBEvent.ROW_UPDATED);
		resultEvent.result = result;
		
		dispatchEvent(resultEvent);
	}
	
	public function executeQuery(sql:String):void
	{
		var statement:SQLStatement = getStatement();
		statement.text = sql;
		statement.addEventListener(SQLEvent.RESULT, onExecuteResult);
		statement.execute();
	}
	
	private function onExecuteResult(event:SQLEvent):void
	{
		var result:SQLResult = event.currentTarget.getResult();
		var dbEvent:DBEvent = new DBEvent(DBEvent.RESULT);
		dbEvent.result = result;

		dispatchEvent(dbEvent);
	}
	
	private function onQueryError(event:SQLErrorEvent):void
	{
		trace(event.error);
	}
	
	private function getStatement():SQLStatement
	{
		var statement:SQLStatement = new SQLStatement();
		statement.sqlConnection = _connection;
		return statement;
	}

}
}