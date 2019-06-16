require 'set'

module Separatum
  module Importers
    class ActiveRecord
      attr_reader :klass_transitions, :object_transitions

      def initialize(**params)
        @max_depth = params[:max_depth] || 2
        @skip_through = params[:skip_through] || true
        @skip_nil = params[:skip_nil] || true

        @skip_klasses = params[:skip_klasses] || []
        @skip_objects = params[:skip_objects] || []
        @skip_klass_transitions = params[:skip_klass_transitions] || []
        @skip_object_transitions = params[:skip_object_transitions] || []

        @klass_transitions = Set[]
        @object_transitions = Set[]
        @objects = Set[]
      end

      def call(object)
        @objects.add(object)
        act(object)
        @objects.to_a
      end

      def act(object, depth = 1)
        object.class.reflections.each do |association_name, reflection|
          if @skip_through && reflection.is_a?(ActiveRecord::Reflection::ThroughReflection)
            next
          end

          if @skip_nil && object.send(association_name).nil?
            next
          end

          if depth >= @max_depth
            next
          end

          case reflection.macro
          when :belongs_to, :has_one
            new_object = object.send(association_name)
            next if @objects.include?(new_object)
            next if new_object.is_one_of_a?(@skip_klasses)

            next if @object_transitions.include?([new_object, object])
            next if @skip_objects.include?(new_object)
            next if @skip_object_transitions.include?([object, new_object])
            next if @skip_klasses.include?(new_object.class)
            next if @skip_klass_transitions.include?([object.class, new_object.class])

            @objects.add(new_object)
            @klass_transitions.add([object.class, new_object.class])
            @object_transitions.add([object, new_object])
            act(new_object, depth + 1)


          when :has_many
            new_objects = object.send(association_name)
            new_objects.each do |new_object|
              next if @objects.include?(new_object)
              next if new_object.is_one_of_a?(@skip_klasses)

              next if @object_transitions.include?([new_object, object])
              next if @skip_objects.include?(new_object)
              next if @skip_object_transitions.include?([object, new_object])
              next if @skip_klasses.include?(new_object.class)
              next if @skip_klass_transitions.include?([object.class, new_object.class])

              @objects.add(new_object)
              @klass_transitions.add([object.class, new_object.class])
              @object_transitions.add([object, new_object])
              act(new_object, depth + 1)
            end

          else
            fail
          end
        end
      end
    end
  end
end
