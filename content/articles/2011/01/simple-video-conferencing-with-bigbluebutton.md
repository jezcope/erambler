--- 
title: Simple video-conferencing with BigBlueButton
kind: article
created_at: 2011-01-24 19:24:50 +00:00
categories: 
- eLearning
tags: 
- Open source
- Video-conferencing
- BigBlueButton
---
Last week, some colleagues and I tried out promising new videoconferencing tool [BigBlueButton][]. I'd previously used it  It's completely open source and based on Adobe Flash so it works in your browser without the need to download any software.

University of Bath colleagues [Nitin][] and [Alex][] have already published their thoughts, so I'll try to avoid duplicating them. I'll also draw comparisons with [Elluminate! Live][], which I've been using quite a bit recently to facilitate a guest lecturer on our course: she lives in Yorkshire and we're trying to reduce the need for her to travel to Bath, especially since our course is all about sustainability!

As someone who supports the IT needs of research staff and students, I can clearly see the value in this type of tool: all the end user needs is a web browser and they're away.

# Positives #

* Uses technology that almost all users have installed already — Elluminate, for example, requires users to download and install Java on platforms that don't ship with it, and there's always one person who didn't read the instructions and complains 10 minutes into a session that they can't connect;
* Seems to cope quite well with lots of people — we had 6+ transmitting sound and video at times;
* Simple, no-nonsense interface — Elluminate has lots and lots and **lots** of features, which can be useful but makes for a very cluttered and confusing interface.

# Negatives #

* There's currently no pre-flight check for users to test their hardware is detected and set up correctly, so there tends to be a lot of testing going on as people connect — ideally this could be done beforehand;
* There are a few minor user interface tweaks which would be useful: for example, it's not clear why you need to enable your microphone to hear audio, and there's no easy way to neatly arrange a large number of video feeds;
* There's apparently an incompatibility between the current Flash plugin for Mac and Google Voice which prevents video from working, but this will apparently be fixed in the next Flash release.

# Other notes #

Importantly for us in the CSCT, there's a rapidly maturing [Sakai interface for BigBlueButton][] which allows users to schedule their own meeting for collaborators in their project sites. It's one of the few Sakai tools being developed in the UK, with Adrian Fish of the University of Lancaster as a major (main?) contributor.

The Sakai interface is also open source, making it much cheaper than the Sakai bridge for Elluminate! Live (the bridge itself is open source, but requires Elluminate to flick a switch at their end to enable the API it uses).

# Summary #

Overall I think that, for fairly technically savvy users, BigBlueButton can and should be used in higher education. Open source projects like this need the oxygen of community, and the only way to smooth off the rough edges is to find them and talk about them.

For everyday use, it might need a little more polish, but probably not much. As long as it avoids the feature bloat which plagues Elluminate! Live, it will soon become a much better option than that product, both on price (usual caveats about open source cost-of-ownership notwithstanding) and on usability[^1].

[^1]: And as a bonus, it lacks the annoying extraneous exclamation mark too.

If you'd like to try it out for yourself, just visit the [BigBlueButton demo server][]: as long as you've got Flash installed, it should just work.

[BigBlueButton]: http://bigbluebutton.org/
[BigBlueButton demo server]: http://demo.bigbluebutton.org/
[Sakai interface for BigBlueButton]: https://confluence.sakaiproject.org/display/BBB/Home
[Elluminate! Live]: http://www.elluminate.com/
[Nitin]: http://colligo.wordpress.com/2011/01/21/focusing-on-bigbluebutton/
[Alex]: http://blogs.bath.ac.uk/al412/2011/01/21/an-assessment-of-bigbluebutton/
