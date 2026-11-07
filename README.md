adamralph.github.com
====================

This is the source code for [adamralph.com](https://adamralph.com/).

Local preview
-------------

GitHub Pages builds the site with its own pinned gems, described by `Gemfile`. That toolchain needs Ruby 3.x.

For local previews on a newer Ruby, `serve.sh` uses `Gemfile.local` instead:

    ./serve.sh

Then browse to <http://localhost:4000/>.
