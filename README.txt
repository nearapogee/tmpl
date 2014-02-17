= tmpl

* https://github.com/nearapogee/tmpl
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
* Unobtrusive javascript.

There are no know problems. This is currently a pre-release. The following are
anticipated changes:

* The class names starting tmpl-container will become tmpl-ctn.
* The tmpl-remove class will become tmpl-rm (non user facing).
* JS will be refactored, for better naming.
* Support for <label for=""> renaming attributes to match field ids. (Soon!)

== SYNOPSIS:

Annotated deeply nested form example, taken from tmpl-example-app.
(https://github.com/nearapogee/tmpl-example-app) Everything is standard rails,
but it does need some integration with the model layer, so see the example to
if the documentation is not enough. All of the helper methods are documented
in Tmpl::ActionViewExtension.

[1]   - Create a form.
[2]   - Add regular model fields.
[3]   - Define a container that the templates will be appended to. This should
        have a class starting with tmpl-container and this should be unique on
        on the page even though it is a class. More on that further down.
        Sometimes this is optional, but it makes the logic explicit.
[4]   - Build a template in a block. This template is not printed to the
        screen where the template is built. Print it with [6] out of the way.
        The key attribute denotes the "key" of the indexed hash of attributes
        living in the template. It is sometimes optional with shallow nested
        forms (one level), but again it makes the logic explicit.
[5]   - Add a link to append a new template to the container defined in [3].
        Set the body of the link with the first argument or a block, like
        link_to allows. The next argument is the name of the template, matching
        what was passed to tmpl_build. The container option allows you to
        specify a css selector (usually always a class) of container to append
        to. This is not required if link it contained in the container and the
        container has a class name of tmpl-container.
[6]   - Print out the templates, with the name set in tmpl_build.
[7]   - Each template needs to be wrapped in a div with class tmpl.
[8]   - If users need to be able to destroy records add a :_destroy hidden
        and it will be set to true if the template is removed.
[9]   - This is the same as [3], except exhibits an additional feature. Again
        the class name of the container starts with tmpl-container, followed
        with -heading which is the name of the template, followed with a
        -index. Along with [10] and the container option, these indexes will
        be updated when new templates are appended with the add link. This
        allows even deeply nested forms to have their add links out side of
        the container they are appended to. The class naming convention is
        required to use this feature.
[10]  - Another add link, but using the index template name and index feature,
        to link it to the appropriate container, when there are many in a
        deeply nested form. Note that the index comes from standard ruby/rails
        iteration and is not part of this gem.
[11]  - Add a remove link. The link must be contained within the template
        (.tmpl) to be removed.

# app/views/book/_form.html.erb
<%= form_for(@book) do |f| %> [1]
  <div class="field">
    <%= f.label :name %><br>
    <%= f.text_field :name %> [2]
  </div>

  <div class="tmpl-container-chapter"> [3]
    <% f.object.chapters.each.with_index do |chapter, index| %>
      <%= f.fields_for :chapters, chapter do |chapter_fields| %>
        <%= render 'chapter', chapter_fields: chapter_fields, index: index %>
      <% end %>
    <% end %>
  </div>

  <% tmpl_build :chapter, key: 'chapters_attributes' do %> [4]
    <%= f.fields_for :chapters, Chapter.new do |chapter_fields| %>
      <%= render 'chapter', chapter_fields: chapter_fields, index: 0 %>
    <% end %>
  <% end %>

  <%= tmpl_add_link "Add Chapter", :chapter,
      container: '.tmpl-container-chapter' %> [5]

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

<%= tmpl :chapter %> [6]
<%= tmpl :heading %> [6]

# app/views/book/_chapter.html.erb
<div class="tmpl"> [7]
  <div class="field">
    <%= chapter_fields.label :title %><br>
    <%= chapter_fields.text_field :title %> [2]
  </div>
  <%= chapter_fields.hidden_field :_destroy %> [8]

  <div class="tmpl-container-heading-<%= index %>"> [9]
    <%= chapter_fields.fields_for :headings do |heading_fields| %>
      <%= render 'heading', heading_fields: heading_fields %>
    <% end %>
  </div>

  <% tmpl_build :heading, key: 'headings_attributes' do %> [5]
    <%= chapter_fields.fields_for :headings, Heading.new do |heading_fields| %>
      <%= render 'heading', heading_fields: heading_fields %>
    <% end %>
  <% end %>

  <%= tmpl_add_link 'Add Heading', :heading,
      container: ".tmpl-container-heading-#{index}" %> [10]
  <%= tmpl_remove_link 'Remove Chapter' %> [11]
</div>

# app/views/book/_heading.html.erb
<div class="tmpl"> [7]
  <div class="field">
    <%= heading_fields.label :text %><br>
    <%= heading_fields.text_field :text %> [2]
  </div>
  <%= heading_fields.hidden_field :_destroy %> [8]

  <%= tmpl_remove_link 'Remove Heading' %> [11]
</div>

== WHY:

Seems like every app needs something like this. This methodology has been
adapted over countless projects until it was time to be extracted.

== REQUIREMENTS:

* rails
* (jquery needs to be loaded on the page)

== INSTALL:

* Add to Gemfile:
  gem 'tmpl'

* Run:
  bundle

* Add to application.js  manifest:
  //= require tmpl

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
