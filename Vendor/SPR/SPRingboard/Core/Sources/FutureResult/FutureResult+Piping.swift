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

import Dispatch


public extension FutureResult {
    
    public func then<NextValue>(upon queue: DispatchQueue = .main, pipeInto nextStep: @escaping (SuccessValue) throws -> NextValue) -> FutureResult<NextValue> {
        let deferred = DeferredResult<NextValue>()
        
        let block = { (result: Result<SuccessValue>) in
            switch result {
            case .success(let value):
                do {
                    let nextValue = try nextStep(value)
                    deferred.fill(result: .success(nextValue))
                } catch (let error) {
                    deferred.fill(result: .failure(error))
                }
            case .failure(let error):
                deferred.fill(result: .failure(error))
            }
        }
        self.then(upon: queue, handleResult: block)
        
        return deferred
    }

    public func then<NextValue>(upon queue: DispatchQueue = .main, pipeInto nextStep: @escaping (SuccessValue) -> Future<NextValue>) -> FutureResult<NextValue> {
        let deferred = DeferredResult<NextValue>()
        
        let block = { (result: Result<SuccessValue>) in
            switch result {
            case .success(let value):
                let future = nextStep(value)
                future.then { (nextValue) -> Void in
                    deferred.fill(result: .success(nextValue))
                }
            case .failure(let error):
                deferred.fill(result: .failure(error))
            }
        }
        self.then(upon: queue, handleResult: block)
        
        return deferred
    }
    
    public func then<NextValue>(upon queue: DispatchQueue = .main, pipeInto nextStep: @escaping (SuccessValue) -> FutureResult<NextValue>) -> FutureResult<NextValue> {
        let deferred = DeferredResult<NextValue>()
        
        let block = { (result: Result<SuccessValue>) in
            switch result {
            case .success(let value):
                let futureResult = nextStep(value)
                futureResult.then { (nextResult) -> Void in
                    deferred.fill(result: nextResult)
                }
            case .failure(let error):
                deferred.fill(result: .failure(error))
            }
        }
        self.then(upon: queue, handleResult: block)
        
        return deferred
    }
    
}
