# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # This cop checks for comparison of something with nil using ==.
      #
      # @example
      #
      #  # bad
      #  if x == nil
      #
      #  # good
      #  if x.nil?
      class NilComparison < Cop
        MSG = 'Prefer the use of the `nil?` predicate.'

        OPS = [:==, :===]

        NIL_NODE = s(:nil)

        def on_send(node)
          _receiver, method, args = *node

          if OPS.include?(method)
            add_offense(node, :selector) if args == NIL_NODE
          end
        end

        private

        def autocorrect(node)
          @corrections << lambda do |corrector|
            expr = node.loc.expression
            new_code = expr.source.sub(/\s*==\s*nil/, '.nil?')
            corrector.replace(expr, new_code)
          end
        end
      end
    end
  end
end
