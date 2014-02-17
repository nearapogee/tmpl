module Tmpl
  module ActionViewExtension

    # Public: Build and store a template.
    #
    # Builds a template and stores it for later. This allows the template to
    # be built in the context it will be replicated in.
    #
    # Warning:  tmpl_build uses content_for under the hood. content_for is
    #           ignored in in caches.
    #
    # tmpl    - The name of the template, usually singular.
    # options - Options for building the template. (Default: {})
    #           :key  - This is the key for the hash of attributes for the
    #                   template. If using accepts_nested_attributes_for this
    #                   is association_attributes, where association is the
    #                   name of the association. This is only required on
    #                   deeply nested forms, but is always acceptable.
    #           other - All other options are passes on the div containing
    #                   the template. Most likely not needed.
    # block   = The content to be used for the template. You can generate the
    #           content however you like, but partials work great.
    #
    # Example:
    #
    #   <% tmpl_build :chapter, key: 'chapters_attributes' do %>
    #     <%= f.fields_for :chapters, Chapter.new do |chapter_fields| %>
    #       <%= render 'chapter', chapter_fields: chapter_fields %>
    #     <% end %>
    #   <% end %>
    #
    # Returns nil.
    def tmpl_build(tmpl, options={}, &block)
      return if content_for?(:"#{tmpl}_tmpl").present?
      if options.has_key? :key
        options.merge!(:"data-tmpl-key" => options.delete(:key))
      end
      options.merge!(id: "#{tmpl}_tmpl", style: "display: none;")
      content_for :"#{tmpl}_tmpl" do
        content_tag(:div, options) { block.call }
      end
    end

    # Public: Print a template.
    #
    # tmpl - The name of the template, usually singular.
    #
    # Examples:
    #
    #   <%= tmpl :chapter %>
    #
    # Return the template (or nil, if the template was not built).
    def tmpl(tmpl)
      content_for :"#{tmpl}_tmpl"
    end

    # Public: Build a link to add a template.
    #
    # body    - The body of the link.
    # tmpl    - The name of the template, usually singular.
    # options - Options for building the link. (Default: {})
    #           :container - A css selector (jquery) of the container the
    #           replicated template should be added to. This should be a class
    #           name starting with tmpl-container, optionally followed by the
    #           template name (usually singular), optionally followed by -num.
    #           There should only be one of these classes on the page. A class
    #           name was standardized on so that the id could be used for
    #           another purpose.
    #           The following are good examples:
    #             '.tmpl-container' - The default the JS uses, assumed if the
    #               container option is not given.
    #             '.tmpl-container-chapter' - More explicit.
    #             '.tmpl-container-chapter-0' - Useful if you have deeply
    #               nested forms. Allows you to specifically choose which
    #               container the replicated template should be appended to.
    #           other - All other options are passes on the link.
    # block   - Optionally, takes a block which is passed onto link_to.
    #
    # Examples:
    #
    #   <%= tmpl_add_link "Add Chapter", :chapter, container: '.tmpl-container-chapter' %>
    #
    #   <%= tmpl_add_link 'Add Heading', :heading, container: ".tmpl-container-heading-#{index}" %>
    #
    # Returns a link to add a template.
    def tmpl_add_link(*args)
      options = args.extract_options!
      body, tmpl = args[-2], args[-1]
      if options.has_key? :container
        options.merge!(:"data-tmpl-container" => options.delete(:container))
      end
      options[:class] = options[:class].to_s.split(' ').tap { |classes|
        classes << 'tmpl-add'
      }.join(' ')
      options.merge!(:"data-tmpl" => tmpl)
      if block_given?
        link_to("javascript:void(0)", options) { yield }
      else
        link_to( body, "javascript:void(0)", options)
      end
    end

    # Public: Build a link to remove a template.
    #
    # This link must be located inside of the .tmpl to be removed. If there is
    # a hidden destroy field, then it will be set so the record is removed,
    # providing accepts_nested_attributes_for has the allow_destroy option set.
    #
    # body    - The body of the link.
    # options - Passed on to link_to, standard options.
    #           (Default: {})
    #
    # Examples:
    #
    #   <%= tmpl_remove_link 'Remove Chapter' %>
    #
    #   <%= tmpl_remove_link class: 'btn' do %>
    #     <i class="icon-trash"></i> Remove
    #   <% end %>
    #
    # Returns a link
    def tmpl_remove_link(*args)
      options = args.extract_options!
      body = args[-1]
      options[:class] = options[:class].to_s.split(' ').tap { |classes|
        classes << 'tmpl-remove'
      }.join(' ')
      if block_given?
        link_to("javascript:void(0)", options) { yield }
      else
        link_to(body, "javascript:void(0)", options)
      end
    end
  end
end
