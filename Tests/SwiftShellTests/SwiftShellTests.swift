import Testing
@testable import SwiftShell

@Test("ECHO: Output") func textOutput() async throws {
    // tests echo terminal output
    let output = SwiftShell("echo 'Hello, World!'")
    let expected = "Hello, World!\n"
    #expect(output == expected)
}

@Test("LS: Directory") func list() async throws {
    // lists user directory and searches for Desktop
    let userFiles = SwiftShell("ls ~/")
    #expect(userFiles.contains("Desktop"))
}

@Test("MKDIR & RM: Directory") func makeRemoveDirectory() async throws {
    // lists working directory contents
    let listStart = SwiftShell("ls -p")
    
    // creates unique name for temporary directory
    var newDirectory = "directory"
    while listStart.contains("\(newDirectory)/") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory creation
    SwiftShell("mkdir \(newDirectory)")
    let  listUpdate = SwiftShell("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    
    // deletes newDirectory and validates directory reversion
    SwiftShell("rm -rf \(newDirectory)")
    let listFinal = SwiftShell("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("TOUCH & RM: File") func  makeRemoveFile () async throws {
    // lists working directory contents
    let listStart = SwiftShell("ls")
    
    // creates unique name for temporary file
    var newFile = "file"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    SwiftShell("touch \(newFile).txt")
    let listUpdate = SwiftShell("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // deletes newDirectory and validates directory reversion
    SwiftShell("rm \(newFile).txt")
    let listFinal = SwiftShell("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("CAT: Viewing") func  catFile () async throws {
    // lists working directory contents
    let listStart = SwiftShell("ls")
    
    // creates unique name for temporary file
    var newFile = "catFile"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    SwiftShell("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = SwiftShell("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // retrieves and validates newFile contents
    let contents = SwiftShell("cat \(newFile).txt")
    let expected = "Hello, World!\n"
    #expect(contents == expected)
    
    // deletes newFile and validates directory reversion
    SwiftShell("rm \(newFile).txt")
    let listFinal = SwiftShell("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("MV: File") func  moveFile () async throws {
    // lists working directory contents
    let listStart = SwiftShell("ls -p")
    
    // creates unique names for temporary file and directory
    var newDirectory = "mvDirectory"
    var newFile = "mvFile"
    while listStart.contains("\(newDirectory)/") || listStart.contains("\(newFile).txt") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory and newFile creation
    SwiftShell("mkdir \(newDirectory)")
    SwiftShell("touch \(newFile).txt")
    let listUpdate = SwiftShell("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // moves newFile into newDirectory and validates move
    SwiftShell("mv \(newFile).txt \(newDirectory)/")
    let listNewDirectory = SwiftShell("ls \(newDirectory)/")
    #expect(listNewDirectory == "\(newFile).txt\n")
    
    // deletes newDirectory and validates directory reversion
    SwiftShell("rm -rf \(newDirectory)")
    let listFinal = SwiftShell("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("CP: File") func copyingFile() async throws {
    // lists working directory contents
    let listStart = SwiftShell("ls")
    
    // creates unique name for temporary files
    var newFile = "toCopy"
    var copyFile = "copy"
    while listStart.contains("\(newFile).txt") || listStart.contains("\(copyFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
        copyFile = "\(copyFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    SwiftShell("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = SwiftShell("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    let fileContents = SwiftShell("cat \(newFile).txt")
    #expect(fileContents == "Hello, World!\n")
    
    // copies newFile and validates copyFile contents
    SwiftShell("cp \(newFile).txt \(copyFile).txt")
    let listCopyUpdate = SwiftShell("ls")
    try #require(listCopyUpdate.contains("\(copyFile).txt"))
    let copyContents = SwiftShell("cat \(copyFile).txt")
    #expect(copyContents == "Hello, World!\n")
    
    // deletes newFile and copyFile and validates directory reversion
    SwiftShell("rm \(newFile).txt \(copyFile).txt")
    let listFinal = SwiftShell("ls")
    #expect(
        listFinal.contains("\(newFile).txt") == false &&
        listFinal.contains("\(copyFile).txt") == false
    )
}

/*
 @Test("CD: Directory") func testChangingDirectory() async throws {
 let workingPath = SwiftShell("pwd")
 print("Working Path: "+workingPath)
 let cdCommand = SwiftShell("cd ../../")
 print("Cd Command: "+cdCommand)
 let newWorkingPath = SwiftShell("pwd")
 print("New Working Path: "+newWorkingPath)
 
 }
 */
