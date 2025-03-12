# SwiftShell

SwiftShell is a Swift library that empowers Swift applications to interact with a system’s default shell. It allows developers to send commands to a command line interface and receive output directly within their Swift applications. 

### Purpose

Apple’s existing Swift frameworks offer limited functionality when it comes to sending and receiving data through shell interfaces. SwiftShell enhances this by providing a robust, concise API for implementing system commands, unlocking a wide range of possibilities for accomplishing programmatic goals.


### Getting Started:
```swift
import SwiftShell
```

### Example Use

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
Due to the requirements of the libraries being leveraged to make SwiftShell, the library is only compatible on macOS systems running 10.15.4 or higher. Other operating systems capable of running Swift will not be able to use SwiftShell.

To find the default system shell of the system, an environment variable containing the path to the shell is read from the process running the Swift software. If the preferred system shell is not running the application process then its executable address will not be provided to SwiftShell, thus commands provided to SwiftShell will not be provided to the preferred shell interface. 



