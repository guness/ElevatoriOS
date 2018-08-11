//
//  ExceptionCatcher.h
//  Elevator
//
//  Created by Sinan Güneş on 11.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

#ifndef ExceptionCatcher_h
#define ExceptionCatcher_h

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}

#endif /* ExceptionCatcher_h */
