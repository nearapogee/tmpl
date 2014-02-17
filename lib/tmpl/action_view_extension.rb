module Tmpl
  module ActionViewExtension

    # Add key option for deeply nested models.
    #
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

    def tmpl(tmpl)
      content_for :"#{tmpl}_tmpl"
    end

    # Add container option if you want the add link outside of the template.
    #
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
