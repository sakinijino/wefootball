require File.dirname(__FILE__) + '/../test_helper'

class OfficalTeamEditorTest < ActiveSupport::TestCase
  def test_is_a_editor
    assert OfficalTeamEditor.is_a_editor?(users(:saki))
    assert !OfficalTeamEditor.is_a_editor?(users(:mike1).id)
  end
end
