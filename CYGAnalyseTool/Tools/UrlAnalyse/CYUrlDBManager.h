//
//  CYUrlDBManager.h
//  CYGAnalyseTool
//
//  Created by 高天翔 on 2017/11/2.
//  Copyright © 2017年 CYGTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYUrlAnalyseModel.h"

@interface CYUrlDBManager : NSObject

+ (CYUrlDBManager *)sharedManager;

- (void)insertOrUpdateDataToDB:(CYUrlAnalyseModel *)model;

- (void)insertOrUpdateDataListToDB:(NSArray <CYUrlAnalyseModel *> *)list;

@end
