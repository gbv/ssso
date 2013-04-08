% Simple Service Status Ontology (SSSO)
% Jakob Voß
% GIT_REVISION_DATE

# Introduction

The **Simple Service Status Ontology (SSSO)** is an event-based RDF ontology
for typical status in fulfillment of a service.

## Status of this document

This specification is managed in a public git repository at
<http://github.com/gbv/ssso>. The master file
[ssso.md](https://github.com/gbv/ssso/blob/master/ssso.md) is written in
[Pandoc’s
Markdown](http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html).
The current version hash is GIT_REVISION_HASH.

RDF serializations of the Simple Service Status Ontology exist as 
[**`ssso.ttl`**](ssso.ttl) in RDF/Turtle as [**`ssss.owl`**](ssso.owl), both
generated from Markdown via [makespec](https://github.com/jakobib/makespec).

**How to contribute**

* Express data in RDF with SSSO!
* Map other ontologies to SSSO!
* [Comment](https://github.com/gbv/ssso/issues) on the specification!
* [Correct](https://github.com/gbv/ssso/blob/master/ssso.md) the current SSSO draft!

**Revision history**

GIT_CHANGES

## Terminology

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in RFC 2119.

## Namespaces and ontology

The URI namespace of this ontology is <http://purl.org/ontology/ssso#>. The
namespace prefix `ssso` is recommeded. The URI of this ontology as a whole
is <http://purl.org/ontology/ssso>.

    @prefix ssso: <http://purl.org/ontology/ssso#> .
    @base         <http://purl.org/ontology/ssso> .

The following namspace prefixes are used to refer to [related ontologies]:

    @prefix crm:     <http://purl.org/NET/cidoc-crm/core#> .
    @prefix dcterms: <http://purl.org/dc/terms/> .
    @prefix dctype:  <http://purl.org/dc/dcmitype/> .
    @prefix dul:     <http://www.loa-cnr.it/ontologies/DUL.owl#> .
    @prefix event:   <http://purl.org/ontology/c4dm/event.owl#> .
    @prefix foaf:    <http://xmlns.com/foaf/0.1/> .
    @prefix gr:      <http://purl.org/goodrelations/v1#> .
    @prefix lode:    <http://linkedevents.org/ontology/> .
    @prefix ncal:    <http://www.semanticdesktop.org/ontologies/2007/04/02/ncal#> .
    @prefix owl:     <http://www.w3.org/2002/07/owl#> .
    @prefix prov:    <http://www.w3.org/ns/prov#> .
    @prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix schema:  <http://schema.org/> .
    @prefix tio:     <http://purl.org/tio/ns#> .
    @prefix vann:    <http://purl.org/vocab/vann/> .
    @prefix xsd:     <http://www.w3.org/2001/XMLSchema#> .

The Simple Service Status Ontology (SSSO) is defined in RDF/Turtle as following:

    <> a owl:Ontology ;
        rdfs:label "Simple Service Status Ontology" ;
        rdfs:label "SSSO" ;
        vann:preferredNamespacePrefix "ssso" .

# Overview

A [ServiceFulfillment] according to SSSO is modeled as set of service events,
each being an instance of [ServiceEvent]. Examples of a [ServiceFulfillment]
include the purchase of a product in a shop, the attendance at a performance,
and the lending of a book in a library. In contrast to [related ontologies],
each [ServiceEvent] and each [ServiceFulfillment] is a not a general offer but
a particular activity in time. The activity typically takes place provided by
at least one particular [ServiceProvider] (e.g. a shop, presenter, or library)
and consumed by at least one [ServiceConsumer] (e.g. a customer, attendee, or
patron). Multiple service event that belong to one service fulfillment should
be connected in time with properties [nextService] and [previousService].

The following diagram illustrates the classes and properties defined in this
ontology:

``` {.ditaa}
                                   nextService / previousService
                                              ------
                                             |      |
                                             v      v
   +-----------------+   provides     +--------------------+   consumedBy   +-----------------+
   | ServiceProvider |--------------->|    ServiceEvent    |--------------->| ServiceConsumer |
   |                 |<---------------|                    |<---------------|                 |
   +-----------------+   providedBy   |   ReservedService  |   consumes     +-----------------+
                                      |   PreparedService  |
                                      |   ProvidedService  |
        +------------+   limits       |   ExecutedService  |   delay    
        | Limitation |--------------->|   RejectedService  |-------------> duration-or-time
        |            |<---------------|                    |-------------> xsd:nonNegativeInteger
        +------------+  limitedBy     | ServiceFulfillment |   queue
                                      +-----^--------------+
                                            |      ^
                                            |      |
                                             ------
                               dcterms:hasPart / dcterms:partOf
```

## Service status

SSSO defines five typical service status as disjoint subclasses of
[ServiceEvent]. Actual service fulfillments do not need to implement all of
these service status.

* A [ReservedService] is in status **reserved**:\
  the service has been accepted for execution but no action has taken place.
  Possible examples include an order of a product that must be paid in advance
  but has not been paid yet, or the reservation of a book in a library that is 
  not accesible yet.

* A [PreparedService] is in status **prepared**:\
  the execution is being prepared but is has not actually started. A possible
  example is a product being sent to the customer.

* A [ProvidedService] is in status **provided**:\
  the service is ready to be executed on request. An example is a product
  that is ready to be picked up by a customer.

* A [ExecutedService] is in status **executed**:\
  the service is actually being executed. For instance this activity can be
  the event when a bought product is handed over to the customer, the time
  of a performance, or the time a book is held on loan by a patron.

* A [RejectedService] is in status **rejected**:\
  the service has been refused or stopped. A possible example is a 
  canceled contract.

## Service limitations

SSSO also defines the class [ServiceLimitation] and the properties [limits],
[limitedBy], [delay], and [queue] to express limitations of services.

## Service types and times

This ontology does not make any assumptions about types of services.  To define
service types, define a subclass of [ServiceEvent].  The class [TimeTravel] is
included in SSSO as artifical example of a service type.

SSSO does neither define (yet another) set of properties to relate a service
event to the time when it started and/or ended. To express such times, one
should better use existing properties from related ontologies, such as:

* [schema:startDate] and [schema:endDate]
* [prov:startedAtTime](#) and [prov:endedAtTime](#)
* [tio:starts](#http://purl.org/tio/ns#starts) and [tio:ends](#http://purl.org/tio/ns#ends)
* [lode:atTime](#http://linkedevents.org/ontology/#term-atTime) or
  [lode:circa](#http://linkedevents.org/ontology/#term-circa)
* [dcterms:date](#http://dublincore.org/documents/dcmi-terms/#terms-date)

The property values SHOULD be modeled as instance of [xsd:dateTime] or
[xsd:date]. The starting time of a service event (if given) MUST be equal to or
earlier than the ending time of the same service event (unless the service is
an instance of [TimeTravel] and [ExecutedService]).

To express an estimated and additional time, SSSO defines the property [delay]
which can also hold a relative duration. Applications SHOULD NOT use this
property to relate a service event to its normal time, unless this time is
an additional constraint.

# Classes

## ServiceEvent

[ServiceEvent]: #ServiceEvent

A service event is an activity that takes places during a specific time. The
event can be connected to one or more [ServiceProvider] with property
[providedBy] and to one or more [ServiceConsumer] with property [consumedBy].

Several [related ontologies] have been proposed to model events or activities
with suprisingly low interconnections. SSSO is agnostic to these ontologies, so
[ServiceEvent] is related to classes in all of them to make happy multiple
communities. A [ServiceEvent] is further subclass of [schema:IndividualProduct] 
and [gr:Individual], which imply [schema:Product] and [gr:ProductOrService].
Nevertheless, SSSO does not make any assumptions whether a [ServiceEvent] is
actually sold or just provided for free.

    ssso:ServiceEvent a owl:Class ;
        rdfs:label "ServiceEvent" ;
        rdfs:subClassOf 
            dctype:Event , 
            event:Event , 
            prov:Activity , 
            lode:Event , 
            dul:Event ,
            crm:E7_Activity ,
            ncal:Event ,
            schema:Event ,
            tio:Event ,
            schema:IndividualProduct ,
            gr:Individual ;
            rdfs:isDefinedBy <> .

## ServiceFulfillment

[ServiceFulfillment]: #servicefulfillment

A Service fulfillment is a [ServiceEvent] that consists of one or more parts. Each
of these parts is also a [ServiceEvent] and connected to the service fulfillment by
`dcterms:partOf`. Vice versa, each instance of [ServiceEvent] is also instance of
[ServiceFulfillment] if connected to another [ServiceEvent] by [dcterms:hasPart].
The parts of a service fulfillment SHOULD be connected to each other by
[nextService] and [previousService].

    ssso:ServiceFulfillment a owl:Class ;
        rdfs:label "ServiceFulfillment" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        rdfs:isDefinedBy <> .

## ReservedService

[ReservedService]: #reservedService

A reserved service is a [ServiceEvent] that has been accepted by a service provider
for execution but not prepared yet. The reserved service has neither been
prepared by a service provider but only queued for further processing.  A
typical example is a product order that has been placed but not payed yet or a
payed ticket to a theater performance.

    ssso:ReservedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith 
          ssso:PreparedService, ssso:ProvidedService, 
          ssso:ExecutedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## PreparedService

[PreparedService]: #preparedservice

A prepared service is being prepared to be provided or executed. A typical example 
is a product that is being send to its consumer.

    ssso:PreparedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:ProvidedService, 
          ssso:ExecutedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## ProvidedService

[ProvidedService]: #providedservice

A provided service is being made available for immediate execution. A typical example is a
product that is ready for being picked up by its consumer.

    ssso:ReservedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ExecutedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## ExecutedService

[ExecutedService]: #executedservice

An executed service represents the actual execution event of fulfillment of a
service. A typical example is a theater performance that is being played.

    ssso:ExecutedService a owl:Class ;
        rdfs:label "ExecutedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ProvidedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## RejectedService

[RejectedService]: #rejectedservice

A rejected service is a [ServiceEvent] that has been rejected by its provider or by
its consumer. The rejection may be infinite or it may be followed by another
service when the reason for rejection has been removed.

    ssso:RejectedService a owl:Class ;
        rdfs:label "RejectedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ProvidedService, ssso:ExecutedService ;
        rdfs:isDefinedBy <> .

## ServiceProvider

[ServiceProvider]: #serviceprovider

A service provider is an entity that is responsible for providing a [ServiceEvent].
Typical providers, such as organizations and people, are also instances of
[foaf:Agent] and [gr:BusinessEntity] but SSSO does not put any constraints on
the nature of providers.

    ssso:ServiceProvider a owl:Class ;
        rdfs:label "ServiceProvider" ;
        rdfs:isDefinedBy <> .

## ServiceConsumer

[ServiceConsumer]: #serviceconsumer

A service consumer is an entity that is requesting or consuming a [ServiceEvent].
Typical consumers, such as organizations and people, are instances of
[foaf:Agent] and [gr:BusinessEntity] but SSSO does not put any constraints on
the nature of consumers.

    ssso:ServiceConsumer a owl:Class ;
        rdfs:label "ServiceConsumer" ;
        rdfs:isDefinedBy <> .

## ServiceLimitation

[ServiceLimitation]: #servicelimitation

A service limitation is some obstacle that may limit the use of a
[ServiceEvent]. For instance the purchase of guns and drugs is limited to
consumers with special permission. Another example is providing a different
product or activity than originally requested. Services and limitations
are connected to each other with properties [limits] and [limitedBy].

    ssso:ServiceLimitation a owl:Class ;
        rdfs:label "ServiceLimitation" ;
        rdfs:isDefinedBy <> .

## TimeTravel

[TimeTravel]: #timetravel

An event which ends before it has been started. Details have been implemented
in the future.

    ssso:TimeTravel a owl:Class ;
        rdfs:label "TimeTravel" ;
        rdfs:isDefinedBy <> .

# Properties

## provides

[provides]: #provides

Relates a [ServiceProvider] instance to a [ServiceEvent] instance .

    ssso:provides a owl:ObjectProperty ;
        rdfs:label "provides" ;
        rdfs:domain ssso:ServiceProvider ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:providedBy ;
        rdfs:isDefinedBy <> .

## providedBy

[providedBy]: #providedBy

Relates a [ServiceEvent] instance to a [ServiceProvider] instance.

    ssso:providedBy a owl:ObjectProperty ;
        rdfs:label "providedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceProvider ;
        owl:inverseOf ssso:provides ;
        rdfs:isDefinedBy <> .

## consumes

[consumes]: #consumes

Relates a [ServiceConsumer] instance to a [ServiceEvent] instance.

    ssso:consumes a owl:ObjectProperty ;
        rdfs:label "consumes" ;
        rdfs:domain ssso:ServiceConsumer ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:consumedBy ;
        rdfs:isDefinedBy <> .

## consumedBy

[consumedBy]: #consumedBy

Relates a [ServiceEvent] instance to a [ServiceConsumer] instance.

    ssso:consumedBy a owl:ObjectProperty ;
        rdfs:label "consumedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceConsumer ;
        owl:inverseOf ssso:consumes ;
        rdfs:isDefinedBy <> .

## limits

[limits]: #limits

Relates a [ServiceLimitation] instance to a [ServiceEvent] instance.

    ssso:limits a owl:ObjectProperty ;
        rdfs:label "limits" ;
        rdfs:domain ssso:ServiceLimitation ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:limitedBy ;
        rdfs:isDefinedBy <> .

## limitedBy

[limitedBy]: #limitedBy

Relates a [ServiceEvent] instance to a [ServiceLimitation] instance.

    ssso:limitedBy a owl:ObjectProperty ;
        rdfs:label "limitedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceLimitation ;
        owl:inverseOf ssso:limits ;
        rdfs:isDefinedBy <> .

## delay

[delay]: #delay

This property can be used to specify an estimated period of time or a date when
a [ServiceEvent] is expected to take place. Applications SHOULD use values in
the range of [xsd:duration], [xsd:dateTime], [xsd:date] or the special value
"unknown" (to indicate a delay of unknown duration). The range may later be
extended to a subset of Extended Date/Time Format (EDTF).

    ssso:queue a owl:DatatypeProperty ;
        rdfs:label "delay" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:isDefinedBy <> .

[xsd:dateTime]: http://www.w3.org/TR/xmlschema-2/#dateTime
[xsd:date]: http://www.w3.org/TR/xmlschema-2/#date
[xsd:duration]: http://www.w3.org/TR/xmlschema-2/#duration

## queue

[queue]: #queue

This property can be used to indicate the size of a waiting queue for some
[ServiceEvent]. Its value must be a non-negative integer (0,1,2...).

    ssso:queue a owl:DatatypeProperty ;
        rdfs:label "queue" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range xsd:nonNegativeInteger ;
        rdfs:isDefinedBy <> .

## nextService

[nextService]: #nextservice

Relates a service instances to another service instance which is following in
time.  The starting time of the following service instance MUST be equal or
later then the ending time of the previous service (unless one of the services
is an instance of [TimeTravel] and [ExecutedService]).

    ssso:nextService a owl:ObjectProperty ;
        rdfs:label "nextService" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range  ssso:ServiceEvent ;
        owl:inverseOf ssso:previousService ;
        rdfs:isDefinedBy <> .

## previousService

[previousService]: #previousservice

Relates a service instances to another service instance which is preceding in
time.  The ending time of the previousg service instance MUST be equal or
earlier then the starting time of the next service  (unless one of the services
is an instance of [TimeTravel] and [ExecutedService]).

    ssso:previousService a owl:ObjectProperty ;
        rdfs:label "previousService" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range  ssso:ServiceEvent ;
        owl:inverseOf ssso:nextService ;
        rdfs:isDefinedBy <> .

# Rules

The following inference rules apply:

``` {.n3}
# domains and ranges
{ $p ssso:provides $s }        => { $p a ssso:ServiceProvider . $s a ssso:ServiceEvent } .
{ $s ssso:providedBy $p }      => { $p a ssso:ServiceProvider . $s a ssso:ServiceEvent } .
{ $l ssso:limits $s }          => { $l a ssso:ServiceLimitation . $s a ssso:ServiceEvent } .
{ $s ssso:limitedBy $l }       => { $l a ssso:ServiceLimitation . $s a ssso:ServiceEvent } .

{ $c ssso:consumes $s }        => { $c a ssso:ServiceConsumer . $s a ssso:ServiceEvent } .
{ $s ssso:consumedBy $c }      => { $c a ssso:ServiceConsumer . $s a ssso:ServiceEvent } .
{ $a ssso:nextService $b }     => { $a a ssso:ServiceEvent . $b a ssso:ServiceEvent } .
{ $a ssso:previousService $b } => { $a a ssso:ServiceEvent . $b a ssso:ServiceEvent } .

# inverse properties
{ $a dcterms:hasPart $b }      <=> { $b dcterms:partOf $a } .
{ $p ssso:provides $s }        <=> { $s ssso:providedBy $p } .
{ $c ssso:consumes $s }        <=> { $s ssso:consumedBy $p } .
{ $l ssso:limits $s }          <=> { $s ssso:limitedBy $l } .
{ $a ssso:previousService $b } <=> { $b ssso:nextService $a } .

# subclasses
{ $s a ssso:ServiceFulfillment } => { $s a ssso:ServiceEvent } .
{ $s a ssso:ReservedService }    => { $s a ssso:ServiceEvent } .
{ $s a ssso:PreparedService }    => { $s a ssso:ServiceEvent } .
{ $s a ssso:ProvidedService }    => { $s a ssso:ServiceEvent } .
{ $s a ssso:ExecutedService }    => { $s a ssso:ServiceEvent } .
{ $s a ssso:RejectedService }    => { $s a ssso:ServiceEvent } .

# service fulfillment
{ $a a ssso:ServiceEvent . $b a ssso:ServiceEvent . $a dcterms:hasPart $b } => { $a a ssso:ServiceFulfillment } .
```

# Related ontologies

[related ontologies]: #related-ontologies

The core class [ServiceEvent] is subclass of event and activity classes from several
related ontologies. The large number of similar classes may result from an inability 
of ontology engineers to agree on semantics or the dislike to refer to ontologies that
have been designed by someone else. The related classes and ontologies include:

* [dctype:Event] from Dublin Core Metadata Terms
* [schema:Event] from Schema.org Ontology
* [event:Event] from Event ontology
* prov:Activity from Provenance ontology
* E7_Activity from the [CIDOC Conceptual Reference Model](http://www.cidoc-crm.org/) expressed in OWL
* lode:Event from LODE ontology (Linking Open Descriptions of Events)
* dul:Event from DOLCE+DnS Ultralite ontology
* ncal:Event from NEPOMUK Calendar Ontology
* tio:Event from Tickets ontology

SSSO further makes use of the Dublin Core Metadata Terms [dcterms:hasPart] and
[dcterms:partOf].

The relation between SSSO, Schema.org, and [GoodRelations] can best be
described by some examples (taken from [GoodRelations], licensed under CC-BY-SA
3.0):

* "Peter Miller offers to repair TV sets made by Siemens" is an instance of
  [gr:Offering] and [schema:Offer]. "Peter Miller repairs a TV set for Lena 
  Meyer" is an instance of [ServiceEvent], [gr:Individual], 
  [gr:ProductOrService], and [schema:IndividualProduct].
* "Volkswagen Innsbruck sells a particular instance of a Volkswagen Golf at 
  $10,000" is an instance of [gr:Offering] and [schema:Offer]. When a 
  particular customer buys one of this cars, it is an instance of [ServiceEvent],
  [gr:Individual], [gr:ProductOrService], and [schema:IndividualProduct].
* An offer for a "Ticket for Bryan Adams at the Verizon Wireless Amphitheatre" 
  is an instance of [gr:Offering] and [schema:Offer]. The "purchase of a ticket 
  and attendence of the concert by Ada Smith and her friend" is an instance of
  [ServiceFulfillment], [ServiceEvent], [gr:Individual], and 
  [schema:IndividualProduct]. The ticket (an instance of [tio:ActualTicket]) and 
  the actual concert are additional instances of [ServiceEvent] connected to 
  the [ServiceFulfillment] with [dcterms:partOf].

In short, a [gr:Offering] refers to a *potential* [ServiceEvent] (and possibly
[ServiceFulfillment]), which is typically also an instance of [gr:Individual],
[gr:ProductOrService], and [schema:Product].


[dcterms:hasPart]: http://dublincore.org/documents/dcmi-terms/#terms-hasPart
[dcterms:partOf]: http://dublincore.org/documents/dcmi-terms/#terms-partOf

[dctype:Event]: http://dublincore.org/documents/dcmi-terms/#dcmitype-Event
[dctype:Service]: http://dublincore.org/documents/dcmi-terms/#dcmitype-Service

[event:Event]: http://motools.sourceforge.net/event/event.html#term_Event

[foaf:Agent]: http://xmlns.com/foaf/spec/#term_Agent

[gr:BusinessEntity]: http://purl.org/goodrelations/v1#BusinessEntity
[gr:Individual]: http://purl.org/goodrelations/v1#Individual
[gr:Offering]: http://purl.org/goodrelations/v1#Offering
[gr:ProductOrService]: http://purl.org/goodrelations/v1#ProductOrService
[gr:offers]: http://purl.org/goodrelations/v1#offers
[gr:seeks]: http://purl.org/goodrelations/v1#seeks

[schema:Event]: http://schema.org/Event
[schema:Product]: http://schema.org/Product
[schema:IndividualProduct]: http://schema.org/IndividualProduct
[schema:Offer]: http://schema.org/Offer
[schema:startDate]: http://schema.org/Event
[schema:endDate]: http://schema.org/Event

[tio:ActualTicket]: http://purl.org/tio/ns#ActualTicket

[GoodRelations]: http://www.heppnetz.de/projects/goodrelations/

# References

## Normative References

* **[RFC 2119]** S. Bradner: *Key words for use in RFCs to Indicate Requirement Levels*. 
  March 1997 <http://tools.ietf.org/html/rfc2119>.

* **[RFC 2396]** T. Berners-Lee et al.: *Uniform Resource Identifiers (URI): Generic Syntax*.
  August 1998 <http://tools.ietf.org/html/rfc2396>.

## Informative References

SSSO is loosely connected to the following ontologies: it is compatible with
them but their use is optional. Feel free to rely on or ignore additional parts
Offering these ontologies when using SSSO.

* *Dublin Core Metadata Terms*. 
  <http://dublincore.org/documents/dcmi-terms/> .
* *Schema.org Ontology*. 
  <http://schema.org/> .
* *Event Ontology*. 
  <http://motools.sourceforge.net/event/event.html> .
* *Provenance Ontology*. 
  <http://www.w3.org/TR/prov-o/> .
* *Linking Open Descriptions of Events*.
  <http://linkedevents.org/ontology/> .
* *NEPOMUK Calendar Ontology*.
  <http://www.semanticdesktop.org/ontologies/ncal/> .
* *DOLCE+DnS Ultralite (DUL) ontology*. 
  *<http://ontologydesignpatterns.org/wiki/Ontology:DOLCE+DnS_Ultralite>*.
* *CIDOC CRM in OWL 2*.
  <http://bloody-byte.net/rdf/cidoc-crm/>.
* *GoodRelations*.
  <http://purl.org/goodrelations/>.
* *Tickets Ontology*
  <http://purl.org/tio>.

SSSO was motivated by the design of an ontology for the Patrons Account
Information API (PAIA, <http://purl.org/ontology/paia>). It includes concepts
formerly included in the specification of Document Availability Information API
(DAIA, <http://github.com/gbv/daiaspec>).

