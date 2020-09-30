---
layout: post
current: post
cover:  assets/images/posts/siggraph2019-what-is-usd-a-primer/colorful-182220_1920.jpg
navigation: True
title: "Notes for 'What is USD: A Primer' SIGGRAPH 2019"
date: 2020-09-30 01:00:00
tags: GDC visual-arts interchange computer-graphics scene-description usd dcc
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
read_time: 6
---

__TLDW Summary__: This talk is an intro to the key concepts and terminology of Universal Scene Description. The presentation shows examples of how USD is integrated into SideFX products.

## Key Terms 
<div class="keyword-container">
<ul class="keyword-container">
<li>Universal Scene Description</li>
<li>Scene Graph</li>
<li>Layer</li>
<li>Hydra</li>
<li>DCC</li>
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

[Link](https://www.youtube.com/watch?v=Yp_TRVD3wjQ){:target="_blank"} to the talk on YouTube.

- [at minute 1](https://youtu.be/Yp_TRVD3wjQ?t=41){:target="_blank"} What is USD?
- [at minute 4](https://youtu.be/Yp_TRVD3wjQ?t=237){:target="_blank"} "Layer" term
- [at minute 4](https://youtu.be/Yp_TRVD3wjQ?t=253){:target="_blank"} "Stage" term
- [at minute 4](https://youtu.be/Yp_TRVD3wjQ?t=285){:target="_blank"} "Composition Arcs" term
- [at minute 5](https://youtu.be/Yp_TRVD3wjQ?t=339){:target="_blank"} "SubLayers" term
- [at minute 7](https://youtu.be/Yp_TRVD3wjQ?t=434){:target="_blank"} "Namespace" term
- [at minute 9](https://youtu.be/Yp_TRVD3wjQ?t=542){:target="_blank"} "Opinions" term
- [at minute 11](https://youtu.be/Yp_TRVD3wjQ?t=694){:target="_blank"} "Sublayering" term
- [at minute 12](https://youtu.be/Yp_TRVD3wjQ?t=749){:target="_blank"} "References" term
- [at minute 14](https://youtu.be/Yp_TRVD3wjQ?t=879){:target="_blank"} "Payload" term
- [at minute 16](https://youtu.be/Yp_TRVD3wjQ?t=1017){:target="_blank"} "Instancing" term
- [at minute 18](https://youtu.be/Yp_TRVD3wjQ?t=1105){:target="_blank"} "VariantSet" term
- [at minute 22](https://youtu.be/Yp_TRVD3wjQ?t=1318){:target="_blank"} "Hydra" term
- [at minute 23](https://youtu.be/Yp_TRVD3wjQ?t=1429){:target="_blank"} Q&A

## Key Concepts 

_the 'more' link will take you to the USD glossary_

- __Layer__: a _file_ on disk ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-Layer))
- __Stage__: the resulting composition of the _layers_ ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-Stage))
- __Composition Arcs__: different ways to combine layers into a _stage_ ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-CompositionArcs))
- __SubLayers__: the way to refer to other layers within a _layer_ ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-SubLayers))
- __Opinions__: a system for resolving conflicts when combining _layers_ ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-Opinions))
- __Namespace__: path to the primitives in the _scene graph_ ([find out more](https://graphics.pixar.com/usd/docs/USD-Glossary.html#USDGlossary-Namespace))

# The Problems/Challenges

* Have a single standardized format for describing a 3D scene 
* The format needs to be open for multiple parties to use and extend
* The format should be easy to implement

# Propositions

* Start learning and using USD in your pipelines to take advantage of the built-in integration into popular DDC tools, commercial rendering engines, and commercial game engines.
* You will need a tool to visualize how USD composes the scene graphs to get the final result.

# Arguments

* Pixar developed USD
* USD is becoming an industry standard
* USD is open and actively developed

# Key Points

* USD is for assembling scene and editing 3D data 
* USD is about enhancing the communication between Digital Content Creation tools
* Layer == Scene Graph == USD File
* USD can enable non-destructive editing of data from lower layers
* The concept of splitting the scene into multiple files allows the artist not to load the whole resulting scene, a.k.a. “Stage”
* Compositing USD files (referencing other USD files in a USD file) works like PhotoShop layers
* “opinions” are used to resolve scene graph composition conflicts. Layer on top will have a stronger “opinion” then the layer below that
* Need a standalone viewer/tool to understand how the scene is created
    * “This can get super confusing.”
    * “This can get very complicated."


<hr>

# Notable parts of the talk

## Enabling multiple artist work
_timestamp: 2 minutes into the presentation_

* It allows multiple artists to work on the same scene
    * Every department can have its own USD file

![Presentation Timestamp 3:53 USD basic structure]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_3-51.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=233"> YouTube</a>. Presentation Timestamp 3:53.</span>


## Composing multiple USD files
_timestamp: 4 minutes into the presentation_

![Presentation Timestamp 4:23 term stage]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_4-23.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=267"> YouTube</a>. Presentation Timestamp 4:23.</span>

## Sublayering
_timestamp: 5 minutes into the presentation_

* An empty root layer creates an empty stage
* USD composition works by combining scene graphs (USD files/Layers)
    * a.k.a. sublayering

![Presentation Timestamp 5:53 two USD files]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_5-53.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=353"> YouTube</a>. Presentation Timestamp 5:53.</span>

![Presentation Timestamp 8:00 two usd files]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_8-00.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=480"> YouTube</a>. Presentation Timestamp 8:00.</span>

* _opinions_ are used to resolve conflicts between scene graphs 

![Presentation Timestamp 11:25 composing USD files]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_11-25.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=662"> YouTube</a>. Presentation Timestamp 11:25.</span>

## References
_timestamp: 12 minutes into the presentation_

* "You reference one primitive from one file into the namespace of an existing primitive of a referencing scene graph"
    * You can make a primitive into a reference to a scene graph in another file
    * You can define root primitives as default primitives
        * USD will look for default primitives
    * The idea is not to just graft a scene graph on top of the existing scene graph. The idea is to specify the location wherein the existing scene graph USD inserts the source scene graph.
![Presentation Timestamp 14:14 referencing example]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_14-14.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=854"> YouTube</a>. Presentation Timestamp 14:14.</span>


## Payloads
_timestamp: 14 minutes into the presentation_

* Only load what you want
![Presentation Timestamp 15-54 payload example full scene]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_15-54.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=954"> YouTube</a>. Presentation Timestamp 15-54.</span>

![Presentation Timestamp 15-57 payload example full scene]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_15-57.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=957"> YouTube</a>. Presentation Timestamp 15-57.</span>


## 3 ways to compose

* There are 3 principal ways to bring a USD file into a scene graph
    * Layers
        * adding a USD file on top of an existing USD file
    * Referencing
        * adding a select primitive of another USD file into a specific location in the base USD file
    * Payload
        * a reference that you can load or not
            * done for memory management and processing time 


## Variantset
_timestamp: 18 minutes into the presentation_

* a non-destructive set of alternatives 
    * examples:
        * dented models that are dented
        * models with different textures materials applied
        * models ageing over time
        * storing LODs
    
* The alternatives are chosen non-destructively by using the “opinion” layer stack



## Hydra
_timestamp: 22 minutes into the presentation_

![Presentation Timestamp 23-08 what is Hydra]({{ site.baseurl }}assets/images/posts/siggraph2019-what-is-usd-a-primer/Screen_Shot_at_23-08.png){:width="700" style="margin: .1em auto"}
  <span style="font-size:50%;text-align:center;display:block">Rob Stauffer. <i>What is USD: A Primer</i>. July 2019, SIGGRAPH, <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ?t=1388"> YouTube</a>. Presentation Timestamp 23-08.</span>



## Notes from the Q&A
_timestamp: 23 minutes into the presentation_

* in theory USD should make the interop between different DCC tools easier
    * it all depends on the way the given DCC supports USD

* _previz_ in Virtual Production can be defined as a USD layer

* USD can hold geometry 
    * You can set up a USD scene in a way where:
        * Some USD files will contain the Scene Description and some USD files will contain the geometry
            * example: [Pixar USD Kitchen set](https://graphics.pixar.com/usd/downloads.html)

* currently missing support for skeletal animation rigs

* it is possible to define your own types to store different metadata

* there isn't a standard way to organize the USD layer files
    * some studios organize per department
    * some organize everything in a flat file

* you can support multiple renderers, but you might need to store multiple material definitions 

* Future work:
    * Making it easier to work with materials for different renderers 
        * MaterialX
        * MDL Material
    * Supporting shaders


<hr>

# Thoughts

## Applications in Game dev

* The possibility of leveraging third-party DCCs tools that will use the same format to save levels
    * a seamless workflow between proprietary studio technologies and third-party tools
* From what I understand you can use USD in 3 different ways:
    * `interchange` - intermediate format to communicate between tools (buffer/temp files)
        * `low` commitment to USD
    * `store` - the authoritative persistent format that all the tools use and save (all your proprietary tools save into a USD file)
        * `medium` commitment to USD
    * `render` - implement the Hydra API to render from USD
        * `high` commitment to USD
        * a third-party DCC, that supports USD, can render using your proprietary render engine ( see [Blender’s Cycles renderer running in the Houdini viewport](http://www.cgchannel.com/2020/07/see-blenders-cycles-renderer-running-in-the-houdini-viewport){:target="_blank"} )

## Practical Truths

_General Tools Development Wisdom_

* **Layers can power non-destructive workflows.** - layers are key for implementing non-destructive workflows.
* **Communicating hierarchies is hard.** - it can be a challenge for a non-technical user to grasp hierarchies, especially if merging of hierarchies is a feature.
* **Visualization is paramount.** - getting the visualization "right" can make all the difference.


## Practical Principles
 
_General Tools Development Principles_

* Make it easy for your users to visualize the internal data. Don't just render the underlying data and call it a day. (see [GDC 2018 Notes for "A Tale of Three Data Schemas"]({{site.baseurl}}/tools-tutorial-day-a-tale-of-three-data-schemas){:target="_blank"} )

* _Layers_ are great for separating artists and department work.


## Questions that came to mind

* Is there a good comparison of scene description file formats (open and not)?
    * [Article "Last mile interchange" by Nick Porcino](http://nickporcino.com/posts/last_mile_interchange.html){:target="_blank"}
    * [The Most Common 3D File Formats (don't have USD)](https://all3dp.com/3d-file-format-3d-files-3d-printer-3d-cad-vrml-stl-obj/){:target="_blank"}
* Who supports USD?
    * [Blender](https://docs.blender.org/manual/en/latest/files/import_export/usd.html)
    * [Unreal](https://docs.unrealengine.com/en-US/Support/Builds/ReleaseNotes/4_24/index.html#new:liveuniversalscenedescriptionstage_beta_)
    * [Unity](https://blogs.unity3d.com/2019/03/28/pixars-universal-scene-description-for-unity-out-in-preview/)
    * [Maya](https://github.com/Autodesk/maya-usd)
    
* Why the "payload" functionality can't be done via "composition arcs"?
    * [Nick Porcino](https://twitter.com/meshula){:target="_blank"} answered:
        Composition arcs is just a graph nomenclature. The “arc” expresses the relationship.
        ```
        level3 -> is_active_in -> world
        lighting -> is_referenced_by -> level3
        night_lighting -> overrides -> lighting
        grunt -> extends -> player
        red_costume -> is_referenced_by -> grunt
        ```
        The mesh in the costume is a payload. The lights in the night_lighting scene might be a payload. etc….

## Notes from the Vault Club

During the discussion in the [Vault Club](http://thetoolsmiths.org/vault_club){:target="_blank"}, I learned a lot. Here are some highlights.

* some game dev studios are experimenting with proof-of-concept level editor that saves the scene graph as USD
* [Eskil Steenberg](https://twitter.com/eskilsteenberg){:target="_blank"} pointed out that USD is more about managing interdepartmental workflows, then about what graphics engineer would look for in a format (polygons, pixels, shaders). "USD, assumes that its part of a pipeline of large DCC applications that supports formats like Alembic, OpenEXR, OpenVDB, OpenShadingLanguage to store the actual data."

* [Nick Porcino](https://twitter.com/meshula){:target="_blank"} mentioned that one of the possible names for USD was "Layered Scene Description". :)
* The name "Hydra" - comes from the idea that you would implement your own rendering "head".
* There might be an issue with the coupling between `blind data` and `known data`. Meaning that if an application creates custom data that is based on the USD data, we might break that custom data by modifying the USD data outside the current application.

<div style="background-color:#FFFF94;border-left: 18px solid #ffff48;padding-left: 50px;">
<p></p>
<p>These notes are just the main ideas of the talk. They don’t contain anecdotes and examples. If you want to learn more, I would advise watching the talk on <a target="_blank" href="https://youtu.be/Yp_TRVD3wjQ">YouTube</a>.</p>
<p></p>
</div>

## The Toolsmiths
![The Toolsmiths logo]({{ site.baseurl }}assets/images/thetoolsmiths_cover_1000x2881.png){:width="700"}

I took these notes as part of our little "Book Club" for Game Tools related videos [The Toolsmiths #vault club](http://thetoolsmiths.org/vault_club){:target="_blank"}

Join us on [Slack](http://thetoolsmiths.org/join_slack_team){:target="_blank"}.

Join us on [Twitter](https://twitter.com/thetoolsmiths){:target="_blank"}.

## Links
* [What is USD: A Primer, Rob Stauffer, SIGGRAPH 2019](https://youtu.be/Yp_TRVD3wjQ){:target="_blank"}

## Related Blog Links
* Notes for [GDC 2018 Notes for "A Tale of Three Data Schemas"]({{site.baseurl}}/tools-tutorial-day-a-tale-of-three-data-schemas)

## Related Talks\Videos
* [SIGGRAPH 2016 Real-Time Graphics in Pixar Film Production](https://www.youtube.com/watch?v=x9ikzGQW0ys){:target="_blank"} 
* [WWDC 2017 From Art to Engine with Model I/O](https://developer.apple.com/videos/play/wwdc2017/610/){:target="_blank"} 
* [GDC 2019 The Future of Scene Description on 'God of War'](https://www.gdcvault.com/play/1026345/The-Future-of-Scene-Description){:target="_blank"}
* [USD at UTS Animal Logic Academy video presentations](https://www.youtube.com/playlist?list=PLNUaMVwYjKk8QDlM8gQSLbl8jxLRgc7d6){:target="_blank"}


## Related resources
* [USD Projects and Resources](https://wiki.aswf.io/display/WGUSD/USD+Projects+and+Resources){:target="_blank"}
* [Resources USD](https://github.com/vfxpro99/usd-resources){:target="_blank"}
* [Article "Last mile interchange" by Nick Porcino](http://nickporcino.com/posts/last_mile_interchange.html){:target="_blank"}
* [See Blender’s Cycles renderer running in the Houdini viewport, CG Channel](http://www.cgchannel.com/2020/07/see-blenders-cycles-renderer-running-in-the-houdini-viewport){:target="_blank"}
* [VSCode USD Language support](https://marketplace.visualstudio.com/items?itemName=AnimalLogic.vscode-usda-syntax){:target="_blank"}
* [HxA 3D asset format, Eskil Steenberg](https://github.com/quelsolaar/HxA){:target="_blank"}
* [How to Integrate FX Using USD and Houdini Solaris - Lesterbanks](https://lesterbanks.com/2020/03/how-to-integrate-fx-using-usd-and-houdini-solaris){:target="_blank"}
* [Solaris, SideFX](https://www.sidefx.com/products/houdini/solaris/){:target="_blank"}
* [Intro to USD](https://yoann01.github.io/blog/2019/10/01/USD.html){:target="_blank"}
* [Alembic - an open computer graphics interchange framework](https://www.alembic.io){:target="_blank"}


## Credits

Post cover image by <a target="_blank" href="https://pixabay.com/users/AlexanderStein-45237/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=182220">Alexander Stein</a> from <a target="_blank" href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=182220">Pixabay</a>
