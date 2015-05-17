---
title: "Go back with the mouse wheel in Chrome"
kind: article
created_at: Wed 06 May 2015 21:22:35 BST
tags:
- Programming
- Chrome
- Extension
- JavaScript
- Open source
- Things I made
---

One of the best ways of getting started developing open source software is to "scratch your own itch": when you have a problem, get coding and solve it.  So it is with this little bit of code.

Scroll Back is a very simple Chrome extension that replicates a little-known feature of Firefox: if you hold down the <kbd>Shift</kbd> key and use the mouse wheel, you can go forward and backward in your browser history.  The idea came from [issue 927 on the Chromium bug tracker][issue 927], which is a request for this very feature.

You can [install the extension from the Chrome Web Store][download] if you use Chrome (or [Chromium][]).

The code is so simple I can reproduce it here in full:

``` javascript
document.addEventListener("wheel", function(e) {
  if (e.shiftKey && e.deltaX != 0) {
    window.history.go(-Math.sign(e.deltaX));
    return e.preventDefault();
  }
});
```

- Line 1 adds an event listener which is executed every time the user uses the scroll wheel.
- If the <kbd>Shift</kbd> key is held down and the user has scrolled (line 2), line 3 goes backward or forward in the history according to whether the user scrolled down or up respectively (`e.deltaX` is positive for down, negative for up)
- Line 4 prevents any unwanted side-effects of scrolling.

The code is automatically executed every time a page is loaded, so has the effect of enabling this behaviour in all pages.

It's open source (licensed under the [MIT License](LICENSE.txt)), so you can [check out the full source code on github][github].

[issue 927]: https://code.google.com/p/chromium/issues/detail?id=927#c18

[github]: https://github.com/jezcope/chrome-scroll-back

[download]: https://chrome.google.com/webstore/detail/scroll-back/bhhdgkdmcbgoecgmdgbkabdbjcihafgc?hl=en-GB&gl=GB

[Chromium]: http://www.chromium.org/
