require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
    	path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    	template = File.read(path)
    	new_template = ERB.new(template).result(binding)
    	render_content(new_template, "text/html")
    end
  end
end


