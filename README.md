# unpin

PIN bruteforce over GET Requests

## How to build

1. git clone https://github.com/JediWed/unpin.git
2. cd unpin
3. make

You can find binary and libraries at *bin/unpin*.

## How to use

```bash
./unpin -u <url> -a <algorithm> -l <lower bound> -p <upper bound> -s <status descriptor> -f <fail value> -v
```

|Option|Possible Value|Default Value|Explanation|
|:----:|:------------:|:-----------:|:----------|
|-u, --url|URL| |Specify REST address for GET request with placeholder where the PIN should be placed. e.g. https://myapi.tld/checkPIN/{pin}|
|-a, --algorithm|bottomUp, topDown, insideOut| insideOut |*bottomUp* starts at lower bound and goes to upper bound. *topDown* starts at upper bound and goes to lower bound. *insideOut* starts in the middle of lower and upper bound and goes alternating and iterative to both bounds.|
|-l, --lowerBound|positive integer|0|Lowest number which PIN could be. e.g. 0|
|-p, --upperBound|positive integer|9999|Highest number which PIN could be. e.g. 9999|
|-s, --statusDesc|string|status|Status descriptor of JSON return which defines if commited PIN was correct. If return value is *"success" = false* your status descriptor is "success". If return value is *"status" = "failed"* your status descriptor is "status".|
|-f, --failValue|string|false|Status value of JSON return which defines if commited PIN was correct. If return value is *"success" = false* your fail value is "false". If return value is *"status" = "failed"* your fail value is "failes".|
|-v, --verbose| | | Activates verbose mode with a lot more information during bruteforce process|
