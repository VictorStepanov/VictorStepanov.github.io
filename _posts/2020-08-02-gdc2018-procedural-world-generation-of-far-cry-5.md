---
layout: post
current: post
cover:  assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/clouds-1852955_1280.jpg
navigation: True
title: Notes for "Procedural World Generation of 'Far Cry 5'" GDC2018
date: 2020-08-09 01:00:00
tags: GDC procedural visual-arts level-art level-design
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
read_time: 6
---

__TLDW Summary__: This talk is about how FC5 developers created a pipeline for generating a realistic game world using procedural recipes. The talk contains a high-level overview of the pipeline with two deep dives into the details of the tools.

## Key Terms 
<div class="keyword-container">
<ul class="keyword-container">
<li>procedural workflow</li>
<li>an ecosystem of procedural tools</li>
<li>Houdini Engine</li>
<li>biome recipes</li>
<li>determinism</li>
<li>terrain</li>
<li>2d mask</li>
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

- [at minute 2](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} Introduction
- [at minute 2](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} The goals of the procedural pipeline
- [at minute 6](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} The tools that were developed
- [at minute 15](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} The system from the user's point of view
- [at minute 12](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} How the pipeline is working under the hood
- [at minute 16](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} The Cliff generation tool
- [at minute 25](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} The Biome generation tool
- [at minute 46](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} What changed during development
- [at minute 49](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} Conclusion
- [at minute 52](https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far){:target="_blank"} Q&A

## Key Concepts 

