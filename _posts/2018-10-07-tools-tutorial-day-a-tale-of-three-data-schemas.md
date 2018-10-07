---
layout: post
current: post
cover:  assets/images/posts/blank-composition-desk-gdc18_small.jpg
navigation: True
title: Notes for "A Tale of Three Data Schemas"
date: 2018-10-07 01:00:00
tags: GDC Tools_Tutorial_Day data
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
---

GDC 2018, Tools Tutorial Day, Ludovic Chabant, Senior Software Engineer @ Electronic Arts Vancouver shared the know-how of the Frostbite engine team when it comes to designing the game's data.

<div style="background-color:#FFFF94;border-left: 6px solid #ffff48;">
These are my notes that I wrote down from watching Ludovic's presentation. If you like what you read I hight recommend getting a GDC Vault subscription and watching the full talk <a href="https://www.gdcvault.com/play/1025284/Tools-Tutorial-Day-A-Tale">link to talk</a>.
</div>
<p style="margin-bottom: 1em;"></p>

## Main Takeaway
The same data is used in different ways. Optimizing the data's logical representation for different usage scenarios is key in achieving great performance, efficient use of storage and a sublime user experience. The way that an artist thinks of the data that he or she sees in the editor window might not be the best way to represent the data to load it as fast as possible into the game or might not be the best way to store it on disk. Different data consumption scenarios demand different optimization. Off course maintaining more than one data layout isn't free but it is worth the investment.

![different data schemas to solve different problems](assets/images/posts/tale_of_3_data_schemas/different_data_schemas_different_problems.png)
<div align="center">
<i><small>a picture of a side from Ludovic Chabant's GDC 2018 presentation</small></i>
</div>
<p style="margin-bottom: 1em;"></p>

## Data Schema

**Definition:** a data schema is the formal description of the structures a system is working with.

