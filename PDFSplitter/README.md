# PDF Splitter for macOS

A native macOS application for splitting large PDF files into smaller chunks. Built specifically for Multi Family Office team to process banking reports before AI parsing.

## Features

### Must-Have (Implemented)
- ✅ **Drag & Drop Interface** - Simply drag PDF files into the app
- ✅ **File Information Display** - Shows page count and file size
- ✅ **Flexible Chunk Sizes** - Preset options (5, 10, 25, 50 pages) or custom value
- ✅ **Automatic Blank Page Removal** - Detects and removes empty pages
- ✅ **Password-Protected PDF Support** - Via PDFKit's native handling
- ✅ **Custom Save Location** - Choose where to save split files
- ✅ **Progress Tracking** - Visual progress bar for large files
- ✅ **Smart File Naming** - Auto-generated names: `original_001.pdf`, `original_002.pdf`, etc.

### Technical Specs
- **Max File Size**: 200 MB (tested with larger files)
- **Performance**: ~10 seconds for 100 pages (depending on complexity)
- **macOS Version**: 13.0+ (Ventura and higher)
- **Technology**: SwiftUI + PDFKit (native Apple frameworks)

## System Requirements

- macOS 13.0 (Ventura) or later
- Apple Silicon or Intel processor

## Installation

### Option 1: Build from Source (Xcode)

1. Open Terminal and navigate to the project:
   ```bash
   cd ~/Demoproject/PDFSplitter
   ```

2. Open in Xcode:
   ```bash
   open Package.swift
   ```

3. In Xcode:
   - Select your Mac as the target
   - Click Product → Run (⌘R)

### Option 2: Build Command Line

```bash
cd ~/Demoproject/PDFSplitter
swift build -c release
```

## Usage

1. **Launch the app**
2. **Load PDF**: Drag & drop a PDF file or click to browse
3. **Choose settings**:
   - Select pages per chunk (5, 10, 25, 50, or custom)
   - Toggle "Remove blank pages" if needed
4. **Click "Split PDF"**
5. **Choose save location** in the dialog
6. **Wait for processing** - progress bar shows status
7. **Done!** Files saved as `filename_001.pdf`, `filename_002.pdf`, etc.

## How It Works

### Blank Page Detection

A page is considered blank if:
1. No text content (empty string after whitespace trim)
2. No annotations
3. Average pixel brightness > 99% (almost pure white)

The algorithm samples 1000 pixels per page at 50% resolution for fast processing.

### Processing Pipeline

```
Input PDF (200 MB, 100 pages)
    ↓
Load with PDFKit
    ↓
Detect blank pages (if enabled)
    ↓
Split into chunks (e.g., 10 pages each)
    ↓
Save files: original_001.pdf, original_002.pdf, ...
```

## Architecture

```
┌─────────────────────────────────────────┐
│         PDFSplitterApp.swift            │
│              (App Entry)                │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          ContentView.swift              │
│         (UI Components)                 │
│  ┌────────────────────────────────┐    │
│  │ DropZoneView                   │    │
│  │ FileInfoView                   │    │
│  │ SplitOptionsView               │    │
│  └────────────────────────────────┘    │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│    PDFSplitterViewModel.swift           │
│        (Business Logic)                 │
│  • loadPDF()                            │
│  • detectBlankPages()                   │
│  • isPageBlank()                        │
│  • splitPDF()                           │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          PDFKit Framework               │
│      (Apple Native PDF Handling)        │
└─────────────────────────────────────────┘
```

## File Structure

```
PDFSplitter/
├── Package.swift              # Swift Package definition
├── Info.plist                 # App metadata
├── README.md                  # This file
├── Sources/
│   ├── PDFSplitterApp.swift   # App entry point
│   ├── ContentView.swift      # Main UI
│   └── PDFSplitterViewModel.swift  # Business logic
├── Resources/                 # (Future: icons, assets)
└── Tests/                     # (Future: unit tests)
```

## Performance Notes

- **Blank page detection**: Uses downscaled rendering (50%) and pixel sampling for speed
- **Large files**: Progress bar updates in real-time
- **Memory**: PDFKit handles memory management automatically
- **Threading**: Async/await for non-blocking UI

## Known Limitations

### By Design (Anti-requirements)
- ❌ No PDF merging
- ❌ No content editing
- ❌ No annotations
- ❌ No batch processing
- ❌ No Windows/Linux versions
- ❌ No licensing/subscription

### Technical
- Protected PDFs with edit restrictions are supported
- Password-protected PDFs require manual unlock via macOS
- Very large files (>200MB) may take longer to process

## Troubleshooting

### "Failed to load PDF"
- Ensure the file is a valid PDF
- Check file permissions
- Try opening in Preview first

### Slow Processing
- Disable "Remove blank pages" for faster processing
- Close other apps to free memory
- Check if PDF has complex graphics

### App Won't Launch
- Verify macOS version is 13.0+
- Rebuild from source with latest Xcode

## Development

### Testing Locally

```bash
# Run in Xcode with debugger
open Package.swift

# Or build and run from terminal
swift run
```

### Adding Features

1. Edit source files in `Sources/`
2. Test changes with ⌘R in Xcode
3. Commit to repository

## Future Enhancements (Could-Have)

- [ ] Keyboard shortcuts (⌘O for open, ⌘S for split)
- [ ] History of recent files
- [ ] Batch processing multiple PDFs
- [ ] Export settings presets
- [ ] Dark mode optimization

## Support

For issues or feature requests, contact the development team.

---

**Version**: 1.0
**Built for**: Multi Family Office Team
**Technology**: SwiftUI + PDFKit
**License**: Internal Use Only
