import Foundation
import CommandLineKit
import Rainbow
import Alamofire
import Alamofire_Synchronous

let cli = CommandLineKit.CommandLine()

enum Algorithm: String {
    case bottomUp
    case topDown
    case insideOut
}

// MARK: - Params
let url: String
var algo: Algorithm = .insideOut
var lowerBound = 0
var upperBound = 9999
var statusDesc = "status"
var failValue = "false"
var start = Date()

// MARK: - CLI Configuration
let urlOption = StringOption(shortFlag: "u", longFlag: "url", required: true, helpMessage: "Specify REST Address for PIN with {pin} for PIN placeholder. e.g. https://myapi.tld/checkPIN/{pin}")
let algoOption = EnumOption<Algorithm>(shortFlag: "a", longFlag: "algorithm", helpMessage: "Algorithm - bottomUp, topDown or insideOut")
let lowerBoundOption = IntOption(shortFlag: "l", longFlag: "lowerBound", helpMessage: "Lower Bound of PIN Range, e.g. 0 for 0000")
let upperBoundOption = IntOption(shortFlag: "p", longFlag: "upperBound", helpMessage: "Upper Bound of PIN Range, e.g. 9999")
let statusDescOption = StringOption(shortFlag: "s", longFlag: "statusDesc", helpMessage: "Status descriptor, e.g. status")
let failValueOption = StringOption(shortFlag: "f", longFlag: "failValue", helpMessage: "Status fail value, e.g. fail, false, etc")
let verboseOption = BoolOption(shortFlag: "v", longFlag: "verbose", helpMessage: "Activate verbose mode")

cli.addOptions(urlOption, algoOption, lowerBoundOption, upperBoundOption, statusDescOption, failValueOption, verboseOption)

cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

guard let urlString = urlOption.value else {
    print("Wrong URL format".red)
    exit(EX_IOERR)
}

// MARK: - Configuration
url = urlString
algo = algoOption.value ?? algo
lowerBound = lowerBoundOption.value ?? lowerBound
upperBound = upperBoundOption.value ?? upperBound
failValue = failValueOption.value ?? failValue

// MARK: - Algorithms

fileprivate func checkPIN(_ pin: String) {
    guard let finalURL = URL(string: url.replacingOccurrences(of: "{pin}", with: pin)) else { exit(EX_IOERR) }
    let response = Alamofire.request(finalURL).responseJSON()
    if let json = response.result.value as? [String: Any], let status = json[statusDesc] as? String {
        if verboseOption.value {
            print("===== \(pin) =====")
            print(finalURL)
            print(json)
        }
        if status != failValue {
            print("PIN \(pin): true")
            print("Time: \(Int(Date().timeIntervalSince(start))) seconds")
            exit(EX_OK)
        }
    }
    print("PIN \(pin): false")
    if verboseOption.value {
        print("Time: \(Int(Date().timeIntervalSince(start))) seconds")
    }
}


fileprivate func bottomUp() {
    for pin in lowerBound ... upperBound {
        checkPIN(String(format: "%04d", pin))
    }
}

fileprivate func topDown() {
    for pin in stride(from: upperBound, to: lowerBound, by: -1) {
        checkPIN(String(format: "%04d", pin))
    }
}

fileprivate func insideOut() {
    let mid = (upperBound - lowerBound) / 2
    let tenth = (upperBound - lowerBound ) / 10
    
    for run in 0...5 {
        for pin in stride(from: mid + (run * tenth), to: min(mid + ((run + 1) * tenth), upperBound + 1), by: +1) {
            checkPIN(String(format: "%04d", pin))
        }
        for pin in stride(from: mid - (run * tenth), to: max(mid - ((run + 1) * tenth), lowerBound - 1), by: -1) {
            checkPIN(String(format: "%04d", pin))
        }
    }
}

switch algo {
case .bottomUp:
    bottomUp()
case .topDown:
    topDown()
case .insideOut:
    insideOut()
}

print("Time: \(Int(Date().timeIntervalSince(start))) seconds")
