//
//  NSURLRequest.m
//  Ego
//
//  Created by David Muñoz Díaz on 15/12/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

@implementation NSURLRequest(Orsee)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
	return YES;
}

@end