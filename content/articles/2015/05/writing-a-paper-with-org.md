---
title: "Writing a paper with org-mode"
kind: article
created_at: Thu May 28 18:49:39 2015
tags:
- Org-mode
- Emacs
- Ruby
- Zotero
- Writing
---

[Emacs org-mode](http://orgmode.org) is a powerful tool, as I've [written about before][before].  As well being good at project and task management, it also has features for writing documents:

- Export in a variety of formats, including HTML, [OpenDocument](http://en.wikipedia.org/wiki/OpenDocument) and [LaTeX](http://en.wikipedia.org/wiki/LaTeX)
- Embed snippets of code (in your favourite language), execute them and include the results (and optionally the code itself) in the exported document

I'll come back to why that's useful in a moment.

I've had a presentation (a position paper on preserving software) accepted for the LIBER conference next month.  I may choose to subsequently submit it as an article to LIBER Quarterly (this is a relatively common pattern) so I thought I'd try writing the article and the presentation together in a single document, and see how it worked.  If nothing else, writing the paper will help me structure my ideas for the presentation, even if it never gets published.

There are probably other ways of doing it, but I've set it up so that exporting in different formats gives me the two different versions of the document:

- *Export as LaTeX* produces a PDF version of the presentation slides, using the Beamer package.
- *Export as OpenDocument text* produces the article, ready for submission.

It took a little sleight of hand, but I'm putting my Beamer slides in `#+BEGIN_LaTeX` blocks, which org-mode will include in the LaTeX export but not any other format, and I've configured Beamer to ignore any text outside frames, which forms the body of the article.

I don't want the abstract and other metadata cluttering up the document itself, so I've pushed those out to a separate file and used an `#+INCLUDE` statement to pull it into the main document at export time.

The one thing missing is a built-in way of integrating with Zotero, which I use as my bibliographic database, to format my references.  However, [Zotero has a very functional API][Zotero API], so I've put together a short Ruby script that grabs a Zotero collection and tweaks the formatting.  Whenever I export the document from org-mode, the code is run and the result (a formatting bibliography) is embedded in the finished version.

```ruby
require 'open-uri'; require 'rexml/document'
url = "https://api.zotero.org/groups/#{group_id}/collections/#{coll_id}/items/top?format=bib&style=#{style}"
REXML::Document.new(open(url)).elements.each('//div[@class="csl-entry"]') do |entry|
  puts '- ' + entry.children
              .collect{|c| if c.instance_of? REXML::Text then c.value else c.text end}
              .join.gsub(%r{</?i>}, '/').gsub(%r{/\(}, '/ (')
end
```
 
This formats a Zotero collection, converting HTML `<i>` tags to the equivalent org-mode markup.  It requires three parameters, `group_id`, `coll_id` and `style`, which can be configured in the org-mode document and passed through when emacs executes the code.  The same snippet could thus be used in multiple documents, just varying the parameters to format a different set of references.

Clearly, embedding executable source code in a document has a lot more potential than I've used here.  It allows data analysis and visualisation code to be embedded directly in a document, even with the option of processing data from tables that are also in the document.  You can also use it to write entire programs in the Literate Programming style, formatting them in the way that makes most narrative sense but exporting ("tangling") pure executable source code.

Once I'm sure it's not a violation of the journal's policy, I'll push the source of the two documents up to github in case anyone wants to see how I've done it.

[before]: /blog/gtd-emacs-org-mode/

[Zotero API]: https://www.zotero.org/support/dev/web_api/v3/start

