require_relative '../lib/mandrill_template_renderer'
require 'test/unit'

class TestMandrillTemplateRenderer < Test::Unit::TestCase

  SIMPLE_SUBSTITUTION_TEMPLATE = "AB *|someHashMapKey|* *|otherKey|* CD"
  def test_missing_replacements
    assert_equal("AB *|someHashMapKey|* *|otherKey|* CD",
                 render_result(SIMPLE_SUBSTITUTION_TEMPLATE,
                               {'foo' => 'bar'}))
  end
  def test_multiple_replacements
    assert_equal("AB someHashMapValue otherValue CD",
                 render_result(SIMPLE_SUBSTITUTION_TEMPLATE,
                               {'someHashMapKey' => 'someHashMapValue', 'otherKey' => 'otherValue'}))
  end


  ONE_LEVEL_IF_TEMPLATE = "AA*|IF:firstKey|* show this *|END:IF|*ZZ"
  def test_one_level_if_block_generated
    assert_equal("AA show this ZZ",
                 render_result(ONE_LEVEL_IF_TEMPLATE,
                               {'firstKey' => 'nonNil'}))
  end
  def test_one_level_if_block__not__generated
    assert_equal("AAZZ",
                 render_result(ONE_LEVEL_IF_TEMPLATE,
                               {}))
  end


  MULTI_IF_TEMPLATE = "AA*|IF:firstKey|*  show this and *|IF:secondKey|* show this inner text *|someHashMapKey|* and *|END:IF|* then show outer stuff again *|END:IF|*ZZ"
  def test_multiple_levels_of_if_blocks__show_outer_only
    assert_equal("AA  show this and  then show outer stuff again ZZ",
                 render_result(MULTI_IF_TEMPLATE,
                               {'firstKey' => 'nonNil'}))
  end
  def test_multiple_levels_of_if_blocks__show_both_levels
    assert_equal("AA  show this and  show this inner text *|someHashMapKey|* and  then show outer stuff again ZZ",
                 render_result(MULTI_IF_TEMPLATE,
                               {'firstKey' => 'nonNil',
                                'secondKey' => 'somethingTruthy'}))
  end
  def test_multiple_levels_of_if_blocks__show_both_levels_and_inner_substitution
    assert_equal("AA  show this and  show this inner text someHashMapValue and  then show outer stuff again ZZ",
                 render_result(MULTI_IF_TEMPLATE,
                               {'firstKey' => 'nonNil',
                                'secondKey' => 'somethingTruthy',
                                'someHashMapKey' => 'someHashMapValue'}))
  end
  def test_multiple_levels_of_if_blocks__show_nothing_without_the_first_key
    assert_equal("AAZZ",
                 render_result(MULTI_IF_TEMPLATE,
                               {'secondKey' => 'somethingTruthy',
                                'someHashMapKey' => 'someHashMapValue'}))
  end


  def render_result(template, hash)
    MandrillTemplateRenderer.new(template).to_s(hash)
  end
end
