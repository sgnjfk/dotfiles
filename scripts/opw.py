#!/usr/bin/env python3
"""
opw - Open file/folder on Windows from remote Linux via HTTP server.

URL structure (folder mode):
  /path/to/dir/        -> directory listing
  /path/to/file        -> view (md rendered, pdf/image inline)
  /path/to/file?dl=1   -> force download
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
import mimetypes
from pathlib import Path
from urllib.parse import quote, unquote, urlparse, parse_qs

import subprocess

VIEWABLE = {".md", ".html", ".htm", ".pdf", ".txt", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp"}

# ── Clipboard ──────────────────────────────────────────────────────────────

def get_ssh_tty():
  if not os.environ.get("TMUX"):
    return None
  try:
    pid = subprocess.check_output(["tmux", "display-message", "-p", "#{client_pid}"], text=True).strip()
    return os.readlink(f"/proc/{pid}/fd/0")
  except Exception:
    return None

def osc52_copy(text):
  b64 = base64.b64encode(text.encode()).decode()
  seq = f"\033]52;c;{b64}\a"
  tty = get_ssh_tty()
  if tty:
    with open(tty, "w") as f:
      f.write(seq); f.flush()
  else:
    sys.stdout.write(seq); sys.stdout.flush()

# ── Network ────────────────────────────────────────────────────────────────

def get_local_ip():
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  try:
    s.connect(("8.8.8.8", 80)); return s.getsockname()[0]
  finally:
    s.close()

def find_free_port():
  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind(("", 0)); return s.getsockname()[1]

# ── Markdown rendering ─────────────────────────────────────────────────────

MD_THEMES = {
  "github-dark": {
    "label": "GitHub Dark",
    "css_url": "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-dark.min.css",
    "body_bg": "#0d1117", "body_color": "#e6edf3",
  },
  "github-light": {
    "label": "GitHub Light",
    "css_url": "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-light.min.css",
    "body_bg": "#ffffff", "body_color": "#1f2328",
  },
  "catppuccin": {
    "label": "Catppuccin",
    "css_url": None,
    "body_bg": "#1e1e2e", "body_color": "#cdd6f4",
    "extra_css": """
      .markdown-body { color: #cdd6f4; background: transparent; }
      .markdown-body h1,.markdown-body h2,.markdown-body h3 { color: #cba6f7; border-color: #313244; }
      .markdown-body a { color: #89b4fa; }
      .markdown-body code { background: #313244; color: #f38ba8; border-radius: 4px; }
      .markdown-body pre { background: #181825; border: 1px solid #313244; }
      .markdown-body blockquote { border-color: #89b4fa; color: #a6adc8; }
      .markdown-body table tr { background: #1e1e2e; border-color: #313244; }
      .markdown-body table tr:nth-child(2n) { background: #181825; }
      .markdown-body table th,.markdown-body table td { border-color: #313244; }
      .markdown-body hr { background: #313244; }
    """
  },
  "dracula": {
    "label": "Dracula",
    "css_url": None,
    "body_bg": "#282a36", "body_color": "#f8f8f2",
    "extra_css": """
      .markdown-body { color: #f8f8f2; background: transparent; }
      .markdown-body h1,.markdown-body h2,.markdown-body h3 { color: #bd93f9; border-color: #44475a; }
      .markdown-body a { color: #8be9fd; }
      .markdown-body code { background: #44475a; color: #ff79c6; border-radius: 4px; }
      .markdown-body pre { background: #1e1f29; border: 1px solid #44475a; }
      .markdown-body blockquote { border-color: #bd93f9; color: #6272a4; }
      .markdown-body table tr { background: #282a36; border-color: #44475a; }
      .markdown-body table tr:nth-child(2n) { background: #1e1f29; }
      .markdown-body table th,.markdown-body table td { border-color: #44475a; }
      .markdown-body hr { background: #44475a; }
    """
  },
  "solarized": {
    "label": "Solarized Dark",
    "css_url": None,
    "body_bg": "#002b36", "body_color": "#839496",
    "extra_css": """
      .markdown-body { color: #839496; background: transparent; }
      .markdown-body h1,.markdown-body h2,.markdown-body h3 { color: #268bd2; border-color: #073642; }
      .markdown-body a { color: #2aa198; }
      .markdown-body code { background: #073642; color: #d33682; border-radius: 4px; }
      .markdown-body pre { background: #073642; border: 1px solid #586e75; }
      .markdown-body blockquote { border-color: #268bd2; color: #586e75; }
      .markdown-body table tr { background: #002b36; border-color: #073642; }
      .markdown-body table tr:nth-child(2n) { background: #073642; }
      .markdown-body table th,.markdown-body table td { border-color: #073642; }
      .markdown-body hr { background: #073642; }
    """
  },
}

MD_TEMPLATE = """<!DOCTYPE html>
<html><head>
<meta charset="utf-8">
<title>{title}</title>
<link id="theme-css" rel="stylesheet" href="{css_url}">
<style>
  body {{ background: {body_bg}; color: {body_color}; padding: 48px 32px 32px; margin: 0; transition: background .2s; }}
  .markdown-body {{ max-width: 960px; margin: 0 auto; }}
  {extra_css}

  /* Theme bar */
  #theme-bar {{
    position: fixed; top: 0; left: 0; right: 0; z-index: 99;
    background: rgba(0,0,0,.4); backdrop-filter: blur(8px);
    display: flex; align-items: center; gap: 6px; padding: 6px 16px;
    font-family: -apple-system, sans-serif; font-size: 12px;
  }}
  #theme-bar span {{ color: #888; margin-right: 4px; }}
  .t-btn {{
    border: 1px solid #444; background: transparent; color: #ccc;
    padding: 3px 10px; border-radius: 4px; cursor: pointer; font-size: 12px;
    transition: all .15s;
  }}
  .t-btn:hover {{ border-color: #888; color: #fff; }}
  .t-btn.active {{ border-color: #58a6ff; color: #58a6ff; }}
</style>
</head>
<body data-theme="{default_theme}">

<div id="theme-bar">
  <span>Theme:</span>
  {theme_buttons}
</div>

<article class="markdown-body">{content}</article>

<script>
const themes = {themes_json};
const DEFAULT = "{default_theme}";

function applyTheme(key) {{
  const t = themes[key];
  document.body.style.background = t.body_bg;
  document.body.style.color = t.body_color;
  const link = document.getElementById("theme-css");
  link.href = t.css_url || "";
  link.disabled = !t.css_url;
  let extra = document.getElementById("extra-css");
  if (!extra) {{ extra = document.createElement("style"); extra.id = "extra-css"; document.head.appendChild(extra); }}
  extra.textContent = t.extra_css || "";
  document.querySelectorAll(".t-btn").forEach(b => b.classList.toggle("active", b.dataset.theme === key));
  localStorage.setItem("opw-theme", key);
}}

document.querySelectorAll(".t-btn").forEach(b => {{
  b.addEventListener("click", () => applyTheme(b.dataset.theme));
}});

const saved = localStorage.getItem("opw-theme");
if (saved && themes[saved]) applyTheme(saved);
else applyTheme(DEFAULT);
</script>
</body></html>"""

def render_md(content, title=""):
  try:
    import markdown, json
    html = markdown.markdown(content, extensions=["tables", "fenced_code", "codehilite", "toc"])

    default_theme = "github-dark"
    t = MD_THEMES[default_theme]

    buttons = ""
    for key, info in MD_THEMES.items():
      active = "active" if key == default_theme else ""
      buttons += f'<button class="t-btn {active}" data-theme="{key}">{info["label"]}</button>'

    themes_json = json.dumps({
      k: {
        "label": v["label"],
        "css_url": v.get("css_url") or "",
        "body_bg": v["body_bg"],
        "body_color": v["body_color"],
        "extra_css": v.get("extra_css", ""),
      } for k, v in MD_THEMES.items()
    })

    return MD_TEMPLATE.format(
      title=title,
      css_url=t.get("css_url") or "",
      body_bg=t["body_bg"],
      body_color=t["body_color"],
      extra_css=t.get("extra_css", ""),
      default_theme=default_theme,
      theme_buttons=buttons,
      content=html,
      themes_json=themes_json,
    )
  except ImportError:
    return None

# ── Directory listing ──────────────────────────────────────────────────────

DIR_CSS = """<style>
*{box-sizing:border-box}
body{background:#0d1117;color:#e6edf3;font-family:-apple-system,sans-serif;padding:32px;margin:0}
h2{color:#7d8590;font-weight:400;font-size:14px;margin-bottom:4px}
.breadcrumb{font-size:13px;margin-bottom:16px}
.breadcrumb a{color:#58a6ff;text-decoration:none}
.breadcrumb a:hover{text-decoration:underline}
.breadcrumb span{color:#7d8590;margin:0 4px}
table{width:100%;max-width:860px;border-collapse:collapse}
td{padding:8px 12px;border-bottom:1px solid #21262d;vertical-align:middle}
td:first-child{width:24px}
.name{font-size:14px}
.name a{color:#e6edf3;text-decoration:none}
.name a:hover{color:#58a6ff}
.size{color:#7d8590;font-size:12px;width:80px;text-align:right}
.actions{width:160px;text-align:right}
.actions a{color:#58a6ff;text-decoration:none;font-size:13px;margin-left:10px}
.actions a:hover{text-decoration:underline}
tr:hover td{background:#161b22}
</style>"""

def render_index(abs_folder, url_path):
  entries = sorted(Path(abs_folder).iterdir(), key=lambda p: (p.is_file(), p.name.lower()))

  # Breadcrumb
  parts = [p for p in url_path.strip("/").split("/") if p]
  crumb = '<a href="/">root</a>'
  for i, part in enumerate(parts):
    href = "/" + "/".join(parts[:i+1]) + "/"
    crumb += f'<span>/</span><a href="{href}">{part}</a>'

  rows = ""
  if url_path != "/":
    parent = "/" + "/".join(parts[:-1]) + ("/" if parts[:-1] else "")
    rows += f'<tr><td>↩</td><td class="name"><a href="{parent}">..</a></td><td></td><td></td></tr>'

  for entry in entries:
    if entry.name.startswith("."):
      continue
    name = entry.name
    ext = entry.suffix.lower()
    entry_url = url_path.rstrip("/") + "/" + quote(name)

    if entry.is_dir():
      rows += f'''<tr>
        <td>📁</td>
        <td class="name"><a href="{entry_url}/">{name}/</a></td>
        <td class="size"></td>
        <td class="actions"><a href="{entry_url}/">Browse</a></td>
      </tr>'''
    else:
      s = entry.stat().st_size
      size = f"{s/1024:.1f} KB" if s < 1024*1024 else f"{s/1024/1024:.1f} MB"
      dl = f'<a href="{entry_url}?dl=1">Download</a>'
      if ext in VIEWABLE:
        actions = f'<a href="{entry_url}">View</a>{dl}'
      else:
        actions = dl
      rows += f'''<tr>
        <td>📄</td>
        <td class="name"><a href="{entry_url}">{name}</a></td>
        <td class="size">{size}</td>
        <td class="actions">{actions}</td>
      </tr>'''

  return f'''<!DOCTYPE html><html><head><meta charset="utf-8"><title>{url_path}</title>{DIR_CSS}</head><body>
<h2>opw</h2>
<div class="breadcrumb">{crumb}</div>
<table><tbody>{rows}</tbody></table>
</body></html>'''

# ── HTTP Handler ───────────────────────────────────────────────────────────

def make_handler(serve_root, is_folder):
  class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
      pass

    def send_html(self, html, status=200):
      data = html.encode()
      self.send_response(status)
      self.send_header("Content-Type", "text/html; charset=utf-8")
      self.send_header("Content-Length", len(data))
      self.end_headers()
      self.wfile.write(data)

    def send_file(self, filepath, download=False):
      mime, _ = mimetypes.guess_type(filepath)
      mime = mime or "application/octet-stream"
      with open(filepath, "rb") as f:
        data = f.read()
      self.send_response(200)
      self.send_header("Content-Type", mime)
      self.send_header("Content-Length", len(data))
      if download:
        self.send_header("Content-Disposition", f'attachment; filename="{os.path.basename(filepath)}"')
      self.end_headers()
      self.wfile.write(data)

    def do_GET(self):
      parsed = urlparse(self.path)
      url_path = unquote(parsed.path)
      force_dl = "dl" in parse_qs(parsed.query)

      # Map URL path to filesystem path
      rel = url_path.lstrip("/")
      fspath = os.path.normpath(os.path.join(serve_root, rel)) if rel else serve_root

      # Security: prevent path traversal
      if not fspath.startswith(serve_root):
        self.send_error(403); return

      if os.path.isdir(fspath):
        if is_folder:
          self.send_html(render_index(fspath, url_path if url_path.endswith("/") else url_path + "/"))
        else:
          self.send_error(404)
        return

      if not os.path.isfile(fspath):
        self.send_error(404); return

      if force_dl:
        self.send_file(fspath, download=True); return

      ext = os.path.splitext(fspath)[1].lower()
      if ext == ".md":
        with open(fspath) as f:
          content = f.read()
        html = render_md(content, os.path.basename(fspath))
        if html:
          self.send_html(html); return

      self.send_file(fspath, download=False)

  return Handler

# ── Main ───────────────────────────────────────────────────────────────────

def main():
  if len(sys.argv) < 2:
    print("Usage: opw <file|folder> [file2 ...]")
    sys.exit(1)

  targets = [os.path.abspath(t) for t in sys.argv[1:]]
  for t in targets:
    if not os.path.exists(t):
      print(f"Error: {t} not found"); sys.exit(1)

  if len(targets) == 1 and os.path.isdir(targets[0]):
    serve_root = targets[0]
    is_folder = True
    cleanup_tmp = False
  else:
    serve_root = tempfile.mkdtemp(prefix="opw_")
    is_folder = False
    cleanup_tmp = True
    for t in targets:
      if os.path.isfile(t):
        shutil.copy2(t, os.path.join(serve_root, os.path.basename(t)))

  ip = get_local_ip()
  port = find_free_port()
  url = f"http://{ip}:{port}/"

  socketserver.TCPServer.allow_reuse_address = True
  server = socketserver.TCPServer(("0.0.0.0", port), make_handler(serve_root, is_folder))

  def cleanup(signum=None, frame=None):
    if cleanup_tmp:
      shutil.rmtree(serve_root, ignore_errors=True)
    sys.exit(0)

  signal.signal(signal.SIGINT, cleanup)
  signal.signal(signal.SIGTERM, cleanup)

  osc52_copy(url)

  print(f"\033[90m── opw {serve_root} ──\033[0m")
  print(f"\033[1;36m  → {url}\033[0m")
  print(f"\033[90m  Copied to clipboard! Ctrl+C to stop.\033[0m")

  try:
    server.serve_forever()
  finally:
    if cleanup_tmp:
      shutil.rmtree(serve_root, ignore_errors=True)
    print(f"\033[90m── done ──\033[0m")

if __name__ == "__main__":
  main()
