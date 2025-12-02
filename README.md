# taskjuggler-rails

## Installation
Add this line to your application's Gemfile:

```ruby
gem "taskjuggler-rails"
```

or

```sh
bundle add "taskjuggler-rails"
```

## Example Usage

```ruby
# app/controllers/gantt_controller.rb

class GanttController < ApplicationController
  def show
    @project_name = "My Awesome Project"
    @effort       = 160   # hours
    @developer    = "alice"
  end
end
```

```erb
<%# app/views/gantt/show.html.tjp %>

project demo "<%= @project_name %>" "1.0" 2025-01-01 +3m

resource <%= @developer %> "Alice"

task planning "Planning" {
  effort 40h
  allocate <%= @developer %>
}

task development "Development" {
  effort <%= @effort %>h
  allocate <%= @developer %>
  depends planning
}

taskreport "Gantt" {
  formats html
  headline "Simple Gantt – Generated <%= Time.now.strftime('%Y-%m-%d') %>"
}
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
