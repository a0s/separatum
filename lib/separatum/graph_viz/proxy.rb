module Separatum
  module GraphViz
    class Proxy
      attr_reader :gv

      def initialize(gv)
        @gv = gv
        @gv[:overlap] = :false
        @nodes = {}
      end

      def add_node(name, *options)
        if @nodes.key?(name)
          @nodes[name]
        else
          @nodes[name] = @gv.add_node(name, *options)
        end
      end

      def add_edge(node1, node2)
        @gv.add_edges(node1, node2)
      end

      # FIXME: change to delegate/forwardable
      def output(*params)
        @gv.output(*params)
      end
    end
  end
end
