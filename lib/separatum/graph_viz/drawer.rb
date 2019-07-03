module Separatum
  module GraphViz
    class Drawer
      def initialize(svg_file_name: nil, dot_file_name: nil)
        @svg_file_name = svg_file_name
        @dot_file_name = dot_file_name
        @gvp = ::Separatum::GraphViz::Proxy.new(::GraphViz.new(:G, type: :digraph))
      end

      def draw(object_transitions)
        object_transitions.each do |prev_object, next_object|
          prev_node = @gvp.add_node(object_title(prev_object))
          next_node = @gvp.add_node(object_title(next_object))
          @gvp.add_edge(prev_node, next_node)
        end

        if @svg_file_name
          @gvp.output(svg: @svg_file_name)
        end

        if @dot_file_name
          @gvp.output(dot: @dot_file_name)
        end

        self
      end

      def object_title(object)
        if object.id.is_a?(String) && object.id.is_uuid?
          "#{object.class}[#{object.id.slice(0, 6)}]"
        else
          "#{object.class}[#{object.id}]"
        end
      end
    end
  end
end
