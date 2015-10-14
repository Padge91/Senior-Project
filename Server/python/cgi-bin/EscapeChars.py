__author__ = 'nicholaspadgett'

from xml.sax.saxutils import escape, unescape
from HTMLParser import HTMLParser

html_escape_table = {
 "&": "&amp;",
 '"': "&quot;",
 "'": "&apos;",
 ">": "&gt;",
 "<": "&lt;",
 }

html_unescape_table = {v:k for k, v in html_escape_table.items()}

def html_escape(text):
    return escape(text, html_escape_table)

def html_unescape(text):
    return unescape(text, html_unescape_table)

class MLStripper(HTMLParser):
    def __init__(self):
        self.reset()
        self.fed = []
    def handle_data(self, d):
        self.fed.append(d)
    def get_data(self):
        return ''.join(self.fed)

def strip_tags(html):
    s = MLStripper()
    s.feed(html)
    return s.get_data()