require 'set'

module Separatum
  module Importers
    class ActiveRecord
      attr_reader :klass_transitions, :object_transitions

      def initialize(**params)
        @max_depth = params[:max_depth] || 3
        @edge_classes = params[:edge_classes] || []
        @denied_classes = params[:denied_classes] || []
        @denied_class_transitions = params[:denied_class_transitions] || []

        @svg_file_name = params[:svg_file_name]
        @dot_file_name = params[:dot_file_name]

        @klass_transitions = Set[]
        @object_transitions = Set[]
        @objects = Set[]
        @time_machine = Time.now
      end

      def call(*objects)
        result = []
        objects.flatten.each do |object|
          @objects = Set[object]
          act(object)
          result += @objects.to_a
        end

        if @svg_file_name || @dot_file_name
          if defined? ::GraphViz
            ::Separatum::GraphViz::Drawer.new(svg_file_name: @svg_file_name, dot_file_name: @dot_file_name).draw(@object_transitions)
          else
            fail("GraphViz const is undefined. Use ruby-graphviz gem")
          end
        end

        ::Separatum::Converters::Object2Hash.new(common_fields: { _time_machine: @time_machine }).(result.flatten.uniq)
      end

      def act(object, depth = 1)
        object.class.reflections.each do |association_name, reflection|
          # Skip Through associations
          next if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)

          # Skip empty associations
          next if object.send(association_name).nil?

          # Limit depth
          next if depth >= @max_depth

          case reflection.macro
          when :belongs_to, :has_one
            next_object = object.send(association_name)
            next unless process_link(object, next_object)
            puts "#{depth}#{' ' * depth}[#{reflection.macro}] #{object.class} -> #{next_object.class}"
            act(next_object, depth + 1)

          when :has_many, :has_and_belongs_to_many
            new_objects = object.send(association_name)
            new_objects.each do |next_object|
              next unless process_link(object, next_object)
              puts "#{depth}#{' ' * depth}[#{reflection.macro}] #{object.class} -> #{next_object.class}"
              act(next_object, depth + 1)
            end

          else
            fail("Unknown association `#{reflection.macro.inspect} :#{association_name}' in #{object.class}")
          end
        end
      end

      def process_link(prev_object, next_object)
        # Skip already added object
        return if @objects.include?(next_object)

        # Skip already processed link
        return if @object_transitions.include?([prev_object, next_object])

        # Stuck on edge classes
        return if @edge_classes.include?(prev_object.class)

        # Will not go to denied classes
        return if @denied_classes.include?(next_object.class)

        # Will not go through denied transitions
        return if @denied_class_transitions.include?([prev_object.class, next_object.class])

        @objects.add(next_object)
        @klass_transitions.add([prev_object.class, next_object.class])
        @object_transitions.add([prev_object, next_object])

        true
      end
    end
  end
end
