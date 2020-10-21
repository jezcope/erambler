---
title: Talks
date: 2020-10-21 14:00:04 UTC+01:00
slug: talks
type: text
data: data/talks.yaml
---

Here is a selection of talks that I've given.

{{% template %}}
<%! import arrow %>
<table>
  <thead>
    <tr>
      <th>Date</th>
      <th>Title</th>
      <th>Location</th>
    </tr>
  </thead>
  % for talk in post.data("talks"):
    <tr>
      <td>
        % if 'date' in talk:
          <% date = arrow.get(talk['date']) %>
          ${date.format('ddd d MMM YYYY')}
        % endif
      </td>
      <td>
        % if 'url' in talk:
          <a href="${talk['url']}">
        % endif
        ${talk['title']}
        % if 'url' in talk:
          </a>
        % endif
      </td>
      <td>
        ${talk.get('location', '')}
      </td>
    </tr>
  % endfor
</table>
{{% /template %}}
