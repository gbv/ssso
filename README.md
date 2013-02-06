This repository contains the **Simple Service Status Ontology (SSSO)**.

The URI of this ontology is <http://purl.org/ontology/ssso> and it's URI
namespace is <http://purl.org/ontology/ssso#>.

# Synopsis

According to the Simple Service Status Ontology, a **Service** is an event with
a specific starting time and/or ending time. Related services can be connected
to each other in time as **nextService** and **previousService**. Each service
can be provided by one ore more **ServiceProvider** and consumed by one or more
**ServiceConsumer**. A service fulfillment is modeled by a set of connected
services. For this purpose SSSO defines five specific disjoint service status,
**ReservedService**, **PreparedService**, **ProvidedService**,
**ExecutedService**, and **RejectedService**.

# Feedback

Feedback is welcome most in form of git pull requests or tracked issues:

* https://github.com/gbv/ssso/issues

# Development

The ontology is created by *document driven development* (similar to literal
programming). There is only one source file `ssso.md` written in [Pandoc
Markdown](http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html).
Both the RDF serialization in RDF/Turtle (or RDF/XML) and the documentation in
HTML are automatically derived from the source file. This requires:

* [Pandoc](http://johnmacfarlane.net/pandoc/), at least 1.9
* [Rapper](http://librdf.org/raptor/rapper.html) from Raptor RDF library

All rules are included in `Makefile`. Just call `make` to (re)create everything, 
or `make html`, `make ttl`, `make owl` to only create selected parts.

To clone this repository:

    git clone git://github.com/gbv/ssso.git

To also clone the HTML version branch, which is presented at
<http://gbv.github.com/ssso>:

    git checkout -b gh-pages origin/gh-pages

