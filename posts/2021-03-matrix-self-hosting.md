---
title: "Matrix self-hosting"
description: "In which I try to decide whether to keep my Matrix server running."
slug: matrix-self-hosting
date: 2021-03-12T21:36:12+00:00
type: post
tags:
- Technology
- Matrix
- Communication
- Self-hosting
- DWeb
---

 
I started running my own Matrix server a little while ago. [Matrix](https://matrix.org) is something rather cool, a chat system similar to IRC or Slack, but open and federated. **Open** in that the standard is available for anyone to view, but also the reference implementations of server and client are open source, along with many other clients and a couple of nascent alternative servers. **Federated** in that, like email, it doesn't matter what server you sign up with, you can talk to users on your own or any other server. 

I decided to host my own for three reasons. Firstly, to see if I could and to learn from it. Secondly, to try and rationalise the Cambrian explosion of Slack teams I was being added to in 2019. Thirdly, to take some control of the loss of access to historical messages in some communities that rely on Slack (especially the [Carpentries](https://carpentries.org) and [RSE](https://society-rse.org/) communities).

Since then, I've also added a fourth goal: taking advantage of various bridges to bring other messaging network I use (such as Signal and Telegram) into a consistent UI. I've also found that my use of Matrix-only rooms has grown as more individuals & communities have adopted the platform.

So, I really like Matrix and I use it daily. My problem now is whether to keep self-hosting. [Synapse](https://matrix.org/docs/projects/server/synapse), the only full server implementation at the moment, is really heavy on memory, so I've ended up running it on a much bigger server than I thought I'd need, which seems overkill for a single-user instance. So now I have to make a decision about whether it's worth keeping going, or shutting it down and going back to matrix.org, or setting up on one of the [other servers that have sprung up in the last couple of years](https://publiclist.anchel.nl/).

There are a couple of other considerations here. Firstly, Synapse resource usage is entirely down to the size of the *rooms* joined by users of the homeowner, not directly the number of users. So if users have mostly overlapping interests, and thus keep to the same rooms, you can support quite a large community without significant extra resource usage.

Secondly, there are a couple of alternative server implementations in development specifically addressing this issue for small servers. [Dendrite](https://github.com/matrix-org/dendrite) and [Conduit](https://conduit.rs/). Neither are quite ready for what I want yet, but are getting close, and when ready that will allow running small homeservers with much more sensible resource usage.

So I could start opening up for other users, and at least justify the size of the server that way. I wouldn't ever want to make it a paid-for service but perhaps people might be willing to make occasional donations towards running costs. That still leaves me with the question of whether I'm comfortable running a service that others may come to rely on, or being responsible for the safety of their information. I could also hold out for Dendrite or Conduit to mature enough that I'm ready to try them, which might not be more than a few months off.

Hmm, seems like I've convinced myself to stick with it for now, and we'll see how it goes. In the meantime, if you know me and you want to try it out let me know and I might risk setting you up with an account!Document Title

