//
//  ViewController.m
//  MultipathTCP-ObjC
//
//  Created by 王云刚 on 2018/10/16.
//  Copyright © 2018年 王云刚. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *debugLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

/**
@enum NSURLSessionMultipathServiceType

@discussion The NSURLSessionMultipathServiceType enum defines constants that
can be used to specify the multipath service type to associate an NSURLSession.  The
multipath service type determines whether multipath TCP should be attempted and the conditions
for creating and switching between subflows.  Using these service types requires the appropriate entitlement.  Any connection attempt will fail if the process does not have the required entitlement.
A primary interface is a generally less expensive interface in terms of both cost and power (such as WiFi or ethernet).  A secondary interface is more expensive (such as 3G or LTE).
*/

/**
 @constant NSURLSessionMultipathServiceTypeNone Specifies that multipath tcp should not be used.  Connections will use a single flow.
 This is the default value.  No entitlement is required to set this value.
 */
- (IBAction)SendNoneReq:(id)sender {
    /* None - no multipath (default) */
    [self realSendReq:NSURLSessionMultipathServiceTypeNone];
}

/**
 @constant NSURLSessionMultipathServiceTypeHandover Specifies that a secondary subflow should only be used
 when the primary subflow is not performing adequately.   Requires the com.apple.developer.networking.multipath entilement.
 */
- (IBAction)SendHandoverReq:(id)sender {
    /* Handover - secondary flows brought up when primary flow is not performing adequately. */
    [self realSendReq:NSURLSessionMultipathServiceTypeHandover];
}

/**
 @constant NSURLSessionMultipathServiceTypeInteractive Specifies that a secodary subflow should be used if the
 primary subflow is not performing adequately (packet loss, high round trip times, bandwidth issues).  The secondary
 subflow will be created more aggressively than with NSURLSessionMultipathServiceTypeHandover.  Requires the com.apple.developer.networking.multipath entitlement.
 */
- (IBAction)SendInteractiveReq:(id)sender {
    /* Interactive - secondary flows created more aggressively. */
    [self realSendReq:NSURLSessionMultipathServiceTypeInteractive];
}

/**
 @constant NSURLSessionMultipathServiceTypeAggregate Specifies that multiple subflows across multiple interfaces should be
 used for better bandwidth.  This mode is only available for experimentation on devices configured for development use.
 It can be enabled in the Developer section of the Settings app.
 */
- (IBAction)SendAggregateReq:(id)sender {
     /* Aggregate - multiple subflows used for greater bandwitdh. */
    [self realSendReq:NSURLSessionMultipathServiceTypeAggregate];
}

- (void)realSendReq:(NSURLSessionMultipathServiceType)type {
    NSURL * mptcpUrl = [NSURL URLWithString:@"http://amiusingmptcp.de/v1/check_connection"];
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfiguration.multipathServiceType = type;
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithURL:mptcpUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString * debugLog = nil;
        if (nil != data) {
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"MPTCP => ResponseData : %@", dictionary);
            if (nil != dictionary) {
                BOOL isMPTCP = [[dictionary objectForKey:@"mptcp"] boolValue];
                if (isMPTCP) {
                    NSLog(@"✔️ Multipath Connection !!!");
                    debugLog = @"✔️ Multipath Connection !!!";
                    
                } else {
                    NSLog(@"❌ No Multipath Connection !!!");
                    debugLog = @"❌ No Multipath Connection !!!";
                }
            }
        } else {
            NSLog(@"MPTCP => %@", error);
            debugLog = [NSString stringWithFormat:@"%@", error];
        }
        
        // Show debug log;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.debugLabel.text = debugLog;
            });
        });
    }];
    [sessionDataTask resume];
}

@end
