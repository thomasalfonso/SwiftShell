import Testing
@testable import SwiftShell

@Test("ECHO: Output") func textOutput() async throws {
    // tests echo terminal output
    let shell = SwiftShell()
    let output = shell.run("echo 'Hello, World!'")
    let expected = "Hello, World!\n"
    #expect(output == expected)
}

@Test("LS: Directory") func list() async throws {
    // lists user directory and searches for Desktop
    let shell = SwiftShell()
    let userFiles = shell.run("ls ~/")
    #expect(userFiles.contains("Desktop"))
}

@Test("MKDIR & RM: Directory") func makeRemoveDirectory() async throws {
    // lists working directory contents
    let shell = SwiftShell()
    let listStart = shell.run("ls -p")
    
    // creates unique name for temporary directory
    var newDirectory = "directory"
    while listStart.contains("\(newDirectory)/") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory creation
    shell.run("mkdir \(newDirectory)")
    let  listUpdate = shell.run("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    
    // deletes newDirectory and validates directory reversion
    shell.run("rm -rf \(newDirectory)")
    let listFinal = shell.run("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("TOUCH & RM: File") func  makeRemoveFile () async throws {
    // lists working directory contents
    let shell = SwiftShell()
    let listStart = shell.run("ls")
    
    // creates unique name for temporary file
    var newFile = "file"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    shell.run("touch \(newFile).txt")
    let listUpdate = shell.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // deletes newDirectory and validates directory reversion
    shell.run("rm \(newFile).txt")
    let listFinal = shell.run("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("CAT: Viewing") func  catFile () async throws {
    // lists working directory contents
    let shell = SwiftShell()
    let listStart = shell.run("ls")
    
    // creates unique name for temporary file
    var newFile = "catFile"
    while listStart.contains("\(newFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    shell.run("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = shell.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // retrieves and validates newFile contents
    let contents = shell.run("cat \(newFile).txt")
    let expected = "Hello, World!\n"
    #expect(contents == expected)
    
    // deletes newFile and validates directory reversion
    shell.run("rm \(newFile).txt")
    let listFinal = shell.run("ls")
    #expect(listFinal.contains("\(newFile).txt") == false)
}

@Test("MV: File") func  moveFile () async throws {
    // lists working directory contents
    let shell = SwiftShell()
    let listStart = shell.run("ls -p")
    
    // creates unique names for temporary file and directory
    var newDirectory = "mvDirectory"
    var newFile = "mvFile"
    while listStart.contains("\(newDirectory)/") || listStart.contains("\(newFile).txt") {
        newDirectory = "\(newDirectory)\(Int.random(in: 1...9))"
        newFile = "\(newFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newDirectory and newFile creation
    shell.run("mkdir \(newDirectory)")
    shell.run("touch \(newFile).txt")
    let listUpdate = shell.run("ls -p")
    try #require(listUpdate.contains("\(newDirectory)/"))
    try #require(listUpdate.contains("\(newFile).txt"))
    
    // moves newFile into newDirectory and validates move
    shell.run("mv \(newFile).txt \(newDirectory)/")
    let listNewDirectory = shell.run("ls \(newDirectory)/")
    #expect(listNewDirectory == "\(newFile).txt\n")
    
    // deletes newDirectory and validates directory reversion
    shell.run("rm -rf \(newDirectory)")
    let listFinal = shell.run("ls -p")
    #expect(listFinal.contains("\(newDirectory)/") == false)
}

@Test("CP: File") func copyingFile() async throws {
    // lists working directory contents
    let shell = SwiftShell()
    let listStart = shell.run("ls")
    
    // creates unique name for temporary files
    var newFile = "toCopy"
    var copyFile = "copy"
    while listStart.contains("\(newFile).txt") || listStart.contains("\(copyFile).txt") {
        newFile = "\(newFile)\(Int.random(in: 1...9))"
        copyFile = "\(copyFile)\(Int.random(in: 1...9))"
    }
    
    // initiates and validates newFile creation
    shell.run("echo \"Hello, World!\" >> \(newFile).txt")
    let listUpdate = shell.run("ls")
    try #require(listUpdate.contains("\(newFile).txt"))
    let fileContents = shell.run("cat \(newFile).txt")
    #expect(fileContents == "Hello, World!\n")
    
    // copies newFile and validates copyFile contents
    shell.run("cp \(newFile).txt \(copyFile).txt")
    let listCopyUpdate = shell.run("ls")
    try #require(listCopyUpdate.contains("\(copyFile).txt"))
    let copyContents = shell.run("cat \(copyFile).txt")
    #expect(copyContents == "Hello, World!\n")
    
    // deletes newFile and copyFile and validates directory reversion
    shell.run("rm \(newFile).txt \(copyFile).txt")
    let listFinal = shell.run("ls")
    #expect(
        listFinal.contains("\(newFile).txt") == false &&
        listFinal.contains("\(copyFile).txt") == false
    )
}


@Test("CD: Directory") func testChangingDirectory() async throws {
    // stores working directory
    let shell = SwiftShell()
    let pathStart = shell.run("pwd")
    
    // initiates and validates navigation to parent folder
    shell.run("cd ../")
    let pathUpdate = shell.run("pwd")
    #expect(pathStart != pathUpdate)
    
    // validates directory navigation and reversion
    shell.run("cd \(pathStart)")
    let pathFinal = shell.run("pwd")
    #expect(pathStart == pathFinal)
}
