# Introduction

The **Simple Service Status Ontology (SSSO)** is an event-based RDF ontology
for typical status in fulfillment of a service. A service in SSSO is an event
that is provided as product. The specification of SSSO was motivated by the
design of an ontology of [Patrons Account Information API] (PAIA) and
a redesign of an ontology of [Document Availability API] (DAIA).

## Status of this document

This specification is managed in a public git repository at
<http://github.com/gbv/ssso>. The master file
[ssso.md](https://github.com/gbv/ssso/blob/master/ssso.md) is written in
[Pandoc’s
Markdown](http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html).
The current version hash is {GIT_REVISION_HASH}.

RDF serializations of the Simple Service Status Ontology exist as 
[**`ssso.ttl`**](ssso.ttl) in RDF/Turtle as [**`ssss.owl`**](ssso.owl), both
generated from Markdown via [makespec](https://github.com/jakobib/makespec).

**How to contribute**

* Express data in RDF with SSSO!
* Map other ontologies to SSSO!
* [Comment](https://github.com/gbv/ssso/issues) on the specification!
* [Correct](https://github.com/gbv/ssso/blob/master/ssso.md) the current SSSO draft!

**Revision history**

{GIT_CHANGES}

## Terminology

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in RFC 2119.

## Namespace and prefix

The URI namespace of Simple Service Status Ontology (SSSO) is 
<http://purl.org/ontology/ssso#>. The namespace prefix `ssso` SHOULD be used.
The URI of this ontology as a whole is <http://purl.org/ontology/ssso>.

The ontology is defined in RDF/Turtle as following:

    @prefix ssso: <http://purl.org/ontology/ssso#> .
    @base         <http://purl.org/ontology/ssso> .

    @prefix owl:  <http://www.w3.org/2002/07/owl#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix vann: <http://purl.org/vocab/vann/> .
    @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .

    <> a owl:Ontology ;
        rdfs:label "Simple Service Status Ontology" ;
        rdfs:label "SSSO" ;
        vann:preferredNamespacePrefix "ssso" .

## Related ontologies

[related ontologies]: #related-ontologies

Several existing ontologies include classes to model events or activities. 
Interconnections between these related ontologies, however, are rare. The
large number of similar classes may result from an inability of ontology 
engineers to agree on semantics or from the dislike to refer to ontologies that
have been designed by someone else. The related ontologies are:

* [Dublin Core Metadata Terms]
* [Schema.org Ontology]
* [Event Ontology]
* [Provenance Ontology]
* [CIDOC-CRM] (CIDOC Conceptual Reference Model)
* [Linking Open Descriptions of Events] (LODE)
* [DOLCE+DnS Ultralite ontology] (DUL)
* [NEPOMUK Calendar Ontology]
* [Tickets Ontology]

The following namespace prefixes are used to refer to related ontologies:

    @prefix crm:     <http://purl.org/NET/cidoc-crm/core#> .
    @prefix dcterms: <http://purl.org/dc/terms/> .
    @prefix dctype:  <http://purl.org/dc/dcmitype/> .
    @prefix dul:     <http://www.loa-cnr.it/ontologies/DUL.owl#> .
    @prefix event:   <http://purl.org/ontology/c4dm/event.owl#> .
    @prefix foaf:    <http://xmlns.com/foaf/0.1/> .
    @prefix geo:     <http://www.w3.org/2003/01/geo/wgs84_pos#> .
    @prefix gr:      <http://purl.org/goodrelations/v1#> .
    @prefix lode:    <http://linkedevents.org/ontology/> .
    @prefix ncal:    <http://www.semanticdesktop.org/ontologies/2007/04/02/ncal#> .
    @prefix prov:    <http://www.w3.org/ns/prov#> .
    @prefix schema:  <http://schema.org/> .
    @prefix tio:     <http://purl.org/tio/ns#> .


# Overview

A [ServiceEvent] according to SSSO is an event that is provided as product.
Examples of [ServiceEvent] and [ServiceFulfillment] include a particular
purchase of a product in a shop, a specific attendance at a performance, and
a certain lending of a book in a library. The event is an activity in time that
is typically provided by one or more [ServiceProvider] (e.g. a shop, presenter,
or library) and consumed by one or more [ServiceConsumer] (e.g. a customer,
attendee, or patron). 

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
[ServiceEvent]. Multiple [ServiceEvent] that belong to one [ServiceFulfillment]
SHOULD be connected in time with properties [nextService] and
[previousService]. An actual [ServiceFulfillment] does not need to implement
all of these service status.

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

## Service types

SSSO does not make any assumptions about types of services.  To define service
types, define a subclass of [ServiceEvent].  The class [TimeTravel] is included
in SSSO as toy example of an artificial service type. See the [Document Service
Ontology](http://gbv.github.com/dso) (DSO) for more practical examples of
service types based on SSSO.

## Service times

SSSO does not define (yet another) set of properties to relate a service event
to the time when it started and/or ended. The following properties from
[related ontologies] are RECOMMENDED instead:

* ... from [CIDOC-CRM]
* [schema:startDate] and [schema:endDate] from [Schema.org Ontology]
* [prov:startedAtTime] and [prov:endedAtTime] from [Provenance Ontology]
* [tio:starts] and [tio:ends] from [Tickets Ontology]
* [lode:atTime] and [lode:circa] from from [Linking Open Descriptions of Events]
* [dcterms:date]
* ... from [DOLCE+DnS Ultralite Ontology]
* ... from [Event Ontology]
* ... from [NEPOMUK Calendar Ontology]

Property values of service times SHOULD be modeled as instance of
[xsd:dateTime] or [xsd:date]. The starting time of a service event (if given)
MUST be equal to or earlier than the ending time of the same service event
(unless the service is an instance of [TimeTravel] and [ExecutedService]).

To express an estimated and additional time, SSSO defines the property [delay]
which can also hold a relative duration. Applications SHOULD NOT use this
property to relate a service event to its normal time, unless this time is
an additional constraint.

## Service locations

The following properties from [related ontologies] are RECOMMENDED to relate
a [ServiceEvent] to the location where the service is, will be, or has been
provided. SSSO does not include any constraints on the nature of locations ---
see the specific property for suitable ranges:

 property                           ontology                               range
---------------------------------- -------------------------------------- --------------------------------------------------------
 [schema:location]                  [Schema.org Ontology]                  [schema:Place] or [schema:PostalAddress]
 [event:place]                      [Event Ontology]                       [geo:SpatialThing]
 [crm:P7_took_place_at]             [CIDOC-CRM]                            [crm:E53_Place]
 [crm:P8_took_place_on_or_within]   [CIDOC-CRM]                            [crm:E19_Physical_Object]
 [prov:atLocation]                  [Provenance Ontology]                  [prov:Location]
 [tio:takesPlaceAt]                 [Tickets Ontology]                     [tio:POI] (subclass of [gr:Location] = [schema:Place])
 [ncal:geo]                         [NEPOMUK Calendar Ontology]            [geo:Point]
 [ncal:location]                    [NEPOMUK Calendar Ontology]            xsd:string
 [ncal:locationAltRep]              [NEPOMUK Calendar Ontology]            rdfs:Resource
 [lode:atPlace]                     [Linking Open Descriptions of Events]  [dul:Place]
 [dul:hasLocation]                  [DOLCE+DnS Ultralite Ontology]         [dul:Entity]

Service locations are OPTIONAL and a service event MAY have multiple locations.

[crm:E53_Place]: http://purl.org/NET/cidoc-crm/core#E53_Place
[crm:E19_Physical_Object]: http://purl.org/NET/cidoc-crm/core#E19_Physical_Object
[crm:P7_took_place_at]: http://purl.org/NET/cidoc-crm/core#P7_took_place_at
[crm:P8_took_place_on_or_within]: http://purl.org/NET/cidoc-crm/core#P7_took_place_on_or_within
[dul:hasLocation]: http://www.loa-cnr.it/ontologies/DUL.owl#hasLocation
[event:place]: http://motools.sourceforge.net/event/event.html#term_place
[lode:atPlace]: http://linkedevents.org/ontology/atPlace
[ncal:geo]: http://www.semanticdesktop.org/ontologies/ncal/#geo
[ncal:locationAltRep]: http://www.semanticdesktop.org/ontologies/ncal/#locationAltRep
[ncal:location]:  http://www.semanticdesktop.org/ontologies/ncal/#location
[prov:atLocation]: http://www.w3.org/TR/prov-o/#atLocation
[schema:location]: http://schema.org/location
[tio:takesPlaceAt]: http://purl.org/tio/ns#takesPlaceAt

[geo:SpatialThing]: http://www.w3.org/2003/01/geo/wgs84_pos#SpatialThing
[geo:Point]: http://www.w3.org/2003/01/geo/wgs84_pos#Point
[dul:Place]: http://www.loa-cnr.it/ontologies/DUL.owl#Place
[dul:Entity]: http://www.loa-cnr.it/ontologies/DUL.owl#Entity
[prov:Location]: http://www.w3.org/TR/prov-o/#Location
[tio:POI]: http://purl.org/tio/ns#POI
[gr:Location]: http://purl.org/goodrelations/v1#Location
[schema:Place]: http://schema.org/Place
[schema:PostalAddress]: http://schema.org/PostalAddress


# Classes

## ServiceEvent

[ServiceEvent]: #ServiceEvent

A **service event** is both, an activity that takes places during a specific
time, and a kind of product or service. Several [related ontologies] define 
more general event or activity classes:

* [dctype:Event] in [Dublin Core Metadata Terms]
* [schema:Event] in [Schema.org Ontology]
* [event:Event] in [Event Ontology]
* [prov:Activity] in [Provenance Ontology]
* [crm:E7_Activity] in [CIDOC-CRM]
* [lode:Event] in [Linking Open Descriptions of Events]
* [dul:Event] in [DOLCE+DnS Ultralite ontology]
* [ncal:Event] in [NEPOMUK Calendar Ontology]
* [tio:Event] in [Tickets Ontology]

[dctype:Event]: http://dublincore.org/documents/dcmi-terms/#dcmitype-Event
[event:Event]: http://motools.sourceforge.net/event/event.html#term_Event
[schema:Event]: http://schema.org/Event
[crm:E7_Activity]: http://purl.org/NET/cidoc-crm/core#E7_Activity
[prov:Activity]: http://www.w3.org/TR/prov-o/#Activity
[lode:Event]: http://linkedevents.org/ontology/Event
[dul:Event]: http://www.loa-cnr.it/ontologies/DUL.owl#Event
[ncal:Event]:  http://www.semanticdesktop.org/ontologies/ncal/#Event
[tio:Event]: http://purl.org/tio/ns#Event

Existing product classes include:

* [schema:IndividualProduct] (which implies [gr:Product]) from [Schema.org Ontology]
* [gr:Individual] (which implies [gr:ProductOrService]) from [GoodRelations]

SSSO is agnostic to these existing classes, so [ServiceEvent] is a subclass of
all of them to make happy multiple communities. Applications of SSSO, however,
SHOULD NOT depend on the explicit expression of a particular event or product
class in addition to ServiceEvent.

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

The event can be connected to one or more [ServiceProvider] with property
[providedBy] and to one or more [ServiceConsumer] with property [consumedBy].

## ServiceFulfillment

[ServiceFulfillment]: #servicefulfillment

A **service fulfillment** is a [ServiceEvent] that consists of one or more
parts. Each of these parts is also a [ServiceEvent] and connected to the
service fulfillment by [dcterms:partOf]. Vice versa, each instance of
[ServiceEvent] is also instance of [ServiceFulfillment] if connected to another
[ServiceEvent] by [dcterms:hasPart].  The parts of a service fulfillment SHOULD
be connected to each other by [nextService] and [previousService].

    ssso:ServiceFulfillment a owl:Class ;
        rdfs:label "ServiceFulfillment" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        rdfs:isDefinedBy <> .

## ReservedService

[ReservedService]: #reservedService

A **reserved service** is a [ServiceEvent] that has been accepted by a service
provider for execution but not prepared yet. The reserved service has neither
been prepared by a service provider but only queued for further processing.  A
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

A **prepared service** is being prepared to be provided or executed. A typical
example is a product that is being send to its consumer.

    ssso:PreparedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:ProvidedService, 
          ssso:ExecutedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## ProvidedService

[ProvidedService]: #providedservice

A **provided service** is being made available for immediate execution. A
typical example is a product that is ready for being picked up by its consumer.

    ssso:ReservedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ExecutedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## ExecutedService

[ExecutedService]: #executedservice

An **executed service** represents the actual execution event of fulfillment of
a service. A typical example is a theater performance that is being played.

    ssso:ExecutedService a owl:Class ;
        rdfs:label "ExecutedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ProvidedService, ssso:RejectedService ;
        rdfs:isDefinedBy <> .

## RejectedService

[RejectedService]: #rejectedservice

A **rejected service** is a [ServiceEvent] that has been rejected by its
provider or by its consumer. The rejection may be infinite or it may be
followed by another service when the reason for rejection has been removed.

    ssso:RejectedService a owl:Class ;
        rdfs:label "RejectedService" ;
        rdfs:subClassOf ssso:ServiceEvent ;
        owl:disjointWith
          ssso:ReservedService, ssso:PreparedService, 
          ssso:ProvidedService, ssso:ExecutedService ;
        rdfs:isDefinedBy <> .

## ServiceProvider

[ServiceProvider]: #serviceprovider

A **service provider** is an entity that is responsible for providing a
[ServiceEvent].  Typical providers, such as organizations and people, are also
instances of [foaf:Agent] and [gr:BusinessEntity] but SSSO does not put any
constraints on the nature of providers.

    ssso:ServiceProvider a owl:Class ;
        rdfs:label "ServiceProvider" ;
        rdfs:isDefinedBy <> .

## ServiceConsumer

[ServiceConsumer]: #serviceconsumer

A **service consumer** is an entity that is requesting or consuming a
[ServiceEvent].  Typical consumers, such as organizations and people, are
instances of [foaf:Agent] and [gr:BusinessEntity] but SSSO does not put any
constraints on the nature of consumers.

    ssso:ServiceConsumer a owl:Class ;
        rdfs:label "ServiceConsumer" ;
        rdfs:isDefinedBy <> .

## ServiceLimitation

[ServiceLimitation]: #servicelimitation

A **service limitation** is some obstacle that may limit the use of a
[ServiceEvent]. For instance the purchase of guns and drugs is limited to
consumers with special permission. Another example is providing a different
product or activity than originally requested. Services and limitations are
connected to each other with properties [limits] and [limitedBy].

    ssso:ServiceLimitation a owl:Class ;
        rdfs:label "ServiceLimitation" ;
        rdfs:isDefinedBy <> .

## TimeTravel

[TimeTravel]: #timetravel

A **time travel** is an event which ends before it has been started. Details
have been implemented in the future.

    ssso:TimeTravel a owl:Class ;
        rdfs:label "TimeTravel" ;
        rdfs:isDefinedBy <> .

# Properties

## provides

[provides]: #provides

Relates a [ServiceProvider] instance that **provides** a [ServiceEvent]
instance to this service event.

    ssso:provides a owl:ObjectProperty ;
        rdfs:label "provides" ;
        rdfs:domain ssso:ServiceProvider ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:providedBy ;
        rdfs:isDefinedBy <> .

## providedBy

[providedBy]: #providedBy

Relates a [ServiceEvent] instance that is **provided by** a [ServiceProvider]
instance to this service provider.

    ssso:providedBy a owl:ObjectProperty ;
        rdfs:label "providedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceProvider ;
        owl:inverseOf ssso:provides ;
        rdfs:isDefinedBy <> .

## consumes

[consumes]: #consumes

Relates a [ServiceConsumer] instance that **consumes** a [ServiceEvent]
instance to this service event.

    ssso:consumes a owl:ObjectProperty ;
        rdfs:label "consumes" ;
        rdfs:domain ssso:ServiceConsumer ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:consumedBy ;
        rdfs:isDefinedBy <> .

## consumedBy

[consumedBy]: #consumedBy

Relates a [ServiceEvent] instance that is **consumed by** a [ServiceConsumer]
instance to this service consumer.

    ssso:consumedBy a owl:ObjectProperty ;
        rdfs:label "consumedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceConsumer ;
        owl:inverseOf ssso:consumes ;
        rdfs:isDefinedBy <> .

## limits

[limits]: #limits

Relates a [ServiceLimitation] instance that **limits** a [ServiceEvent]
instance to this service event.

    ssso:limits a owl:ObjectProperty ;
        rdfs:label "limits" ;
        rdfs:domain ssso:ServiceLimitation ;
        rdfs:range ssso:ServiceEvent ;
        owl:inverseOf ssso:limitedBy ;
        rdfs:isDefinedBy <> .

## limitedBy

[limitedBy]: #limitedBy

Relates a [ServiceEvent] instance that is **limited by** a [ServiceLimitation]
instance to this service limitation.

    ssso:limitedBy a owl:ObjectProperty ;
        rdfs:label "limitedBy" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range ssso:ServiceLimitation ;
        owl:inverseOf ssso:limits ;
        rdfs:isDefinedBy <> .

## delay

[delay]: #delay

This property can be used to specify an **estimated period of time or a date**
when a delayed [ServiceEvent] is expected to take place. Applications SHOULD
use values in the range of [xsd:duration], [xsd:dateTime], [xsd:date], or the
special value "unknown" to indicate a significant delay of unknown duration.
The range may later be extended to a subset of Extended [Date/Time
Format](http://www.loc.gov/standards/datetime/) (EDTF).

    ssso:delay a owl:DatatypeProperty ;
        rdfs:label "delay" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:isDefinedBy <> .

[xsd:dateTime]: http://www.w3.org/TR/xmlschema-2/#dateTime
[xsd:date]: http://www.w3.org/TR/xmlschema-2/#date
[xsd:duration]: http://www.w3.org/TR/xmlschema-2/#duration

Applications SHOULD NOT use this property to specify a normal [Service
time](#service-time). An example of a service event with delay is a concert
that starts at an official time but there is a delay until band begins to play.

## queue

[queue]: #queue

This property can be used to indicate the **size of a waiting queue** for some
[ServiceEvent]. Its value MUST be a non-negative integer (0,1,2...).

    ssso:queue a owl:DatatypeProperty ;
        rdfs:label "queue" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range xsd:nonNegativeInteger ;
        rdfs:isDefinedBy <> .

## nextService

[nextService]: #nextservice

Relates a [ServiceEvent] instances to another service event that is the **next
service** following in time.  The starting time of the following service
instance MUST be equal or later then the ending time of the previous service
(unless one of the services is an instance of [TimeTravel] and
[ExecutedService]).

    ssso:nextService a owl:ObjectProperty ;
        rdfs:label "nextService" ;
        rdfs:domain ssso:ServiceEvent ;
        rdfs:range  ssso:ServiceEvent ;
        owl:inverseOf ssso:previousService ;
        rdfs:isDefinedBy <> .

## previousService

[previousService]: #previousservice

Relates a [ServiceEvent] instances to another service event that is the
**previous service** preceding in time.  The ending time of the previousg
service instance MUST be equal or earlier then the starting time of the next
service  (unless one of the services is an instance of [TimeTravel] and
[ExecutedService]).

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


# Relations to Schema.org and GoodRelations

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

[dcterms:date]: http://dublincore.org/documents/dcmi-terms/#terms-date
[dcterms:hasPart]: http://dublincore.org/documents/dcmi-terms/#terms-hasPart
[dcterms:partOf]: http://dublincore.org/documents/dcmi-terms/#terms-partOf

[dctype:Service]: http://dublincore.org/documents/dcmi-terms/#dcmitype-Service

[foaf:Agent]: http://xmlns.com/foaf/spec/#term_Agent

[gr:BusinessEntity]: http://purl.org/goodrelations/v1#BusinessEntity
[gr:Individual]: http://purl.org/goodrelations/v1#Individual
[gr:Offering]: http://purl.org/goodrelations/v1#Offering
[gr:ProductOrService]: http://purl.org/goodrelations/v1#ProductOrService
[gr:offers]: http://purl.org/goodrelations/v1#offers
[gr:seeks]: http://purl.org/goodrelations/v1#seeks

[lode:atTime]: http://linkedevents.org/ontology/#term-atTime
[lode:circa]: http://linkedevents.org/ontology/#term-circa

[prov:startedAtTime]: http://www.w3.org/TR/prov-o/#startedAtTime
[prov:endedAtTime]: http://www.w3.org/TR/prov-o/#endedAtTime
[schema:Product]: http://schema.org/Product
[schema:IndividualProduct]: http://schema.org/IndividualProduct
[schema:Offer]: http://schema.org/Offer
[schema:startDate]: http://schema.org/Event
[schema:endDate]: http://schema.org/Event

[tio:ActualTicket]: http://purl.org/tio/ns#ActualTicket
[tio:starts]: http://purl.org/tio/ns#starts
[tio:ends]: http://purl.org/tio/ns#ends

[GoodRelations]: http://www.heppnetz.de/projects/goodrelations/

# References

## Normative References

* **[RFC 2119]** S. Bradner: *Key words for use in RFCs to Indicate Requirement Levels*. 
  March 1997 <http://tools.ietf.org/html/rfc2119>.

* **[RFC 2396]** T. Berners-Lee et al.: *Uniform Resource Identifiers (URI): Generic Syntax*.
  August 1998 <http://tools.ietf.org/html/rfc2396>.

## Informative References

SSSO was motivated by the design of the following ontologies and specifications

* J. Voß: *Patrons Account Information API*.
  2013 <http://purl.org/ontology/paia>
* J. Voß: *Document Availability Information API*. 
  2013 <http://github.com/gbv/daiaspec>.

SSSO is loosely connected to the following ontologies: it is compatible with
them but their use is optional. Feel free to rely on or ignore additional parts
of these ontologies when using SSSO.

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
* *DOLCE+DnS Ultralite (DUL) ontology*
  <http://ontologydesignpatterns.org/wiki/Ontology:DOLCE+DnS_Ultralite>*.
* *CIDOC CRM in OWL 2*.
  <http://bloody-byte.net/rdf/cidoc-crm/>.
* *GoodRelations*.
  <http://purl.org/goodrelations/>.
* *Tickets Ontology*
  <http://purl.org/tio>.

[Dublin Core Metadata Terms]: http://dublincore.org/documents/dcmi-terms/
[CIDOC-CRM]: http://www.cidoc-crm.org/
[DOLCE+DnS Ultralite Ontology]: http://ontologydesignpatterns.org/wiki/Ontology:DOLCE+DnS_Ultralite
[Document Availability API]: http://purl.org/ontology/daia
[Event Ontology]: http://motools.sf.net/event/event.html
[Linking Open Descriptions of Events]: http://linkedevents.org/ontology/
[NEPOMUK Calendar Ontology]: http://www.semanticdesktop.org/ontologies/ncal/
[Patrons Account Information API]: http://purl.org/ontology/paia
[Provenance Ontology]: http://www.w3.org/TR/prov-o/
[Schema.org Ontology]: http://schema.org/
[Tickets Ontology]: http://purl.org/tio


