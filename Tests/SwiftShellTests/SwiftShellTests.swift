import Testing
@testable import SwiftShell

@Test("ECHO: Output") func textOutput() async throws {
    // tests echo terminal output
    let command = ShellCommand()
    let output = command.run("echo 'Hello, World!'")
    let expected = "Hello, World!\n"
    #expect(output == expected)
}

@Test("LS: Directory") func list() async throws {
    // lists user directory and searches for Desktop
    let command = ShellCommand()
    let userFiles = command.run("ls ~/")
    #expect(userFiles.contains("Desktop"))
}

@Test("MKDIR & RM: Directory") func makeRemoveDirectory() async throws {
    // lists working directory contents
    let command = ShellCommand()
    let listStart = command.run("ls -p")
    
    // creates unique name for temporary directory
    var newDirectory = "directory"
    while listStart.contains("\(newDirectory)/") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory creation
    command.run("mkdir \(newDirectory)")
    let  listUpdate = command.run("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    
    // deletes newDirectory and validates directory reversion
    command.run("rm -rf \(newDirectory)")
    let listFinal = command.run("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("TOUCH & RM: File") func  makeRemoveFile () async throws {
    // lists working directory contents
    let command = ShellCommand()
    let listStart = command.run("ls")
    
    // creates unique name for temporary file
    var newFile = "file"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    command.run("touch \(newFile).txt")
    let listUpdate = command.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // deletes newDirectory and validates directory reversion
    command.run("rm \(newFile).txt")
    let listFinal = command.run("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("CAT: Viewing") func  catFile () async throws {
    // lists working directory contents
    let command = ShellCommand()
    let listStart = command.run("ls")
    
    // creates unique name for temporary file
    var newFile = "catFile"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    command.run("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = command.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // retrieves and validates newFile contents
    let contents = command.run("cat \(newFile).txt")
    let expected = "Hello, World!\n"
    #expect(contents == expected)
    
    // deletes newFile and validates directory reversion
    command.run("rm \(newFile).txt")
    let listFinal = command.run("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("MV: File") func  moveFile () async throws {
    // lists working directory contents
    let command = ShellCommand()
    let listStart = command.run("ls -p")
    
    // creates unique names for temporary file and directory
    var newDirectory = "mvDirectory"
    var newFile = "mvFile"
    while listStart.contains("\(newDirectory)/") || listStart.contains("\(newFile).txt") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory and newFile creation
    command.run("mkdir \(newDirectory)")
    command.run("touch \(newFile).txt")
    let listUpdate = command.run("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // moves newFile into newDirectory and validates move
    command.run("mv \(newFile).txt \(newDirectory)/")
    let listNewDirectory = command.run("ls \(newDirectory)/")
    #expect(listNewDirectory == "\(newFile).txt\n")
    
    // deletes newDirectory and validates directory reversion
    command.run("rm -rf \(newDirectory)")
    let listFinal = command.run("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("CP: File") func copyingFile() async throws {
    // lists working directory contents
    let command = ShellCommand()
    let listStart = command.run("ls")
    
    // creates unique name for temporary files
    var newFile = "toCopy"
    var copyFile = "copy"
    while listStart.contains("\(newFile).txt") || listStart.contains("\(copyFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
        copyFile = "\(copyFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    command.run("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = command.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    let fileContents = command.run("cat \(newFile).txt")
    #expect(fileContents == "Hello, World!\n")
    
    // copies newFile and validates copyFile contents
    command.run("cp \(newFile).txt \(copyFile).txt")
    let listCopyUpdate = command.run("ls")
    try #require(listCopyUpdate.contains("\(copyFile).txt"))
    let copyContents = command.run("cat \(copyFile).txt")
    #expect(copyContents == "Hello, World!\n")
    
    // deletes newFile and copyFile and validates directory reversion
    command.run("rm \(newFile).txt \(copyFile).txt")
    let listFinal = command.run("ls")
    #expect(
        listFinal.contains("\(newFile).txt") == false &&
        listFinal.contains("\(copyFile).txt") == false
    )
}


@Test("CD: Directory") func testChangingDirectory() async throws {
    // stores working directory
    let command = ShellCommand()
    let pathStart = command.run("pwd")
    
    // initiates and validates navigation to parent folder
    command.run("cd ../")
    let pathUpdate = command.run("pwd")
    #expect(pathStart != pathUpdate)
    
    // validates directory navigation and reversion
    command.run("cd \(pathStart)")
    let pathFinal = command.run("pwd")
    #expect(pathStart == pathFinal)
}
