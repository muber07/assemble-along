import SwiftUI
import UIKit
import CoreMotion

@main
struct AssembleAlongApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    @State private var projects = [AssemblyProject.bookcase]
    @State private var showNewAssembly = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(projects) { project in
                        NavigationLink(value: project) { ProjectRow(project: project) }
                    }
                } header: {
                    Text("My assemblies")
                }
            }
            .navigationTitle("Assemble Along")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showNewAssembly = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Start an assembly")
                }
            }
            .navigationDestination(for: AssemblyProject.self) { AssemblyDetailView(project: $0) }
            .sheet(isPresented: $showNewAssembly) {
                NewAssemblyView { project in
                    projects.insert(project, at: 0)
                    showNewAssembly = false
                }
            }
        }
        .tint(.assembleGreen)
    }
}

struct ProjectRow: View {
    let project: AssemblyProject
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: project.symbol).font(.title2).foregroundStyle(.brown)
                .frame(width: 48, height: 52).background(Color.assembleSand).clipShape(RoundedRectangle(cornerRadius: 13))
            VStack(alignment: .leading, spacing: 4) {
                Text(project.name).font(.headline)
                Text(project.status).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(project.completedSteps)/\(project.steps.count)").font(.caption.weight(.bold)).foregroundStyle(.assembleGreen)
        }
        .padding(.vertical, 4)
    }
}

struct NewAssemblyView: View {
    let onComplete: (AssemblyProject) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImage: UIImage?
    @State private var source: CaptureSource?
    @State private var productURL = ""
    @State private var didIdentify = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(didIdentify ? "We found your item" : "What do you have?")
                        .font(.largeTitle.bold())
                    Text(didIdentify ? "Confirm the match, then we’ll get your build ready." : "Start with the easiest clue. The manual can come later.")
                        .foregroundStyle(.secondary)
                    if didIdentify { matchCard } else { sourceOptions }
                }
                .padding(20)
            }
            .navigationTitle("New assembly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } } }
            .sheet(item: $source) { selection in
                CameraPicker(source: selection == .library ? .photoLibrary : .camera) { image in
                    selectedImage = image
                    didIdentify = image != nil
                }
            }
        }
    }

    private var sourceOptions: some View {
        VStack(spacing: 12) {
            SourceOption(icon: "camera.fill", title: "Take a photo", subtitle: "Box, label, barcode, or item") { source = .camera }
            SourceOption(icon: "link", title: "Paste a product link", subtitle: "From a retailer or manufacturer") { }
            TextField("https://…", text: $productURL).textInputAutocapitalization(.never).keyboardType(.URL).textFieldStyle(.roundedBorder)
            Button("Find product") { if !productURL.isEmpty { didIdentify = true } }.buttonStyle(.borderedProminent).disabled(productURL.isEmpty)
            SourceOption(icon: "doc.text.viewfinder", title: "Scan a receipt", subtitle: "We’ll identify the purchased item") { source = .receipt }
            SourceOption(icon: "doc.fill", title: "Add a manual", subtitle: "PDF or photos of the pages") { source = .library }
        }
    }

    private var matchCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Group {
                    if let selectedImage { Image(uiImage: selectedImage).resizable().scaledToFill() }
                    else { Image(systemName: "books.vertical.fill").font(.system(size: 34)).foregroundStyle(.brown) }
                }
                .frame(width: 70, height: 76).background(Color.assembleSand).clipShape(RoundedRectangle(cornerRadius: 14))
                VStack(alignment: .leading) {
                    Text("Scandi Oak Bookcase").font(.headline)
                    Text("High-confidence match · 98%").font(.caption.weight(.semibold)).foregroundStyle(.assembleGreen)
                }
            }
            .padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 20)).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.16)))
            Label("Official manual found", systemImage: "checkmark.seal.fill").font(.subheadline.weight(.semibold)).foregroundStyle(.assembleGreen)
            Text("7 build steps · 31-piece parts list").foregroundStyle(.secondary)
            Button("Yes, set up my build") { onComplete(.bookcase) }.buttonStyle(PrimaryButtonStyle())
            Button("This isn’t my item") { didIdentify = false }.frame(maxWidth: .infinity)
        }
    }
}

struct AssemblyDetailView: View {
    let project: AssemblyProject
    @State private var step = 2
    var body: some View {
        TabView {
            BuildView(project: project, step: $step).tabItem { Label("Build", systemImage: "hammer.fill") }
            PartsView(project: project).tabItem { Label("Parts", systemImage: "square.grid.2x2") }
            LevelView().tabItem { Label("Level", systemImage: "level") }
        }
        .navigationTitle(project.name).navigationBarTitleDisplayMode(.inline)
    }
}

