import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = PDFSplitterViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Drop Zone / File Info
            DropZoneView(viewModel: viewModel)
                .frame(height: 200)

            if viewModel.selectedFile != nil {
                // File Info Display
                FileInfoView(viewModel: viewModel)

                Divider()

                // Split Options Panel
                SplitOptionsView(viewModel: viewModel)

                // Blank Page Removal Option
                Toggle("Remove blank pages", isOn: $viewModel.removeBlankPages)
                    .toggleStyle(.checkbox)

                Divider()

                // Split Button
                Button(action: {
                    Task {
                        await viewModel.splitPDF()
                    }
                }) {
                    Text("Split PDF")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isProcessing)

                // Progress Bar
                if viewModel.isProcessing {
                    ProgressView(value: viewModel.progress) {
                        Text("Processing: \(Int(viewModel.progress * 100))%")
                    }
                }

                // Results
                if let resultMessage = viewModel.resultMessage {
                    Text(resultMessage)
                        .foregroundColor(viewModel.hasError ? .red : .green)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(30)
        .frame(width: 500)
    }
}

struct DropZoneView: View {
    @ObservedObject var viewModel: PDFSplitterViewModel
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isDragging ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: [10])
                        )
                        .foregroundColor(isDragging ? .accentColor : .gray)
                )

            VStack(spacing: 12) {
                Image(systemName: "doc.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.gray)

                Text(viewModel.selectedFile?.lastPathComponent ?? "Drag & Drop PDF Here")
                    .font(.headline)

                if viewModel.selectedFile == nil {
                    Text("or click to browse")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
            return true
        }
        .onTapGesture {
            selectFile()
        }
    }

    private func handleDrop(providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }

        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil),
                  url.pathExtension.lowercased() == "pdf" else {
                return
            }

            DispatchQueue.main.async {
                viewModel.loadPDF(url: url)
            }
        }
    }

    private func selectFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            viewModel.loadPDF(url: url)
        }
    }
}

struct FileInfoView: View {
    @ObservedObject var viewModel: PDFSplitterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Pages:")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.totalPages)")
            }

            HStack {
                Text("Size:")
                    .fontWeight(.semibold)
                Spacer()
                Text(viewModel.fileSize)
            }

            if viewModel.removeBlankPages && viewModel.blankPagesCount > 0 {
                HStack {
                    Text("Blank pages:")
                        .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.blankPagesCount)")
                    .foregroundColor(.orange)
            }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct SplitOptionsView: View {
    @ObservedObject var viewModel: PDFSplitterViewModel

    let presets = [5, 10, 25, 50]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pages per chunk:")
                .fontWeight(.semibold)

            HStack(spacing: 12) {
                ForEach(presets, id: \.self) { preset in
                    Button(action: {
                        viewModel.pagesPerChunk = preset
                    }) {
                        Text("\(preset)")
                            .frame(width: 50)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .background(viewModel.pagesPerChunk == preset ? Color.accentColor.opacity(0.2) : Color.clear)
                    .cornerRadius(6)
                }

                Spacer()

                TextField("Custom", value: $viewModel.pagesPerChunk, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }
        }
    }
}
