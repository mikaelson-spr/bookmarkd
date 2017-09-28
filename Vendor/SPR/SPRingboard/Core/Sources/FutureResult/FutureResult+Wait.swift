// SPRingboard
// Copyright (c) 2017 SPRI, LLC <info@spr.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.


public extension FutureResult {
    
    /// Create a future result that is filled when either provided future 
    /// result is filled with a failure or when both provided results are
    /// filled with success.
    public static func wait<A,B>(a: FutureResult<A>, b: FutureResult<B>) -> FutureResult<(a:A,b:B)> {
        let deferred = DeferredResult<(a:A,b:B)>()
        
        a.then { (resultA: Result<A>) in
            switch resultA {
            case .failure(let error):
                deferred.fill(result: .failure(error))
            case .success(let valueA):
                b.then { (resultB: Result<B>) in
                    switch resultB {
                    case .failure(let error):
                        deferred.fill(result: .failure(error))
                    case .success(let valueB):
                        let tuple = (a: valueA, b: valueB)
                        deferred.fill(value: tuple)
                    }
                }
            }
        }
        
        return deferred
    }
    
    /// Create a future result that is filled when any provided future result
    /// is filled with a failure or when all provided results are filled with 
    /// success.
    public static func wait<A,B,C>(a: FutureResult<A>, b: FutureResult<B>, c: FutureResult<C>) -> FutureResult<(a:A,b:B,c:C)> {
        let deferred = DeferredResult<(a:A,b:B,c:C)>()
        
        a.then { (resultA: Result<A>) in
            switch resultA {
            case .failure(let error):
                deferred.fill(result: .failure(error))
            case .success(let valueA):
                b.then { (resultB: Result<B>) in
                    switch resultB {
                    case .failure(let error):
                        deferred.fill(result: .failure(error))
                    case .success(let valueB):
                        c.then { (resultC: Result<C>) in
                            switch resultC {
                            case .failure(let error):
                                deferred.fill(result: .failure(error))
                            case .success(let valueC):
                                let tuple = (a: valueA, b: valueB, c: valueC)
                                deferred.fill(value: tuple)
                            }
                        }
                    }
                }
            }
        }
        
        return deferred
    }
    
}