- __biome__ : an area of a game world with distinct terrain, vegetation, and animal life.
  ![slide 71 sub biome](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_71_sub_biome.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #71.</p>
- __map__ : parts of a game _world_ that are not loaded at the same time
- __section__ : a part of a _map_ (256m X 256m)
- __sector__ : a part of a _section_ (64m X 64m), the smallest part of a world that can be _baked_
  ![slide 34 sector](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_34_sector.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #34.</p>
- __recipe__ : a set of rules that given a set of inputs determines what _entities_ need to be placed at a given location
- __points of interest__ : a _map_ _location_ reserved for user input and editing

# The Problems/Challenges

* Filling up empty space is easy, but filling it up so it looks _natural_ is a big challenge.
* The workflow required to fill up large open spaces beautifully, quickly, while maintaining the _flexibility_ for applying user input.
	* The workflow had to allow fine-tuning of smaller _locations_ to deliver _tight gameplay experiences_.
* _Terraforming_ can't be locked at the start of the project
	* The terrain of the game would be constantly changing, and the _biomes_ would need to be constantly updated. Updating the biomes by hand wasn't an option.
	* The asset placement needs to be consistent with the terrain topology.
* The pipeline needs to run without human intervention to regenerate the content in a _build farm_ setting.
* The pipeline needs to generate small _sections_ of the world separately.
* The parts of the world should be generated _deterministically_ to enable stitching parts together.

# Propositions

* The biomes procedural system should be able to simulate _natural phenomena_.
  ![slide 80 natural phenomena](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_80_natural.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #80.</p>
  ![slide 99 natural phenomena](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_99_canopy.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #99.</p>
* Build _biome recipes_ that react to the physical features of the land to ensure _coherence_ throughout the world
  ![slide 89 natural phenomena](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_89_physical_features.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #89.</p>

* The iterative process is vital to the quality of the game

* Use Houdini Engine to run the full map generation in a nightly build
* _same input_ = _same result_ (determinism matters)
* The ecosystem of tools needs to be user friendly 
	* shelf tools
	* be able to override procedural results
* User must be able to bake data as they work


# Key Points

* They developed a sophisticated procedural pipeline for creating a realistic game world using Houdini and Houdini Engine
* Originally they just wanted to develop the _biome tool_, but they ended up developing a suite of tools.
* The _heart_ of the pipeline is the _data exchange_ between the Houdini Engine and the Game Engine
  ![slide 70 importing 2d data](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_70_import_2d_data.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #70.</p>
* They developed an _ecosystem of procedural tools_, where one tool would provide the input to the next tool
  ![slide 38 high-level pipeline overview](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_38_the_pipeline.png){:width="700" style="margin: .1em auto"}
  <p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #38.</p>
* They regenerate the entire game world every night on special _build machines_.

<hr>

# Notable parts of the talk

<hr>

## User Iteration Workflow
_timestamp: 6 minutes into the presentation_

1. Terraforming pass
2. Define freshwater
  ![slide 22 high-level pipeline overview](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_22_fresh_water.png){:width="700" style="margin: .1em auto"} <span style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #22.</span>
3. Run the _cliff generation tool_ to create cliffs on steep terrain 
4. Use _Biome painter_ and run procedural generation to spawn the vegetation 
5. Setting up _Points of Interest_ (a.k.a. location)
	![slide 26 high-level pipeline overview](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_26_point_of_interest.png){:width="700" style="margin: .1em auto"} <span style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #26.</span>
	1. Paint an area with the grass Biome
	2. Laying down a road spline
	3. Bake roads and refresh biome
	4. Add buildings, props
	5. Apply terrain texture
	6. Add more Trees with the forest sub-biome
	7. Bake/refresh biome
	8. Add fence spline
	9. Add power line spline
		1. Snap power line connector to house
		2. Bake/refresh biome


## User Non-Destructive Workflow
_timestamp: 11 minutes into the presentation_
1. Update level of terrain
2. Bake/refresh biome
	![slide 35 high-level pipeline overview](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_35_bake.png){:width="700" style="margin: .1em auto"}
	<p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #35.</p>


# How the pipeline is working under the hood
_timestamp: 12 minutes into the presentation_

* At the heart of the pipeline is the data exchange between the Houdini Engine and the Game Engine
* Inputs for the pipeline are sent from the Game Engine to Houdini via a Python Script
	* world information
	* spline & shapes 
	* file paths
	* Terrain Sectors (Main input that the generation is linked to)
	* heightmaps 
	* Biome painter
	* 2D terrain masks
	* Houdini Geometry (that might have been generated by another procedural tool)
* Outputs of Houdini 
	* List of outputs 
		* Entity point could
		![slide 37 high-level pipeline overview](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_37_entity_point_cloud.png){:width="700" style="margin: .1em auto"}
		<p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #37.</p>
		* Terrain texture layers
		* Terrain heightmap layers
		* 2D terrain data 
		* Geometry
		* Terrain logic zones 
	* The data is saved onto a disk using temp "buffers"
* The output of one tool influences the output of another tool
	* The tools use masks to communicate with each other

# Examples of tools

## Cliffs tool
_timestamp: 16 minutes into the presentation_

![slide 65 cliff tool](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_65_cliff_tool.png){:width="700" style="margin: .1em auto"}
<p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #65.</p>

## Biomes Tool
_timestamp: 25 minutes into the presentation_

![slide 69 biome tool](assets/images/posts/gdc2018-procedural-world-generation-of-far-cry-5/slide_69_biome_tool.png){:width="700" style="margin: .1em auto"}
<p style="font-size:50%">Carrier, Etienne. <i>Procedural World Generation of 'Far Cry 5'</i>. Mar. 2018, GDC, <a target="_blank" href="https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far"> GDC Vault Slide Location</a>. Presentation Slide #69.</p>


# Lessons Learned
_timestamp: 46 minutes into the presentation_

* Making the steps of the _pipeline simple_. Don't require knowledge of when the underlying data is generated or how it affects the _downstream tasks_. 
* The _blending of biomes_ is a complicated feature for the users to use and the developers to debug.
* This level of customization and generation at this scale _can impact the gameplay_.
* This is just a taste of what is possible to produce using this type of _procedural technology_.
* You won't get it right on your first try. Keep iterating and simplifying the pipeline. Be flexible - plans and requirements change.
* _Pay attention_ to how the users use the tools. If you think a feature will be useful it doesn't mean that the users will use it.

<hr>

# Thoughts

<hr>

## Solved Problems/Challenges

_Did they solve what they set out to solve?_

* They shipped FC5
* They developed suite of tools:
	* The freshwater tool
	* Fences & power line tool
	* Cliff generation tool 
	* Biome tool (to spawn vegetation)
	* Fog tool 
	* World map tool (scatter trees on the world map)
	* Power line tool
		* Auto snapping if a user made an error (with-in a given threshold distance)
* The pipeline is automated and runs nightly
* The workflow allowed for quick __iteration__ and the ability to _"bake as you work"_
* Use _biome recipes_ to define what vegetation will be placed in different parts of the map (near water, near cliffs, at high altitude)


## Practical Truths

_General Tools Development Wisdom_

* **"At first you won't understand the problem".** - You won't get a system design "right" from the first attempt.
* **"You are not your users".** - If you think something is a good feature, it doesn't mean that the users will think so. 
* **"Users don't have to know the implementation details".** - Users will not remember complicated cause-and-effect scenarios.
* **"Watch out for Hidden Cascade Effects".** - In a fully automated system, a user might not see/ suspect that their changes are affecting another system that is out of view.
* **"The speed of iteration is vital to the quality of the game".** - Don't let the tools be the bottleneck of the iteration process.


## Practical Principles

_General Tools Development Principles_

* Enable user input and _customization_ inside a procedural generation system.
* _Observe users_ to understand what is important for them.
* _K.I.S.S._: Keep It Stupid Simple
* Search for the balance between _control_ and _automation_.


## Questions that came to mind

* What are some websites/resources about good _Digital Content Creation tool_ architecture/patterns? Maybe even some checklists?
	* Like :
		* "Don't forget to make a headless client for your tool"
		* "Don't forget to add python scripting"
		* "Don't forget to think about determinism when saving
* Is there any alternative to Houdini? (not counting __rolling your own__)
* How do they edit the road network that spans multiple __maps__ (parts of the __world__)?
* How long into the future when level art for __second class__ points of interest will be fully defined by recipes? When will it be mainstream?


<div style="background-color:#FFFF94;border-left: 18px solid #ffff48;padding-left: 50px;">
<p></p>
<p>These notes are just the main ideas of the talk. They don’t contain anecdotes and examples. If you want to learn more, I would advise watching the talk on the <a target="_blank" href="https://www.gdcvault.com/play/1025215/Procedural-World-Generation-of-Far">GDC Vault</a>.</p>
<p></p>
</div>

## The Toolsmiths
![The Toolsmiths logo]({{ site.baseurl }}assets/images/thetoolsmiths_cover_1000x2881.png){:width="700"}

I took these notes as part of our little "Book Club" for GDC Vault Videos [The Toolsmiths #vault club](http://thetoolsmiths.org/vault_club){:target="_blank"}

Join us on [Slack](http://thetoolsmiths.org/join_slack_team){:target="_blank"}.

Join us on [Twitter](https://twitter.com/thetoolsmiths){:target="_blank"}.

## Links
* [Slides: 	Procedural World Generation of 'Far Cry 5'](https://www.gdcvault.com/play/1025557/Procedural-World-Generation-of-Far){:target="_blank"}

## Related Talks\Videos
* [GDC 2017 'Ghost Recon Wildlands': Terrain Tools and Technology](https://www.gdcvault.com/play/1024029/-Ghost-Recon-Wildlands-Terrain){:target="_blank"} 
* [GDC 2018 Terrain Rendering in 'Far Cry 5'](https://www.gdcvault.com/browse/gdc-18/play/1025261/Terrain-Rendering-in-Far-Cry){:target="_blank"} 
* [GDC 2018 The Asset Build System of 'Far Cry 5'](https://www.gdcvault.com/browse/gdc-18/play/1025264/The-Asset-Build-System-of){:target="_blank"} 
* [GAT #69: River - 2k19 Edition](https://www.youtube.com/watch?v=OklvMqMCkc4&feature=youtu.be){:target="_blank"}


## Credits

Post cover image by <a href="https://pixabay.com/users/Pexels-2286921/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=1852955">Pexels</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=1852955">Pixabay</a>