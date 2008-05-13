require File.dirname(__FILE__) + '/../test_helper'

class OfficalMatchEditorTest < ActiveSupport::TestCase
  def test_is_a_editor
    assert OfficalMatchEditor.is_a_editor?(users(:saki))
    assert !OfficalMatchEditor.is_a_editor?(users(:mike1).id)
  end
end
