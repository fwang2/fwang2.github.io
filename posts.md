---
layout: default
title: Home
---


<div class="catalogue">
  {% for post in paginator.posts %}
      <div>
        <time datetime="{{ post.date }}" class="catalogue-time">{{ post.date | date: "%B %d, %Y" }}</time>
        <h1 class="catalogue-title">{{ post.title }}</h1>
        <div class="catalogue-line"></div>
        <p>
          {{ post.content }}
        </p>
      </div>
  {% endfor %}
</div>

<div class="pagination">
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path | prepend: site.url }}" class="left arrow">&#8592;</a>
  {% endif %}
  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path | prepend: site.url }}" class="right arrow">&#8594;</a>
  {% endif %}

  <span>{{ paginator.page }}</span>
</div>
