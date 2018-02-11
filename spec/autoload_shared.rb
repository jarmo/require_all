shared_examples_for "#autoload_all syntactic sugar" do
  before :each do
    @file_list = [
            "#{@base_dir}/module1/a.rb",
            "#{@base_dir}/module2/longer_name.rb",
            "#{@base_dir}/module2/module3/b.rb"
    ]
  end

  it "accepts files with and without extensions" do
    is_expected.not_to be_loaded("Autoloaded::Module2::LongerName")
    expect(send(@method, @base_dir + '/module2/longer_name', base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module2::LongerName")

    is_expected.not_to be_loaded("Autoloaded::Module1::A")
    expect(send(@method, @base_dir + '/module1/a.rb', base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A")
  end

  it "accepts lists of files" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, @file_list, base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "is totally cool with a splatted list of arguments" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, *(@file_list << {base_dir: @autoload_base_dir}))).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all .rb files under a directory without a trailing slash" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, @base_dir, base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all .rb files under a directory with a trailing slash" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, "#{@base_dir}/", base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all files specified by a glob" do
    is_expected.not_to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    expect(send(@method, "#{@base_dir}/**/*.rb", base_dir: @autoload_base_dir)).to be_truthy
    is_expected.to be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "returns false if an empty input was given" do
    send(@method, [])
    expect(send(@method, [])).to be_falsey
    expect(send(@method)).to be_falsey
  end

  it "raises LoadError if no file or directory found" do
    expect {send(@method, "not_found")}.to raise_error(LoadError)
  end

  it "can handle empty directories" do
    # Have to make these on the fly because they can't be saved as a test fixture because Git won't track directories with nothing in them.
    FileUtils.mkpath("#{@base_dir}/empty_dir")
    FileUtils.mkpath("#{@base_dir}/nested/empty_dir")
    FileUtils.mkpath("#{@base_dir}/nested/more_nested/empty_dir")

    expect {send(@method, "#{@base_dir}/empty_dir")}.to_not raise_error
    expect {send(@method, "#{@base_dir}/nested")}.to_not raise_error
  end

  it "raises LoadError if :base_dir doesn't exist" do
    expect {send(@method, @base_dir, base_dir: @base_dir + "/non_existing_dir")}.
            to raise_exception(LoadError)
  end
end
