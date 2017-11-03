//
//  CYUrlDBManager.m
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/11/2.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import "CYUrlDBManager.h"

#import "FMDB.h"

static NSString* kCYGUrlDBName = @"CYG_Url";
static NSString* kCYGUrlTableName = @"Url";

@interface CYUrlDBManager ()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation CYUrlDBManager

+ (CYUrlDBManager *)sharedManager {
    
    static CYUrlDBManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CYUrlDBManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self createDB];
        [self createTable];
    }
    return self;
}

- (void)createDB {
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databasePath]];
    [_dbQueue openFlags];
}

- (void)createTable {
    
    __block NSString* sql = [self getTableSql];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        if (![db tableExists:kCYGUrlTableName]) {
            NSError* error = nil;
            [db executeUpdate:sql withErrorAndBindings:&error];
            if (error) {
                
            }
        }
    }];
}

- (NSString *)getTableSql {
    
    NSString* uid = [NSString stringWithFormat:@"%@ TEXT unique not null", CYUrlModelReqUid];
    NSString* statusCode = [NSString stringWithFormat:@"%@ INTEGER", CYUrlModelStatusCode];
    NSString* mime = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelMimeType];
    NSString* errorInfo = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelErrorInfo];
    NSString* method = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelHttpMethod];
    NSString* requestUrl = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqUrl];
    NSString* requestPath = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqPath];
    NSString* reqBody = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqBody];
    NSString* reqHeaderFields = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqHeaderFields];
    NSString* reqHeaderLength = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqHeaderLength];
    NSString* reqBodyLength = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelReqBodyLength];
    NSString* respUrl = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelResponseUrl];
    NSString* respPath = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelRespPath];
    NSString* respBody = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelResponseBody];
    NSString* respContent = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelResponseContent];
    NSString* respTime = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelResponseTime];
    NSString* respHeaderFields = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelRespHeaderFields];
    NSString* respHeaderLength = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelRespHeaderLength];
    NSString* respBodyLength = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelRespBodyLength];
    NSString* startDate = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelStartDate];
    NSString* endDate = [NSString stringWithFormat:@"%@ TEXT", CYUrlModelEndDate];
    
    NSArray* array = @[uid, statusCode, mime, errorInfo, method, requestUrl, requestPath, reqBody, reqHeaderFields, reqHeaderLength, reqBodyLength, respUrl, respPath, respBody, respContent, respTime, respHeaderFields, respHeaderLength, respBodyLength, startDate, endDate];
    
    NSString* sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",kCYGUrlTableName, [array componentsJoinedByString:@","]];
    
    return sql;
}

- (NSString *)getTransactionSql {
    
    NSMutableArray* tempKeys = [NSMutableArray array];
    for (NSString* key in [self dbKeys]) {
        
        NSString* tempKey = [NSString stringWithFormat:@":%@", key];
        [tempKeys addObject:tempKey];
    }
    
    NSString* sql = [NSString stringWithFormat:@"insert or replace into %@ values (%@)",kCYGUrlTableName, [tempKeys componentsJoinedByString:@","]];
    return sql;
}

- (NSArray *)dbKeys{
    
    NSArray* keys = @[CYUrlModelReqUid,
                      CYUrlModelStatusCode,
                      CYUrlModelMimeType,
                      CYUrlModelErrorInfo,
                      CYUrlModelHttpMethod,
                      CYUrlModelReqUrl,
                      CYUrlModelReqPath,
                      CYUrlModelReqBody,
                      CYUrlModelReqHeaderFields,
                      CYUrlModelReqHeaderLength,
                      CYUrlModelReqBodyLength,
                      CYUrlModelResponseUrl,
                      CYUrlModelRespPath,
                      CYUrlModelResponseBody,
                      CYUrlModelResponseContent,
                      CYUrlModelResponseTime,
                      CYUrlModelRespHeaderFields,
                      CYUrlModelRespHeaderLength,
                      CYUrlModelRespBodyLength,
                      CYUrlModelStartDate,
                      CYUrlModelEndDate];
    
    return keys;
}

- (NSString *)databasePath {
    static NSString *databasePath = nil;
    if (!databasePath) {
        NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* name = [NSString stringWithFormat:@"%@.db", kCYGUrlDBName];
        databasePath = [cacheDirectory stringByAppendingPathComponent:name];
    }
    return databasePath;
}

- (void)insertOrUpdateDataToDB:(CYUrlAnalyseModel *)model {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSString* sqlStr = [self getTransactionSql];
        __block NSDictionary* dict = [model transformToDictionary];
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [db executeUpdate:sqlStr withParameterDictionary:dict];
        }];
    });
}

- (void)insertOrUpdateDataListToDB:(NSArray <CYUrlAnalyseModel *> *)list {
    
    NSArray* dataList  = [list copy];
    [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CYUrlAnalyseModel * model = obj;
        [self insertOrUpdateDataToDB:model];
    }];
}


@end
