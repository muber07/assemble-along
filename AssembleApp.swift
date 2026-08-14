import SwiftUI

@main
struct AssembleAlongApp: App {
    var body: some Scene { WindowGroup { AssemblyFlowView() } }
}

struct AssemblyFlowView: View {
    enum Route { case welcome, source, match, parts, build, level, done }
    @State private var route: Route = .welcome
    @State private var isLevel = true

    var body: some View {
        NavigationStack {
            Group {
                switch route {
                case .welcome: welcome
                case .source: source
                case .match: match
                case .parts: parts
                case .build: build
                case .level: level
                case .done: done
                }
            }
            .padding(20)
            .background(Color(.systemGroupedBackground))
        }
    }

    private var welcome: some View { VStack(alignment: .leading) {
        Spacer(); Image(systemName: "shippingbox.fill").font(.system(size: 88)).foregroundStyle(.brown)
        Text("Make it make\nsense.").font(.system(size: 42, weight: .bold, design: .rounded))
        Text("A clear next step for anything you need to assemble.").foregroundStyle(.secondary)
        Spacer(); Button("Start an assembly") { route = .source }.buttonStyle(PrimaryButton())
        Button("Continue my bookcase") { route = .build }.buttonStyle(.borderless)
    } }

    private var source: some View { VStack(alignment: .leading, spacing: 16) {
        Text("NEW ASSEMBLY").font(.caption.weight(.bold)).foregroundStyle(.green)
        Text("What do you have?").font(.largeTitle.bold()); Text("Start with the easiest clue. The manual can come later.").foregroundStyle(.secondary)
        SourceButton(icon: "camera.fill", title: "Take a photo", subtitle: "Box, label, barcode, or item") { route = .match }
        SourceButton(icon: "link", title: "Paste a product link", subtitle: "From a retailer or brand") { route = .match }
        SourceButton(icon: "doc.text.viewfinder", title: "Scan a receipt", subtitle: "We’ll find the purchased item") { route = .match }
        Spacer(); Button("I already have the manual") { route = .match }.frame(maxWidth: .infinity)
    } }

    private var match: some View { VStack(alignment: .leading, spacing: 18) {
        Text("PRODUCT FOUND").font(.caption.weight(.bold)).foregroundStyle(.green); Text("Is this your item?").font(.largeTitle.bold())
        HStack { Image(systemName: "books.vertical.fill").font(.system(size: 48)).foregroundStyle(.brown); VStack(alignment: .leading) { Text("Scandi Oak Bookcase").font(.headline); Text("High-confidence match · 98%").font(.caption).foregroundStyle(.green) } }.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 18))
        Text("Official manual found\n7 build steps · 31-piece parts list").foregroundStyle(.secondary); Spacer()
        Button("Yes, set up my build") { route = .parts }.buttonStyle(PrimaryButton())
    } }

    private var parts: some View { VStack(alignment: .leading) { Text("Before you build").font(.caption.weight(.bold)).foregroundStyle(.green); Text("Let’s check your parts").font(.largeTitle.bold()); Text("Lay everything out. We’ll confirm what’s there before you start.").foregroundStyle(.secondary); List { Label("Side panels · 2 found", systemImage: "rectangle.split.3x1"); Label("Long dowels · 12 found", systemImage: "minus"); Label("Cam locks · 18 found", systemImage: "circle.fill") }.scrollContentBackground(.hidden); Button("Everything is here") { route = .build }.buttonStyle(PrimaryButton()) } }

    private var build: some View { VStack(alignment: .leading) { Text("STEP 3 OF 7").font(.caption.weight(.bold)).foregroundStyle(.green); Text("Attach the left panel").font(.largeTitle.bold()); Spacer(); Image(systemName: "books.vertical.fill").font(.system(size: 150)).foregroundStyle(.brown).frame(maxWidth: .infinity); Text("Insert 4 cam locks into panel A").font(.headline); Text("Match each arrow to the edge hole. Don’t turn them yet.").foregroundStyle(.secondary); Spacer(); Button("I’ve done this step") { route = .level }.buttonStyle(PrimaryButton()) } }

    private var level: some View { VStack(alignment: .leading) { Text("FINAL CHECK").font(.caption.weight(.bold)).foregroundStyle(.green); Text("Make it level").font(.largeTitle.bold()); Text("Place your phone flat on the top shelf.").foregroundStyle(.secondary); Spacer(); VStack { HStack { Text(isLevel ? "Looking good" : "Slightly tilted").bold(); Spacer(); Text(isLevel ? "0.0°" : "1.8°") }; Capsule().fill(.black).frame(height: 56).overlay(Circle().fill(.green).frame(width: 34, height: 34).offset(x: isLevel ? 0 : 24)).onTapGesture { isLevel.toggle() } }.padding().background(Color(red: .12, green: .22, blue: .20)).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 18)); Spacer(); Button("It’s level") { route = .done }.buttonStyle(PrimaryButton()) } }

    private var done: some View { VStack { Spacer(); Image(systemName: "checkmark").font(.system(size: 46, weight: .bold)).foregroundStyle(.black).padding(25).background(.green).clipShape(Circle()); Text("You built it.").font(.largeTitle.bold()).padding(.top); Text("Your Scandi Oak Bookcase is saved, level, and ready to use.").foregroundStyle(.secondary).multilineTextAlignment(.center); Spacer(); Button("Start another assembly") { route = .welcome }.buttonStyle(PrimaryButton()) } }
}

struct SourceButton: View { let icon, title, subtitle: String; let action: () -> Void; var body: some View { Button(action: action) { HStack { Image(systemName: icon).font(.title2).frame(width: 42, height: 42).background(.green.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 12)); VStack(alignment: .leading) { Text(title).fontWeight(.semibold); Text(subtitle).font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "chevron.right").foregroundStyle(.tertiary) }.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 18)) } .buttonStyle(.plain) } }
struct PrimaryButton: ButtonStyle { func makeBody(configuration: Configuration) -> some View { configuration.label.frame(maxWidth: .infinity).padding(16).background(Color(red: .12, green: .22, blue: .20)).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 16)).opacity(configuration.isPressed ? 0.8 : 1) } }