### Examples of data schemas
* Public properties of script components in Unity
* Decorated public properties of a UClass in Unreal Engine
* [Blind Data](https://knowledge.autodesk.com/support/maya/downloads/caas/CloudHelp/cloudhelp/2018/ENU/Maya-Modeling/files/GUID-6B2E2B87-C990-416F-B772-D0CED101F5E6-htm.html) in Maya
* Table columns in a database management system
* Frostbite DDF (Data Definition Format)

### Basic idea

<p style="margin-bottom: 0;">A data schema is a for communicating about the existence of a <i>type of something</i> which has:</p>
* properties like 
    * ints 
    * floats
    * etc.
* references to other types

### Usage scenarios

<p style="margin-bottom: 0;">A data schema is used to:</p>
* display a type's properties in an editor context.
* store the type on disk.
* load the type at runtime.

## Designing a data schema
![Designing data schemas requires consideration](assets/images/posts/tale_of_3_data_schemas/designing_data_schemas.png)
<div align="center">
<i><small>a picture of a side from Ludovic Chabant's GDC 2018 presentation</small></i>
</div>
<br>
If you design a data schema with a **programmer bias** you will get a data schema that will be great for loading at runtime.

<p style="margin-bottom: 0;">It will be:</p>
* flat and packed
* optimized for loading
* unintelligible for designers and artists

If you design a data schema with a **content creator bias** you will get a data schema that will be great for human understanding and iteration.

<p style="margin-bottom: 0;">It will be:</p>
* easy to use and edit by multiple people
* not cache friendly
* not efficiently laid out in memory

## Three different data schemas
![Not just one data schema](assets/images/posts/tale_of_3_data_schemas/not_just_one_data_schema.png)
<div align="center">
<i><small>a picture of a side from Ludovic Chabant's GDC 2018 presentation</small></i>
</div>
<p style="margin-bottom: 1em;"></p>

### Runtime data schema
<p style="margin-bottom: 0;"><strong>used by</strong></p>
* the game for loading the data into memory
* the programmers in the code

<p style="margin-bottom: 0;"><strong>purpose</strong></p>
* performance
* patching
* loading
* nicely packed in memory

<p style="margin-bottom: 0;"><strong> optimized for</strong></p>
* reading

### Storage data schema
_the tools backend_
**a.k.a disk version**

<div style="background-color:#FFFF94;border-left: 6px solid #ffff48;">
Tools usually use this to save what the user is working on (the logical peace of data).
Not to be confused with a data format like XML, JSON or YAML.
</div>
<p style="margin-bottom: 1em;"></p>
<p style="margin-bottom: 0;"><strong>used by</strong></p>
* tools to save users work on some form of persistent storage

<p style="margin-bottom: 0;"><strong>purpose</strong></p>
* can be versioned and easily merged in revision control
* can be used by tools for automation
* supports multi-user editing (splitting into different parts)
   * for example, the runtime data schema doesn't need this

<p style="margin-bottom: 0;"><strong> optimized for</strong></p>
* writing to disk


### Tool data schema
_the tools frontend_

<div style="background-color:#FFFF94;border-left: 6px solid #ffff48;">
How the content creators see it in their minds. How the game data is displayed in an editor as a graph, property grid or a gizmo.
You can think of this as a subset of UX. Usually, very Object Oriented.
</div>
<p style="margin-bottom: 1em;"></p>
<p style="margin-bottom: 0;"><strong>used by</strong></p>
* content creators for content creation
* engineers for analysis and decision making
* tools developers for creating a great editing experience

<p style="margin-bottom: 0;"><strong>purpose</strong></p>
* better understanding by humans
* better UX
* workflow and iteration oriented

<p style="margin-bottom: 0;"><strong> optimized for</strong></p>
* editing
* iteration


### Frostbite Engine tails

Ludovic brings up 4 tails about how the 3 data schemas are used in the Frostbite Engine.

<p style="margin-bottom: 0;">The main points of the tails:</p>
1. Use a more user-friendly data schema for user editing, but keep an eye out for where you do the conversion from one data schema to another.
2. Use different data schemas to solve different problems, and optimize for different use cases.
3. UX and Data Schemas have a strong relationship. Changing one might affect the other.
4. Use conditional compilation to include tools/storage data schemas in the runtime data schemas. Conditionally include appropriate pipeline code in the runtime to transform data on the fly during live-edit.


### The most important Data Schema
The **Storage Data Schema** is the most important Data Schema.
It is only Data Schema that is persistent.
<div style="background-color:#FFFF94;border-left: 6px solid #ffff48;">
it the most expensive to change, because it is persistent
</div>
<p style="margin-bottom: 1em;"></p>

### Designing Data Schemas
1. Start with designing the Storage Data Schema
2. Build your Tools around the Storage Data Schema
3. Implement your Runtime Code around the Storage Data Schema
    * if it is obvious that the Storage Schema is not performant enough go to the next subsection to find out how to deal with it

#### Dealing with performance issues
<p style="margin-bottom: 0;">If the Runtime Data Schema is not performant enough</p>
1. Adjust the Runtime Data Schema and the code
2. Write the pipeline code to convert from the Storage Schema to the Runtime Schema 

#### Mixing Data Schemas
If your engine does not formally support different types of data schemas, use conditional compilation to have ways to remove the Tools/Storage Data Schemas from the production build. 


### What we have learned

1. There are different ways to organize the same logical data (Tools, Storage, Runtime)
2. Use more user-friendly data organization for the users of your Tools and a more performant way of data organization for your Runtime
3. With this way of organizing data, you can solve different problems without a lot of sacrifices
4. Always remember that a change in a Data Schema can lead to a change in the UX of a tool and vice versa
5. Have a pipeline in place to convert from the Storage Schema to the Runtime Schema


### Personal notes
This reminded me of [Mike Acton's Data-Oriented Design talk](https://youtu.be/rX0ItVEVjHc?t=1394) where every problem in programming is a data transformation problem.


## Mindmap / Mental Representation

<iframe src='https://www.xmind.net/embed/THiC/' width='750px' height='450px' frameborder='0' scrolling='no' allowfullscreen="true"></iframe>
[Click to see it in fullscreen](https://www.xmind.net/m/THiC/)

[Link to mindmap source](https://www.dropbox.com/s/v9o5opk5llrqmvp/Data%20Schemas.xmind?dl=0)

You can open the file with [XMind](https://github.com/xmindltd/xmind)

## The Toolsmiths
![The Toolsmiths logo](http://thetoolsmiths.org/assets/thetoolsmiths_cover_1000x2881.png)
**Ludovic Chabant** is a member of the [Toolsmiths](http://thetoolsmiths.org/) community. The Toolsmiths are a community of Game Tool Developers that are passionate about improving the way people make games.

Join us on [Slack](http://thetoolsmiths.org/join_slack_team).

Join us on [Twitter](https://twitter.com/thetoolsmiths).

## Links
* [Slides: A Tale of Three Data Schemas](https://www.ea.com/frostbite/news/a-tale-of-three-data-schemas)
* [GDC Vault Video: A Tale of Three Data Schemas](https://www.gdcvault.com/play/1025284/Tools-Tutorial-Day-A-Tale)
* [Ludovic Chabant on Twitter](https://twitter.com/ludovicchabant?lang=en)


