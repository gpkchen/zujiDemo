//
//  ZYSafeSwizzle.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSafeSwizzle.h"
#import "ZYMacro.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzle)

+ (void) load{
    Method __NSArrayI__ObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method __safe__NSArrayI__ObjcAtIndex = class_getInstanceMethod([self class], @selector(__safe__NSArrayI_objcAtIndex:));
    if (!class_addMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:),
                         method_getImplementation(__NSArrayI__ObjectAtIndex),
                         method_getTypeEncoding(__safe__NSArrayI__ObjcAtIndex))) {
        method_exchangeImplementations(__NSArrayI__ObjectAtIndex, __safe__NSArrayI__ObjcAtIndex);
    }
    
    Method __NSSingleObjectArrayI__ObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
    Method __safe__NSSingleObjectArrayI__ObjcAtIndex = class_getInstanceMethod([self class], @selector(__safe__NSSingleObjectArrayI_objcAtIndex:));
    if (!class_addMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:),
                         method_getImplementation(__NSSingleObjectArrayI__ObjectAtIndex),
                         method_getTypeEncoding(__safe__NSSingleObjectArrayI__ObjcAtIndex))) {
        method_exchangeImplementations(__NSSingleObjectArrayI__ObjectAtIndex, __safe__NSSingleObjectArrayI__ObjcAtIndex);
    }
    
    Method __NSArray0__ObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
    Method __safe__NSArray0__ObjcAtIndex = class_getInstanceMethod([self class], @selector(__safe__NSArray0_objcAtIndex:));
    if (!class_addMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:),
                         method_getImplementation(__NSArray0__ObjectAtIndex),
                         method_getTypeEncoding(__safe__NSArray0__ObjcAtIndex))) {
        method_exchangeImplementations(__NSArray0__ObjectAtIndex, __safe__NSArray0__ObjcAtIndex);
    }
}

- (instancetype)__safe__NSArrayI_objcAtIndex:(NSUInteger)index{
    @try {
        return [self __safe__NSArrayI_objcAtIndex:index];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSArray Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
        return nil;
    }
}

- (instancetype)__safe__NSSingleObjectArrayI_objcAtIndex:(NSUInteger)index{
    @try {
        return [self __safe__NSSingleObjectArrayI_objcAtIndex:index];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSArray Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
        return nil;
    }
}

- (instancetype)__safe__NSArray0_objcAtIndex:(NSUInteger)index{
    @try {
        return [self __safe__NSArray0_objcAtIndex:index];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSArray Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
        return nil;
    }
}

@end




@implementation NSMutableArray (Swizzle)

+ (void) load{
    Method __NSArrayM__ObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method __safe__NSArrayM__ObjcAtIndex = class_getInstanceMethod([self class], @selector(__safe__NSArrayM_objcAtIndex:));
    if (!class_addMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:),
                         method_getImplementation(__NSArrayM__ObjectAtIndex),
                         method_getTypeEncoding(__safe__NSArrayM__ObjcAtIndex))) {
        method_exchangeImplementations(__NSArrayM__ObjectAtIndex, __safe__NSArrayM__ObjcAtIndex);
    }
    
    Method __NSArrayM__addObject = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(addObject:));
    Method __safe__NSArrayM__addObject = class_getInstanceMethod([self class], @selector(__safe__NSArrayM_addObject:));
    if (!class_addMethod(objc_getClass("__NSArrayM"), @selector(addObject:),
                         method_getImplementation(__NSArrayM__addObject),
                         method_getTypeEncoding(__safe__NSArrayM__addObject))) {
        method_exchangeImplementations(__NSArrayM__addObject, __safe__NSArrayM__addObject);
    }
}

- (instancetype)__safe__NSArrayM_objcAtIndex:(NSUInteger)index{
    @try {
        return [self __safe__NSArrayM_objcAtIndex:index];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSMutableArray Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
        return nil;
    }
}


- (void)__safe__NSArrayM_addObject:(id)object{
    @try {
        [self __safe__NSArrayM_addObject:object];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSMutableArray Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
    }
}


@end






@implementation NSMutableDictionary (Swizzle)

+ (void) load{
    Method __NSDictionaryM__setObject = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:));
    Method __safe__NSDictionaryM__setObject = class_getInstanceMethod([self class], @selector(__NSDictionaryM__setObject:forKey:));
    if (!class_addMethod(objc_getClass("__NSDictionaryM"), @selector(setObject:forKey:),
                         method_getImplementation(__NSDictionaryM__setObject),
                         method_getTypeEncoding(__safe__NSDictionaryM__setObject))) {
        method_exchangeImplementations(__NSDictionaryM__setObject, __safe__NSDictionaryM__setObject);
    }
    
    Method __NSDictionaryM__setValue = class_getInstanceMethod(objc_getClass("__NSDictionaryM"), @selector(setValue:forKey:));
    Method __safe__NSDictionaryM__setValue = class_getInstanceMethod([self class], @selector(__NSDictionaryM__setValue:forKey:));
    if (!class_addMethod(objc_getClass("__NSDictionaryM"), @selector(setValue:forKey:),
                         method_getImplementation(__NSDictionaryM__setValue),
                         method_getTypeEncoding(__safe__NSDictionaryM__setValue))) {
        method_exchangeImplementations(__NSDictionaryM__setValue, __safe__NSDictionaryM__setValue);
    }
}

- (void)__NSDictionaryM__setObject:(id)anObject forKey:(id <NSCopying>)aKey{
    @try {
        return [self __NSDictionaryM__setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSDictionary Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
    }
}

- (void)__NSDictionaryM__setValue:(id)anObject forKey:(id <NSCopying>)aKey{
    @try {
        return [self __NSDictionaryM__setValue:anObject forKey:aKey];
    } @catch (NSException *exception) {
        ZYLog(@"============================SAFE============================\nNSDictionary Exception:\n%@%@\n============================SAFE============================",exception.reason,exception.callStackSymbols);
    }
}

@end
