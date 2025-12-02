module TaskjugglerRails
  class Engine < ::Rails::Engine
    isolate_namespace TaskjugglerRails

    initializer "taskjuggler_rails.template_handlers" do
      ActionView::Template.register_template_handler :tjp, proc { |template|
        <<~RUBY
          # Create a proper view context with full assigns and helpers
          view = ActionView::Base.with_view_paths(
            ActionController::Base.view_paths,
            assigns.merge(local_assigns),
            controller
          )

          # This gives us: @effort, helpers, params, current_user, etc.
          # No extend needed — with_view_paths already includes helpers

          tjp_source = view.instance_eval do
            ERB.new(#{template.source.inspect}, trim_mode: '-').result(binding)
          end

          TaskjugglerRails::Renderer.render_html(tjp_source)
        RUBY
      }
    end
  end
end
