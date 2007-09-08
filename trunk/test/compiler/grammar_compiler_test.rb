require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GrammarCompilerTest < Screw::Unit::TestCase
  
  def setup
    @compiler = Compiler::GrammarCompiler.new
    @source_path = File.join(File.dirname(__FILE__), 'test_grammar.treetop')
    @target_path = File.join(File.dirname(__FILE__), 'test_grammar.rb')
    @alternate_target_path = File.join(File.dirname(__FILE__), 'test_grammar_alt.rb')
    delete_target_files
  end
  
  def teardown
    delete_target_files
    Object.class_eval do
      remove_const(:Test) if const_defined?(:Test)
    end
  end
  
  test "compilation of a single file to a default file name" do
    assert !File.exists?(@target_path)
    @compiler.compile(@source_path)
    assert File.exists?(@target_path)
    require @target_path
    Test::GrammarParser.new.parse('foo').should be_success
  end
  
  test "compilation of a single file to an explicit file name" do
    assert !File.exists?(@alternate_target_path)
    @compiler.compile(@source_path, @alternate_target_path)
    assert File.exists?(@alternate_target_path)
    require @alternate_target_path
    Test::GrammarParser.new.parse('foo').should be_success
  end
  
  test "compilation of a single file without writing it to an output file" do
    @compiler.ruby_source(@source_path).should_not be_nil
  end

  test "load_grammar compiles and evaluates source grammar with extension" do    
    load_grammar @source_path
    Test::GrammarParser.new.parse('foo').should be_success
  end

  test "load_grammar compiles and evaluates source grammar with no extension" do
    path_without_extension = @source_path.gsub(/\.treetop\Z/, '')
    load_grammar path_without_extension
    Test::GrammarParser.new.parse('foo').should be_success
  end
  
  
  def delete_target_files
    File.delete(@target_path) if File.exists?(@target_path)
    File.delete(@alternate_target_path) if File.exists?(@alternate_target_path)
  end
  
end

