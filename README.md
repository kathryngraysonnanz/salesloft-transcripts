# SalesLoft Call Transcripts 

This script has been forked and modified from [caserta31/gyde-transcripts](https://github.com/caserta31/gyde-transcripts) for use with the Progress User Research Copilot Agent. It pulls call transcript TEXT files from Salesloft via their API, saves them to a local folder, then copies them into a synced OneDrive folder (that the User Research Agent is watching) and deletes the local copy. 

Originally, this program also handled upload to Google Drive. I am not using those aspects of the script, but I have retained them here for reference / in case they're needed in the future. 

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Salesloft API Key

Make sure your `.env` file has your Salesloft API key:
```
SALESLOFT_API_KEY=your_api_key_here
```

### 3. Run the Script

**Option A: Test Mode (Quick Test - 15 transcripts)**
```bash
npm test
```

**Option B: Batch Mode (Get ALL transcripts)**
```bash
npm run batch
```

Run batch mode multiple times to process all your calls:
```bash
npm run batch  # Run 1: Processes first batch
npm run batch  # Run 2: Processes next batch (auto-skips duplicates)
npm run batch  # Run 3: Continue until all calls processed
```

**Option C: Clean & Reset (Start fresh)**
```bash
npm run clean  # Resets the tracker (backs up old data)
npm run batch  # Re-download all transcripts
```

**Option D: Kathryn's Custom Script**
```bash
./batch-and-copy.sh  # Runs batch mode, copies files to OneDrive, deletes locally saved files. Kathryn runs daily using the following cron job: 00 10 * * * /Users/nanz/salesloft-transcripts/scripts/batch-and-copy.sh >> ~/cron.log 2>&1
```

**📖 New to this?**
- **[HOW_IT_WORKS.md](./HOW_IT_WORKS.md)** - **START HERE!** Explains the tracking system & when to use each command
- **[WHEN_TO_RUN.md](./docs/WHEN_TO_RUN.md)** - Quick reference guide

## What the Script Does

1. Fetches call data records from Salesloft API with pagination support
2. Applies smart filtering (completed calls, minimum duration, has activity ID)
3. Checks for AI transcripts early to skip calls without transcription_id
4. For calls with AI transcripts:
   - Fetches ALL sentence pages (handles pagination automatically)
   - Combines sentences into complete conversation transcripts
   - Saves as text files locally and uploads to Google Drive
5. Provides detailed progress tracking and summary statistics

## Which Mode Should I Use?

| Feature | Test Mode (`npm test`) | Batch Mode (`npm run batch`) | Clean Mode (`npm run clean`) |
|---------|----------------------|----------------------------|----------------------------|
| **Purpose** | Quick testing | Production data extraction | Reset & start fresh |
| **Transcripts** | Stops at 15 | Unlimited (all available) | Clears tracker (no download) |
| **Records Scanned** | 100 per run | 500 per run | N/A |
| **Use Case** | Initial setup, spot-checking | Full historical backfill, ongoing sync | After bug fix, reset needed |
| **Duplicate Prevention** | ✅ Yes | ✅ Yes | N/A (clears all history) |
| **Run Multiple Times** | ✅ Yes | ✅ Yes (recommended) | Only when needed |

## Configuration

Settings are in `config.js` - you can adjust without modifying the main scripts:

```javascript
// Test mode settings
test: {
  TARGET_AI_TRANSCRIPTS: 15,  // Stop after finding 15
  MAX_RECORDS_TO_SCAN: 100,   // Scan 100 records per run
  MIN_DURATION: 30,            // Minimum call duration (seconds)
}

// Batch mode settings
batch: {
  MAX_RECORDS_TO_SCAN: 500,   // Scan 500 records per run
  MIN_DURATION: 30,            // Minimum call duration (seconds)
  API_DELAY_MS: 100,           // 100ms delay = 10 calls/sec
}
```

## Output

- Files are saved to: `./recordings/`
- File naming format: `transcript_call_{callId}_{timestamp}.txt`
- Each file includes:
  - Call metadata (ID, date, duration, phone numbers)
  - **Complete** AI-generated transcript text (all sentences, paginated automatically)

### Console Output Indicators

- `✅ AI TRANSCRIPT` - Full conversation transcript from AI speech-to-text
- `⚠️ MANUAL NOTE ONLY` - User-typed summary (not conversation transcript)
- `⊘ Skipped (no AI transcript)` - Call had no transcription_id, skipped early

### Summary Statistics

The script provides detailed statistics:
```
=== SUMMARY ===
✓ Successfully processed: 8 calls
  ✅ With AI transcripts: 5
  ⚠️  With manual notes only: 2
  ❌ Without any transcript: 1
⊘ Skipped (no AI transcript): 32
✗ Failed: 0 calls
```

## After Download

Once the transcripts are downloaded to your computer, you can:
- Manually upload them to Google Drive
- Process them with text analysis tools
- Search through them for specific content
- Store them in your preferred location

## Notes

- **Smart Filtering**: Only processes completed calls with minimum 30s duration
- **AI Transcript Detection**: Automatically checks for `transcription_id` and skips calls without AI transcripts
- **Complete Transcripts**: Handles pagination automatically to fetch ALL sentences (no truncation)
- **Efficient**: Skips calls early if no AI transcript exists, saving ~80% of API calls
- **Files**: The `batch-and-copy.sh` script calls the batch task, then copies the downloaded files to a synced OneDrive folder and deletes the local version.
- Files are plain text (.txt format)
- If a transcript fails to download, the script continues with the next one

## How AI Transcripts Work

See [EXPLAINED.md](./docs/EXPLAINED.md) for a detailed technical explanation of:
- The 3-step API process (Call Data → Conversation → Sentences)
- How AI transcripts are detected and distinguished from manual notes
- JSON schemas for each API endpoint
- Pagination handling for complete transcripts
- Scaling and performance optimizations

## Troubleshooting

### "Error fetching transcripts"
- Verify your `SALESLOFT_API_KEY` is correct in the `.env` file
- Check that the API key has the necessary permissions in Salesloft

### "Error downloading recording"
- The recording URL may have expired or be inaccessible
- Check your network connection

### "Duplicate transcripts with different call IDs"
- This was a bug in earlier versions (now fixed!)
- Run `npm run clean` to reset the tracker
- Then run `npm run batch` to re-download with the fix

---

## 📚 Documentation

Comprehensive guides are available in the `docs/` folder:

### Getting Started
- **[WHEN_TO_RUN.md](./docs/WHEN_TO_RUN.md)** - **START HERE!** Simple guide on when to use each command
- **[QUICK_START.md](./docs/QUICK_START.md)** - Workflows, verification steps, and troubleshooting

### Advanced Topics
- **[BATCHING_GUIDE.md](./docs/BATCHING_GUIDE.md)** - Advanced batching strategies and scheduling
- **[EXPLAINED.md](./docs/EXPLAINED.md)** - Technical deep-dive on API architecture and data flows

### Production Deployment
- **[NEXT_STEPS.md](./docs/NEXT_STEPS.md)** - 🚀 Roadmap for automated deployment on Render
