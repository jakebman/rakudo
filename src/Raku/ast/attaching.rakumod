# Done by any AST node that is the target for being attached to by another node.
# An attaching AST node is one that wants to be somehow attached to a parent
# element, because it has a semantic relationship with it. For example, a
# a (has-scoped) method will want to attach to the immediately enclosing
# package, while a placeholder parameter like $^a will want to attach to the
# nearest scope that can carry a signature. Attachment happens at parse time
# or BEGIN time.
class RakuAST::AttachTarget
  is RakuAST::Node
{
    # Returns a List (possibly empty) of attach target names for this node.
    method attach-target-names() {
        nqp::die('attach-target-names not implemented for ' ~ self.HOW.name(self));
    }

    # Clears any existing attachments, so we don't duplicately attach things.
    method clear-attachments() {
        nqp::die('clear-attachments not implemented for ' ~ self.HOW.name(self));
    }
}
