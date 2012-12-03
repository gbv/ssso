% Simple Service Status Ontology (SSSO)
% Jakob Voß
% GIT_REVISION_DATE

# Introduction

The **Simple Service Status Ontology (SSSO)** is an RDF ontology for typical
status in fulfillment of a service.

## Status of this document

Updates and sources can be found at <http://github.com/gbv/ssso>. The current
version of this document was last modified at GIT_REVISION_DATE with revision
GIT_REVISION_HASH.

## Namespaces

The (preliminary) namespace of this ontology is
<http://purl.org/ontology/ssso>. The namespace prefix `ssso` is recommeded.

    @prefix :     <http://purl.org/ontology/ssso> .
    @prefix ssso: <http://purl.org/ontology/ssso> .
    @base         <http://purl.org/ontology/ssso> .

The following namspace prefixes are used to refer to other ontologies:

    @prefix owl:    <http://www.w3.org/2002/07/owl#> .
    @prefix rdfs:   <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix dctype: <http://purl.org/dc/dcmitype/> .
    @prefix event:  <http://purl.org/ontology/c4dm/event.owl#> .
    @prefix prov:   <http://www.w3.org/ns/prov#> .
    @prefix dul:    <http://www.loa-cnr.it/ontologies/DUL.owl#> .
    @prefix lode:   <http://linkedevents.org/ontology/> .
    @prefix crm:    <http://purl.org/NET/cidoc-crm/core#> .
    @prefix foaf:   <http://xmlns.com/foaf/0.1/> .
    @prefix vann:   <http://purl.org/vocab/vann/> .
    @prefix ncal: <http://www.semanticdesktop.org/ontologies/2007/04/02/ncal#> .
    @prefix schema: <http://schema.org/> .

## Ontology

    <http://purl.org/ontology/ssso> a owl:Ontology ;
		rdfs:label "Simple Service Status Ontology" ;
        rdfs:label "SSSO" ;
        vann:preferredNamespacePrefix "ssso" .

# Overview

