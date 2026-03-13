#!/usr/bin/env python3
"""
opw - Open file on Windows from remote Linux.

Starts a one-shot HTTP server, prints a clickable link.
Ctrl+Click in Windows Terminal to download & open.
Server auto-stops after download completes, temp file cleaned up.
"""

import http.server
import socketserver
import sys
import os
import shutil
import socket
import signal
import tempfile
import threading
import base64
from pathlib import Path
from urllib.parse import quote

import subprocess

def get_ssh_tty():
  if not os.environ.get("TMUX"):
    return None
  try:
    pid = subprocess.check_output(
      ["tmux", "display-message", "-p", "#{client_pid}"], text=True
    ).strip()
    tty = os.readlink(f"/proc/{pid}/fd/0")
    return tty
  except Exception:
    return None

def osc52_copy(text):
  b64 = base64.b64encode(text.encode()).decode()
  seq = f"\033]52;c;{b64}\a"
  tty = get_ssh_tty()
  if tty:
    with open(tty, "w") as f:
      f.write(seq)
      f.flush()
  else:
    sys.stdout.write(seq)
    sys.stdout.flush()

def get_local_ip():
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  try:
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]
  finally:
    s.close()

def find_free_port():
  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind(("", 0))
    return s.getsockname()[1]

MD_TEMPLATE = """<!DOCTYPE html>
<html><head>
<meta charset="utf-8">
<title>{title}</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-dark.min.css">
<style>
  body {{ background: #0d1117; padding: 32px; }}
  .markdown-body {{ max-width: 960px; margin: 0 auto; }}
</style>
</head><body>
<article class="markdown-body">{content}</article>
</body></html>"""

def render_md(filepath):
  try:
    import markdown
    with open(filepath) as f:
      html = markdown.markdown(f.read(), extensions=["tables", "fenced_code", "codehilite", "toc"])
    return MD_TEMPLATE.format(title=os.path.basename(filepath), content=html)
  except ImportError:
    return None

def main():
  if len(sys.argv) < 2:
    print("Usage: opw <file> [file2 ...]")
    sys.exit(1)

  files = [os.path.abspath(f) for f in sys.argv[1:]]
  for f in files:
    if not os.path.isfile(f):
      print(f"Error: {f} not found")
      sys.exit(1)

  tmpdir = tempfile.mkdtemp(prefix="opw_")
  served = []
  for f in files:
    basename = os.path.basename(f)
    if basename.endswith(".md"):
      html = render_md(f)
      if html:
        html_name = basename[:-3] + ".html"
        with open(os.path.join(tmpdir, html_name), "w") as hf:
          hf.write(html)
        served.append(html_name)
        continue
    dest = os.path.join(tmpdir, basename)
    shutil.copy2(f, dest)
    served.append(basename)

  ip = get_local_ip()
  port = find_free_port()
  downloads = {name: False for name in served}
  lock = threading.Lock()

  class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
      super().__init__(*args, directory=tmpdir, **kwargs)

    def log_message(self, fmt, *args):
      pass

    def do_GET(self):
      super().do_GET()
      if has_html:
        return
      name = self.path.lstrip("/")
      with lock:
        if name in downloads:
          downloads[name] = True
          if all(downloads.values()):
            threading.Thread(target=shutdown, daemon=True).start()

  server = socketserver.TCPServer(("0.0.0.0", port), Handler)

  def shutdown():
    server.shutdown()

  def cleanup(signum=None, frame=None):
    shutil.rmtree(tmpdir, ignore_errors=True)
    sys.exit(0)

  signal.signal(signal.SIGINT, cleanup)
  signal.signal(signal.SIGTERM, cleanup)

  urls = [f"http://{ip}:{port}/{quote(name)}" for name in served]

  osc52_copy(urls[0] if len(urls) == 1 else "\n".join(urls))

  print(f"\033[90m── opw serving on {ip}:{port} ──\033[0m")
  for url in urls:
    print(f"\033[1;36m  → {url}\033[0m")
  has_html = any(name.endswith(".html") for name in served)
  if has_html:
    print(f"\033[90m  Copied to clipboard! Paste in browser. Press Ctrl+C to stop.\033[0m")
  else:
    print(f"\033[90m  Copied to clipboard! Paste in browser or Ctrl+Click. Auto-closes after download.\033[0m")

  try:
    server.serve_forever()
  finally:
    shutil.rmtree(tmpdir, ignore_errors=True)
    print(f"\033[90m── done ──\033[0m")

if __name__ == "__main__":
  main()
