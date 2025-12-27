# PDF Splitter - Quick Start Guide

## For Team Members

### What is this?

A macOS app that splits large PDF banking reports into smaller chunks for AI processing.

**Problem it solves**: No more manual splitting in Preview!

---

## Installation (One-Time Setup)

### Step 1: Get the Code

```bash
# Clone the repository (if you haven't)
gh repo clone alpinadigitalai/Demoproject

# Navigate to the app
cd ~/Demoproject/PDFSplitter
```

### Step 2: Build the App

**Option A: Using Xcode (Easiest)**

```bash
# Open in Xcode
open Package.swift
```

Then in Xcode:
- Click the Play button (▶️) or press ⌘R
- App window will open

**Option B: Command Line**

```bash
# Build and run
swift run
```

---

## Daily Usage

### How to Split a PDF

1. **Launch the app** (see Installation above)

2. **Load your PDF**:
   - Drag & drop the file into the window
   - OR click the drop zone to browse

3. **Choose settings**:
   - Click a preset (5, 10, 25, or 50 pages)
   - OR type custom number in the text field
   - Toggle "Remove blank pages" if needed

4. **Click "Split PDF"**

5. **Choose where to save** in the dialog

6. **Wait** for the progress bar to finish

7. **Done!** Your files are saved as:
   ```
   report_001.pdf
   report_002.pdf
   report_003.pdf
   ...
   ```

---

## Common Scenarios

### Scenario 1: Split 150-page report into 25-page chunks

1. Drag the PDF file
2. Click "25" button
3. Check "Remove blank pages" ✅
4. Click "Split PDF"
5. Choose folder
6. Get 6 files (assuming no blank pages)

### Scenario 2: Quick 10-page chunks

1. Drag the PDF file
2. Click "10" button (default)
3. Click "Split PDF"
4. Done!

### Scenario 3: Custom 15-page chunks

1. Drag the PDF file
2. Type "15" in the Custom field
3. Click "Split PDF"
4. Choose folder

---

## Tips & Tricks

### ⚡️ Speed Tips

- **Disable blank page removal** for faster processing (if you don't have blank pages)
- **Use preset buttons** - they're faster than typing

### 🎯 Best Practices

- **Save to Desktop or Documents** for easy finding
- **Use default naming** - it's chronological and clear
- **Keep blank page removal ON** - saves AI processing time

### ⚠️ Troubleshooting

**App won't launch?**
```bash
# Rebuild
cd ~/Demoproject/PDFSplitter
swift package clean
swift build
swift run
```

**"Failed to load PDF"?**
- Check file is actually a PDF
- Try opening in Preview first
- Check file permissions

**Processing takes forever?**
- Disable "Remove blank pages" for speed
- Large files (200MB) can take 20-30 seconds - this is normal

**Wrong chunk size?**
- Make sure you clicked the preset OR typed in custom field
- Check the number before clicking "Split PDF"

---

## Keyboard Shortcuts

Currently none implemented. (Could be added in future!)

---

## What NOT to Do

❌ Don't try to split multiple PDFs at once (not supported)
❌ Don't expect to merge PDFs (use Preview for that)
❌ Don't use for editing PDF content (use Adobe Acrobat)

---

## Need Help?

1. **Check the README**: `~/Demoproject/PDFSplitter/README.md`
2. **Check build docs**: `~/Demoproject/PDFSplitter/BUILD.md`
3. **Ask the dev team**
4. **Contact Хамид (@hamidun)**

---

## Advanced Usage

### Running from Terminal

```bash
# Quick launch
cd ~/Demoproject/PDFSplitter && swift run
```

### Creating a Desktop Shortcut

1. Build the app in Xcode
2. Product → Archive
3. Distribute as "Copy App"
4. Move to Applications folder
5. Drag to Dock

---

## Performance Expectations

| PDF Size | Pages | Expected Time |
|----------|-------|---------------|
| Small | 1-20 | < 2 seconds |
| Medium | 20-100 | 5-10 seconds |
| Large | 100-200 | 10-20 seconds |
| Very Large | 200+ | 20-30 seconds |

*With blank page detection enabled*

---

## Example Workflow

**Your morning routine**:

```
1. Open email with banking reports (150 pages each)
2. Download PDFs to Desktop
3. Launch PDF Splitter
4. For each PDF:
   - Drag to app
   - Click "25" (standard chunk size)
   - "Remove blank pages" ✅
   - Click "Split PDF"
   - Save to Reports/[ClientName]/
5. Upload chunks to AI parser
6. Process results
```

**Time saved**: 15 minutes vs Preview manual method!

---

## Updating the App

```bash
# Get latest version
cd ~/Demoproject
git pull

# Rebuild
cd PDFSplitter
swift build
```

---

## Feature Requests

Want a new feature? Suggest to the dev team:

**Could be added**:
- [ ] Keyboard shortcuts
- [ ] Batch processing (multiple PDFs)
- [ ] Recent files history
- [ ] Preset saving
- [ ] Dark mode tweaks

**Won't be added** (by design):
- Merging PDFs (use Preview)
- Editing content (use Acrobat)
- Windows version (macOS only)

---

## Settings

Current settings are **in-app only** (no preferences file).

Defaults:
- Pages per chunk: 10
- Remove blank pages: ON
- Save location: User chooses each time

---

## FAQ

**Q: Can I split password-protected PDFs?**
A: Yes, macOS will ask for the password automatically.

**Q: What's the maximum file size?**
A: Tested up to 200MB, but technically no limit.

**Q: Do I need internet?**
A: No, works completely offline.

**Q: Where are files saved?**
A: Wherever you choose in the save dialog.

**Q: Can I undo a split?**
A: No, but just delete the output files.

**Q: What happens to the original?**
A: Nothing! It's never modified.

---

## Version Info

**Current Version**: 1.0
**Last Updated**: 2025-12-27
**Supports**: macOS 13.0+ (Ventura and higher)

---

**That's it! You're ready to split PDFs like a pro!** 🚀
