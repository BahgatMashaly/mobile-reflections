//
//  SqliteHandler.m
//  SMBClinical
//
//  Created by jigar shah on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SqliteHandler.h"


@implementation SqliteHandler

- (id)init {
	if ([super init]) {
		appDelegate = (MobileJabberAppDelegate*)[[UIApplication sharedApplication] delegate];
	}
	return self;
}

//
/// A Generic Method for Insert Record in any table
//
- (void)insertSingle:(NSDictionary*)records inTable:(NSString *)tblName {
    @try {
        NSArray *aryFields = [records allKeys];
        NSString *values = @"";
        NSString *fields = @"";
        for (NSString *strKey in aryFields) {
            NSString *strValue = @"";
            strValue = [[[records objectForKey:strKey] description] stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strValue length])];
            values = [NSString stringWithFormat:@"%@'%@'", values,strValue];
            values = [values stringByAppendingString:@","];
            fields = [fields stringByAppendingString: strKey];
            fields = [fields stringByAppendingString:@","];
        }
        values = [values substringToIndex:[values length]-1];
        fields = [fields substringToIndex:[fields length]-1];
	
        NSString *strQuery = [NSString stringWithFormat:@"Insert into %@ (%@) values (%@)", tblName, fields, values];
        const char *sqlStmt = [strQuery UTF8String];
        if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
            sqlite3_step(compiledStatement);
        }
        sqlite3_finalize(compiledStatement);
    }
    @catch (NSException *exc) {
        NSLog (@"%@", [exc description]);
    }
	
}

//
/// A Generic Method for Insert Multiple Records in any table
//
- (void)insertMultiple:(NSMutableArray*)aryRecords inTable:(NSString *)tblName {
	BOOL isLoop = NO;
	for (int i = 0; i < [aryRecords count]; i++) {
		NSDictionary *records = [aryRecords objectAtIndex:i];
		NSArray *aryFields = [records allKeys];
		NSString *values = @"";
		NSString *fields = @"";
		for (NSString *strKey in aryFields) {
			NSString *strValue = @"";
			strValue = [[[records objectForKey:strKey] description] stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strValue length])];
			values = [NSString stringWithFormat:@"%@'%@'", values,strValue];
			values = [values stringByAppendingString:@","];
			fields = [fields stringByAppendingString: strKey];
			fields = [fields stringByAppendingString:@","];
		}
		values = [values substringToIndex:[values length]-1];
		fields = [fields substringToIndex:[fields length]-1];
		
		NSString *strQuery = [NSString stringWithFormat:@"Insert into %@ (%@) values (%@)", tblName, fields, values];
		const char *sqlStmt = [strQuery UTF8String];
		if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
			sqlite3_step(compiledStatement);
			isLoop = YES;
		}
		sqlite3_reset(compiledStatement);		
	}
	if (isLoop) {
		sqlite3_finalize(compiledStatement);
	}
	
	
}

//
/// Delete records from table on specific condition
//
- (void)deleteAllRecordsWhere:(NSDictionary*)fields inTable:(NSString *)tblName {
	// Get All Key from Dictionary fields in array of String 
	
	NSArray *aryFields = [fields allKeys];
	
	NSString *strWherePart = @"";
	
	// Create a String after where
	
	for (NSString *strTempField in aryFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strWherePart stringByAppendingFormat:@"%@ = '%@' %@ ",strTempField, strValue];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
	
	NSString *strQuery = [NSString stringWithFormat:@"delete from %@ where %@", tblName, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		sqlite3_step(compiledStatement);		
	}
	sqlite3_finalize(compiledStatement);
}
//
/// Delete all records from table
//
- (void)deleteAllRecordsInTable:(NSString *)tblName {
	NSString *strQuery = [NSString stringWithFormat:@"delete from %@", tblName];
	const char *sqlStmt = [strQuery UTF8String];
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		sqlite3_step(compiledStatement);		
	}
	sqlite3_finalize(compiledStatement);
}
//
/// A Generic Method for select record with All Fields from any table
/// This will return a array containing NSDictionary object with fieldName as Key
//
- (NSMutableArray *)selectWholeRecordFrom:(NSString*)tblName {
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select * from %@", tblName];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
				
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}
//

// 25/8 Mohit

- (NSMutableArray *)getColumnName:(NSString*)tblName{
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select * from %@", tblName];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
								
				[aryRecords addObject:columnName];
			}		
			break;
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;

}

//
/// A Generic Method for select record with Fields specified in aryField from any table
/// This will return a array containing NSDictionary object with fieldName as Key
//
- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName {
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	
	
	NSString *strFields = @"";
	for (NSString *strTemp in aryField) {
		strFields = [strFields stringByAppendingFormat:@"%@,", strTemp];		
	}
	strFields = [strFields substringToIndex:[strFields length] - 1];
	
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select %@ from %@", strFields, tblName];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
		
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
								
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}

//
/// Use if you want to select record on any perticular condition
/// A Generic Method for select record with All Fields from any table
/// This will return a array containing NSDictionary object with fieldName as Key
/// You can pass where clause too for that we are using fields Dictionary
/// Type asks for And/Or
//
- (NSMutableArray *)selectWholeRecordFrom:(NSString*)tblName withWhere:(NSDictionary*)fields type:(NSString*)strType {
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Get All Key from Dictionary fields in array of String 
	
	NSArray *aryFields = [fields allKeys];
	
	NSString *strWherePart = @"";
	
	// Create a String after where
	
	for (NSString *strTempField in aryFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strWherePart stringByAppendingFormat:@"%@ = '%@' %@ ",strTempField, strValue, strType];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
		
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select * from %@ where %@", tblName, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
							
				
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}

