# Installing SQLite3 on Windows

## 1. Download SQLite

1. Go to the official SQLite download page:  
   https://sqlite.org/download.html

2. Under **Precompiled Binaries for Windows**, download:
   - `sqlite-tools-win-x64-*.zip` (for 64-bit Windows)

---

## 2. Extract the Files

1. Right-click the downloaded ZIP file  
2. Click **Extract All**
3. Extract to a folder such as:  `C:\sqlite`

You should see files like:
- `sqlite3.exe`
- `sqldiff.exe`
- `sqlite3_analyzer.exe`

---

## 3. Add SQLite to PATH (Optional but Recommended)

1. Press **Windows + R**
2. Type `sysdm.cpl` and press Enter
3. Go to **Advanced → Environment Variables**
4. Under *System Variables*, find **Path**
5. Click **Edit → New**
6. Add the folder path: `C:\sqlite`

7. Click **OK** on all dialogs

---

## 4. Verify Installation

1. Open **Command Prompt**
2. Run: `sqlite3 --version` 

If installed correctly, the SQLite version will be displayed.

---

## 5. Start Using SQLite

To open SQLite shell: `sqlite3`

To create a database: `sqlite3 mydatabase.db`


---

## Done 🎉

SQLite is now installed and ready to use on your Windows system.