require File.dirname(__FILE__) + '/../test_helper'

class FootballGroundEditorTest < ActiveSupport::TestCase
  def test_is_a_editor
    assert FootballGroundEditor.is_a_editor?(users(:saki))
    assert !FootballGroundEditor.is_a_editor?(users(:mike1).id)
  end
end
