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


/// An `ObjectDataSource` that represents multiple data sources as a single
/// data source.
///
/// For example, 
public final class ConcatenatingObjectDataSource<ObjectType>: ObjectDataSource<ObjectType> {
    
    private struct SectionBookmark {
        public let objectDataSource: ObjectDataSource<ObjectType>
        public let section: Int
    }
    
    private let bookmarks: [SectionBookmark]
    
    public init(dataSources: [ObjectDataSource<ObjectType>]) {
        var bookmarks: [SectionBookmark] = []
        for ods in dataSources {
            let sectionCount = ods.numberOfSections()
            for sectionIndex in 0..<sectionCount {
                let bookmark = SectionBookmark(objectDataSource: ods, section: sectionIndex)
                bookmarks.append(bookmark)
            }
        }
        self.bookmarks = bookmarks
        
        super.init()
    }
    
    // MARK: ObjectDataSource
    
    public override func numberOfSections() -> Int {
        let count = self.bookmarks.count
        return count
    }
    
    public override func numberOfObjectsInSection(_ section: Int) -> Int {
        let bookmark = self.bookmarks[section]
        let ods = bookmark.objectDataSource
        let odsSection = bookmark.section
        
        let count = ods.numberOfObjectsInSection(odsSection)
        return count
    }
    
    public override func objectAt(_ indexPath: IndexPath) throws -> ObjectType {
        let section = indexPath.section
        
        let bookmark = self.bookmarks[section]
        let ods = bookmark.objectDataSource
        let odsSection = bookmark.section
        
        let odsIndexPath = IndexPath(row: indexPath.row, section: odsSection)
        let object = try ods.objectAt(odsIndexPath)
        return object
    }
    
    public override func titleOfSection(_ section: Int) -> String? {
        let bookmark = self.bookmarks[section]
        let ods = bookmark.objectDataSource
        let odsSection = bookmark.section
        
        let title = ods.titleOfSection(odsSection)
        return title
    }
    
}
