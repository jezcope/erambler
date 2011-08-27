this.WebFontConfig =
  google:
    families: [ 'Gentium+Basic:400,400italic:latin', 'Amaranth:700,700italic:latin' ]

wf = document.createElement 'script'
scheme = if 'https:' == document.location.protocol then 'https' else 'http'
wf.src = "#{scheme}://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
wf.type = 'text/javascript'
wf.async = 'true'

s = document.getElementsByTagName('script')[0]
s.parentNode.insertBefore(wf, s)