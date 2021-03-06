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


fileprivate let uponQueue = DispatchQueue.global(qos: .utility)


public extension FutureResult {
    
    public func filter<E>(_ isIncluded: @escaping (E) throws -> Bool) -> FutureResult<[E]> where SuccessValue: Sequence, E == SuccessValue.Iterator.Element {
        let future = self.then(upon: uponQueue) { (sequence) throws -> [E] in
            let array = try sequence.filter(isIncluded)
            return array
        }
        return future
    }
    
    public func flatMap<E,T>(_ transform: @escaping (E) throws -> T?) -> FutureResult<[T]> where SuccessValue: Sequence, E == SuccessValue.Iterator.Element {
        let future = self.then(upon: uponQueue) { (sequence) throws -> [T] in
            let array = try sequence.flatMap(transform)
            return array
        }
        return future
    }
    
    public func map<E,T>(_ transform: @escaping (E) throws -> T) -> FutureResult<[T]> where SuccessValue: Sequence, E == SuccessValue.Iterator.Element {
        let future = self.then(upon: uponQueue) { (sequence) throws -> [T] in
            let array = try sequence.map(transform)
            return array
        }
        return future
    }
    
    public func reduce<E,T>(_ initialResult: T, _ nextPartialResult: @escaping (T, E) throws -> T) -> FutureResult<T> where SuccessValue: Sequence, E == SuccessValue.Iterator.Element {
        let future = self.then(upon: uponQueue) { (sequence) throws -> T in
            let reduced = try sequence.reduce(initialResult, nextPartialResult)
            return reduced
        }
        return future
    }
    
}
