---
layout: post
current: post
cover:  assets/images/posts/blank-composition-desk-gdc2019.jpg
navigation: True
title: Notes for "The Future of Scene Description on 'God of War'" GDC2019
date: 2019-06-16 01:00:00
tags: GDC data determinism ddl
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
read_time: 5
---

__TLDW Summary__: This talk sheds light on the decisions that were made by the Santa Monica Studio’s engine team while tackling the problems of time and complexity in transforming source data into game-ready data.

## Keywords
<div class="keyword-container">
<ul class="keyword-container">
<li>Data Design</li>
<li>Data Duality</li>
<li>Scene Description</li>
<li>Data Definition Language (DDL)</li>
<li>Nondeterminism</li>
</ul>
<style>
    .keyword-container > ul
    {
        font-size: 16px;
        list-style-type: none;
        padding:15px;
    }
    .keyword-container > li
    {
        background-color:#f3f3f3;
        display : inline;
        padding:5px;
        margin:2px;
        margin-bottom: 100px;
        border-radius: 5px;
    }
</style>
</div>


## Presentation Time Stamps
- [at min 1](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Backgound: Game Content Pipeline
- [at min 16](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Past: Redefining SmSchema
- [at min 20](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Present: A view after years of investment
- [at min 27](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Present: Connecting the parts of the design into one
- [at min 37](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Looking into the future: many opportunities still remain
- [at min 41](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Lessons we’ve learned
- [at min 43](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description) Q&A

## Backgound: Game Content Pipeline
_timestamp: 1 min into the presentation_
- God of War data breakdown
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\god-of-War-data-breakdown.jpg" alt="slide: God of War data breakdown" width="700"/>
- What Source Data and Run-time data have in common
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\source-data-n-production-data.jpg" alt="slide: What Source Data and Run-time data have in common" width="700"/>
- The design philosophy was inspired by the scene description from the film industry
- Patch size was a common enemy
    - Nondeterminism made patch sizes huge
        - Patching was always an afterthought.
        - Parts of the run-time was an afterthought.
- Exploring data formats to find a better way 
- 2 types of explicit data formats
    - Low level: FlatBuffers, ProtocolBuffers
    - Higher level: COLLADA and USD
- None satisfied the requirements 
    - This was the catalyst for the SmSchema Data Definition Language
- The SmSchema proof of concept had 3 main parts 
    - The definition itself 
    - C++ code generation with (Jinja Python)
    - Sterilization into JSON
- The first attempt to apply it to a real-world problem showed that the mental model that they had envisioned had missing parts
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\smschema-interconnected-technologies.jpg" alt="slide: missing interconnected technologies" width="700"/>

##  Past: Redefining SmSchema
_timestamp: 16 min into the presentation_
- Decided to use the serialization as an anchor point to design around
- The redesign started with laying down the foundation with [first-prenciples](https://fs.blog/2018/04/first-principles/)
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\first-principles.jpg" alt="slide: first-prenciples used in the design" width="700"/>
- Wanted to get away from a JSON-based Language
- Issues with Maya scalability brought more questions that needed answers
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\new-insight.jpg" alt="slide: questions that needed answers" width="700"/>

## Present: A view after years of investment
_timestamp: 20 min into the presentation_
- <img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\smschema-interconnected-technologies-2.jpg" alt="slide: SmSchema architecture high level" width="700"/>
- The DDL was inspired by [Insomniac's DDL](https://gdcvault.com/play/1015531/Developing-Imperfect-Software-How-to)
- Used [ANTLR](https://www.antlr.org/) for language definition
- Process of code generation 
    - Used special Compile-Time Type Info (CTTI) to decouple the DDL and the code generation
    - Used a functional approach to make it easier to generate code to any current or future target
    - Used special metadata in the form of annotations to enable user-driven code generation without making changes in the parser
- <img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\code-gen-1.jpg" alt="slide: Code Generation with CTTI info" width="700"/>
- <img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\code-gen-2.jpg" alt="slide: Code Generation with CTTI flexibility" width="700"/>
- Serialization formats
    - JSON - Human readable for merging, diffing and fixing issues 
        - Leverage open source tools and libs
    - Binary - For performance & compression
    - Experimenting with MsgPack to encode large assets
    - X3D scene loader increased performance by an order of magnitude while saving and loading 

##  Present: connecting the parts of the design into one
_timestamp: 27 min into the presentation_
- The defining structure of SmSchema that brings all of the parts together is called the document.
- The Document is a “Section of data with a header”
    - Defining the semantics of pointers used in the referencing solution. Used to reference other documents.
- Pointers was a common request for SmSchema
    - See details on the implementation of pointer @ min 28
    - The pointer had to provide 
        - Ownership semantics: unique, weak
        - Locality semantics: local, section, external
        - Used Frozen/Alive concept to determine if the reference is loaded
        - The concept of the section was introduced to SmSchema
            - A document is segmented into several memory blocks
            - These memory blocks are called sections and are used for storing things like debug data or GPU data
- <img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\sections.jpg" alt="slide: Sections of the SmSchema Doc" width="700"/>
- With the Document structure, they were able to design workflows with a minimum amount of transformations from the source data to the run-time data
    - The document could be 
        - Shipping streaming resource
        - A string hash look-up table
        - A source X3D scene graph
- <img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\data-transform.jpg" alt="slide: Transforming data from source to run-time" width="700"/>

##  Looking into the future: many opportunities still remain
_timestamp: 37 min into the presentation_

- Current and future research
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\wip.jpg" alt="slide: SmSchema architecture high level Final" width="700"/>
- Challenges with external pointer resolution
    - Who is responsible for resolving? 
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\external-pointers.jpg" alt="slide: Frozen external pointers" width="700"/>
- This led to the creation of a data structure for arbitrating external pointer resolution called the “document store”
    - The document arbitration takes a form of transaction
<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\document-store.jpg" alt="slide: Document store transactions" width="700"/>
- The combination of the Document Store and Streaming Policies could produce complex decision-making behavior for streaming resources

<div style="font-style: normal;font-size: 26px;margin-left: 32px;font-family: Consolas, 'Times New Roman', Verdana;border-left: 4px solid #3a5ebf;padding-left: 20px;">
<p></p>
"Solutions have to be driven by use case, introduced with scrutiny, and solve a domain of problems evidently and clearly."
<p></p>
</div>

##  Lessons we’ve learned
_timestamp: 41 min into the presentation_
- While answering what is the future of Scene Description on “God of War”
    - They understood that there are other questions that they need to answer before answering the original question
        - What are the primitives used in the design of
            - The engine
            - The workflows
            - The formats

<div style="font-style: normal;font-size: 26px;margin-left: 32px;font-family: Consolas, 'Times New Roman', Verdana;border-left: 4px solid #3a5ebf;padding-left: 20px;">
<p></p>
"Our goal was never to predispose ourselves to a particulate design. The future of scene description is not a data structure, it’s not a design pattern; it’s a set of questions that we need to be able to answer about our content."
<p></p>
</div>

<img src="assets/images/posts/the-future-of-scene-description-on-god-of-war\takeaway.jpg" alt="slide: takeaway" width="700"/>


<div style="background-color:#FFFF94;border-left: 18px solid #ffff48;padding-left: 50px;">
<p></p>
<p>These notes are just the main ideas of the talk. They don’t contain anecdotes and examples. If you want to learn more, I would advise watching the talk on the <a href="https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description">GDC Vault</a>.</p>
<p></p>
</div>

## The Toolsmiths
<img src="http://thetoolsmiths.org/assets/thetoolsmiths_cover_1000x2881.png" alt="The Toolsmiths logo" width="700"/>

I took these notes as part of our little "Book Club" for GDC Vault Videos [The Toolsmiths #vault club](http://thetoolsmiths.org/vault_club)

**Koray Hagen** is a member of the [Toolsmiths](http://thetoolsmiths.org/) community. The Toolsmiths are a community of Game Tool Developers that are passionate about improving the way people make games.

Join us on [Slack](http://thetoolsmiths.org/join_slack_team).

Join us on [Twitter](https://twitter.com/thetoolsmiths).

## Links
* [The Future of Scene Description on 'God of War'](https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description)
* Slides for [The Future of Scene Description on 'God of War'](https://www.gdcvault.com/play/1026345/The-Future-of-Scene-Description)

## Related Blog Links
* Notes for [GDC 2018 Tools Tutorial Day: A Tale of Three Data Schemas]({{site.baseurl}}/2018-10-07-tools-tutorial-day-a-tale-of-three-data-schemas)

## Related talks
* [GDC 2018 Tools Tutorial Day: A Tale of Three Data Schemas](https://www.gdcvault.com/play/1025284/Tools-Tutorial-Day-A-Tale)
* [GDC 2012 Developing Imperfect Software: How to Prepare for Development Pipeline Failure](https://gdcvault.com/play/1015531/Developing-Imperfect-Software-How-to)
