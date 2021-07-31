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

      context "with FOR UPDATE" do
        let(:sql) do
          # https://github.com/isucon/isucon10-qualify/blob/7e6b6cfb672cde2c57d7b594d0352dc48ce317df/webapp/ruby/app.rb#L304
          <<~SQL
            SELECT * FROM chair WHERE id = ? AND stock > 0 FOR UPDATE
          SQL
        end

        it { should eq "chair" }
      end

      context "with sub query" do
        let(:sql) do
          <<~SQL
            SELECT DISTINCT id
             , name, description, thumbnail, address, latitude, longitude, rent, door_height, door_width, features, popularity, popularity_desc
            FROM (
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
              UNION ALL
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
              UNION ALL
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
              UNION ALL
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
              UNION ALL
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
              UNION ALL
              SELECT * FROM estate WHERE (door_width >= ? AND door_height >= ?)
            ) AS estate_all
            ORDER BY popularity_desc ASC, id ASC LIMIT 20
          SQL
        end

        it { should eq "estate" }
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

    context "UPDATE" do
      # https://github.com/isucon/isucon10-qualify/blob/7e6b6cfb672cde2c57d7b594d0352dc48ce317df/webapp/ruby/app.rb#L309
      let(:sql) do
        <<~SQL
          UPDATE chair SET stock = stock - 1 WHERE id = ?
        SQL
      end

      it { should eq "chair" }
    end

    context "other" do
      let(:sql) do
        <<~SQL
          USE isucon
        SQL
      end

      it { should eq "other" }
    end
  end
end
