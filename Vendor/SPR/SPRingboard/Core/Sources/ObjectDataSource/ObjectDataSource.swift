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

import Foundation


/// `ObjectDataSource` provides an implementation-agnostic adapter for managing
/// object collections generated by underlying data storage technologies. The
/// `ObjectDataSource` API is designed for ease of use within
/// `UICollectionViewDataSource` and `UITableViewDataSource` implementations.
///
/// This API promotes decoupling of `UIViewController`s from the app's data
/// storage technology. The app's middle tier should return `ObjectDataSource`
/// objects instead of storage-specific results such as `FMResultSet` (SQLite)
/// or `NSFetchedResultsController` (Core Data).
///
/// Decoupling the the data storage technology from the app's
/// `UIViewController` objects has proven useful for projects that require
/// development to start before the service API or domain model contracts are
/// defined and for projects that experience a significant change in service
/// API or domain modeling that requires a different storage technology for
/// performance or proper domain mapping. For example, apps using this protocol
/// as part of decoupling data access tier are able to change their storage
/// technologies between Core Data, SQLite, Realm.io, Cloudant CDTDatastore, or
/// fixtured data without touching the code in `UIViewControllers`.
///
/// `ObjectDataSource` is defined as a class instead of a protocol because it
/// is easier to read and maintain Swift code that uses generic classes than
/// code that uses protocols with associated types. The root implementation
/// reports that it has 0 sections and 0 rows in each section, it returns `nil`
/// for section titles, and `objectAt` throws an `Error.invalidIndexPath`
/// error.
open class ObjectDataSource<ObjectType> {
    
    /// Shared error types for ObjectDataSource implementations.
    public enum Error: Swift.Error {
        
        /// The caller requested an object for a row that does not exist.
        case invalidIndexPath(IndexPath)
        
        /// The backing data storage solution is unable to provide the object
        /// for a valid index path.
        case objectUnavailable(IndexPath)
    }
    
    /// Public initializer for subclasses to call. By default, the initializer
    /// would be `internal`.
    ///
    /// In _The Swift Programming Language (Swift 4)_ book, see Access Control
    /// > Initializers > Default Initializers for more information.
    public init() { }
    
    /// Returns the number of objects (rows) in the section.
    ///
    /// - Parameter inSection: A 0-based index identifying the section.
    ///
    /// - Returns: A positive integer indicating the number of objects in the
    ///   specified section, or `0` if no objects are in the section.
    open func numberOfObjectsInSection(_ section: Int) -> Int {
        return 0
    }
    
    /// Returns the number of sections in this data source.
    ///
    /// - Returns: A positive integer indicating the number of section in this
    ///   data source, or `0` if there are no sections.
    open func numberOfSections() -> Int {
        return 0
    }
    
    /// Returns the object at the given index path in the object list.
    ///
    /// - Parameter indexPath: An IndexPath containing the section and row of
    ///   the object to be retrieved.
    ///
    /// - Throws:
    ///   - `Error.invalidIndexPath` if `indexPath` does not describe a valid
    ///     section and row in the data source.
    ///   - `Error.objectUnavailable` if the specified object could not be
    ///     loaded from the underlying data storage for any reason.
    ///   - Other errors as appropriate.
    ///
    /// - Returns: The object at a given index path in the object list.
    open func objectAt(_ indexPath: IndexPath) throws -> ObjectType {
        throw Error.invalidIndexPath(indexPath)
    }
    
    /// Returns the title of a section, or `nil` if the section has no title.
    ///
    /// - Parameter section: A 0-based index identifying the section.
    ///
    /// - Returns: A string containing the title of the section, or `nil` if
    ///   the section does not have a name.
    open func titleOfSection(_ section: Int) -> String? {
        return nil
    }
    
}

