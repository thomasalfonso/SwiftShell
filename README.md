# SwiftShell

SwiftShell is a Swift library that empowers Swift applications to interact with a system’s default shell. Implementing the library allows developers to send system commands directly to a shell executable, where the commands will be interpreted, actioned, and the standard output processed and delivered within the Swift application.  

### Purpose

Apple’s existing Swift frameworks offer limited functionality when it comes to sending and receiving data through shell interfaces. SwiftShell enhances this by providing a robust, concise API for implementing system commands, unlocking a wide range of possibilities for accomplishing programmatic goals.


### Getting Started:

Add SwiftShell dependency details to *package.swift*

```swift
import PackageDescription

let package = Package(
    name: {your package name},
    dependencies: [
        .package(url: "https://github.com/thomasalfonso/SwiftShell.git", branch: "main" ),
    ],
    targets: [
        .executableTarget(
            name: {your executable name},
            dependencies: [
                .product(name: "SwiftShell", package: "SwiftShell"),
            ]
        ),
    ]
)
```

Import library

```swift 
import SwiftShell
```

Instantiate SwiftShell and issue commands 
```swift
let shell = SwiftShell()
shell.run("touch newFile.txt")
```

With the information provided by the previous code snippets, you should be able to use SwiftShell as intended. If there are any issues, please raise a ticket. 





### More Code Examples

Receiving standard output from shell by using *echo*

```swift
    import SwiftShell

    let shell = SwiftShell()
    let output = shell.run("echo 'Hello, World!'")
    print(output) // prints "Hello, World!\n" 
```

Checking user directory contents with *ls*
```swift
    import SwiftShell
    
    let shell = SwiftShell()
    let userFiles = shell.run("ls ~/")
    userFiles.contains("Desktop") // true
```

Using Swift string interpolation with shell commands
```swift
    import SwiftShell

    let shell = SwiftShell()
    let newFile = "catFile"
    shell.run("echo \"Hello, World!\" >> \(newFile).txt")
    let contents = shell.run("cat \(newFile).txt")
    print(contents) // prints "Hello, World!\n"
```

To see more examples of library usage check SwiftShellTests attached to this package. The tests contain many more basic shell commands being used. 

### Limitations

To find the default system shell of the system, an environment variable containing the path to the shell is read from the process running the Swift software. If the preferred system shell is not running the application process then its executable address will not be provided to SwiftShell, thus commands provided to SwiftShell will not be provided to the preferred shell interface. 
