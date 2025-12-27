# Build Instructions

## Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+ with Command Line Tools
- Swift 5.9+

## Quick Start

### Method 1: Xcode (Recommended for Development)

```bash
# Navigate to project
cd ~/Demoproject/PDFSplitter

# Open in Xcode
open Package.swift
```

In Xcode:
1. Wait for package resolution
2. Select "My Mac" as target
3. Click Run (⌘R) or Product → Run

### Method 2: Command Line Build

```bash
cd ~/Demoproject/PDFSplitter

# Debug build
swift build

# Release build (optimized)
swift build -c release

# Run directly
swift run
```

### Method 3: Create Standalone App Bundle

```bash
cd ~/Demoproject/PDFSplitter

# Build release version
swift build -c release

# The executable will be at:
# .build/release/PDFSplitter
```

## Creating a .app Bundle for Distribution

To create a proper macOS app bundle:

1. **Open Xcode**: `open Package.swift`

2. **Archive the app**:
   - Product → Archive
   - Wait for build to complete
   - In Organizer, click "Distribute App"
   - Choose "Copy App"
   - Save to desired location

3. **Or use command line** (requires additional setup):

```bash
# Install create-dmg (if not installed)
brew install create-dmg

# Build release
swift build -c release

# Create app bundle structure
mkdir -p PDFSplitter.app/Contents/MacOS
mkdir -p PDFSplitter.app/Contents/Resources

# Copy executable
cp .build/release/PDFSplitter PDFSplitter.app/Contents/MacOS/

# Copy Info.plist
cp Info.plist PDFSplitter.app/Contents/

# Create DMG
create-dmg \
  --volname "PDF Splitter" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --app-drop-link 450 185 \
  "PDFSplitter-v1.0.dmg" \
  "PDFSplitter.app"
```

## Verifying the Build

```bash
# Check Swift version
swift --version

# Should output: Swift version 5.9 or later

# Verify package
swift package describe

# Run tests (when available)
swift test
```

## Troubleshooting

### "Cannot find Package.swift"
```bash
# Ensure you're in the correct directory
pwd
# Should show: /Users/[username]/Demoproject/PDFSplitter

ls -la
# Should show Package.swift
```

### "Module not found"
```bash
# Clean build
swift package clean
swift package resolve
swift build
```

### "Xcode version too old"
```bash
# Update Xcode via App Store or:
xcode-select --install
```

### Code Signing Issues
In Xcode:
1. Select project in navigator
2. Go to Signing & Capabilities
3. Enable "Automatically manage signing"
4. Select your Team

## Development Workflow

```bash
# 1. Make code changes in Sources/

# 2. Build and test
swift build

# 3. Run the app
swift run

# 4. If everything works, commit
git add .
git commit -m "feat: your changes"
git push
```

## Performance Optimization

For maximum performance in production:

```bash
# Build with optimizations
swift build -c release -Xswiftc -O

# Profile with Instruments
# In Xcode: Product → Profile (⌘I)
```

## Clean Build

If you encounter issues:

```bash
# Remove all build artifacts
rm -rf .build
swift package clean

# Rebuild
swift build
```

## Minimum Build Requirements

| Component | Minimum Version |
|-----------|----------------|
| macOS | 13.0 (Ventura) |
| Xcode | 15.0 |
| Swift | 5.9 |
| Command Line Tools | Latest |

## Distribution Checklist

Before distributing to team:

- [ ] Build in Release mode
- [ ] Test with sample PDF files
- [ ] Test with large files (100+ pages)
- [ ] Verify blank page detection
- [ ] Check all preset buttons work
- [ ] Test custom page input
- [ ] Verify progress bar updates
- [ ] Test drag & drop
- [ ] Test file browser
- [ ] Check output file naming
- [ ] Verify error messages display

## Quick Commands Reference

```bash
# Build debug
swift build

# Build release
swift build -c release

# Run
swift run

# Clean
swift package clean

# Update dependencies
swift package update

# Generate Xcode project (if needed)
swift package generate-xcodeproj
```
