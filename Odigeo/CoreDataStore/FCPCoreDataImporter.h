//
//  FCPCoreDataImporter.h
//  Odigeo
//
//  Created by Fernando Canon on 28/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSManager;
@class WSCurrencyConverter;

@interface FCPCoreDataImporter : NSObject


- (id)initWithContext:(NSManagedObjectContext *)context webservice:(WSManager *)webservice andWSCurrency:(WSCurrencyConverter*)  wsConverter;

- (void) import;

@end