A service fulfillment is modeled as chain of service events, each being an
instance of [Service](#service). Five typical service status are defined as
disjoint subclasses:

* A [ReservedService](#reservedservice) is in status *reserved*:\
  the service has been accepted for fulfillment but no action has taken place.
* A [PreparedService](#preparedservice) is in status *prepared*:\
  the fulfillment is being prepared but is has not actually started.
* A [ProvidedService](#providedservice) is in status *provided*:\
  the service is ready to be fulfilled on request.
* A [ExecutedService](#executedservice) is in status *executed*:\
  the service is actually being fulfilled.
* A [RejectedService](#rejectedservice) is in status *rejected*:\
  the service has been refused or stopped.

A service is typically connected to at least one service [Provider](#provider)
and at least one service [Consumer](#consumer). 

This ontology does not make any assumptions about types of services. Examples
include buying a product from a shop and lending a book from a library. The
class [TimeTravel](#timetravel) is included as artifical example of a service
type.

# Classes

## Service

A service is an Event or activity. Several RDF ontologies have been proposed 
for such entities, maybe because ontology engineers cannot agree on semantics:

* Dublin Core Metadata Terms
* Event ontology
* Provenance ontology
* LODE ontology (Linking Open Descriptions of Events)
* DOLCE+DnS Ultralite ontology
* CIDOC-CRM expressed in OWL
* Schema.org Ontology
* NEPOMUK Calendar Ontology

An SSSO Service is subclass of all of them to make happy multiple communities.

    :Service a owl:Class ;
        rdfs:label "Service" ;
        rdfs:subClassOf 
            dctype:Event , 
            event:Event , 
            prov:Activity , 
            lode:Event , 
            dul:Event ,
            crm:E7_Activity ;
			ncal:Event ,
			schema:Event ,
            rdfs:isDefinedBy ssso: .

Service [providers](#provider) can be connected to a service
with property [providedBy](#providedby) and service [consumers](#consumer) 
can be connected to a service with property [consumedBy](#consumedBy).

The time when a service started and/or ended can be expressed as instance of
`xsd:dateTime` or `xsd:date` with properties `prov:startedAtTime` or
`schema:startDate` and `prov:endedAtTime` or `schema:endDate` respectively. The
starting time must be equal to or earlier than the ending time (unless the
service is an instance of [TimeTravel](#timetravel) and
[ExecutedService](#executedservice)).


## ReservedService

A reserved service is a [Service](#service) that has been accepted by a service
provider for execution but not prepared yet. The reserved service has neither
been prepared by a service provider but only queued for further processing.
A typical example is a product order that has been placed but not payed yet.

    :ReservedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf :Service ;
        owl:disjointWith :PreparedService, :ProvidedService, :ExecutedService, :RejectedService ;
        rdfs:isDefinedBy ssso: .

## PreparedService

A prepared service is being prepared to be provided or executed. A typical example 
is a product that is being send to its consumer.

    :PreparedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf :Service ;
        owl:disjointWith :ReservedService, :ProvidedService, :ExecutedService, :RejectedService ;
        rdfs:isDefinedBy ssso: .

## ProvidedService

A provided service is being made available for immediate execution. A typical example is a
product that is ready for being picked up by its consumer.

    :ReservedService a owl:Class ;
        rdfs:label "ReservedService" ;
        rdfs:subClassOf :Service ;
        owl:disjointWith :ReservedService, :PreparedService, :ExecutedService, :RejectedService ;
        rdfs:isDefinedBy ssso: .

## ExecutedService

An executed service represents the actual execution of fulfillment of a service.

    :ExecutedService a owl:Class ;
        rdfs:label "ExecutedService" ;
        rdfs:subClassOf :Service ;
        owl:disjointWith :ReservedService, :PreparedService, :ProvidedService, :RejectedService ;
        rdfs:isDefinedBy ssso: .

## RejectedService

A rejected service has been rejected by its provider or by its consumer. The
rejection may be infinite or it may be followed by another service when the
reason for rejection has been removed.

    :RejectedService a owl:Class ;
        rdfs:label "RejectedService" ;
        rdfs:subClassOf :Service ;
        owl:disjointWith :ReservedService, :PreparedService, :ProvidedService, :ExecutedService ;
        rdfs:isDefinedBy ssso: .

## Provider

A provider is an entity that is responsible for providing a [Service](#service).
Typical providers are instances of `foaf:Agent`, such as organizations or people,
but the Simple Service Status Ontology does not put any constraints on the nature
of providers.

    ssso:Provider a owl:Class ;
        rdfs:label "provider" ;
        rdfs:isDefinedBy ssso: .

## Consumer

A consumer is an entity that is requesting or consuming a [Service](#service).
Typical consumers are instances of `foaf:Agent`, such as organizations or people,
but the Simple Service Status Ontology does not put any constraints on the nature
of consumers.

    ssso:Provider a owl:Class ;
        rdfs:label "consumer" ;
        rdfs:isDefinedBy ssso: .

## TimeTravel

An event which ends before it has been started. Details have been implemented
in the future.

    :TimeTravel a owl:Class ;
        rdfs:label "TimeTravel" .

# Properties

## providedBy

Relates a [Service](#service) instance to a [Provider](#provider) instance.

    :providedBy a owl:ObjectProperty ;
        rdfs:label "providedBy" ;
        rdfs:domain :Service ;
        rdfs:range :Provider ;
        owl:inverseOf :provided ;
        rdfs:isDefinedBy ssso: .

## provided

Relates a [Provider](#provider) instance to a  [Service](#service) instance .

    :providedBy a owl:ObjectProperty ;
        rdfs:label "provided" ;
        rdfs:domain :Provider ;
        rdfs:range :Service ;
        owl:inverseOf :providedBy ;
        rdfs:isDefinedBy ssso: .

## consumedBy

Relates a [Service](#service) instance to a [Consumer](#consumer) instance.

    :consumedBy a owl:ObjectProperty ;
        rdfs:label "consumedBy" ;
        rdfs:domain :Service ;
        rdfs:range :Consumer ;
        owl:inverseOf :consumed ;
        rdfs:isDefinedBy ssso: .

## consumed

Relates a [Consumer](#consumer) instance to a [Service](#service) instance.

    :consumedBy a owl:ObjectProperty ;
        rdfs:label "consumed" ;
        rdfs:domain :Consumer ;
        rdfs:range :Service ;
        owl:inverseOf :consumedBy ;
        rdfs:isDefinedBy ssso: .

## next

Relates a service instances to another service instance which is following in time.
The starting time of the following service instance MUST be equal or later then the
ending time of the previous service (unless one of the services is an instance of 
[ExecutedService](#executedservice) and [TimeTravel](#timetravel)).

    :next a owl:ObjectProperty ;
       rdfs:label "next" ;
      rdfs:domain :Service ;
      rdfs:range  :Service ;
      owl:inverseOf :previous ;
        rdfs:isDefinedBy ssso: .

## previous

Relates a service instances to another service instance which is preceding in time.
The ending time of the previousg service instance MUST be equal or earlier then the
starting time of the next service (unless one of the services is an instance of 
[ExecutedService](#executedservice) and [TimeTravel](#timetravel)).

    :next a owl:ObjectProperty ;
       rdfs:label "previous" ;
      rdfs:domain :Service ;
      rdfs:range  :Service ;
      owl:inverseOf :next ;
        rdfs:isDefinedBy ssso: .

# References

## Normative Reference

...

## Informative References

* Antoni Mylka (Editor). 2007. *NEPOMUK Calendar Ontology*.
  <http://www.semanticdesktop.org/ontologies/ncal/>.
* **Schema.org Ontology**. <http://schema.org/>.

