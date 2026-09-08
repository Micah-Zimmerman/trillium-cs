# Your Trillium CS Workspace

This is your computer for this class. It is not your Chromebook — it is a
real Linux machine running in a data center. Your Chromebook is the screen.

## What is in here

- `hello.py` — a Python program. Start here.
- `index.html` — a web page. Start here if you are building something visual.
- `students/README.md` — the class list. You will add yourself to it today.

## Run the Python program

Click the terminal panel at the bottom of the screen. Type this and press Enter:

    python3 hello.py

It will greet you. Then open `hello.py`, change the name on the first line to
your name, save with Ctrl+S, and run it again.

## See the web page

1. Right-click `index.html` in the file list on the left.
2. Choose **Show Preview**.
3. If nothing appears, click the **Ports** tab at the bottom, find port 3000,
   and click the globe icon. Your page opens in a new browser tab.

## Save your work to the internet

Your changes are not saved anywhere permanent until you commit and push them.
Do this at the end of every class, even if the thing you built does not work.

1. Click the **Source Control** icon in the far-left bar.
2. Type a short message saying what you changed.
3. Click **Commit**, then **Sync Changes**.

## Two rules that will save you

**Rule 1: commit at the end of every class.** Your codespace is deleted after
30 days of not being opened. Your repository is never deleted. Committing
moves your work from the one that disappears to the one that does not.

**Rule 2: Ctrl+W closes your browser tab, not your file.** Chrome takes that
shortcut before the editor sees it. To close a file, click the small x on the
file's tab.

## When you are done for the day

Go to github.com/codespaces, find your codespace, click the ... menu, and
choose **Stop codespace**. It stops itself after 30 idle minutes anyway, but
stopping it yourself is faster and it is a good habit.

## Games with graphics

See `pygame-starter/README.md`: Pygame runs in a browser tab here. Programs that must open their own window (Turtle, Tkinter, Java Swing) can use the **desktop** configuration instead: when creating a codespace, choose "Trillium CS Starter (with desktop)" and open port 6080 for a Linux desktop in a tab.

## More starters

Other starting points (Pygame, LÖVE/Lua, JavaScript canvas, terminal Python)
live in the class starters repo. To add one to this repository:

1. Open a terminal: **F1** → *Terminal: Create New Terminal*.
2. Paste this whole line (in the terminal, paste is **Ctrl+Shift+V**), then press Enter:

   ```
   bash <(curl -s https://raw.githubusercontent.com/ryannorris-trillium/trillium-starters/main/get.sh) pygame
   ```

   Replace `pygame` with `love`, `web-canvas`, or `terminal-python`. If you leave
   the name off, it asks you which one.
3. A new folder appears. Open its `README.md` for the two or three commands that run it.
4. Commit the folder: Source Control → message → Commit → Sync.

**Updating a starter you already have:** run the same line again. It adds any
new starter files (for example a new `dev.sh`) and never overwrites files you
already have, so your own edits are safe.

**What that line does:** `curl -s` downloads the script `get.sh`; `bash <( … )`
runs it straight away; the word at the end is the starter name. Only run
`bash <(curl …)` lines from a source you know — this one is Ryan's class repo.
