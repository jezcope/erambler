def embed_youtube(code_or_url)
  code = code_or_url.gsub(%r{https?://(www\.)?youtube\.com/watch\?v=}, "")
  %{<div class="video-container"><iframe width="487" height="274" src="https://www.youtube.com/embed/#{code}" frameborder="0" allowfullscreen></iframe></div>}
end
