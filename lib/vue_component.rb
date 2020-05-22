class VueComponent < Arbre::Component
  builder_method :root
  def tag_name
    :root
  end

  def initialize(*)
    super
  end

  def build(attributes = {})
    super(process_attributes(attributes))
  end

  def process_attributes(attributes)
    vue_attributes = {}
    attributes.each do |key, value|
      dasherized_key = key.to_s.dasherize
      if value.is_a?(String)
        vue_attributes[dasherized_key] = value
      elsif !dasherized_key.index(':').nil? && dasherized_key.index(':').zero?
        vue_attributes[dasherized_key] = value.to_json
      else
        vue_attributes[":" + dasherized_key] = value.to_json
      end
    end
    vue_attributes
  end
end

def component_creator(auto_build_elements)
  auto_build_elements.each do |element|
    as_string=element.to_s
    camelized_element = as_string.camelize
    Object.const_set(camelized_element,Class.new(VueComponent))
    Object.const_get(camelized_element).class_eval do
      builder_method as_string.to_sym
      def tag_name
        self.class.to_s.underscore
      end
    end
  end
end

