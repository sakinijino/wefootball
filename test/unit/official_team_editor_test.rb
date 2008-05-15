require File.dirname(__FILE__) + '/../test_helper'

class OfficialTeamEditorTest < ActiveSupport::TestCase
  def test_is_a_editor
    assert OfficialTeamEditor.is_a_editor?(users(:saki))
    assert !OfficialTeamEditor.is_a_editor?(users(:mike1).id)
  end
end
