= tmpl

* http://github.com/nearapogee/tmpl (url)

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

  .tmpl-container
    - tmpl_build :collar do
      = f.fields_for :collars do |collar_fields|
        .tmpl
          = collar_fields.text_field :color
          = tmpl_remove_link 'Remove Collar'
          = collar_fields.hidden_field :_destroy

  = tmpl_add_link 'Add Collar', :collar
  = tmpl :collar


== REQUIREMENTS:

* rails

== INSTALL:

* Add to Gemfile: gem 'tmpl'
* bundle
* Add to JS asset manifest: require tmpl

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
