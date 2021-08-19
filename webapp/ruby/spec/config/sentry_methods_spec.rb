RSpec.describe SentryMethods do
  include SentryMethods

  describe "#system_with_sentry" do
    subject { system_with_sentry(command) }

    context "successful" do
      let(:command) { "whoami" }

      it { expect { subject }.not_to raise_error }
    end

    context "failed" do
      let(:command) { "ls ffff" }

      it { expect { subject }.to raise_error("`ls ffff` is failed") }
    end
  end
end
