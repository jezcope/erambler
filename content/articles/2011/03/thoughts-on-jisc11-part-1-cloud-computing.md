--- 
title: "Thoughts on #JISC11 part 1: Cloud computing"
kind: article
created_at: 2011-03-20 17:12:01 +00:00
categories: 
- Conferences
tags: 
- JISC11
- Cloud computing
- JANET
- E-science
---
*This post is part of a short series in which I share the thoughts prompted by the recent [JISC conference in Liverpool][JISC11].*

The first session I attended at the JISC conference was entitled “[Cloud Solutions: Risk or Reward?][Session 1]” I was particularly looking forward to it as I've become increasingly interested in the affordances of cloud computing for higher education.


[Prof. Paul Watson, Director of the Digital Institute at the University of Newcastle][Watson] was first to speak. I think he has it spot on to go after the 'long tail' of researchers: that large majority with little access to IT skills & resources.

It's too easy to focus on serving the easy few, with the budget to purchase their own computing power and the expertise to make use of it. The remainder of researchers who could make use of shared computing resource to analyse and store their data more effectively have neither the time, the expertise nor the budget to buy big machines for relatively small tasks. It's these users who represent the majority of those who could benefit from cloud computing, if only the tools can be found to let them.


To make this work, using the cloud has to be much more like using apps researchers are familiar with, like Office and EndNote. Newcastle’s e-science central project seems to be taking a good approach: everything works through a web browser and is designed to be as easy as possible.

They’ve even thought about supporting a progression in use, from simply storing data, to analysing it, automating common analysis workflows and finally sharing and reusing those workflows. As well as supporting research, this has big implications for teaching too: the ability to let students experiment with established workflows on real datasets could be a really powerful tool.

As an aside, there was an interesting question from the floor about whether this heralded a return to thin-client computing, with all the loss of freedom that entails. My own view is that cloud computing finally let's us find a happy medium between running everyday apps on the desktop and passing resource-hungry jobs off to dedicated clusters.


Going the other way, [Dr Phil Richards, Director of IT Services at the University of Loughborough][Richards] suggested that the “killer app” for the cloud would be the ability to provide cheap virtual servers, an approach known as Infrastructure-as-a-Service, or IaaS.

This makes sense from the perspective of those supporting the IT needs of researchers, but without the skills to know what to do with a virtual server, I’m not sure the researchers themselves will see immediate benefits. IaaS might make the cloud worthwhile to implement in the first place, but it’ll only make a big difference when it’s easy and cheap for researchers to store and analyse data.


All three speakers naturally made the point about cost reduction. Phil Richards cited HP as an example of a large organisation who have made real savings by rationalising their data centres, going from 85 to just 6 and halving the number of applications running on them to 3,000, and saving $1b per annum in return.

Cloud computing brings the cost benefits of scale to end-users who only need a small proportion of the total resource available. It also transmutes up-front capital expenditure to ongoing operational expenditure for those end-users, making planning much easier at a time of great financial upheaval.


As ever, there are risks attached to new developments. [JANET’s Middleware Group Manager, Henry Hughes][Hughes], gave a good summary of these. Cloud services must be able to comply with legislation (such as the Data Protection Act, with the US Patriot Act muddying the waters). They must handle multi-tenancy securely, without putting sensitive or confidential data at risk. They must provide protection against lock-in, so that applications can be migrated to new services as necessary. Finally, they must be able to guarantee availability of their services. These are all big challenges, but I think we can meet them.


In meeting these challenges, we have a big advantage on our side. One of the biggest costs in HP's data centre project was building a secure, high-performance network, and UK HE already has one in the form of JANET.


I know not everyone will agree with me, but my overall impression is that the rewards of cloud computing for HE vastly outweigh the risks. It’s time for those universities still holding out to stop talking about it and got on with it!


*Thanks to Chris Sexton for her [cloud computing notes](http://cicsdir.blogspot.com/2011/03/clouds-and-clouds-and-feeling-strange.html), which reminded me of a few figures that I’d failed to write down.*


[JISC11]: http://www.jisc.ac.uk/events/2011/03/jisc11.aspx

[Session 1]: http://www.jisc.ac.uk/events/2011/03/jisc11/programme/1cloudsolutions.aspx

[Watson]: http://www.cs.ncl.ac.uk/people/paul.watson

[Richards]: http://www.lboro.ac.uk/admin/vc/emg/director-it.html

[Hughes]: http://websrvr01.ukerna.ac.uk/about/janet/staff/h.hughes.html
