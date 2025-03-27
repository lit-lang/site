---
layout: default
---

# News

{% if site.posts.size > 0 %}
  <ul class="PostList">
    {% for post in site.posts %}
      <li>
        <article>
          <h2><a class="" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a></h2>
          <p>{% if post.description %}{{ post.description }}{% else %}{{ post.excerpt | strip_html }}{% endif %}</p>
          <span>Published <time class="date" datetime="{{ post.date | date: '%Y-%m-%d' }}">{{ post.date | date: '%B %d, %Y' }}</time></span>
        </article>
      </li>
    {% endfor %}
  </ul>
{% else %}
  <p>No news posts available at the moment. Check back soon!</p>
{% endif %}
