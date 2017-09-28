# Result

Asynchronous operations cannot make use of Swift's built-in error handling
using `throws`, so it is necessary for asynchronous completion handlers to
accept both successful outcomes and errors indicating failure. 


## Result Type

The `Result` enumeration has `success` and `failure` cases that each support an
associated type holding the operation's successful output or the error that
caused the operation to fail. The `Result` type is fundamental to all of the
other asynchronous components included in this module. 

`Result` allows us to convert code like: 

    // yuck
    
    // Define asynchronous function
    func doSomethingAsynchronously(completion: @escaping (Int?, Error?) -> Void) {
        // ...
    }
    
    // Call asynchronous function
    doSomethingAsynchronously { (value: Int?, error: Error?) in 
        if let error = error {
            // handle error
        } else if let value = value {
            // handle value
        } else {
            // huh. what to do here?
        }
    } 

to code like:
    
    // Define asynchronous function
    func doSomethingAsynchronously(completion: @escaping (Result<Int>) -> Void) {
        // ...
    }
    
    // Call asynchronous function
    doSomethingAsynchronously { (result: Result<Int>) in 
        switch result {
        case .success(let value):
            // handle value
        case .failure(let error):
            // handle error
        }
    } 

## ResultHandler

Since the `(Result<T>) -> Void` type gets used so frequently when writing 
asynchronous code that generates `Result`s, the it the `ResultHandler<T>` type 
alias has been defined. Using `ResultHandler`, we could have written the 
`doSomethingAsynchronously` method parameters as:

    func doSomethingAsynchronously(completion: @escaping ResultHandler<Int>)
