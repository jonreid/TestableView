import SwiftUI

struct ContentView: TestableView {
    @State private var count = 0
    var viewInspectorHook: ((ContentView) -> Void)?

    var body: some View {
        VStack {
            Text("\(count)").id("count")
            Button("+1") {
                count += 1
            }
            .id("increment")
            .padding()
        }
        .onAppear { self.viewInspectorHook?(self) }
    }
}

#Preview {
    ContentView()
}
