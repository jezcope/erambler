---
title: "Bridging Carpentries Slack channels to Matrix"
description: |
  In which I try to save some of the history of The Carpentries
  by bridging Slack to its open source cousin Matrix
slug: bridging-carpentries-slack-channels-to-matrix
date: 2019-11-25T23:03:50+00:00
type: post
tags:
- Open culture
- Technology
- The Carpentries
- Fediverse
- Communication
---


It looks like I've accidentally taken charge
of bridging a bunch of [The Carpentries](https://carpentries.org) Slack channels
over to [Matrix](https://matrix.org).
Given this,
it seems like a good idea
to explain what that sentence means
and reflect a little on my reasoning.
I'm more than happy to discuss the pros and cons of this approach

If you just want to try chatting in Matrix,
jump to [the getting started section](#how-can-i-get-started)

## What are Slack and Matrix?

[Slack][] ([see also on Wikipedia][Slack WP]),
for those not familiar with it,
is an online text chat platform
with the feel of [IRC](http://en.wikipedia.org/wiki/IRC) (Internet Relay Chat),
a modern look and feel
and both web and smartphone interfaces.
By providing a free tier that meets many peoples' needs on its own
Slack has become the communication platform of choice
for thousands of online communities, private projects and more.

One of the major disadvantages of using Slack's free tier,
as many community organisations do,
is that as an incentive to upgrade to a paid service
your chat history is limited to the most recent 10,000 messages
across all channels.
For a busy community like The Carpentries,
this means that messages older than about 6-7 weeks
are already inaccessible,
rendering some of the quieter channels apparently empty.

As Slack is at pains to point out,
that history isn't gone,
just archived and hidden from view
unless you pay the low, low price
of $1/user/month.
That doesn't seem too pricy,
unless you're a non-profit organisation
with a lot of projects you want to fund
and an active membership of several hundred worldwide,
at which point it soon adds up.
Slack does offer to waive the cost for registered non-profit organisations,
but only for one community.
The Carpentries is not an independent organisation,
but one fiscally sponsored by Community Initiatives,
which has already used its free quota of one elsewhere
rendering the Carpentries ineligible.
Other umbrella organisations such as NumFocus
(and, I expect, Mozilla)
also run into this problem with Slack.

So, we have a community which is slowly and inexorably
losing its own history behind a paywall.
For some people this is simply annoying,
but from my perspective as a facilitator of the preservation of digital things
the community is haemhorraging an important record of its early history.

Enter Matrix.

Matrix is a chat platform similar to IRC, Slack or Discord.
It's divided into separate channels,
and users can join one or more of these
to take part in the conversation happening in those channels.
What sets it apart from older technology like IRC
and walled gardens like Slack & Discord
is that it's *federated*.

Federation means simply that users on any server
can communicate with users and channels on any other server.
Usernames and channel addresses specify
both the individual identifier
and the server it calls home,
just as your email address contains all the information needed
for my email server to route messages to it.
While users are currently tied to their home server,
channels can be mirrored and synchronised across multiple servers
making the overall system much more resilient.
Can't connect to your favourite channel on server X?
No problem:
just connect via its alias on server Y
and when X comes back online it will be resynchronised.

The technology used is much more modern and secure
than the aging IRC protocol,
and there's no vender lock-in like there is with
closed platforms like Slack and Discord.
On top of that,
Matrix channels can easily be "bridged" to channels/rooms on other platforms,
including, yes, Slack,
so that you can join on Matrix and transparently talk to people connected to the bridged room,
or vice versa.

So, to summarise:

- The current Carpentries Slack channels could be bridged to Matrix at no cost and with no disruption to existing users
- The history of those channels from that point on would be retained on matrix.org and accessible even when it's no longer available on Slack
- If at some point in the future The Carpentries chose to invest in its own Matrix server, it could adopt and become the main Matrix home of these channels without disruption to users of either Matrix or (if it's still in use at that point) Slack
- Matrix is an open protocol, with a reference server implementation and wide range of clients all available as free software, which aligns with the values of the Carpentries community

On top of this:

- I'm fed up of having so many different Slack teams to switch between to see the channels in all of them, and prefer having all the channels I regularly visit in a single unified interface;
- I wanted to see how easy this would be and whether others would also be interested.

Given all this, I thought I'd go ahead and give it a try
to see if it made things more manageable for me
and to see what the reaction would be from the community.

[Slack]: https://slack.com
[Slack WP]: https://en.wikipedia.org/wiki/Slack_(software

## How can I get started?

!!! reminder
    Please remember that,
    like any other Carpentries space,
    the [Code of Conduct][] applies in all of these channels.

**First**, sign up for a Matrix account.
The quickest way to do this
is on the [Matrix "Try now" page][],
which will take you to the Riot Web client
which for many is synonymous with Matrix.
[Other clients are also available for the adventurous.][other clients]

**Second**, join one of the channels.
The links below will take you to a page
that will let you connect via your preferred client.
You'll need to log in
as they are set not to allow guest access,
but, unlike Slack,
you won't need an invitation to be able to join.

- [#general][] --- the main open channel to discuss all things Carpentries
- [#random][] --- anything that would be considered offtopic elsewhere
- [#welcome][] --- join in and introduce yourself!

That's all there is to getting started with Matrix.
To find all the bridged channels
there's a Matrix "community"
that I've added them all to:
[Carpentries Matrix community][+thecarpentries].

There's a lot more,
including how to bridge your favourite channels from Slack to Matrix,
but this is all I've got time and space for here!
If you want to know more,
leave a comment below,
or send me a message on Slack (jezcope)
or maybe [Matrix (@petrichor:matrix.org)][@petrichor]!
I've also made a separate channel for Matrix-Slack discussions:
[#matrix on Slack](https://app.slack.com/client/T03LE485Y/CR12Z6V2S)
and [Carpentries Matrix Discussion on Matrix](https://matrix.to/#/#carpentries-matrix:matrix.org)

[Code of Conduct]: https://docs.carpentries.org/topic_folders/policies/code-of-conduct.html
[Matrix "Try now" page]: https://matrix.org/try-now/
[other clients]: https://matrix.org/docs/projects/try-matrix-now/
[#general]: https://matrix.to/#/#carpentries-general:matrix.org
[#random]: https://matrix.to/#/#carpentries-random:matrix.org
[#welcome]: https://matrix.to/#/#carpentries-welcome:matrix.org
[+thecarpentries]: https://matrix.to/#/+thecarpentries:matrix.org
[@petrichor]: https://matrix.to/#/@petrichor:matrix.org
