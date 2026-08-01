#!/usr/bin/env python3
"""Serves frontend/build/web for local preview with caching fully disabled.

Flutter's web bootstrap loads main.dart.js via a fixed, non-versioned URL
(no content hash query string), so a plain `python -m http.server` lets
browsers heuristically cache a stale build indefinitely between rebuilds
with no visible error - the app just silently keeps running old code.
Every response here gets `Cache-Control: no-store` to rule that out.
"""

import functools
import http.server
import sys


class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
    directory = sys.argv[2] if len(sys.argv) > 2 else "."
    handler = functools.partial(NoCacheHandler, directory=directory)
    http.server.test(HandlerClass=handler, port=port)
