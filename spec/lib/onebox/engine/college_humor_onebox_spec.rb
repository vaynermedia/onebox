require "spec_helper"

describe Onebox::Engine::CollegeHumorOnebox do
  before(:all) do
    @link = "http://collegehumor.com"
  end

  include_context "engines"
  it_behaves_like "an engine"

  describe "#to_html" do
    it "includes still" do
      expect(html).to include("a9febe641d5beb264bbab0de49272e5a-mitt-romney-style-gangnam-style-parody.jpg")
    end

    it "includes description" do
      expect(html).to include("Heyyy wealthy ladies!&quot;Mitt Romney Style&quot; is now available on iTunes")
    end

    it "includes embedded video link" do
      expect(html).to include("moogaloop.1.0.31.swf?clip_id=6830834&amp;use_node_id=true&amp;og=1&amp;auto=true")
    end
  end
end
