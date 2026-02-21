#!/usr/bin/env node
/**
 * Uploads open_yapper.dmg to Firebase Storage and outputs the public download URL.
 *
 * Prerequisites:
 * 1. Firebase Storage must be enabled for your project (Firebase Console → Storage)
 * 2. Set GOOGLE_APPLICATION_CREDENTIALS to your service account key JSON path, e.g.:
 *    export GOOGLE_APPLICATION_CREDENTIALS="./service-account.json"
 *
 * To get a service account key:
 * Firebase Console → Project Settings → Service Accounts → Generate new private key
 *
 * Usage: node scripts/upload-dmg.mjs [path-to-dmg]
 */

import { initializeApp, cert } from "firebase-admin/app";
import { getStorage } from "firebase-admin/storage";
import { readFileSync, existsSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const DMG_PATH =
  process.argv[2] || resolve(__dirname, "../../open_yapper.dmg");
const STORAGE_PATH = "downloads/open_yapper.dmg";

async function main() {
  if (!existsSync(DMG_PATH)) {
    console.error(`Error: DMG file not found at ${DMG_PATH}`);
    process.exit(1);
  }

  const keyPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (!keyPath || !existsSync(keyPath)) {
    console.error(
      "Error: Set GOOGLE_APPLICATION_CREDENTIALS to your service account JSON path."
    );
    console.error(
      "Get it from: Firebase Console → Project Settings → Service Accounts → Generate new private key"
    );
    process.exit(1);
  }

  const key = JSON.parse(readFileSync(keyPath, "utf8"));
  const projectId = key.project_id;
  initializeApp({
    credential: cert(key),
    storageBucket: `${projectId}.appspot.com`,
  });

  const bucket = getStorage().bucket();
  await bucket.upload(DMG_PATH, {
    destination: STORAGE_PATH,
    metadata: {
      contentType: "application/octet-stream",
      metadata: {
        contentDisposition: 'attachment; filename="Open Yapper.dmg"',
      },
    },
  });

  const file = bucket.file(STORAGE_PATH);
  await file.makePublic();

  const publicUrl = `https://storage.googleapis.com/${PROJECT_ID}.appspot.com/${STORAGE_PATH}`;
  console.log("\nUpload complete! Add this to your .env.local:\n");
  console.log(`NEXT_PUBLIC_DOWNLOAD_URL=${publicUrl}\n`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
