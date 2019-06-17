---
layout: post
current: post
cover:  assets/images/posts/blank-composition-desk-gdc2019.jpg
navigation: True
title: Notes for "Pipeline Support for Feature Branches in 'Destiny'" GDC2019
date: 2019-05-05 01:00:00
tags: GDC version_control game_data_merging
class: post-template
subclass: 'post'
comments: true
author: vstepano
future: true
published : ture
read_time: 3
---

## TLDW Summary:
How Bungie created an ecosystem of tools and workflows to allow small teams to quickly iterate on changes without worrying about breaking and blocking other teams.

## Keywords
<div class="keyword-container">
<ul class="keyword-container">
<li>Game Data Merging</li>
<li>Version Control System</li>
<li>Branch Integration </li>
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

## Intro
- Each P4 branch is about 4 Tb 
- Up to 350 content creators, designers, and engineers working in one branch
- They use a pre-commit build pipeline - “the Gauntlet”
    - Pete Kugler did a talk at [GDC2016: Developing a pipeline for managing game stability](https://drive.google.com/file/d/1FeZGA-MeuI31Wan9ZVlXmSZ-JrSLgIL2/view?usp=sharing)
        - Pipeline for managing game stability
        - Describes the reason they put the pre-commit system in place
- They pick stability over iteration speed
    - <img src="assets/images/posts/pipeline-support-for-feature-branches/initial-destiny-2-challenges.jpg" alt="slide: initial Destiny 2 challenges" width="700"/>
- Had technical limitations of just simply adding more feature branches 
    - Not supported by tools
    - More pressure on integration
    - More pressure on build pipeline
    - Couldn’t merge game data
- Definition **“Feature Branch”** - Branch created for teams to work in without interfering with the stability of the main branch
- Definition **“Small Team”** -  group of cross-discipline developer working collaboratively on shared features (strike teams? )
- The development team was in an environment that would not allow risky feature prototype and development
    - Long pre-commit build pipeline throughput
    - Thurow QA testing
    - Fear of creating blockers
- Vision
    - <img src="assets/images/posts/pipeline-support-for-feature-branches/auto-integration.jpg" alt="slide: auto-integration" width="400"/>
    - <img src="assets/images/posts/pipeline-support-for-feature-branches/small-team-development-vision.jpg" alt="slide: small team development vision" width="700"/>
    - QA had the option to use stabilization branch to shield from the auto integrations that were happening
- Had 3 main challenges:
    - <img src="assets/images/posts/pipeline-support-for-feature-branches/achieving-the-development-vision.jpg" alt="slide: achieving the development vision" width="700"/>
        - Focused on semantically merge content to make the lives of content creators easier 
        - Focused on making a simple as possible to keep branches in-sync and stable (management tools)
- Developers became accustomed to workflow build around having multiple branches per workspace
    - Because of the release cycles (having multiple features in progress)
    - Expected to have immediate access to things that are mapped in the workspace
- Source [DCC](http://thetoolsmiths.org/codex/glossary/) assets in the same location as the game data
    - This made for build branches 

- Moving to a streamed depot was a risk that the dev team didn’t want to take
    - Compromise by adapting the current system to behave like Streams
    - Had plans to move to Streams for next project

## Scaling the Infrastructure
- Needed to implement Centralized Branch Authority 
    - Which was available as part P4 Stream
    - Used the build farm DB to be the Branch Authority 
- Needed to implement a way to make the branches available on the build farm machines
- Asset pipeline changes
    - For details checkout Brandon Moro's talk: [GDC 2018 Tools Tutorial Day: Bungie’s Asset Pipeline: 'Destiny 2' and Beyond](https://www.gdcvault.com/play/1025430/Tools-Tutorial-Day-Bungie-s) 
    - Need to enable the scaling of the Asset Cache 
        - Used to be one/two machine(s) per branch  
        - Decoupled storage HW from the service HW
        - The service was made stateless 
            - So service could handle different branches
            - The state management was moved into Redis
            - Logging was moved into elasticsearch
- To setup, branch used a lazy copy of that branch
    - The branch was 4 Tb 
    - On the backend use deduplication to not store the same data

## Implementing Content Merging

- Propper game data merging 
    - Needs to know the semantics of the data
    - Used C# for the content merge tool (some screenshots [at min 40](https://www.gdcvault.com/play/1025992/Pipeline-Support-for-Feature-Branches))
        - <img src="assets/images/posts/pipeline-support-for-feature-branches/content-merge-tool.jpg" alt="slide: content merge tool" width="400"/>
    - Tracked auto-resolve\ conflict ratio
    - Used TDD and recorded mergers that produced conflict to analyze 
- [at min 31](https://www.gdcvault.com/play/1025992/Pipeline-Support-for-Feature-Branches) notes on how to implement merging of game data
- Were able to reach 80% auto-conflict resolution rate

## Flow of changes
- Created custom tool “Team Sync” to view of a users branch state
    - <img src="assets/images/posts/pipeline-support-for-feature-branches/team-sync.jpg" alt="slide: Team Sync tool" width="400"/>
    - Shows 
        - Check-ins
        - Bugs
        - Builds in progress/finished
    - For more info see [GDC 2019 Tools Tutorial Day: Tooling for Small Team Workflows](https://www.gdcvault.com/browse/gdc-19/play/1025807)
- Had a special process for automatically integrating into the main branch
    - Via a build farm worker
    - Had a special local conflict resolution workflow (when conflicts happened during an integration)
    - After conflict resolution, automated testing would occur 
        - If something was broken, the team had the ability to login to a remote worker and fix the issue
            - The worker would have all the dev tools ready
- All in all, Pete says that this was a great investment for the dev team

<div style="background-color:#FFFF94;border-left: 18px solid #ffff48;padding-left: 50px;">
<p></p>
<p>These notes are just the main ideas of the talk. They don’t contain anecdotes and examples. If you want to learn more, I would advise watching the talk on the <a href="https://www.gdcvault.com/play/1025969/The-Future-of-Scene-Description">GDC Vault</a>.</p>
<p></p>
</div>

## The Toolsmiths
<img src="http://thetoolsmiths.org/assets/thetoolsmiths_cover_1000x2881.png" alt="The Toolsmiths logo" width="700"/>

I took these notes as part of our little "Book Club" for GDC Vault Videos [The Toolsmiths #vault club](http://thetoolsmiths.org/vault_club)

**Pete Kugler** is a member of the [Toolsmiths](http://thetoolsmiths.org/) community. The Toolsmiths are a community of Game Tool Developers that are passionate about improving the way people make games.

Join us on [Slack](http://thetoolsmiths.org/join_slack_team).

Join us on [Twitter](https://twitter.com/thetoolsmiths).

## Links
* [GDC 2019 Pipeline Support for Feature Branches in 'Destiny'](https://www.gdcvault.com/play/1025992/Pipeline-Support-for-Feature-Branches)

## Related Blog Links
* Notes for [GDC 2019 Bungie's Force Multipliers: Production Engineers]({{site.baseurl}}/gdc2019-bungie-s-force-multipliers-production-engineers)

## Related talks
* 2016 talk by Pete Kugler - [GDC 2016 Developing a pipeline for managing game stability](https://drive.google.com/file/d/1FeZGA-MeuI31Wan9ZVlXmSZ-JrSLgIL2/view?usp=sharing)
* [GDC 2019 Tools Tutorial Day: Tooling for Small Team Workflows](https://www.gdcvault.com/browse/gdc-19/play/1025807)
* [GDC 2018 Tools Tutorial Day: Shipping 'Call of Duty'](https://www.gdcvault.com/play/1025380/Tools-Tutorial-Day-Shipping-Call)
* [GDC 2018 Tools Tutorial Day: Bungie’s Asset Pipeline: 'Destiny 2' and Beyond](https://www.gdcvault.com/play/1025430/Tools-Tutorial-Day-Bungie-s)
* [HandmadeCon 2016 - Asset Systems and Scalability](https://www.youtube.com/watch?v=7KXVox0-7lU)
* [GDC 2019 Bungie's Force Multipliers: Production Engineers](https://www.gdcvault.com/play/1025970/Bungie-s-Force-Multipliers-Production)
* [GDC 2018 Teams Are Stronger Than Heroes: Bungie Development Evolved](https://www.gdcvault.com/browse/gdc-18/play/1025252/Teams-Are-Stronger-Than-Heroes)
* [GDC 2018 Epic Sync: Wrangling the Work of Highly Interdependent Dev Teams at Bungie](https://www.gdcvault.com/browse/gdc-18/play/1025116/Epic-Sync-Wrangling-the-Work)