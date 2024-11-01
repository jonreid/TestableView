// TestableView by Jon Reid, https://qualitycoding.org
// Copyright 2024 Jonathan M. Reid. https://github.com/jonreid/TestableView/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

@testable import Counter
import ViewInspector
import XCTest

extension XCTestCase {
    @MainActor func inspectChangingView<V: TestableView>(
        _ sut: inout V,
        actionCapturingResult: @escaping ((InspectableView<ViewType.View<V>>) throws -> Void),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectation = sut.on(\.viewInspectorHook, file: file, line: line, perform: actionCapturingResult)
        ViewHosting.host(view: sut)
        wait(for: [expectation], timeout: 0.4)
    }
}
