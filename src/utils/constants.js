/**
 * Application Constants
 * Central location for all configuration constants
 */

import { fileURLToPath } from 'url';
import path from 'path';

// Resolve the project root relative to this file,
// so paths work regardless of where the script is called from
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PROJECT_ROOT = path.join(__dirname, '../..');

// Local download folder (for backup/debugging)
export const DOWNLOAD_FOLDER = path.join(PROJECT_ROOT, 'recordings');

// File paths (in data/ directory)
export const PROCESSED_IDS_FILE = path.join(PROJECT_ROOT, 'data/processed_conversation_ids.json');
export const LEGACY_PROCESSED_IDS_FILE = path.join(PROJECT_ROOT, 'data/processed_call_ids.json');
export const MAPPING_CSV_FILE = path.join(PROJECT_ROOT, 'data/transcript_salesforce_mapping.csv');

// Google Drive configuration paths
export const OAUTH_CREDENTIALS_PATH = path.join(PROJECT_ROOT, 'oauth_credentials.json');
export const TOKEN_PATH = path.join(PROJECT_ROOT, 'token.json');