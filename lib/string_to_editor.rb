require 'tempfile'

module OpenStringInEditor
  def write_to_tmp_file
    return @path_of_tmp_file_for_string_to_editor if @path_of_tmp_file_for_string_to_editor
    Tempfile.open('ruby_string') do |tempfile|
      tempfile.puts self
      @path_of_tmp_file_for_string_to_editor = tempfile.path
    end
  end

  def view
    if ENV['EDITOR']
      write_to_tmp_file
      system("#{ENV['EDITOR']} #{@path_of_tmp_file_for_string_to_editor} &")
    else
      raise ":view was called for a String, but the EDITOR variable was not set in ENV"
    end
  end
end

class String
  include OpenStringInEditor
end
