//
//  SqliteHandler.h
//  SMBClinical
//
//  Created by jigar shah on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteHandler : NSObject {
	MobileJabberAppDelegate *appDelegate;
	sqlite3_stmt *compiledStatement;
}

- (void)insertSingle:(NSDictionary*)records inTable:(NSString *)tblName;

- (void)insertMultiple:(NSMutableArray*)aryRecords inTable:(NSString *)tblName;


- (void)deleteAllRecordsInTable:(NSString *)tblName;

- (void)deleteAllRecordsWhere:(NSDictionary*)fields inTable:(NSString *)tblName;


- (NSMutableArray *)selectWholeRecordFrom:(NSString*)tblName;

- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName;



- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName withWhere:(NSDictionary*)fields;

- (BOOL)checkIfRecordExistIn:(NSString*)Table by:(NSDictionary*)record;

- (NSMutableArray *)selectRecordBySpecificFields:(NSArray*)aryField fromTable:(NSString*)tblName withWhereAndLike:(NSDictionary*)fields;

- (NSMutableArray *)getColumnName:(NSString*)tblName;

- (NSMutableArray *)updateWholeRecordFrom:(NSString*)tblName set:(NSDictionary*)data withWhere:(NSDictionary*)fields;

- (NSMutableArray *)selectWholeRecordFrom:(NSString*)tblName withWhere:(NSDictionary*)fields type:(NSString*)strType;
- (NSMutableArray *)selectTopRecordFrom:(NSString*)tblName withWhere:(NSDictionary*)fields withCount:(NSInteger)count type:(NSString*)strType;
@end
