
#import "Kiwi.h"
#import "ASIHTTPRequest.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "Nocilla.h"

SPEC_BEGIN(NocillaSpec)

// networksetup -setwebproxy "Wi-Fi" 127.0.0.1 12345
// networksetup -setwebproxystate "Wi-Fi" off
beforeAll(^{
    [[LSNocilla sharedInstace] start];
});
afterEach(^{
    [[LSNocilla sharedInstace] clearStubs];
});
context(@"ASIHTTPRequest", ^{
    it(@"should stub the request", ^{
        stubRequest(@"POST", @"http://localhost:12345/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"Cacatuha!!!", @"sisisi").
        withBody(@"caca").
        andReturn(403).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"Hello World!");
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://localhost:12345/say-hello"]];
        [request addRequestHeader:@"Content-Type" value:@"text/plain"];
        [request addRequestHeader:@"Cacatuha!!!" value:@"sisisi"];
        [request appendPostData:[[@"caca" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
        [request startSynchronous];
        
        [request.error shouldBeNil];
        [[request.responseString should] equal:@"Hello World!"];
        [[theValue(request.responseStatusCode) should] equal:theValue(403)];
        [[[request.responseHeaders objectForKey:@"Content-Type"] should] equal: @"text/plain"];     
    });
});

context(@"AFNetworking", ^{
    it(@"should stub the request", ^{
        stubRequest(@"POST", @"http://localhost:12345/say-hello").
        withHeader(@"Content-Type", @"text/plain").
        withHeader(@"Cacatuha!!!", @"sisisi").
        withBody(@"caca").
        andReturn(403).
        withHeader(@"Content-Type", @"text/plain").
        withBody(@"Hello World!");
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:12345/say-hello"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"sisisi" forHTTPHeaderField:@"Cacatuha!!!"];
        [request setHTTPBody:[@"caca" dataUsingEncoding:NSASCIIStringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation start];
        
        [operation waitUntilFinished];
        
        [operation.error shouldNotBeNil];
        [[operation.responseString should] equal:@"Hello World!"];
        [[theValue(operation.response.statusCode) should] equal:theValue(403)];
        [[[[operation.response allHeaderFields] objectForKey:@"Content-Type"] should] equal: @"text/plain"];
    });
});
SPEC_END