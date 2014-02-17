require "test_helper"

class TestTmpl < ActionView::TestCase
  include Tmpl::ActionViewExtension

  def setup
    @view_flow = ActionView::OutputFlow.new
  end

  def test_tmpl_add_link
    link = tmpl_add_link("Add", :chapter)
    assert_select HTML::Document.new(link.to_s).root,
      'a[class=tmpl-add][data-tmpl=chapter][href="javascript:void(0)"]',
      'Add'
  end

  def test_tmpl_add_link_with_container
    link = tmpl_add_link("Add", :chapter, container: '.tmpl-ctn')
    assert_select HTML::Document.new(link.to_s).root,
      'a[class="tmpl-add"][data-tmpl-container=".tmpl-ctn"]'
  end

  def test_tmpl_add_link_with_class
    link = tmpl_add_link("Add", :chapter, class: 'my-cls')
    assert_select HTML::Document.new(link.to_s).root,
      'a[class="my-cls tmpl-add"]'
  end

  def test_tmpl_remove_link
    link = tmpl_remove_link("Remove")
    assert_select HTML::Document.new(link.to_s).root,
      'a[class=tmpl-remove][href="javascript:void(0)"]',
      'Remove'
  end

  def test_tmpl_remove_link_with_class
    link = tmpl_remove_link("Remove", class: 'my-cls')
    assert_select HTML::Document.new(link.to_s).root,
      'a[class="my-cls tmpl-remove"]'
  end

  def test_tmpl_build
    tmpl_build(:chapter) do
      content_tag(:span, 'Template Content')
    end
    template = tmpl(:chapter)
    assert_select HTML::Document.new(template.to_s).root,
      'div[id=chapter_tmpl][style="display: none;"]' do
      assert_select 'span', 'Template Content'
    end
  end

  def test_tmpl_build_with_key
    tmpl_build(:chapter, key: 'my-key') {}
    template = tmpl(:chapter)
    assert_select HTML::Document.new(template.to_s).root,
      'div[id=chapter_tmpl][data-tmpl-key=my-key]'
  end

end
