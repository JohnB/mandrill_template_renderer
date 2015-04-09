require_relative '../lib/mandrill_template_renderer'
require 'test/unit'

class TestMandrillTemplateRenderer < Test::Unit::TestCase
  def test_simple_key_value_replacement
    hash = {'someHashMapKey' => 'someHashMapValue', 'holySmokes' => 'It works'}
    template = "<someHtml> whatever *|someHashMapKey|*  other stuff.. *|holySmokes|* for real"
    result = MandrillTemplateRenderer.new(template).to_s(hash)
    assert_equal("<someHtml> whatever someHashMapValue  other stuff.. It works for real", result)
  end

  def test_one_level_if_block_generated
    hash = {'keyExists' => 'nonNil', 'holySmokes' => 'It works'}
    template = "<someHtml> whatever *|IF:keyExists|*  other stuff.. *|holySmokes|* for *|END:IF|* real"
    result = MandrillTemplateRenderer.new(template).to_s(hash)
    assert_equal("<someHtml> whatever   other stuff.. It works for  real", result)
  end

  def test_one_level_if_block__not__generated
    hash = {}
    template = "<someHtml> whatever *|IF:keyExists|*  other stuff.. *|holySmokes|* for *|END:IF|* real"
    result = MandrillTemplateRenderer.new(template).to_s(hash)
    assert_equal("<someHtml> whatever  real", result)
  end

  def test_multiple_levels_of_if_blocks
    hash = {'keyExists' => 'nonNil', 'holySmokes' => 'It works', 'innerKey' => 'innerValue'}
    template = "<someHtml> whatever *|IF:keyExists|*  other stuff.. *|IF:holySmokes|* INNER *|innerKey|* X *|END:IF|* for *|END:IF|* real"
    result = MandrillTemplateRenderer.new(template).to_s(hash)
    assert_equal("<someHtml> whatever   other stuff..  INNER innerValue X  for  real", result)
  end
end
