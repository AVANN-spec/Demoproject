# Testing Guide for PDF Splitter

## Quick Test

```bash
# Navigate to project
cd ~/Demoproject/PDFSplitter

# Build the app
swift build

# Run the app
swift run
```

## Manual Testing Checklist

### Basic Functionality
- [ ] **Launch app** - App window opens successfully
- [ ] **Window size** - Window is 500px wide, auto-height
- [ ] **Drop zone visible** - Shows "Drag & Drop PDF Here" message

### File Loading
- [ ] **Drag & drop PDF** - File loads successfully
- [ ] **Click to browse** - File picker opens and works
- [ ] **Invalid file** - Shows error for non-PDF files
- [ ] **File info displays** - Shows correct page count and size
- [ ] **Large file (100+ pages)** - Loads without crashing
- [ ] **Very large file (200MB)** - Loads successfully

### Split Options
- [ ] **Preset buttons (5, 10, 25, 50)** - Each button selects that value
- [ ] **Custom input field** - Can type custom page count
- [ ] **Invalid custom value** - Handles negative/zero values gracefully
- [ ] **Preset highlights** - Selected preset shows visual feedback

### Blank Page Detection
- [ ] **Toggle on/off** - Checkbox works
- [ ] **Blank page count** - Shows number of detected blank pages
- [ ] **Detection accuracy** - Correctly identifies truly blank pages
- [ ] **Processing time** - Completes detection in reasonable time

### PDF Splitting
- [ ] **Split button** - Triggers file save dialog
- [ ] **Save location** - Can choose custom folder
- [ ] **Cancel save** - Canceling dialog doesn't crash
- [ ] **Progress bar** - Shows and updates during processing
- [ ] **File naming** - Creates files with _001, _002, etc. pattern
- [ ] **Chunk sizes** - Each file has correct number of pages
- [ ] **Success message** - Shows file count and location

### Edge Cases
- [ ] **1-page PDF** - Handles gracefully
- [ ] **Exact chunk size** - No partial files if perfectly divisible
- [ ] **Partial chunk** - Last file has remaining pages
- [ ] **All blank pages** - Shows warning or creates no files
- [ ] **Protected PDF** - Loads and processes correctly
- [ ] **Password PDF** - macOS handles password prompt

### Performance
- [ ] **10 pages** - Processes in < 2 seconds
- [ ] **100 pages** - Processes in < 10 seconds
- [ ] **200 pages** - Processes in < 20 seconds
- [ ] **Memory usage** - Doesn't spike excessively
- [ ] **UI responsiveness** - App doesn't freeze during processing

## Creating Test PDF Files

### Using Preview (macOS)

1. **Create blank PDF**:
   ```
   Open Preview → File → New from Clipboard
   Insert blank pages: Tools → Annotate → Add Page
   Save as test_blank.pdf
   ```

2. **Create large PDF**:
   - Duplicate pages in existing PDF
   - Or: Print any document choosing "Save as PDF"
   - Keep adding pages until 100+

3. **Create mixed PDF** (blank + content):
   - Start with content PDF
   - Insert blank pages: Tools → Annotate → Add Page
   - Mix throughout document

### Using Command Line

```bash
# Create simple test PDF
echo "Test content" | cupsfilter -i text/plain -o application/pdf > test.pdf

# Combine multiple PDFs (if you have PDFtk installed)
pdftk test.pdf test.pdf test.pdf cat output large_test.pdf
```

## Automated Testing (Future)

### Unit Tests Template

```swift
import XCTest
@testable import PDFSplitter

class PDFSplitterTests: XCTestCase {
    func testBlankPageDetection() {
        // Test blank page detection algorithm
    }

    func testChunkCalculation() {
        // Test splitting logic
    }

    func testFileNaming() {
        // Test output file naming
    }
}
```

To run when implemented:
```bash
swift test
```

## Performance Profiling

### Using Xcode Instruments

1. Open project: `open Package.swift`
2. Product → Profile (⌘I)
3. Choose template:
   - **Time Profiler** - CPU usage
   - **Allocations** - Memory usage
   - **Leaks** - Memory leaks
4. Run with large PDF
5. Analyze results

### Benchmarking

```bash
# Time the operation
time swift run

# Or create test script
cat > benchmark.sh << 'EOF'
#!/bin/bash
echo "Building..."
swift build -c release

echo "Running benchmark..."
time .build/release/PDFSplitter test_100pages.pdf
EOF

chmod +x benchmark.sh
./benchmark.sh
```

## Common Issues & Fixes

### Issue: App crashes on launch
**Fix**: Rebuild from scratch
```bash
swift package clean
swift build
```

### Issue: Blank page detection too slow
**Fix**: Already optimized with 50% scale and sampling. Consider:
- Reducing sample size (currently 1000 pixels)
- Disabling feature for very large files
- Adding "Fast mode" toggle

### Issue: Memory issues with large PDFs
**Fix**: PDFKit handles this automatically, but if issues persist:
- Process in smaller batches
- Force garbage collection between chunks
- Monitor in Instruments

### Issue: Wrong blank page detection
**Fix**: Adjust threshold in `isPageBlank()`:
```swift
// Current: 0.99 (99% brightness)
// Try: 0.95 for less aggressive detection
return averageBrightness > 0.95
```

## Regression Testing

Before each release, test with:

1. **Sample banking reports** (if available)
2. **100-page generated PDF**
3. **Mix of content and blank pages**
4. **Protected PDF**
5. **Minimum size PDF (1 page)**
6. **Maximum size PDF (200MB)**

## User Acceptance Testing

Have team members test:

1. Install app on their Macs
2. Process real banking reports
3. Verify output quality
4. Report any issues
5. Rate ease of use (1-5)

## Test Results Template

```markdown
## Test Session: [Date]

**Tester**: [Name]
**macOS Version**: [e.g., 13.5]
**Build**: [commit hash or version]

### Results

| Test Case | Status | Notes |
|-----------|--------|-------|
| Drag & drop | ✅ | Worked perfectly |
| 100-page PDF | ✅ | Processed in 8s |
| Blank detection | ⚠️  | Missed 2 pages |
| File naming | ✅ | Correct pattern |

### Issues Found

1. [Description of issue]
2. [Description of issue]

### Overall Rating: [1-5] ⭐
```

## Next Steps After Testing

1. ✅ Fix any critical bugs
2. ✅ Optimize performance issues
3. ✅ Improve UX based on feedback
4. ✅ Add requested features
5. ✅ Create distribution build
6. ✅ Write user documentation
7. ✅ Deploy to team
