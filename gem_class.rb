class GemClass
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def installed?
    return @is_installed if @is_installed != nil
    dependencies
    return @is_installed
  end

  def dependencies
    return @dependencies ||= get_dependencies
  end

  def uninstall
    system("gem uninstall #{name}")
  end

  def dependencies_r
    return @dependencies_r if @dependencies_r
    @@dependencies_traversed = []
    @dependencies_r = get_dependencies_r
    @dependencies_r.delete(name)
    return @dependencies_r
  end

  def uninstall_r
    dependencies_r.each do |d|
      dgem = GemClass.new(d)
      if dgem.installed?
        dgem.uninstall
      else
        p "Not installed: #{dgem.name}"
      end
    end
    uninstall
  end

  def get_dependencies_r
    # Base case:
    if @@dependencies_traversed.include?(name) || dependencies.empty?
      return [name]
    end

    @@dependencies_traversed.push name
    @dependencies_r = dependencies.map do |d|
      [d] + GemClass.new(d).get_dependencies_r
    end.flatten.uniq
  end

  private

  def get_dependencies
    deps_out = %x[gem dependency #{name}]
    # p deps_out.inspect
    if deps_out.start_with? "No"
      @is_installed = false
      return []
    else
      @is_installed = true
      self.class.gem_names_from_output deps_out
    end
  end

  def self.gem_names_from_output(output)
    output.split("\n").map { |line| gem_name_from_line(line) }.compact.uniq
  end

  def self.gem_name_from_line(line)
    line.start_with?("Gem") ? nil : line.split.first
  end

  # class << self
  #   protected :gems_from_output, :gem_name_from_line
  # end
end
