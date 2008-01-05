require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel.local_variables" do
  it "contains locals as they are added" do
    a = 1
    b = 2
    local_variables.should include("a", "b")
  end

  it "is accessable from bindings" do
    def local_var_foo
      a = 1
      b = 2
      binding      
    end
    foo_binding = local_var_foo()
    res = eval("local_variables",foo_binding)
    res.should include("a", "b")
  end
end
