@testable import Counter
import XCTest
import ViewInspector

final class ContentViewTests: XCTestCase {
    @MainActor
    func test_initialCount() throws {
        let sut = ContentView()

        let count = try sut.inspect().find(viewWithId: "count").text().string()

        XCTAssertEqual(count, "0")
    }

    // begin-snippet: with_boilerplate
    @MainActor
    func test_incrementOnce_withBoilerplate() throws {
        var sut = ContentView()
        let expectation = sut.on(\.viewInspectorHook) { view in
            try view.find(viewWithId: "increment").button().tap()
            let count = try view.find(viewWithId: "count").text().string()
            XCTAssertEqual(count, "1")
        }
        ViewHosting.host(view: sut)
        wait(for: [expectation], timeout: 0.2)
    }
    // end-snippet

    // begin-snippet: with_testable_view
    @MainActor
    func test_incrementOnce_withTestableView() throws {
        var sut = ContentView()
        inspectChangingView(&sut) { view in
            try view.find(viewWithId: "increment").button().tap()
            let count = try view.find(viewWithId: "count").text().string()
            XCTAssertEqual(count, "1")
        }
    }
    // end-snippet

    // begin-snippet: scannable
    @MainActor
    func test_incrementOnce_scannable() throws {
        var sut = ContentView()
        var count: String?

        inspectChangingView(&sut) { view in
            try view.find(viewWithId: "increment").button().tap()
            count = try view.find(viewWithId: "count").text().string()
        }

        XCTAssertEqual(count, "1")
    }
    // end-snippet
}
