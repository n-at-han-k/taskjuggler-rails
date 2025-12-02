require "action_controller"
require "active_support"

module TaskjugglerRails
  mattr_accessor :config, default: ActiveSupport::OrderedOptions.new.merge(
    tj3_path: Gem.bin_path("taskjuggler", "tj3"),
    tj3_args: {}
  )
end

require "taskjuggler_rails/version"
require "taskjuggler_rails/renderer"
require "taskjuggler_rails/engine"


