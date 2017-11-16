//
//  ContactsController.m
//  DeleteContacts
//
//  Created by Patrick Aubin on 11/15/17.
//  Copyright © 2017 Patrick Aubin. All rights reserved.
//

#import "ContactsController.h"
#import "Contacts/Contacts.h"

@import CocoaLumberjack;
@import PhoneNumberKit;

@implementation ContactsController

+ (void) deleteAllContacts {
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    PhoneNumberKit *phoneNumberKit = [[PhoneNumberKit alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactPhoneNumbersKey];
            NSString *containerId = contactStore.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
                
                for (CNContact *contact in cnContacts) {
                    for (CNLabeledValue *phoneNumber in [contact phoneNumbers]) {
                        NSLog(@"%@", ((CNPhoneNumber *)phoneNumber.value).stringValue);
                    }

                    [saveRequest deleteContact:[contact mutableCopy]];
                }
                
                [contactStore executeSaveRequest:saveRequest error:nil];
//                DDLogVerbose(@"Deleted contacts %lu", cnContacts.count);
            }
        }
    }];
    
}

@end
