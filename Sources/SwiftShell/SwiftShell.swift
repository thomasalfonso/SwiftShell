import Foundation

/// Returns a String containing the default system shell output after command execution
/// Available for 10.15.4 and higher due to other data parsing methods depreciating

public class SwiftShell {
    // workingDirectory state maintained between process() instances
    private var workingDirectory = "./"
    
    public init() {}
    
    @discardableResult
    public func run(_ command: String) -> String {
        // shell instance run in process
        // standard output over pipe
        let process = Process()
        let pipe = Pipe()
        // process properties
        process.executableURL = URL(
            fileURLWithPath: ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        )
        // cd and pwd used for keeping working directory current
        process.arguments = ["-c", "cd \(workingDirectory); \(command); pwd;" ]
        process.standardOutput = pipe
        process.standardError = pipe
        
        // command is executed and standard output from shell is returned
        do {
            try process.run()
            let output = try parse(pipe)
            return output
        } catch {
            return error.localizedDescription
        }
    }
    
    // parses data, updates workingDirectory, and returns standard output from shell
    private func parse (_ pipe: Pipe) throws -> String {
        // pulls raw data from pipe
        let rawData = try pipeResponse(pipe)
    
        // parses data to separate user command response and pwd response
        let data = String(decoding: rawData, as: UTF8.self).split(separator: "\n")
        guard let lastLine = data.last else { throw ShellError.DataAbsent }
        guard let directoryIndex = lastLine.firstIndex(of: "/") else { throw ShellError.IndexNotFound }
        
        // updates pwd so working directory changes between process instances
        let pwdResponse = String(lastLine[directoryIndex...])
        self.workingDirectory = pwdResponse
        
        // returns command data
        let commandData = String(data.joined(separator: "\n")[..<directoryIndex])
        return commandData
    }
    
    // returns rawData retrieved from pipe instance
    private func pipeResponse (_ pipe : Pipe) throws -> Data {
        if #available(macOS 10.15.4, *) {
            // pipe parsing for newer operating systems
            guard let rawData = try pipe.fileHandleForReading.readToEnd() else { throw ShellError.PipeEmpty }
            return rawData
        }
        else {
            // depreciated pipe parsing for older devices
            let rawData = pipe.fileHandleForReading.readDataToEndOfFile()
            return rawData
        }
    }
    
    // describes errors
    enum ShellError: Error {
        case PipeEmpty
        case DataAbsent
        case IndexNotFound
    }
}
