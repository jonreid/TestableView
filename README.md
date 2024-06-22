# TestableView

[![Mastodon Follow](https://img.shields.io/mastodon/follow/109765011064804734?domain=https%3A%2F%2Fiosdev.space
)](https://iosdev.space/@qcoding)

When using [ViewInspector](https://github.com/nalexn/ViewInspector/) to unit test a SwiftUI View that uses `@State` or `@Environment`, the [simplest approach](https://github.com/nalexn/ViewInspector/blob/0.10.0/guide.md#views-using-state-environment-or-environmentobject) is to add a hook called on `didAppear`. The test then:

- wraps a closure into that hook,
- creates an XCTestExpectation so the test can wait for the hook,
- mounts the View, and
- waits for the closure to run.

```swift
@MainActor
func test_incrementOnce() throws {
    var sut = ContentView()
    let expectation = sut.on(\.viewInspectorHook) { view in
        try view.find(viewWithId: "increment").button().tap()
        let count = try view.find(viewWithId: "count").text().string()
        XCTAssertEqual(count, "1")
    }
    ViewHosting.host(view: sut)
    wait(for: [expectation], timeout: 0.01)
}
```

That's a lot of boilerplate, and it makes it harder to scan for the test intent.

[UpdateTestableView.swift](https://github.com/jonreid/TestableView/blob/main/UpdateTestableView.swift) provides an XCTestCase extension to take care of that boilerplate.

## Adding it to your project

The new XCTestCase method relies on a TestableView type to define the hook for ViewInspector. So you need to use one file in your production code, and one file in your test code.

### Production code

1. Copy [TestableView.swift](https://github.com/jonreid/TestableView/blob/main/TestableView.swift) into your production code.
2. Redefine your View as a `TestableView`. Xcode will tell you how to define your hook property.
3. Make sure to call the hook at the end of your view:

```swift
.onAppear { self.viewInspectorHook?(self) }
```

### Test code

1. Copy [UpdateTestableView.swift](https://github.com/jonreid/TestableView/blob/main/UpdateTestableView.swift) into your test code.
2. Change the `YourModule` placeholder so it does an `@testable import` from the module that defines `TestableView`.

## Use it in your test

Now our test can call `update(_:action:)`:

```swift
@MainActor
func test_incrementOnce() throws {
    var sut = ContentView()
    update(&sut) { view in
        try view.find(viewWithId: "increment").button().tap()
        let count = try view.find(viewWithId: "count").text().string()
        XCTAssertEqual(count, "1")
    }
}
```

## Author

Jon Reid is the author of _[iOS Unit Testing by Example](https://iosunittestingbyexample.com)._ His website is [Quality Coding](https://qualitycoding.org).