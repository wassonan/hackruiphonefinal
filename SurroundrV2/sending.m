/* // AF_INET will be created using the IPv4 domain (AF_INET)
// If we want TCP we could put in SOCK_STREAM here instead of SOCK_DGRAM, using protocol 0, which is IP.
int send_sock_fd = socket(AF_INET, SOCK_DGRAM, 0);
if (send_sock_fd < 0) {
    // Error occurred
}

int flag = 1;
int result = setsockopt(send_sock_fd, SOL_SOCKET, SO_BROADCAST, &flag, sizeof(flag));
if (result < 0) {
    // Error occurred
}

 */
/*
//struct sockaddr_in addr;
memset(&addr, 0, sizeof(addr));
addr.sin_family = AF_INET;
addr.sin_addr.s_addr = INADDR_BROADCAST;
addr.sin_port = htons(kPortNumber);

NSData *data;
result = sendto(send_sock_fd, [data bytes], [data length], 0, (struct sockaddr*)&addr, sizeof(addr));
//if ( result < 0 ) {
    // Error occurred
}
 
 */
//
//  recieving.m
//  SurroundrV2
//
//  Created by Ben Kropf on 10/11/14.
//  Copyright (c) 2014 benkropf. All rights reserved.
//

//#import <Foundation/Foundation.h>



// get out of my sight


/*
 int rec_sock_fd = socket(AF_INET, SOCK_DGRAM, 0);
 if (rec_sock_fd < 0) {
 // Error occurred
 }
 
 
 struct ifaddrs *addrs;
 int result = getifaddrs(&addrs);
 if (result < 0) {
 return;
 // Error occurred
 }
 
 const struct ifaddrs *cursor = addrs;
 while (cursor != NULL) {
 if ( cursor->ifa_addr->sa_family == AF_INET
 && !(cursor->ifa_flags & IFF_LOOPBACK)
 && !(cursor->ifa_flags & IFF_POINTOPOINT)
 &&  (cursor->ifa_flags & IFF_MULTICAST) ) {
 
 // We will do some stuff in here. k
 
 struct ip_mreq multicast_req;
 memset(&multicast_req, 0, sizeof(multicast_req));
 multicast_req.imr_multiaddr.s_addr = inet_addr(kMulticastAddress);
 multicast_req.imr_interface = ((struct sockaddr_in *)cursor->ifa_addr)->sin_addr;
 
 setsockopt(rec_sock_fd, IPPROTO_IP, IP_DROP_MEMBERSHIP, &multicast_req, sizeof(multicast_req));
 
 if (setsockopt(rec_sock_fd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &multicast_req, sizeof(multicast_req)) < 0) {
 // Error occurred
 return;
 }
 }
 cursor = cursor->ifa_next;
 }
 
 struct sockaddr_in rec_addr;
 
 char buffer[kBufferSize];
 socklen_t addr_len = sizeof(rec_addr);
 
 while (1) {
 
 NSLog(@"uh2");
 
 // Receive a message, waiting if there's nothing there yet
 int bytes_received = recvfrom(rec_sock_fd, buffer, kBufferSize, 0, (struct sockaddr*)&rec_addr, &addr_len);
 NSLog(@"uh");
 
 if ( bytes_received < 0 ) {
 // Error occurred
 }
 
 
 // Now we have bytes_received bytes of data in buffer. Print it!
 fwrite(buffer, sizeof(char), bytes_received, stdout);
 printf("%s", buffer);
 
 NSString *str = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
 NSLog(@"%@", str);
 
 str = @"bob";
 
 _testLabel.text = str;
 
 }
 
 */


// another method

/*
 - (IBAction)listenTest:(id)sender {
 
 // Recieving
 
 int rec_sock_fd = socket(AF_INET, SOCK_DGRAM, 0);
 if (rec_sock_fd < 0) {
 // Error occurred
 }
 
 // Bind to socket
 struct sockaddr_in rec_addr;
 memset(&rec_addr, 0, sizeof(rec_addr));
 rec_addr.sin_family = AF_INET;
 rec_addr.sin_addr.s_addr = INADDR_ANY;
 rec_addr.sin_port = htons(kPortNumber);
 
 int result = bind(rec_sock_fd, (struct sockaddr*)&rec_addr, sizeof(rec_addr));
 if (result < 0) {
 // Error occurred
 }
 
 char buffer[kBufferSize];
 int addr_len = sizeof(rec_addr);
 
 while (1) {
 
 int bytes_received = recvfrom(rec_sock_fd, buffer, kBufferSize, 0, (struct sockaddr*)&rec_addr, &addr_len);
 if ( bytes_received < 0 ) {
 // Error occurred
 }
 
 fwrite(buffer, sizeof(char), bytes_received, stdout);
 
 }
 
 }
*/
