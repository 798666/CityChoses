//
//  CityArchiveHelper.m
//  CityChose
//
//  Created by mijk on 15/8/28.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import "CityArchiveHelper.h"
#define kLastestPath  @"lastestUserInformation"
#define kLastestFile  @"lastestUser"
@implementation CityArchiveHelper

+ (NSString *)lastestUserPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kLastestPath];
}

+ (void)saveForUser:(NSMutableArray *)userarry {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:userarry forKey:kLastestFile];
        [archiver finishEncoding];
        [data writeToFile:[[self class] lastestUserPath] atomically:YES];
    });
}

+  (NSMutableArray *)getLastestUserarry {
    NSString *userPath = [[self class] lastestUserPath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchiver decodeObjectForKey:kLastestFile];
}

@end
