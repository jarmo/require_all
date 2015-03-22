shared_examples_for "#require_all syntactic sugar" do
  before :each do
    @file_list = [
            "#{@base_dir}/module1/a.rb",
            "#{@base_dir}/module2/longer_name.rb",
            "#{@base_dir}/module2/module3/b.rb"
    ]
  end

  it "accepts files with and without extensions" do
    should_not be_loaded("Autoloaded::Module2::LongerName")
    send(@method, @base_dir + '/module2/longer_name').should be_truthy
    should be_loaded("Autoloaded::Module2::LongerName")

    should_not be_loaded("Autoloaded::Module1::A")
    send(@method, @base_dir + '/module1/a.rb').should be_truthy
    should be_loaded("Autoloaded::Module1::A")
  end

  it "accepts lists of files" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    send(@method, @file_list).should be_truthy
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "is totally cool with a splatted list of arguments" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B")
    send(@method, *@file_list).should be_truthy
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B")
  end

  it "will load all .rb files under a directory without a trailing slash" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, @base_dir).should be_truthy
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all .rb files under a directory with a trailing slash" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, "#{@base_dir}/").should be_truthy
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "will load all files specified by a glob" do
    should_not be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                         "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
    send(@method, "#{@base_dir}/**/*.rb").should be_truthy
    should be_loaded("Autoloaded::Module1::A", "Autoloaded::Module2::LongerName",
                     "Autoloaded::Module2::Module3::B", "WrongModule::WithWrongModule")
  end

  it "returns false if an empty input was given" do
    send(@method, []).should be_falsey
    send(@method).should be_falsey
  end

  it "throws LoadError if no file or directory found" do
    lambda {send(@method, "not_found")}.should raise_error(LoadError)
  end
end
