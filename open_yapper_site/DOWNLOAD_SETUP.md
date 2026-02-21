# Setting Up the DMG Download

Firebase Hosting (free tier) does not allow executable files like `.dmg`. The download is hosted on **Firebase Storage** instead.

## Option 1: Upload via Script (Recommended)

1. **Enable Firebase Storage** (if not already):
   - [Firebase Console](https://console.firebase.google.com) → open-yapper → **Storage** → Get started

2. **Create a service account key**:
   - Project Settings → **Service accounts** → **Generate new private key**
   - Save the JSON file (e.g. `service-account.json`) in a secure location

3. **Run the upload script**:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="./service-account.json"
   npm run upload-dmg
   ```
   Or with a custom DMG path:
   ```bash
   npm run upload-dmg ../open_yapper.dmg
   ```

4. **Add the output URL to `.env.local`**:
   ```
   NEXT_PUBLIC_DOWNLOAD_URL=https://storage.googleapis.com/open-yapper.appspot.com/downloads/open_yapper.dmg
   ```

5. **Redeploy**:
   ```bash
   npm run build && firebase deploy
   ```

## Option 2: Manual Upload via Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com) → open-yapper → **Storage**
2. Create a folder `downloads` (if it doesn't exist)
3. Upload `open_yapper.dmg` to `downloads/open_yapper.dmg`
4. Click the file → **Get download URL** (or make it public in Rules)
5. Add to `.env.local`:
   ```
   NEXT_PUBLIC_DOWNLOAD_URL=<paste-the-url>
   ```
6. Redeploy: `npm run build && firebase deploy`
