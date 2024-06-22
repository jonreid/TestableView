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

    @MainActor
    func test_incrementOnce_withBoilerplate() throws {
        var sut = ContentView()
        let expectation = sut.on(\.viewInspectorHook) { view in
            try view.find(viewWithId: "increment").button().tap()
            let count = try view.find(viewWithId: "count").text().string()
            XCTAssertEqual(count, "1")
        }
        ViewHosting.host(view: sut)
        wait(for: [expectation], timeout: 0.01)
    }

    @MainActor
    func test_incrementOnce_withTestableView() throws {
        var sut = ContentView()
        update(&sut) { view in
            try view.find(viewWithId: "increment").button().tap()
            let count = try view.find(viewWithId: "count").text().string()
            XCTAssertEqual(count, "1")
        }
    }

    @MainActor
    func test_incrementOnce_scannable() throws {
        var sut = ContentView()
        var count: String?

        update(&sut) { view in
            try view.find(viewWithId: "increment").button().tap()
            count = try view.find(viewWithId: "count").text().string()
        }

        XCTAssertEqual(count, "1")
    }
}
