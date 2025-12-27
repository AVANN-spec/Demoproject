import SwiftUI
import PDFKit

@MainActor
class PDFSplitterViewModel: ObservableObject {
    @Published var selectedFile: URL?
    @Published var totalPages: Int = 0
    @Published var fileSize: String = ""
    @Published var pagesPerChunk: Int = 10
    @Published var removeBlankPages: Bool = true
    @Published var blankPagesCount: Int = 0
    @Published var isProcessing: Bool = false
    @Published var progress: Double = 0.0
    @Published var resultMessage: String?
    @Published var hasError: Bool = false

    private var pdfDocument: PDFDocument?

    func loadPDF(url: URL) {
        selectedFile = url
        resultMessage = nil
        hasError = false

        guard let document = PDFDocument(url: url) else {
            resultMessage = "Failed to load PDF"
            hasError = true
            return
        }

        pdfDocument = document
        totalPages = document.pageCount

        // Calculate file size
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = attributes[.size] as? Int64 {
            fileSize = ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
        }

        // Detect blank pages if option is enabled
        if removeBlankPages {
            Task {
                await detectBlankPages()
            }
        }
    }

    func detectBlankPages() async {
        guard let document = pdfDocument else { return }

        var blankCount = 0

        for pageIndex in 0..<document.pageCount {
            guard let page = document.page(at: pageIndex) else { continue }

            if await isPageBlank(page) {
                blankCount += 1
            }
        }

        blankPagesCount = blankCount
    }

    private func isPageBlank(_ page: PDFPage) async -> Bool {
        // Check for text content
        if let text = page.string, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }

        // Check for images/drawings by analyzing page content
        // If page has annotations or drawings, it's not blank
        if page.annotations.count > 0 {
            return false
        }

        // Additional check: render page and analyze pixel data
        let pageRect = page.bounds(for: .mediaBox)
        let scale: CGFloat = 0.5 // Lower resolution for faster processing

        let scaledWidth = Int(pageRect.width * scale)
        let scaledHeight = Int(pageRect.height * scale)

        guard let context = CGContext(
            data: nil,
            width: scaledWidth,
            height: scaledHeight,
            bitsPerComponent: 8,
            bytesPerRow: scaledWidth * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return false
        }

        context.setFillColor(NSColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))

        context.scaleBy(x: scale, y: scale)
        page.draw(with: .mediaBox, to: context)

        guard let data = context.data else { return false }

        // Sample pixels to calculate average brightness
        let pixelCount = scaledWidth * scaledHeight
        let sampleSize = min(1000, pixelCount) // Sample 1000 pixels or less
        let stride = max(1, pixelCount / sampleSize)

        var brightnessSum: Double = 0

        for i in stride(from: 0, to: pixelCount, by: stride) {
            let offset = i * 4
            let r = data.load(fromByteOffset: offset, as: UInt8.self)
            let g = data.load(fromByteOffset: offset + 1, as: UInt8.self)
            let b = data.load(fromByteOffset: offset + 2, as: UInt8.self)

            let brightness = (Double(r) + Double(g) + Double(b)) / (3.0 * 255.0)
            brightnessSum += brightness
        }

        let averageBrightness = brightnessSum / Double(sampleSize)

        // Page is blank if average brightness > 99%
        return averageBrightness > 0.99
    }

    func splitPDF() async {
        guard let document = pdfDocument,
              let sourceURL = selectedFile else {
            return
        }

        isProcessing = true
        progress = 0.0
        resultMessage = nil
        hasError = false

        // Ask user for save location
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.nameFieldStringValue = sourceURL.deletingPathExtension().lastPathComponent + "_split"
        panel.message = "Choose folder to save split PDFs"
        panel.prompt = "Select"

        guard await panel.beginSheetModal(for: NSApp.keyWindow!) == .OK,
              let saveURL = panel.url else {
            isProcessing = false
            return
        }

        // Create output directory
        let outputDir = saveURL
        do {
            try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
        } catch {
            resultMessage = "Failed to create output directory: \(error.localizedDescription)"
            hasError = true
            isProcessing = false
            return
        }

        // Collect non-blank pages
        var validPages: [Int] = []
        for i in 0..<document.pageCount {
            guard let page = document.page(at: i) else { continue }

            if removeBlankPages {
                if await !isPageBlank(page) {
                    validPages.append(i)
                }
            } else {
                validPages.append(i)
            }

            progress = Double(i + 1) / Double(document.pageCount) * 0.3 // 30% for detection
        }

        // Split into chunks
        let chunks = stride(from: 0, to: validPages.count, by: pagesPerChunk).map {
            Array(validPages[$0..<min($0 + pagesPerChunk, validPages.count)])
        }

        var savedFiles = 0

        for (index, chunk) in chunks.enumerated() {
            let newDocument = PDFDocument()

            for (pagePosition, originalPageIndex) in chunk.enumerated() {
                guard let page = document.page(at: originalPageIndex) else { continue }
                newDocument.insert(page, at: pagePosition)
            }

            let fileName = String(format: "%@_%03d.pdf",
                                sourceURL.deletingPathExtension().lastPathComponent,
                                index + 1)
            let fileURL = outputDir.appendingPathComponent(fileName)

            if newDocument.write(to: fileURL) {
                savedFiles += 1
            }

            progress = 0.3 + (Double(index + 1) / Double(chunks.count) * 0.7) // 70% for saving
        }

        isProcessing = false
        progress = 1.0

        let removedPages = document.pageCount - validPages.count
        resultMessage = """
        Successfully split into \(savedFiles) files
        \(removedPages > 0 ? "\nRemoved \(removedPages) blank pages" : "")
        Saved to: \(outputDir.lastPathComponent)
        """
    }
}
