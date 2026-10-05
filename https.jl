import { Address4, Address6 } from 'ip-address';

// Validation
Address4.isValid('192.168.1.1');           // true
Address6.isValid('2001:db8::1');           // true
Address6.isValid('not an address');        // false

// Parsing (throws AddressError on invalid input)
const v4 = new Address4('192.168.1.1/24');
const v6 = new Address6('2001:db8::1/64');

// Subnet membership
const host = new Address4('192.168.1.42');
const network = new Address4('192.168.1.0/24');
host.isInSubnet(network);                  // true

// Subnet range
network.startAddress().correctForm();      // '192.168.1.0'
network.endAddress().correctForm();        // '192.168.1.255'

// Strict network-address check (host bits must be zero).
// isValid() accepts CIDRs with host bits set — '192.168.1.5/24' is a valid
// host-with-subnet, but it isn't a network address.
const cidr = new Address4('192.168.1.5/24');
Address4.isValid('192.168.1.5/24');                                // true
cidr.correctForm() === cidr.startAddress().correctForm();          // false

// Address properties
const link = new Address6('fe80::1');
link.isLinkLocal();                        // true
link.isMulticast();                        // false
link.isLoopback();                         // false

new Address4('192.168.1.1').isPrivate();   // true (RFC 1918)
new Address6('fc00::1').isULA();           // true (RFC 4193)

// Numeric and byte representations
v4.bigInt();                               // 3232235777n
v4.toArray();                              // [192, 168, 1, 1]
v6.canonicalForm();                        // '2001:0db8:0000:0000:0000:0000:0000:0001'

// Embedded IPv4 + Teredo
const teredo = new Address6('2001:0:ce49:7601:e866:efff:62c3:fffe');
teredo.inspectTeredo().client4;            // '157.60.0.1'

// Parse host + port from a URL
Address6.fromURL('http://[2001:db8::1]:8080/').port;  // 8080
