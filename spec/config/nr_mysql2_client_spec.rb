RSpec.describe "NRMysql2Client" do
  describe ".parse_table" do
    subject { NRMysql2Client.parse_table(sql) }

    context "SELECT" do
      context "plain" do
        let(:sql) do
          # https://github.com/isucon/isucon10-qualify/blob/7e6b6cfb672cde2c57d7b594d0352dc48ce317df/webapp/ruby/app.rb#L118
          <<~SQL
          SELECT * FROM chair WHERE stock > 0 ORDER BY price ASC, id ASC LIMIT 10
          SQL
        end

        it { should eq "chair" }
      end

      context "with quote" do
        let(:sql) do
          # https://github.com/isucon/isucon9-qualify/blob/34b3e785ebdd97d5c39a1263cbf56d1ae5e3ef91/webapp/ruby/lib/isucari/web.rb#L225
          <<~SQL
          SELECT id FROM `categories` WHERE parent_id = ?
          SQL
        end

        it { should eq "categories" }
      end

      context "with multiline" do
        let(:sql) do
          # https://github.com/isucon/isucon10-qualify/blob/7e6b6cfb672cde2c57d7b594d0352dc48ce317df/webapp/ruby/app.rb#L118
          <<~SQL
          SELECT * FROM
          chair
          WHERE stock > 0 ORDER BY price ASC, id ASC LIMIT 10
          SQL
        end

        it { should eq "chair" }
      end
    end

    context "INSERT" do
      # https://github.com/isucon/isucon10-qualify/blob/7e6b6cfb672cde2c57d7b594d0352dc48ce317df/webapp/ruby/app.rb#L281
      let(:sql) do
        <<~SQL
          INSERT INTO chair(id, name, description, thumbnail, price, height, width, depth, color, features, kind, popularity, stock) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        SQL
      end
      it { should eq "chair" }
    end
  end
end
