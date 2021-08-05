//
//  XCTestCase+MemoryLeakTracking.swift
//  SalahTimesTests
//
//  Created by Suhayl Ahmed on 05/08/2021.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
}
