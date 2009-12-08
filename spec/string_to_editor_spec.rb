require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'tempfile'
require 'string_to_editor'

describe "StringToEditor" do
  before do
    @mock_temp_file = mock('temp file',
                           :path => '/path/to/temp_file',
                           :puts => nil)
    Tempfile.stub!(:open).and_yield @mock_temp_file
  end

  describe "write_to_tmp_file" do
    it "should open a temporary file to write to" do
      Tempfile.should_receive(:open).with('ruby_string')
      "bla".write_to_tmp_file
    end

    it "should write the string to the temporary file" do
      @mock_temp_file.should_receive(:puts).with "pooh"
      "pooh".write_to_tmp_file
    end

    it "should store the path of the temporary file in @path_of_tmp_file_for_string_to_editor" do
      s = "honey"
      s.write_to_tmp_file
      s.instance_variable_get('@path_of_tmp_file_for_string_to_editor').should == '/path/to/temp_file'
    end

    it "should return the path of the temporary file" do
      s = "honey"
      s.write_to_tmp_file.should == '/path/to/temp_file'
    end

    it "should write to a tmp file only once" do
      s = "mash"
      s.write_to_tmp_file
      Tempfile.should_not_receive(:open)
      s.write_to_tmp_file
    end

    it "should return the path of the temporary file if it was already written to a temporary file" do
      s = "honey"
      s.write_to_tmp_file
      s.write_to_tmp_file.should == '/path/to/temp_file'
    end
  end

  describe "view" do
    describe "if no editor command is specified in ENV['EDITOR']" do
      before do
        ENV.delete('EDITOR')
      end

      it "should raise an error" do
        lambda { "breakfast".view }.should raise_error
      end
    end

    describe "if ENV['EDITOR'] contains an editor command" do
      before do
        ENV['EDITOR'] = '/bin/editor/command'
      end

      it "should send a string to the edit command in the background" do
        s = "sausage"
        s.should_receive(:system).with('/bin/editor/command /path/to/temp_file &')
        s.view
      end
    end
  end
end