struct BuildView: View {
    let project: AssemblyProject
    @Binding var step: Int
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("STEP \(step + 1) OF \(project.steps.count)").font(.caption.weight(.bold)).foregroundStyle(.assembleGreen)
                Text(project.steps[step].title).font(.largeTitle.bold())
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 24).fill(Color.assembleCanvas).frame(height: 280)
                    Image(systemName: "books.vertical.fill").font(.system(size: 145)).foregroundStyle(.brown).frame(maxWidth: .infinity, minHeight: 280)
                    Text("3D guide").font(.caption.weight(.bold)).padding(9).background(Color.assembleLime).clipShape(RoundedRectangle(cornerRadius: 9)).padding(15)
                }
                VStack(alignment: .leading, spacing: 7) {
                    Text(project.steps[step].instruction).font(.headline)
                    Text(project.steps[step].detail).foregroundStyle(.secondary)
                    Label("Need: \(project.steps[step].parts)", systemImage: "wrench.and.screwdriver").font(.subheadline.weight(.medium)).padding(.top, 4)
                }
                .padding().background(Color.assemblePale).clipShape(RoundedRectangle(cornerRadius: 18))
                HStack { Text("\(step + 1) / \(project.steps.count)").foregroundStyle(.secondary); Spacer(); ProgressView(value: Double(step + 1), total: Double(project.steps.count)).tint(.assembleGreen).frame(width: 180) }
                Button(step == project.steps.count - 1 ? "Finish assembly" : "I’ve done this step") { if step < project.steps.count - 1 { step += 1 } }.buttonStyle(PrimaryButtonStyle())
            }.padding(20)
        }
    }
}

struct PartsView: View {
    let project: AssemblyProject
    var body: some View { List(project.parts) { part in HStack { Image(systemName: part.symbol).frame(width: 32).foregroundStyle(.brown); VStack(alignment: .leading) { Text(part.name).fontWeight(.semibold); Text("\(part.expected) expected").font(.caption).foregroundStyle(.secondary) }; Spacer(); Label("\(part.found)", systemImage: part.found == part.expected ? "checkmark.circle.fill" : "exclamationmark.circle.fill").labelStyle(.iconOnly).foregroundStyle(part.found == part.expected ? .assembleGreen : .orange) } }.navigationTitle("Parts check") }
}

struct LevelView: View {
    @StateObject private var motion = LevelMotionManager()
    var body: some View { VStack(alignment: .leading, spacing: 18) { Text("Final check").font(.caption.weight(.bold)).foregroundStyle(.assembleGreen); Text("Make it level").font(.largeTitle.bold()); Text("Place your phone flat on the finished shelf.").foregroundStyle(.secondary); Spacer(); VStack(spacing: 16) { HStack { Text(motion.isLevel ? "Looking good" : "Slightly tilted").font(.headline); Spacer(); Text(String(format: "%.1f°", abs(motion.angle))).monospacedDigit() }; Capsule().fill(Color.black.opacity(0.82)).frame(height: 60).overlay(alignment: .leading) { Circle().fill(Color.assembleLime).frame(width: 34, height: 34).offset(x: 148 + min(65, max(-65, motion.angle * 20))) }.onTapGesture { motion.demoTilt.toggle() }; Text(motion.isLevel ? "Keep the bubble centered." : "Raise the lower side a little.").font(.subheadline).foregroundStyle(.white.opacity(0.75)) }.padding().foregroundStyle(.white).background(Color.assembleDark).clipShape(RoundedRectangle(cornerRadius: 22)); Spacer(); Button("It’s level") { }.buttonStyle(PrimaryButtonStyle()) }.padding(20).onAppear { motion.start() }.onDisappear { motion.stop() } }
}

struct SourceOption: View { let icon, title, subtitle: String; let action: () -> Void; var body: some View { Button(action: action) { HStack(spacing: 14) { Image(systemName: icon).font(.title2).frame(width: 46, height: 46).background(Color.assembleLime.opacity(0.42)).clipShape(RoundedRectangle(cornerRadius: 13)); VStack(alignment: .leading, spacing: 3) { Text(title).fontWeight(.semibold); Text(subtitle).font(.caption).foregroundStyle(.secondary) }; Spacer(); Image(systemName: "chevron.right").foregroundStyle(.tertiary) }.padding().background(.background).clipShape(RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.gray.opacity(0.15))) }.buttonStyle(.plain) } }
struct PrimaryButtonStyle: ButtonStyle { func makeBody(configuration: Configuration) -> some View { configuration.label.frame(maxWidth: .infinity).padding(16).background(Color.assembleDark).foregroundStyle(.white).clipShape(RoundedRectangle(cornerRadius: 16)).opacity(configuration.isPressed ? 0.75 : 1) } }

