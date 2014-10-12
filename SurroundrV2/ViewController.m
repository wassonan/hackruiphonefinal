//
//  ViewController.m
//  SurroundrV2
//
//  Created by Ben Kropf on 10/11/14.
//  Copyright (c) 2014 benkropf. All rights reserved.
//

#import "ViewController.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <netdb.h>

#define kPortNumber 48317
#define kBufferSize 1024
#define kMaxSockets 16
#define kMulticastAddress "224.0.0.1"
#define MAXSTRINGLENGTH 80


@implementation ViewController

@synthesize ip, readyToStream, port, testLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readyToStream = NO;
}
- (IBAction)connectStream:(id)sender {
    if (self.readyToStream) {
        [self streamMusic];
    } else {
        NSLog(@"Not ready to stream");
    }
    
}


- (void)startMulticastListen {
        
    char *multicastAddrString = "224.0.0.1"; // First arg: multicast addr (v4 or v6!)
    char *service = "48317"; // Second arg: port/service
        
    struct addrinfo addrCriteria; // Criteria for address match
    memset(&addrCriteria, 0, sizeof(addrCriteria)); // Zero out structure
    addrCriteria.ai_family = AF_UNSPEC; // v4 or v6 is OK
    addrCriteria.ai_socktype = SOCK_DGRAM; // Only datagram sockets
    addrCriteria.ai_protocol = IPPROTO_UDP; // Only UDP protocol
    addrCriteria.ai_flags |= AI_NUMERICHOST; // Don't try to resolve address
        
    // Get address information
    struct addrinfo *multicastAddr; // List of server addresses
    int rtnVal = getaddrinfo(multicastAddrString, service,
                                 &addrCriteria, &multicastAddr);
    if (rtnVal != 0)
        NSLog(@"getaddrinfo() failed");
        
    // Create socket to receive on
    int sock = socket(multicastAddr->ai_family, multicastAddr->ai_socktype,
                          multicastAddr->ai_protocol);
    if (sock < 0)
        NSLog(@"socket() failed");
        
    if (bind(sock, multicastAddr->ai_addr, multicastAddr->ai_addrlen) < 0) {
        
        // Now join the multicast "group"
        struct ip_mreq joinRequest;
        joinRequest.imr_multiaddr = ((struct sockaddr_in *) multicastAddr->ai_addr)->sin_addr;
        joinRequest.imr_interface.s_addr = 0; // Let the system choose the i/f
        printf("Joining IPv4 multicast group...\n");
        
        if (setsockopt(sock, IPPROTO_IP, IP_ADD_MEMBERSHIP, &joinRequest, sizeof(joinRequest)) < 0)
            NSLog(@"setsockopt(IPV4_ADD_MEMBERSHIP) failed");
    }
    
    // Free address structure(s) allocated by getaddrinfo()
    freeaddrinfo(multicastAddr);
    char recvString[MAXSTRINGLENGTH + 1]; // Buffer to receive into
    
    // Receive a single datagram from the server
    int recvStringLen = recvfrom(sock, recvString, MAXSTRINGLENGTH, 0, NULL, 0);
    
    if (recvStringLen < 0)
        NSLog(@"recvfrom() failed");
        
    recvString[recvStringLen] = '\0'; // Terminate the received string
    
    // Note: sender did not send the terminal 0
    printf("Received: %s\n", recvString);
    
    char *token = strtok(recvString, " ");
    self.ip = strdup(token);
    token = strtok(NULL, " ");
    self.port = strdup(token);
    
    printf("%s\n", self.ip);
    printf("%s\n\n", self.port);
    
    NSString *str = [NSString stringWithCString:recvString encoding:NSUTF8StringEncoding];
    testLabel.text = str;
    
    close(sock);
    self.readyToStream = YES;
}
- (void)streamMusic{
    
    NSLog(@"hi %s", self.ip);
    
    int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock < 0)
        NSLog(@"socket() failed");
    // Construct the server address structure
    struct sockaddr_in servAddr; // Server address
    memset(&servAddr, 0, sizeof(servAddr)); // Zero out structure
    servAddr.sin_family = AF_INET; // IPv4 address family
    NSLog(@"\n-------------------------------------\n About to connect...\n");
    NSLog(@"Ip:%s and port:%s",self.ip, self.port);
    
    // Convert address2.1 IPv4 TCP Client 13
    int rtnVal = inet_pton(AF_INET, self.ip, &servAddr.sin_addr.s_addr);
    if (rtnVal == 0)
        NSLog(@"inet_pton() failed \ninvalid address string");
    else if (rtnVal < 0)
        NSLog(@"inet_pton() failed");
    
    //Convering port to short
    unsigned short portnum = (unsigned short) [NSString stringWithUTF8String:self.port].integerValue;
    NSLog(@"%i",portnum);
    servAddr.sin_port = htons(portnum); // Server port
    // Establish the connection to the echo server
    if (connect(sock, (struct sockaddr *) &servAddr, sizeof(servAddr)) < 0)
        NSLog(@"connect() failed %i (%s)",errno,strerror(errno));
    
    // Receive the same string back from the server
    unsigned int totalBytesRcvd = 0; // Count of total bytes received
    fputs("Received: ", stdout); // Setup to print the echoed string
    
    char buffer[kBufferSize]; // I/O buffer
    /* Receive up to the buffer size (minus 1 to leave space for
    a null terminator) bytes from the sender */
    int numBytes = recv(sock, buffer, kBufferSize- 1, 0);
    
    if (numBytes < 0)
        NSLog(@"recv() failed");
    else if (numBytes == 0)
        NSLog(@"connection closed prematurely");
    
    totalBytesRcvd += numBytes; // Keep tally of total bytes
    buffer[numBytes] = '\0'; // Terminate the string!
    fputs(buffer, stdout); // Print the echo buffer
    
    NSString *str = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    NSLog(str);
    
    close(sock);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)multicastListen:(id)sender {
    [self startMulticastListen];
}


@end
