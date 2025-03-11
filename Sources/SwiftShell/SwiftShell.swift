import Foundation

/// Returns a String containing the default system shell output after command execution
/// Available for 10.15.4 and higher due to other data parsing methods depreciating
@available(macOS 10.15.4, *)
@discardableResult
func SwiftShell (_ command: String) -> String {
    let process = Process()
    let pipe = Pipe()
    
    // properties of process being set - shell location,
    // command input and output
    process.executableURL = URL(fileURLWithPath: ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
    )
    process.arguments = ["-c", command]
    process.standardOutput = pipe
    process.standardError = pipe
    
    // command execution and data return
    do {
        try process.run()
        // returns data from command execution
        guard let data = try pipe.fileHandleForReading.readToEnd() else {
            // returns "" when data is nil
            return ""
        }
        // parses data returned from command execution
        return  String(decoding: data, as: UTF8.self)
    } catch {
        // returns error if process execution fails
        return error.localizedDescription
    }
}
