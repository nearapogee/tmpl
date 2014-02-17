module Tmpl
  class Railtie < ::Rails::Railtie
    initializer 'tmpl.include' do
      ActiveSupport.on_load(:action_view) do
        ::ActionView::Base.send :include, Tmpl::ActionViewExtension
      end
    end
  end
end
