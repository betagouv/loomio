module ApplicationHelper
  def vue_css_includes
    vue_index = File.read(Rails.root.join('public/client/vue/index.html'))
    Nokogiri::HTML(vue_index).css('head link').map {|el| el.attr(:href) }
  end

  def vue_js_includes
    vue_index = File.read(Rails.root.join('public/client/vue/index.html'))
    Nokogiri::HTML(vue_index).css('script').map {|el| el.attr(:src) }
  end

  def metadata
    @metadata ||= if should_have_metadata && current_user.can?(:show, resource)
      "Metadata::#{controller_name.singularize.camelize}Serializer".constantize.new(resource)
    else
      {title: AppConfig.theme[:site_name], image_urls: []}
    end.as_json
  end

  def resource
    instance_variable_get("@#{resource_name}") ||
    instance_variable_set("@#{resource_name}", ModelLocator.new(resource_name, params).locate)
  end

  def resource_name
    controller_name.singularize
  end

  def should_have_metadata
    %w{discussion group poll user}.include? controller_name.singularize.downcase
  end
end