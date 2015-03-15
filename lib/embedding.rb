def embed_youtube(code_or_url)
  code = code_or_url.gsub(%r{https?://(www\.)?youtube\.com/watch\?v=}, "")
  %{<iframe width="487" height="274" src="https://www.youtube.com/embed/#{code}" frameborder="0" allowfullscreen></iframe>}
end
