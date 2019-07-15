---
layout: post
current: post
cover:  assets/images/posts/blank-composition-desk-gdc2019.jpg
navigation: True
title: Notes for "Tools for 'Marvel's Spider-Man' Editing with Immutable Data" GDC2019
date: 2019-07-14 01:00:00
tags: GDC data ddl edit web
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
read_time: 5
---

__TLDW Summary__: This talk is a tour of the technologies that Insomniac Games developed to transition from their web based tools to their new desktop tools. Highlighting what challenges they encountered when replacing the tool chain in mid production.

## Keywords
<div class="keyword-container">
<ul class="keyword-container">
<li>Data Design</li>
<li>Immutable Data</li>
<li>Mid Production</li>
<li>Data Definition Language (DDL)</li>
<li>Porting</li>
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

- [at min 1](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Background
- [at min 2](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Making Changes
- [at min 6](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Mission Directive
- [at min 15](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Implicitly shared data with Copy-on-write
- [at min 29](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Immutable Data
- [at min 32](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) The Edit Loop
- [at min 41](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Hazards Encountered
- [at min 45](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Conclusion
- [at min 47](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider) Q&A


# Background
- Insomniac Games started to develop Web-Based Tools in 2010 (written in JavaScript)
  - This lead to some issues and the engine team decided to go back to the regular desktop tools
    - for more see [GDC 2017 "Insomniac's Web Tools: A Postmortem"](http://www.gdcvault.com/play/1024465/Insomniac-s-Web-Tools-A) 
  - Insomniac Games  shipped 6 games with the web tools
- This talk is about what happened after the "Insomniac's Web Tools: A Postmortem" 

# Making Changes
_timestamp: 2 min into the presentation_
-  In 2015 the work started on the transition from JavaScript to C++ Qt with a 4 man team
- The refactoring had to be done while the tools were still in use
- Sunset Overdrive pushed the JS world editor to its limits and 'Marvel's Spider-Man' Manhattan would be even bigger
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/map-scale.jpg" alt="slide: Sunset Overdrive vs'Marvel's Spider-Man' Manhattan size" width="700"/> 
- the team needed to port 12 editors from JS 
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/world-editor.jpg" alt="slide: world editor" width="700"/>
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/animation-editor.jpg" alt="slide: animation editor" width="700"/>
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/cinematics-editor.jpg" alt="slide: cinematics editor" width="700"/>
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/vfx-editor.jpg" alt="slide: vfx editor" width="700"/>
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/12-editors.jpg" alt="slide: 12 editors" width="700"/>
- the goals of the refactoring were
  - performance (being able to work with large data sets) 
    - multi-threading support
  - easier to maintain
  - type safety (JS “Uncaught TypeError: undefined is not a function”)

# Mission Directive
_timestamp: 6 min into the presentation_

- the tool porting was planned to be done when a significant part of the content would have been created with the old tools
  - needed to provide an upgrade path or data compatibility
- the C++ tools need to have the same UX and UI as the JS tools to make the switching between the tools as seamless as possible.
  - no feature requests were accepted to make it possible to finish on time
- The tools were 100% data compatible
  - this enabled the users to fall back to the JS tools when they hit an issue with the C++ version
- the JS tools were using a local client/server model
  - the local server was called LunaServer 
    - for more check out the GDC2012 talk about [Developing Imperfect Software: How to Prepare for Development Pipeline Failure](https://gdcvault.com/play/1015531/Developing-Imperfect-Software-How-to)
  - LunaServer 
    - stores its state in MongoDB
    - responsible for file system IO
    - responsible for Perforce operations
    - sync changes to assets between tools
 
- their own in-house DDL
  - made JSON type safe with a DDL compiler (ToolsDDL) that would compile the DDL into C++ code (set/get)
  - tools use in memory JSON representation (to reduce complexity and the need to convert between C++ object)modification 
- to represent a game object, they use JSON trees which are the same as hash table of hash tables

# Implicitly shared data with Copy-on-write
_timestamp: 15 min into the presentation_
- a detailed explanation of the Implicitly shared data with Copy-on-write pattern at @ 15-36
- basic idea 
  - a global state is implicitly shared between modules
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/modify_worldNode_0.jpg" alt="slide: modify worldNode step one" width="700"/>
  - when a module wants to update the global state, a copy is made 
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/modify_worldNode.jpg" alt="slide: modify worldNode step two" width="700"/> 
  - after the modification is done the rest of the modules get notified to fetch the pointer to the new object
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/modify_worldNode_2.jpg" alt="slide: modify worldNode step three" width="700"/>
- implicit sharing makes it easy to compute the diff of 2 JSON trees
  - this is because as soon as 2 subtrees point to the same shared subtree, you don’t need to traverse that part of the tree any further.


# Immutable Data
_timestamp: 29 min into the presentation_
- the same idea of Implicitly shared data **without** Copy-on-write 
  - no setters 
  - <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/Immutable_Data.jpg" alt="slide: Immutable Data class" width="700"/>
- this makes it easier to reason about the code

<div style="font-style: normal;font-size: 26px;margin-left: 32px;font-family: Consolas, 'Times New Roman', Verdana;border-left: 4px solid #3a5ebf;padding-left: 20px;">
<p></p>
"Immutable is not const. const only controls access, immutable is a guarantee."
<p></p>
</div>
<p></p>
- they like to think about this as a step towards functional programming
- designing an API that is like a function that returns a new value based on the old value
  - without any 
    - side effects 
    - preconditions


# The Edit Loop
_timestamp: 32 min into the presentation_
- LunaEdit is the module that is responsible for editing asset 
  - creating a new object from an object that was passed in
- LunaEdit is also responsible for 
  - handling Perforce checkout 
  - handling the undo system
  - sending updates to the LunaServer (updating the DB and files on disk)
  - broadcast changes all of the modules in the system (change/update)
- all of the complexity of working with the data format is hidden in one place -  the LunaEdit module
- <img src="assets/images/posts/tools-for-marvels-spider-man-editing-with-immutable-data/edit_loop.jpg" alt="slide: The Edit Loop" width="700"/>


# Hazards Encountered
_timestamp: 41 min into the presentation_

- copying wide (flat) hash tables is expensive
  - prefer deep hash tables 
- don’t use QJsonObject
  - strings are stored as 8-bit and returned as 16-bit
  - strings are not shared (issue with identical keys)
- with multiple versions of data in flight
  - a module wants to change a piece of data that is in the process of being updated.
  - this wasn’t an issue because the main thread is the only thread that can request a change 



<div style="background-color:#FFFF94;border-left: 18px solid #ffff48;padding-left: 50px;">
<p></p>
<p>These notes are just the main ideas of the talk. They don’t contain anecdotes and examples. If you want to learn more, I would advise watching the talk on the <a href="https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider">GDC Vault</a>.</p>
<p></p>
</div>

## The Toolsmiths
<img src="http://thetoolsmiths.org/assets/thetoolsmiths_cover_1000x2881.png" alt="The Toolsmiths logo" width="700"/>

I took these notes as part of our little "Book Club" for GDC Vault Videos [The Toolsmiths #vault club](http://thetoolsmiths.org/vault_club)

Join us on [Slack](http://thetoolsmiths.org/join_slack_team).

Join us on [Twitter](https://twitter.com/thetoolsmiths).

## Links
* [Tools for 'Marvel's Spider-Man' Editing with Immutable Data](https://www.gdcvault.com/play/1026080/Tools-for-Marvel-s-Spider)

## Related talks
* [GDC 2017 "Insomniac's Web Tools: A Postmortem"](http://www.gdcvault.com/play/1024465/Insomniac-s-Web-Tools-A) 
* [GDC 2012 Developing Imperfect Software: How to Prepare for Development Pipeline Failure](https://gdcvault.com/play/1015531/Developing-Imperfect-Software-How-to)
