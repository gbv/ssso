This repository contains the **Simple Service Status Ontology (SSSO)**. The
ontology is created by document driven development, similar to literal
programming. The source file `ssso.md` is written in 
[Pandoc Markdown](http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html).

Feedback is welcome most in form of git pull requests or tracked issues:

* https://github.com/gbv/ssso/issues

Creating a nice HTML version and other output formats from `paia.md` requires
[Pandoc](http://johnmacfarlane.net/pandoc/) 1.9: simply call `make` in your
working directory. With `make ttl` you get the ontology in RDF/Turtle.
