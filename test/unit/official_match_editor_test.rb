require File.dirname(__FILE__) + '/../test_helper'

class OfficialMatchEditorTest < ActiveSupport::TestCase
  def test_is_a_editor
    assert OfficialMatchEditor.is_a_editor?(users(:saki))
    assert !OfficialMatchEditor.is_a_editor?(users(:mike1).id)
  end
end
