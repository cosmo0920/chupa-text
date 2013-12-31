# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

class TestFeeder < Test::Unit::TestCase
  def setup
    @feeder = ChupaText::Feeder.new
  end

  sub_test_case("feed") do
    private
    def feed(data)
      texts = []
      @feeder.feed(data) do |extracted_data|
        texts << extracted_data.body
      end
      texts
    end

    sub_test_case("text") do
      def test_text
        data = ChupaText::Data.new
        data.content_type = "text/plain"
        data.body = "Hello"
        assert_equal(["Hello"], feed(data))
      end
    end
  end
end