// Select top x record
- (NSMutableArray *)selectTopRecordFrom:(NSString*)tblName withWhere:(NSDictionary*)fields withCount:(NSInteger)count type:(NSString*)strType {
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Get All Key from Dictionary fields in array of String 
	
	NSArray *aryFields = [fields allKeys];
	
	NSString *strWherePart = @"";
	
	// Create a String after where
	
	for (NSString *strTempField in aryFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strWherePart stringByAppendingFormat:@"%@ = '%@' %@ ",strTempField, strValue, strType];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
    
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select TOP 10 from %@ where %@",  tblName, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
                
				
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}

//
/// Use if you want to select fields on any perticular condition
/// A Generic Method for select record with Fields specified in aryField from any table
/// This will return a array containing NSDictionary object with fieldName as Key
/// You can pass where clause too for that we are using fields Dictionary
//
- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName withWhere:(NSDictionary*)fields {
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Create string for specific fields to select
	
	NSString *strFields = @"";
	for (NSString *strTemp in aryField) {
		strFields = [strFields stringByAppendingFormat:@"%@,", strTemp];		
	}
	strFields = [strFields substringToIndex:[strFields length] - 1];
	
	
	NSArray *aryWhereFields = [fields allKeys];
	
	NSString *strWherePart = @"";
	
	// Create a String after where clause in Query
	
	for (NSString *strTempField in aryWhereFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strTempField stringByAppendingFormat:@" = '%@' and ", strValue];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
	
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select %@ from %@ where %@", strFields, tblName, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
				
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}


//
/// Check If Record exist on 
//
- (BOOL)checkIfRecordExistIn:(NSString*)Table by:(NSDictionary*)record {
	BOOL isExist = NO;
	NSArray *aryKeys = [record allKeys];
	
	NSString *strWherePart = @"";
	for (NSString *strKey in aryKeys) {
		NSString *strValue = [record objectForKey:strKey];
		
		strWherePart = [strWherePart stringByAppendingFormat:@"%@ = %@ and", strValue, strKey];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	NSString *strQuery = [NSString stringWithFormat:@"Select * from %@ where %@", Table, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {			
			// Get total number of field in table
			
			isExist = YES;
			break;
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	return isExist;
}

- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName withWhereAndLike:(NSDictionary*)fields {
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Create string for specific fields to select
	
	NSString *strFields = @"";
	for (NSString *strTemp in aryField) {
		strFields = [strFields stringByAppendingFormat:@"%@,", strTemp];		
	}
	strFields = [strFields substringToIndex:[strFields length] - 1];
	
	
	NSArray *aryWhereFields = [fields allKeys];
	
	NSString *strWherePart = @"";
	
	// Create a String after where clause in Query
	
	for (NSString *strTempField in aryWhereFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strTempField stringByAppendingFormat:@" like '%@%%' and ", strValue];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
	
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Select %@ from %@ where %@", strFields, tblName, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		// Loop for each row after executing query
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			// Get total number of field in table
			
			NSInteger count = sqlite3_column_count(compiledStatement);
			NSMutableDictionary *dictRecord = [[[NSMutableDictionary alloc] init] autorelease];
			for (int i = 0; i < count; i++) {
				
				// Get Column Name at index and value for Column
				
				NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(compiledStatement, i)];
				NSString *strValue = @"";
				if (sqlite3_column_text(compiledStatement, i) != NULL) {
					strValue = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(compiledStatement, i)];
				}
				
				// Add Value in Dictionary. Dictionary With fieldname as Key for related values
				
				[dictRecord setObject:strValue forKey:columnName];
			}
			[aryRecords addObject:dictRecord];
			
		}
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}

- (NSMutableArray *)updateWholeRecordFrom:(NSString*)tblName set:(NSDictionary*)data withWhere:(NSDictionary*)fields{
	
	NSMutableArray *aryRecords = [[NSMutableArray alloc] init];
	
	// Get All Key from Dictionary fields in array of String 
	
	NSArray *aryFields = [fields allKeys];
	
	NSArray *arydata = [data allKeys];
	
	// Create a String after set
	
	NSString *strSetPart = @"";
	
	for (NSString *strTempField in arydata) {
		NSString *strTempVale = [data objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strSetPart = [strSetPart stringByAppendingFormat:@"%@ = '%@' ,  ",strTempField, strValue];
	}
	strSetPart = [strSetPart substringToIndex:[strSetPart length] - 4];
	
	
	// Create a String after where
	
	NSString *strWherePart = @"";

	for (NSString *strTempField in aryFields) {
		NSString *strTempVale = [fields objectForKey:strTempField];
		NSString *strValue = [strTempVale stringByReplacingOccurrencesOfString:@"'" withString:@"''" options:0 range:NSMakeRange(0, [strTempVale length])];
		strWherePart = [strWherePart stringByAppendingFormat:@"%@ = '%@' and ",strTempField, strValue];
	}
	strWherePart = [strWherePart substringToIndex:[strWherePart length] - 4];
	
		
	// Create Query with table name
	
	NSString *strQuery = [NSString stringWithFormat:@"Update %@ set %@ where %@", tblName,strSetPart, strWherePart];
	const char *sqlStmt = [strQuery UTF8String];
	
	// Prepare statement
	
	if (sqlite3_prepare_v2(appDelegate.database, sqlStmt, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_step(compiledStatement);
		
	
	}
	
	// Finalize compiled statement to free database from a process
	
	sqlite3_finalize(compiledStatement);
	
	NSMutableArray *aryFinal = [NSMutableArray arrayWithArray:aryRecords];
	[aryRecords release];
	return aryFinal;
}

- (void)dealloc {
	//if (compiledStatement != nil) {
//		sqlite3_finalize(compiledStatement);
//	}
	[super dealloc];
}

@end
