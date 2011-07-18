require './gem_class'

class GemClass
  def self.sample
    gems_from_output(%x[gem list]).sample
  end
end

describe GemClass do
  before(:each) do
    @uninstalled_gem = GemClass.new("uninstalled_gem")
    @gem_without_deps = GemClass.new("tzinfo")
    @gem_with_deps = GemClass.new("rake")
  end

  describe "#name" do
    it "returns name" do
      @uninstalled_gem.name.should == "uninstalled_gem"
    end
  end

  describe "#installed?" do
    specify { @uninstalled_gem.installed?.should be_false }
    specify { @gem_with_deps.installed?.should be_true }
  end
  
  describe "#dependencies" do
    specify { @uninstalled_gem.dependencies.should be_empty }
    specify { @gem_without_deps.dependencies.should be_empty }
    specify { @gem_with_deps.dependencies.should_not be_empty }
    # specify { p @gem_with_deps.dependencies }
  end
  
  describe "#dependencies_r" do
    specify { @uninstalled_gem.dependencies_r.should be_empty }
    specify { @gem_without_deps.dependencies_r.should be_empty }
    specify { @gem_with_deps.dependencies_r.should_not be_empty }
    # specify { p GemClass.new("rails").dependencies_r }
  end
end
