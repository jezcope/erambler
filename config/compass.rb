# Require any additional compass plugins here.
require "bootstrap-sass"

# Set this to the root of your project when deployed:
http_path = "/"
project_path = "."
css_dir = "output/assets/style"
sass_dir = "content/assets/style"
images_dir = "output/assets/images"
javascripts_dir = "output/assets/javascripts"
fonts_dir = "output/assets/fonts"

output_style = :expanded
sass_options = {
  syntax: :scss,
  style:  :compressed
}

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass