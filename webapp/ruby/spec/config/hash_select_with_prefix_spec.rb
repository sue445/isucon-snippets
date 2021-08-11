require "time"

RSpec.describe HashSelectWithPrefix do
  using HashSelectWithPrefix

  describe "#select_with_prefix" do
    subject { source.select_with_prefix(prefix) }

    let(:source) do
      {
        reservation_id: 1,
        reservation_schedule_id: 2,
        reservation_user_id: 3,
        reservation_created_at: Time.parse("2021-08-11 00:11:22"),
        user_id: 4,
        user_email: "sue445@example.com",
        user_nickname: "sue445",
        user_staff: 1,
        user_created_at: Time.parse("2021-08-12 00:11:22"),
      }
    end

    context "with `reservation_`" do
      let(:prefix) { :reservation_ }

      it { should eq({id: 1, schedule_id: 2, user_id: 3, created_at: Time.parse("2021-08-11 00:11:22")}) }
    end

    context "with `user_`" do
      let(:prefix) { :user_ }

      it { should eq({id: 4, email: "sue445@example.com", nickname: "sue445", staff: 1, created_at: Time.parse("2021-08-12 00:11:22")}) }
    end
  end
end