enum CaptureSource: String, Identifiable { case camera, receipt, library; var id: String { rawValue } }
struct CameraPicker: UIViewControllerRepresentable { let source: UIImagePickerController.SourceType; let onImage: (UIImage?) -> Void; func makeCoordinator() -> Coordinator { Coordinator(onImage: onImage) }; func makeUIViewController(context: Context) -> UIImagePickerController { let picker = UIImagePickerController(); picker.sourceType = UIImagePickerController.isSourceTypeAvailable(source) ? source : .photoLibrary; picker.delegate = context.coordinator; return picker }; func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {} final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate { let onImage: (UIImage?) -> Void; init(onImage: @escaping (UIImage?) -> Void) { self.onImage = onImage }; func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) { picker.dismiss(animated: true) { self.onImage(info[.originalImage] as? UIImage) } }; func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) { self.onImage(nil) } } } }

final class LevelMotionManager: ObservableObject { @Published var angle: Double = 0; @Published var demoTilt = false { didSet { if demoTilt { angle = 2.2 } } }; private let manager = CMMotionManager(); var isLevel: Bool { abs(angle) < 1.2 }; func start() { guard manager.isDeviceMotionAvailable else { return }; manager.deviceMotionUpdateInterval = 0.1; manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in guard let roll = motion?.attitude.roll else { return }; if !(self?.demoTilt ?? false) { self?.angle = roll * 180 / .pi } } }; func stop() { manager.stopDeviceMotionUpdates() } }

struct AssemblyProject: Identifiable, Hashable { let id = UUID(); let name, symbol, status: String; let completedSteps: Int; let steps: [AssemblyStep]; let parts: [AssemblyPart]; static let bookcase = AssemblyProject(name: "Scandi Oak Bookcase", symbol: "books.vertical.fill", status: "In progress", completedSteps: 2, steps: [.init(title: "Lay out the base", instruction: "Set the two side panels face up.", detail: "Keep the finished edge facing outward.", parts: "2 side panels"), .init(title: "Add the dowels", instruction: "Insert the long dowels into panel A.", detail: "Push each one in until it sits flush.", parts: "12 long dowels"), .init(title: "Attach the left panel", instruction: "Insert 4 cam locks into panel A.", detail: "Match each arrow to the edge hole. Don’t turn them yet.", parts: "4 cam locks"), .init(title: "Secure the right panel", instruction: "Connect panel B to the dowels.", detail: "Turn the cam locks clockwise to secure.", parts: "4 cam locks"), .init(title: "Add the shelves", instruction: "Slide each shelf onto its supports.", detail: "Start with the lowest shelf.", parts: "4 shelves"), .init(title: "Attach the back", instruction: "Nail the back panel in place.", detail: "Keep the frame square while you work.", parts: "24 nails"), .init(title: "Level the bookcase", instruction: "Adjust the feet until the shelf is level.", detail: "Use the level tab for a final check.", parts: "Adjustable feet")], parts: [.init(name: "Side panels", symbol: "rectangle.split.3x1", expected: 2, found: 2), .init(name: "Long dowels", symbol: "minus", expected: 12, found: 12), .init(name: "Cam locks", symbol: "circle.fill", expected: 18, found: 18), .init(name: "Back panel", symbol: "rectangle.portrait", expected: 1, found: 1)]) }
struct AssemblyStep: Hashable { let title, instruction, detail, parts: String }
struct AssemblyPart: Identifiable, Hashable { let id = UUID(); let name, symbol: String; let expected, found: Int }
extension Color { static let assembleGreen = Color(red: 0.24, green: 0.45, blue: 0.20); static let assembleLime = Color(red: 0.84, green: 0.94, blue: 0.41); static let assembleDark = Color(red: 0.12, green: 0.22, blue: 0.20); static let assembleSand = Color(red: 0.92, green: 0.84, blue: 0.74); static let assemblePale = Color(red: 0.94, green: 0.96, blue: 0.87); static let assembleCanvas = Color(red: 0.94, green: 0.93, blue: 0.89) }
