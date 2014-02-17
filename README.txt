= tmpl

* https://github.com/nearapogee/tmpl (url)
* https://github.com/nearapogee/tmpl-example-app

== DESCRIPTION:

An agnostic approach to handle dynamic forms in rails.

== FEATURES/PROBLEMS:

* Simple: Build a template, multiply that template.
* Minimal view duplication.
* Works with deeply nested forms.
* Built minimal and light.
* Low coupling.
* No magic.

== SYNOPSIS:

(abbreviated deeply nested example)

# app/views/book/_form.html.erb
<%= form_for(@book) do |f| %>
  <div class="field">
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </div>

  <% tmpl_build :chapter, key: 'chapters_attributes' do %>
    <%= f.fields_for :chapters, Chapter.new do |chapter_fields| %>
      <%= render 'chapter', chapter_fields: chapter_fields, index: 0 %>
    <% end %>
  <% end %>

  <%= tmpl_add_link "Add Chapter", :chapter, container: '.tmpl-container-chapter' %>

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

<%= tmpl :chapter %>
<%= tmpl :heading %>

# app/views/book/_chapter.html.erb
<div class="tmpl">
  <div class="field">
    <%= chapter_fields.label :title %><br>
    <%= chapter_fields.text_field :title %>
  </div>
  <%= chapter_fields.hidden_field :_destroy %>

  <div class="tmpl-container-heading-<%= index %>">
    <%= chapter_fields.fields_for :headings do |heading_fields| %>
      <%= render 'heading', heading_fields: heading_fields %>
    <% end %>
  </div>

  <% tmpl_build :heading, key: 'headings_attributes' do %>
    <%= chapter_fields.fields_for :headings, Heading.new do |heading_fields| %>
      <%= render 'heading', heading_fields: heading_fields %>
    <% end %>
  <% end %>

  <%= tmpl_add_link 'Add Heading', :heading, container: ".tmpl-container-heading-#{index}" %>
  <%= tmpl_remove_link 'Remove Chapter' %>
</div>

# app/views/book/_heading.html.erb
<div class="tmpl">
  <div class="field">
    <%= heading_fields.label :text %><br>
    <%= heading_fields.text_field :text %>
  </div>
  <%= heading_fields.hidden_field :_destroy %>

  <%= tmpl_remove_link 'Remove Heading' %>
</div>


== REQUIREMENTS:

* rails
* jquery-rails

== INSTALL:

* Add to Gemfile:
  gem 'tmpl'

* Run:
  bundle

* Add to application.js  manifest:
  //= require tmpl

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2014 Matthew C. Smith

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
